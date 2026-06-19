// ============================================================
// Grupo: Marcos José e Josué Costa
// Descrição: Módulo de extensão com zero.
//            Converte um valor de 16 bits para 32 bits,
//            preenchendo os bits mais significativos com zero.
// ============================================================

module zeroExtend (

    input  [15:0] in,
    output [31:0] out
);

assign out = {16'b0, in};

endmodule
