`timescale 1ns/1ps

module ExtendUnit_tb;

    reg  [11:0] in;
    reg         ExtSel;
    wire [15:0] out;

    ExtendUnit dut (
        .in(in),
        .ExtSel(ExtSel),
        .out(out)
    );

    task check_ext;
        input [11:0] in_val;
        input        extsel_val;
        input [15:0] expected;
        begin
            in = in_val;
            ExtSel = extsel_val;
            #1;
            if (out !== expected) begin
                $display("ERROR: in=%h ExtSel=%b out=%h expected=%h",
                         in_val, extsel_val, out, expected);
                $stop;
            end else begin
                $display("OK: in=%h ExtSel=%b out=%h", in_val, extsel_val, out);
            end
        end
    endtask

    initial begin
        $display("===== ExtendUnit_tb =====");

        check_ext(12'h123, 1'b0, 16'h0123);
        check_ext(12'h7FF, 1'b0, 16'h07FF);
        check_ext(12'h800, 1'b0, 16'hF800);
        check_ext(12'hFFF, 1'b0, 16'hFFFF);

        check_ext(12'h123, 1'b1, 16'h0123);
        check_ext(12'h800, 1'b1, 16'h0800);
        check_ext(12'hFFF, 1'b1, 16'h0FFF);

        $display("ExtendUnit_tb PASSED");
        $stop;
    end

endmodule
