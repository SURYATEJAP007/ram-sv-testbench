class driver_ram;
 transaction_ram txn;
virtual ram_interface.driver_ram vif;
mailbox #(transaction_ram) m1;
int count=0;

function new(mailbox #(transaction_ram) m1,virtual ram_interface.driver_ram vif);
this.vif=vif;
this.m1=m1;
endfunction

task run();
@(posedge vif.clk);
vif.rst<='1;
@(posedge vif.clk);
vif.en<='1;
vif.rst<='0;
repeat(100) begin
m1.get(txn);
@(posedge vif.clk);
vif.wr_en<=txn.wr_en;
vif.rd_en<=txn.rd_en;
vif.addr<=txn.addr;
vif.din<=txn.wr_data;
txn.display($sformatf("received the current transaction %d",count));
count++;
end
endtask

endclass