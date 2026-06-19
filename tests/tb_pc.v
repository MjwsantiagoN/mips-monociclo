// ============================================================
// Grupo: Marcos José e Josué Costa
// Atividade: Projeto 02 - 2VA
// Disciplina: Arquitetura e Organização de Computadores
// Semestre: 2025.2
// Arquivo: tb_pc.v
// Descrição: Testbench do Contador de Programa (pc).
//            Verifica a inicialização em zero, o reset
//            síncrono e a atualização correta do PC a
//            cada borda de subida do clock.
// ============================================================

module tb_pc;

reg clock;
reg reset;
reg [31:0] nextPC;
wire [31:0] PC;

pc uut (
    .clock  (clock),
    .reset  (reset),
    .nextPC (nextPC),
    .PC     (PC)
);

initial begin
    $display("=== Testbench PC ===");
    clock  = 0;
    reset  = 1;
    nextPC = 32'h00000004;
    #10;
    $display("reset=1: PC=0x%08h (esperado 0x00000000)", PC);
    reset  = 0;
    nextPC = 32'h00000004;
    #10; $display("nextPC=4:  PC=0x%08h (esperado 0x00000004)", PC);
    nextPC = 32'h00000008;
    #10; $display("nextPC=8:  PC=0x%08h (esperado 0x00000008)", PC);
    nextPC = 32'h0000000C;
    #10; $display("nextPC=12: PC=0x%08h (esperado 0x0000000C)", PC);
    // Testa reset no meio da execução
    reset  = 1; nextPC = 32'hDEADBEEF;
    #10; $display("reset=1:   PC=0x%08h (esperado 0x00000000)", PC);
    $display("=== Fim ===");
    $finish;

end

always #5 clock = ~clock;

endmodule
