class template_axis_driver extends uvm_driver #(template_axis_sequence_item);
    `uvm_component_utils(template_axis_driver)

    virtual template_axis_interface vif;
    string agent_name;
    template_axis_sequence_item req;
    bit direction;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     `uvm_info("DRV","DRIVER DONE!", UVM_NONE)
     `uvm_info("CHECK",$sformatf("DIRECTION = %0d",direction),UVM_NONE)
     
    if (!uvm_config_db#(virtual template_axis_interface)::get(this,"",$sformatf("vif_%s",agent_name), vif))
      `uvm_fatal(get_type_name(), "virtual interface not set for driver")
    else
      `uvm_info("DRV_INTF","GOT INTERFACE!",UVM_NONE)

  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork begin
    if(direction == 0)begin
    forever begin
      
          `uvm_info("START ITEM WRITE","ITEM STARTED...",UVM_NONE)
            seq_item_port.get_next_item(req);
            vif.axis_tvalid <= 1;
            vif.axis_tdata <= req.data;
            while(!(vif.axis_tvalid == 1 && vif.axis_tready==1))
                @(posedge vif.axis_clk);
            vif.axis_tvalid <= 0;
            vif.axis_tdata <= 0;
            seq_item_port.item_done();
             `uvm_info("ENDED ITEM WRITE","ITEM ENDED...",UVM_NONE)
        end
    end
    end
    begin
       if(direction == 1)begin
           `uvm_info("START ITEM READ","ITEM STARTED...",UVM_NONE)
            vif.axis_tready <= 1;
            while(!(vif.axis_tvalid == 1 && vif.axis_tready==1))
                @(posedge vif.axis_clk);
           `uvm_info("ENDED ITEM READ","ITEM ENDED...",UVM_NONE) 
        end
    end
    join_none

   
  endtask
endclass 
