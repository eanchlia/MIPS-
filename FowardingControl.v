`timescale 1ns / 1ps

module ForwardingControl(
	input [4:0] Rs_ID, Rt_ID, Rs_EX, Rt_EX, WriteRegAddress_MEM, WriteRegAddress_WB,
	input RegWrite_MEM, RegWrite_WB,
	output reg ReadData1Sel_ID, ReadData2Sel_ID,
	output reg [1:0] ReadData1Sel_EX, ReadData2Sel_EX
);
	
always @(Rs_ID, Rt_ID, Rs_EX, Rt_EX, WriteRegAddress_MEM, WriteRegAddress_WB, RegWrite_MEM, RegWrite_WB)
begin
	if (Rs_EX == WriteRegAddress_MEM && RegWrite_MEM == 1) begin
		ReadData1Sel_EX <= 1;
	end else if (Rs_EX == WriteRegAddress_WB && RegWrite_WB == 1) begin
		ReadData1Sel_EX <= 2;
	end else begin
		ReadData1Sel_EX <= 0;
	end
	
	if (Rt_EX == WriteRegAddress_MEM && RegWrite_MEM == 1) begin
		ReadData2Sel_EX <= 1;
	end else if (Rt_EX == WriteRegAddress_WB && RegWrite_WB == 1) begin
		ReadData2Sel_EX <= 2;
	end else begin
		ReadData2Sel_EX <= 0;
	end
	
	if (Rs_ID == WriteRegAddress_WB && RegWrite_WB == 1) begin
		ReadData1Sel_ID <= 1;
	end else begin
		ReadData1Sel_ID <= 0;
	end
	
	if (Rt_ID == WriteRegAddress_WB && RegWrite_WB == 1) begin
		ReadData2Sel_ID <= 1;
	end else begin
		ReadData2Sel_ID <= 0;
	end
end	
	
endmodule

