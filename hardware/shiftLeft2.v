// ============================================================
// Grupo: Marcos José e Josué Costa
// Descrição: Módulo responsável por deslocar um valor
//            2 bits para a esquerda.
//            Utilizado no cálculo dos endereços de branch.
// ============================================================

module shiftLeft2 (

    input  [31:0] in,
    output [31:0] out
);

assign out = in << 2;

endmodule
