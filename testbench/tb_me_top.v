`include "../rtl/addr_gen.v"
`include "../rtl/control_unit.v"
`include "./memory_single_port.v"
`include "../rtl/pe.v"
`include "../rtl/shift_register.v"
`include "../rtl/sum.v"
`include "../rtl/pe_line.v"
`include "../rtl/pe_array.v"
`include "../rtl/me_top.v"
`default_nettype none

module tb_me_top;

parameter TB_LENGTH    = 16;
parameter SW_LENGTH    = 64;
parameter PE_OUT_WIDTH = 8;
parameter MEMORY_SW    = "../memory/memory_sw.txt";
parameter MEMORY_TB    = "../memory/memory_tb.txt";

localparam CNT_WIDTH = $clog2((SW_LENGTH-TB_LENGTH+1)**2);
localparam SAD_WIDTH = $clog2(TB_LENGTH**2) + PE_OUT_WIDTH;

reg                  rst_n;
reg                  clk;
reg                  req;
wire [CNT_WIDTH-1:0] min_cnt;
wire [SAD_WIDTH-1:0] min_sad;
wire                 ack;

me_top
#(
  .TB_LENGTH         ( TB_LENGTH    ),
  .SW_LENGTH         ( SW_LENGTH    ),
  .PE_OUT_WIDTH      ( PE_OUT_WIDTH ),
  .MEMORY_SW_CONTENT ( MEMORY_SW    ),
  .MEMORY_TB_CONTENT ( MEMORY_TB    )
)
_me_top
(
  .rst_n   ( rst_n   ),
  .clk     ( clk     ),
  .req     ( req     ),
  .min_cnt ( min_cnt ),
  .min_sad ( min_sad ),
  .ack     ( ack     )
);

parameter CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk = ~clk;

initial begin
  $dumpfile("tb_me_top.vcd");
  $dumpvars(0, tb_me_top);
end

initial begin
  #1 rst_n<=1'bx;clk<=1'bx;req<=1'bx;
  #(CLK_PERIOD) rst_n<=1;
  #(CLK_PERIOD*3) rst_n<=0;clk<=0;req<=0;
  repeat(5) @(posedge clk);
  rst_n<=1;
  repeat(3) @(posedge clk);
  req<=1;
  while(~ack) @(posedge clk);
  repeat(10) @(posedge clk);
  req<=0;
  repeat(10) @(posedge clk);
  $finish(2);
end

endmodule
`default_nettype wire
