`timescale 1ns/1ps

module PC_tb;

    reg clk;
    reg reset;
    reg [11:0] next_pc;
    wire [11:0] pc_out;

    PC dut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc_out(pc_out)
    );

    always #5 clk = ~clk;

    initial begin
        $display("===== PC_tb =====");

        clk = 1'b0;
        reset = 1'b1;
        next_pc = 12'h000;

        #1;
        if (pc_out !== 12'h000) begin
            $display("ERROR: PC is not zero during reset");
            $stop;
        end

        #11;
        reset = 1'b0;
        next_pc = 12'h123;

        @(posedge clk);
        #1;
        if (pc_out !== 12'h123) begin
            $display("ERROR: PC load failed expected=123 got=%h", pc_out);
            $stop;
        end

        next_pc = 12'h124;
        @(posedge clk);
        #1;
        if (pc_out !== 12'h124) begin
            $display("ERROR: PC update failed expected=124 got=%h", pc_out);
            $stop;
        end

        reset = 1'b1;
        #1;
        if (pc_out !== 12'h000) begin
            $display("ERROR: async reset failed expected=000 got=%h", pc_out);
            $stop;
        end

        $display("PC_tb PASSED");
        $stop;
    end

endmodule
