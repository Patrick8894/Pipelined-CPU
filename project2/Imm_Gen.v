module Imm_Gen(I_imm, SB_imm, ALUop, MemWrite, data_o);

input [11:0] I_imm;
input [11:0] SB_imm;
input [1:0] ALUop;
input MemWrite;
output reg signed[31:0] data_o;
always @ (I_imm or SB_imm or ALUop or MemWrite)
begin
	if (ALUop == 2'b01) begin // beq
		data_o <= {{20{SB_imm[11]}}, SB_imm[0], SB_imm[10:5],SB_imm[4:1], 1'b0}; // 12, 10:5| 4:1, 11
	end
	else if (ALUop == 2'b00 ) begin
		if (MemWrite == 1) // sw
			data_o <= {{20{SB_imm[11]}},SB_imm[11:0]};
		else//lw
			data_o <= {{20{I_imm[11]}},I_imm[11:0]};
	end
	else begin
		data_o <= {{20{I_imm[11]}},I_imm[11:0]};
	end
end
endmodule
