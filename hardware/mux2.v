// ============================================================
// Grupo: Marcos José e Josué Costa
// Descrição: Multiplexador 2:1 de 32 bits.
//            Seleciona uma entre duas entradas de 32 bits
//            de acordo com um sinal de controle.
// ============================================================

module mux2(
    input [31:0] in0,
    input [31:0] in1,
    input select,
    output [31:0] out
);

assign out = select ? in1 : in0;

endmodule
