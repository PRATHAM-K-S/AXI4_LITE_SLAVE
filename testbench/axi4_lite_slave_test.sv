class axi4_lite_slave_test extends uvm_test;
    
    // Factory registration
    `uvm_component_utils(axi4_lite_slave_test)

    // Component handle decleration
    axi4_lite_slave_env env_h;

    // Config handle decleration
    axi4_lite_slave_config env_config;

    // Virtual interface handle decleration
    virtual axi4_lite_slave_if vif;

    // Class constructor
    function new(string name="axi4_lite_slave_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    // build_phase definition
    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual axi4_lite_slave_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "vif not set")
        end
        env_config = new("env_config");
        env_config.vif = vif;
        env_h = axi4_lite_slave_env::type_id::create("env_h", this);
        uvm_config_db #(axi4_lite_slave_config)::set(this, "env_h", "config", env_config);
    endfunction: build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    task run_phase(uvm_phase phase);
        fork
            begin
                axi4_lite_slave_write_sequence wr_seq;
                wr_seq = axi4_lite_slave_write_sequence::type_id::create("wr_seq");
                phase.raise_objection(this);
                    wr_seq.start(env_h.agt_h.wr_seqr_h);
                    #100ns;
                phase.drop_objection(this);
            end
            begin
                axi4_lite_slave_read_sequence rd_seq;
                rd_seq = axi4_lite_slave_read_sequence::type_id::create("rd_seq");
                phase.raise_objection(this);
                    rd_seq.start(env_h.agt_h.rd_seqr_h);
                    #100ns;
                phase.drop_objection(this);
            end
        join
    endtask
    
endclass: axi4_lite_slave_test