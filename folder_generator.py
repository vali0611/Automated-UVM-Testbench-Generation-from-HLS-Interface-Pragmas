import os.path
import json
import re
import os
import warnings
import shutil
# ------------------------------------------Initialise Generator------------------------------------------------------------------------
# AXI SLAVE
axi_s_pkg_content_file = ""
axi_s_intf_content_file = ""
axi_s_driver_content_file = ""
axi_s_reset_driver_content_file = ""
axi_s_sequencer_content_file = ""
axi_s_agent_content_file = ""
axi_s_reset_agent_content_file = ""
axi_s_monitor_content_file = ""
axi_s_basic_sequence_content_file = ""
axi_s_reset_sequence_content_file = ""
axi_s_sequence_item_content_file = ""
axi_s_reset_seq_item_content_file = ""


# AXI STREAM
axis_pkg_content_file = ""
axis_intf_content_file = ""
axis_driver_content_file = ""
axis_sequencer_content_file = ""
axis_agent_content_file = ""
axis_monitor_content_file = ""
axis_basic_sequence_content_file = ""
axis_sequence_item_content_file = ""

# Scripting
check_sim_content_file = ""
run_all_content_file = ""
run_gui_content_file = ""
tasks_content_file = ""
create_project_content_file = ""

# COMMON CONTENT
scoreboard_content_file = ""
environment_content_file = ""
base_test_content_file = ""
test_content_file = ""
top_content_file = ""
combined_pkg_content_file = ""
#NO MAIN FUNCTION
no_func_top_content_file = ""
no_func_pkg_content_file = ""
# --------------------------------------------Config Json Parser----------------------------------------------------------------------------
config_json = ""
with open("config_json.json") as file:
	config_json = file.read();
config_json = json.loads(config_json)
# ----------------------------------------------Path Config------------------------------------------------------------------------------
path = config_json["directory path"]
print(path)
print("\n")
path_tb = path + "\\testbench"
path_rtl = path + "\\rtl"
path_script = path + "\\.vscode"
path_source = "C:\\Users\\Vali\\Desktop\\Practica\\Python\\Source_library"
# ---------------------------------------------Sturcture Json parser------------------------------------------------------------------------------
content_json = ""
with open("parser_json.json") as file:
	content_json = file.read()
content_json = json.loads(content_json)
keys = content_json.keys()
key_found = 0;
structure_name = ""
rtl_name = ""
for key in keys:
	if (key == config_json["function name"]):
		print("Selected function: ")
		print(key)
		print("Generating your structure...")
		key_found = 1;
		structure_name = config_json["function name"];
		break;
if key_found == 0:
	warnings.warn("Warning!Selected function doesn't exist!")
	print("Generating demo testbench with your username..")
	structure_name = config_json["username"];

rtl_name = config_json["rtl name"];
# -----------------------------------------------Delete Config---------------------------------------------------------------------
path_final = path + "\\" + structure_name
print(path_final)
if config_json["delete_folders"] == 1:
	if (os.path.isdir(path_final)):
		shutil.rmtree(path_final)
		print("Structure deleted")
	#else:
	#	print("Nothing to delete")
	#exit();
# ---------------------------------------- Bundle collector-------------------------------------------------------------------------------
if key_found == 1:
	pragma = content_json[config_json["function name"]]["Pragmas"]

slave_bundles = []

if key_found == 1:
	for value in pragma:
		if value["protocol"] == "s_axilite":
			if value["bundle"] != "-":
				slave_bundles.append(value["bundle"])

	slave_bundles = set(slave_bundles)
# ----------------------------------------AXI4Lite content collector-------------------------------------------------------------------------------
os.chdir(path_source)
is_axi_s = 0;
is_axis = 0;
if key_found == 1:
	for value in pragma:
		if value["protocol"] == "s_axilite":
			is_axi_s = 1;
			with open("template_axi_lite_basic_sequence.sv") as file:
				axi_s_basic_sequence_content_file = file.read();
			with open("template_axi_lite_reset_sequence.sv") as file:
				axi_s_reset_sequence_content_file = file.read();
			with open("template_axi_lite_sequence_item.sv") as file:
				axi_s_sequence_item_content_file = file.read();
			with open("template_axi_lite_reset_seq_item.sv") as file:
				axi_s_reset_seq_item_content_file = file.read();
			with open("template_axi_lite_intf.sv") as file:
				axi_s_intf_content_file = file.read();
			with open("template_axi_lite_sequencer.sv") as file:
				axi_s_sequencer_content_file = file.read();
			with open("template_axi_lite_agent.sv") as file:
				axi_s_agent_content_file = file.read();
			with open("template_axi_lite_reset_agent.sv") as file:
				axi_s_reset_agent_content_file = file.read();
			with open("template_axi_lite_driver.sv") as file:
				axi_s_driver_content_file = file.read();
			with open("template_axi_lite_reset_driver.sv") as file:
				axi_s_reset_driver_content_file = file.read();
			with open("template_axi_lite_monitor.sv") as file:
				axi_s_monitor_content_file = file.read();
# --------------------------------------------------------------AXIS Stream Content Collector--------------------------------------------------------------------------
		elif value["protocol"] == "axis":
			is_axis = 1;
			with open("template_axis_basic_sequence.sv") as file:
				axis_basic_sequence_content_file = file.read();
			with open("template_axis_sequence_item.sv") as file:
				axis_sequence_item_content_file = file.read();
			with open("template_axis_interface.sv") as file:
				axis_intf_content_file = file.read();
			with open("template_axis_sequencer.sv") as file:
				axis_sequencer_content_file = file.read();
			with open("template_axis_agent.sv") as file:
				axis_agent_content_file = file.read();
			with open("template_axis_driver.sv") as file:
				axis_driver_content_file = file.read();
			with open("template_axis_monitor.sv") as file:
				axis_monitor_content_file = file.read();
# ------------------------------------------------------------Common Content File------------------------------------------------------------------------------------
if is_axis == 1 and is_axi_s == 1:
    with open("template_pkg.sv") as file:
       combined_pkg_content_file = file.read()
    with open("template_scoreboard.sv") as file:
       scoreboard_content_file = file.read()

elif is_axis == 1 and is_axi_s == 0:
    with open("template_axis_pkg.sv") as file:
       axis_pkg_content_file = file.read()
    with open("template_scoreboard.sv") as file:
       scoreboard_content_file = file.read()

elif is_axis == 0 and is_axi_s == 1:
    with open("template_axi_s_pkg.sv") as file:
       axi_s_pkg_content_file = file.read()
    with open("template_axi_lite_scoreboard.sv") as file:
       scoreboard_content_file = file.read()

with open("template_env.sv") as file:
	environment_content_file = file.read();
with open("template_base_test.sv") as file:
	base_test_content_file = file.read();
with open("template_test.sv") as file:
	test_content_file = file.read();
with open("template_top.sv") as file:
	top_content_file = file.read();
#-----------------------------------------------------------------No funcyion content files--------------------------------------------------
with open("no_func_top.sv") as file:
	no_func_top_content_file = file.read();
with open("no_func_pkg.sv") as file:
	no_func_pkg_content_file = file.read();
# ----------------------------------------------------------------Scripting Content Collector--------------------------------------------------------------------------------
with open("check_sim.tcl") as file:
	check_sim_content_file = file.read();
with open("run_all.bat") as file:
	run_all_content_file = file.read();
with open("run_sim_gui.tcl") as file:
	run_gui_content_file = file.read();
with open("tasks.json") as file:
	tasks_content_file = file.read();
with open("create_project.tcl") as file:
	create_project_content_file = file.read();
# -----------------------------------------------Operation Collector-----------------------------------------------------------------------------------
if key_found == 1 and is_axis == 1:
	operations = content_json[config_json["function name"]]["Operation"];
# -------------------------------------------File Editor TOP---------------------------------------------------------------------------------
pattern = re.compile(
	r"""
    \s*
    (`timescale[\s\S]*?(?=importt))
    \s*
    (importt[\s\S]*?(?=tempt))
    \s*
    (tempt[\s\S]*?(?=templaty))
    \s*
    (templaty[\s\S]*?(?=axi_dut))
    \s*
    (axi_dut [\s\S]*?(?=.s_axi))
    \s*
    (.s_axi[\s\S]*?(?=.tempy))
    \s*
    (.tempy[\s\S]*?(?=\);))\);
    \s*
    (initial[\s\S]*?(?=uvm))
    \s*
    (uvm[\s\S]*?(?=uvm))
    \s*
    (uvm[\s\S]*?(?=end))
    \s*
    (end[\s\S]*?top)
""",
	re.VERBOSE | re.DOTALL
)
matches = pattern.findall(top_content_file)
top_template = ""
template_imports = ""
template_axi_slave_intf = "\t"
template_axis_intf = "\t"
template_dut = ""
template_axi_slave_signals = ""
template_axis_signals = ""
template_clk_and_rst = ""
template_axi_slave_config = ""
template_axis_config = ""
template_start_test = ""

axi_slave_intf_ex = ""
axis_intf_ex = ""
axi_slave_dut_ex = ""
axis_dut_ex = ""
axi_slave_config_ex = ""
axis_config_ex = ""

for top, imports, axi_s_intf, axis_intf, dut, axi_s_signals, axis_signals, clk_rst, axi_s_config, axis_config, test in matches:
	top_template = top;
	template_imports = imports;
	template_axi_slave_intf = axi_s_intf;
	template_axis_intf = axis_intf;
	template_dut = dut;
	template_axi_slave_signals = axi_s_signals;
	template_axis_signals = axis_signals;
	template_clk_and_rst = clk_rst;
	template_axi_slave_config = axi_s_config;
	template_axis_config = axis_config;
	template_start_test = test;

# set_intf_template = set_intf_template.strip();
final_imports = template_imports.replace("importt", "import");
final_imports = final_imports.replace("templatk", structure_name)
# if(is_axi_s == 1 and is_axis == 1) or (is_axi_s == 0 and is_axis == 0):
final_imports = final_imports.replace("template", structure_name);
if (is_axis == 1 and is_axi_s == 0):
	final_imports = final_imports.replace("importt", "import");
	final_imports = final_imports.replace("tempx", structure_name + "_axis");
if (is_axis == 0 and is_axi_s == 1):
	final_imports = final_imports.replace("tempx", structure_name + "_axi_s");
	final_imports = final_imports.replace("importt", "import");
if (is_axis == 0 and is_axi_s == 0):
	final_imports = final_imports.replace("import tempx_pkg::*;\n\n\n", "")
if (is_axi_s == 0):
	final_imports = final_imports.replace('`include "' + structure_name + '_axi_lite_intf.sv"', "")
if (is_axis == 0):
	final_imports = final_imports.replace('`include "' + structure_name + '_axis_interface.sv"', "")
template_dut = template_dut.replace("axi_dut", rtl_name);
template_start_test = template_start_test.replace("template", structure_name);
if (is_axis == 0 and is_axi_s == 0) or (is_axis == 1 and is_axi_s == 1):
	final_imports = final_imports.replace("tempx", structure_name);

if (is_axi_s == 1):
	for bundle in slave_bundles:
		axi_slave_intf_ex = axi_slave_intf_ex + template_axi_slave_intf + "\n\t";
		axi_slave_intf_ex = axi_slave_intf_ex.replace("tempt", structure_name);
		axi_slave_intf_ex = axi_slave_intf_ex.replace("template", bundle);

		axi_slave_dut_ex = axi_slave_dut_ex + template_axi_slave_signals + "\n\t";
		axi_slave_dut_ex = axi_slave_dut_ex.replace("tempt", bundle);
		axi_slave_dut_ex = axi_slave_dut_ex.replace("template", bundle);

		axi_slave_config_ex = axi_slave_config_ex + template_axi_slave_config + "\n\t";
		axi_slave_config_ex = axi_slave_config_ex.replace("template", structure_name);
		axi_slave_config_ex = axi_slave_config_ex.replace("xvif", "vif_" + bundle);
		axi_slave_config_ex = axi_slave_config_ex.replace("tempt", bundle);

	axi_slave_dut_ex = axi_slave_dut_ex.rstrip("\n\t");
	if len(slave_bundles) == 0:
		intf_ex = intf_template.replace("tempt", structure_name);
		intf_ex = intf_ex.replace("template", structure_name);

		template_axi_slave_signals = dut_signal_template.replace("tempt", structure_name);
		template_axi_slave_signals = template_axi_slave_signals.replace("template", structure_name);

		axi_slave_config_ex = set_intf_template.replace("template", structure_name);
		axi_slave_config_ex = axi_slave_config_ex.replace("tempt", structure_name);
		axi_slave_config_ex = axi_slave_config_ex.replace("xvif", "vif_" + structure_name);

if (is_axis == 1):
	for operation in operations:
		axis_intf_ex = axis_intf_ex + template_axis_intf + "\n\t";
		axis_intf_ex = axis_intf_ex.replace("templaty", structure_name);
		axis_intf_ex = axis_intf_ex.replace("template", operation["module"]);

		axis_dut_ex = axis_dut_ex + template_axis_signals + " \n\t";
		axis_dut_ex = axis_dut_ex.replace("tempy", operation["module"]);
		axis_dut_ex = axis_dut_ex.replace("template", operation["module"]);

		axis_config_ex = axis_config_ex + template_axis_config + " \n\t";
		axis_config_ex = axis_config_ex.replace("template", structure_name);
		axis_config_ex = axis_config_ex.replace("yvif", "vif_" + operation["module"]);
		axis_config_ex = axis_config_ex.replace("tempt", operation["module"]);

	axis_dut_ex = axis_dut_ex.rstrip("\n\t");
final_signals_dut = axi_slave_dut_ex + axis_dut_ex
final_signals_dut = final_signals_dut.rstrip()
final_signals_dut = final_signals_dut.rstrip(",")
final_signals_dut = final_signals_dut + "\n\t);\n";
final_top = top_template + final_imports + axi_slave_intf_ex + axis_intf_ex + template_dut + final_signals_dut + template_clk_and_rst + axi_slave_config_ex + axis_config_ex + template_start_test;
# ------------------------------------------File Editor ENV-----------------------------------------------------------------------------
pattern = re.compile(
	r"""
(class[\s\S]*?(?=template_axi_lite_agent))
\s*
(template_axi_lite_agent[\s\S]*?(?=template_axis_agent))
\s*
(template_axis_agent[\s\S]*?(?=virtual))
\s*
(virtual[\s\S]*?(?=agt_axi_s))
\s*
(agt_axi_s[\s\S]*?(?=agt_axis))
\s*
(agt_axis[\s\S]*?(?=endfunction))
\s*
(endfunction[\s\S]*?(?=agt_axi_s))
\s*
(agt_axi_s[\s\S]*?(?=agt_axis))
\s*
(agt_axis[\s\S]*?(?=endfunction))
\s*
(endfunction[\s\S]*?endclass)

""",
	re.VERBOSE | re.DOTALL
)
matches = pattern.findall(environment_content_file)
env_template = ""
template_axi_slave_decl = ""
template_axis_decl = ""
template_build_phase = ""
template_axi_slave_agt = ""
template_axis_agt = ""
template_connect_phase = ""
template_axi_slave_connect = ""
template_axis_connect = ""
template_env_end = ""

for env, slave_decl, axis_decl, build, slave_agt, axis_agt, connect, slave_connect, axis_connect, end in matches:
	env_template = env
	template_axi_slave_decl = slave_decl
	template_axis_decl = axis_decl
	template_build_phase = build
	template_axi_slave_agt = slave_agt
	template_axis_agt = axis_agt
	template_connect_phase = connect
	template_axi_slave_connect = slave_connect
	template_axis_connect = axis_connect
	template_env_end = end

env_template = env_template.replace("template", structure_name);
template_build_phase = template_build_phase.replace("template", structure_name);

axi_s_decl_ex = ""
axis_decl_ex = ""
axi_s_create_ex = ""
axis_create_ex = ""
axi_s_connect_ex = ""
axis_connect_ex = ""

if (is_axi_s == 1):
	for bundle in slave_bundles:
		axi_s_decl_ex = axi_s_decl_ex + template_axi_slave_decl + "\n\t";
		axi_s_decl_ex = axi_s_decl_ex.replace("template", structure_name);
		axi_s_decl_ex = axi_s_decl_ex.replace("agt", "agent_" + bundle);

		axi_s_create_ex = axi_s_create_ex + template_axi_slave_agt + "\n\t\t";
		axi_s_create_ex = axi_s_create_ex.replace("agt", "agent_" + bundle);
		axi_s_create_ex = axi_s_create_ex.replace("template", structure_name);
		axi_s_create_ex = axi_s_create_ex.replace("agnt", bundle);
		axi_s_create_ex = axi_s_create_ex.replace("a_nm", bundle);

		axi_s_connect_ex = axi_s_connect_ex + template_axi_slave_connect + "\n\t\t";
		axi_s_connect_ex = axi_s_connect_ex.replace("agt_axi_s", "agent_" + bundle + "_axi_s");

	if len(slave_bundles) == 0:
		axi_s_decl_ex = agt_dec_template.replace("template", structure_name);
		axi_s_decl_ex = axi_s_decl_ex.replace("agt_axi_s", "agent_" + structure_name);
		axi_s_decl_ex = axi_s_decl_ex + "\n\t";

		axi_s_create_ex = agt_template_create.replace("template", structure_name);
		axi_s_create_ex = axi_s_create_ex.replace("agt", "agent_" + structure_name);
		axi_s_create_ex = axi_s_create_ex.replace("agnt", structure_name);
		axi_s_create_ex = axi_s_create_ex + "\n\t";

		axi_s_connect_ex = env_template_connect.replace("agt", "agent_" + structure_name);
		axi_s_connect_ex = axi_s_connect_ex + "\n\t";
if (is_axis == 1):
	for operation in operations:
		axis_decl_ex = axis_decl_ex + template_axis_decl + "\n\t";
		axis_decl_ex = axis_decl_ex.replace("template", structure_name);
		axis_decl_ex = axis_decl_ex.replace("agt", "agent_" + operation["module"]);

		axis_create_ex = axis_create_ex + template_axis_agt + "\n\t\t";
		axis_create_ex = axis_create_ex.replace("agt", "agent_" + operation["module"]);
		axis_create_ex = axis_create_ex.replace("template", structure_name);
		axis_create_ex = axis_create_ex.replace("agnt", operation["module"]);
		axis_create_ex = axis_create_ex.replace("a_nm", operation["module"]);
		axis_create_ex = axis_create_ex.replace("dirct", operation["direction"]);

		axis_connect_ex = axis_connect_ex + template_axis_connect + "\n\t\t";
		axis_connect_ex = axis_connect_ex.replace("agt_axis", "agent_" + operation["module"] + "_axis");

final_env = env_template + axi_s_decl_ex + axis_decl_ex + template_build_phase + axi_s_create_ex + axis_create_ex + template_connect_phase + axi_s_connect_ex + axis_connect_ex + "\n" + template_env_end;
# ----------------------------------------------------------------File Editor BASE TEST-----------------------------------------------------------------------------
pattern = re.compile(
	r"""
(class[\s\S]*?(?=virtuals))
\s*
(virtuals[\s\S]*?(?=virtual))
\s*
(virtual[\s\S]*?endtask)
\s*
(virtual[\s\S]*?endtask)
""",
	re.VERBOSE | re.DOTALL
)
matches = pattern.findall(base_test_content_file)
template_test = ""
template_write_seq = ""
template_read_seq = ""
template_write_stream = ""

for test, write, read, write_stream in matches:
	template_test = test;
	template_write_seq = write;
	template_read_seq = read;
	template_write_stream = write_stream;

write_seq_ex = ""
read_seq_ex = ""
write_stream_ex = ""

template_test = template_test.replace("template", structure_name);

if (is_axi_s == 1):
	for bundle in slave_bundles:
		write_seq_ex = write_seq_ex + template_write_seq + "\n\t"
		write_seq_ex = write_seq_ex.replace("template", structure_name);
		write_seq_ex = write_seq_ex.replace("seqt_write", "seq_write_" + bundle);
		write_seq_ex = write_seq_ex.replace("agt", "agent_" + bundle);
		write_seq_ex = write_seq_ex.replace("virtuals", "virtual");
		write_seq_ex = write_seq_ex.replace("writRegister", "writeRegister_" + bundle);
		write_seq_ex = write_seq_ex + "\n"

		read_seq_ex = read_seq_ex + template_read_seq + "\n\t"
		read_seq_ex = read_seq_ex.replace("template", structure_name);
		read_seq_ex = read_seq_ex.replace("seqt_read", "seq_read_" + bundle);
		read_seq_ex = read_seq_ex.replace("agt", "agent_" + bundle);
		read_seq_ex = read_seq_ex.replace("reaRegister", "readRegister_" + bundle);
		read_seq_ex = read_seq_ex + "\n";

	if len(slave_bundles) == 0:
		write_seq_ex = write_seq_ex + write_seq_template + "\n\t"
		write_seq_ex = write_seq_ex.replace("template", structure_name);
		write_seq_ex = write_seq_ex.replace("seqt_write", "seq_write_" + structure_name);
		write_seq_ex = write_seq_ex.replace("agt", "agent_" + structure_name);
		write_seq_ex = write_seq_ex.replace("writRegister", "writeRegister_" + structure_name);
		write_seq_ex = write_seq_ex + "\n\t"

		read_seq_ex = read_seq_ex + read_seq_template + "\n\t"
		read_seq_ex = read_seq_ex.replace("template", structure_name);
		read_seq_ex = read_seq_ex.replace("seqt_read", "seq_read_" + structure_name);
		read_seq_ex = read_seq_ex.replace("agt", "agent_" + structure_name);
		read_seq_ex = read_seq_ex.replace("reaRegister", "readRegister_" + structure_name);
if (is_axis == 1):
	for operation in operations:
		if (operation["direction"] == "0"):
			write_stream_ex = write_stream_ex + template_write_stream + "\n\t"
			write_stream_ex = write_stream_ex.replace("template", structure_name);
			write_stream_ex = write_stream_ex.replace("seqt_wrt", "seq_write_stream_" + operation["module"]);
			write_stream_ex = write_stream_ex.replace("agt", "agent_" + operation["module"]);
			write_stream_ex = write_stream_ex.replace("Writ_data_stream", "Write_data_stream_" + operation["module"]);

base_test_final = template_test + write_seq_ex + read_seq_ex + write_stream_ex + "\nendclass";
# -------------------------------------------------------------------------File Editor TEST-----------------------------------------------------------------------------
pattern = re.compile(
	r"""
(class[\s\S]*?(?=Wrik_data_stream))
\s*
(Wrik_data_stream[\s\S]*?(?=writRegister))
\s*
(writRegister[\s\S]*?(?=`uvm_info))
\s*
(`uvm_info[\s\S]*?endclass)
""",
	re.VERBOSE | re.DOTALL
)
matches = pattern.findall(test_content_file)
template_reg_test = ""
template_readXwrite = ""
template_write_stream = ""
template_end_test = ""

readXwrite_ex = ""
write_stream_ex = ""

for test, ws, rw, end in matches:
	template_reg_test = test;
	template_write_stream = ws;
	template_readXwrite = rw;
	template_end_test = end;

template_reg_test = template_reg_test.replace("template", structure_name);
template_end_test = template_end_test.replace("template", structure_name);
if (is_axi_s == 1):
	for bundle in slave_bundles:
		readXwrite_ex = readXwrite_ex + template_readXwrite + "\n\t";
		readXwrite_ex = readXwrite_ex.replace("writRegister", "writeRegister_" + bundle);
		readXwrite_ex = readXwrite_ex.replace("reaRegister", "readRegister_" + bundle);
		readXwrite_ex = readXwrite_ex + "\t";
	if len(slave_bundles) == 0:
		readXwrite_ex = readXwrite_ex + template_readXwrite + "\n\t";
		readXwrite_ex = readXwrite_ex.replace("writRegister", "writeRegister_" + structure_name);
		readXwrite_ex = readXwrite_ex.replace("reaRegister", "writeRegister_" + structure_name);
if (is_axis == 1):
	for operation in operations:
		if (operation["direction"] == "0"):
			write_stream_ex = write_stream_ex + template_write_stream + "\n\t";
			write_stream_ex = write_stream_ex.replace("Wrik_data_stream", "Write_data_stream_" + operation["module"]);

final_test = template_reg_test + readXwrite_ex + write_stream_ex + template_end_test;
# -----------------------------------------------------------------------File Editor SCOREBOARD-----------------------------------------------------------------------------------------------
if is_axis == 0 and is_axi_s == 1:
    # CAZUL 1: Avem DOAR AXI-Lite. Fisierul (template_axi_lite_scoreboard.sv) este deja complet!
    # Sarim peste regex si doar inlocuim numele proiectului.
    final_scoreboard = scoreboard_content_file.replace(
        "template", structure_name
    )
else:
    # CAZUL 2: Avem AXI-Stream sau Hibrid. Folosim regex-ul tau pentru a taia din template-ul general.
    pattern = re.compile(
        r"""
    (`uvm[\s\S]*?(?=virtuals))
    \s*
    (virtuals[\s\S]*?(?=virtual))
    \s*
    (virtual[\s\S]*?endfunction)
    """,
        re.VERBOSE | re.DOTALL,
    )
    matches = pattern.findall(scoreboard_content_file)
    template_scoreboard = ""
    template_write_axis = ""
    template_write_axi_slave = ""

    for scb, waxi_s, waxis in matches:
        template_scoreboard = scb
        template_write_axis = waxis
        template_write_axi_slave = waxi_s

    scoreboard_ex = template_scoreboard.replace("template", structure_name)
    write_axis_ex = ""
    write_axi_s_ex = ""

    if is_axis == 0:
        scoreboard_ex = scoreboard_ex.replace(
            "`uvm_analysis_imp_decl(_AXIS)", ""
        )
        scoreboard_ex = scoreboard_ex.replace(
            " uvm_analysis_imp_AXIS #("
            + structure_name
            + "_axis_sequence_item, "
            + structure_name
            + "_scoreboard) analysis_axis_export;\n",
            "",
        )
        scoreboard_ex = scoreboard_ex.replace(
            'analysis_axis_export = new("analysis_axis_export", this);', ""
        )
    if is_axi_s == 0:
        scoreboard_ex = scoreboard_ex.replace(
            "`uvm_analysis_imp_decl(_AXI_S)", ""
        )
        scoreboard_ex = scoreboard_ex.replace(
            "uvm_analysis_imp_AXI_S #("
            + structure_name
            + "_axi_lite_sequence_item, "
            + structure_name
            + "_scoreboard) analysis_axi_s_export;\n",
            "",
        )
        scoreboard_ex = scoreboard_ex.replace(
            'analysis_axi_s_export = new("analysis_axi_s_export", this);', ""
        )

    if is_axis == 1:
        write_axis_ex = template_write_axis.replace("template", structure_name)
    if is_axi_s == 1:
        write_axi_s_ex = template_write_axi_slave.replace(
            "template", structure_name
        )

    final_scoreboard = (
        scoreboard_ex + write_axis_ex + "\n" + write_axi_s_ex + "\nendclass"
    )
# ---------------------------------------------------------------Creating the Structure-----------------------------------------------------------------------------------------------------------
os.chdir(path)
os.mkdir(structure_name)
os.chdir(structure_name)
if os.path.isdir(path_tb) | os.path.isdir(path_rtl) | os.path.isdir(path_script):
	warnings.warn("This project already exists")
	exit()
else:
	os.mkdir("src")
	os.chdir("src")
	os.chdir("..")
	os.mkdir("testbench")
	os.chdir("testbench")

	os.mkdir(structure_name + "_agents")
	os.chdir(structure_name + "_agents")
	if (is_axi_s == 1):
		with open(structure_name + "_axi_lite_agent.sv", "x+") as file:
			axi_s_agent_content_file = axi_s_agent_content_file.replace("template", structure_name);
			file.write(axi_s_agent_content_file);
			print("AXI_S Agent done")
		with open(structure_name + "_axi_lite_reset_agent.sv", "x+") as file:
			axi_s_reset_agent_content_file = axi_s_reset_agent_content_file.replace("template", structure_name);
			file.write(axi_s_reset_agent_content_file);
			print("AXI_S Reset Agent done")
		with open(structure_name + "_axi_lite_monitor.sv", "x+") as file:
			axi_s_monitor_content_file = axi_s_monitor_content_file.replace("template", structure_name);
			file.write(axi_s_monitor_content_file);
			print("AXI_S Monitor done")

		if config_json["agent_active"] == 1:
			with open(structure_name + "_axi_lite_sequencer.sv", "x+") as file:
				axi_s_sequencer_content_file = axi_s_sequencer_content_file.replace("template", structure_name);
				file.write(axi_s_sequencer_content_file);
				print("AXI_S Sequencer done")

			with open(structure_name + "_axi_lite_driver.sv", "x+") as file:
				axi_s_driver_content_file = axi_s_driver_content_file.replace("template", structure_name);
				file.write(axi_s_driver_content_file);
				print("AXI_S Driver done")
			with open(structure_name + "_axi_lite_reset_driver.sv", "x+") as file:
				axi_s_reset_driver_content_file = axi_s_reset_driver_content_file.replace("template", structure_name);
				file.write(axi_s_reset_driver_content_file);
				print("AXI_S Reset Driver done")
	# -----------------------------------------------------------------------------------------------------------------------------------
	if (is_axis == 1):
		with open(structure_name + "_axis_agent.sv", "x+") as file:
			axis_agent_content_file = axis_agent_content_file.replace("template", structure_name);
			file.write(axis_agent_content_file);
			print("AXIS Agent done")

		with open(structure_name + "_axis_monitor.sv", "x+") as file:
			axis_monitor_content_file = axis_monitor_content_file.replace("template", structure_name);
			file.write(axis_monitor_content_file);
			print("AXIS Monitor done")

		if config_json["agent_active"] == 1:
			with open(structure_name + "_axis_sequencer.sv", "x+") as file:
				axis_sequencer_content_file = axis_sequencer_content_file.replace("template", structure_name)
				file.write(axis_sequencer_content_file);
				print("AXIS Sequencer done")

			with open(structure_name + "_axis_driver.sv", "x+") as file:
				axis_driver_content_file = axis_driver_content_file.replace("template", structure_name);
				file.write(axis_driver_content_file);
				print("AXIS Driver done")
	os.chdir("..")

	os.mkdir(structure_name + "_seq_lib")
	os.chdir(structure_name + "_seq_lib")

	if (is_axi_s == 1):
		with open(structure_name + "_axi_lite_sequence_item.sv", "x+") as file:
			axi_s_sequence_item_content_file = axi_s_sequence_item_content_file.replace("template", structure_name);
			file.write(axi_s_sequence_item_content_file);
			print("AXI_S Sequence_item done")
		with open(structure_name + "_axi_lite_reset_seq_item.sv", "x+") as file:
			axi_s_reset_seq_item_content_file = axi_s_reset_seq_item_content_file.replace("template", structure_name);
			file.write(axi_s_reset_seq_item_content_file);
			print("AXI_S Reset Sequence_item done")
		with open(structure_name + "_axi_lite_basic_sequence.sv", "x+") as file:
			axi_s_basic_sequence_content_file = axi_s_basic_sequence_content_file.replace("template", structure_name);
			file.write(axi_s_basic_sequence_content_file);
			print("AXI_S Sequence done")
		with open(structure_name + "_axi_lite_reset_sequence.sv", "x+") as file:
			axi_s_reset_sequence_content_file = axi_s_reset_sequence_content_file.replace("template", structure_name);
			file.write(axi_s_reset_sequence_content_file);
			print("AXI_S Reset Sequence done")
	if (is_axis == 1):
		with open(structure_name + "_axis_sequence_item.sv", "x+") as file:
			axis_sequence_item_content_file = axis_sequence_item_content_file.replace("template", structure_name);
			file.write(axis_sequence_item_content_file);
			print("AXIS Sequence_item done")

		with open(structure_name + "_axis_basic_sequence.sv", "x+") as file:
			axis_basic_sequence_content_file = axis_basic_sequence_content_file.replace("template", structure_name);
			file.write(axis_basic_sequence_content_file);
			print("AXIS Sequence done")

	os.chdir("..")

	os.mkdir(structure_name + "_env")
	os.chdir(structure_name + "_env")

	with open(structure_name + "_scoreboard.sv", "x+") as file:

		scoreboard_content_file = final_scoreboard.replace("virtuals", "virtual");
		file.write(scoreboard_content_file);
		print("Scoreboard done")

	with open(structure_name + "_env.sv", "x+") as file:
		file.write(final_env);
		print("Environment done")

	os.chdir("..")

	os.mkdir(structure_name + "_top")
	os.chdir(structure_name + "_top")

	if (is_axi_s == 1):
		with open(structure_name + "_axi_lite_intf.sv", "x+") as file:
			axi_s_intf_content_file = axi_s_intf_content_file.replace("template", config_json["function name"]);
			file.write(axi_s_intf_content_file);
			print("AXI_S Interface done")

	if (is_axis == 1):
		with open(structure_name + "_axis_interface.sv", "x+") as file:
			axis_intf_content_file = axis_intf_content_file.replace("template", config_json["function name"]);
			file.write(axis_intf_content_file);
			print("AXIS Interface done")

	with open(structure_name + "_base_test.sv", "x+") as file:
		file.write(base_test_final);
		print("Base test done");

	if is_axis == 1 or is_axi_s == 1:
		with open(structure_name + "_test.sv", "x+") as file:
			file.write(final_test)
		print("Test done")

	with open(structure_name + "_top.sv", "x+") as file:
		if(is_axis == 1 or is_axi_s ==1):
			file.write(final_top)
		elif(is_axis == 0 and is_axi_s == 0):
			no_func_top_content_file = no_func_top_content_file.replace("template",structure_name);
			file.write(no_func_top_content_file)
		print("Top done")

	if (is_axis == 1 and is_axi_s == 1):
		with open(structure_name + "_pkg.sv", "x+") as file:
			combined_pkg_content_file = combined_pkg_content_file.replace("template", structure_name);
			file.write(combined_pkg_content_file)
			print("COMMON package done");
	elif (is_axis == 1 and is_axi_s == 0):
		with open(structure_name + "_axis_pkg.sv", "x+") as file:
			axis_pkg_content_file = axis_pkg_content_file.replace("template", structure_name);
			file.write(axis_pkg_content_file)
			print("AXIS package done");

	elif (is_axis == 0 and is_axi_s == 1):
		with open(structure_name + "_axi_s_pkg.sv", "x+") as file:
			axi_s_pkg_content_file = axi_s_pkg_content_file.replace("template", structure_name);
			file.write(axi_s_pkg_content_file);
			print("AXI_S package done");
	elif (is_axis == 0 and is_axi_s == 0):
		with open(structure_name + "_pkg.sv" , "x+")as file:
			no_func_pkg_content_file = no_func_pkg_content_file.replace("template",structure_name);
			file.write(no_func_pkg_content_file);
			print("NO FUNCTION package done")
print("Structura creata cu succes!")
# ------------------------------------Create Script Files------------------------------------------------------------------------------------
os.chdir(path_final)
os.mkdir(".vscode")
os.chdir(".vscode")
os.mkdir("scripts")
os.chdir("scripts")
with open("check_sim.tcl", "x+") as file:
	file.write(check_sim_content_file)
	print("Check Sim done!")

with open("run_all.bat", "x+") as file:
	file.write(run_all_content_file)
	print("Run all done!")

with open("run_sim_gui.tcl", "x+") as file:
	file.write(run_gui_content_file)
	print("Run gui done!")
with open("create_project.tcl", "x+") as file:
	if (is_axis == 1 or is_axi_s == 1):
		create_project_content_file = create_project_content_file.replace("dut", "src");
		create_project_content_file = create_project_content_file.replace("tempt_src", rtl_name);
		create_project_content_file = create_project_content_file.replace("topt", structure_name + "_top");
		create_project_content_file = create_project_content_file.replace("topx", rtl_name);

		create_project_content_file = create_project_content_file.replace("template", structure_name);
		if (is_axis == 1 and is_axi_s == 0):
			create_project_content_file = create_project_content_file.replace("$proj_dir/testbench/" + structure_name + "_top/" + structure_name + "_axi_lite_intf.sv \\\n  ", "")
			create_project_content_file = create_project_content_file.replace("pkg", "axis_pkg")
		if (is_axis == 0 and is_axi_s == 1):
			create_project_content_file = create_project_content_file.replace("$proj_dir/testbench/" + structure_name + "_top/" + structure_name + "_axis_interface.sv \\\n  ", "")
			create_project_content_file = create_project_content_file.replace("pkg", "axi_s_pkg")
		file.write(create_project_content_file)
	if (is_axis == 0 and is_axi_s == 0):
		create_project_content_file = create_project_content_file.replace("$proj_dir/testbench/topt/template_axi_lite_intf.sv \\" +"\n ", "")
		create_project_content_file = create_project_content_file.replace("$proj_dir/testbench/topt/template_axis_interface.sv \\" + "\n ", "")
		create_project_content_file = create_project_content_file.replace("topt", structure_name + "_top");
		create_project_content_file = create_project_content_file.replace("template", structure_name);
		create_project_content_file = create_project_content_file.replace("dut", "src");
		create_project_content_file = create_project_content_file.replace("topx", rtl_name);
		file.write(create_project_content_file)
	print("Create project done!")
	os.chdir("..")
with open("tasks.json", "x+") as file:
	file.write(tasks_content_file)
	clear("Task file done!")
