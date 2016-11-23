module fpga_top
(
  input  wire       RSTN,
  input  wire       clk_sys,
  input  wire       clk,
  input  wire       SW4N,
  input  wire       SW5N,
  output wire [7:0] SEG_A,
  output wire [7:0] SEG_B,
  output wire [7:0] SEG_C,
  output wire [7:0] SEG_D,
  output wire [7:0] SEG_E,
  output wire [7:0] SEG_F,
  output wire [7:0] SEG_G,
  output wire [7:0] SEG_H,
  output wire [8:0] SEG_SEL_IK
);

parameter TB_LENGTH    = 16;
parameter SW_LENGTH    = 64;
parameter PE_OUT_WIDTH = 8;
parameter MEMORY_SW    = "./memory_sw.mif";
parameter MEMORY_TB    = "./memory_tb.mif";

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

// detect falling edge
reg [1:0] ff_sw4 = 0;
reg [1:0] ff_sw5 = 0;
always @(posedge clk) begin
  ff_sw4 <= {ff_sw4[0], SW4N};
  ff_sw5 <= {ff_sw5[0], SW5N};
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
  .TB_LENGTH         ( TB_LENGTH    ),
  .SW_LENGTH         ( SW_LENGTH    ),
  .PE_OUT_WIDTH      ( PE_OUT_WIDTH )
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

/* 7SEG LED
+--------+--------+--------+--------+
| data0  | data1  | data2  | data3  |
+--------+--------+--------+--------+
| data4  | data5  | data6  | data7  |
+--------+--------+--------+--------+
| data8  | data9  | data10 | data11 |
+--------+--------+--------+--------+
| data12 | data13 | data14 | data15 |
+--------+--------+--------+--------+
*/

displayIK_7seg_16
_displayIK_7seg_16
(
  .RSTN    ( RSTN       ),
  .CLK     ( clk_sys    ),
  .data0   ( {3'h0,  clk, 3'h0, RSTN, 8'h00} ),
  .data1   ( {3'h0, SW4N, 3'h0, SW5N, 3'h0, req, 3'h0, ack} ),
  .data2   ( 0          ),
  .data3   ( 0          ),
  .data4   ( min_sad    ),
  .data5   ( min_mvec   ),
  .data6   ( 0          ),
  .data7   ( 0          ),
  .data8   ( pel_sw     ),
  .data9   ( pel_tb     ),
  .data10  ( 0          ),
  .data11  ( 0          ),
  .data12  ( 0          ),
  .data13  ( 0          ),
  .data14  ( 0          ),
  .data15  ( 0          ),
  .SEG_A   ( SEG_A      ),
  .SEG_B   ( SEG_B      ),
  .SEG_C   ( SEG_C      ),
  .SEG_D   ( SEG_D      ),
  .SEG_E   ( SEG_E      ),
  .SEG_F   ( SEG_F      ),
  .SEG_G   ( SEG_G      ),
  .SEG_H   ( SEG_H      ),
  .SEG_SEL ( SEG_SEL_IK )
);

endmodule
