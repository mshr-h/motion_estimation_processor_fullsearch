module display_module_async
(
  input  wire [3:0] SEG_VAL,
  output reg  [7:0] SEG
);

always @ (SEG_VAL) begin
  case (SEG_VAL)
    4'h0: SEG <= 8'b11111100;
    4'h1: SEG <= 8'b01100000;
    4'h2: SEG <= 8'b11011010;
    4'h3: SEG <= 8'b11110010;
    4'h4: SEG <= 8'b01100110;
    4'h5: SEG <= 8'b10110110;
    4'h6: SEG <= 8'b10111110;
    4'h7: SEG <= 8'b11100000;
    4'h8: SEG <= 8'b11111110;
    4'h9: SEG <= 8'b11110110;
    4'ha: SEG <= 8'b11101110;
    4'hb: SEG <= 8'b00111110;
    4'hc: SEG <= 8'b00011010;
    4'hd: SEG <= 8'b01111010;
    4'he: SEG <= 8'b10011110;
    4'hf: SEG <= 8'b10001110;
  endcase
end

endmodule
