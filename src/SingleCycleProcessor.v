module SingleCycleProcessor (
    input clk,
    input reset
);
    wire [11:0] pc_out;
    wire [11:0] pc_plus_1;
    wire [11:0] branch_target;
    wire [11:0] branch_or_next_pc;
    wire [11:0] jump_target;
    wire [11:0] next_pc;

    wire [15:0] instruction;
    wire [3:0] opcode;
    wire [2:0] ri;
    wire [8:0] funct;
    wire [11:0] imm12;

    wire Jump;
    wire Branch;
    wire RegWrite;
    wire ALUSrc;
    wire MemRead;
    wire MemWrite;
    wire MemToReg;
    wire RegDst;
    wire ALU_InA_Sel;
    wire ExtSel;
    wire [2:0] ALUOp;

    wire [2:0] read_addr0;
    wire [2:0] read_addr1;
    wire [2:0] write_addr;

    wire [15:0] read_data0;
    wire [15:0] read_data1;
    wire [15:0] extended_immediate;
    wire [15:0] alu_in1;
    wire [15:0] alu_in2;
    wire [15:0] alu_result;
    wire zero_flag;

    wire [15:0] mem_read_data;
    wire [15:0] write_back_data;

    wire branch_taken;

    assign opcode = instruction[15:12];
    assign ri     = instruction[11:9];
    assign funct  = instruction[8:0];
    assign imm12  = instruction[11:0];

    assign read_addr0 = 3'b000;
    assign read_addr1 = ri;
    assign write_addr = RegDst ? ri : 3'b000;

    assign alu_in1 = ALU_InA_Sel ? read_data1 : read_data0;
    assign alu_in2 = ALUSrc ? extended_immediate : read_data1;

    assign write_back_data = MemToReg ? mem_read_data : alu_result;

    assign branch_target    = {pc_out[11:9], instruction[8:0]};
    assign branch_taken     = Branch & zero_flag;
    assign branch_or_next_pc = branch_taken ? branch_target : pc_plus_1;
    assign jump_target      = instruction[11:0];
    assign next_pc          = Jump ? jump_target : branch_or_next_pc;

    PC pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc_out(pc_out)
    );

    AdderPC adder_pc_inst (
        .a(pc_out),
        .result(pc_plus_1)
    );

    InstructionMemory imem (
        .address(pc_out),
        .instruction(instruction)
    );

    ControlUnit cu (
        .opcode(opcode),
        .funct(funct),
        .Jump(Jump),
        .Branch(Branch),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .RegDst(RegDst),
        .ALU_InA_Sel(ALU_InA_Sel),
        .ExtSel(ExtSel),
        .ALUOp(ALUOp)
    );

    RegisterFile rf (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite),
        .read_addr_0(read_addr0),
        .read_addr_1(read_addr1),
        .write_addr(write_addr),
        .write_data(write_back_data),
        .read_data_0(read_data0),
        .read_data_1(read_data1)
    );

    ExtendUnit ext_unit (
        .in(imm12),
        .ExtSel(ExtSel),
        .out(extended_immediate)
    );

    ALU alu (
        .a(alu_in1),
        .b(alu_in2),
        .alu_op(ALUOp),
        .result(alu_result),
        .zero_flag(zero_flag)
    );

    DataMemory dmem (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .address(instruction[11:0]),
        .write_data(read_data0),
        .read_data(mem_read_data)
    );
endmodule
