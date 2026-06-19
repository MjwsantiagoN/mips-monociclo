// ============================================================
// Grupo: --
// Atividade: Projeto 02 - 2VA
// Disciplina: Arquitetura e Organização de Computadores
// Semestre: 2025.2
// Arquivo: ctrl.v
// Descrição: Unidade de controle principal do MIPS monociclo.
//            Recebe o opcode [31:26] da instrução e o campo
//            funct [5:0] (necessário para detectar jr).
//            Gera todos os sinais de controle do datapath.
//
//  Sinais de saída:
//   regDst    [1:0] – seleção do reg. destino: 00=$rt, 01=$rd, 10=$31
//   aluSrc    [1:0] – fonte do operando 2 da ULA:
//                     00=ReadData2, 01=SignExt(imm), 10=ZeroExt(imm),
//                     11=shamt (para sll/srl/sra)
//   memToReg  [1:0] – fonte do WriteData do regfile:
//                     00=resultado ULA, 01=readData mem, 10=PC+8 (jal)
//   regWrite      – habilita escrita no regfile
//   memRead       – habilita leitura na memória de dados
//   memWrite      – habilita escrita na memória de dados
//   branch        – sinal de branch (beq)
//   branchNE      – sinal de branch (bne)
//   aluOp  [1:0]  – código para ula_ctrl
//   jump          – instrução j ou jal
//   jal           – instrução jal (salva PC+8 em $ra)
//   jumpReg       – instrução jr (PC = R[$rs])
//   luiSel        – indica LUI (imm vai como in2 da ULA)
// ============================================================

module ctrl (
    input  [5:0] opcode,     // Instruction[31:26]
    input  [5:0] funct,      // Instruction[5:0]  (para jr)

    output reg [1:0] regDst,
    output reg [1:0] aluSrc,
    output reg [1:0] memToReg,
    output reg       regWrite,
    output reg       memRead,
    output reg       memWrite,
    output reg       branch,
    output reg       branchNE,
    output reg [1:0] aluOp,
    output reg       jump,
    output reg       jal,
    output reg       jumpReg
);

    // Opcodes MIPS padrão
    localparam OP_RTYPE = 6'b000000;
    localparam OP_J     = 6'b000010;
    localparam OP_JAL   = 6'b000011;
    localparam OP_ADDI  = 6'b001000;
    localparam OP_ADDIU = 6'b001001;
    localparam OP_ANDI  = 6'b001100;
    localparam OP_ORI   = 6'b001101;
    localparam OP_XORI  = 6'b001110;
    localparam OP_SLTI  = 6'b001010;
    localparam OP_SLTIU = 6'b001011;
    localparam OP_LUI   = 6'b001111;
    localparam OP_LW    = 6'b100011;
    localparam OP_SW    = 6'b101011;
    localparam OP_BEQ   = 6'b000100;
    localparam OP_BNE   = 6'b000101;

    // funct de jr
    localparam FUNCT_JR = 6'b001000;

    always @(*) begin

        // Valores padrão (NOP seguro)
        regDst   = 2'b00;
        aluSrc   = 2'b00;
        memToReg = 2'b00;
        regWrite = 1'b0;
        memRead  = 1'b0;
        memWrite = 1'b0;
        branch   = 1'b0;
        branchNE = 1'b0;
        aluOp    = 2'b00;
        jump     = 1'b0;
        jal      = 1'b0;
        jumpReg  = 1'b0;

        case (opcode)

            // --------------------------------------------------
            // Tipo R: add, sub, and, or, xor, nor, slt, sltu,
            //         sll, srl, sra, sllv, srlv, srav, jr
            // --------------------------------------------------
            OP_RTYPE: begin
                if (funct == FUNCT_JR) begin
                    // jr: pula para R[$rs], não escreve nada
                    jumpReg  = 1'b1;
                    regWrite = 1'b0;
                end else begin
                    regDst   = 2'b01; // destino = $rd
                    aluSrc   = 2'b00; // operando 2 = ReadData2
                    memToReg = 2'b00; // write back = resultado ULA
                    regWrite = 1'b1;
                    aluOp    = 2'b10; // decodifica pelo funct
                end
            end

            // --------------------------------------------------
            // addi / addiu: $rt = $rs + SignExt(imm)
            // --------------------------------------------------
            OP_ADDI,
            OP_ADDIU: begin
                regDst   = 2'b00; // destino = $rt
                aluSrc   = 2'b01; // operando 2 = SignExt(imm)
                memToReg = 2'b00;
                regWrite = 1'b1;
                aluOp    = 2'b00; // ADD
            end

            // --------------------------------------------------
            // andi: $rt = $rs & ZeroExt(imm)
            // --------------------------------------------------
            OP_ANDI: begin
                regDst   = 2'b00;
                aluSrc   = 2'b10; // operando 2 = ZeroExt(imm)
                memToReg = 2'b00;
                regWrite = 1'b1;
                aluOp    = 2'b11; // decodifica pelo opcode (AND)
            end

            // --------------------------------------------------
            // ori: $rt = $rs | ZeroExt(imm)
            // --------------------------------------------------
            OP_ORI: begin
                regDst   = 2'b00;
                aluSrc   = 2'b10; // ZeroExt(imm)
                memToReg = 2'b00;
                regWrite = 1'b1;
                aluOp    = 2'b11; // OR
            end

            // --------------------------------------------------
            // xori: $rt = $rs ^ ZeroExt(imm)
            // --------------------------------------------------
            OP_XORI: begin
                regDst   = 2'b00;
                aluSrc   = 2'b10; // ZeroExt(imm)
                memToReg = 2'b00;
                regWrite = 1'b1;
                aluOp    = 2'b11; // XOR
            end

            // --------------------------------------------------
            // slti: $rt = $rs < SignExt(imm)  (signed)
            // --------------------------------------------------
            OP_SLTI: begin
                regDst   = 2'b00;
                aluSrc   = 2'b01; // SignExt(imm)
                memToReg = 2'b00;
                regWrite = 1'b1;
                aluOp    = 2'b11; // SLT via opcode
            end

            // --------------------------------------------------
            // sltiu: $rt = $rs < SignExt(imm)  (unsigned)
            // --------------------------------------------------
            OP_SLTIU: begin
                regDst   = 2'b00;
                aluSrc   = 2'b01; // SignExt(imm)
                memToReg = 2'b00;
                regWrite = 1'b1;
                aluOp    = 2'b11; // SLTU via opcode
            end

            // --------------------------------------------------
            // lui: $rt = {imm, 16'b0}
            // --------------------------------------------------
            OP_LUI: begin
                regDst   = 2'b00;
                aluSrc   = 2'b10; // imediato (ZeroExt, mas ULA faz LUI)
                memToReg = 2'b00;
                regWrite = 1'b1;
                aluOp    = 2'b11; // LUI via opcode
            end

            // --------------------------------------------------
            // lw: $rt = D_mem[$rs + SignExt(imm)]
            // --------------------------------------------------
            OP_LW: begin
                regDst   = 2'b00;
                aluSrc   = 2'b01; // SignExt(imm)
                memToReg = 2'b01; // write back = leitura da memória
                regWrite = 1'b1;
                memRead  = 1'b1;
                aluOp    = 2'b00; // ADD (cálculo de endereço)
            end

            // --------------------------------------------------
            // sw: D_mem[$rs + SignExt(imm)] = $rt
            // --------------------------------------------------
            OP_SW: begin
                aluSrc   = 2'b01; // SignExt(imm)
                memWrite = 1'b1;
                aluOp    = 2'b00; // ADD (cálculo de endereço)
            end

            // --------------------------------------------------
            // beq: if ($rs == $rt) PC = PC+4 + SignExt(imm)<<2
            // --------------------------------------------------
            OP_BEQ: begin
                aluSrc = 2'b00;
                branch = 1'b1;
                aluOp  = 2'b01; // SUB (zeroFlag indica igualdade)
            end

            // --------------------------------------------------
            // bne: if ($rs != $rt) PC = PC+4 + SignExt(imm)<<2
            // --------------------------------------------------
            OP_BNE: begin
                aluSrc   = 2'b00;
                branchNE = 1'b1;
                aluOp    = 2'b01; // SUB (zeroFlag=0 indica diferença)
            end

            // --------------------------------------------------
            // j: PC = {PC+4[31:28], address, 00}
            // --------------------------------------------------
            OP_J: begin
                jump = 1'b1;
            end

            // --------------------------------------------------
            // jal: R[31] = PC+8; PC = {PC+4[31:28], address, 00}
            // --------------------------------------------------
            OP_JAL: begin
                jump     = 1'b1;
                jal      = 1'b1;
                regDst   = 2'b10; // destino = $31
                memToReg = 2'b10; // write back = PC+8
                regWrite = 1'b1;
            end

            default: begin
                // Instrução desconhecida: NOP (todos sinais já no padrão)
            end

        endcase
    end

endmodule
