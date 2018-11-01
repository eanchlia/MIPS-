`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Module - sign_extension.v
// Description - Extends a 16-Bit input number to produce a 32-Bit output
// number.
////////////////////////////////////////////////////////////////////////////////

module sign_extension(
    output reg [31:0] out_40,
    input [15:0] in_40
);

always@(in_40)
begin    
    out_40 <= {{16{in_40[15]}},in_40};
end
endmodule

