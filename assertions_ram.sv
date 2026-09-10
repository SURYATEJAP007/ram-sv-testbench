
module ram_assertions(ram_interface vif);

    property p_no_simultaneous_rw;
        @(posedge vif.clk)
        disable iff (vif.rst)
        vif.en |-> !(vif.wr_en && vif.rd_en);
    endproperty

    a_no_simultaneous_rw:
        assert property(p_no_simultaneous_rw)
        else $error("RAM ERROR: Read and Write enabled simultaneously");


    property p_reset_dout;
        @(posedge vif.clk)
        vif.rst |=> (vif.dout == 8'h00);
    endproperty

    a_reset_dout:
        assert property(p_reset_dout)
        else $error("RAM ERROR: DOUT is not zero after reset");

    property p_valid_write;
        @(posedge vif.clk)
        disable iff (vif.rst)
        (vif.en && vif.wr_en && !vif.rd_en)
        |-> !$isunknown({vif.addr, vif.din});
    endproperty

    a_valid_write:
        assert property(p_valid_write)
        else $error("RAM ERROR: Unknown address/data during WRITE");


    property p_valid_read;
        @(posedge vif.clk)
        disable iff (vif.rst)
        (vif.en && !vif.wr_en && vif.rd_en)
        |-> !$isunknown(vif.addr);
    endproperty

    a_valid_read:
        assert property(p_valid_read)
        else $error("RAM ERROR: Unknown address during READ");


    property p_address_known;
        @(posedge vif.clk)
        disable iff (vif.rst)
        vif.en |-> !$isunknown(vif.addr);
    endproperty

    a_address_known:
        assert property(p_address_known)
        else $error("RAM ERROR: Address contains X/Z");

    property p_write_data_known;
        @(posedge vif.clk)
        disable iff (vif.rst)
        (vif.en && vif.wr_en && !vif.rd_en)
        |-> !$isunknown(vif.din);
    endproperty

    a_write_data_known:
        assert property(p_write_data_known)
        else $error("RAM ERROR: Write data contains X/Z");


endmodule


