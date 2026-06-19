// ============================================================
// Grupo: Marcos José e Josué Costa
// Descrição: Comparador utilizado para verificar a relação
//            entre dois operandos, auxiliando em operações
//            de comparação e instruções condicionais.
// ============================================================

module comparator(

    input [31:0] a,
    input [31:0] b,
    output equal
);

assign equal = (a == b);

endmodule
