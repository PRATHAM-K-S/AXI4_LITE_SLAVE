package axi4_lite_slave_pkg;
    parameter ADDR_WIDTH = `ADDR_WIDTH;
    parameter DATA_WIDTH = `DATA_WIDTH;
    parameter STRB_WIDTH = `DATA_WIDTH/8;
    parameter PROT_WIDTH = 3;
    parameter RSP_WIDTH = 2;
    parameter HANDSHAKE_TIMEOUT_CYCLES = 100;

    // User defined types
    typedef enum {READ, WRITE} tx_type_enum_t;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "axi4_lite_slave_seq_item.sv"
    `include "axi4_lite_slave_config.sv"
    `include "axi4_lite_slave_sequence_lib.sv"
    `include "axi4_lite_slave_driver.sv"
    `include "axi4_lite_slave_monitor.sv"
    `include "axi4_lite_slave_sequencer.sv"
    `include "axi4_lite_slave_agent.sv"
    `include "axi4_lite_slave_env.sv"
    `include "axi4_lite_slave_test.sv"

endpackage: axi4_lite_slave_pkg