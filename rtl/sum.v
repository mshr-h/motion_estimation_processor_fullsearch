`default_nettype none
module sum (
  input  wire          rst_n,
  input  wire          clk,
  input  wire [2047:0] ad, // 8*16*16
  output reg  [15:0]   sum
);

genvar i,j,k,m;

reg [7:0] preg1 [0:255];
generate
for (i = 0; i < 256; i = i + 1) begin : PIPELINE1
  always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
      preg1[i] <= 0;
    else
      preg1[i] <= ad[(i+1)*8-1:i*8];
  end
end
endgenerate

reg [9:0] preg2 [0:63];
generate
for (j = 0; j < 64; j = j + 1) begin : PIPELINE2
  always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
      preg2[j] <= 0;
    else
      preg2[j] <= (preg1[j*4]+preg1[j*4+1])+(preg1[j*4+2]+preg1[j*4+3]);
  end
end
endgenerate

reg [11:0] preg3 [0:15];
generate
for (k = 0; k < 16; k = k + 1) begin : PIPELINE3
  always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
      preg3[k] <= 0;
    else
      preg3[k] <= (preg2[k*4]+preg2[k*4+1])+(preg2[k*4+2]+preg2[k*4+3]);
  end
end
endgenerate

reg [13:0] preg4 [0:3];
generate
for (m = 0; m < 4; m = m + 1) begin : PIPELINE4
  always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
      preg4[m] <= 0;
    else
      preg4[m] <= (preg3[m*4]+preg3[m*4+1])+(preg3[m*4+2]+preg3[m*4+3]);
  end
end
endgenerate

always @(posedge clk or negedge rst_n) begin
  if(~rst_n)
    sum <= 0;
  else
    sum <= (preg4[0]+preg4[1])+(preg4[2]+preg4[3]);
end

endmodule
`default_nettype wire
