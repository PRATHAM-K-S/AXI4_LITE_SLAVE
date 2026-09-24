class axi4_lite_slave_monitor extends uvm_monitor;

    // Factory registration
    `uvm_component_utils(axi4_lite_slave_monitor)

    // Virtual interface declerations
    virtual axi4_lite_slave_if vif;

    // Analysis port declerations
    uvm_analysis_port #(axi4_lite_slave_seq_item) wr_ap;
    uvm_analysis_port #(axi4_lite_slave_seq_item) rd_ap;

    // Class constructor
    function new(string name="axi4_lite_slave_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    // build_phase definition
    function void build_phase(uvm_phase phase);
        wr_ap = new("wr_ap", this);
        rd_ap = new("rd_ap", this);
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        wait(vif.ARESETn);
        fork
            collect_write();
            collect_read();
        join
    endtask: run_phase

    // collect_write: sample write channel signals
    task collect_write();
        bit got_awaddr;
        bit got_wdata;
        axi4_lite_slave_seq_item wr_tx;

        got_awaddr = 1'b0;
        got_wdata = 1'b0;
        wr_tx = axi4_lite_slave_seq_item::type_id::create("wr_tx");
        wr_tx.m_tx_type = WRITE;

        forever begin
            @(vif.mon_cb);
            if(!vif.ARESETn) begin
                got_awaddr = 1'b0;
                got_wdata = 1'b0;
                continue;
            end
            if(vif.mon_cb.AWVALID && vif.mon_cb.AWREADY) begin
                wr_tx.m_awaddr = vif.mon_cb.AWADDR;
                wr_tx.m_awprot = vif.mon_cb.AWPROT;
                got_awaddr = 1'b1;
            end
            if(vif.mon_cb.WVALID && vif.mon_cb.WREADY) begin
                wr_tx.m_wdata = vif.mon_cb.WDATA;
                wr_tx.m_wstrb = vif.mon_cb.WSTRB;
                got_wdata = 1'b1;
            end
            if(got_awaddr && got_wdata && vif.mon_cb.BVALID && vif.mon_cb.BREADY) begin
               wr_tx.m_bresp = vif.mon_cb.BRESP;
               `uvm_info(get_type_name(), wr_tx.convert2string(), UVM_MEDIUM)
               wr_ap.write(wr_tx);
               got_awaddr = 1'b0;
               got_wdata = 1'b0;
               wr_tx = axi4_lite_slave_seq_item::type_id::create("wr_tx");
               wr_tx.m_tx_type = WRITE;
            end
        end
    endtask: collect_write

    // collect_read: sample read channel signals
    task collect_read();
        bit got_araddr;
        axi4_lite_slave_seq_item rd_tx;

        got_araddr = 1'b0;
        rd_tx = axi4_lite_slave_seq_item::type_id::create("rd_tx");
        rd_tx.m_tx_type = READ;

        forever begin
            @(vif.mon_cb);
            if(!vif.ARESETn) begin
                got_araddr = 1'b0;
                continue;
            end
            if(vif.mon_cb.ARVALID && vif.mon_cb.ARREADY) begin
                rd_tx.m_araddr = vif.mon_cb.ARADDR;
                rd_tx.m_arprot = vif.mon_cb.ARPROT;
                got_araddr = 1'b1;
            end
            if(got_araddr && vif.mon_cb.RVALID && vif.mon_cb.RREADY) begin
                rd_tx.m_rdata = vif.mon_cb.RDATA;
                rd_tx.m_rresp = vif.mon_cb.RRESP;
                `uvm_info(get_type_name(), rd_tx.convert2string(), UVM_MEDIUM)
                rd_ap.write(rd_tx);
                got_araddr = 1'b0;
                rd_tx = axi4_lite_slave_seq_item::type_id::create("rd_tx");
                rd_tx.m_tx_type = READ;
            end
        end
    endtask: collect_read
    
endclass: axi4_lite_slave_monitor