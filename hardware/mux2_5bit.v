// ============================================================
// Grupo: Marcos José e Josué Costa
// Atividade: Projeto 02 - 2VA
// Disciplina: Arquitetura e Organização de Computadores
// Semestre: 2025.2
// Arquivo: mux2_5bit.v
// Descrição: Multiplexador 2:1 de 5 bits, utilizado para
//            selecionar o endereço de destino no regfile
//            (ex: entre $rt e $rd).
// ============================================================

module mux2_5bit (
    input  [4:0] in0,
    input  [4:0] in1,
    input        select,
    output [4:0] out
);

    assign out = select ? in1 : in0;

endmodule
