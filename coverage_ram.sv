class ram_coverage;

    mailbox #(transaction_ram) m3;

    transaction_ram txn;

    covergroup ram_cg;

        cp_operation : coverpoint {txn.wr_en, txn.rd_en} {

            bins idle  = {2'b00};
            bins write = {2'b10};
            bins read  = {2'b01};

        }

        cp_addr : coverpoint txn.addr {

            bins addresses[] = {[0:15]};

        }

        cp_data : coverpoint txn.wr_data {

            bins zero = {8'h00};
            bins low  = {[8'h01:8'h3F]};
            bins mid  = {[8'h40:8'hBF]};
            bins high = {[8'hC0:8'hFE]};
            bins max  = {8'hFF};

        }

        cross cp_operation, cp_addr;

    endgroup


    function new(mailbox #(transaction_ram) m3);

        this.m3 = m3;

        ram_cg = new();

    endfunction


    task run();

        forever begin

            m3.get(txn);

            ram_cg.sample();

        end

    endtask

endclass
