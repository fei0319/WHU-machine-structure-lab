`define ALUOp_add 5'b00000
`define ALUOp_sub 5'b00001
`define ALUOp_ra 5'b00010
`define ALUOp_and 5'b00011

module alu (
    input signed [31:0] A,
    input signed [31:0] B,
    input [4:0] ALUOp,
    output signed [31:0] C,
    output [7:0] Zero
);

    reg [31:0] result;
    always @(*) begin
        case (ALUOp)
            `ALUOp_add: result <= A + B;
            `ALUOp_sub: result <= A - B;
            `ALUOp_ra:  result <= A >>> B;
            `ALUOp_and: result <= A & B;
        endcase
    end
    assign C = result;


endmodule
