// Basic example sequence that produces seq_item transactions
class template_axis_basic_sequence extends uvm_sequence #(template_axis_sequence_item);
  `uvm_object_utils(template_axis_basic_sequence)

  int unsigned num_items = 1;
  logic [31:0] data;
  logic        random;

  template_axis_sequence_item req_axis;

  function new(string name = "basic_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Starting AXIS sequence", UVM_NONE)
    
      req_axis = template_axis_sequence_item::type_id::create("req_axis");
      if(random) begin
        if (!req_axis.randomize()) `uvm_error(get_type_name(), "AXIS randomization failed")
      end
      else 
        req_axis.data = data;
      
      start_item(req_axis);

      `uvm_info("BASIC SEQUENCE", req_axis.convert2string_sequence(),UVM_NONE)

      finish_item(req_axis);

  endtask 
endclass 
