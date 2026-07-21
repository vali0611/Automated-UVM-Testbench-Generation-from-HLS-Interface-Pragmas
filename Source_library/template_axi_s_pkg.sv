package axi4Lite_adder_axi_s_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "../axi4Lite_adder_seq_lib/axi4Lite_adder_axi_lite_sequence_item.sv"
    `include "../axi4Lite_adder_seq_lib/axi4Lite_adder_axi_lite_reset_seq_item.sv"
    `include "../axi4Lite_adder_seq_lib/axi4Lite_adder_axi_lite_reset_sequence.sv"
    `include "../axi4Lite_adder_seq_lib/axi4Lite_adder_axi_lite_basic_sequence.sv"
    `include "../axi4Lite_adder_agents/axi4Lite_adder_axi_lite_sequencer.sv"
    `include "../axi4Lite_adder_agents/axi4Lite_adder_axi_lite_monitor.sv"
    `include "../axi4Lite_adder_agents/axi4Lite_adder_axi_lite_driver.sv"
    `include "../axi4Lite_adder_agents/axi4Lite_adder_axi_lite_agent.sv"
    `include "../axi4Lite_adder_agents/axi4Lite_adder_axi_lite_reset_driver.sv"
    `include "../axi4Lite_adder_agents/axi4Lite_adder_axi_lite_reset_agent.sv"
    `include "../axi4Lite_adder_env/axi4Lite_adder_scoreboard.sv"
    `include "../axi4Lite_adder_env/axi4Lite_adder_env.sv"
    `include "axi4Lite_adder_base_test.sv"
    `include "axi4Lite_adder_test.sv"
endpackage