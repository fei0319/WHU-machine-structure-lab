`define EXT_CTRL_ITYPE_SHAMT 6'b000000
`define EXT_CTRL_ITYPE 6'b000001
`define EXT_CTRL_STYPE 6'b000010
`define EXT_CTRL_BTYPE 6'b000011
`define EXT_CTRL_UTYPE 6'b000100
`define EXT_CTRL_JTYPE 6'b000101

module ext (
    input [4:0] iimm_shamt,
    input [11:0] iimm,
    input [11:0] simm,
    input [11:0] bimm,
    input [19:0] uimm,
    input [19:0] jimm,
    input [5:0] EXTOp,
    output reg [31:0] immout
);
    always @(iimm) begin
        case (EXTOp)
            `EXT_CTRL_ITYPE_SHAMT: immout <= {27'b0, iimm_shamt[4:0]};
            `EXT_CTRL_ITYPE:
            if (iimm[11] > 0) immout <= {20'b11111111111111111111, iimm[11:0]};
            else immout <= {20'b0, iimm[11:0]};
            `EXT_CTRL_STYPE:
            if (simm[11] > 0) immout <= {20'b11111111111111111111, simm[11:0]};
            else immout <= {20'b0, simm[11:0]};
            `EXT_CTRL_BTYPE:
            if (bimm[11] > 0) immout <= {19'b1111111111111111111, bimm[11:0], 1'b0};
            else immout <= {19'b0, bimm[11:0], 1'b0};
            `EXT_CTRL_UTYPE: immout <= {uimm[19:0], 12'b0};
            `EXT_CTRL_JTYPE:
            if (jimm[19] > 0) immout <= {11'b11111111111, jimm[19:0], 1'b0};
            else immout <= {11'b0, jimm[19:0], 1'b0};
            default: immout <= 32'b0;
        endcase

    end
endmodule
