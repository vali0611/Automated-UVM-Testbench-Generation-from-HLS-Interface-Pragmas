class template_axi_lite_agent extends uvm_agent;
    `uvm_component_utils(template_axi_lite_agent)

  // Configuration knob
    uvm_active_passive_enum template_is_active = UVM_ACTIVE;

  // Sub-components
     template_axi_lite_driver      drv;
     template_axi_lite_monitor     mon;
     template_axi_lite_sequencer   seqr;
     string agent_name;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("AGENT FOR AXI SLAVE","AGENT DONE!", UVM_NONE)

         if (template_is_active == UVM_ACTIVE) begin
             seqr = template_axi_lite_sequencer ::type_id::create("seqr", this);
             drv  = template_axi_lite_driver ::type_id::create("drv",  this);
             drv.agent_name = agent_name;
         end
         mon = template_axi_lite_monitor ::type_id::create("mon",  this);
         mon.agent_name = agent_name;
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (template_is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(seqr.seq_item_export);
        end
    endfunction
endclass : template_axi_lite_agent
