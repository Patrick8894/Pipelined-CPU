module MUX_Reg1(rs1_IDEX, WB_WriteData, MEM_ALUResult, ForwardA, ALUsrc1);

input [31:0] rs1_IDEX;
input [31:0] WB_WriteData;
input [31:0] MEM_ALUResult;
input [1:0]  ForwardA;
output reg [31:0] ALUsrc1;

always @ (rs1_IDEX, WB_WriteData, MEM_ALUResult, ForwardA, ALUsrc1)
begin
	case(ForwardA)
		2'b00: ALUsrc1 = rs1_IDEX;
		2'b01: ALUsrc1 = WB_WriteData;
		2'b10: ALUsrc1 = MEM_ALUResult;
	endcase
end

endmodule