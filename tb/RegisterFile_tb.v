`timescale 1ns/1ps

module RegisterFile_tb;

    reg clk;
    reg reset;
    reg RegWrite;
    reg [2:0] read_addr_0;
    reg [2:0] read_addr_1;
    reg [2:0] write_addr;
    reg [15:0] write_data;
    wire [15:0] read_data_0;
    wire [15:0] read_data_1;

    integer i;

    RegisterFile dut (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite),
        .read_addr_0(read_addr_0),
        .read_addr_1(read_addr_1),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_data_0(read_data_0),
        .read_data_1(read_data_1)
    );

    always #5 clk = ~clk;

    initial begin
        $display("===== RegisterFile_tb =====");

        clk = 1'b0;
        reset = 1'b1;
        RegWrite = 1'b0;
        read_addr_0 = 3'b000;
        read_addr_1 = 3'b001;
        write_addr = 3'b000;
        write_data = 16'h0000;

        #1;
        for (i = 0; i < 8; i = i + 1) begin
            if (dut.regs[i] !== 16'h0000) begin
                $display("ERROR: reset failed at regs[%0d]=%h", i, dut.regs[i]);
                $stop;
            end
        end

        #11;
        reset = 1'b0;

        write_addr = 3'd3;
        write_data = 16'hA5A5;
        RegWrite = 1'b1;
        @(posedge clk);
        #1;
        if (dut.regs[3] !== 16'hA5A5) begin
            $display("ERROR: write to R3 failed");
            $stop;
        end

        write_addr = 3'd5;
        write_data = 16'h5A5A;
        @(posedge clk);
        #1;
        if (dut.regs[5] !== 16'h5A5A) begin
            $display("ERROR: write to R5 failed");
            $stop;
        end

        RegWrite = 1'b0;
        read_addr_0 = 3'd3;
        read_addr_1 = 3'd5;
        #1;
        if (read_data_0 !== 16'hA5A5 || read_data_1 !== 16'h5A5A) begin
            $display("ERROR: asynchronous read failed read0=%h read1=%h", read_data_0, read_data_1);
            $stop;
        end

        write_addr = 3'd3;
        write_data = 16'h1111;
        @(posedge clk);
        #1;
        if (dut.regs[3] !== 16'hA5A5) begin
            $display("ERROR: register changed while RegWrite=0");
            $stop;
        end

        reset = 1'b1;
        #1;
        for (i = 0; i < 8; i = i + 1) begin
            if (dut.regs[i] !== 16'h0000) begin
                $display("ERROR: second reset failed at regs[%0d]=%h", i, dut.regs[i]);
                $stop;
            end
        end

        $display("RegisterFile_tb PASSED");
        $stop;
    end

endmodule

