module fpga_top
(
  input  wire       CLOCK_50,
  input  wire       CLOCK2_50,
  input  wire       CLOCK3_50,
  input  wire       CLOCK4_50,
  output wire [6:0] HEX0,
  output wire [6:0] HEX1,
  output wire [6:0] HEX2,
  output wire [6:0] HEX3,
  output wire [6:0] HEX4,
  output wire [6:0] HEX5,
  input  wire [3:0] KEY,
  output wire [9:0] LEDR
);

parameter TB_LENGTH    = 16;
parameter SW_LENGTH    = 64;
parameter PE_OUT_WIDTH = 8;
parameter MEMORY_SW    = "../memory_sw.mif";
parameter MEMORY_TB    = "../memory_tb.mif";

localparam ADDR_SW   = $clog2(SW_LENGTH**2);
localparam ADDR_TB   = $clog2(TB_LENGTH**2);
localparam CNT_WIDTH = $clog2((SW_LENGTH-TB_LENGTH+1)**2);
localparam SAD_WIDTH = $clog2(TB_LENGTH**2) + PE_OUT_WIDTH;

reg                  req;
wire [SAD_WIDTH-1:0] min_sad;
wire [CNT_WIDTH-1:0] min_mvec;
wire                 ack;

wire [7:0]           pel_sw;
wire [7:0]           pel_tb;
wire [ADDR_SW-1:0]   addr_sw;
wire [ADDR_TB-1:0]   addr_tb;

wire clk = CLOCK_50;
wire RSTN = KEY[2];

// detect falling edge
reg [1:0] ff_sw4 = 0;
reg [1:0] ff_sw5 = 0;
always @(posedge clk) begin
  ff_sw4 <= {ff_sw4[0], KEY[0]};
  ff_sw5 <= {ff_sw5[0], KEY[1]};
end
wire tri_sw4 = (ff_sw4 == 2'b10);
wire tri_sw5 = (ff_sw5 == 2'b10);

always @(posedge clk or negedge RSTN) begin
  if(~RSTN)
    req <= 0;
  else if(tri_sw4)
    req <= 1;
  else if(tri_sw5)
    req <= 0;
end

me_top
#(
  .TB_LENGTH    ( TB_LENGTH    ),
  .SW_LENGTH    ( SW_LENGTH    ),
  .PE_OUT_WIDTH ( PE_OUT_WIDTH )
) _me_top
(
  .rst_n    ( RSTN     ),
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

assign LEDR[0] = req;
assign LEDR[1] = ack;
assign LEDR[2] = |min_sad;
assign LEDR[3] = |min_mvec;
assign LEDR[4] = |pel_tb;
assign LEDR[5] = |pel_sw;

endmodule
