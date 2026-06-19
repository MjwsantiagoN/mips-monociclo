// ============================================================
// Grupo: --
// Atividade: Projeto 02 - 2VA
// Disciplina: Arquitetura e Organização de Computadores
// Semestre: 2025.2
// Arquivo: mips.v
// Descrição: Módulo top-level do núcleo MIPS monociclo.
//            Integra todos os submódulos (PC, i_mem, regfile,
//            ULA, d_mem, ctrl, ula_ctrl) e os elementos
//            combinacionais do datapath (somadores, MUXes,
//            extensores, shift). Suporta todas as instruções
//            R, I e J especificadas no projeto.
//
//  Interface:
//    clock     – sinal de clock externo
//    reset     – reseta o regfile (todos os registradores = 0)
//    PC_out    – valor atual do PC
//    ula_out   – valor atual da saída da ULA
//    mem_out   – valor atual da saída da memória de dados
//
//  Compilação (Icarus Verilog):
//    iverilog -g2012 -o mips_sim \
//      pc.v i_mem.v d_mem.v regfile.v ula.v ula_ctrl.v ctrl.v \
//      adder.v mux2.v mux4.v mux2_5bit.v mux4_5bit.v \
//      signExtend.v zeroExtend.v shiftLeft2.v mips.v <testbench.v>
// ============================================================

module mips (
    input        clock,
    input        reset,
    output [31:0] PC_out,
    output [31:0] ula_out,
    output [31:0] mem_out
);

    // --------------------------------------------------------
    // Fios internos do datapath
    // --------------------------------------------------------
    wire [31:0] PC;
    wire [31:0] nextPC;
    wire [31:0] PC_plus4;
    wire [31:0] PC_plus8;

    // Campos da instrução
    wire [31:0] instruction;
    wire [5:0]  opcode  = instruction[31:26];
    wire [4:0]  rs      = instruction[25:21];
    wire [4:0]  rt      = instruction[20:16];
    wire [4:0]  rd      = instruction[15:11];
    wire [4:0]  shamt   = instruction[10:6];
    wire [5:0]  funct   = instruction[5:0];
    wire [15:0] imm16   = instruction[15:0];
    wire [25:0] jAddr   = instruction[25:0];

    // Imediatos extendidos
    wire [31:0] signExtImm;
    wire [31:0] zeroExtImm;
    wire [31:0] branchOffset;

    // Regfile
    wire [4:0]  writeAddr;
    wire [31:0] readData1;
    wire [31:0] readData2;
    wire [31:0] writeData;

    // ULA
    wire [31:0] ulaIn1;
    wire [31:0] ulaIn2;
    wire [31:0] ulaResult;
    wire        zeroFlag;
    wire [3:0]  ulaOP;

    // Memória de dados
    wire [31:0] memReadData;

    // Sinais de controle
    wire [1:0]  regDst;
    wire [1:0]  aluSrc;
    wire [1:0]  memToReg;
    wire        regWrite;
    wire        memRead;
    wire        memWrite;
    wire        branch;
    wire        branchNE;
    wire [1:0]  aluOp;
    wire        jump;
    wire        jal;
    wire        jumpReg;

    // Próximo PC
    wire        takeBranch;
    wire        takeBranchNE;
    wire [31:0] branchTarget;
    wire [31:0] jumpTarget;
    wire [31:0] pcBranchMux;
    wire [31:0] pcJumpMux;

    // --------------------------------------------------------
    // Saídas
    // --------------------------------------------------------
    assign PC_out  = PC;
    assign ula_out = ulaResult;
    assign mem_out = memReadData;

    // --------------------------------------------------------
    // PC
    // --------------------------------------------------------
    pc u_pc (
        .clock  (clock),
        .reset  (reset),
        .nextPC (nextPC),
        .PC     (PC)
    );

    adder u_add_pc4 (
        .a      (PC),
        .b      (32'd4),
        .result (PC_plus4)
    );

    adder u_add_pc8 (
        .a      (PC_plus4),
        .b      (32'd4),
        .result (PC_plus8)
    );

    // --------------------------------------------------------
    // Memória de instrução
    // --------------------------------------------------------
    i_mem u_imem (
        .address (PC),
        .i_out   (instruction)
    );

    // --------------------------------------------------------
    // Unidade de controle
    // --------------------------------------------------------
    ctrl u_ctrl (
        .opcode   (opcode),
        .funct    (funct),
        .regDst   (regDst),
        .aluSrc   (aluSrc),
        .memToReg (memToReg),
        .regWrite (regWrite),
        .memRead  (memRead),
        .memWrite (memWrite),
        .branch   (branch),
        .branchNE (branchNE),
        .aluOp    (aluOp),
        .jump     (jump),
        .jal      (jal),
        .jumpReg  (jumpReg)
    );

    // --------------------------------------------------------
    // Extensores de imediato
    // --------------------------------------------------------
    signExtend u_signext (
        .in  (imm16),
        .out (signExtImm)
    );

    zeroExtend u_zeroext (
        .in  (imm16),
        .out (zeroExtImm)
    );

    shiftLeft2 u_shift_branch (
        .in  (signExtImm),
        .out (branchOffset)
    );

    // --------------------------------------------------------
    // Banco de registradores
    // --------------------------------------------------------
    // MUX 4:1 de 5 bits: 00→$rt, 01→$rd, 10→$31 (jal)
    mux4_5bit u_mux_regdst (
        .in0    (rt),
        .in1    (rd),
        .in2    (5'd31),
        .in3    (5'd0),
        .select (regDst),
        .out    (writeAddr)
    );

    regfile u_regfile (
        .clock     (clock),
        .reset     (reset),
        .regWrite  (regWrite),
        .readAddr1 (rs),
        .readAddr2 (rt),
        .writeAddr (writeAddr),
        .writeData (writeData),
        .readData1 (readData1),
        .readData2 (readData2)
    );

    // --------------------------------------------------------
    // ULA
    // --------------------------------------------------------
    // in1: shamt para sll/srl/sra com campo shamt fixo; R[$rs] nos demais
    assign ulaIn1 = ((aluOp == 2'b10) &&
                     ((funct == 6'b000000) ||  // sll
                      (funct == 6'b000010) ||  // srl
                      (funct == 6'b000011)))   // sra
                    ? {27'b0, shamt}
                    : readData1;

    // in2: MUX 4:1 → 00=R[$rt], 01=SignExt(imm), 10=ZeroExt(imm), 11=R[$rt]
    mux4 u_mux_alusrc (
        .in0    (readData2),
        .in1    (signExtImm),
        .in2    (zeroExtImm),
        .in3    (readData2),
        .select (aluSrc),
        .out    (ulaIn2)
    );

    ula_ctrl u_ula_ctrl (
        .aluOp  (aluOp),
        .funct  (funct),
        .opcode (opcode),
        .ulaOP  (ulaOP)
    );

    ula u_ula (
        .in1      (ulaIn1),
        .in2      (ulaIn2),
        .op       (ulaOP),
        .result   (ulaResult),
        .zeroFlag (zeroFlag)
    );

    // --------------------------------------------------------
    // Memória de dados
    // --------------------------------------------------------
    d_mem u_dmem (
        .address   (ulaResult),
        .writeData (readData2),
        .readData  (memReadData),
        .memWrite  (memWrite),
        .memRead   (memRead)
    );

    // --------------------------------------------------------
    // MUX MemToReg: 00=ULA, 01=Mem, 10=PC+8 (jal)
    // --------------------------------------------------------
    mux4 u_mux_memtoreg (
        .in0    (ulaResult),
        .in1    (memReadData),
        .in2    (PC_plus8),
        .in3    (32'b0),
        .select (memToReg),
        .out    (writeData)
    );

    // --------------------------------------------------------
    // Lógica de próximo PC
    // --------------------------------------------------------
    adder u_add_branch (
        .a      (PC_plus4),
        .b      (branchOffset),
        .result (branchTarget)
    );

    assign jumpTarget    = {PC_plus4[31:28], jAddr, 2'b00};
    assign takeBranch    = branch   & zeroFlag;
    assign takeBranchNE  = branchNE & (~zeroFlag);

    // MUX 1: branch
    mux2 u_mux_branch (
        .in0    (PC_plus4),
        .in1    (branchTarget),
        .select (takeBranch | takeBranchNE),
        .out    (pcBranchMux)
    );

    // MUX 2: jump (j / jal)
    mux2 u_mux_jump (
        .in0    (pcBranchMux),
        .in1    (jumpTarget),
        .select (jump),
        .out    (pcJumpMux)
    );

    // MUX 3: jr
    mux2 u_mux_jr (
        .in0    (pcJumpMux),
        .in1    (readData1),
        .select (jumpReg),
        .out    (nextPC)
    );

endmodule
