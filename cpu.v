`timescale 1ns / 1ps

module cpu (
    input clk,
    input rstn,
    input [15:0] sw_i,
    output [7:0] disp_an_o,
    output [7:0] disp_seg_o
);

    reg [31:0] clk_div;
    always @(posedge clk, negedge rstn) begin
        if (!rstn) clk_div <= 0;
        else clk_div <= clk_div + 1'b1;
    end
    wire clk_cpu;
    assign clk_cpu = clk_div[27];

    wire [63:0] disp_data;
    seg7x16 u_seg7x16 (
        .clk(clk),
        .rstn(rstn),
        .i_data(disp_data),
        .disp_mode(1'b0),
        .o_seg(disp_seg_o),
        .o_sel(disp_an_o)
    );

    wire [31:0] inst;
    reg  [31:0] PC;

    dist_mem_im u_im (
        .a  (PC),
        .spo(inst)
    );

    always @(posedge clk_cpu, negedge rstn) begin
        if (!rstn) PC <= 0;
        else PC <= PC + 1;
    end

    assign disp_data = {{32{1'b0}}, inst};

    wire RegWrite;
    wire [5:0] rs1, rs2, rd;
    assign rs1 = inst[24:20];
    assign rs2 = inst[19:15];
    assign rd  = inst[11:7];
    wire [31:0] rs1_data, rs2_data, rd_data;
    rf u_rf (
        .clk(clk),
        .rstn(rstn),
        .write_enable(RegWrite),
        .sw_i(sw_i),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(rd_data),
        .rd1(rs1_data),
        .rd2(rs2_data)
    );

    wire MemWrite, ALUSrc, WDSel;
    wire [4:0] ALUOp;
    wire [5:0] EXTOp;
    wire [2:0] DMType;
    ctrl u_ctrl (
        .Op(inst[6:0]),
        .Funct7(inst[31:25]),
        .Funct3(inst[14:12]),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .EXTOp(EXTOp),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .DMType(DMType),
        .WDSel(WDSel)
    );

    wire [31:0] imm;
    ext u_ext (
        .iimm_shamt(imm[24:20]),
        .iimm(imm[31:20]),
        .simm({imm[31:25], imm[11:7]}),
        .bimm({imm[31], imm[7], imm[30:25], imm[11:8]}),
        .uimm(),
        .jimm(),
        .EXTOp(EXTOp),
        .immout(imm)
    );

    wire [31:0] ALUResult;
    alu u_alu (
        .A(rs1_data),
        .B(ALUSrc ? imm : rs2_data),
        .ALUOp(ALUOp),
        .C(ALUResult),
        .Zero()
    );

    wire [31:0] dout;
    dm u_dm (
        .clk(clk),
        .DMWr(MemWrite),
        .address(ALUResult),
        .din(rs2_data),
        .DMType(DMType),
        .dout(dout)
    );

    assign rd_data = WDSel ? dout : ALUResult;

endmodule
