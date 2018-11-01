////////////////////////////////////////////////////////////////////////////////
// Module - ProgramCounter.v
// Description - 32-Bit program counter (PC) register.
//
// INPUTS:-
// Address: 32-Bit address input port.
// Reset: 1-Bit input control signal.
// Clk: 1-Bit input clock signal.
//
// OUTPUTS:-
// PCResult: 32-Bit registered output port.
//
////////////////////////////////////////////////////////////////////////////////

module ProgramCounter(
    output reg [31:0]  PCResult,
    input [31:0] PCNext,
    input Reset,
    input Clk,
    input PCWrite
);

	initial begin
	
		PCResult <= 32'h00000000;
	end

    always @(posedge Clk)
    begin
    	if (Reset == 1)
    	begin
    		PCResult <= 32'h00000000;
    	end
    	else
    	begin
			if (PCWrite == 1) begin
				PCResult <= PCNext;
			end
    	end
    end

endmodule
