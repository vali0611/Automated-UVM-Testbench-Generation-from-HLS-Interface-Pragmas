typedef uvm_sequencer #(axi4Lite_adder_axi_lite_reset_seq_item) axi4Lite_adder_axi_lite_reset_sequencer;

class axi4Lite_adder_axi_lite_reset_sequence extends uvm_sequence #(axi4Lite_adder_axi_lite_reset_seq_item);
  `uvm_object_utils(axi4Lite_adder_axi_lite_reset_sequence)

  function new(string name = "axi4Lite_adder_axi_lite_reset_sequence");
    super.new(name);
  endfunction

  virtual task body();
    axi4Lite_adder_axi_lite_reset_seq_item req;
    req = axi4Lite_adder_axi_lite_reset_seq_item::type_id::create("req");
    start_item(req);
    if (!req.randomize())
      `uvm_error(get_type_name(), "Randomizare esuata pentru reset_seq_item")
    finish_item(req);
  endtask : body
endclass : axi4Lite_adder_axi_lite_reset_sequence