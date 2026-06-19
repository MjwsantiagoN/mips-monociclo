// ============================================================
// Grupo: --
// Atividade: Projeto 02 - 2VA
// Disciplina: Arquitetura e Organização de Computadores
// Semestre: 2025.2
// Arquivo: d_mem.v
// Descrição: Memória de dados (RAM) assíncrona com tamanho
//            parametrizável. Suporta leitura e escrita por
//            palavra (32 bits). ReadData fica em alta
//            impedância quando MemRead = 0. A escrita é
//            combinacional (ativada por MemWrite).
// ============================================================

module d_mem #(
    parameter MEM_SIZE = 64  // Número de palavras de 32 bits
)(
    input  [31:0] address,    // Endereço de acesso (em bytes)
    input  [31:0] writeData,  // Dado a ser escrito
    output [31:0] readData,   // Dado lido
    input         memWrite,   // Habilita escrita
    input         memRead     // Habilita leitura
);

    // Memória RAM: MEM_SIZE palavras de 32 bits
    (* ramstyle = "logic" *) reg [31:0] mem [0:MEM_SIZE-1];

	/*
    integer i;
    initial begin
        // Inicializa toda a memória com zeros
        for (i = 0; i < MEM_SIZE; i = i + 1)
            mem[i] = 32'h00000000;
    end
    */

    // Escrita assíncrona: quando MemWrite = 1, escreve na posição
    always @(*) begin
		#0;
		if (memWrite)
			mem[address[31:2]] = writeData;
	end

    // Leitura assíncrona: alta impedância quando MemRead = 0
    assign readData = memRead ? mem[address[31:2]] : 32'bz;

endmodule
