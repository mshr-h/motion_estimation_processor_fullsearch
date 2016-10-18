`default_nettype none
module pe_line
#(
  parameter ARRAY_SIZE = 16
) (
  input  wire                    rst_n,
  input  wire                    clk,
  input  wire                    en_sw,
  input  wire                    en_tb,
  input  wire [7:0]              pel_sw,
  input  wire [7:0]              pel_tb,
  output wire [7:0]              nxt_sw,
  output wire [7:0]              nxt_tb,
  output wire [ARRAY_SIZE*8-1:0] ad
);

wire [7:0] tmp_sw [0:ARRAY_SIZE];
wire [7:0] tmp_tb [0:ARRAY_SIZE];
wire [7:0] w_ad [0:ARRAY_SIZE-1];

assign tmp_sw[0] = pel_sw;
assign tmp_tb[0] = pel_tb;
assign nxt_sw    = tmp_sw[ARRAY_SIZE];
assign nxt_tb    = tmp_tb[ARRAY_SIZE];

genvar i;
generate
for(i=0; i<ARRAY_SIZE; i=i+1) begin :PE_LINE
  pe _pe
  (
    .rst_n  ( rst_n       ),
    .clk    ( clk         ),
    .en_sw  ( en_sw       ),
    .en_tb  ( en_tb       ),
    .pel_sw ( tmp_sw[i]   ),
    .pel_tb ( tmp_tb[i]   ),
    .nxt_sw ( tmp_sw[i+1] ),
    .nxt_tb ( tmp_tb[i+1] ),
    .ad     ( w_ad[i]     )
  );
end
endgenerate

// pack AD
generate
for (i=0; i<ARRAY_SIZE; i=i+1) begin: PACK
  assign ad[8*(i+1)-1:8*i] = w_ad[i];
end
endgenerate

endmodule
`default_nettype wire
