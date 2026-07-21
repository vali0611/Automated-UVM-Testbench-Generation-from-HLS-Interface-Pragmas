`uvm_analysis_imp_decl(_AXI_S)
class template_scoreboard extends uvm_component;
  `uvm_component_utils(template_scoreboard)
  uvm_analysis_imp_AXI_S #(template_axi_lite_sequence_item, template_scoreboard) analysis_axi_s_export;

   virtual axi4Lite_adder_axi_lite_intf vif;
  bit[31:0] axi_addr;
  bit [31:0] axi_data;
  bit axi_write;
  bit axi_addr_valid;
  bit[1:0] axi_resp;
  bit [31:0] reg_map[int unsigned];
  logic [31:0] exp_data;



  // Variabile pentru coverage
  bit [31:0] cov_addr;
  bit [31:0] cov_data;
  bit cov_write;

  //Coverage
  covergroup cg_axi;
    cp_addr: coverpoint cov_addr {
      bins addr_0 = {9'h0000};
      bins addr_4 = {9'h0004};
      bins addr_8 = {9'h0008};
      bins addr_c = {9'h000c};
      bins addr_10 = {9'h0010};
      //bins addr_14 = {9'h0014}; nu-l folosesc
      bins addr_18 = {9'h0018};
      //bins addr_1c = {9'h001c};  nu-l folosesc la nimic
      bins addr_20 = {9'h0020};
      bins addr_24 = {9'h0024};
      bins unimplemented = default;
    }
    cp_data: coverpoint cov_data{
      bins pow2[] = {
        32'h0000_0001, 32'h0000_0002, 32'h0000_0004, 32'h0000_0008,
        32'h0000_0010, 32'h0000_0020, 32'h0000_0040, 32'h0000_0080,
        32'h0000_0100, 32'h0000_0200, 32'h0000_0400, 32'h0000_0800,
        32'h0000_1000, 32'h0000_2000, 32'h0000_4000, 32'h0000_8000,
        32'h0001_0000, 32'h0002_0000, 32'h0004_0000, 32'h0008_0000,
        32'h0010_0000, 32'h0020_0000, 32'h0040_0000, 32'h0080_0000,
        32'h0100_0000, 32'h0200_0000, 32'h0400_0000, 32'h0800_0000,
        32'h1000_0000, 32'h2000_0000, 32'h4000_0000, 32'h8000_0000
      };
      bins max_data = {32'hFFFF_FFFF};
      bins min_data = {32'h0000_0000};
      bins unimplemented = default;
    }
    cp_write: coverpoint cov_write{
      bins read = {0};
      bins write = {1};
    }
    cp_ap_start : coverpoint cov_data[0] iff(cov_addr == 32'h0000_0000) {
  bins zero = {0};
  bins one  = {1};
    }

    cp_ap_done : coverpoint cov_data[1] iff(cov_addr == 32'h0000_0000) {
  bins zero = {0};
  bins one  = {1};
    }

    cp_ap_idle : coverpoint cov_data[2] iff(cov_addr == 32'h0000_0000) {
  bins zero = {0};
  bins one  = {1};
  }

    cp_ap_ready : coverpoint cov_data[3] iff(cov_addr == 32'h0000_0000) {
  bins zero = {0};
  bins one  = {1};
    }

    //Crosscoverage
    x_addr_write : cross cp_addr, cp_write{
    ignore_bins ignore_write_0x20 = binsof(cp_addr) intersect {9'h0020} && binsof(cp_write) intersect {1};
    ignore_bins ignore_write_0x24 = binsof(cp_addr) intersect {9'h0024} && binsof(cp_write) intersect {1};
    ignore_bins ignore_read_0x0c = binsof(cp_addr) intersect {9'h000c} && binsof(cp_write) intersect {0};
    }

  endgroup

  function new(string name, uvm_component parent);
        super.new(name, parent);
        reg_map['h0010] = 32'h0000_0000; // singurele adrese care stocheaza date si pot fi verificate
        reg_map['h0018] = 32'h0000_0000;
        cg_axi = new();
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_axi_s_export = new("analysis_axi_s_export", this);

    if (!uvm_config_db#(virtual axi4Lite_adder_axi_lite_intf)::get(this, "", "vif_temp", vif))
    `uvm_fatal(get_type_name(), "Nu am putut prelua interfata virtuala 'vif_temp' in scoreboard!")


    `uvm_info("SCOREBOARD","SCOREBOARD DONE!",UVM_NONE)
  endfunction
  virtual task run_phase(uvm_phase phase);
  forever begin
    @(negedge vif.s_axi_aresetn);
    `uvm_info("SCOREBOARD", "Reset detectat, resetez modelul intern (reg_map)", UVM_NONE)
    reg_map['h0010] = 32'h0000_0000;
    reg_map['h0018] = 32'h0000_0000;
  end
endtask

  virtual function bit addr_valid(bit[31:0] addr);
    return reg_map.exists(addr);  //verificam daca adresa este valida
  endfunction

  virtual function void write_AXI_S(axi4Lite_adder_axi_lite_sequence_item tr);
    `uvm_info("Scoreboard",$sformatf("AXI RECEIVED ITEM: %s", tr.convert2string_scoreboard()),UVM_NONE)

    cov_addr = tr.addr;   //extragem datele pentru coverage
    cov_data = tr.data;

    if(tr.write == 1) begin
      cov_write = 1;
    end else begin
      cov_write = 0;
    end

    cg_axi.sample();

    // Logica normala a Scoreboard-ului
    if(vif.s_axi_aresetn == 1)begin
    if(tr.write == 1) begin
      if(addr_valid(tr.addr))begin
        reg_map[tr.addr] = tr.data;   //data extrasa din hardware este scrisa in registrul corespunzator adresei
      end
    end
    else begin
      if(addr_valid(tr.addr))begin
        exp_data = reg_map[tr.addr];

        if(tr.data != exp_data) begin
          `uvm_error("SCOREBOARD", $sformatf("Data mismatch at address %h: expected %h, got %h", tr.addr, exp_data, tr.data))
        end
        else if (tr.data == exp_data) begin
          `uvm_info("SCOREBOARD", $sformatf("Data match at address %h: expected %h, got %h", tr.addr, exp_data, tr.data), UVM_NONE)
        end
      end
    end
    end else begin
      `uvm_info("SCOREBOARD", "Reset-ul este activ.", UVM_NONE)
    end
  endfunction

endclass