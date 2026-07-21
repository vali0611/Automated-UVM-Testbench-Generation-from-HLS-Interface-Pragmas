source create_project.tcl


set rc [catch {
    launch_simulation -simset sim_1
} result]

if {$rc} {
    puts stderr "=========== SIM FAILED ==========="
    puts stderr $result
    exit 1
} else {
    puts "=========== SIM OK ==========="
    exit 0
}