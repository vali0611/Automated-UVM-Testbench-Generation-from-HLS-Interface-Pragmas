// Basic sequence item (transaction)
class template_axi_lite_sequence_item extends uvm_sequence_item;
  `uvm_object_utils(template_axi_lite_sequence_item)

  // Address and data
  rand logic [8:0]   addr;
  rand logic [31:0]  data;     // WDATA for writes, RDATA for reads
  rand logic         write;    // 1=write, 0=read
  string name;
  // Byte enables for writes (captured by monitor; driver sets to '1 by default)
  logic  [3:0] wstrb;

  // Response code: BRESP for writes, RRESP for reads
  logic  [1:0] resp;

  // Add constraints for valid transactions
  constraint c_addr {
    addr >= 0;
    addr <= 9'h120;
    addr%4 == 0;
  }

  function new(string name = "template_axi_lite_sequence_item");
    super.new(name);
  endfunction

  // Optional: pretty printing
  function string convert2string_monitor();
    return $sformatf("axi4_lite_seq_item\n\t* addr=%0d\n\t* data=%0d\n\t* write=%0b\n\t* wstrb=%b\n\t* resp=%b",
                     addr, data, write, wstrb, resp);
  endfunction

  function string convert2string_sequence();
    return $sformatf("axi4_lite_seq_item\n\t* addr=%0d\n\t* data=%0d\n\t* write=%0b\n\t*",
                     addr, data, write);
  endfunction

   function string convert2string_scoreboard();
    return $sformatf("axi4_lite_seq_item\n\t* addr=%0d\n\t* data=%0d\n\t* write=%0b\n\t* wstrb=%b\n\t* resp=%b\n\t* from: %s\n\t*",
                     addr, data, write, wstrb, resp, name);
  endfunction
endclass : template_axi_lite_sequence_item

