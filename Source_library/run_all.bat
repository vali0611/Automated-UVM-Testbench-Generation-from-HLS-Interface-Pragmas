@echo off
cd /d "%~dp0"
echo ==== STEP 1: compile/elab check in terminal ====
call vivado -mode batch -source check_sim.tcl

echo ==== STEP 2: opening Vivado GUI ====
call vivado -mode gui -source run_sim_gui.tcl

exit /b 0