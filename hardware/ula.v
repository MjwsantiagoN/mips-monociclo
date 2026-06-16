module ula(
    input [31:0] in1,
    input [31:0] in2,
    input [3:0] op,
    output reg [31:0] result,
    output reg zeroFlag
);

always @(*) begin 
result = 32'b0;
zeroFlag = 1'b0;

case (op)
 
    4'b0000: result = in1 + in2;    // Adição (add)
    4'b0001: result = in1 - in2;    // Subtração (sub)
    4'b0010: result = in1 & in2;    // AND 
    4'b0011: result = in1 | in2;    // OR 
    4'b0100: result = in1 ^ in2;    // XOR
    4'b0101: result = ~(in1 | in2); // NOR
	 
	 4'b0110: result = ($signed(in1) < $signed(in2)) ? 32'd1 : 32'd0; // Menor que com sinal (slt)
    4'b0111: result = (in1 < in2) ? 32'd1 : 32'd0;                   // Menor que sem sinal (sltu)

    4'b1000: result = in2 << in1[4:0];           // Deslocamento para a esquerda (sll/sllv)
    4'b1001: result = in2 >> in1[4:0];           // Deslocamento para a direita (srl/srlv)
    4'b1010: result = $signed(in2) >>> in1[4:0]; // Deslocamento p/ direita com sinal (sra/srav)

    default: result = 32'b0;
endcase

    zeroFlag = (result == 32'd0);
end

endmodule