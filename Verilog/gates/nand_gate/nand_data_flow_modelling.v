`timescale 1ns / 1ps
module nand_data_flow_modelling(y,a,b);
output y;
input a,b;
assign y = ~(a & b);
endmodule
