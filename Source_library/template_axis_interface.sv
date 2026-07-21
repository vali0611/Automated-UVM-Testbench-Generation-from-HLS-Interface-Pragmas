`timescale 1ps / 1ps
interface template_axis_interface (input logic axis_clk, input logic axis_rst_n);

logic [31:0] axis_tdata;
logic axis_tready;
logic axis_tvalid;

endinterface