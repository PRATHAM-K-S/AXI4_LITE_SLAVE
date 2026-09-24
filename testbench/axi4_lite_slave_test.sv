/*----- Base test -----*/
class axi4_lite_slave_base_test extends uvm_test;
    
    // Factory registration
    `uvm_component_utils(axi4_lite_slave_base_test)

    // Component handle decleration
    axi4_lite_slave_env env_h;

    // Config handle decleration
    axi4_lite_slave_config env_config;

    // Virtual interface handle decleration
    virtual axi4_lite_slave_if vif;

    // Sequence handles, a null handle means that channel is not exercised
    axi4_lite_slave_base_sequence m_wr_seq;
    axi4_lite_slave_base_sequence m_rd_seq;

    // Class constructor
    function new(string name="axi4_lite_slave_base_test", uvm_component parent=null);
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

    // Derived tests override this to choose which sequences run
    virtual function void create_sequences();
        m_wr_seq = axi4_lite_slave_write_only_sequence::type_id::create("m_wr_seq");
        m_rd_seq = axi4_lite_slave_read_only_sequence::type_id::create("m_rd_seq");
    endfunction: create_sequences

    task run_phase(uvm_phase phase);
        create_sequences();
        phase.raise_objection(this);
        fork
            begin
                if(m_wr_seq != null) m_wr_seq.start(env_h.agt_h.wr_seqr_h);
            end
            begin
                if(m_rd_seq != null) m_rd_seq.start(env_h.agt_h.rd_seqr_h);
            end
        join
        #100ns;
        phase.drop_objection(this);
    endtask: run_phase
    
endclass: axi4_lite_slave_base_test

/*----- Base sequence test -----*/
class axi4_lite_slave_base_seq_test extends axi4_lite_slave_base_test;

    // Factory registration
    `uvm_component_utils(axi4_lite_slave_base_seq_test)

    // Class constructor
    function new(string name="axi4_lite_slave_base_seq_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void create_sequences();
        m_wr_seq = axi4_lite_slave_base_sequence::type_id::create("m_wr_seq");
    endfunction: create_sequences

endclass: axi4_lite_slave_base_seq_test

/*----- Write data idle cycles > write address idle cycles test -----*/
class axi4_lite_slave_data_gt_addr_test extends axi4_lite_slave_base_test;

    // Factory registration
    `uvm_component_utils(axi4_lite_slave_data_gt_addr_test)

    // Class constructor
    function new(string name="axi4_lite_slave_data_gt_addr_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void create_sequences();
        m_wr_seq = axi4_lite_slave_data_gt_addr_sequence::type_id::create("m_wr_seq");
    endfunction: create_sequences

endclass: axi4_lite_slave_data_gt_addr_test

/*----- Write address idle cycles > write data idle cycles test -----*/
class axi4_lite_slave_addr_gt_data_test extends axi4_lite_slave_base_test;

    // Factory registration
    `uvm_component_utils(axi4_lite_slave_addr_gt_data_test)

    // Class constructor
    function new(string name="axi4_lite_slave_addr_gt_data_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void create_sequences();
        m_wr_seq = axi4_lite_slave_addr_gt_data_sequence::type_id::create("m_wr_seq");
    endfunction: create_sequences

endclass: axi4_lite_slave_addr_gt_data_test

/*----- Write data idle cycles == write address idle cycles test -----*/
class axi4_lite_slave_data_eq_addr_test extends axi4_lite_slave_base_test;

    // Factory registration
    `uvm_component_utils(axi4_lite_slave_data_eq_addr_test)

    // Class constructor
    function new(string name="axi4_lite_slave_data_eq_addr_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void create_sequences();
        m_wr_seq = axi4_lite_slave_data_eq_addr_sequence::type_id::create("m_wr_seq");
    endfunction: create_sequences

endclass: axi4_lite_slave_data_eq_addr_test

/*----- All idle cycles == 0 test -----*/
class axi4_lite_slave_zero_idle_test extends axi4_lite_slave_base_test;

    // Factory registration
    `uvm_component_utils(axi4_lite_slave_zero_idle_test)

    // Class constructor
    function new(string name="axi4_lite_slave_zero_idle_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void create_sequences();
        m_wr_seq = axi4_lite_slave_zero_idle_sequence::type_id::create("m_wr_seq");
        m_wr_seq.m_seq_tx_type = WRITE;
        m_rd_seq = axi4_lite_slave_zero_idle_sequence::type_id::create("m_rd_seq");
        m_rd_seq.m_seq_tx_type = READ;
    endfunction: create_sequences

endclass: axi4_lite_slave_zero_idle_test

/*----- Write only test -----*/
class axi4_lite_slave_write_only_test extends axi4_lite_slave_base_test;

    // Factory registration
    `uvm_component_utils(axi4_lite_slave_write_only_test)

    // Class constructor
    function new(string name="axi4_lite_slave_write_only_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void create_sequences();
        m_wr_seq = axi4_lite_slave_write_only_sequence::type_id::create("m_wr_seq");
    endfunction: create_sequences

endclass: axi4_lite_slave_write_only_test

/*----- Read only test -----*/
class axi4_lite_slave_read_only_test extends axi4_lite_slave_base_test;

    // Factory registration
    `uvm_component_utils(axi4_lite_slave_read_only_test)

    // Class constructor
    function new(string name="axi4_lite_slave_read_only_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void create_sequences();
        m_rd_seq = axi4_lite_slave_read_only_sequence::type_id::create("m_rd_seq");
    endfunction: create_sequences

endclass: axi4_lite_slave_read_only_test
