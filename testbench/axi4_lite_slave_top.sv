`include "axi4_lite_slave_defines.sv"
`include "axi4_lite_slave_pkg.sv"
`include "axi4_lite_slave_if.sv"
`include "../design/axi4_lite_slave.v"

module axi4_lite_slave_top;
    
    import uvm_pkg::*;
    import axi4_lite_slave_pkg::*;

    bit ACLK;
    bit ARESETn;

    axi4_lite_slave_if duv_if(ACLK, ARESETn);

    axi4_lite_slave DUT(
        .ACLK(duv_if.ACLK),
        .ARESETn(duv_if.ARESETn),
        .AWADDR(duv_if.AWADDR),
        .AWPROT(duv_if.AWPROT),
        .AWVALID(duv_if.AWVALID),
        .AWREADY(duv_if.AWREADY),
        .WDATA(duv_if.WDATA),
        .WSTRB(duv_if.WSTRB),
        .WVALID(duv_if.WVALID),
        .WREADY(duv_if.WREADY),
        .BRESP(duv_if.BRESP),
        .BVALID(duv_if.BVALID),
        .BREADY(duv_if.BREADY),
        .ARADDR(duv_if.ARADDR),
        .ARPROT(duv_if.ARPROT),
        .ARVALID(duv_if.ARVALID),
        .ARREADY(duv_if.ARREADY),
        .RDATA(duv_if.RDATA),
        .RRESP(duv_if.RRESP),
        .RVALID(duv_if.RVALID),
        .RREADY(duv_if.RREADY)
    );

    initial begin
        forever #5 ACLK = ~ACLK;
    end

    initial begin
        ARESETn = 1'b0;
        repeat(3) @(posedge ACLK);
        ARESETn = 1'b1;
    end

    initial begin
        uvm_config_db #(virtual axi4_lite_slave_if)::set(null, "uvm_test_top", "vif", duv_if);
        run_test("axi4_lite_slave_base_test");
    end

endmodule: axi4_lite_slave_top