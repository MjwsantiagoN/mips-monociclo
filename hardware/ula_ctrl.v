// ============================================================
// Grupo: Marcos José e Josué Costa
// Atividade: Projeto 02 - 2VA
// Disciplina: Arquitetura e Organização de Computadores
// Semestre: 2025.2
// Arquivo: ula_ctrl.v
// Descrição: Unidade de controle da ULA. Recebe o sinal
//            ALUOp (2 bits) da unidade de controle principal
//            e o campo funct (6 bits) da instrução tipo R.
//            Gera o código de operação de 4 bits para a ULA.
//
//  ALUOp:
//    00 → Soma (usado por lw, sw, addi)
//    01 → Subtração (usado por beq, bne)
//    10 → Operação definida pelo campo funct (tipo R)
//    11 → Operação definida pelo opcode I (andi, ori, xori,
//          slti, sltiu, lui)
//
//  Codificação da ULA (op[3:0]):
//    0000 = ADD    0001 = SUB    0010 = AND    0011 = OR
//    0100 = XOR    0101 = NOR    0110 = SLT    0111 = SLTU
//    1000 = SLL    1001 = SRL    1010 = SRA    1011 = LUI
// ============================================================

module ula_ctrl (
    input  [1:0] aluOp,   // Sinal da unidade de controle principal
    input  [5:0] funct,   // Bits [5:0] da instrução (campo funct)
    input  [5:0] opcode,  // Opcode da instrução (para casos tipo I especiais)
    output reg [3:0] ulaOP // Código de operação para a ULA
);

    // Códigos funct das instruções tipo R (MIPS padrão)
    localparam FUNCT_ADD  = 6'b100000;
    localparam FUNCT_SUB  = 6'b100010;
    localparam FUNCT_AND  = 6'b100100;
    localparam FUNCT_OR   = 6'b100101;
    localparam FUNCT_XOR  = 6'b100110;
    localparam FUNCT_NOR  = 6'b100111;
    localparam FUNCT_SLT  = 6'b101010;
    localparam FUNCT_SLTU = 6'b101011;
    localparam FUNCT_SLL  = 6'b000000;
    localparam FUNCT_SRL  = 6'b000010;
    localparam FUNCT_SRA  = 6'b000011;
    localparam FUNCT_SLLV = 6'b000100;
    localparam FUNCT_SRLV = 6'b000110;
    localparam FUNCT_SRAV = 6'b000111;
    localparam FUNCT_JR   = 6'b001000;

    // Opcodes instruções tipo I com operação específica
    localparam OP_ANDI  = 6'b001100;
    localparam OP_ORI   = 6'b001101;
    localparam OP_XORI  = 6'b001110;
    localparam OP_SLTI  = 6'b001010;
    localparam OP_SLTIU = 6'b001011;
    localparam OP_LUI   = 6'b001111;

    always @(*) begin
        case (aluOp)

            // ALUOp = 00: soma (lw, sw, addi)
            2'b00: ulaOP = 4'b0000; // ADD

            // ALUOp = 01: subtração (beq, bne)
            2'b01: ulaOP = 4'b0001; // SUB

            // ALUOp = 10: tipo R – decodifica pelo campo funct
            2'b10: begin
                case (funct)
                    FUNCT_ADD:  ulaOP = 4'b0000; // add
                    FUNCT_SUB:  ulaOP = 4'b0001; // sub
                    FUNCT_AND:  ulaOP = 4'b0010; // and
                    FUNCT_OR:   ulaOP = 4'b0011; // or
                    FUNCT_XOR:  ulaOP = 4'b0100; // xor
                    FUNCT_NOR:  ulaOP = 4'b0101; // nor
                    FUNCT_SLT:  ulaOP = 4'b0110; // slt
                    FUNCT_SLTU: ulaOP = 4'b0111; // sltu
                    FUNCT_SLL:  ulaOP = 4'b1000; // sll
                    FUNCT_SLLV: ulaOP = 4'b1000; // sllv
                    FUNCT_SRL:  ulaOP = 4'b1001; // srl
                    FUNCT_SRLV: ulaOP = 4'b1001; // srlv
                    FUNCT_SRA:  ulaOP = 4'b1010; // sra
                    FUNCT_SRAV: ulaOP = 4'b1010; // srav
                    FUNCT_JR:   ulaOP = 4'b0000; // jr (ADD sem uso do resultado)
                    default:    ulaOP = 4'b0000;
                endcase
            end

            // ALUOp = 11: tipo I com operação específica (andi, ori, xori, slti, sltiu, lui)
            2'b11: begin
                case (opcode)
                    OP_ANDI:  ulaOP = 4'b0010; // andi → AND
                    OP_ORI:   ulaOP = 4'b0011; // ori  → OR
                    OP_XORI:  ulaOP = 4'b0100; // xori → XOR
                    OP_SLTI:  ulaOP = 4'b0110; // slti → SLT (signed)
                    OP_SLTIU: ulaOP = 4'b0111; // sltiu → SLTU (unsigned)
                    OP_LUI:   ulaOP = 4'b1011; // lui  → LUI
                    default:  ulaOP = 4'b0000;
                endcase
            end

            default: ulaOP = 4'b0000;
        endcase
    end

endmodule
