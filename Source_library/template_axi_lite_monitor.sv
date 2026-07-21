class axi4Lite_adder_axi_lite_monitor extends uvm_component;
  `uvm_component_utils(axi4Lite_adder_axi_lite_monitor)


    virtual axi4Lite_adder_axi_lite_intf vif;
    string agent_name;
    uvm_analysis_port #(axi4Lite_adder_axi_lite_sequence_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("MON","MONITOR DONE!",UVM_NONE)
        ap = new("ap", this);
        if (!uvm_config_db#(virtual axi4Lite_adder_axi_lite_intf)::get(this, "", $sformatf("vif_%s",agent_name), vif))
            `uvm_fatal(get_type_name(), "virtual interface not set for monitor")
        else
            `uvm_info("MON INTF","GOT INTERFACE!",UVM_NONE)
    endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    fork
      forever begin // WRITE

       axi4Lite_adder_axi_lite_sequence_item tr;
        logic [8:0]   awaddr;
        logic [31:0]  wdata;
        logic [3:0]   wstrb;
        logic [1:0]   bresp;
        // Address handshake
        wait (vif.s_axi_awvalid && vif.s_axi_awready);
        awaddr = vif.s_axi_awaddr;

        // Data handshake
        wait (vif.s_axi_wvalid && vif.s_axi_wready);
        wdata  = vif.s_axi_wdata;
        wstrb  = vif.s_axi_wstrb;

        // Response handshake
        wait (vif.s_axi_bvalid && vif.s_axi_bready);
        bresp  = vif.s_axi_bresp;

        tr = axi4Lite_adder_axi_lite_sequence_item::type_id::create("wr_tr");
        tr.write = 1;
        tr.addr  = awaddr;
        tr.data  = wdata;
        tr.wstrb = wstrb;
        tr.resp  = bresp;
        tr.name = agent_name;
        `uvm_info("[MONITOR]", $sformatf("WRITE: %s", tr.convert2string_monitor()), UVM_NONE)
        ap.write(tr);
      end

      forever begin // READ
       axi4Lite_adder_axi_lite_sequence_item tr;
        bit [8:0]   araddr;
        bit [31:0]  rdata;
        bit [1:0]   rresp;

        // Address handshake
        wait (vif.s_axi_arvalid && vif.s_axi_arready);
        araddr = vif.s_axi_araddr;

        // Data/resp handshake
        wait (vif.s_axi_rvalid && vif.s_axi_rready);
        rdata  = vif.s_axi_rdata;
        rresp  = vif.s_axi_rresp;

        tr = axi4Lite_adder_axi_lite_sequence_item::type_id::create("rd_tr");
        tr.write = 0;
        tr.addr  = araddr;
        tr.data  = rdata;
        tr.wstrb = 4'b0000;
        tr.resp  = rresp;
        tr.name = agent_name;
        `uvm_info("[MONITOR]", $sformatf("READ: %s", tr.convert2string_monitor()), UVM_NONE)
        ap.write(tr);
      end
    join

  endtask : run_phase
endclass : axi4Lite_adder_axi_lite_monitor
