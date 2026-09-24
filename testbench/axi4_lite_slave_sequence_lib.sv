// Idle cycle relationship applied to each randomized item
typedef enum {IDLE_ANY, IDLE_DATA_GT_ADDR, IDLE_ADDR_GT_DATA, IDLE_DATA_EQ_ADDR, IDLE_ALL_ZERO} idle_mode_enum_t;

/*----- 1. Base sequence -----*/
class axi4_lite_slave_base_sequence extends uvm_sequence #(axi4_lite_slave_seq_item);

    // Factory registration
    `uvm_object_utils(axi4_lite_slave_base_sequence)

    // Sequence knobs
    int unsigned m_num_txns = 10;
    tx_type_enum_t m_seq_tx_type = WRITE;
    idle_mode_enum_t m_idle_mode = IDLE_ANY;

    // Class constructor
    function new(string name="axi4_lite_slave_base_sequence");
        super.new(name);
    endfunction

    task body();
        axi4_lite_slave_seq_item tx;
        repeat(m_num_txns) begin
            tx = axi4_lite_slave_seq_item::type_id::create("tx");
            start_item(tx);
            if(!tx.randomize() with {
                m_tx_type == m_seq_tx_type;

                // Aligned address and protection = 0
                m_awaddr % 4 == 0;
                m_araddr % 4 == 0;
                m_awprot == 0;
                m_arprot == 0;

                // Keep addresses inside the DUT's 16-word register file
                soft m_awaddr inside {[0:'h3C]};
                soft m_araddr inside {[0:'h3C]};

                (m_idle_mode == IDLE_DATA_GT_ADDR) -> (m_wr_data_idle_cycles > m_wr_addr_idle_cycles);
                (m_idle_mode == IDLE_ADDR_GT_DATA) -> (m_wr_addr_idle_cycles > m_wr_data_idle_cycles);
                (m_idle_mode == IDLE_DATA_EQ_ADDR) -> (m_wr_data_idle_cycles == m_wr_addr_idle_cycles);
                (m_idle_mode == IDLE_ALL_ZERO)     -> (m_wr_addr_idle_cycles   == 0 &&
                                                              m_wr_data_idle_cycles   == 0 &&
                                                              m_wr_bready_idle_cycles == 0 &&
                                                              m_rd_addr_idle_cycles   == 0 &&
                                                              m_rd_rready_idle_cycles == 0);
            }) begin
                `uvm_fatal(get_type_name(), "Randomization failed")
            end
            finish_item(tx);
        end
    endtask

endclass: axi4_lite_slave_base_sequence

/*----- 2. Write data idle cycles > write address idle cycles -----*/
class axi4_lite_slave_data_gt_addr_sequence extends axi4_lite_slave_base_sequence;

    // Factory registration
    `uvm_object_utils(axi4_lite_slave_data_gt_addr_sequence)

    // Class constructor
    function new(string name="axi4_lite_slave_data_gt_addr_sequence");
        super.new(name);
        m_seq_tx_type = WRITE;
        m_idle_mode = IDLE_DATA_GT_ADDR;
    endfunction

endclass: axi4_lite_slave_data_gt_addr_sequence

/*----- 3. Write address idle cycles > write data idle cycles -----*/
class axi4_lite_slave_addr_gt_data_sequence extends axi4_lite_slave_base_sequence;

    // Factory registration
    `uvm_object_utils(axi4_lite_slave_addr_gt_data_sequence)

    // Class constructor
    function new(string name="axi4_lite_slave_addr_gt_data_sequence");
        super.new(name);
        m_seq_tx_type = WRITE;
        m_idle_mode = IDLE_ADDR_GT_DATA;
    endfunction

endclass: axi4_lite_slave_addr_gt_data_sequence

/*----- 4. Write data idle cycles == write address idle cycles -----*/
class axi4_lite_slave_data_eq_addr_sequence extends axi4_lite_slave_base_sequence;

    // Factory registration
    `uvm_object_utils(axi4_lite_slave_data_eq_addr_sequence)

    // Class constructor
    function new(string name="axi4_lite_slave_data_eq_addr_sequence");
        super.new(name);
        m_seq_tx_type = WRITE;
        m_idle_mode = IDLE_DATA_EQ_ADDR;
    endfunction

endclass: axi4_lite_slave_data_eq_addr_sequence

/*----- 5. All idle cycles == 0 -----*/
class axi4_lite_slave_zero_idle_sequence extends axi4_lite_slave_base_sequence;

    // Factory registration
    `uvm_object_utils(axi4_lite_slave_zero_idle_sequence)

    // Class constructor
    function new(string name="axi4_lite_slave_zero_idle_sequence");
        super.new(name);
        m_idle_mode = IDLE_ALL_ZERO;
    endfunction

endclass: axi4_lite_slave_zero_idle_sequence

/*----- 6. Write only sequence -----*/
class axi4_lite_slave_write_only_sequence extends axi4_lite_slave_base_sequence;

    // Factory registration
    `uvm_object_utils(axi4_lite_slave_write_only_sequence)

    // Class constructor
    function new(string name="axi4_lite_slave_write_only_sequence");
        super.new(name);
        m_seq_tx_type = WRITE;
    endfunction

endclass: axi4_lite_slave_write_only_sequence

/*----- 7. Read only sequence -----*/
class axi4_lite_slave_read_only_sequence extends axi4_lite_slave_base_sequence;

    // Factory registration
    `uvm_object_utils(axi4_lite_slave_read_only_sequence)

    // Class constructor
    function new(string name="axi4_lite_slave_read_only_sequence");
        super.new(name);
        m_seq_tx_type = READ;
    endfunction

endclass: axi4_lite_slave_read_only_sequence
