#include <hls_stream.h>
#include <cstdint>

void axis_axilite_test(
    uint32_t& add,
    hls::stream<uint32_t>& s_axis,
    hls::stream<uint32_t>& m_axis
) {
#pragma HLS INTERFACE axis          port=s_axis
#pragma HLS INTERFACE axis          port=m_axis
#pragma HLS INTERFACE s_axilite     port=add    bundle=reg
#pragma HLS INTERFACE ap_ctrl_none  port=return

    uint32_t in_data;

    in_data = s_axis.read();
    m_axis.write(in_data + add);
}

void axis_axilite(
    uint32_t& add,
    hls::stream<uint32_t>& s_axis,
    hls::stream<uint32_t>& m_axis
) {
#pragma HLS INTERFACE axis          port=s_axis
#pragma HLS INTERFACE axis          port=m_axis
#pragma HLS INTERFACE s_axilite     port=add    bundle=reg
#pragma HLS INTERFACE s_axilite     port=add    bundle=hex
#pragma HLS INTERFACE ap_ctrl_none  port=return

    uint32_t in_data;

    in_data = s_axis.read();
    m_axis.write(in_data + 5);

}

#include <hls_stream.h>
#include <cstdint>
void axis_multistream_test(
    hls::stream<uint32_t> & s_axis,
    hls::stream<uint32_t> & m_axis
) {
#pragma HLS INTERFACE axis port=s_axis
#pragma HLS INTERFACE axis port=m_axis
#pragma HLS INTERFACE axis port=s_axis_2
#pragma HLS INTERFACE axis port=m_axis_1
#pragma HLS INTERFACE ap_ctrl_none port=return

    uint32_t in_data;

    in_data = s_axis.read();
    m_axis.write(in_data + 1);

    in_data = s_axis_2.read();
    m_axis_1.write(in_data +10);
}
void axis_test(
    hls::stream<uint32_t>& s_axis,
    hls::stream<uint32_t>& m_axis
) {
#pragma HLS INTERFACE axis port=s_axis
#pragma HLS INTERFACE axis port=m_axis
#pragma HLS INTERFACE ap_ctrl_none port=return

    uint32_t in_data;

    in_data = s_axis.read();
    m_axis.write(in_data + 1);
}
#include <hls_stream.h>
#include <cstdint>

void axis_test(
    hls::stream<uint32_t>& s_axis,
    hls::stream<uint32_t>& m_axis
) {
#pragma HLS INTERFACE axis port=s_axis
#pragma HLS INTERFACE axis port=m_axis
#pragma HLS INTERFACE ap_ctrl_none port=return

    uint32_t in_data;

    in_data = s_axis.read();
    m_axis.write(in_data + 1);
}


void Example5(double const A[], double const B[], double C[]) {
  #pragma HLS INTERFACE m_axi port=A bundle=gmem0 offset=slave
  #pragma HLS INTERFACE m_axi port=B bundle=gmem1 offset=slave
  #pragma HLS INTERFACE m_axi port=C bundle=gmem2 offset=slave
  #pragma HLS INTERFACE s_axilite port=A bundle=control
  #pragma HLS PORT port=return
  #pragma HLS INTERFACE s_axilite port=B bundle=control_1
  #pragma HLS INTERFACE s_axilite port=C bundle=control_2
  #pragma HLS interface s_axilite port=return bundle=control_3
  #pragma HLS PORT port=return
}


void Example5_Reordered(double const A[], double const B[], double C[]) {
  #pragma HLS INTERFACE m_axi port=A bundle=gmem0 offset=slave
  #pragma HLS INTERFACE m_axi port=B bundle=gmem1 offset=slave
  #pragma HLS INTERFACE m_axi port=C bundle=gmem2 offset=slave
  #pragma HLS INTERFACE s_axilite port=A bundle=control
  #pragma HLS PORT port=return
  #pragma HLS INTERFACE s_axilite port=B bundle=control
  #pragma HLS interface s_axilite port=C bundle=control
  #pragma HLS INTERFACE s_axilite PORT=return bundle=control
}


void Example3(float const *in, float *out) {
  #pragma HLS INTERFACE m_axi port=in bundle=gmem0 offset=slave
  #pragma HLS INTERFACE m_axi port=out bundle=gmem1 offset=slave
  #pragma HLS INTERFACE s_axilite port=in
  #pragma HLS INTERFACE s_axilite port=OUT
  #pragma HLS PORT port=return
  #pragma HLS INTERFACE s_axilite port=return
}

void Example3_Time(float const *in, float *out) {
  #pragma HLS INTERFACE m_axi port=in bundle=gmem0 offset=slave
  #pragma HLS INTERFACE m_axi port=out bundle=gmem1 offset=slave
  #pragma HLS PORT port=return
  #pragma HLS INTERFACE s_axilite port=In
  #pragma HLS INTERFACE s_axilite port=out
    #pragma HLS INTERFACE s_axilite port=return
}

void axi4Lite_adder(uint32_t& in0, uint32_t& in1, uint32_t& out0){

    #pragma HLS INTERFACE s_axilite  port=return   bundle=temp
    #pragma HLS INTERFACE s_axilite  port=in0      bundle=temp
    #pragma HLS INTERFACE s_axilite  port=in1      bundle=temp
    #pragma HLS INTERFACE s_axilite  port=out0     bundle=temp

}

void axi4Lite_adder_mul(uint32_t& in0, uint32_t& in1, uint32_t& out0){
    #pragma HLS INTERFACE   s_axilite    port=return     bundle=control
    #pragma HLS INTERFACE   s_axilite    port=in0        bundle=inputs
    #pragma HLS INTERFACE   s_axilite    port=in1        bundle=inputs
    #pragma HLS INTERFACE   s_axilite    port=out0       bundle=outputs

}