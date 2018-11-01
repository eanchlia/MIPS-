////////////////////////////////////////////////////////////////////////////////
// Module - PCAdder.v
// Description - 32-Bit program counter (PC) adder.
//
// INPUTS:-
// PCResult: 32-Bit input port.
//
// OUTPUTS:-
// PCAddResult: 32-Bit output port.
//
////////////////////////////////////////////////////////////////////////////////

module PCAdder(
    output reg [31:0] PCAddResult,
    input [31:0] PCResult
);

    always @(PCResult)
    begin
    	PCAddResult <= PCResult + 32'h00000004;
    end

endmodule


