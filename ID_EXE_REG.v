module ID_EX_REG(
    input Clk,
    input Rst,
    input MemWrite,
    input MemRead,
    input RegWrite,
    input MemtoReg,
    input BranchEqual,
    input RegDest,
    input ALUBSrc,
    input [3:0] ALUControl,
    input [31:0] ReadData1,
    input [31:0] ReadData2,
    input [31:0] Instruction_ID,
    input [31:0] Extended15to0Inst,
    input [31:0] PCNow_in,
    input [31:0] PCNext4_in,
    input [4:0] WriteRegAddress_in,
    output reg MemWrite_EX,
    output reg MemRead_EX,
    output reg RegWrite_EX,
    output reg MemtoReg_EX,
    output reg BranchEqual_EX,
    output reg RegDest_EX,
    output reg ALUBSrc_EX,
    output reg [3:0] ALUControl_EX,
    output reg [31:0] ReadData1_EX,
    output reg [31:0] ReadData2_EX,
    output reg [31:0] Instruction_EX,
    output reg [31:0] Extended15to0Inst_EX,
    output reg [31:0] PCNow_out,
    output reg [31:0] PCNext4_out,
    output reg [4:0] WriteRegAddress_out);
	
always@(Rst)
begin
	if (Rst == 1) begin
		MemWrite_EX 			<=  0;
		MemRead_EX 				<=  0;
		RegWrite_EX 			<=  0;
		MemtoReg_EX 			<=  0;
		BranchEqual_EX		<=  0;
		RegDest_EX				<=  0;
		ALUBSrc_EX				<=  0;
		ALUControl_EX			<=  0;
		ReadData1_EX		<=  0;
		ReadData2_EX		<=  0;
		Instruction_EX			<=  0;
		Extended15to0Inst_EX <=  0;
		PCNext4_out <= 0;
		PCNow_out <= 0;
		WriteRegAddress_out <= 0;
	end
end

always@(posedge Clk)
begin
    MemWrite_EX 			<=  MemWrite;
	MemRead_EX 				<=  MemRead;
	RegWrite_EX 			<=  RegWrite;
	MemtoReg_EX 			<=  MemtoReg;
	BranchEqual_EX		<=  BranchEqual;
	RegDest_EX				<=  RegDest;
	ALUBSrc_EX				<=  ALUBSrc;
	ALUControl_EX			<=  ALUControl;
	ReadData1_EX		<=  ReadData1;
	ReadData2_EX		<=  ReadData2;
	Instruction_EX			<=  Instruction_ID;
	Extended15to0Inst_EX <=  Extended15to0Inst;
	PCNext4_out <= PCNext4_in;
	PCNow_out <= PCNow_in;
	WriteRegAddress_out = WriteRegAddress_in;
end
	 	
endmodule

