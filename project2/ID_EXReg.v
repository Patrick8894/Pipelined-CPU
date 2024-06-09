module ID_EXReg(clk_i, RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, ALUop_i, ALUsrc_i, rs1_i, rs2_i, imm_i, func7_i, func3_i, ID_rs1_i, ID_rs2_i, rd_i, stall_i, RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUop_o, ALUsrc_o, rs1_o, rs2_o, imm_o, func7_o, func3_o, EX_Rs1, EX_Rs2, rd_o);

input clk_i;
input RegWrite_i;
input MemtoReg_i;
input MemRead_i;
input MemWrite_i;
input [1:0] ALUop_i;
input ALUsrc_i;
input [31:0] rs1_i;
input [31:0] rs2_i;
input [31:0] imm_i;
input [6:0] func7_i;
input [2:0] func3_i;
input [4:0] ID_rs1_i;
input [4:0] ID_rs2_i;
input [4:0] rd_i;
input stall_i;

output reg RegWrite_o;
output reg MemtoReg_o;
output reg MemRead_o;
output reg MemWrite_o;
output reg [1:0] ALUop_o;
output reg ALUsrc_o;
output reg [31:0] rs1_o;
output reg [31:0] rs2_o;
output reg [31:0] imm_o;
output reg [6:0] func7_o;
output reg [2:0] func3_o;
output reg [4:0] EX_Rs1;
output reg [4:0] EX_Rs2;
output reg [4:0] rd_o;

always @ (posedge clk_i)
begin
	if(stall_i == 0) begin
		RegWrite_o <= RegWrite_i;
		MemtoReg_o <= MemtoReg_i;
		MemRead_o <= MemRead_i;
		MemWrite_o <= MemWrite_i;
		ALUop_o <= ALUop_i;
		ALUsrc_o <= ALUsrc_i;
		rs1_o <= rs1_i;
		rs2_o <= rs2_i;
		imm_o <= imm_i;
		func7_o <= func7_i;
		func3_o <= func3_i;
		EX_Rs1 <= ID_rs1_i;
		EX_Rs2 <= ID_rs2_i;
		rd_o <= rd_i;
	end
end

endmodule