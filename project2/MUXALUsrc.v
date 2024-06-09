module MUXALUsrc(rs2, imm, ALUsrc, data_o);

input [31:0] rs2;
input [31:0] imm;
input ALUsrc;
output reg [31:0] data_o;

always @ (rs2 or imm or ALUsrc)
begin
	if (ALUsrc == 1) begin
		data_o <= imm;
	end
	else begin
		data_o <= rs2;
	end
end
endmodule