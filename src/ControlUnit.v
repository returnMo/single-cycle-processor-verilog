module ControlUnit (
    input [3:0] opcode,
    input [8:0] funct,
    output reg Jump,
    output reg Branch,
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemRead,
    output reg MemWrite,
    output reg MemToReg,
    output reg RegDst,
    output reg ALU_InA_Sel,
    output reg ExtSel,
    output reg [2:0] ALUOp
);
    localparam [8:0] FUNCT_MOVETO   = 9'b000000001;
    localparam [8:0] FUNCT_MOVEFROM = 9'b000000010;
    localparam [8:0] FUNCT_ADD      = 9'b000000100;
    localparam [8:0] FUNCT_SUB      = 9'b000001000;
    localparam [8:0] FUNCT_AND      = 9'b000010000;
    localparam [8:0] FUNCT_OR       = 9'b000100000;
    localparam [8:0] FUNCT_NOT      = 9'b001000000;
    localparam [8:0] FUNCT_NOP      = 9'b010000000;

    always @(*) begin
        Jump        = 1'b0;
        Branch      = 1'b0;
        RegWrite    = 1'b0;
        ALUSrc      = 1'b0;
        MemRead     = 1'b0;
        MemWrite    = 1'b0;
        MemToReg    = 1'b0;
        RegDst      = 1'b0;
        ALU_InA_Sel = 1'b0;
        ExtSel      = 1'b0;
        ALUOp       = 3'b000;

        case (opcode)
            4'b0000: begin
                RegWrite = 1'b1;
                MemRead  = 1'b1;
                MemToReg = 1'b1;
            end

            4'b0001: begin
                MemWrite = 1'b1;
            end

            4'b0010: begin
                Jump = 1'b1;
            end

            4'b0100: begin
                Branch = 1'b1;
                ALUOp  = 3'b001;
            end

            4'b1000: begin
                case (funct)
                    FUNCT_MOVETO: begin
                        RegWrite = 1'b1;
                        RegDst   = 1'b1;
                        ALUOp    = 3'b101;
                    end

                    FUNCT_MOVEFROM: begin
                        RegWrite = 1'b1;
                        ALUOp    = 3'b110;
                    end

                    FUNCT_ADD: begin
                        RegWrite = 1'b1;
                        ALUOp    = 3'b000;
                    end

                    FUNCT_SUB: begin
                        RegWrite = 1'b1;
                        ALUOp    = 3'b001;
                    end

                    FUNCT_AND: begin
                        RegWrite = 1'b1;
                        ALUOp    = 3'b010;
                    end

                    FUNCT_OR: begin
                        RegWrite = 1'b1;
                        ALUOp    = 3'b011;
                    end

                    FUNCT_NOT: begin
                        RegWrite    = 1'b1;
                        ALU_InA_Sel = 1'b1;
                        ALUOp       = 3'b100;
                    end

                    FUNCT_NOP: begin
                    end

                    default: begin
                    end
                endcase
            end

            4'b1100: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                ExtSel   = 1'b0;
                ALUOp    = 3'b000;
            end

            4'b1101: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                ExtSel   = 1'b0;
                ALUOp    = 3'b001;
            end

            4'b1110: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                ExtSel   = 1'b1;
                ALUOp    = 3'b010;
            end

            4'b1111: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                ExtSel   = 1'b1;
                ALUOp    = 3'b011;
            end

            default: begin
            end
        endcase
    end
endmodule
