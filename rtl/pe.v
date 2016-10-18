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
      nxt_sw <= pel_sw;
    if(en_tb)
      nxt_tb <= pel_tb;
  end
end

assign ad = (nxt_sw > nxt_tb) ? nxt_sw - nxt_tb
                              : nxt_tb - nxt_sw;

endmodule
`default_nettype wire
