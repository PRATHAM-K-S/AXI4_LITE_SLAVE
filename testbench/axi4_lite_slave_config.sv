class axi4_lite_slave_config extends uvm_object;

    // Config variables
    uvm_active_passive_enum is_active = UVM_ACTIVE;
    int unsigned handshake_timeout_cycles = 10;
    virtual axi4_lite_slave_if vif;

    // Class constructor
    function new(string name="axi4_lite_slave_agent_config");
        super.new(name);
    endfunction

endclass: axi4_lite_slave_config