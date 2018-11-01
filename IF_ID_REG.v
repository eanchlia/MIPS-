`timescale 1ns / 1ps

module IF_ID_REG(
    input Clk_40,
    input Rst_40,
    input Write_40,
    input [31:0] instruction_in_40,
    input [31:0] PCNow_in_40,
    input [31:0] PCNext4_in_40,
    output reg [31:0] instruction_out_40,
    output reg [31:0] PCNow_out_40,
    output reg [31:0] PCNext4_out_40
);

reg [31:0] instruction_outB_40, PCNow_outB_40, PCNext4_outB_40;
	
always@(Rst_40)
begin
    if (Rst_40 == 1) begin
        instruction_out_40 <= 32'b0;
        PCNext4_out_40 <= 32'b0;
        PCNow_out_40 <= 0;
    end else if (Rst == 0) begin
        instruction_out_40 <= instruction_out_40;
        PCNext4_out_40 <= PCNext4_out_40;
        PCNow_out_40 <= PCNow_out_40;
    end
end

always@(posedge Clk_40)
begin
    if (Write_40) begin
        instruction_out_40 <= instruction_i_40;
        PCNext4_out_40 <= PCNext4_i_40;
        PCNow_out_40 <= PCNow_i_40;
    end
end

always@(negedge Clk_40) begin
    instruction_out_40 <= instruction_i_40;
    PCNext4_out_40 <= PCNext4_i_40;
    PCNow_out_40 <= PCNow_i_40;
end
endmodule

