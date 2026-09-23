class axi4_lite_slave_sequencer extends uvm_sequencer #(axi4_lite_slave_seq_item);
    
    `uvm_component_utils(axi4_lite_slave_sequencer)

    // Class constructor
    function new(string name="axi4_lite_slave_sequencer", uvm_component parent=null);
        super.new(name, parent);
    endfunction
    
endclass //axi4_lite_slave_sequencer extends uvm_sequencer #(axi4_lite_slave_seq_item)