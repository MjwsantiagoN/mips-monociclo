// ============================================================
// Grupo: --
// Atividade: Projeto 02 - 2VA
// Disciplina: Arquitetura e Organização de Computadores
// Semestre: 2025.2
// Arquivo: tb_dmem.v
// Descrição: Testbench da memória de dados.
//  Compilação: cd hardware/ && iverilog -g2012 -o sim d_mem.v ../tests/tb_dmem.v && vvp sim
// ============================================================

module tb_dmem;
    reg  [31:0] address, writeData;
    wire [31:0] readData;
    reg  memWrite, memRead;
    d_mem #(.MEM_SIZE(256)) uut(.address(address),.writeData(writeData),
        .readData(readData),.memWrite(memWrite),.memRead(memRead));
    initial begin
        $display("=== Testbench d_mem ===");
        memWrite=0; memRead=0; address=0; writeData=0; #10;
        // Escreve 0xDEADBEEF em 0x00
        address=0; writeData=32'hDEADBEEF; memWrite=1; memRead=0; #10; memWrite=0;
        memRead=1; #10; $display("Leu 0x%08h (esperado 0xDEADBEEF)", readData);
        // Alta impedância
        memRead=0; #10; $display("MemRead=0: readData=0x%08h (esperado z)", readData);
        // Escreve 0xCAFEBABE em 0x08
        address=8; writeData=32'hCAFEBABE; memWrite=1; #10; memWrite=0;
        memRead=1; address=0; #10; $display("Leu end.0: 0x%08h (esperado 0xDEADBEEF)", readData);
        address=8; #10; $display("Leu end.8: 0x%08h (esperado 0xCAFEBABE)", readData);
        $display("=== Fim ==="); $finish;
    end
endmodule
