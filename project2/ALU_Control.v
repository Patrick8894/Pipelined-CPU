module ALU_Control(func7, func3, ALUop, ALUCrtl);

input [6:0] func7;
input [2:0] func3;
input [1:0] ALUop;
output reg [2:0] ALUCrtl;
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

always @ (func7 or func3 or ALUop)
begin
	if (func3 == 3'b111) begin //and
		ALUCrtl = 3'b000;
	end
	else if (func3 == 3'b010) begin // lw or sw => do add
		ALUCrtl = 3'b011;
	end
	else if (func3 == 3'b100) begin // xor
		ALUCrtl = 3'b001;
	end
	else if (func3 == 3'b001) begin // sll
		ALUCrtl = 3'b010;
	end
	else if (func3 == 3'b101) begin // srai
		ALUCrtl = 3'b111;
	end
	else if (func3 == 3'b000) begin
		if (ALUop == 2'b10) begin // r-type
			if (func7 == 7'b0000000) begin // add
				ALUCrtl = 3'b011;
			end
			else if (func7 == 7'b0100000) begin // sub
				ALUCrtl = 3'b100;
			end
			else if (func7 == 7'b0000001) begin // mul
				ALUCrtl = 3'b101;
			end
		end
		else begin // i-type addi
			ALUCrtl = 3'b110;
		end
	end
end
endmodule