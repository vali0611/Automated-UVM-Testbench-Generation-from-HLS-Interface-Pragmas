cd ../..
set proj_dir [file normalize [pwd]]
file delete -force ./vivado_Source_lib_combined

create_project sim_Source_lib_combined ./vivado_Source_lib_combined -part xc7a35tcpg236-1 -force

add_files -fileset sim_1 [list \
  $proj_dir/testbench/topt/template_axi_lite_intf.sv \
  $proj_dir/testbench/topt/template_axis_interface.sv \
  $proj_dir/testbench/topt/template_pkg.sv \
  $proj_dir/testbench/topt/template_top.sv \
]
add_files -fileset sources_1 [list \
  $proj_dir/dut/topx.v\
  #!PLEASE ADD THE REST OF YOUR DESIGN!
]

set_property file_type SystemVerilog [get_files [list \
  $proj_dir/testbench/topt/template_axi_lite_intf.sv \
  $proj_dir/testbench/topt/template_axis_interface.sv \
  $proj_dir/testbench/topt/template_pkg.sv \
  $proj_dir/testbench/topt/template_top.sv \
]]

set_property top template_top [get_filesets sim_1]


update_compile_order -fileset sim_1
update_compile_order -fileset sources_1
