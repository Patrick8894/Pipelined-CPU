module Forwarding_Unit(EX_Rs1, EX_Rs2, WB_Rd, WB_RegWrite, MEM_Rd, MEM_RegWrite, ForwardA, ForwardB);

input [4:0] EX_Rs1;
input [4:0] EX_Rs2;
input [4:0] WB_Rd;
input WB_RegWrite;
input [4:0] MEM_Rd;
input MEM_RegWrite;
output reg [1:0] ForwardA;
output reg [1:0] ForwardB;
always @ (EX_Rs1, EX_Rs2, WB_Rd, WB_RegWrite, MEM_Rd, MEM_RegWrite)
begin
	ForwardA = 2'b00;
	ForwardB = 2'b00;
	if(MEM_RegWrite
	&& (MEM_Rd != 0)
	&& (MEM_Rd == EX_Rs1)) ForwardA = 2'b10;
	
	if(MEM_RegWrite
	&& (MEM_Rd != 0)
	&& (MEM_Rd == EX_Rs2)) ForwardB = 2'b10;

	if(WB_RegWrite
	&& (WB_Rd != 0)
	&& !(MEM_RegWrite && (MEM_Rd != 0)
	&& (MEM_Rd == EX_Rs1))
	&& (WB_Rd == EX_Rs1)) ForwardA = 2'b01;
	
	if(WB_RegWrite
	&& (WB_Rd != 0)
	&& !(MEM_RegWrite && (MEM_Rd != 0)
	&& (MEM_Rd == EX_Rs2))
	&& (WB_Rd == EX_Rs2)) ForwardB = 2'b01;
end

endmodule