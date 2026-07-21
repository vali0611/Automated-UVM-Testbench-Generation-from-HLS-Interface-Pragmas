class axi4Lite_adder_axi_lite_driver extends uvm_driver #(axi4Lite_adder_axi_lite_sequence_item);
    `uvm_component_utils(axi4Lite_adder_axi_lite_driver)

    virtual axi4Lite_adder_axi_lite_intf vif;
    string agent_name;
    axi4Lite_adder_axi_lite_sequence_item req;
    axi4Lite_adder_axi_lite_sequence_item rsp;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

  // Get interface via config DB
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi4Lite_adder_axi_lite_intf)::get(this, "", $sformatf("vif_%s",agent_name), vif))
      `uvm_fatal(get_type_name(), "virtual interface not set for driver")
    else
      `uvm_info("DRV_INTF","GOT INTERFACE!",UVM_NONE)

  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("DRV","DRIVER DONE!", UVM_NONE)
    forever begin

	fork
		begin
	//wait until there is an item available and get it
    	seq_item_port.get_next_item(req);
		 rsp = axi4Lite_adder_axi_lite_sequence_item::type_id::create("rsp");

      rsp.set_id_info(req);

      `uvm_info("AXI4_LITE_DRIVER", $sformatf("Got new item: %s", req.convert2string()), UVM_DEBUG)

      if(req.write == 1) begin // write
        // WSTRB = 4'b1111 to write all bytes; can be modified to do partial writes
        vif.s_axi_wstrb = '1;
		// Drive the address and data
		vif.s_axi_wdata  = req.data;
		vif.s_axi_awaddr = req.addr;
		// Signal that the data and the address are valid on the bus
		vif.s_axi_awvalid = 1;
		vif.s_axi_wvalid  = 1;

		// Wait until the consumer acknowledges the data and the address, then clear the valid signals
		wait(vif.s_axi_awready == 1 );
		@(posedge vif.s_axi_aclk);
		vif.s_axi_awvalid = 0;

		wait(vif.s_axi_wready == 1);
		@(posedge vif.s_axi_aclk);
		vif.s_axi_wvalid  = 0;

		// // Wait until the consumer aknowledges the write and check the response
		wait(vif.s_axi_bvalid == 1);
		@(posedge vif.s_axi_aclk);
		if(vif.s_axi_bresp == 0)
			`uvm_info("[DRIVER]", "Write access successfull", UVM_NONE)
		else
			`uvm_warning("[DRIVER]", $sformatf("The previous write access generated %0b response", vif.s_axi_bresp))

		// // Acknowledge the response by setting BREADY for 1 clock cycle
		vif.s_axi_bready = 1;
		@(posedge vif.s_axi_aclk);
		vif.s_axi_bready = 0;

        vif.s_axi_wstrb = 0;

		end
		else begin // read
			// Drive the address and signal that it is valid
			vif.s_axi_araddr = req.addr;
			vif.s_axi_arvalid = 1;

			// Wait until the consumer acknowldedges the address, then clear the valid signal
			wait (vif.s_axi_arready == 1);
			@(posedge vif.s_axi_aclk );
			vif.s_axi_arvalid = 0;

			// // Wait until the consumer signals that the read data is available on the bus
			wait (vif.s_axi_rvalid  == 1);

			// // Check the response
			// // If successful, print the data in the log. This is only for debugging purposes, since the monitor will capture it
			@(posedge vif.s_axi_aclk);
			if(vif.s_axi_rresp == 0) begin
				`uvm_info("[DRIVER]", $sformatf("Successfully read data %0d", vif.s_axi_rdata), UVM_NONE)
				rsp.data = vif.s_axi_rdata;
				rsp.addr = req.addr;
				rsp.write = req.write;
			end
			else
				`uvm_warning("[DRIVER]", $sformatf("The previous read access generated %0b response", vif.s_axi_bresp))

			// // Acknowledge the response by setting RREADY for 1 clock cycle
			vif.s_axi_rready  = 1;
			@(posedge vif.s_axi_aclk);
			vif.s_axi_rready  = 0;

			  `uvm_info("RSP ITEM",$sformatf("item data : addr = %0d , data = %0d",rsp.addr,rsp.data),UVM_NONE)
			  seq_item_port.put(rsp);
		end


      seq_item_port.item_done();
	  req = null;
	end

	begin
		wait(vif.s_axi_aresetn == 1'h0);
	end

	join_any

	disable fork;

	if(vif.s_axi_aresetn == 0) begin
		`uvm_warning ("DRIVER", "RESET DETECTAT PUNEM DRIVER PE PAUZA")
		if (req != null) begin
            seq_item_port.item_done();
            req = null;
	end

		vif.s_axi_awvalid = 0;
        vif.s_axi_wvalid  = 0;
        vif.s_axi_arvalid = 0;
        vif.s_axi_bready  = 0;
        vif.s_axi_rready  = 0;

wait(vif.s_axi_aresetn == 1'b1);
      end
	end
  endtask : run_phase
endclass : axi4Lite_adder_axi_lite_driver
