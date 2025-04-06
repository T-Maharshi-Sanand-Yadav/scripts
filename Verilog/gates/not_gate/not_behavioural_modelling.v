`timescale 1ns / 1ps
module not_behavioural_modelling(y,a);
output y;
input a;
reg y;
always@(a)
y = ~a;
endmodule

