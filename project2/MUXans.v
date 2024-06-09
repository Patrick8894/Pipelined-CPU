module MUXans(ALUout, memory_out, MemtoReg, ans);

input [31:0] ALUout;
input [31:0] memory_out;
input MemtoReg;
output reg [31:0] ans;

always @ (ALUout, memory_out, MemtoReg)
begin
	if (MemtoReg == 1) begin
		ans <= memory_out;
	end
	else begin
		ans <= ALUout;
	end
end
endmodule