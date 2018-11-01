////////////////////////////////////////////////////////////////////////////////
// Description - 32-Bit wide arithmetic logic unit (ALU).
//
// INPUTS:-
// ALUControl: 4-Bit input control bits to select an ALU operation.
// A: 32-Bit input port A.
// B: 32-Bit input port B.
//
// OUTPUTS:-
// ALUResult: 32-Bit ALU result output.
// ZERO: 1-Bit output flag.
//
// Op   | 'ALUControl' value
// ==========================
// AND  | 0000
// OR   | 0001
// ADD  | 0010
// XOR  | 0100
// SUB  | 0110
// SLT  | 0111
// MUL  | 1001
//
////////////////////////////////////////////////////////////////////////////////

module ALU32Bit (
    output reg [31:0] ALUResult,
    output reg Zero,
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUControl
);
always @(*)
begin
    case (ALUControl)
        0: // AND
            ALUResult <= A & B;
        1: // OR
            ALUResult <= A | B;
        2: // ADD
            ALUResult <= A + B;
        3: // NOR
            ALUResult <= ~(A | B);
        4: // XOR
            ALUResult <= A^B;
        6: // SUB
            ALUResult <= A + (~B + 1);
        7: begin // SLT
            if (A[31] != B[31]) begin
                if (A[31] > B[31]) begin
                    ALUResult <= 1;
                end else begin
                    ALUResult <= 0;
                end
            end else begin
                if (A < B) begin
                    ALUResult <= 1;
                end else begin
                    ALUResult <= 0;
                end
            end
        end
        8: //Decrement 1
            ALUResult <= A - 1;
        9: // MUL
            ALUResult <= A * B;
        
        default: begin
            $display("Wrong ALUControl %d:",ALUControl);
        end
    endcase
end

always @(ALUResult)
begin
    if (ALUResult == 0) begin
        Zero <= 1;
    end else begin
        Zero <= 0;
    end
end

endmodule

