`timescale 1ns / 1ps
module xor_behavioural_modelling(y,a,b);
output y;
input a,b;
reg y;
always@(a or b)
y = a ^ b;
endmodule
