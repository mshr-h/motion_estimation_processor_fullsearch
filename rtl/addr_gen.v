`default_nettype none

module addr_gen
#(
  parameter ADDR_SW = 12,
  parameter ADDR_TB = 8
) (
  input  wire               rst_n,
  input  wire               clk,
  input  wire               clr,
  input  wire               en_sw,
  input  wire               en_tb,
  output reg  [ADDR_SW-1:0] addr_sw,
  output reg  [ADDR_TB-1:0] addr_tb
);

wire [ADDR_SW-1:0] nxt_sw = (clr) ? 0
                                  : (en_sw) ? addr_sw+1
                                            : addr_sw;
wire [ADDR_TB-1:0] nxt_tb = (clr) ? 0
                                  : (en_tb) ? addr_tb+1
                                            : addr_tb;

always @(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    addr_sw <= 0;
    addr_tb <= 0;
  end else begin
    addr_sw <= nxt_sw;
    addr_tb <= nxt_tb;
  end
end

endmodule
`default_nettype wire
