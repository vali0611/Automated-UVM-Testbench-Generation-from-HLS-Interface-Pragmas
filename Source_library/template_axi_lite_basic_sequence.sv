// Basic example sequence that produces seq_item transactions
class template_axi_lite_basic_sequence extends uvm_sequence #(template_axi_lite_sequence_item);
  `uvm_object_utils(template_axi_lite_basic_sequence)

  int unsigned num_items = 1;
  logic        random;
  logic [31:0] data;
  logic        write;
  logic [8:0]  addr;// 1-write, 0-read


  function new(string name = "basic_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), $sformatf("Starting AXILITE_M sequence with %0d items", num_items), UVM_MEDIUM)
    repeat (num_items) begin
      req = template_axi_lite_sequence_item::type_id::create("req");
      if(random) begin
        if (!req.randomize()) `uvm_error(get_type_name(), "AXILITE_M randomization failed")
      end
      else begin
        req.data = data;
        req.addr = addr;
        req.write = write;
      end
      
      start_item(req);
         //if (req.write)
      `uvm_info("BASIC SEQUENCE", req.convert2string_sequence(),UVM_NONE)

      finish_item(req);

      if (!req.write) begin
        template_axi_lite_sequence_item rsp_seq;
        get_response(rsp_seq);
        data = rsp_seq.data;
        `uvm_info("BASIC SEQUENCE", rsp_seq.convert2string_sequence(),UVM_NONE)
       // `uvm_info("SEQUENCE", $sformatf("GOT DATA RESPONSE =%0d AND FROM RSP = %0d", data, rsp_seq.data),UVM_NONE)
      end
    end
  endtask : body
endclass : template_axi_lite_basic_sequence
