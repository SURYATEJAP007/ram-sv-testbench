`include "enviroment_ram.sv"

module top;
  logic clk;

  initial clk = 0;
  always #5 clk = ~clk;

  ram_interface intf(clk);

virtual ram_interface.driver_ram  vif_drv = intf;
virtual ram_interface.monitor_ram vif_mon = intf;

  ram dut (
    .clk  (intf.clk),
    .rst  (intf.rst),
    .en   (intf.en),
    .wr_en   (intf.wr_en),
    .rd_en   (intf.rd_en),
    .addr (intf.addr),
    .din  (intf.din),
    .dout (intf.dout)
  );

  ram_assertions sva(intf);

  environment env;

  initial begin
    env = new(vif_drv,vif_mon);
    env.run();          
    #20;                
    $display("Functional coverage = %0.2f%%", env.cov.ram_cg.get_coverage());
    $finish;
  end

endmodule
