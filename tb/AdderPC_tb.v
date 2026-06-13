`timescale 1ns/1ps

module AdderPC_tb;

    reg  [11:0] a;
    wire [11:0] result;

    AdderPC dut (
        .a(a),
        .result(result)
    );

    task check_add;
        input [11:0] in_a;
        input [11:0] expected;
        begin
            a = in_a;
            #1;
            if (result !== expected) begin
                $display("ERROR: a=%h result=%h expected=%h", in_a, result, expected);
                $stop;
            end else begin
                $display("OK: a=%h result=%h", in_a, result);
            end
        end
    endtask

    initial begin
        $display("===== AdderPC_tb =====");

        check_add(12'h000, 12'h001);
        check_add(12'h001, 12'h002);
        check_add(12'h00F, 12'h010);
        check_add(12'h7FE, 12'h7FF);
        check_add(12'hFFF, 12'h000); // 12-bit wraparound

        $display("AdderPC_tb PASSED");
        $stop;
    end

endmodule
