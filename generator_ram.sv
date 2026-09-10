
class generator_ram;
 transaction_ram txn;
mailbox#(transaction_ram) m1;
int count=0;

function new(mailbox #(transaction_ram) m1);
this.m1=m1;
endfunction

task run();
repeat(100) begin
txn=new();

if(!txn.randomize())
$error("randomization failed");
else begin
txn.display($sformatf("generated[%d]",count));
m1.put(txn);
end
count++;
end
endtask 
endclass
