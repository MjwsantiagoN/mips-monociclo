// ============================================================
// Grupo: --
// Atividade: Projeto 02 - 2VA
// Disciplina: Arquitetura e Organização de Computadores
// Semestre: 2025.2
// Arquivo: mux4.v
// Descrição: Multiplexador 4:1 de 32 bits. Utilizado para
//            selecionar entre múltiplas fontes de dados,
//            como as entradas da ULA (ALUSrc) ou o dado a
//            ser escrito no regfile (MemToReg).
// ============================================================

module mux4 (
    input  [31:0] in0,
    input  [31:0] in1,
    input  [31:0] in2,
    input  [31:0] in3,
    input  [1:0]  select,
    output [31:0] out
);

    assign out = (select == 2'b00) ? in0 :
                 (select == 2'b01) ? in1 :
                 (select == 2'b10) ? in2 : in3;

endmodule
