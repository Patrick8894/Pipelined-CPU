module Control(opcode, MemtoReg, MemRead, MemWrite, ALUop, ALUsrc, RegWrite, Branch, NoOp);

input [6:0] opcode;
input NoOp;
output reg [1:0] ALUop;
output reg ALUsrc;
output reg RegWrite;
output reg MemtoReg;
output reg MemRead;
output reg MemWrite;
output reg Branch;

always @ (NoOp)
begin 
	if (NoOp == 1) begin
		ALUop = 2'b0;
		ALUsrc = 0;
		RegWrite = 0;
		MemtoReg = 0;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
	end
end	


always @ (opcode or negedge NoOp)
begin
	if (opcode == 7'b0110011) begin // r-type
		ALUop = 2'b10;
		ALUsrc = 0; // use rd2
		RegWrite = 1;
		MemtoReg = 0;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
	end
	else if (opcode == 7'b0010011)begin // i-type srai or addi
		ALUop = 2'b11;
		ALUsrc = 1; // use imm
		RegWrite = 1;
		MemtoReg = 0;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
	end
	else if (opcode == 7'b0000011)begin // lw
		ALUop = 2'b00;
		ALUsrc = 1; // use imm
		RegWrite = 1;
		MemtoReg = 1;
		MemRead = 1;
		MemWrite = 0;
		Branch = 0;
	end
	else if (opcode == 7'b0100011)begin // sw
		ALUop = 2'b00;
		ALUsrc = 1; // use imm
		RegWrite = 0;
		MemtoReg = 0;
		MemRead = 0;
		MemWrite = 1;
		Branch = 0;
	end
	else if (opcode == 7'b1100011) begin // beq
		ALUop = 2'b01;
		ALUsrc = 1; // use imm
		RegWrite = 0;
		MemtoReg = 0;
		MemRead = 0;
		MemWrite = 0;
		Branch = 1;
	end
	else if (opcode == 7'b0) begin
		ALUop = 2'b0;
		ALUsrc = 0; // use imm
		RegWrite = 0;
		MemtoReg = 0;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
	end
end
endmodule
