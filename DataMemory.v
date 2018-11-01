////////////////////////////////////////////////////////////////////////////////
// Module - data_memory.v
// Description - 32-Bit wide data memory.
//
// INPUTS:-
// Address_40: 32-Bit address input port.
// WriteData_40: 32-Bit input port.
// Clk_40: 1-Bit Input clock signal.
// MemWrite_40: 1-Bit control signal for memory write.
// MemRead_40: 1-Bit control signal for memory read.
//
// OUTPUTS:-
// ReadData_40: 32-Bit registered output port.
//
////////////////////////////////////////////////////////////////////////////////

module DataMemory (
    output reg [31:0] ReadData_40,
    input [31:0] Address_40,
    input [31:0] WriteData_40,
    input MemRead_40,
    input MemWrite_40,
    input Clk_40
);

reg [31:0] Memory [0:63];

initial begin
	$readmemb("test_data.txt",Memory);

end

always @(posedge Clk_40)
begin
    if (MemWrite_40)
    begin
        Memory[Address_40>>2] = WriteData_40;
    end

end
always @(Address_40 or MemRead_40)
begin
    if (MemRead_40)
    begin
        ReadData_40 = Memory[Address_40>>2];
    end
end


