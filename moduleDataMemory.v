module single_port_ram 
(
input CLK,WE,
input [31:0] A,
input [31:0] WD,
output [31:0] RD
);
reg [31:0] mem [0:63]; //memory declartion
always @(posedge CLK) begin
if (WE)
    mem[A[31:2]] <= WD;     
end
// Asynchronous read operation
assign RD = mem[A[31:2]];    
endmodule