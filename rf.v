module rf(
    input clk,
    input rstn,
    input write_enable,
    input [15:0] sw_i,
    input [4:0] rs1, rs2, rd,
    input [31:0] wd,
    output [31:0] rd1, rd2
);
    
    reg [31:0] rf[31:0];
    
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) rf[i] = i;
    end

    always @(posedge clk) begin
        if (write_enable && rd != 5'b00000 && !sw_i[1]) rf[rd] <= wd;
    end

    assign rd1 = rs1 ? rf[rs1] : 0;
    assign rd2 = rs2 ? rf[rs2] : 0;

endmodule