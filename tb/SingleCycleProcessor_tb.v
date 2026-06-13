`timescale 1ns/1ps

module SingleCycleProcessor_tb;

    reg clk;
    reg reset;
    integer cycle;

    reg [15:0] expected_r0;
    reg [15:0] expected_r1;
    reg [15:0] expected_r2;
    reg [15:0] expected_r3;
    reg [15:0] expected_r4;
    reg [15:0] expected_r5;
    reg [15:0] expected_r6;
    reg [15:0] expected_r7;
    reg [15:0] expected_mem20;

    SingleCycleProcessor dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    task check_word;
        input [127:0] name;
        input [15:0] actual;
        input [15:0] expected;
        begin
            if (actual !== expected) begin
                $display("ERROR: %0s mismatch. actual=%h expected=%h", name, actual, expected);
                $stop;
            end else begin
                $display("OK: %0s = %h", name, actual);
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        cycle = 0;

        expected_r0    = 16'h00EB;
        expected_r1    = 16'h0005;
        expected_r2    = 16'h0008;
        expected_r3    = 16'h0008;
        expected_r4    = 16'h0000;
        expected_r5    = 16'h00EB;
        expected_r6    = 16'h0000;
        expected_r7    = 16'h0000;
        expected_mem20 = 16'h00EB;


        // Optional memory initialization for cleaner simulation start
        dut.dmem.mem[12'h020] = 16'h0000;

        // Keep reset active through at least one clock edge
        #12;
        reset = 1'b0;

        repeat (35) begin
            @(posedge clk);
	    #1;
            cycle = cycle + 1;

            $display(
                "cycle=%0d pc=%03h instr=%04h R0=%04h R1=%04h R2=%04h R3=%04h R4=%04h R5=%04h R6=%04h R7=%04h MEM20=%04h",
                cycle,
                dut.pc_out,
                dut.instruction,
                dut.rf.regs[0],
                dut.rf.regs[1],
                dut.rf.regs[2],
                dut.rf.regs[3],
                dut.rf.regs[4],
                dut.rf.regs[5],
                dut.rf.regs[6],
                dut.rf.regs[7],
                dut.dmem.mem[12'h020]
            );
        end

        $display("--------------------------------------------------");
        $display("Final checks");
        $display("--------------------------------------------------");

        check_word("R0",        dut.rf.regs[0],    expected_r0);
        check_word("R1",        dut.rf.regs[1],    expected_r1);
        check_word("R2",        dut.rf.regs[2],    expected_r2);
        check_word("R3",        dut.rf.regs[3],    expected_r3);
        check_word("R4",        dut.rf.regs[4],    expected_r4);
        check_word("R5",        dut.rf.regs[5],    expected_r5);
        check_word("R6",        dut.rf.regs[6],    expected_r6);
        check_word("R7",        dut.rf.regs[7],    expected_r7);
        check_word("MEM[0x020]", dut.dmem.mem[12'h020], expected_mem20);

        // Final self-loop check: program must end at Jump 0x01C
        if (dut.pc_out !== 12'h01C) begin
            $display("ERROR: Final PC is not at the self-loop address. pc_out=%03h expected=01C", dut.pc_out);
            $stop;
        end else begin
            $display("OK: Final PC = %03h (self-loop reached)", dut.pc_out);
        end

        if (dut.instruction !== 16'h201C) begin
            $display("ERROR: Final instruction mismatch. instr=%04h expected=201C", dut.instruction);
            $stop;
        end else begin
            $display("OK: Final instruction = %04h (Jump 0x01C)", dut.instruction);
        end

        $display("--------------------------------------------------");
        $display("TEST PASSED");
        $display("--------------------------------------------------");

        $stop;
    end

endmodule
