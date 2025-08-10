module RISCV_Processor_Top (
    input CLK,
    input areset
);

// Internal signals
wire [31:0] PC;
wire [31:0] Instr;
wire [31:0] RD1, RD2;
wire [31:0] ImmExt;
wire [31:0] SrcA, SrcB;
wire [31:0] ALUResult;
wire [31:0] ReadData;
wire [31:0] Result;

// Control signals
wire RegWrite, ALUSrc, MemWrite, ResultSrc, PCSrc, Branch;
wire [1:0] ImmSrc;
wire [2:0] ALUControl;
wire Zero, SignFlag;

// Program Counter
ProgramCounter pc_unit (
    .ImmExt(ImmExt),
    .CLK(CLK),
    .areset(areset),
    .load(1'b1),  // always enabled, no halt
    .PCSrc(PCSrc),
    .PC(PC)
);

// Instruction Memory
InstructionMemory imem (
    .A(PC),
    .RD(Instr)
);

// Register File
Register_File regfile (
    .CLK(CLK),
    .areset(areset),
    .WE3(RegWrite),
    .A1(Instr[19:15]), // rs1
    .A2(Instr[24:20]), // rs2
    .A3(Instr[11:7]),  // rd
    .WD3(Result),
    .RD1(RD1),
    .RD2(RD2)
);
// Sign Extend
signextend signext (
    .Instr(Instr),
    .ImmSrc(ImmSrc),
    .ImmExt(ImmExt)
);
// ALU Source A
assign SrcA = RD1;
// ALU Source B MUX
MUX2to1 alu_src_mux (
    .In1(RD2),     // 0: register
    .In2(ImmExt),  // 1: immediate
    .sel(ALUSrc),
    .out(SrcB)
);
// ALU
Alu alu (
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUControl(ALUControl),
    .ALUResult(ALUResult),
    .Zero(Zero),
    .Sign(SignFlag)
);
// Data Memory
single_port_ram dmem (
    .CLK(CLK),
    .WE(MemWrite),
    .A(ALUResult),
    .WD(RD2),
    .RD(ReadData)
);
// Result MUX
MUX2to1 result_mux (
    .In1(ALUResult),  // 0: from ALU
    .In2(ReadData),   // 1: from memory
    .sel(ResultSrc),
    .out(Result)
);
// Control Unit
ControlUnit control (
    .op(Instr[6:0]),
    .funct3(Instr[14:12]),
    .funct7(Instr[30]),
    .op5(Instr[5]),
    .Zero(Zero),
    .SignFlag(SignFlag),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .Branch(Branch),      // now connected
    .ResultSrc(ResultSrc),
    .PCSrc(PCSrc),
    .ImmSrc(ImmSrc),
    .ALUControl(ALUControl)
);

endmodule
