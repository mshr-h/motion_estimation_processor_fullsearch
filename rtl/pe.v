`default_nettype none
module pe
(
  input  wire       rst_n,
  input  wire       clk,
  input  wire       en_sw,
  input  wire       en_tb,
  input  wire [7:0] pel_sw,
  input  wire [7:0] pel_tb,
  output reg  [7:0] nxt_sw,
  output reg  [7:0] nxt_tb,
  output wire [7:0] ad
);

always @(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    nxt_sw <= 0;
    nxt_tb <= 0;
  end else begin
    if(en_sw)
      nxt_sw <= #1 pel_sw;
    if(en_tb)
      nxt_tb <= #1 pel_tb;
  end
end

// 8-bit AD
// assign ad = (nxt_sw > nxt_tb) ? nxt_sw - nxt_tb
                              // : nxt_tb - nxt_sw;

// 4-bit AD
// assign ad[3:0] = (nxt_sw[7:4] > nxt_tb[7:4]) ? nxt_sw[7:4] - nxt_tb[7:4]
                                             // : nxt_tb[7:4] - nxt_sw[7:4];

// 2-bit AD, 6-bit XOR
// assign ad[7:6] = (nxt_sw[7:6] > nxt_tb[7:6]) ? nxt_sw[7:6] - nxt_tb[7:6]
                                             // : nxt_tb[7:6] - nxt_sw[7:6];
// assign ad[5:0] = nxt_sw[5:0] ^ nxt_tb[5:0];

endmodule
`default_nettype wire
