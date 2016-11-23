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

localparam ADDR_SW   = $clog2(SW_LENGTH**2);
localparam ADDR_TB   = $clog2(TB_LENGTH**2);
localparam CNT_WIDTH = $clog2((SW_LENGTH-TB_LENGTH+1)**2);
localparam SAD_WIDTH = $clog2(TB_LENGTH**2) + PE_OUT_WIDTH;

reg                  rst_n;
reg                  clk;
reg                  req;
wire [SAD_WIDTH-1:0] min_sad;
wire [CNT_WIDTH-1:0] min_mvec;
wire                 ack;

wire [7:0]           pel_sw;
wire [7:0]           pel_tb;
wire [ADDR_SW-1:0]   addr_sw;
wire [ADDR_TB-1:0]   addr_tb;

me_top
#(
  .TB_LENGTH         ( TB_LENGTH    ),
  .SW_LENGTH         ( SW_LENGTH    ),
  .PE_OUT_WIDTH      ( PE_OUT_WIDTH ) )
_me_top
(
  .rst_n    ( rst_n    ),
  .clk      ( clk      ),
  .req      ( req      ),
  .min_sad  ( min_sad  ),
  .min_mvec ( min_mvec ),
  .ack      ( ack      ),

  // memory access ports
  .pel_sw   ( pel_sw   ),
  .pel_tb   ( pel_tb   ),
  .addr_sw  ( addr_sw  ),
  .addr_tb  ( addr_tb  )
);

memory_single_port
#(.DWIDTH  ( 8         ),
  .AWIDTH  ( ADDR_SW   ),
  .CONTENT ( MEMORY_SW ) )
_memory_sw
(
  .clock   ( clk     ),
  .wren    ( 1'b0    ),
  .address ( addr_sw ),
  .data    ( 8'd0    ),
  .q       ( pel_sw  )
);

memory_single_port
#(.DWIDTH  ( 8         ),
  .AWIDTH  ( ADDR_TB   ),
  .CONTENT ( MEMORY_TB ) )
_memory_tb
(
  .clock   ( clk     ),
  .wren    ( 1'b0    ),
  .address ( addr_tb ),
  .data    ( 8'd0    ),
  .q       ( pel_tb  )
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
