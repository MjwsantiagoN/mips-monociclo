// ============================================================
// Grupo: --
// Atividade: Projeto 02 - 2VA
// Disciplina: Arquitetura e Organização de Computadores
// Semestre: 2025.2
// Arquivo: tb_imem.v
// Descrição: Testbench da memória de instrução.
//  Compilação: cd hardware/ && iverilog -g2012 -o sim i_mem.v ../tests/tb_imem.v && vvp sim
// ============================================================

module tb_imem;
    reg  [31:0] address;
    wire [31:0] i_out;
    i_mem #(.MEM_SIZE(256)) uut (.address(address), .i_out(i_out));
    integer i;
    initial begin
        $display("=== Testbench i_mem ===");
        for (i = 0; i < 8; i = i + 1) begin
            address = i * 4; #10;
            $display("address=0x%08h -> i_out=0x%08h", address, i_out);
        end
        $display("=== Fim ==="); $finish;
    end
endmodule
