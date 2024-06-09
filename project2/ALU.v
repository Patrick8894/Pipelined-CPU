module ALU(rs1, rs2, ALUCrtl, data_o);

input [31:0] rs1;
input [31:0] rs2;
input [2:0] ALUCrtl;
output reg [31:0] data_o;

/*
// and 000
// xor 001
// sll 010
// add 011
// sub 100
// mul 101
// addi 110
// srai 111
*/
reg [4:0] tmp;
always @ (ALUCrtl or rs1 or rs2)
begin
	if (ALUCrtl == 3'b000) begin // and
		data_o = rs1 & rs2;
	end
	else if (ALUCrtl == 3'b001) begin // xor
		data_o = rs1 ^ rs2;
	end
	else if (ALUCrtl == 3'b010) begin // sll
		data_o = rs1 << rs2;
	end
	else if (ALUCrtl == 3'b011) begin // add
		data_o = rs1 + rs2;
	end
	else if (ALUCrtl == 3'b100) begin // sub
		data_o = rs1 - rs2;
	end
	else if (ALUCrtl == 3'b101) begin // mul
		data_o = rs1 * rs2;
	end
	else if (ALUCrtl == 3'b110) begin // addi
		data_o = rs1 + rs2;
	end
	else if (ALUCrtl == 3'b111) begin // srai
		tmp = {rs2[4:0]};
		data_o = rs1 >> tmp;
	end
end

endmodule