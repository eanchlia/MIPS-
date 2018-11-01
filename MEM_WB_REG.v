`timescale 1ns / 1ps
module MEM_WB_REG(
    input Clk_40,
    input Reset_40,
    input [31:0] ALUResult_MEM_40,
    input [31:0] Instruction_MEM_40,
    input [31:0] ReadDataFromMem_MEM_40,
    input MemtoReg_MEM_40,  
    input RegWrite_MEM_40,
    input [31:0]  ReadData1_MEM_40,
    input Zero_MEM_40,
    input RegDst_MEM_40,
    input [31:0] NextInstruct_in_40,
    input [4:0] WriteRegAddress_in_40,
    output reg [31:0] ALUResult_WB_40,
    output reg [31:0] Instruction_WB_40,
    output reg [31:0] ReadDataFromMem_WB_40,
    output reg MemtoReg_WB_40,  
    output reg RegWrite_WB_40,
    output reg [31:0] ReadData1_WB_40,
    output reg RegDst_WB_40,
    output reg Zero_WB_40,
    output reg [31:0] NextInstruct_out_40,
    output reg [4:0] WriteRegAddress_out_40);
	
always@(Reset_40)
begin
	if (Reset == 1_40) begin
		ALUResult_WB_40			<=  0;
		Instruction_WB_40		<=  0;
		ReadDataFromMem_WB_40   <=  0;
		MemtoReg_WB_40			<=  0;
		RegWrite_WB_40			<=  0;
		RegDst_WB_40			<=  0;
		Zero_WB_40				<=  0;
		ReadData1_WB_40 		<=  0;
		NextInstruct_out_40     <= 0;
		WriteRegAddress_out_40  <= 0;
	end
end

always@(posedge Clk_40)
begin
	ALUResult_WB_40			 <=  ALUResult_MEM_40;
	Instruction_WB_40		 <=  Instruction_MEM_40;
	ReadDataFromMem_WB_40    <=  ReadDataFromMem_MEM_40;
	MemtoReg_WB_40			 <=  MemtoReg_MEM_40;
	RegWrite_WB_40			 <=  RegWrite_MEM_40;
    RegDst_WB_40			 <=  RegDst_MEM_40;
	Zero_WB_40				 <=  Zero_MEM_40;
	ReadData1_WB_40			 <=  ReadData1_MEM_40;
	NextInstruct_out_40      <= NextInstruct_in_40;
	WriteRegAddress_out_40   <= WriteRegAddress_in_40;
end


