module tb_pc;

reg clock;
reg [31:0] nextPC;

wire [31:0] PC;

pc uut (

    .clock(clock),
    .nextPC(nextPC),
    .PC(PC)
);

initial begin

    clock = 0;
    nextPC = 0;
    #10 nextPC = 4;
    #10 nextPC = 8;
    #10 nextPC = 12;
	 #10 $stop;

end

always #5 clock = ~clock;

endmodule