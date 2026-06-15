module regfile(
    input clock,
    input regWrite,
    input reset,
	 input [4:0] writeAddr,
    input [31:0] writeData,
    input [4:0] readAddr1,
    input [4:0] readAddr2,
    output [31:0] readData1,
    output [31:0] readData2
);

// Cria os 32 registradores, com 32 bits cada
reg [31:0] registers [0:31];
integer i;

// Escrita síncrona, somente com a borda de subida do clock
always @(posedge clock) begin
        if (reset) begin
		  
		  // Zera todos os registradores
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'h00000000;
            end
        end 
		  
		  // Se a escrita nos registradores for habilitada (regWrite = 1)
		  else if (regWrite) begin
		  
		  // Se a escrita não for no registrador $0, escreve o dado no registrador especificado
            if (writeAddr != 5'd0) begin
                registers[writeAddr] <= writeData;
            end
        end
    end


// Leitura Assíncrona
assign readData1 = (readAddr1 == 5'd0) ? 32'd0 : registers[readAddr1];
assign readData2 = (readAddr2 == 5'd0) ? 32'd0 : registers[readAddr2];

endmodule