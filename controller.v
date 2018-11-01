`timescale 1ns/1ps
module Controller(
    input Clk,
    input Reset
);
	
wire [31:0] PreInstruction_IF, Instruction_IF, PreInstruction_ID, Instruction_ID, Instruction_EX, Instruction_MEM, Instruction_WB;
wire [31:0] PCNext4_IF, PCNext4_ID, PCNext4_EX, PCNext4_MEM, PCNext4_WB;
wire [31:0] PCNow_IF, PCNow_ID, PCNow_EX;
wire PCNextSel;
wire [31:0] PCTarget, JumpTarget;


wire [31:0] ReadData1, ReadData1_ID, ReadData1_EX, ReadData1_MEM, ReadData1_WB;
wire [31:0] ReadData2, ReadData2_ID, ReadData2_EX, ReadData2_MEM;
wire [31:0] ReadData1Final, ReadData2Final;
wire ReadData1Sel_ID, ReadData2Sel_ID;
wire [1:0] ReadData1Sel_EX, ReadData2Sel_EX;
reg RegWrite;
wire RegWrite_EX, RegWrite_MEM, RegWrite_WB;
wire RegWriteFinal_MEM, RegWriteFinal_WB;
wire [31:0] WriteDataToReg;
wire [4:0] ReadRegister1, ReadRegister2;
wire [31:0] Extended15to0Inst, Extended15to0Inst_EX;
wire RegWriteSel_EX, RegWriteSel_MEM, RegWriteSel_WB;


wire [4:0] WriteRegAddress, WriteRegAddress_EX, WriteRegAddress_MEM, WriteRegAddress_WB;
reg [3:0] ALUControl;
wire [3:0] ALUControl_EX;
wire [31:0] ALUResult_EX, ALUResult_MEM, ALUResult_WB;
wire [31:0] ALUSrcInA, ALUSrcInB;
reg ALUBSrc;
wire ALUBSrc_EX;
wire Zero_EX, Zero_MEM;
reg BranchEqual;
wire BranchEqual_EX;
wire [31:0] BranchTargetFinal;
wire BranchFinal;

reg MemtoReg;
wire MemtoReg_EX, MemtoReg_MEM, MemtoReg_WB;
reg MemWrite;
wire MemWrite_EX, MemWrite_MEM;
reg MemRead;
wire MemRead_EX, MemRead_MEM;
reg JumpSel, Jump, JumpFlush;
wire [31:0] RegData_MEM;
wire [31:0] ReadDataFromMem, ReadDataFromMem_WB;

reg RegDst;
wire RegDst_EX, RegDst_MEM, RegDst_WB;
wire IF_ID_Reset, ID_EX_Reset, EX_MEM_Reset, MEM_WB_Reset;
wire InstructionSel_IF, InstructionSel_ID, PCWrite, IF_ID_Write, Stall;

InstructionFetchUnit IF (
    .Instruction (PreInstruction_IF),
    .PCNext4 (PCNext4_IF),
    .PCNow (PCNow_IF),
    .Clk (Clk),
    .Reset (Reset),
    .Jump (PCNextSel),
    .PCWrite (PCWrite),
    .NewPC (PCTarget)
);

RegisterFile RF (
    .ReadData1 (ReadData1),
    .ReadData2 (ReadData2),
	.ReadRegister1 (ReadRegister1),
	.ReadRegister2 (ReadRegister2),
	.WriteRegister (WriteRegAddress_WB),
	.RegWrite (RegWriteFinal_WB),
    .Clk (Clk)
);

ALU32Bit ALU (
    .ALUResult (ALUResult_EX),
    .Zero (Zero_EX),
    .A (ALUSrcInA),
    .B (ALUSrcInB),
    .ALUControl (ALUControl_EX)
);

DataMemory DataMem (
    .ReadData (ReadDataFromMem),
    .Address (ALUResult_MEM),
    .WriteData (ReadData2_MEM),
    .MemRead (MemRead_MEM),
    .MemWrite (MemWrite_MEM),
    .Clk (Clk)
);

sign_extension InstExtend (
    .out (Extended15to0Inst),
    .in (Instruction_ID [15:0])
);

mux_2to1_32bit RegDataMux(WriteDataToReg, ALUResult_WB, ReadDataFromMem_WB, MemtoReg_WB);

mux_2to1_5bit WriteRegAddressMux(WriteRegAddress, Instruction_ID[20:16], Instruction_ID[15:11], RegDst);

mux_2to1_32bit ALUBInputMux (ALUSrcInB, ReadData2, Extended15to0Inst, ALUBSrc_EX);

mux_2to1_32bit PCTargetMux(PCTarget, JumpTarget, BranchTargetFinal, BranchFinal);
mux_2to1_32bit jumpsel(JumpTarget, {PCNow_ID[31:26],(Instruction_ID[25:0]<<2)}, ReadData1, JumpSel);
BranchPredictor BP (BranchTargetFinal, PCNext4_EX, Extended15to0Inst_EX);

ForwardingControl forward(Instruction_ID[25:21], Instruction_ID[20:16], Instruction_EX[25:21], Instruction_EX[20:16], RegWriteFinal_MEM, WriteRegAddress_MEM, RegWriteFinal_WB, WriteRegAddress_WB, ReadData1Sel_ID, ReadData2Sel_ID, ReadData1Sel_EX, ReadData2Sel_EX);
mux_2to1_32bit ReadData1SelMux_ID (ReadData1_ID, ReadData1, WriteDataToReg, ReadData1Sel_ID);
mux_2to1_32bit ReadData2SelMux_ID (ReadData2_ID, ReadData2, WriteDataToReg, ReadData2Sel_ID);
mux_4to1_32bit ReadData1SelMux_EX (ReadData1Final, ReadData1_EX, RegData_MEM, WriteDataToReg, 32'b0, ReadData1Sel_EX);
mux_4to1_32bit ReadData2SelMux_EX (ReadData2Final, ReadData2_EX, RegData_MEM, WriteDataToReg, 32'b0, ReadData2Sel_EX);
mux_4to1_32bit RegDataMux_MEM (RegData_MEM, ALUResult_MEM, ReadDataFromMem, PCNext4_MEM, ReadData1_MEM, MemtoReg_MEM);
mux_2to1_1bit RegWriteMux_MEM (RegWriteFinal_MEM, RegWrite_MEM, Zero_MEM, RegWriteSel_MEM);

//Data Hazard
HazardDetector hazardDetector(MemRead_EX, PreInstruction_ID[25:21], PreInstruction_ID[20:16], Instruction_EX[20:16], Stall, Reset);
mux_2to1_32bit InstructionMux_IF(Instruction_IF, PreInstruction_IF, 32'b0, InstructionSel_IF);

mux_2to1_32bit InstructionMux_ID(Instruction_ID, PreInstruction_ID, 32'b0, InstructionSel_ID);

//PipeLining

IF_ID_REG if_id_reg(
    Clk, IF_ID_Reset, IF_ID_Write, Instruction_IF, PCNow_IF, PCNext4_IF, PreInstruction_ID, PCNow_ID, PCNext4_ID);

ID_EX_REG  id_ex_reg (Clk, ID_EX_Reset, MemWrite, MemRead, RegWrite, MemtoReg, BranchEqual, RegDst, ALUBSrc, ALUControl, ReadData1_ID, ReadData2_ID, Instruction_ID, Extended15to0Inst, PCNow_ID, PCNext4_ID,WriteRegAddress, MemWrite_EX, MemRead_EX,RegWrite_EX, MemtoReg_EX, BranchEqual_EX, RegDst_EX, ALUBSrc_EX, ALUControl_EX, ReadData1_EX, ReadData2_EX,	Instruction_EX, Extended15to0Inst_EX, PCNow_EX, PCNext4_EX, WriteRegAddress_EX);

EX_MEM_REG ex_mem_reg (Clk, EX_MEM_Reset, MemRead_EX, MemWrite_EX, ReadData1_EX, ReadData2_EX, RegWrite_EX, RegDst_EX, MemtoReg_EX, ALUResult_EX, Zero_EX, PCNext4_EX, Instruction_EX, WriteRegAddress_EX, MemRead_MEM, MemWrite_MEM, ReadData1_MEM, ReadData2_MEM, RegWrite_MEM, RegDst_MEM, MemtoReg_MEM, ALUResult_MEM, Zero_MEM, PCNext4_MEM, Instruction_MEM, WriteRegAddress_MEM);

MEM_WB_REG mem_wb_reg(Clk, MEM_WB_Reset, ALUResult_MEM, Instruction_MEM, ReadDataFromMem, MemtoReg_MEM, RegWrite_MEM, ReadData1_MEM, Zero_MEM, RegDst_MEM, PCNext4_MEM, WriteRegAddress_MEM, ALUResult_WB, Instruction_WB, ReadDataFromMem_WB, MemtoReg_WB, RegWrite_WB, ReadData1_WB, RegDst_WB, Zero_WB, PCNext4_WB, WriteRegAddress_WB);					


assign ReadRegister1 = Instruction_ID[25:21];// rs
assign ReadRegister2 = Instruction_ID[20:16];// rt
assign BranchFinal = BranchEqual_EX & Zero_EX;
assign IF_ID_Reset = Reset;
assign ID_EX_Reset = Reset;
assign EX_MEM_Reset = Reset;
assign MEM_WB_Reset = Reset;
assign PCNextSel = Jump;
assign InstructionSel_IF = JumpFlush;
assign InstructionSel_ID = Stall;
assign PCWrite = ~Stall;
assign IF_ID_Write = ~Stall;
assign ReadData1_ID = ReadData1;
assign ReadData2_ID = ReadData2;

always @(Reset)
begin
    Jump <= 0;
	JumpSel <= 0;
    JumpFlush <= 0;
    MemRead <= 0;
    MemtoReg <= 0;
    MemWrite <= 0;
    ALUControl <= 0;
    ALUBSrc <= 0;
    BranchEqual <= 0;
    RegWrite <= 0;
    RegDst <= 0;
end
 
always @(Instruction_ID) begin
    if (Instruction_ID !=0)
    begin
        case (Instruction_ID[31:26])
            0: begin //R-type
                case (Instruction_ID[5:0])
                    32: begin //ADD
				    	Jump <= 0;
				    	JumpFlush <= 0;
				    	JumpSel <= 0;
				    	ALUControl <= 2;
				    	RegWrite <= 1;
                    end
                    33: begin //ADDU
				    	Jump <= 0;
				    	JumpFlush <= 0;
				    	JumpSel <= 0;
				    	ALUControl <= 2;
				    	RegWrite <= 1;
                    end
                    34: begin //SUB
				    	Jump <= 0;
				    	JumpFlush <= 0;
				    	JumpSel <= 0;
				    	ALUControl <= 6;
				    	RegWrite <= 1;
                    end
                    
                    18: begin //MUL
				    	Jump <= 0;
				    	JumpFlush <= 0;
				    	JumpSel <= 0;
				    	ALUControl <= 9;
				    	RegWrite <= 1;
                    end

                    8: begin //JR
				    	Jump <= 1;
				    	JumpFlush <= 1;
				    	JumpSel <= 1;
				    	ALUControl <= 0;
				    	RegWrite <= 0;
                    end
                    default:
                        RegWrite <= 0;
                endcase
                    MemRead <= 0;
				    MemtoReg <= 0;
                    MemWrite <= 0;
                    BranchEqual <=0;
                    RegDst <= 1;
                    ALUBSrc <= 0;
                end
            2: begin //Jump
                Jump <= 0;
	            JumpSel <= 0;
                JumpFlush <= 0;
                MemRead <= 0;
                MemtoReg <= 0;
                MemWrite <= 0;
                ALUControl <= 0;
                ALUBSrc <= 0;
                BranchEqual <= 0;
                RegWrite <= 0;
                RegDst <= 0;
            end
            4: begin //BEQ
                Jump <= 0;
	            JumpSel <= 0;
                JumpFlush <= 0;
                MemRead <= 0;
                MemtoReg <= 0;
                MemWrite <= 0;
                ALUControl <= 4;
                ALUBSrc <= 0;
                BranchEqual <= 1;
                RegWrite <= 0;
                RegDst  <= 0;
            end
            9: begin // ADDIU
                Jump  <= 0;
	            JumpSel <= 0;
                JumpFlush <= 0;
                MemRead <= 0;
                MemtoReg <= 0;
                MemWrite <= 0;
                ALUControl <= 2;
                ALUBSrc <= 1;
                BranchEqual <= 0;
                RegWrite <= 1;
                RegDst <= 0;
            end
            10: begin // ADDIU -1
                Jump <= 0;
	            JumpSel <= 0;
                JumpFlush <= 0;
                MemRead <= 0;
                MemtoReg <= 0;
                MemWrite <= 0;
                ALUControl <= 8;
                ALUBSrc <= 1;
                BranchEqual <= 0;
                RegWrite <= 1;
                RegDst <= 0;
            end
            35: begin //LW
                Jump <= 0;
	            JumpSel <= 0;
                JumpFlush <= 0;
                MemRead <= 1;
                MemtoReg <= 1;
                MemWrite <= 0;
                ALUControl <= 2;
                ALUBSrc <= 0;
                BranchEqual <= 0;
                RegWrite <= 1;
                RegDst <= 0;
            end
            43: begin //SW
                Jump <= 0;
	            JumpSel <= 0;
                JumpFlush <= 0;
                MemRead <= 0;
                MemtoReg <= 0;
                MemWrite <= 1;
                ALUControl <= 2;
                ALUBSrc <= 1;
                BranchEqual <= 0;
                RegWrite <= 0;
                RegDst <= 0;
            end
        endcase
    end
end

endmodule

