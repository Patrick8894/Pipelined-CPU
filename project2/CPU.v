module CPU
(
    clk_i, 
    rst_i,
    start_i,
    mem_data_i,
    mem_ack_i,
    mem_data_o,
    mem_addr_o,
    mem_enable_o,
    mem_write_o,
);

// Ports
input clk_i;
input rst_i;
input start_i;
input [255:0]  mem_data_i; 
input     mem_ack_i;
output [255:0]    mem_data_o; 
output [31:0]    mem_addr_o;     
output    mem_enable_o; 
output    mem_write_o;

wire [31:0] instr;
wire [31:0] instr_IFID;
wire [31:0] instr_addr_out;
wire [31:0] instr_addr_IFID;
wire [31:0] instr_addr_in;

wire [1:0] ALUop;
wire [1:0] ALUop_IDEX;
wire ALUsrc;
wire ALUsrc_IDEX;
wire RegWrite;
wire RegWirte_IDEX;
wire MEM_RegWrite;
wire WB_RegWrite;
wire MemtoReg;
wire MemtoReg_IDEX;
wire MemtoReg_EXMEM;
wire MemtoReg_MEMWB;
wire MemRead;
wire MemRead_IDEX;
wire MemRead_EXMEM;
wire MemWrite;
wire MemWrite_IDEX;
wire MemWrite_EXMEM;
wire branch;
wire Control_branch;

wire [31:0] ALUout;
wire [31:0] MEM_ALUResult;
wire [31:0] ALUout_MEMWB;
wire [31:0] rs1;
wire [31:0] rs1_IDEX;
wire [31:0] rs2;
wire [31:0] rs2_IDEX;
wire [31:0] rs2_EXMEM;
wire signed [31:0] imm;
wire signed [31:0] imm_IDEX;
wire [6:0] func7;
wire [2:0] func3;
wire [4:0] rd_IDEX;
wire [4:0] MEM_Rd;
wire [4:0] WB_Rd;
wire [31:0] addnum;
wire [2:0] ALUCtrl;
wire PCWrite;
wire [31:0] memory_out;
wire [31:0] memory_out_MEMWB;
wire [31:0] WB_WriteData;

wire [31:0] ALUsrc1;
wire [31:0] MUX_rs2;
wire [1:0] ForwardA;
wire [1:0] ForwardB;
wire [4:0] EX_Rs1;
wire [4:0] EX_Rs2;
wire NoOp;
wire [31:0] instr_addr_branch;
wire [31:0] instr_addr_nobranch;

//assign PCWrite = 1; // should delete when handling branch

wire  cpu_stall_o;

// PC=PC+4
Adder Adder(
instr_addr_out,
instr_addr_nobranch
);

MUX_PC MUX_PC(
branch,
instr_addr_branch,
instr_addr_nobranch,
instr_addr_in
);

addr_branch addr_branch(
instr_addr_IFID,
imm,
instr_addr_branch
);

// select instruction address to instr_addr_out
PC PC(
clk_i,
rst_i,
start_i,
cpu_stall_o,
PCWrite,
instr_addr_in,
instr_addr_out
);

// load instruction to instr
Instruction_Memory Instruction_Memory(
.addr_i     (instr_addr_out), 
.instr_o    (instr)
);

// IF/ID
IF_IDReg IF_IDReg(
clk_i, 
instr_addr_out, 
stall, 
branch, 
instr, 
cpu_stall_o,
instr_IFID, 
instr_addr_IFID
);

// output control signals
Control Control(
(instr_IFID[6:0]),
MemtoReg,
MemRead,
MemWrite,
ALUop,
ALUsrc,
RegWrite,
Control_branch,
NoOp
);

// Branch decider
Branch Branch(
Control_branch,
rs1,
rs2,
branch
);

// deal with rs1, rs2 and write to rd 
Registers Registers(
.clk_i      (clk_i),
.RS1addr_i   (instr_IFID[19:15]),
.RS2addr_i   (instr_IFID[24:20]),
.RDaddr_i   (WB_Rd), 
.RDdata_i   (WB_WriteData),
.RegWrite_i (WB_RegWrite), 
.RS1data_o   (rs1), 
.RS2data_o   (rs2) 
);

// immediate sign extend
Imm_Gen Imm_Gen(
instr_IFID[31:20], // for I type
{instr_IFID[31:25],instr_IFID[11:7]}, // for sw and beq
ALUop,
MemWrite,
imm
);

// ID/EX
ID_EXReg ID_EXReg(
// input
clk_i, 
RegWrite, 
MemtoReg, 
MemRead, 
MemWrite, 
ALUop, 
ALUsrc, 
rs1, 
rs2, 
imm,
instr_IFID[31:25],
instr_IFID[14:12],
instr_IFID[19:15],
instr_IFID[24:20],
instr_IFID[11:7],
cpu_stall_o,
// output
RegWrite_IDEX, 
MemtoReg_IDEX, 
MemRead_IDEX, 
MemWrite_IDEX, 
ALUop_IDEX, 
ALUsrc_IDEX,
rs1_IDEX, 
rs2_IDEX,
imm_IDEX,
func7, 
func3,
EX_Rs1,
EX_Rs2,
rd_IDEX
);

// choose rs2 or immediate
MUXALUsrc MUX_ALUSrc(
MUX_rs2,
imm_IDEX,
ALUsrc_IDEX,
addnum
);

// choose which operation we should use
ALU_Control ALU_Control(
func7,
func3, 
ALUop_IDEX,
ALUCtrl
);

// processing the operation
ALU ALU(
ALUsrc1,
addnum,
ALUCtrl,
ALUout
);

// EX/MEM
EX_MEMReg EX_MEMReg(
// input
clk_i, 
RegWrite_IDEX, 
MemtoReg_IDEX,
MemRead_IDEX,
MemWrite_IDEX,
ALUout,
MUX_rs2,
rd_IDEX,
cpu_stall_o,
// output 
MEM_RegWrite,
MemtoReg_EXMEM, 
MemRead_EXMEM,
MemWrite_EXMEM,
MEM_ALUResult,
rs2_EXMEM,
MEM_Rd
);


// MEM/WB
MEM_WBReg MEM_WBReg(
// input
clk_i,
MEM_RegWrite,
MemtoReg_EXMEM,
MEM_ALUResult,
memory_out,
MEM_Rd,
cpu_stall_o,
// output
WB_RegWrite,
MemtoReg_MEMWB,
ALUout_MEMWB,
memory_out_MEMWB,
WB_Rd
);

MUXans MUXans(
ALUout_MEMWB,
memory_out_MEMWB,
MemtoReg_MEMWB,
WB_WriteData
);

MUX_Reg1 MUX_Reg1(
rs1_IDEX, 
WB_WriteData, 
MEM_ALUResult, 
ForwardA, 
ALUsrc1
);

MUX_Reg2 MUX_Reg2(
rs2_IDEX, 
WB_WriteData, 
MEM_ALUResult, 
ForwardB, 
MUX_rs2
);

Forwarding_Unit Forwarding_Unit(
EX_Rs1,
EX_Rs2,
WB_Rd,
WB_RegWrite,
MEM_Rd,
MEM_RegWrite,
ForwardA,
ForwardB
);

Hazard_Detection_Unit Hazard_Detection_Unit(
instr_IFID[19:15],
instr_IFID[24:20],
MemRead_IDEX,
Control_branch,
rd_IDEX,
PCWrite,
stall,
NoOp
);

dcache_controller dcache	
(
    // System clock, reset and stall
    clk_i, 
    rst_i,
    
    // to Data Memory interface        
    mem_data_i, 
    mem_ack_i,     
    mem_data_o, 
    mem_addr_o,     
    mem_enable_o, 
    mem_write_o, 
    
    // to CPU interface    
    rs2_EXMEM, 
    MEM_ALUResult,     
    MemRead_EXMEM,
    MemWrite_EXMEM, 
    memory_out, 
    cpu_stall_o
);
endmodule