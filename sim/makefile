.ONESHELL:

run_test1: clean
	irun -sv -uvm -access +rwc +nccoverage+all -covoverwrite -covworkdir ./router_cov -covscope router_scope -svseed random ../rtl/* ../test/pkg.sv ../tb/top.sv +incdir+../tb +incdir+../apb_slave_top +incdir+../ahb_master_top +incdir+../test -timescale 1ns/1ns +UVM_TESTNAME=router_test

run_test2:
	irun -sv -uvm -access +rwc ../rtl/* ../test/pkg.sv ../tb/top.sv +incdir+../tb +incdir+../apb_slave_top +incdir+../ahb_master_top  +incdir+../test -timescale 1ns/1ns +UVM_TESTNAME=test_1
run_test3:
	irun -sv -uvm -access +rwc ../rtl/* ../test/pkg.sv ../tb/top.sv +incdir+../tb +incdir+../apb_slave_top +incdir+../ahb_master_top  +incdir+../test -timescale 1ns/1ns +UVM_TESTNAME=test_2

run_test4:
	irun -sv -uvm -access +rwc ../rtl/* ../test/pkg.sv ../tb/top.sv +incdir+../tb +incdir+../apb_slave_top +incdir+../ahb_master_top  +incdir+../test -timescale 1ns/1ns +UVM_TESTNAME=test_3
run_test5:
		irun -sv -uvm -access +rwc ../rtl/* ../test/pkg.sv ../tb/top.sv +incdir+../tb +incdir+../apb_slave_top +incdir+../ahb_master_top  +incdir+../test -timescale 1ns/1ns +UVM_TESTNAME=test_4

#run_test6:
#	irun -sv -uvm -access +rwc ../rtl/* ../test/router_pkg.sv ../tb/top.sv +incdir+../tb +incdir+../rd_agt_top +incdir+../wr_agt_top  +incdir+../test -timescale 1ns/1ns +UVM_TESTNAME=router_small_pkt_test

#run_test7:
#	irun -sv -uvm -access +rwc ../rtl/* ../test/ahb_pkg.sv ../tb/top.sv +incdir+../tb +incdir+../agent +incdir+../test -timescale 1ns/1ns +UVM_TESTNAME=WRAP16_test
#run_test8:
#	irun -sv -uvm -access +rwc ../rtl/* ../test/ahb_pkg.sv ../tb/top.sv +incdir+../tb +incdir+../agent +incdir+../test -timescale 1ns/1ns +UVM_TESTNAME=INCR16_test

#run_test9:
	#irun -sv -uvm -access +rwc ../rtl/* ../test/ahb_pkg.sv ../tb/top.sv +incdir+../tb +incdir+../agent +incdir+../test -timescale 1ns/1ns +UVM_TESTNAME=cov_test

#regress: run_test1 run_test2 run_test3 run_test4 
assert:
	irun +access+rwc top.sv

covreport:
		irun -sv -uvm -access +rwc +nccoverage+all -covoverwrite -covworkdir ./router_cov -covscope router_scope -svseed random ../rtl/* ../test/router_pkg.sv ../tb/top.sv +incdir+../tb +incdir+../rd_agt_top +incdir+../wr_agt_top +incdir+../test -timescale 1ns/1ns +uvm_testname=regress

regress:
	@echo "reading_files"
	@while read -r file; do \
	@echo "$$file"; \
	irun -sv -uvm -access +rwc +nccoverage+all -covfile ./cov.ccf -covoverwrite -covworkdir ./router_cov -covscope router_scope -svseed random ../rtl/* ../test/router_pkg.sv ../tb/top.sv +incdir+../tb +incdir+../rd_agt_top +incdir+../wr_agt_top  +incdir+../test -timescale 1ns/1ns +UVM_NO_RELNOTES +UVM_TESTNAME="$$file" -l ./router_log/"$$file".log -covtest "$$file"
	done <testlist.f


clean:
	rm -rf INCA_libs irun.* router.* irun.* router_cov dump.*
