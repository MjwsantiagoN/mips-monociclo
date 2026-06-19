// ============================================================
// Grupo: Marcos José e Josué Costa
// Atividade: Projeto 02 - 2VA
// Disciplina: Arquitetura e Organização de Computadores
// Semestre: 2025.2
// Arquivo: tb_ctrl.v
// Compilação: cd hardware/ && iverilog -g2012 -o sim ctrl.v ../tests/tb_ctrl.v && vvp sim
// ============================================================

module tb_ctrl;
    reg [5:0] opcode, funct;
    wire [1:0] regDst,aluSrc,memToReg,aluOp;
    wire regWrite,memRead,memWrite,branch,branchNE,jump,jal,jumpReg;
    ctrl uut(.opcode(opcode),.funct(funct),.regDst(regDst),.aluSrc(aluSrc),
        .memToReg(memToReg),.regWrite(regWrite),.memRead(memRead),
        .memWrite(memWrite),.branch(branch),.branchNE(branchNE),
        .aluOp(aluOp),.jump(jump),.jal(jal),.jumpReg(jumpReg));
    task show; input [63:0] n; begin
        $display("%-8s rDst=%b aSrc=%b mToR=%b rW=%b mR=%b mW=%b br=%b bNE=%b aOp=%b j=%b jal=%b jr=%b",
            n,regDst,aluSrc,memToReg,regWrite,memRead,memWrite,branch,branchNE,aluOp,jump,jal,jumpReg);
    end endtask
    initial begin
        $display("=== Testbench ctrl ===");
        funct=0;
        opcode=6'b000000; funct=6'b100000; #10; show("add");
        opcode=6'b000000; funct=6'b001000; #10; show("jr");
        opcode=6'b001000; funct=0; #10; show("addi");
        opcode=6'b001100; #10; show("andi");
        opcode=6'b001101; #10; show("ori");
        opcode=6'b001111; #10; show("lui");
        opcode=6'b100011; #10; show("lw");
        opcode=6'b101011; #10; show("sw");
        opcode=6'b000100; #10; show("beq");
        opcode=6'b000101; #10; show("bne");
        opcode=6'b000010; #10; show("j");
        opcode=6'b000011; #10; show("jal");
        $display("=== Fim ==="); $finish;
    end
endmodule
