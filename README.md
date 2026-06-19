# MIPS Monociclo – Projeto 02

**Disciplina:** Arquitetura e Organização de Computadores  
**Semestre:** 2025.2  
**Professor:** Vítor A. Coutinho – UFRPE

## Objetivo

Este projeto consiste na implementação de um processador MIPS monociclo de 32 bits em Verilog, desenvolvido como parte da disciplina de Arquitetura e Organização de Computadores.

A arquitetura segue o modelo monociclo clássico, no qual cada instrução é executada integralmente em um único ciclo de clock, percorrendo as etapas de busca, decodificação, execução, acesso à memória e escrita de volta (write-back).

O projeto foi desenvolvido de forma modular, permitindo testar individualmente cada componente e validar a integração completa do processador.

## Ferramentas Utilizadas
- Verilog HDL
- Quartus Prime
- ModelSim
- Icarus Verilog
- Git/GitHub

## Estrutura do projeto

```
mips-monociclo/
├── hardware/
│   ├── mips.v          ← Top-level (núcleo MIPS)
│   ├── pc.v            ← Contador de Programa
│   ├── i_mem.v         ← Memória de instrução (ROM)
│   ├── d_mem.v         ← Memória de dados (RAM)
│   ├── regfile.v       ← Banco de registradores
│   ├── ula.v           ← Unidade Lógica e Aritmética
│   ├── ula_ctrl.v      ← Controle da ULA
│   ├── ctrl.v          ← Unidade de controle principal
│   ├── adder.v         ← Somador 32 bits
│   ├── mux2.v          ← MUX 2:1 32 bits
│   ├── mux4.v          ← MUX 4:1 32 bits
│   ├── mux2_5bit.v     ← MUX 2:1 5 bits
│   ├── mux4_5bit.v     ← MUX 4:1 5 bits
│   ├── signExtend.v    ← Extensão de sinal (16→32 bits)
│   ├── zeroExtend.v    ← Extensão com zero (16→32 bits)
│   ├── shiftLeft2.v    ← Shift left 2 bits
│   ├── comparator.v    ← Comparador de igualdade
│   └── instruction.list ← Programa de teste (binário)
└── tests/
    ├── tb_mips.v       ← Testbench de integração (principal)
    ├── tb_pc.v         ← Testbench do PC
    ├── tb_regfile.v    ← Testbench do banco de registradores
    ├── tb_ula.v        ← Testbench da ULA
    ├── tb_ula_ctrl.v   ← Testbench do controle da ULA
    ├── tb_ctrl.v       ← Testbench da unidade de controle
    ├── tb_imem.v       ← Testbench da memória de instrução
    └── tb_dmem.v       ← Testbench da memória de dados
```

## Instruções suportadas

**Tipo R:** add, sub, and, or, xor, nor, slt, sltu, sll, srl, sra, sllv, srlv, srav, jr  
**Tipo I:** addi, addiu, andi, ori, xori, slti, sltiu, lui, lw, sw, beq, bne  
**Tipo J:** j, jal

## Fluxo de Execução

Cada instrução percorre as seguintes etapas:

**Busca (Instruction Fetch)**
- O PC fornece o endereço atual.
- A memória de instruções retorna a instrução correspondente.

**Decodificação (Instruction Decode)**
- Os campos da instrução são separados.
- A unidade de controle gera os sinais necessários.
  
**Execução (Execute)**
- A ULA realiza a operação correspondente.
  
**Acesso à memória (Memory Access)**
- lw realiza leitura.
- sw realiza escrita.
  
**Escrita de volta (Write Back)**
- O resultado é armazenado no banco de registradores.

## Como simular (Icarus Verilog)

```bash
cd hardware/

# Testbench de integração completo
iverilog -g2012 -o sim \
  pc.v i_mem.v d_mem.v regfile.v ula.v ula_ctrl.v ctrl.v \
  adder.v mux2.v mux4.v mux2_5bit.v mux4_5bit.v \
  signExtend.v zeroExtend.v shiftLeft2.v mips.v \
  ../tests/tb_mips.v
vvp sim

# Módulos individuais
iverilog -g2012 -o sim pc.v ../tests/tb_pc.v && vvp sim
iverilog -g2012 -o sim regfile.v ../tests/tb_regfile.v && vvp sim
iverilog -g2012 -o sim ula.v ../tests/tb_ula.v && vvp sim
iverilog -g2012 -o sim ula_ctrl.v ../tests/tb_ula_ctrl.v && vvp sim
iverilog -g2012 -o sim ctrl.v ../tests/tb_ctrl.v && vvp sim
iverilog -g2012 -o sim i_mem.v ../tests/tb_imem.v && vvp sim
iverilog -g2012 -o sim d_mem.v ../tests/tb_dmem.v && vvp sim
```

## Programa de teste (instruction.list)

O arquivo `instruction.list` contém um programa que exercita as
principais instruções. Cada linha é uma instrução de 32 bits em binário.
Para executar um programa próprio, basta substituir o conteúdo do arquivo
mantendo o formato: uma instrução por linha, 32 dígitos binários.

## Codificação da ULA (op[3:0])

| Código | Operação |
|--------|----------|
| 0000   | ADD      |
| 0001   | SUB      |
| 0010   | AND      |
| 0011   | OR       |
| 0100   | XOR      |
| 0101   | NOR      |
| 0110   | SLT (signed)  |
| 0111   | SLTU (unsigned) |
| 1000   | SLL / SLLV |
| 1001   | SRL / SRLV |
| 1010   | SRA / SRAV |
| 1011   | LUI      |
