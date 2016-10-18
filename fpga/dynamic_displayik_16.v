module dynamic_displayIK_16
(
  input  wire        CLK,
  input  wire        RST,
  input  wire [31:0] SEG_0,
  input  wire [31:0] SEG_1,
  input  wire [31:0] SEG_2,
  input  wire [31:0] SEG_3,
  input  wire [31:0] SEG_4,
  input  wire [31:0] SEG_5,
  input  wire [31:0] SEG_6,
  input  wire [31:0] SEG_7,
  input  wire [31:0] SEG_8,
  input  wire [31:0] SEG_9,
  input  wire [31:0] SEG_10,
  input  wire [31:0] SEG_11,
  input  wire [31:0] SEG_12,
  input  wire [31:0] SEG_13,
  input  wire [31:0] SEG_14,
  input  wire [31:0] SEG_15,
  output reg  [7:0]  SEG_A,
  output reg  [7:0]  SEG_B,
  output reg  [7:0]  SEG_C,
  output reg  [7:0]  SEG_D,
  output reg  [7:0]  SEG_E,
  output reg  [7:0]  SEG_F,
  output reg  [7:0]  SEG_G,
  output reg  [7:0]  SEG_H,
  output reg  [8:0]  SEG_SEL
);

reg [2:0]  COUNTER;
reg [15:0] DEF_COUNTER;
parameter DEF_MAX = 16'h7FFF;
parameter COUNT_MAX = 3'b111;

always @(posedge CLK or negedge RST) begin
  if(!RST) begin
    SEG_A <= 8'hFC;
    SEG_B <= 8'hFC;
    SEG_C <= 8'hFC;
    SEG_D <= 8'hFC;
    SEG_E <= 8'hFC;
    SEG_F <= 8'hFC;
    SEG_G <= 8'hFC;
    SEG_H <= 8'hFC;
    SEG_SEL <=9'h1FF;
    COUNTER <= 3'h0;
    DEF_COUNTER <= 16'h0000;
  end else begin
    if(DEF_COUNTER != DEF_MAX) begin
      DEF_COUNTER <= DEF_COUNTER + 16'd1;
      SEG_SEL <=9'h000;
    end
    else begin
      DEF_COUNTER <= 16'h0000;
      case(COUNTER)
        3'd0: begin
          SEG_A <= SEG_0[31:24];
          SEG_B <= SEG_0[23:16];
          SEG_C <= SEG_0[15:8];
          SEG_D <= SEG_0[7:0];
          SEG_E <= SEG_1[31:24];
          SEG_F <= SEG_1[23:16];
          SEG_G <= SEG_1[15:8];
          SEG_H <= SEG_1[7:0];
          SEG_SEL <= 9'b0_0000_0001;
        end
        3'd1: begin
          SEG_A <= SEG_2[31:24];
          SEG_B <= SEG_2[23:16];
          SEG_C <= SEG_2[15:8];
          SEG_D <= SEG_2[7:0];
          SEG_E <= SEG_3[31:24];
          SEG_F <= SEG_3[23:16];
          SEG_G <= SEG_3[15:8];
          SEG_H <= SEG_3[7:0];
          SEG_SEL <= 9'b0_0000_0010;
        end
        3'd2: begin
          SEG_A <= SEG_4[31:24];
          SEG_B <= SEG_4[23:16];
          SEG_C <= SEG_4[15:8];
          SEG_D <= SEG_4[7:0];
          SEG_E <= SEG_5[31:24];
          SEG_F <= SEG_5[23:16];
          SEG_G <= SEG_5[15:8];
          SEG_H <= SEG_5[7:0];
          SEG_SEL <= 9'b0_0000_0100;
        end
        3'd3: begin
          SEG_A <= SEG_6[31:24];
          SEG_B <= SEG_6[23:16];
          SEG_C <= SEG_6[15:8];
          SEG_D <= SEG_6[7:0];
          SEG_E <= SEG_7[31:24];
          SEG_F <= SEG_7[23:16];
          SEG_G <= SEG_7[15:8];
          SEG_H <= SEG_7[7:0];
          SEG_SEL <= 9'b0_0000_1000;
        end
        3'd4: begin
          SEG_A <= SEG_8[31:24];
          SEG_B <= SEG_8[23:16];
          SEG_C <= SEG_8[15:8];
          SEG_D <= SEG_8[7:0];
          SEG_E <= SEG_9[31:24];
          SEG_F <= SEG_9[23:16];
          SEG_G <= SEG_9[15:8];
          SEG_H <= SEG_9[7:0];
          SEG_SEL <= 9'b0_0001_0000;
        end
        3'd5: begin
          SEG_A <= SEG_10[31:24];
          SEG_B <= SEG_10[23:16];
          SEG_C <= SEG_10[15:8];
          SEG_D <= SEG_10[7:0];
          SEG_E <= SEG_11[31:24];
          SEG_F <= SEG_11[23:16];
          SEG_G <= SEG_11[15:8];
          SEG_H <= SEG_11[7:0];
          SEG_SEL <= 9'b0_0010_0000;
        end
        3'd6: begin
          SEG_A <= SEG_12[31:24];
          SEG_B <= SEG_12[23:16];
          SEG_C <= SEG_12[15:8];
          SEG_D <= SEG_12[7:0];
          SEG_E <= SEG_13[31:24];
          SEG_F <= SEG_13[23:16];
          SEG_G <= SEG_13[15:8];
          SEG_H <= SEG_13[7:0];
          SEG_SEL <= 9'b0_0100_0000;
        end
        3'd7: begin
          SEG_A <= SEG_14[31:24];
          SEG_B <= SEG_14[23:16];
          SEG_C <= SEG_14[15:8];
          SEG_D <= SEG_14[7:0];
          SEG_E <= SEG_15[31:24];
          SEG_F <= SEG_15[23:16];
          SEG_G <= SEG_15[15:8];
          SEG_H <= SEG_15[7:0];
          SEG_SEL <= 9'b0_1000_0000;
        end
      endcase
      if(COUNTER == COUNT_MAX) begin
        COUNTER <= 3'd0;
      end else begin
        COUNTER <= COUNTER + 3'd1;
      end
    end
  end
end

endmodule
