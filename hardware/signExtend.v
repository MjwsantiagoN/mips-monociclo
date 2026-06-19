// ============================================================
// Grupo: Marcos José e Josué Costa
// Descrição: Módulo de extensão de sinal.
//            Converte um valor de 16 bits para 32 bits,
//            preservando o bit de sinal.
// ============================================================

module signExtend (

    input  [15:0] in,
    output [31:0] out
);

assign out = {{16{in[15]}}, in};

endmodule
