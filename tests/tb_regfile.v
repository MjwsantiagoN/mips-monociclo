module tb_regfile;

    reg clock;
    reg regWrite;
    reg reset;

    reg [4:0] readAddr1;
    reg [4:0] readAddr2;
    reg [4:0] writeAddr;

    reg [31:0] writeData;

    wire [31:0] readData1;
    wire [31:0] readData2;

    // Instancia o módulo
    regfile uut (

        .clock(clock),
        .regWrite(regWrite),
        .reset(reset),

        .readAddr1(readAddr1),
        .readAddr2(readAddr2),

        .writeAddr(writeAddr),
        .writeData(writeData),

        .readData1(readData1),
        .readData2(readData2)

    );

    // Gera o clock
    always #5 clock = ~clock;

    initial begin

        // Inicialização
        clock = 0;

        reset = 1;
        regWrite = 0;

        readAddr1 = 0;
        readAddr2 = 0;

        writeAddr = 0;
        writeData = 0;

        // Mantém reset ativo
        #10;

        // Desativa reset
        reset = 0;

        // Escreve 100 no registrador 5
        regWrite = 1;

        writeAddr = 5'd5;
        writeData = 32'd100;

        #10;

        // Lê registrador 5
        readAddr1 = 5'd5;

        #10;

        // Escreve 200 no registrador 10
        writeAddr = 5'd10;
        writeData = 32'd200;

        #10;

        // Lê dois registradores simultaneamente
        readAddr1 = 5'd5;
        readAddr2 = 5'd10;

        #10;

        // Tenta escrever em $0 (deve ser ignorado)
        writeAddr = 5'd0;
        writeData = 32'd999;

        #10;

        // Lê $0
        readAddr1 = 5'd0;

        #10;

        $stop;

    end

endmodule