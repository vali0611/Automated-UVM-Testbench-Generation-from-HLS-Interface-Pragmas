`timescale 1ps / 1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

import template_pkg::*;

module template_top;

  logic clk;
  logic reset_n;

initial begin
    clk = 0;
    forever begin
      #5;
    clk = ~clk;
    end
  end

  initial begin
     reset_n = 0;
        #1;
     reset_n = 1;
  end

  initial begin

    end

  initial begin
    `uvm_info("WARNING","INCOMPLETE TESTBENCH!",UVM_NONE)
    `uvm_info("TOP", "DEMO SIMULATION STARTED", UVM_NONE)
    fork
        begin
            run_test("template_base_test");
        end
        begin
            repeat(100000) @(posedge clk);
             $finish();
            `uvm_fatal("SIM_END", $sformatf("Reached the simulation limit..Please add the rest of your testbench"))
        end
    join_any
    disable fork;

  end
endmodule