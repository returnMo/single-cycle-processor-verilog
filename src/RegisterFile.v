module RegisterFile (
    input clk,
    input reset,
    input RegWrite,
    input [2:0] read_addr_0,
    input [2:0] read_addr_1,
    input [2:0] write_addr,
    input [15:0] write_data,
    output [15:0] read_data_0,
    output [15:0] read_data_1
);
    reg [15:0] regs [0:7];
    integer i;

    assign read_data_0 = regs[read_addr_0];
    assign read_data_1 = regs[read_addr_1];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1)
                regs[i] <= 16'b0;
        end else if (RegWrite) begin
            regs[write_addr] <= write_data;
        end
    end
endmodule
