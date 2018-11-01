module EX_MEM_REG(
    input Clk,
    input Rst,
    input MemRead_in,
    input MemWrite_in,
    input [31:0] ReadData1_in,
    input [31:0] ReadData2_in,
    input RegWrite_in,
    input RegDst_in,
    input MemToReg_in,
    input [31:0]ALUResult_in,
    input Zero_in,
    input [31:0] NextInstruct_in,
	input [31:0] Instruction_in,
    input [4:0] WriteRegAddress_in,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg [31:0] ReadData1_out,
    output reg [31:0] ReadData2_out,
    output reg RegWrite_out,
    output reg RegDst_out,
    output reg MemToReg_out,
    output reg [31:0] ALUResult_out,
    output reg  Zero_out,
	output reg [31:0] NextInstruct_out,
    output reg [31:0] Instruction_out,
    output reg [4:0] WriteRegAddress_out);

always@(Rst)
begin
	if (Rst == 1) begin
		MemRead_out <= 0;
		MemWrite_out <= 0;
		ReadData1_out <= 0;
		ReadData2_out <= 0;
		RegWrite_out <= 0;
		RegDst_out <= 0;
		MemToReg_out <= 0;
		ALUResult_out <= 0;
		Zero_out <= 0;
		NextInstruct_out <= 0;
		Instruction_out <= 0;
		WriteRegAddress_out <= 0;
	end
end

always@(posedge Clk)
begin
	MemRead_out <= MemRead_in;
	MemWrite_out <= MemWrite_in;
	ReadData1_out <= ReadData1_in;
	ReadData2_out <= ReadData2_in;
	RegWrite_out <= RegWrite_in;
	RegDst_out <= RegDst_in;
	MemToReg_out <= MemToReg_in;
	ALUResult_out <= ALUResult_in;
	Zero_out <= Zero_in;
	NextInstruct_out <= NextInstruct_in;
	Instruction_out <= Instruction_in;
	WriteRegAddress_out <= WriteRegAddress_in;
end
	


endmodule


