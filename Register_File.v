module Register_File(
    input CLK, areset, WE3,
    input [4:0] A1, A2, A3,
    input [31:0] WD3,
    output [31:0] RD1, RD2
);

reg [31:0] regs[0:31];
integer i;

always @(posedge CLK or negedge areset) begin
    if (!areset) begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] <= 32'b0;
    end else if (WE3 && A3 != 5'b0) begin
        regs[A3] <= WD3;
    end
end

assign RD1 = (A1 == 5'b0) ? 32'b0 : regs[A1];
assign RD2 = (A2 == 5'b0) ? 32'b0 : regs[A2];

endmodule
