module ProgramCounter(
    input [31:0] ImmExt, 
    input CLK, areset, load, PCSrc,
    output reg [31:0] PC
);
wire [31:0] PCNext = (PCSrc) ? (PC + ImmExt) : (PC + 4);

always @(posedge CLK or negedge areset) begin
    if (!areset)
        PC <= 32'b0;
    else if (load)
        PC <= PCNext;
end

endmodule
