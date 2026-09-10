`include "interface_ram.sv"
`include "transaction_ram.sv"
`include "generator_ram.sv"
`include "driver_ram.sv"
`include "monitor_ram.sv"
`include "scoreboard_ram.sv"
`include "coverage_ram.sv"

class environment;
generator_ram g;
driver_ram r;
monitor_ram m;
scoreboard_ram s;
ram_coverage cov;

mailbox#(transaction_ram) m1;
mailbox#(transaction_ram) m2;
mailbox#(transaction_ram) m3;

virtual ram_interface.driver_ram  vif_drv;
virtual ram_interface.monitor_ram vif_mon;

function new(virtual ram_interface.driver_ram vif_drv, virtual ram_interface.monitor_ram vif_mon);
  this.vif_drv = vif_drv;
  this.vif_mon = vif_mon;
  m1 = new();
  m2 = new();
  m3 = new();
  g  = new(m1);
  r  = new(m1, vif_drv);
  m  = new(m2,m3, vif_mon);
  s  = new(m2);
  cov = new(m3);
endfunction

task run();
begin
fork
m.run();
s.run();
cov.run();
join_none            
fork
g.run();
r.run();
join                  
repeat(5) @(posedge vif_drv.clk);  
disable fork;         
end
endtask
endclass
