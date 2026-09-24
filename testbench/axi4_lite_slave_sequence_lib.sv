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
        repeat(10) begin
            start_item(tx);
            if(!tx.randomize()) begin
                `uvm_fatal(get_type_name(), "Write randomization failed")
            end
            finish_item(tx);
        end
    endtask

endclass: axi4_lite_slave_write_sequence

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
        repeat(10) begin
            start_item(tx);
            if(!tx.randomize()) begin
                `uvm_fatal(get_type_name(), "Write randomization failed")
            end
            finish_item(tx);
        end
    endtask

endclass: axi4_lite_slave_read_sequence