module MUX_PC(branch , addr_branch , addr_nobranch , addr_out);
input branch;
input [31:0] addr_branch , addr_nobranch;
output [31:0] addr_out;
assign addr_out = branch? addr_branch : addr_nobranch;
endmodule
