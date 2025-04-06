`timescale 1ns / 1ps
module nand_gate_level_modelling(y,a,b);
output y;
input a,b;
nand x1(y,a,b);
endmodule
