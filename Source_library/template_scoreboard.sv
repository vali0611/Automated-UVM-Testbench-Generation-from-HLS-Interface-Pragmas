`uvm_analysis_imp_decl(_AXIS)
`uvm_analysis_imp_decl(_AXI_S)
class template_scoreboard extends uvm_component;
  `uvm_component_utils(template_scoreboard)

  // Analysis export to connect from monitor

  uvm_analysis_imp_AXI_S #(template_axi_lite_sequence_item, template_scoreboard) analysis_axi_s_export;
  uvm_analysis_imp_AXIS #(template_axis_sequence_item, template_scoreboard) analysis_axis_export;

  function new(string name, uvm_component parent);
        super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_axi_s_export = new("analysis_axi_s_export", this);
    analysis_axis_export = new("analysis_axis_export", this);
    `uvm_info("SCOREBOARD","SCOREBOARD DONE!",UVM_NONE)
  endfunction


  virtuals function void write_AXI_S(template_axi_lite_sequence_item tr);
   `uvm_info("Scoreboard",$sformatf("AXI RECEIVED ITEM: %s", tr.convert2string_scoreboard()),UVM_NONE)
  endfunction

  virtual function void write_AXIS(template_axis_sequence_item tr);
    if(tr.direction == 1)
      `uvm_info("OUTPUT DATA",$sformatf("RESULT DATA = %0d, from: %s",tr.data, tr.name),UVM_NONE)
    else
      `uvm_info("INPUT DATA",$sformatf("INPUT DATA = %0d, from: %s",tr.data, tr.name),UVM_NONE)
  endfunction

endclass
