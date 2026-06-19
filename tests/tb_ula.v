// ============================================================
// Grupo: Marcos José e Josué Costa
// Atividade: Projeto 02 - 2VA
// Disciplina: Arquitetura e Organização de Computadores
// Semestre: 2025.2
// Arquivo: tb_ula.v
// Descrição: Testbench da Unidade Lógica e Aritmética (ULA).
//            Verifica as operações aritméticas, lógicas,
//            comparações, deslocamentos e a geração do
//            sinal zeroFlag.
//
//  Compilação:
//    cd hardware/
//    iverilog -g2012 -o sim *.v ../tests/tb_ula.v && vvp sim
// ============================================================

module tb_ula;

    reg [31:0] in1;
    reg [31:0] in2;
    reg [3:0] op;

    wire [31:0] result;
    wire zeroFlag;

    // Instancia a ULA
    ula uut (

        .in1(in1),
        .in2(in2),
        .op(op),

        .result(result),
        .zeroFlag(zeroFlag)

    );

    initial begin

        // 10 + 20 = 30
        in1 = 32'd10;
        in2 = 32'd20;
        op  = 4'b0000;

        #10;

        // 20 - 10 = 10
        in1 = 32'd20;
        in2 = 32'd10;
        op  = 4'b0001;

        #10;

        // 15 - 15 = zeroFlag
        in1 = 32'd15;
        in2 = 32'd15;
        op  = 4'b0001;

        #10;

        // 12 & 10 = 8
        in1 = 32'd12;
        in2 = 32'd10;
        op  = 4'b0010;

        #10;

        // 12 | 10 = 14
        op = 4'b0011;

        #10;

        // 12 ^ 10 = 6
        op = 4'b0100;

        #10;

        // ~(12 | 10) = 1 [NOR]
        op = 4'b0101;

        #10;

        // -5 < 3 (com sinal)
        in1 = -32'd5;
        in2 = 32'd3;
        op  = 4'b0110;

        #10;
		  
		  // 5 < 3 (sem sinal)
        in1 = 32'd5;
        in2 = 32'd10;
        op  = 4'b0111;

        #10;

        // 3 << 2 = 12 (sll)
        in1 = 32'd2;
        in2 = 32'd3;
        op  = 4'b1000;

        #10;

        // 16 >> 2 = 4 (srl)
        in1 = 32'd2;
        in2 = 32'd16;
        op  = 4'b1001;

        #10;

        // -16 >>> 2 = -4 (sra)
        in1 = 32'd2;
        in2 = -32'd16;
        op  = 4'b1010;

        #10;

        $finish;

    end

endmodule
