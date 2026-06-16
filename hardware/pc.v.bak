module PC (
    input clock,
    input [31:0] nextPC,
    output reg [31:0] PC
);

// Garante que o PC começa em zero
initial begin
    PC = 32'h00000000;
end

// Executa somente na borda de subida do clock
always @(posedge clock) begin
    PC <= nextPC;
end

endmodule