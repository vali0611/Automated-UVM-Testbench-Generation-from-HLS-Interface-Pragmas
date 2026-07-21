class axi4Lite_adder_axi_lite_reset_driver extends uvm_driver #(axi4Lite_adder_axi_lite_reset_seq_item);
    `uvm_component_utils(axi4Lite_adder_axi_lite_reset_driver)

    virtual axi4Lite_adder_axi_lite_intf vif;

    function new(string name = "reset_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

  // Get interface via config DB
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi4Lite_adder_axi_lite_intf)::get(this, "", "vif_temp", vif)) begin
      `uvm_fatal("RESET_DRV", "Nu am putut prelua interfata virtuala 'vif' din uvm_config_db!")
    end else begin
      `uvm_info("RESET_DRV", "Interfata virtuala a fost preluata cu succes!", UVM_LOW)
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

  vif.s_axi_aresetn <= 1'b1;

    forever begin
    seq_item_port.get_next_item(req);
    @(posedge vif.s_axi_aclk);
    vif.s_axi_aresetn <= 1'b0;
    repeat(req.reset_cycles) begin
        @(posedge vif.s_axi_aclk);
      end
    vif.s_axi_aresetn <= 1'b1;
    `uvm_info("RESET_DRV", $sformatf("Resetul a fost activat pentru %0d cicli de ceas", req.reset_cycles), UVM_LOW)
    seq_item_port.item_done();
    end
  endtask : run_phase
endclass : axi4Lite_adder_axi_lite_reset_driver
