module EX_MEMReg(clk_i, RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, ALUout_i, rs2_i, rd_i, stall_i, RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUout_o, rs2_o, rd_o);

input clk_i;
input RegWrite_i;
input MemtoReg_i;
input MemRead_i;
input MemWrite_i;
input [31:0] ALUout_i;
input [31:0] rs2_i;
input [4:0] rd_i;
input stall_i;

output reg RegWrite_o;
output reg MemtoReg_o;
output reg MemRead_o;
output reg MemWrite_o;
output reg [31:0] ALUout_o;
output reg [31:0] rs2_o;
output reg [4:0] rd_o;

always @ (posedge clk_i)
begin
	if(stall_i == 0) begin
		RegWrite_o <= RegWrite_i;
		MemtoReg_o <= MemtoReg_i;
		MemRead_o <= MemRead_i;
		MemWrite_o <= MemWrite_i;
		ALUout_o <= ALUout_i;
		rs2_o <= rs2_i;
		rd_o <= rd_i;
	end
end

endmodule