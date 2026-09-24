class axi4_lite_slave_env extends uvm_env;

    // Factory registration
    `uvm_component_utils(axi4_lite_slave_env)

    // Component handle decleration
    axi4_lite_slave_agent agt_h;

    // Config handle decleration
    axi4_lite_slave_config m_config;
    
    // Class constructor
    function new(string name="axi4_lite_slave_env", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    // build_phase definition
    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(axi4_lite_slave_config)::get(this, "", "config", m_config)) begin
            `uvm_fatal("NOCONFIG", "config not found")
        end
        m_config.is_active = UVM_ACTIVE;
        agt_h = axi4_lite_slave_agent::type_id::create("agt_h", this);
        uvm_config_db #(axi4_lite_slave_config)::set(this, "agt_h", "config", m_config);
    endfunction: build_phase

endclass: axi4_lite_slave_env