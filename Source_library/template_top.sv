`timescale 1ps / 1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

importt tempx_pkg::*;
`include "template_axi_lite_intf.sv"
`include "template_axis_interface.sv"


module templatk_top;

  logic clk;
  tempt_axi_lite_intf template_axi_s_if(.s_axi_aclk(clk));
  templaty_axis_interface template_axis_if(.axis_clk(clk),.axis_rst_n(reset_n));
     axi_dut dut(

     .ap_clk   (clk),
     .ap_rst_n(temp_axi_s_if.s_axi_aresetn),
     .s_axi_tempt_AWADDR (template_axi_s_if.s_axi_awaddr),
     .s_axi_tempt_AWVALID(template_axi_s_if.s_axi_awvalid),
     .s_axi_tempt_AWREADY(template_axi_s_if.s_axi_awready),
     .s_axi_tempt_WDATA  (template_axi_s_if.s_axi_wdata),
     .s_axi_tempt_WSTRB  (template_axi_s_if.s_axi_wstrb),
     .s_axi_tempt_WVALID (template_axi_s_if.s_axi_wvalid),
     .s_axi_tempt_WREADY (template_axi_s_if.s_axi_wready),
     .s_axi_tempt_BRESP  (template_axi_s_if.s_axi_bresp),
     .s_axi_tempt_BVALID (template_axi_s_if.s_axi_bvalid),
     .s_axi_tempt_BREADY (template_axi_s_if.s_axi_bready),
     .s_axi_tempt_ARADDR (template_axi_s_if.s_axi_araddr),
     .s_axi_tempt_ARVALID(template_axi_s_if.s_axi_arvalid),
     .s_axi_tempt_ARREADY(template_axi_s_if.s_axi_arready),
     .s_axi_tempt_RDATA  (template_axi_s_if.s_axi_rdata),
     .s_axi_tempt_RRESP  (template_axi_s_if.s_axi_rresp),
     .s_axi_tempt_RVALID (template_axi_s_if.s_axi_rvalid),
     .s_axi_tempt_RREADY (template_axi_s_if.s_axi_rready),
     .tempy_TDATA(template_axis_if.axis_tdata),
     .tempy_TVALID(template_axis_if.axis_tvalid),
     .tempy_TREADY(template_axis_if.axis_tready),
     );

  initial begin
    clk = 0;
    forever begin
      #5;
    clk = ~clk;
    end
  end

  initial begin

    uvm_config_db#(virtual template_axi_lite_intf)::set(null, "*", "xvif", tempt_axi_s_if);
    uvm_config_db#(virtual template_axis_interface)::set(null, "*", "yvif", tempt_axis_if);
  end

  initial begin
    `uvm_info("TOP", "SIMULATION STARTED", UVM_NONE)
    fork
        begin
            run_test("template_test");
        end
        begin
            repeat(100000) @(posedge clk);
             $finish();
            `uvm_fatal("SIM_END", $sformatf("Reached the simulation limit"))
        end
    join_any
    disable fork;

  end
endmodule : template_top