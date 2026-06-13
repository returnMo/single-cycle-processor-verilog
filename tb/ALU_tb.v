`timescale 1ns/1ps

module ALU_tb;

    reg  [15:0] a;
    reg  [15:0] b;
    reg  [2:0] alu_op;
    wire [15:0] result;
    wire zero_flag;

    ALU dut (
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(result),
        .zero_flag(zero_flag)
    );

    task check_alu;
        input [2:0]  op;
        input [15:0] in_a;
        input [15:0] in_b;
        input [15:0] expected_result;
        input        expected_zero;
        begin
            alu_op = op;
            a = in_a;
            b = in_b;
            #1;
            if (result !== expected_result || zero_flag !== expected_zero) begin
                $display("ERROR: op=%b a=%h b=%h result=%h zero=%b expected_result=%h expected_zero=%b",
                         op, in_a, in_b, result, zero_flag, expected_result, expected_zero);
                $stop;
            end else begin
                $display("OK: op=%b a=%h b=%h result=%h zero=%b",
                         op, in_a, in_b, result, zero_flag);
            end
        end
    endtask

    initial begin
        $display("===== ALU_tb =====");

        check_alu(3'b000, 16'h0003, 16'h0005, 16'h0008, 1'b0);
        check_alu(3'b001, 16'h0008, 16'h0005, 16'h0003, 1'b0);
        check_alu(3'b001, 16'h0005, 16'h0005, 16'h0000, 1'b1);
        check_alu(3'b010, 16'h00F0, 16'h0FF0, 16'h00F0, 1'b0);
        check_alu(3'b011, 16'h00F0, 16'h0F0F, 16'h0FFF, 1'b0);
        check_alu(3'b100, 16'h00F0, 16'h1234, 16'hFF0F, 1'b0);
        check_alu(3'b101, 16'hABCD, 16'h1234, 16'hABCD, 1'b0);
        check_alu(3'b110, 16'hABCD, 16'h1234, 16'h1234, 1'b0);
        check_alu(3'b111, 16'h1111, 16'h2222, 16'h0000, 1'b1);

        $display("ALU_tb PASSED");
        $stop;
    end

endmodule

