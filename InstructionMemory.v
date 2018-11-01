`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Module - InstructionMemory.v
// Description - 32-Bit wide instruction memory.
//
// INPUT:-
// Address: 32-Bit address input port.
//
// OUTPUT:-
// Instruction: 32-Bit output port.
//
////////////////////////////////////////////////////////////////////////////////

module InstructionMemory(
    output [31:0] Instruction_40,
    input [31:0] Address_40
);
    
reg [31:0] mem_40[0:255];


	initial
	begin
		$readmemb("code.txt",mem_40);
	end

	assign Instruction_40 = mem_40[Address_40>>2];	

endmodule

