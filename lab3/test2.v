`timescale 1ns / 1ps

module test (
    input clk,
    input rstn,
    input [15:0] sw_i,
    output [7:0] disp_an_o,
    disp_seg_o
);

    reg [31:0] clk_div;
    always @(posedge clk, negedge rstn) begin
        if (!rstn) clk_div <= 0;
        else clk_div <= clk_div + 1'b1;
    end

    wire clk_cpu;
    assign clk_cpu = clk_div[25];

    wire [4:0] ALUOp;
    assign ALUOp = {3'b000, sw_i[4:3]};

    wire [5:0] rs1, rs2, rd;
    wire [31:0] rd1, rd2, wd;
    assign rs1 = {2'b00, sw_i[10:8]};
    assign rs2 = {2'b00, sw_i[7:5]};
    assign rd = rs1;
    assign wd = {{29{rs2[2]}}, rs2};

    wire [31:0] result;
    wire [63:0] display_data;

    assign display_data = {32'h00000000, (sw_i[13] ? rd1 : result)};

    alu u_alu (
        .A(rd1),
        .B(rd2),
        .ALUOp(ALUOp),
        .C(result),
        .Zero()
    );

    rf u_rf (
        .clk(clk),
        .rstn(rstn),
        .write_enable(sw_i[2]),
        .sw_i(sw_i),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    seg7x16 u_seg7x16 (
        .clk(clk),
        .rstn(rstn),
        .disp_mode(1'b0),
        .i_data(display_data),
        .o_seg(disp_seg_o),
        .o_sel(disp_an_o)
    );

endmodule
