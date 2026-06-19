// ============================================================
// Grupo: --
// Atividade: Projeto 02 - 2VA
// Disciplina: Arquitetura e Organização de Computadores
// Semestre: 2025.2
// Arquivo: i_mem.v
// Descrição: Memória de instrução (ROM) assíncrona com tamanho
//            parametrizável. As instruções são carregadas a
//            partir do arquivo externo "instruction.list",
//            onde cada linha contém uma instrução em binário.
// ============================================================

module i_mem #(
    parameter MEM_SIZE = 64  // Número de palavras de 32 bits
)(
    input  [31:0] address,    // Endereço fornecido pelo PC
    output [31:0] i_out       // Instrução lida (saída combinacional)
);

    // Memória ROM: MEM_SIZE palavras de 32 bits
    reg [31:0] mem [0:MEM_SIZE-1];

    // Carrega instruções do arquivo externo na inicialização
    initial begin
        $readmemb("instruction.list", mem);
    end

    // Leitura assíncrona: endereço em bytes → índice de palavra (÷ 4)
    assign i_out = mem[address[31:2]];

endmodule
