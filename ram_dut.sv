module ram(clk,rst,en,wr_en,rd_en,addr,din,dout);
input logic clk,rst,en,wr_en,rd_en;
input logic [3:0]addr;
input logic [7:0]din;
output logic [7:0]dout;

reg [7:0] mem [15:0];

always @(posedge clk or posedge rst)begin
if(rst) begin
dout<='0;
for (int i=0;i<16;i++)
mem[i]<='0;
end
else if(en) begin
if(wr_en&&!rd_en)
mem[addr]<=din;
else if(!wr_en&&rd_en) 
dout<=mem[addr];
end
end
endmodule
