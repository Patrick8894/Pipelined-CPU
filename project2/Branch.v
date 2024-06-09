module Branch(control_branch , rd1 , rd2 , branch);
input control_branch;
input [31:0] rd1;
input [31:0] rd2;
output branch;
assign branch =  (control_branch && (rd1 == rd2) );
endmodule
