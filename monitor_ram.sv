class monitor_ram;
 transaction_ram txn;
virtual ram_interface.monitor_ram vif;
mailbox #(transaction_ram) m2;
mailbox #(transaction_ram) m3;
int count=0;

function new(mailbox #(transaction_ram) m2,mailbox #(transaction_ram) m3,virtual ram_interface.monitor_ram vif);
this.vif=vif;
this.m2=m2;
this.m3=m3;
endfunction

task run();
transaction_ram prev_txn;
prev_txn=null;
forever begin
@(posedge vif.clk);
#1;
txn=new();
txn.wr_en=vif.wr_en;
txn.rd_en=vif.rd_en;
txn.addr=vif.addr;
txn.wr_data=vif.din;
if(prev_txn!=null) begin
if(prev_txn.rd_en) prev_txn.dout=vif.dout;
m2.put(prev_txn);
m3.put(prev_txn);
prev_txn.display($sformatf("monitoring the signal of transaction %d",count));
count++;
end
prev_txn=txn;
end
endtask


endclass
