module ExtendUnit (
    input [11:0] in,
    input ExtSel,
    output [15:0] out
);
    wire [15:0] sign_ext;
    wire [15:0] zero_ext;

    assign sign_ext = {{4{in[11]}}, in};
    assign zero_ext = {4'b0000, in};

    assign out = ExtSel ? zero_ext : sign_ext;
endmodule
