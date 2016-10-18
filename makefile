.ONESHELL:
all:
	cd testbench
	iverilog -Wall -o tb_me_top.out tb_me_top.v
	vvp tb_me_top.out

mif:
	python tools/convert2mif.py memory/memory_sw.txt fpga/memory_sw.mif
	python tools/convert2mif.py memory/memory_tb.txt fpga/memory_tb.mif

distclean: clean
	rm -f fpga/*.mif
	rm -f memory/*.txt

clean:
	rm -f testbench/*.out
	rm -f testbench/*.vcd
	rm -rf fpga/db
	rm -rf fpga/greybox_tmp
	rm -rf fpga/incremental_db
	rm -rf fpga/output_files
	rm -rf fpga/simulation
	rm -f fpga/*.qws
