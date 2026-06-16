module comparator(

    input [31:0] a,
    input [31:0] b,
    output equal
);

assign equal = (a == b);

endmodule