// ============================================================
// Grupo: Marcos José e Josué Costa
// Atividade: Projeto 02 - 2VA
// Disciplina: Arquitetura e Organização de Computadores
// Semestre: 2025.2
// Arquivo: tb_mips.v
// Descrição: Testbench de integração do núcleo MIPS monociclo.
//            Verificações baseadas no projeto2_codigo_teste.asm
//
//  Compilação:
//    cd hardware/
//    iverilog -g2012 -o sim *.v ../tests/tb_mips.v && vvp sim
// ============================================================

module tb_mips;

    reg clock;
    reg reset;

    wire [31:0] PC_out;
    wire [31:0] ula_out;
    wire [31:0] mem_out;

    mips uut (
        .clock   (clock),
        .reset   (reset),
        .PC_out  (PC_out),
        .ula_out (ula_out),
        .mem_out (mem_out)
    );

    always #10 clock = ~clock;

    integer cycle;
	
	reg [31:0] test5_t3;
	reg [31:0] test6_j;
	reg [31:0] test7_jaljr;
	reg [31:0] ra_snapshot;

    initial begin
        $display("=== Testbench MIPS Monociclo ===");
        $display("%-6s %-10s %-10s %-10s", "Ciclo", "PC", "ULA_out", "Mem_out");
        $display("----------------------------------------------");

        clock = 0;
        reset = 1;
        cycle = 0;

        @(posedge clock); #1;
        reset = 0;

        // Executa ciclos suficientes para cobrir os 7 testes
        repeat (70) begin
			@(posedge clock); #1;
			cycle = cycle + 1;

			$display("%-6d 0x%08h 0x%08h 0x%08h",
				cycle, PC_out, ula_out, mem_out);

			// Teste 5 - LW/SW
			if (cycle == 56)
				test5_t3 = uut.u_regfile.registers[11];

			// Teste 6 - J
			if (cycle == 61)
				test6_j = uut.u_regfile.registers[8];

			// Teste 7 - JAL/JR
			if (cycle == 64) begin
				test7_jaljr = uut.u_regfile.registers[8];
				ra_snapshot = uut.u_regfile.registers[31];
			end
		end

        $display("\n=== Estado final dos registradores ===");

        // Teste 1 - ADD, SUB, ADDI, AND, OR, XOR, NOR
        // $s0=20, $s1=15 -> add=$t0=35, sub=$t1=5, addi=$t2=40
        // and=$t3=4, or=$t4=31, xor=$t5=27
        $display("--- Teste 1: ADD, SUB, ADDI, AND, OR, XOR, NOR ---");
        $display("$t0 (8)  = %0d  (esperado: 35 - add 20+15)",  uut.u_regfile.registers[8]);
        $display("$t1 (9)  = %0d  (esperado: 5  - sub 20-15)",  uut.u_regfile.registers[9]);
        $display("$t2 (10) = %0d  (esperado: 40 - addi 20+20)", uut.u_regfile.registers[10]);
        $display("$t3 (11) = %0d  (esperado: 4  - and 20&15)",  uut.u_regfile.registers[11]);
        $display("$t4 (12) = %0d  (esperado: 31 - or  20|15)",  uut.u_regfile.registers[12]);
        $display("$t5 (13) = %0d  (esperado: 27 - xor 20^15)", uut.u_regfile.registers[13]);

        // Teste 5 - LW e SW
        $display("--- Teste 5: LW e SW ---");
        $display("$t3 (11) = %0d  (esperado: 30 - add lw[12]+lw[16])", uut.u_regfile.registers[11]);
        $display("$t0 (8)  = %0d  (esperado: 100 - add t3+t4)",         uut.u_regfile.registers[8]);

        // Teste 6 - Jump
		$display("--- Teste 6: J ---");
		$display("$8 (8) = %0d (esperado: 1 - addi apos jump)", test6_j);

        $display("\n=== Verificacoes automaticas ===");

        // Verificações teste 1 (estado intermediário — difícil checar no final)
        // Verificações teste 5
        if (test5_t3 === 32'd30)
			$display("PASS: $t3 = 30 (lw+sw funcionando)");
		else
			$display("FAIL: $t3 = %0d (esperado 30)", test5_t3);

        if (test6_j === 32'd1)
			$display("PASS: $8 = 1 (jump funcionando)");
		else
			$display("FAIL: $8 = %0d (esperado 1 apos jump)", test6_j);

        $display("--- Teste 7: JAL/JR ---");
		$display("$ra (31) = 0x%08h", ra_snapshot);
		$display("$8  (8)  = 0x%08h", test7_jaljr);

		if (test7_jaljr == ra_snapshot)
			$display("PASS: JAL/JR funcionando");
		else
			$display("FAIL: JAL/JR");

        $display("\n=== Fim do testbench MIPS ===");
        $finish;
    end

endmodule
