module Adder(data1, data_o);

input [31:0] data1;
output reg [31:0] data_o;

always @ (data1)
begin
	data_o <= data1 + 4;
end

endmodule