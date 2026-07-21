package template_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "../template_seq_lib/template_axis_sequence_item.sv"
    `include "../template_seq_lib/template_axi_lite_sequence_item.sv"

    `include "../template_seq_lib/template_axi_lite_basic_sequence.sv"
    `include "../template_seq_lib/template_axis_basic_sequence.sv"

    `include "../template_agents/template_axis_sequencer.sv"
    `include "../template_agents/template_axi_lite_sequencer.sv"

    `include "../template_agents/template_axis_monitor.sv"
    `include "../template_agents/template_axi_lite_monitor.sv"

    `include "../template_agents/template_axis_driver.sv"
    `include "../template_agents/template_axi_lite_driver.sv"

    `include "../template_agents/template_axis_agent.sv"
    `include "../template_agents/template_axi_lite_agent.sv"

    `include "../template_env/template_scoreboard.sv"
    `include "../template_env/template_env.sv"
    `include "template_base_test.sv"
    `include "template_test.sv"
    
endpackage