module addr_branch(addr_cur, addr_offset,addr_branch);
input signed[31:0] addr_cur;
input signed [31:0] addr_offset;
output signed[31:0] addr_branch;

assign addr_branch = (addr_cur) + (addr_offset);
endmodule
