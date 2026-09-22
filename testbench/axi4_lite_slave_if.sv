interface axi4_lite_slave_if(input bit ACLK, input bit ARESETn);

    import axi4_lite_slave_pkg::*;

    // Write address channel ports
    logic [ADDR_WIDTH-1:0] AWADDR;
    logic [PROT_WIDTH-1:0] AWPROT;
    logic AWVALID;
    logic AWREADY;

    // Write data channel ports
    logic [DATA_WIDTH-1:0] WDATA;
    logic [STRB_WIDTH-1:0] WSTRB;
    logic WVALID;
    logic WREADY;

    // Write response channel ports
    logic [RSP_WIDTH-1:0] BRESP;
    logic BVALID;
    logic BREADY;

    // Read address channel ports
    logic [ADDR_WIDTH-1:0] ARADDR;
    logic [PROT_WIDTH-1:0] ARPROT;
    logic ARVALID;
    logic ARREADY;

    // Read data channel ports
    logic [DATA_WIDTH-1:0] RDATA;
    logic [RSP_WIDTH-1:0] RRSEP;
    logic RVALID;
    logic RREADY;

    // Driver clocking block
    clocking drv_cb @(posedge ACLK);
        default input #1step;
        default output #1ns;

        /*----- Driver output signals ------*/

        // Write address channel
        output AWADDR;
        output AWPROT;
        output AWVALID;

        // Write data channel
        output WDATA;
        output WSTRB;
        output WVALID;

        // Write response channel
        output BREADY;

        // Read address channel
        output ARADDR;
        output ARPROT;
        output ARVALID;

        // Read data channel
        output RREADY;

        /*----- Driver Input signals ------*/
        
        // Write address channel
        input AWREADY;

        // Write data channel
        input WREADY;

        // Write response channel
        input BRESP;
        input BVALID;

        // Read address channel
        input ARREADY;

        // Read data channel
        input RDATA;
        input RRSEP;
        input RVALID;
    endclocking

    // Monitor clocking block
    clocking mon_cb @(posedge ACLK);
        default input #1step;

        // Write address channel signals
        input AWADDR;
        input AWPROT;
        input AWVALID;
        input AWREADY;

        // Write data channel signals
        input WDATA;
        input WSTRB;
        input WVALID;
        input WREADY;

        // Write response channel signals
        input BRESP;
        input BVALID;
        input BREADY;

        // Read address channel signals
        input ARADDR;
        input ARPROT;
        input ARVALID;
        input ARREADY;

        // Read data channel signals
        input RDATA;
        input RRSEP;
        input RVALID;
        input RREADY;
    endclocking

    // modports
    modport DRV(clocking drv_cb, input ARESETn);
    modport MON(clocking mon_cb, input ARESETn);

endinterface: axi4_lite_slave_if