module ctrl (
    input [6:0] Op,
    input [6:0] Funct7,
    input [2:0] Funct3,
    output RegWrite,
    output MemWrite,
    output [5:0] EXTOp,
    output [4:0] ALUOp,
    output ALUSrc,
    output [2:0] DMType,
    output WDSel
);

endmodule
