class axi4_lite_slave_driver extends uvm_driver #(axi4_lite_slave_seq_item);
    
    // Factory registration
    `uvm_component_utils(axi4_lite_slave_driver)

    // Virtual inteface handle decleration
    virtual axi4_lite_slave_if vif;

    // Transaction handle decleration
    axi4_lite_slave_seq_item wr_req;
    axi4_lite_slave_seq_item rd_req;

    // Pull port declerations
    uvm_seq_item_pull_port #(axi4_lite_slave_seq_item) wr_seqr_item_port;
    uvm_seq_item_pull_port #(axi4_lite_slave_seq_item) rd_seqr_item_port;

    // Class constructor
    function new(string name="axi4_lite_slave_driver", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    // build_phase definition
    function void build_phase(uvm_phase phase);
        wr_seqr_item_port = new("wr_seqr_item_port", this);
        rd_seqr_item_port = new("rd_seqr_item_port", this);
    endfunction: build_phase

    // run_phase definition
    task run_phase(uvm_phase phase);
        @(!vif.ARESETn);
        forever begin
            fork
                fork
                    write();
                    read();
                join
                @(negedge vif.ARESETn);
            join_any
            disable fork;
            if(wr_req.m_is_item_on_flight) begin
                `uvm_warning("RESET", {"on the fly reset applied", wr_req.convert2string()})
            end
            if(rd_req.m_is_item_on_flight) begin
                `uvm_warning("RESET", {"on the fly reset applied", rd_req.convert2string()})
            end
        end
    endtask: run_phase

    // Write channel process 
    task write();
        forever begin
            wr_seqr_item_port.get_next_item(wr_req);
            wr_req.m_is_item_on_flight = 1'b1;
            drive_write(wr_req);
            wr_req.m_is_item_on_flight = 1'b0;
            wr_seqr_item_port.item_done();        
        end
    endtask: write

    // Read channel process 
    task read();
        forever begin
            rd_seqr_item_port.get_next_item(rd_req);
            rd_req.m_is_item_on_flight = 1'b1;
            drive_read(rd_req);
            rd_req.m_is_item_on_flight = 1'b0;
            rd_seqr_item_port.item_done();        
        end
    endtask: read

    // Drive write signals
    task drive_write(input axi4_lite_slave_seq_item tx);
        fork
            begin
                repeat(tx.m_wr_addr_idle_cycles) @(vif.drv_cb);
                vif.drv_cb.AWADDR <= tx.m_awaddr;
                vif.drv_cb.AWPROT <= tx.m_awprot;
                vif.drv_cb.AWVALID <= 1'b1;
                wait_for_handshake(vif.drv_cb.AWREADY, "AWREADY");
                vif.drv_cb.AWVALID <= 1'b0;
            end
            begin
                repeat(tx.m_wr_data_idle_cycles) @(vif.drv_cb);
                vif.drv_cb.WDATA <= tx.m_wdata;
                vif.drv_cb.WSTRB <= tx.m_wstrb;
                vif.drv_cb.WVALID <= 1'b1;
                wait_for_handshake(vif.drv_cb.WREADY, "WREADY");
                vif.drv_cb.WVALID <= 1'b0;   
            end
        join
        repeat(tx.m_wr_bready_idle_cycles) @(vif.drv_cb);
        vif.drv_cb.BREADY <= 1'b1;
        wait_for_handshake(vif.drv_cb.BVALID, "BVALID");
        vif.drv_cb.BREADY <= 1'b0;
    endtask: drive_write

    // Drive read signals
    task drive_read(input axi4_lite_slave_seq_item tx);
        repeat(tx.m_rd_addr_idle_cycles) @(vif.drv_cb);
        vif.ARADDR <= tx.m_araddr;
        vif.ARPROT <= tx.m_arprot;
        vif.ARVALID <= 1'b1;
        wait_for_handshake(vif.ARREADY, "ARREADY");
        vif.ARVALID <= 1'b0;
        vif.RREADY <= 1'b1;
        wait_for_handshake(vif.RREADY, "RREADY");
        vif.RREADY <=1'b0;
    endtask: drive_read

    task wait_for_handshake(const ref logic signal, input string signal_name);
        int wait_cycle_count = 0;
        do @(vif.drv_cb) begin
            wait_cycle_count++;
            if(wait_cycle_count == HANDSHAKE_TIMEOUT_CYCLES) begin
                `uvm_fatal("HANDSHAKE TIMEOUT", {signal_name, "handshake failed"})
            end
        end while(!signal && (wait_cycle_count < HANDSHAKE_TIMEOUT_CYCLES));
    endtask: wait_for_handshake

endclass: axi4_lite_slave_driver