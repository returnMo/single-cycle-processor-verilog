`timescale 1ns/1ps

module ControlUnit_tb;

    reg  [3:0] opcode;
    reg  [8:0] funct;
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

    ControlUnit dut (
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

    task check_ctrl;
        input [3:0] op;
        input [8:0] fn;
        input exp_Jump;
        input exp_Branch;
        input exp_RegWrite;
        input exp_ALUSrc;
        input exp_MemRead;
        input exp_MemWrite;
        input exp_MemToReg;
        input exp_RegDst;
        input exp_ALU_InA_Sel;
        input exp_ExtSel;
        input [2:0] exp_ALUOp;
        begin
            opcode = op;
            funct  = fn;
            #1;
            if (Jump        !== exp_Jump       ||
                Branch      !== exp_Branch     ||
                RegWrite    !== exp_RegWrite   ||
                ALUSrc      !== exp_ALUSrc     ||
                MemRead     !== exp_MemRead    ||
                MemWrite    !== exp_MemWrite   ||
                MemToReg    !== exp_MemToReg   ||
                RegDst      !== exp_RegDst     ||
                ALU_InA_Sel !== exp_ALU_InA_Sel||
                ExtSel      !== exp_ExtSel     ||
                ALUOp       !== exp_ALUOp) begin
                $display("ERROR: control mismatch for opcode=%b funct=%b", op, fn);
                $display("got Jump=%b Branch=%b RegWrite=%b ALUSrc=%b MemRead=%b MemWrite=%b MemToReg=%b RegDst=%b ALU_InA_Sel=%b ExtSel=%b ALUOp=%b",
                         Jump, Branch, RegWrite, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, ALU_InA_Sel, ExtSel, ALUOp);
                $stop;
            end else begin
                $display("OK: opcode=%b funct=%b", op, fn);
            end
        end
    endtask

    initial begin
        $display("===== ControlUnit_tb =====");

        check_ctrl(4'b0000, 9'b000000000, 1'b0,1'b0,1'b1,1'b0,1'b1,1'b0,1'b1,1'b0,1'b0,1'b0,3'b000);
        check_ctrl(4'b0001, 9'b000000000, 1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,3'b000);
        check_ctrl(4'b0010, 9'b000000000, 1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,3'b000);
        check_ctrl(4'b0100, 9'b000000000, 1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,3'b001);

        check_ctrl(4'b1000, 9'b000000001, 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,3'b101);
        check_ctrl(4'b1000, 9'b000000010, 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,3'b110);
        check_ctrl(4'b1000, 9'b000000100, 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,3'b000);
        check_ctrl(4'b1000, 9'b000001000, 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,3'b001);
        check_ctrl(4'b1000, 9'b000010000, 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,3'b010);
        check_ctrl(4'b1000, 9'b000100000, 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,3'b011);
        check_ctrl(4'b1000, 9'b001000000, 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,3'b100);
        check_ctrl(4'b1000, 9'b010000000, 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,3'b000);

        check_ctrl(4'b1100, 9'b000000000, 1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,3'b000);
        check_ctrl(4'b1101, 9'b000000000, 1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,3'b001);
        check_ctrl(4'b1110, 9'b000000000, 1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,3'b010);
        check_ctrl(4'b1111, 9'b000000000, 1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,3'b011);

        check_ctrl(4'b0111, 9'b111111111, 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,3'b000);

        $display("ControlUnit_tb PASSED");
        $stop;
    end

endmodule
