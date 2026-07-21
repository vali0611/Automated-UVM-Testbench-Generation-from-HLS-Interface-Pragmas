class template_test extends template_base_test;
  `uvm_component_utils(template_test)


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("REGISTER TEST","REGISTER TEST OK!",UVM_NONE)
  endfunction

  virtual task run_phase(uvm_phase phase);

    logic [31:0] wdata;
    logic [31:0] rdata;
    phase.raise_objection(this);

    `uvm_info("REGISTER_TEST", "START SENDING ITEMS..", UVM_NONE)
    for(int addr = 0; addr <= 8'h18; addr=addr+4) begin
        wdata = $random();
        Wrik_data_stream(wdata);
        writRegister(addr, wdata);
        reaRegister(addr, rdata);
        `uvm_info("REGISTER_TEST", $sformatf("Read data=%0d\n", rdata), UVM_NONE)
    end

     phase.drop_objection(this);
  endtask
endclass

