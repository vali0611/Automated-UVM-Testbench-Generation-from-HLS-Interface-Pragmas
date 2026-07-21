class template_env extends uvm_env;
    `uvm_component_utils(template_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    template_scoreboard scb;
    template_axi_lite_reset_agent agent_temp_axi_reset;
    template_axi_lite_agent agt_axi_s;
    template_axis_agent agt_axis;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("ENV", "ENV DONE!", UVM_NONE)
        scb = template_scoreboard::type_id::create("scb", this);
        agent_temp_axi_reset = template_axi_lite_reset_agent::type_id::create("agent_temp_axi_reset", this);
        agt_axi_s = template_axi_lite_agent::type_id::create("agt_axi_s", this);
        agt_axi_s.agent_name = "a_nm";
        agt_axis = template_axis_agent::type_id::create("agt_axis", this);
        agt_axis.agent_name = "a_nm";
        agt_axis.direction = dirct;
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt_axi_s.mon.ap.connect(scb.analysis_axi_s_export);
        agt_axis.mon.ap.connect(scb.analysis_axis_export);
    endfunction
endclass