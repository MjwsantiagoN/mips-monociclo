// ============================================================
// Grupo: --
// Atividade: Projeto 02 - 2VA
// Disciplina: Arquitetura e Organização de Computadores
// Semestre: 2025.2
// Arquivo: mux4_5bit.v
// Descrição: Multiplexador 4:1 de 5 bits. Utilizado para
//            selecionar o registrador destino (WriteAddr)
//            no regfile:
//              00 → $rt  (instruções tipo I)
//              01 → $rd  (instruções tipo R)
//              10 → $31  (instrução jal)
//              11 → não utilizado (reservado)
// ============================================================

module mux4_5bit (
    input  [4:0] in0,
    input  [4:0] in1,
    input  [4:0] in2,
    input  [4:0] in3,
    input  [1:0] select,
    output [4:0] out
);

    assign out = (select == 2'b00) ? in0 :
                 (select == 2'b01) ? in1 :
                 (select == 2'b10) ? in2 : in3;

endmodule
