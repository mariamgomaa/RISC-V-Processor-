module ControlUnit(
    input [6:0] op,
    input [2:0] funct3,
    input funct7, op5, Zero, SignFlag,
    output reg RegWrite, ALUSrc, MemWrite, Branch, ResultSrc, PCSrc,
    output reg [1:0] ImmSrc,
    output reg [2:0] ALUControl
);

reg [1:0] ALUOp;

// Main Decoder
always @(*) begin
    case (op)
        7'b0000011: begin // lw
            RegWrite = 1;
            ImmSrc = 2'b00;
            ALUSrc = 1;
            MemWrite = 0;
            ResultSrc = 1;
            Branch = 0;
            ALUOp = 2'b00;
        end
        7'b0100011: begin // sw
            RegWrite = 0;
            ImmSrc = 2'b01;
            ALUSrc = 1;
            MemWrite = 1;
            ResultSrc = 0;
            Branch = 0;
            ALUOp = 2'b00;
        end
        7'b0110011: begin // R-type
            RegWrite = 1;
            ImmSrc = 2'b00;
            ALUSrc = 0;
            MemWrite = 0;
            ResultSrc = 0;
            Branch = 0;
            ALUOp = 2'b10;
        end
        7'b0010011: begin // I-type
            RegWrite = 1;
            ImmSrc = 2'b00;
            ALUSrc = 1;
            MemWrite = 0;
            ResultSrc = 0;
            Branch = 0;
            ALUOp = 2'b10;
        end
        7'b1100011: begin // Branch
            RegWrite = 0;
            ImmSrc = 2'b10;
            ALUSrc = 0;
            MemWrite = 0;
            ResultSrc = 0;
            Branch = 1;
            ALUOp = 2'b01;
        end
        default: begin
            RegWrite = 0;
            ImmSrc = 2'b00;
            ALUSrc = 0;
            MemWrite = 0;
            ResultSrc = 0;
            Branch = 0;
            ALUOp = 2'b00;
        end
    endcase
end

// PCSrc Logic
always @(*) begin
    case (funct3)
        3'b000: PCSrc = Zero & Branch;       // beq
        3'b001: PCSrc = ~Zero & Branch;      // bne
        3'b100: PCSrc = SignFlag & Branch;   // blt
        default: PCSrc = 0;
    endcase
end

// ALU Decoder
always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 3'b000; // add (for lw/sw)
        2'b01: ALUControl = 3'b010; // subtract (for branches)
        2'b10: begin
            case (funct3)
                3'b000: ALUControl = ({op5, funct7} == 2'b11) ? 3'b010 : 3'b000; // sub/add
                3'b001: ALUControl = 3'b001; // sll
                3'b100: ALUControl = 3'b100; // xor
                3'b101: ALUControl = 3'b101; // srl
                3'b110: ALUControl = 3'b110; // or
                3'b111: ALUControl = 3'b111; // and
                default: ALUControl = 3'b000;
            endcase
        end
        default: ALUControl = 3'b000;
    endcase
end

endmodule
