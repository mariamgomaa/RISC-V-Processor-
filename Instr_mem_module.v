module InstructionMemory (
    input [31:0] A, 
    output [31:0] RD
);

reg [31:0] mem [0:63];

initial begin
    $readmemh("program.txt", mem);
end

assign RD = mem[A[31:2]];

endmodule
