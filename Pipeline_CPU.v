/***************************************************
Student Name: 
Student ID: 
***************************************************/

`timescale 1ns/1ps
module Pipeline_CPU(
	input clk_i,
	input rst_i
	);

wire [31:0] pc_o;
wire [31:0] instr;
wire RegWrite;
wire [31:0] RSdata_o;
wire [31:0] RTdata_o;
wire [31:0] ALUresult;
wire MemRead,MemWrite;
wire [31:0] DM_o;

wire ALUSrc;
wire MemtoReg;
wire Branch;
wire [1:0] ALUOp;
wire [1:0] Jump;
wire [31:0] Add_to_pc_Mux0;
wire [31:0] imm;
wire [31:0] sl1;
wire [31:0] mux_to_alu;
wire [3:0] aluctrl;
wire [31:0] Add_to_pc_Mux1;
wire zero;
wire pcsrc;
wire [3:0] instr_to_ALUCtrl;
wire cout;
wire overflow;
wire [31:0] Mux_o;
wire [31:0] pc_i;

// IF/ID
parameter IF_ID_size = 64;
wire [IF_ID_size-1:0] IF_ID_o;

// ID
wire [31:0] ID_pc_o;
wire [31:0] ID_instr;

wire [4:0] IF_ID_regRs1;
wire [4:0] IF_ID_regRs2;
wire [4:0] IF_ID_regRd;

assign ID_pc_o = IF_ID_o[63:32];
assign ID_instr = IF_ID_o[31:0];

assign IF_ID_regRs1 = IF_ID_o[19:15];
assign IF_ID_regRs2 = IF_ID_o[24:20];
assign IF_ID_regRd = IF_ID_o[11:7];

assign instr_to_ALUCtrl = {IF_ID_o[30],IF_ID_o[14:12]};

// ID/EX
parameter ID_EX_size = 155;
wire [ID_EX_size-1:0] ID_EX_o;

// EX
wire [31:0] Add_to_EX_MEM;
wire [31:0] EX_RSdata_o;
wire [31:0] EX_RTdata_o;
wire [31:0] EX_imm;
wire [31:0] EX_pc_o;
wire [4:0] RS1;
wire [4:0] RS2;
wire [4:0] RD;

assign EX_pc_o = ID_EX_o[146:115];
assign EX_RSdata_o = ID_EX_o[114:83];
assign EX_RTdata_o = ID_EX_o[82:51];
assign EX_imm = ID_EX_o[50:19];
assign RS1 = ID_EX_o[14:10];
assign RS2 = ID_EX_o[9:5];
assign RD = ID_EX_o[4:0];

// EX/MEM
parameter EX_MEM_size = 107;
wire [EX_MEM_size-1:0] EX_MEM_o;
wire [31:0] MEM_addr;
wire [31:0] MEM_data;
wire [4:0] EX_MEM_regRd;

assign Add_to_pc_Mux1 = EX_MEM_o[101:70];
assign MEM_addr = EX_MEM_o[68:37];
assign MEM_data = EX_MEM_o[36:5];
assign EX_MEM_regRd = EX_MEM_o[4:0];

assign pcsrc = EX_MEM_o[104] & EX_MEM_o[69];

// MEM/WB
parameter MEM_WB_size = 71;
wire [MEM_WB_size-1:0] MEM_WB_o;
wire [31:0] WB_DM_o;
wire [31:0] WB_ALUresult;
wire [4:0] WB_RD;

assign WB_DM_o = MEM_WB_o[68:37];
assign WB_ALUresult = MEM_WB_o[36:5];
assign WB_RD = MEM_WB_o[4:0];

//ID&EX MUX
wire [31:0] mux_ID_A_o;
wire [31:0] mux_ID_B_o;
wire [1:0] EX_ForwardingA;
wire [1:0] EX_ForwardingB;
wire ID_ForwardingA;
wire ID_ForwardingB;
wire [31:0] Mux3_EX_A_o;
wire [31:0] Mux3_EX_B_o;

MUX_2to1 Mux_PCSrc(
		.data0_i(Add_to_pc_Mux0),       
		.data1_i(Add_to_pc_Mux1),
		.select_i(pcsrc),
		.data_o(pc_i)
		);
		
ProgramCounter PC(
       .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_i(pc_i) ,   
	    .pc_o(pc_o) 
	    );

Adder Adder1(
       .src1_i(pc_o),     
	    .src2_i(4),     
	    .sum_o(Add_to_pc_Mux0)    
	    );
		
Instr_Memory IM(
      .addr_i(pc_o),  
	   .instr_o(instr)    
	   );		

Pipline #(.size(IF_ID_size))IF_ID(
		.clk_i(clk_i),      
	   .rst_i (rst_i),     
	   .data_i({pc_o,instr}) ,   
	   .data_o(IF_ID_o)
		);

Reg_File RF(
      .clk_i(clk_i),      
	   .rst_i(rst_i) ,     
      .RSaddr_i(ID_instr[19:15]) ,  
      .RTaddr_i(ID_instr[24:20]) ,  
      .RDaddr_i(WB_RD) ,  
      .RDdata_i(Mux_o) , 
      .RegWrite_i(MEM_WB_o[MEM_WB_size -1]),
      .RSdata_o(RSdata_o) ,  
      .RTdata_o(RTdata_o)   
      );	

Decoder Decoder(
      .instr_i(ID_instr), 
		.ALUSrc(ALUSrc),
		.MemtoReg(MemtoReg),
	   .RegWrite(RegWrite),
		.MemRead(MemRead),
		.MemWrite(MemWrite),
	   .Branch(Branch),
		.ALUOp(ALUOp),
		.Jump(Jump)
	   );
		
Imm_Gen ImmGen(
		.instr_i(ID_instr[31:0]),
		.Imm_Gen_o(imm)
		);
//
MUX_2to1 Mux_ID_A(
		.data0_i(RSdata_o),       
		.data1_i(Mux_o),
		.select_i(ID_ForwardingA),
		.data_o(mux_ID_A_o)
		);

MUX_2to1 Mux_ID_B(
		.data0_i(RTdata_o),       
		.data1_i(Mux_o),
		.select_i(ID_ForwardingB),
		.data_o(mux_ID_B_o)
		);

Pipline #(.size(ID_EX_size))ID_EX(
		.clk_i(clk_i),      
	   .rst_i (rst_i),     
	   .data_i({RegWrite,MemtoReg,Branch,MemRead,MemWrite,ALUOp,ALUSrc,ID_pc_o,mux_ID_A_o,mux_ID_B_o,imm,instr_to_ALUCtrl,IF_ID_regRs1,IF_ID_regRs2,IF_ID_regRd}) ,   
	   .data_o(ID_EX_o)
		);
		

//
MUX_3to1 Mux_3to1_EX_A(
		.data0_i(EX_RSdata_o),       
		.data1_i(Mux_o),
		.data2_i(MEM_addr),
		.select_i(EX_ForwardingA),
		.data_o(Mux3_EX_A_o)
		);	

MUX_2to1 Mux_ALUSrc(
		.data0_i(EX_RTdata_o),
		.data1_i(EX_imm),
		.select_i(ID_EX_o[147]),
		.data_o(mux_to_alu)
		);
		
//
MUX_3to1 Mux_3to1_EX_B(
		.data0_i(mux_to_alu),       
		.data1_i(Mux_o),
		.data2_i(MEM_addr),
		.select_i(EX_ForwardingB),
		.data_o(Mux3_EX_B_o)
		);

Shift_Left_1 SL1(
		.data_i(EX_imm),
		.data_o(sl1)
		);

Adder Adder2(
       .src1_i(EX_pc_o),     
	    .src2_i(sl1),
	    .sum_o(Add_to_EX_MEM)
	    );
		
alu alu(
		.rst_n(rst_i),
		.src1(Mux3_EX_A_o),
		.src2(Mux3_EX_B_o),
		.ALU_control(aluctrl),
		.zero(zero),
		.result(ALUresult),
		.cout(cout),
		.overflow(overflow)
		);

ALU_Ctrl ALU_Ctrl(
		.instr(ID_EX_o[18:15]),
		.ALUOp(ID_EX_o[149:148]),
		.ALU_Ctrl_o(aluctrl)
		);
		
ForwardingUnit Forwarding(
		.ID_RS1(IF_ID_regRs1),
		.ID_RS2(IF_ID_regRs2),
		.RS1(RS1),
		.RS2(RS2),
		.EX_MEM_regRd(EX_MEM_regRd),
		.MEM_WB_regRd(WB_RD),
		.ID_EX_RegWrite(ID_EX_o[ID_EX_size-1]),
		.EX_MEM_RegWrite(EX_MEM_o[EX_MEM_size-1]),
		.MEM_WB_RegWrite(MEM_WB_o[MEM_WB_size-1]),
		.EX_ForwardingA(EX_ForwardingA),
		.EX_ForwardingB(EX_ForwardingB),
		.ID_ForwardingA(ID_ForwardingA),
		.ID_ForwardingB(ID_ForwardingB)
		);
		
Pipline #(.size(EX_MEM_size))EX_MEM(
		.clk_i(clk_i),      
	   .rst_i (rst_i),     
	   .data_i({ID_EX_o[154:150],Add_to_EX_MEM,zero,ALUresult,Mux3_EX_B_o,RD}) ,   
	   .data_o(EX_MEM_o)
		);
		
Data_Memory Data_Memory(
		.clk_i(clk_i),
		.addr_i(MEM_addr),
		.data_i(MEM_data),
		.MemRead_i(EX_MEM_o[103]),
		.MemWrite_i(EX_MEM_o[102]),
		.data_o(DM_o)
		);
		
Pipline #(.size(MEM_WB_size))MEM_WB(
		.clk_i(clk_i),      
	   .rst_i (rst_i),     
	   .data_i({EX_MEM_o[106:105],DM_o,MEM_addr,EX_MEM_regRd}) ,   
	   .data_o(MEM_WB_o)
		);
		
MUX_2to1 Mux_MemtoReg(
		.data0_i(WB_ALUresult),       
		.data1_i(WB_DM_o),
		.select_i(MEM_WB_o[69]),
		.data_o(Mux_o)
		);
		
endmodule
		  
