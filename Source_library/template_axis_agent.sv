
class template_axis_agent extends uvm_agent;
    `uvm_component_utils(template_axis_agent)

  // Configuration knob
    uvm_active_passive_enum template_is_active = UVM_ACTIVE;

  // Sub-components
    template_axis_driver      drv;
    template_axis_monitor     mon;
    template_axis_sequencer   seqr;
    string agent_name;
    bit direction;
   

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("AGENT FOR AXI STREAM","AGENT DONE!", UVM_NONE)

         if (template_is_active == UVM_ACTIVE) begin
            seqr = template_axis_sequencer ::type_id::create("seqr", this);
            drv  = template_axis_driver ::type_id::create("drv",  this);
            drv.agent_name = agent_name;
            drv.direction = direction;
         
         end
         mon = template_axis_monitor ::type_id::create("mon",  this);
         mon.agent_name = agent_name;
         mon.direction = direction;
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (template_is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(seqr.seq_item_export);
        end
    endfunction
endclass
