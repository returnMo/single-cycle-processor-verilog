module AdderPC (
    input [11:0] a,
    output [11:0] result
);
    assign result = a + 12'h001;
endmodule
