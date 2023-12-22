`define ALUOp_add 5'b00000
`define ALUOp_sub 5'b00001

module alu (
    input signed [31:0] A,
    input signed [31:0] B,
    input [4:0] ALUOp,
    output signed [31:0] C,
    output [7:0] Zero
);

    assign C = A + B;

endmodule
