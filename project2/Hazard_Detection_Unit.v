module Hazard_Detection_Unit(rs1,rs2,Memread,branch_control,rd,PCwrite,stall,NoOp);
input [4:0] rs1,rs2,rd;
input Memread , branch_control;
output reg PCwrite , stall , NoOp;

reg prevlw;
reg [4:0] prevlwrd;
initial begin
	prevlw = 0;
	prevlwrd = 5'b0;
end

// Data hazard (lw)
always @ (rs1 or rs2 or rd or Memread) begin
	//Data hazard (lw)
	if (Memread == 1 && (rd == rs1 || rd == rs2) ) begin
		stall = 1;
		NoOp = 1;
		PCwrite = 0;
	end 
	// control hazard
	else if (branch_control == 1)begin 
		if (rd == rs1 || rd == rs2) begin
			stall = 1;
			NoOp = 1;
			PCwrite = 0;
		end
		if (prevlw == 1 && (prevlwrd == rs1 || prevlwrd == rs2 ) ) begin
			stall = 1;
			NoOp = 1;
			PCwrite = 0;
		end
	end
	else begin
		stall = 0;
		NoOp = 0;
		PCwrite = 1;		
	end

	if (Memread == 1) begin
		prevlw = 1;
		prevlwrd = rd;
	end
	else 
		prevlw = 0;
 
end

endmodule
