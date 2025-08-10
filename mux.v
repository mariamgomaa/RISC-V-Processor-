module MUX2to1 (
    input [31:0] In1, In2,
    input sel,
    output [31:0] out
);
assign out = sel ? In2 : In1; // In2 = ImmExt, In1 = RD2

endmodule
