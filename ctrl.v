`define EXT_CTRL_ITYPE_SHAMT 6'b000000
`define EXT_CTRL_ITYPE 6'b000001
`define EXT_CTRL_STYPE 6'b000010
`define EXT_CTRL_BTYPE 6'b000011
`define EXT_CTRL_UTYPE 6'b000100
`define EXT_CTRL_JTYPE 6'b000101

`define dm_word 3'b000
`define dm_halfword 3'b001
`define dm_halfword_unsigned 3'b001
`define dm_byte 3'b011
`define dm_byte_unsigned 3'b100

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

    wire rtype = (Op == 7'b0110011);
    wire itype = (Op == 7'b0010011);
    wire ltype = (Op == 7'b0000011);
    wire stype = (Op == 7'b0100011);
    wire shamt = (Funct3 == 3'b001 || Funct3 == 3'b101);

    wire srai = (itype && Funct3 == 3'b101 && Funct7 == 7'b0100000);
    wire andi = (itype && Funct3 == 3'b111);

    assign RegWrite = rtype | itype | ltype;
    assign MemWrite = stype;
    assign ALUSrc = itype | ltype | stype;
    assign DMType = `dm_word;
    assign WDSel = ltype;

    assign EXTOp = (itype ? (shamt ? `EXT_CTRL_ITYPE_SHAMT : `EXT_CTRL_ITYPE) : (ltype ? `EXT_CTRL_ITYPE : `EXT_CTRL_STYPE));
    assign ALUOp = (srai ? `ALUOp_ra : (andi ? `ALUOp_and : `ALUOp_add));

endmodule
