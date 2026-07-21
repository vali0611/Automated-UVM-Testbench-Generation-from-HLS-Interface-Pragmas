//reset agent
class axi4Lite_adder_axi_lite_reset_seq_item extends uvm_sequence_item;
  `uvm_object_utils(axi4Lite_adder_axi_lite_reset_seq_item)

    rand int reset_cycles;

    constraint c_reset_duration {
    reset_cycles inside {[2:10]}; //cate cycle uri tine
  }

  function new (string name = "axi4Lite_adder_axi_lite_reset_sequence_item");
    super.new(name);
  endfunction

  //optional: pretty printing
  virtual function string convert2string();
    return $sformatf("RESET_ITEM: tinem resetul low pentru %0d cicli de ceas", reset_cycles);
  endfunction

endclass : axi4Lite_adder_axi_lite_reset_seq_item