`define ALUOp_add 5'b00000
`define ALUOp_sub 5'b00001

module alu (
    input signed [31:0] A,
    B,
    input [4:0] ALUOp,
    output signed [31:0] C,
    output reg [7:0] Zero
);

    reg signed [31:0] res;

    always @(A, B, ALUOp) begin
        case (ALUOp)
            `ALUOp_add: res <= A + B;
            `ALUOp_sub: res <= A - B;
            default: res <= 0;
        endcase
    end

    assign C = res;

endmodule
