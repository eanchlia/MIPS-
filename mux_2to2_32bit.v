module mux_2to1_32bit(
    output reg [31:0] out_40,
    input [31:0] inA_40,
    input [31:0] inB_40,
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

