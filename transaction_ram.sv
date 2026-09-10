class transaction_ram;
rand bit wr_en,rd_en;
rand bit [3:0] addr;
rand bit [7:0] wr_data;
bit [7:0] dout;
constraint case_1{ !(wr_en && rd_en); }
constraint case_2{wr_en dist { 1:=60,0:=40};  }
constraint case_3{rd_en dist { 1:=60,0:=40};  }

function void display(string tag="");
$display("[%s] wr_en=%b rd_en=%b addr=%b wr_data=%b",tag,wr_en,rd_en,addr,wr_data);
endfunction
endclass
