module IF_IDReg(clk_i, PC, stall, flush, instr, stall2_i, instr_o, PC_o);

input clk_i;
input [31:0] PC; // for branch
input stall; // for brach
input flush; // for branch
input [31:0] instr;
input stall2_i;
output reg [31:0] instr_o;
output reg [31:0] PC_o;


always @ (posedge clk_i)
begin
	if (stall == 0 && stall2_i == 0) begin
		PC_o <= PC;
		instr_o <= instr;
	end
	if (flush == 1) begin
		instr_o <= 32'b0;
	end
end
endmodule
