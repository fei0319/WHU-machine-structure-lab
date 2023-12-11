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

    wire [31:0] A, B, C;
    assign A = {{28{sw_i[10]}}, sw_i[10:7]};
    assign B = {{28{sw_i[6]}}, sw_i[6:3]};

    wire [4:0] ALUOp;
    assign ALUOp = sw_i[2] ? `ALUOp_add : `ALUOp_sub;

    reg [63:0] data;
    reg [ 1:0] disp;
    reg [ 3:0] value;
    always @(posedge clk_cpu, negedge rstn) begin
        if (!rstn) disp = 2'b00;
        else begin
            if (disp == 2'b11) disp = 2'b00;
            case (disp)
                2'b00: value = A;
                2'b01: value = B;
                2'b10: value = C;
            endcase
            data = 32'h0FFFFFFF;
            data[31:28] <= value;
            disp <= disp + 2'b01;
        end
    end

    alu u_alu (
        .A(A),
        .B(B),
        .ALUOp(ALUOp),
        .C(C),
        .Zero()
    );

    seg7x16 u_seg7x16 (
        .clk(clk),
        .rstn(rstn),
        .disp_mode(1'b0),
        .i_data(data),
        .o_seg(disp_seg_o),
        .o_sel(disp_an_o)
    );

endmodule
