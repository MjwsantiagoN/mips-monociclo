// ============================================================
// Grupo: --
// Atividade: Projeto 02 - 2VA
// Disciplina: Arquitetura e Organização de Computadores
// Semestre: 2025.2
// Arquivo: tb_ula_ctrl.v
// Compilação: cd hardware/ && iverilog -g2012 -o sim ula_ctrl.v ../tests/tb_ula_ctrl.v && vvp sim
// ============================================================

module tb_ula_ctrl;
    reg [1:0] aluOp; reg [5:0] funct,opcode; wire [3:0] ulaOP;
    ula_ctrl uut(.aluOp(aluOp),.funct(funct),.opcode(opcode),.ulaOP(ulaOP));
    task show; input [79:0] n; begin
        $display("%-10s aluOp=%b funct=%b op=%b -> ulaOP=%b(%0d)",n,aluOp,funct,opcode,ulaOP,ulaOP);
    end endtask
    initial begin
        $display("=== Testbench ula_ctrl ==="); opcode=0;
        aluOp=2'b00; funct=6'bx; #10; show("lw/sw/addi");
        aluOp=2'b01; funct=6'bx; #10; show("beq/bne");
        aluOp=2'b10;
        funct=6'b100000;#10;show("add"); funct=6'b100010;#10;show("sub");
        funct=6'b100100;#10;show("and"); funct=6'b100101;#10;show("or");
        funct=6'b100110;#10;show("xor"); funct=6'b100111;#10;show("nor");
        funct=6'b101010;#10;show("slt"); funct=6'b101011;#10;show("sltu");
        funct=6'b000000;#10;show("sll"); funct=6'b000010;#10;show("srl");
        funct=6'b000011;#10;show("sra"); funct=6'b000100;#10;show("sllv");
        aluOp=2'b11; funct=0;
        opcode=6'b001100;#10;show("andi"); opcode=6'b001101;#10;show("ori");
        opcode=6'b001110;#10;show("xori"); opcode=6'b001010;#10;show("slti");
        opcode=6'b001011;#10;show("sltiu"); opcode=6'b001111;#10;show("lui");
        $display("=== Fim ==="); $finish;
    end
endmodule
