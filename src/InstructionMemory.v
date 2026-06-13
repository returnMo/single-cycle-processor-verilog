module InstructionMemory (
    input [11:0] address,
    output [15:0] instruction
);
    reg [15:0] mem [0:4095];
    integer i;

    localparam [15:0] INSTR_NOP = 16'h8080;

    initial begin
        for (i = 0; i < 4096; i = i + 1)
            mem[i] = INSTR_NOP;

        $readmemh("program.hex", mem);
    end

    assign instruction = mem[address];
endmodule
