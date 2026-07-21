// Basic sequence item (transaction)
class template_axis_sequence_item extends uvm_sequence_item;
  `uvm_object_utils(template_axis_sequence_item)

  rand logic [31:0]  data; //DATA to sent to the stream
  logic direction;
  string name;
  function new(string name = "template_axis_sequence_item");
    super.new(name);
  endfunction

  // Optional: pretty printing
  function string convert2string_monitor();
    return $sformatf("axi4_stream_seq_item\n\t*  data=%0d\n\t*",data);
  endfunction

  function string convert2string_sequence();
    return $sformatf("axi4_stream_seq_item\n\t*  data=%0d\n\t*",data);
  endfunction
endclass 

