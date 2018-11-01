`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Module - mux_2to1_32bit.v
// Description - Performs signal multiplexing between 2 32-Bit words.
////////////////////////////////////////////////////////////////////////////////

module mux_2to1_5bit(
    output reg [4:0] out_40,
    input [4:0] inA_40,
    input [4:0] inB_40,
    input sel_40
);

always@(inA_40,inB_40,sel_40)
begin
    if (sel_40 == 0)
	begin
        out_40 <= inA_40;
    end else  
    begin
        out_40 <= inB_40;
	end
 end
	
endmodule


