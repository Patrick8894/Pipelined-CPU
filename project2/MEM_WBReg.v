module MEM_WBReg(clk_i, RegWrite_i, MemtoReg_i, ALUout_i, Memout_i, rd_i, stall_i, RegWrite_o, MemtoReg_o, ALUout_o, Memout_o, rd_o);

input clk_i;
input RegWrite_i;
input MemtoReg_i;
input [31:0] ALUout_i;
input [31:0] Memout_i;
input [4:0] rd_i;
input stall_i;

output reg RegWrite_o;
output reg MemtoReg_o;
output reg [31:0] ALUout_o;
output reg [31:0] Memout_o;
output reg [4:0] rd_o;

always @ (posedge clk_i)
begin
	if(stall_i == 0) begin
		RegWrite_o <= RegWrite_i;
		MemtoReg_o <= MemtoReg_i;
		ALUout_o <= ALUout_i;
		Memout_o <= Memout_i;
		rd_o <= rd_i;
	end
end

endmodule