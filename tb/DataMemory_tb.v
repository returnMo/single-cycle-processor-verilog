`timescale 1ns/1ps

module DataMemory_tb;

    reg clk;
    reg MemRead;
    reg MemWrite;
    reg [11:0] address;
    reg [15:0] write_data;
    wire [15:0] read_data;

    DataMemory dut (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin
        $display("===== DataMemory_tb =====");

        clk = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        address = 12'h000;
        write_data = 16'h0000;

        #1;
        if (dut.mem[12'h010] !== 16'h0000) begin
            $display("ERROR: initial memory is not zero at 0x010");
            $stop;
        end

        address = 12'h010;
        MemRead = 1'b0;
        #1;
        if (read_data !== 16'h0000) begin
            $display("ERROR: read_data must be zero when MemRead=0");
            $stop;
        end

        address = 12'h010;
        write_data = 16'h1234;
        MemWrite = 1'b1;
        @(posedge clk);
        #1;
        if (dut.mem[12'h010] !== 16'h1234) begin
            $display("ERROR: write failed at 0x010");
            $stop;
        end

        MemWrite = 1'b0;
        MemRead = 1'b1;
        #1;
        if (read_data !== 16'h1234) begin
            $display("ERROR: read back failed at 0x010");
            $stop;
        end

        address = 12'h011;
        write_data = 16'hABCD;
        MemRead = 1'b0;
        MemWrite = 1'b1;
        @(posedge clk);
        #1;
        if (dut.mem[12'h011] !== 16'hABCD) begin
            $display("ERROR: write failed at 0x011");
            $stop;
        end

        if (dut.mem[12'h010] !== 16'h1234) begin
            $display("ERROR: memory corruption detected at 0x010");
            $stop;
        end

        $display("DataMemory_tb PASSED");
        $stop;
    end

endmodule

