class template_axi_lite_reset_agent extends uvm_agent;
    `uvm_component_utils(template_axi_lite_reset_agent)

  // Configuration knob
    uvm_active_passive_enum template_is_active = UVM_ACTIVE;

    template_axi_lite_reset_driver r_drv;
    template_axi_lite_reset_sequencer r_seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        r_drv = axi4Lite_adder_axi_lite_reset_driver::type_id::create("r_drv", this);
        r_seq = axi4Lite_adder_axi_lite_reset_sequencer::type_id::create("r_seq", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        r_drv.seq_item_port.connect(r_seq.seq_item_export);
    endfunction

endclass : template_axi_lite_reset_agent
