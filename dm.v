`define dm_word 3'b000
`define dm_halfword 3'b001
`define dm_halfword_unsigned 3'b001
`define dm_byte 3'b011
`define dm_byte_unsigned 3'b100

module dm (
    input clk,
    input DMWr,
    input [4:0] address,
    input [31:0] din,
    input [2:0] DMType,
    output reg [31:0] dout
);

    reg [7:0] dmem[31:0];

    always @(posedge clk) begin
        if (DMWr) begin
            case (DMType)
                `dm_word: begin
                    dmem[address]   <= din[7:0];
                    dmem[address+1] <= din[15:8];
                    dmem[address+2] <= din[23:16];
                    dmem[address+3] <= din[31:24];
                end
                `dm_halfword: begin
                    dmem[address]   <= din[7:0];
                    dmem[address+1] <= din[15:8];
                end
                `dm_byte: begin
                    dmem[address] <= din[7:0];
                end
            endcase
        end
        case (DMType)
            `dm_word: dout = {dmem[address+3], dmem[address+2], dmem[address+1], dmem[address]};
            `dm_halfword: dout = {{16{dmem[address+1][7]}}, dmem[address+1], dmem[address]};
            `dm_halfword_unsigned: dout = {{16{1'b0}}, dmem[address+1], dmem[address]};
            `dm_byte: dout = {{24{dmem[address][7]}}, dmem[address]};
            `dm_byte_unsigned: dout = {{24{1'b0}}, dmem[address]};
        endcase
    end

endmodule
