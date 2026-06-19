<<<<<<< HEAD
module pc (
    input clock,
    input [31:0] nextPC,
    output reg [31:0] PC
);

// Garante que o PC começa em zero
initial begin
    PC = 32'h00000000;
end

// Executa somente na borda de subida do clock
always @(posedge clock) begin
    PC <= nextPC;
end

endmodule
=======
// ============================================================
// Grupo: --
// Atividade: Projeto 02 - 2VA
// Disciplina: Arquitetura e Organização de Computadores
// Semestre: 2025.2
// Arquivo: pc.v
// Descrição: Contador de Programa (Program Counter).
//            Registrador síncrono que armazena o endereço
//            da instrução atual. Atualiza na borda de subida
//            do clock. O sinal de reset (ativo em 1) força
//            o PC a 0x00000000 sincronamente.
// ============================================================

module pc (
    input        clock,
    input        reset,
    input  [31:0] nextPC,
    output reg [31:0] PC
);

    initial begin
        PC = 32'h00000000;
    end

    always @(posedge clock) begin
        if (reset)
            PC <= 32'h00000000;
        else
            PC <= nextPC;
    end

endmodule
>>>>>>> feat/complete-mips-implementation
