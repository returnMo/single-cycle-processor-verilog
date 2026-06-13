module DataMemory (
    input clk,
    input MemRead,
    input MemWrite,
    input [11:0] address,
    input [15:0] write_data,
    output [15:0] read_data
);
    reg [15:0] mem [0:4095];
    integer i;

    initial begin
        for (i = 0; i < 4096; i = i + 1)
            mem[i] = 16'b0;
    end

    assign read_data = MemRead ? mem[address] : 16'b0;

    always @(posedge clk) begin
        if (MemWrite)
            mem[address] <= write_data;
    end
endmodule
