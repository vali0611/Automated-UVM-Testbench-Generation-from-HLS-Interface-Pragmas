class template_axis_monitor extends uvm_component;
  `uvm_component_utils(template_axis_monitor)


    virtual template_axis_interface vif;
    string agent_name;
    uvm_analysis_port #(template_axis_sequence_item) ap;
    
    bit direction;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
         `uvm_info("CHECK",$sformatf("DIRECTION = %0d",direction),UVM_NONE)
        `uvm_info("MON","MONITOR DONE!",UVM_NONE)
        ap = new("ap", this);

      if (!uvm_config_db#(virtual template_axis_interface)::get(this,"", $sformatf("vif_%s",agent_name), vif))
        `uvm_fatal(get_type_name(), "virtual interface not set for monitor")
      else
        `uvm_info("DRV_INTF","GOT INTERFACE!",UVM_NONE)

   

    endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      template_axis_sequence_item axis_item;
      axis_item =  template_axis_sequence_item::type_id::create("axis_item");
      do
        @(posedge vif.axis_clk);
      while(!(vif.axis_tvalid == 1 && vif.axis_tready==1));
      
      axis_item.data = vif.axis_tdata;
      axis_item.direction = direction;
      axis_item.name = agent_name;
      `uvm_info("MONITOR",$sformatf("Collected tdata = %0d with %0d direction",axis_item.data, axis_item.direction),UVM_NONE)
      ap.write(axis_item);
    end
  endtask 
endclass 
