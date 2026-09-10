interface ram_interface(input logic clk);
logic rst=0,en=0,wr_en=0,rd_en=0;
logic [3:0] addr=0;
logic [7:0] din=0;
logic [7:0] dout;

modport driver_ram(
input clk,
output rst,en,wr_en,rd_en,addr,din );

modport monitor_ram(
input clk,rst,en,wr_en,rd_en,addr,din,dout
);
endinterface
