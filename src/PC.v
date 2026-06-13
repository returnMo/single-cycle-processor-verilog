module PC (
    input clk,
    input reset,
    input [11:0] next_pc,
    output reg [11:0] pc_out
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 12'b0;
        else
            pc_out <= next_pc;
    end
endmodule
