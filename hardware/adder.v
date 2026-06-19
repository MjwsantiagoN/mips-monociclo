// ============================================================
// Grupo: Marcos José e Josué Costa
// Descrição: Somador de 32 bits utilizado para realizar
//            operações de incremento e cálculo de endereços,
//            como PC+4, PC+8 e endereços de branch.
// ============================================================

module adder(

    input [31:0] a,
    input [31:0] b,
    output [31:0] result
);

assign result = a + b;

endmodule
