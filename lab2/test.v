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
    assign clk_cpu = sw_i[15] ? clk_div[27] : clk_div[25];

    reg [4:0] reg_index;
    wire [31:0] reg_data;
    always @(posedge clk_cpu, negedge rstn) begin
        if (!rstn) reg_index <= 5'b00000;
        else begin
            reg_index <= reg_index + 1'b1;
        end
    end

    rf u_rf(
        .clk(clk),
        .rstn(rstn),
        .write_enable(sw_i[3]),
        .sw_i(sw_i),
        .rs1(reg_index),
        .rs2(),
        .rd(sw_i[12:8]),
        .wd(sw_i[7:4]),
        .rd1(reg_data),
        .rd2()
    );

    seg7x16 u_seg7x16 (
        .clk(clk),
        .rstn(rstn),
        .disp_mode(1'b0),
        .i_data({{32{reg_data[31]}}, reg_data}),
        .o_seg(disp_seg_o),
        .o_sel(disp_an_o)
    );

endmodule
