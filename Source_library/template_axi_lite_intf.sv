`timescale 1ps / 1ps

interface axi4Lite_adder_axi_lite_intf(input logic s_axi_aclk);
  logic s_axi_aresetn;

  // AXI4-Lite interface
  logic [8:0]   s_axi_awaddr;
  logic         s_axi_awvalid = 0;
  logic         s_axi_awready;
  logic [31:0]  s_axi_wdata;
  logic [3:0]   s_axi_wstrb;
  logic         s_axi_wvalid = 0;
  logic         s_axi_wready;
  logic [1:0]   s_axi_bresp;
  logic         s_axi_bvalid;
  logic         s_axi_bready = 0;
  logic [8:0]   s_axi_araddr;
  logic         s_axi_arvalid = 0;
  logic         s_axi_arready;
  logic [31:0]  s_axi_rdata;
  logic [1:0]   s_axi_rresp;
  logic         s_axi_rvalid;
  logic         s_axi_rready = 0;

  property stable_awvalid;
  @(posedge s_axi_aclk) disable iff(!s_axi_aresetn)
  (s_axi_awvalid && !s_axi_awready) |=> s_axi_awvalid;
  endproperty

  property stable_awaddr;
  @(posedge s_axi_aclk) disable iff(!s_axi_aresetn)
  (s_axi_awvalid && !s_axi_awready) |=> $stable(s_axi_awaddr);
  endproperty

  property stable_wvalid;
  @(posedge s_axi_aclk) disable iff(!s_axi_aresetn)
  (s_axi_wvalid && !s_axi_wready) |=> s_axi_wvalid;
  endproperty

  property stable_wdata;
  @(posedge s_axi_aclk) disable iff(!s_axi_aresetn)
  (s_axi_wvalid && !s_axi_wready) |=> $stable(s_axi_wdata);
  endproperty
  property stable_arvalid;
    @(posedge s_axi_aclk) disable iff(!s_axi_aresetn)
    (s_axi_arvalid && !s_axi_arready) |=> s_axi_arvalid;
  endproperty

  property stable_araddr;
    @(posedge s_axi_aclk) disable iff(!s_axi_aresetn)
    (s_axi_arvalid && !s_axi_arready) |=> $stable(s_axi_araddr);
  endproperty

  property stable_rvalid;
    @(posedge s_axi_aclk) disable iff(!s_axi_aresetn)
    (s_axi_rvalid && !s_axi_rready) |=> s_axi_rvalid;
  endproperty

  property stable_rdata;
    @(posedge s_axi_aclk) disable iff(!s_axi_aresetn)
    (s_axi_rvalid && !s_axi_rready) |=> $stable(s_axi_rdata);
  endproperty

  assert property (stable_awvalid)
  else $error("AWVALID COBORAT INAINTE DE HANDSHAKE CU AWREADY! ");

  assert property (stable_awaddr)
  else $error("AWADDR MODIFICAT INAINTE DE HANDSHAKE! ");

  assert property (stable_wvalid)
  else $error("WVALID COBORAT INAINTE DE HANDSHAKE CU WREADY! ");

  assert property (stable_wdata)
  else $error("WDATA MODIFICAT INAINTE DE HANDSHAKE! ");

  assert property (stable_arvalid)
  else $error("ARVALID COBORAT INAINTE DE HANDSHAKE CU ARREADY!");

  assert property (stable_araddr)
  else $error("ARADDR MODIFICAT INAINTE DE HANDSHAKE!");

  assert property (stable_rvalid)
  else $error("RVALID COBORAT INAINTE DE HANDSHAKE CU RREADY!");

  assert property (stable_rdata)
  else $error("RDATA MODIFICAT INAINTE DE HANDSHAKE!");

//INJECTARE EROARE
//  initial begin
//      #100; //asteptam sa inceapa simularea
//
//      @(posedge s_axi_aclk);
//
  //    force s_axi_awvalid = 1;
//      force s_axi_awready = 0;
//
 //     @(posedge s_axi_aclk);
//
//      force s_axi_awvalid = 0; //aici apare eroarea
//
//      @(posedge s_axi_aclk);
//
//      release s_axi_awvalid;
//      release s_axi_awready;
//  end


property reset_check;
  @(posedge s_axi_aclk)
  (!s_axi_aresetn) |-> (s_axi_awvalid == 0) && (s_axi_wvalid == 0) && (s_axi_bvalid == 0)
                     && (s_axi_arvalid == 0) && (s_axi_rvalid == 0)
                     && (s_axi_bready == 0) && (s_axi_rready == 0);
endproperty

assert property (reset_check)
else $error("RESET-UL NU A RESETAT PROTOCOLUL AXI!");

// X Z CHECK
    property X_Z_check;
    @(posedge s_axi_aclk) disable iff(s_axi_aresetn!== 1)
    !$isunknown({s_axi_awvalid, s_axi_awready, s_axi_wvalid, s_axi_wready,
                 s_axi_bvalid, s_axi_arready,
                 s_axi_rvalid});
    endproperty
    assert property (X_Z_check)
    else $error("X SAU Z APARUTE IN TIMPUL FUNCTIONARII NORMALE");

  property delayed_check; //folosesc logica "once known. always known"
  @(posedge s_axi_aclk) disable iff(s_axi_aresetn !== 1)
    (!$isunknown(s_axi_bready)) |=> (!$isunknown(s_axi_bready)) and     //daca una din ele nu indeplineste conditia
    (!$isunknown(s_axi_arvalid)) |=> (!$isunknown(s_axi_arvalid)) and   //apare eroare
    (!$isunknown(s_axi_rready)) |=> (!$isunknown(s_axi_rready));
  endproperty

  assert property(delayed_check)
  else $error("X SAU Z APARUTE IN TIMPUL FUNCTIONARII NORMALE");

  property XZ_awaddr;
  @(posedge s_axi_aclk) disable iff(s_axi_aresetn!== 1)
  s_axi_awvalid |-> !$isunknown(s_axi_awaddr);
  endproperty

  assert property(XZ_awaddr)
  else $error("X SAU Z APARUTE IN AWADDR! ");

  property XZ_wdata;
  @(posedge s_axi_aclk) disable iff(s_axi_aresetn!== 1)
  s_axi_wvalid |-> !$isunknown(s_axi_wdata);
  endproperty

  assert property(XZ_wdata)
  else $error("X SAU Z APARUTE IN WDATA! ");

  property XZ_araddr;
  @(posedge s_axi_aclk) disable iff(s_axi_aresetn!== 1)
  s_axi_arvalid |-> !$isunknown(s_axi_araddr);
  endproperty

  assert property(XZ_araddr)
  else $error("X SAU Z APARUTE IN ARADDR! ");

  property XZ_rdata;
  @(posedge s_axi_aclk) disable iff(s_axi_aresetn!== 1)
  s_axi_rvalid |-> !$isunknown(s_axi_rdata);
  endproperty

  assert property(XZ_rdata)
  else $error("X SAU Z APARUTE IN RDATA! ");

endinterface :axi4Lite_adder_axi_lite_intf
