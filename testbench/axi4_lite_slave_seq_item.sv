class axi4_lite_slave_seq_item extends uvm_sequence_item;
    
    // Factory registration
    `uvm_object_utils(axi4_lite_slave_seq_item)

    // Class constructor
    function new(string name="axi4_lite_slave_seq_item");
        super.new(name);
    endfunction

    /*----- Input signals to DUT -----*/

    // Write address channel signals
    rand bit [ADDR_WIDTH-1:0] m_awaddr;
    rand bit [PROT_WIDTH-1:0] m_awprot;
    bit m_awvalid;

    // Write data channel signals
    rand bit [DATA_WIDTH-1:0] m_wdata;
    rand bit [STRB_WIDTH-1:0] m_wstrb;
    bit m_wvalid;

    // Write response channel signals
    bit m_bready;

    // Read address channel signals
    rand bit [ADDR_WIDTH-1:0] m_araddr;
    rand bit [PROT_WIDTH-1:0] m_arprot;
    bit m_arvalid;

    // Read data channel signals
    bit m_rready;

    /*----- Output signals from the DUT -----*/

    // Write address channel
    logic m_awready;

    // Write data channel ports
    logic m_wready;

    // Write response channel ports
    logic [RSP_WIDTH-1:0] m_bresp;
    logic m_bvalid;

    // Read address channel ports
    logic m_arready;

    // Read data channel ports
    logic [DATA_WIDTH-1:0] m_rdata;
    logic [RSP_WIDTH-1:0] m_rresp;
    logic m_rvalid;

    /*----- Non DUT signals -----*/

    // delay cycles randomization signals
    rand int unsigned m_wr_addr_idle_cycles;
    rand int unsigned m_wr_data_idle_cycles;
    rand int unsigned m_wr_bready_idle_cycles;
    rand int unsigned m_rd_addr_idle_cycles;
    rand int unsigned m_rd_rready_idle_cycles;

    // Transaction information signals
    rand tx_type_enum_t m_tx_type;
    bit m_is_item_on_flight;

    /*----- Sequence item methods -----*/

    // convert2String method definition
    function string convert2string();
        string s;

        s = super.convert2string();

        // Transaction info
        s = $sformatf("%s\n TRANSACTION_TYPE \t%s\n ITEM_ON_FLIGHT \t%s\n",
        s, m_tx_type.name(), m_is_item_on_flight?"YES":"NO");

        if(m_tx_type == WRITE) begin
            // Write address channel signals
            s = $sformatf("%s\n AWADDR \t%0h\n AWPROT \t%0b\n AWVALID \t%0b\n AWREADY \t%0b\n",
            s, m_awaddr, m_awprot, m_awvalid, m_awready);
            // Write data channel signals
            s = $sformatf("%s\n WDATA \t%0h\n WSTRB \t%0b\n WVALID \t%0b\n WREADY \t%0b\n",
            s, m_wdata, m_wstrb, m_wvalid, m_wready);
            // Write response channel signals
            s = $sformatf("%s\n BRESP \t%0b\n BVALID \t%0b\n BREADY \t%0b\n",
            s, m_bresp, m_bvalid, m_bready);
            // Write delay cycle signals
            s = $sformatf("%s\n WRITE_ADDR_IDLE_CYCLES \t%0d\n WRITE_DATA_IDLE_CYCLES \t%0d\n WRITE_BREADY_IDLE_CYCLES \t%0d\n",
            s, m_wr_addr_idle_cycles, m_wr_data_idle_cycles, m_wr_bready_idle_cycles);
        end
        else begin
            // Read address channel signals
            s = $sformatf("%s\n ARADDR \t%0h\n ARPROT \t%0b\n ARVALID \t%0b\n ARREADY \t%0b\n",
            s, m_araddr, m_arprot, m_arvalid, m_arready);
            // Read data channel signals
            s = $sformatf("%s\n RDATA \t%0h\n RRESP \t%0b\n RVALID \t%0b\n RREADY \t%0b\n",
            s, m_rdata, m_rresp, m_rvalid, m_rready);
            // Read delay cycle signals
            s = $sformatf("%s\n READ_ADDR_IDLE_CYCLES \t%0d\n READ_RREADY_IDLE_CYCLES \t%0d\n",
            s, m_rd_addr_idle_cycles, m_rd_rready_idle_cycles);
        end

        return s;
    endfunction: convert2string

    // do_copy method definition
    function void do_copy(uvm_object rhs);
        axi4_lite_slave_seq_item rhs_;

        if(!$cast(rhs_, rhs)) begin
            `uvm_error("do_copy", "Cast failed")
        end

        super.do_copy(rhs);

        // Write address channel signals
        m_awaddr = rhs_.m_awaddr;
        m_awprot = rhs_.m_awprot;
        m_awvalid = rhs_.m_awvalid;
        m_awready = rhs_.m_awready;

        // Write data channel signals
        m_wdata = rhs_.m_wdata;
        m_wstrb = rhs_.m_wstrb;
        m_wvalid = rhs_.m_wvalid;
        m_wready = rhs_.m_wready;

        // Write response channel signals
        m_bready = rhs_.m_bready;
        m_bvalid = rhs_.m_bvalid;
        m_bready = rhs_.m_bready;

        // Read address channel signals
        m_araddr =  rhs_.m_araddr;
        m_arprot = rhs_.m_araddr;
        m_arvalid = rhs_.m_arvalid;
        m_arready = rhs_.m_arready;

        // Read data channel signals
        m_rdata = rhs_.m_rdata;
        m_rresp = rhs_.m_rresp;
        m_rvalid = rhs_.m_rvalid;
        m_rready = rhs_.m_rready;

        // Delay cycles randomization signals
        m_wr_addr_idle_cycles = rhs_.m_wr_addr_idle_cycles;
        m_wr_data_idle_cycles = rhs_.m_wr_data_idle_cycles;
        m_wr_bready_idle_cycles = rhs_.m_wr_bready_idle_cycles;
        m_rd_addr_idle_cycles = rhs_.m_rd_addr_idle_cycles;
        m_rd_rready_idle_cycles = rhs_.m_rd_rready_idle_cycles;

        // Transaction information signals
        m_tx_type = rhs_.m_tx_type;
        m_is_item_on_flight = rhs_.m_is_item_on_flight;
    endfunction: do_copy

    /*----- base constraint definitions -----*/

    constraint idle_cycle_constraints {
        soft m_wr_addr_idle_cycles inside {[0:5]};
        soft m_wr_data_idle_cycles inside {[0:5]};
        soft m_wr_bready_idle_cycles inside {[0:5]};
        soft m_rd_addr_idle_cycles inside {[0:5]};
        soft m_rd_rready_idle_cycles inside {[0:5]};
    }

    constraint strb_constraints {
        soft m_wstrb != 0;
    }
    
endclass: axi4_lite_slave_seq_item 