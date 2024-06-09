module MUX_Reg2(rs2_IDEX, WB_WriteData, MEM_ALUResult, ForwardB, MUX_rs2);

input [31:0] rs2_IDEX;
input [31:0] WB_WriteData;
input [31:0] MEM_ALUResult;
input [1:0]  ForwardB;
output reg [31:0] MUX_rs2;

always @ (rs2_IDEX, WB_WriteData, MEM_ALUResult, ForwardB, MUX_rs2)
begin
	case(ForwardB)
		2'b00: MUX_rs2 = rs2_IDEX;
		2'b01: MUX_rs2 = WB_WriteData;
		2'b10: MUX_rs2 = MEM_ALUResult;
	endcase
end

endmodule