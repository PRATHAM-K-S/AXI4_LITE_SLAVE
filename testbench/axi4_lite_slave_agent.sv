class axi4_lite_slave_agent extends uvm_agent;
    
    // Factory registration
    `uvm_component_utils(axi4_lite_slave_agent)

    // Component handle declerations
    axi4_lite_slave_sequencer wr_seqr_h;
    axi4_lite_slave_sequencer rd_seqr_h;
    axi4_lite_slave_driver drv_h;
    axi4_lite_slave_monitor mon_h;

    // Analysis port declerations
    uvm_analysis_port #(axi4_lite_slave_seq_item) wr_mon_ap;
    uvm_analysis_port #(axi4_lite_slave_seq_item) rd_mon_ap;

    // Config handle decleration
    axi4_lite_slave_config m_config;

    // Class constructor
    function new(string name="axi4_lite_slave_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction 

    // build_phase definition
    function void build_phase(uvm_phase phase);
        
        if(!uvm_config_db #(axi4_lite_slave_config)::get(this, "", "config", m_config)) begin
            `uvm_fatal("NOCONFIG", "config not found")
        end

        mon_h = axi4_lite_slave_monitor::type_id::create("mon_h", this);
        wr_mon_ap = new("wr_mon_ap", this);
        rd_mon_ap = new("rd_mon_ap", this);

        if(m_config.is_active == UVM_ACTIVE) begin
            drv_h = axi4_lite_slave_driver::type_id::create("drv_h", this);
            wr_seqr_h = axi4_lite_slave_sequencer::type_id::create("wr_seqr_h", this);
            rd_seqr_h = axi4_lite_slave_sequencer::type_id::create("rd_seqr_h", this);
        end

    endfunction: build_phase

    // connect_phase definition
    function void connect_phase(uvm_phase phase);
        mon_h.wr_ap.connect(wr_mon_ap);
        mon_h.rd_ap.connect(rd_mon_ap);
        mon_h.vif = m_config.vif;
        if(m_config.is_active == UVM_ACTIVE) begin
            drv_h.wr_seqr_item_port.connect(wr_seqr_h.seq_item_export);
            drv_h.rd_seqr_item_port.connect(rd_seqr_h.seq_item_export);
            drv_h.vif = m_config.vif;
        end
    endfunction: connect_phase

endclass: axi4_lite_slave_agent