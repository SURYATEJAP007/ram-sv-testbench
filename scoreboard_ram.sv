class scoreboard_ram;
  transaction_ram txn;
  mailbox #(transaction_ram) m2;
  reg [7:0] ref_mem [15:0];

  function new(mailbox #(transaction_ram) m2);
    this.m2 = m2;
    foreach(ref_mem[i]) ref_mem[i] = '0; 
  endfunction

  task run();
    forever begin
      m2.get(txn);

      if (txn.wr_en && !txn.rd_en) begin
        ref_mem[txn.addr] = txn.wr_data;
        txn.display($sformatf("model updated: wrote %0d to addr %0d", txn.wr_data, txn.addr));
      end
      else if (!txn.wr_en && txn.rd_en) begin
        if(txn.dout===ref_mem[txn.addr])
           $display("PASS; din is %b ,expected was %b, actual was %b",txn.wr_data,ref_mem[txn.addr],txn.dout);
    
else 
 $error("FAIL; din is %b ,expected was %b, actual was %b",txn.wr_data,ref_mem[txn.addr],txn.dout);
end
else
$display("no operation founded");
end
  endtask
endclass
