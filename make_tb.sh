cd testbench
iverilog -Wall -o tb_me_top.out tb_me_top.v
vvp tb_me_top.out
cd ..
