class template_axi_lite_sequencer extends uvm_sequencer #(template_axi_lite_sequence_item);
  `uvm_component_utils(template_axi_lite_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass : template_axi_lite_sequencer