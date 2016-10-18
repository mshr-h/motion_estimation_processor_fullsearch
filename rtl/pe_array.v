`default_nettype none
module pe_array
#(
  parameter TB_LENGTH = 16,
  parameter SW_LENGTH = 48,
  parameter SAD_WIDTH = 16
) (
  input  wire                 rst_n,
  input  wire                 clk,
  input  wire                 en_sw,
  input  wire                 en_tb,
  input  wire [7:0]           pel_sw,
  input  wire [7:0]           pel_tb,
  output wire [SAD_WIDTH-1:0] sad
);

wire [8*TB_LENGTH-1:0] w_ad [0:TB_LENGTH-1]; // 8*16*16
wire [8*(TB_LENGTH**2)-1:0] packed_ad; // 8*16*16
wire [7:0] tmp_sw [0:TB_LENGTH-1];
wire [7:0] tmp_tb [0:TB_LENGTH];
wire [7:0] tmp_sr [0:TB_LENGTH];

assign tmp_sr[0] = pel_sw;
assign tmp_tb[0] = pel_tb;

genvar i;
generate
for(i=0; i<TB_LENGTH; i=i+1) begin :PE_ARRAY
  shift_register
  #(.DEPTH  ( SW_LENGTH-TB_LENGTH ),
    .DWIDTH ( 8  ) )
  _sr
  (
    .rst_n ( rst_n     ),
    .clk   ( clk       ),
    .en    ( en_sw     ),
    .d     ( tmp_sr[i] ),
    .q     ( tmp_sw[i] )
  );
  pe_line _pe_line
  (
    .rst_n  ( rst_n       ),
    .clk    ( clk         ),
    .en_sw  ( en_sw       ),
    .en_tb  ( en_tb       ),
    .pel_sw ( tmp_sw[i]   ),
    .pel_tb ( tmp_tb[i]   ),
    .nxt_sw ( tmp_sr[i+1] ),
    .nxt_tb ( tmp_tb[i+1] ),
    .ad     ( w_ad[i]     )
  );
end
endgenerate

// pack w_ad
generate
for (i = 0; i < TB_LENGTH; i = i + 1) begin :PACK
  assign packed_ad[(i+1)*8*TB_LENGTH-1:i*8*TB_LENGTH] = w_ad[i];
end
endgenerate

sum
_sum
(
  .rst_n ( rst_n     ),
  .clk   ( clk       ),
  .ad    ( packed_ad ),
  .sum   ( sad       )
);

endmodule
`default_nettype wire

