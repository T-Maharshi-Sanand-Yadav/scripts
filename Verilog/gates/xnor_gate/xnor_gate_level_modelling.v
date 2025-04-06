`timescale 1ns / 1ps
module xnor_gate_level_modelling(y,a,b);
output y;
input a,b;
xnor x1(y,a,b);
endmodule
