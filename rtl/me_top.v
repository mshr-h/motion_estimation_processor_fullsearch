module me_top
#(
  parameter TB_LENGTH         = 16, // Size of Template Block
  parameter SW_LENGTH         = 64, // Size of Search Window
  parameter PE_OUT_WIDTH      = 8,  // Bit width of Processor Element's output
  parameter MEMORY_SW_CONTENT = "./memory_sw.txt",
  parameter MEMORY_TB_CONTENT = "./memory_tb.txt"
) (
  input  wire                 rst_n,
  input  wire                 clk,
  input  wire                 req,
  output wire [CNT_WIDTH-1:0] min_cnt,
  output wire [SAD_WIDTH-1:0] min_sad,
  output wire                 ack
);

localparam ADDR_SW   = $clog2(SW_LENGTH**2);
localparam ADDR_TB   = $clog2(TB_LENGTH**2);
localparam CNT_WIDTH = $clog2((SW_LENGTH-TB_LENGTH+1)**2);
localparam SAD_WIDTH = $clog2(TB_LENGTH**2) + PE_OUT_WIDTH;

wire                 clr;
wire [ADDR_SW-1:0]   addr_sw;
wire [ADDR_TB-1:0]   addr_tb;
wire                 en_addr_sw;
wire                 en_addr_tb;
wire                 en_pearray_sw;
wire                 en_pearray_tb;
wire [7:0]           pel_sw;
wire [7:0]           pel_tb;
wire [SAD_WIDTH-1:0] sad;

control_unit
#(.SAD_WIDTH ( SAD_WIDTH ),
  .CNT_WIDTH ( CNT_WIDTH ),
  .TB_LENGTH ( TB_LENGTH ),
  .SW_LENGTH ( SW_LENGTH ) )
_control_unit
(
  .rst_n         ( rst_n         ),
  .clk           ( clk           ),
  .req           ( req           ),
  .sad           ( sad           ),
  .clr           ( clr           ),
  .en_addr_sw    ( en_addr_sw    ),
  .en_addr_tb    ( en_addr_tb    ),
  .en_pearray_sw ( en_pearray_sw ),
  .en_pearray_tb ( en_pearray_tb ),
  .min_cnt       ( min_cnt       ),
  .min_sad       ( min_sad       ),
  .ack           ( ack           )
);

addr_gen
#(.ADDR_SW ( ADDR_SW ),
  .ADDR_TB ( ADDR_TB ) )
_addr_gen
(
  .rst_n   ( rst_n      ),
  .clk     ( clk        ),
  .clr     ( clr        ),
  .en_sw   ( en_addr_sw ),
  .en_tb   ( en_addr_tb ),
  .addr_sw ( addr_sw    ),
  .addr_tb ( addr_tb    )
);

memory_single_port
#(.DWIDTH  ( 8                 ),
  .AWIDTH  ( ADDR_SW           ),
  .CONTENT ( MEMORY_SW_CONTENT ) )
_memory_sw
(
  .clock   ( clk     ),
  .wren    ( 1'b0    ),
  .address ( addr_sw ),
  .data    ( 8'd0    ),
  .q       ( pel_sw  )
);

memory_single_port
#(.DWIDTH  ( 8                 ),
  .AWIDTH  ( ADDR_TB           ),
  .CONTENT ( MEMORY_TB_CONTENT ) )
_memory_tb
(
  .clock   ( clk     ),
  .wren    ( 1'b0    ),
  .address ( addr_tb ),
  .data    ( 8'd0    ),
  .q       ( pel_tb  )
);

pe_array
#(
  .TB_LENGTH ( TB_LENGTH ),
  .SW_LENGTH ( SW_LENGTH ),
  .SAD_WIDTH ( SAD_WIDTH ) )
_pe_array
(
  .rst_n  ( rst_n         ),
  .clk    ( clk           ),
  .en_sw  ( en_pearray_sw ),
  .en_tb  ( en_pearray_tb ),
  .pel_sw ( pel_sw        ),
  .pel_tb ( pel_tb        ),
  .sad    ( sad           )
);

endmodule
