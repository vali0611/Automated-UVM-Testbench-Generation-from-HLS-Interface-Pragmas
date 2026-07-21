class template_axis_sequencer extends uvm_sequencer #(template_axis_sequence_item);
  `uvm_component_utils(template_axis_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass