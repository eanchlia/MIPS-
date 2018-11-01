////////////////////////////////////////////////////////////////////////////////
// Module - InstructionFetchUnit.v
// Description - Fetches the instruction from the instruction memory based on
//               the program counter (PC) value.
//
// OUTPUTS:-
// Instruction: 32-Bit output instruction from the instruction memory.
//
////////////////////////////////////////////////////////////////////////////////

module InstructionFetchUnit (
    output [31:0] Instruction_40,
    output [31:0] PCNext4_40,
    output [31:0] PCNow_40,
    input Clk_40,  
    input Reset_40,
    input Jump_40,
    input PCWrite_40,
    input [31:0] NewPC
);

wire [31:0] PCAdderOut_40,  PCNext_40,  PCOut;

PCAdder adder (
    .PCAddResult_40 (PCAdderOut_40),
    .PCResult_40 (PCOut_40)
);

ProgramCounter PC (
    .PCResult_40 (PCOut_40),
    .PCNext_40 (PCNext_40),
    .Reset_40 (Reset_40),
    .Clk_40 (Clk_40),
    .PCWrite_40 (PCWrite_40)

);

InstructionMemory IM(
    .Instruction_40(Instruction_40),
    .Address_40 (PCOut_40)
);

mux_2to1_32bit JumpOrPCNext4Mux (PCNext_40, PCAdderOut_40, NewPC_40, Jump_40);

assign PCNow_40 = PCOut_40;
assign PCNext4_40 = PCAdderOut_40;
endmodule

