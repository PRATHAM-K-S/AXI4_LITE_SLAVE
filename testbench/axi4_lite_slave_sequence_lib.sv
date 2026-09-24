class axi4_lite_slave_write_sequence extends uvm_sequence;
    
    // Factory registration
    `uvm_object_utils(axi4_lite_slave_write_sequence)

    // Class constructor
    function new(string name="axi4_lite_slave_write_sequence");
        super.new(name);
    endfunction

    task body();
        axi4_lite_slave_seq_item tx;
        tx = axi4_lite_slave_seq_item::type_id::create("tx");
        tx.m_tx_type = WRITE;
        repeat(4) begin
            start_item(tx);
            if(!tx.randomize() with {m_tx_type == WRITE; m_awaddr == 32'h100; m_awprot == 0;}) begin
                `uvm_fatal(get_type_name(), "Write randomization failed")
            end
            finish_item(tx);
        end
    endtask

endclass: axi4_lite_slave_write_sequence

class axi4_lite_slave_write_diff_cycle_sequence extends uvm_sequence;
    
    // Factory registration
    `uvm_object_utils(axi4_lite_slave_write_diff_cycle_sequence)

    // Class constructor
    function new(string name="axi4_lite_slave_write_diff_cycle_sequence");
        super.new(name);
    endfunction

    task body();
        axi4_lite_slave_seq_item tx;
        tx = axi4_lite_slave_seq_item::type_id::create("tx");
        repeat(4) begin
            start_item(tx);
            // AWREADY/WREADY can take up to 2 cycles to rise after VALID,
            // so a gap of at least 2 idle cycles keeps the AW and W handshakes on different edges
            if(!tx.randomize() with {
                m_tx_type == WRITE;
                m_awaddr == 32'h100;
                m_awaddr[1:0] == 2'b00;
                m_awprot == 0;
                (m_wr_data_idle_cycles >= m_wr_addr_idle_cycles + 2) ||
                (m_wr_addr_idle_cycles >= m_wr_data_idle_cycles + 2);
            }) begin
                `uvm_fatal(get_type_name(), "Write randomization failed")
            end
            finish_item(tx);
        end
    endtask

endclass: axi4_lite_slave_write_diff_cycle_sequence

class axi4_lite_slave_read_sequence extends uvm_sequence;
    
    // Factory registration
    `uvm_object_utils(axi4_lite_slave_read_sequence)

    // Class constructor
    function new(string name="axi4_lite_slave_read_sequence");
        super.new(name);
    endfunction

    task body();
        axi4_lite_slave_seq_item tx;
        tx = axi4_lite_slave_seq_item::type_id::create("tx");
        tx.m_tx_type = READ;
        repeat(4) begin
            start_item(tx);
            if(!tx.randomize() with {m_tx_type == READ; m_araddr == 32'h100; m_arprot == 0;}) begin
                `uvm_fatal(get_type_name(), "Read randomization failed")
            end
            finish_item(tx);
        end
    endtask

endclass: axi4_lite_slave_read_sequence