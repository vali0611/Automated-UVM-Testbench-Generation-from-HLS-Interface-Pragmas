class template_base_test extends uvm_test;
  `uvm_component_utils(template_base_test)

  template_env env;


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = template_env::type_id::create("env", this);

  endfunction

  virtuals task writRegister(logic [8:0] addr, logic[31:0] value);
    template_axi_lite_basic_sequence seqt_write;
    seqt_write = template_axi_lite_basic_sequence::type_id::create("seqt_write");
    seqt_write.write = 1;
    seqt_write.addr = addr;
    seqt_write.data = value;
    seqt_write.start(env.agt_axi_s.seqr);
  endtask

  virtual task reaRegister(logic[8:0] addr, ref logic[31:0] value);
    template_axi_lite_basic_sequence seqt_read;
    seqt_read = template_axi_lite_basic_sequence::type_id::create("seqt_read");
    seqt_read.write = 0;
    seqt_read.addr = addr;
    seqt_read.start(env.agt_axi_s.seqr);
    value = seqt_read.data;
  endtask


  virtual task Writ_data_stream(logic [31:0] tdata);
    template_axis_basic_sequence seqt_wrt;
    seqt_wrt = template_axis_basic_sequence::type_id::create("seqt_wrt");
    seqt_wrt.data = tdata;
    seqt_wrt.start(env.agt_axis.seqr);
  endtask

endclass

