`timescale 1ns/1ps

module InstructionMemory_tb;

    reg  [11:0] address;
    wire [15:0] instruction;

    InstructionMemory dut (
        .address(address),
        .instruction(instruction)
    );

    task check_instr;
        input [11:0] addr;
        input [15:0] expected;
        begin
            address = addr;
            #1;
            if (instruction !== expected) begin
                $display("ERROR: addr=%03h instruction=%04h expected=%04h",
                         addr, instruction, expected);
                $stop;
            end else begin
                $display("OK: addr=%03h instruction=%04h", addr, instruction);
            end
        end
    endtask

    initial begin
        $display("===== InstructionMemory_tb =====");

        check_instr(12'h000, 16'hC005);
        check_instr(12'h001, 16'h8201);
        check_instr(12'h002, 16'hC003);
        check_instr(12'h003, 16'h8401);
        check_instr(12'h004, 16'h8202);
        check_instr(12'h005, 16'h8404);
        check_instr(12'h006, 16'h8208);
        check_instr(12'h007, 16'h8601);
        check_instr(12'h008, 16'h420C);
        check_instr(12'h009, 16'h8210);
        check_instr(12'h00A, 16'h480C);
        check_instr(12'h00B, 16'hC001);
        check_instr(12'h00C, 16'h8220);
        check_instr(12'h00D, 16'h8240);
        check_instr(12'h00E, 16'hE00F);
        check_instr(12'h00F, 16'hF0F0);
        check_instr(12'h010, 16'hD00F);
        check_instr(12'h011, 16'h1020);
        check_instr(12'h012, 16'hCFFF);
        check_instr(12'h013, 16'h0020);
        check_instr(12'h014, 16'h8A01);
        check_instr(12'h015, 16'h4618);
        check_instr(12'h016, 16'h4A19);
        check_instr(12'h017, 16'hC001);
        check_instr(12'h018, 16'hF800);
        check_instr(12'h019, 16'h8080);
        check_instr(12'h01A, 16'h201C);
        check_instr(12'h01B, 16'hC123);
        check_instr(12'h01C, 16'h201C);

        check_instr(12'h020, 16'h8080);
        check_instr(12'h100, 16'h8080);

        $display("InstructionMemory_tb PASSED");
        $stop;
    end

endmodule
