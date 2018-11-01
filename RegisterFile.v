////////////////////////////////////////////////////////////////////////////////
// Description - Implements a register file with 32 32-Bit wide registers.
//
// INPUTS:-
// ReadRegister1: 5-Bit address to select a register to be read through 32-Bit
//                output port 'ReadRegister1'.
// ReadRegister2: 5-Bit address to select a register to be read through 32-Bit
//                output port 'ReadRegister2'.
// WriteRegister: 5-Bit address to select a register to be written through 32-Bit
//                input port 'WriteRegister'.
// WriteData: 32-Bit write input port.
// RegWrite: 1-Bit control input signal.
//
// OUTPUTS:-
// ReadData1: 32-Bit registered output.
// ReadData2: 32-Bit registered output.
//
////////////////////////////////////////////////////////////////////////////////

module RegisterFile(
	output reg [31:0] ReadData1_40,
	output reg [31:0] ReadData2_40,
	input [4:0] ReadRegister1_40,
	input [4:0] ReadRegister2_40,
	input [4:0] WriteRegister_40,
	input [31:0] WriteData_40,
	input RegWrite_40,
    input Clk_40
);

reg [31:0] Registers_40 [0:31];

initial
begin
    Registers_40[0] <= 32'h00000000;
    Registers_40[1] <= 32'h00000000;
    Registers_40[2] <= 32'h00000002;
    Registers_40[3] <= 32'h00000003;
    Registers_40[4] <= 32'h00000004;
    Registers_40[5] <= 32'h00000005;
    Registers_40[6] <= 32'h00000006;
    Registers_40[7] <= 32'h00000007;
    Registers_40[8] <= 32'h00000000;
    Registers_40[9] <= 32'h00000000;
    Registers_40[10] <= 32'h00000000;
    Registers_40[11] <= 32'h00000000;
    Registers_40[12] <= 32'h00000000;
    Registers_40[13] <= 32'h00000000;
    Registers_40[14] <= 32'h00000000;
    Registers_40[15] <= 32'h00000000;
    Registers_40[16] <= 32'h00000000;
    Registers_40[17] <= 32'h00000000;
    Registers_40[18] <= 32'h00000000;
    Registers_40[19] <= 32'h00000000;
    Registers_40[20] <= 32'h00000000;
    Registers_40[21] <= 32'h00000000;
    Registers_40[22] <= 32'h00000000;
    Registers_40[23] <= 32'h00000000;
    Registers_40[24] <= 32'h00000000;
    Registers_40[25] <= 32'h00000000;
    Registers_40[29] <= 32'd252; // this value should point to the top of data memory
    Registers_40[31] <= 32'b0;
end
	
	
always @(posedge Clk_40)
begin
    if (RegWrite_40 == 1)
    begin
        Registers_40[WriteRegister_40] <= WriteData_40;
    end
end
	
always @(negedge Clk_40)
begin
    ReadData1_40 <= Registers_40[ReadRegister1_40];
    ReadData2_40 <= Registers_40[ReadRegister2_40];
end
	
endmodule

