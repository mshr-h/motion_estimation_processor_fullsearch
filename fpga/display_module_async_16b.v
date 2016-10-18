`timescale 1ps/1ps

module display_module_async_16b
(
  input  wire [15:0] data,
  output wire [31:0] SEG_32
);

wire[7:0] SEG0,SEG1,SEG2,SEG3;

display_module_async
i0
(
  .SEG_VAL (data[3:0]),
  .SEG     (SEG0)
);
display_module_async
i1
(
  .SEG_VAL (data[7:4]),
  .SEG     (SEG1)
);
display_module_async
i2
(
  .SEG_VAL (data[11:8]),
  .SEG     (SEG2)
);
display_module_async
i3
(
  .SEG_VAL (data[15:12]),
  .SEG     (SEG3)
);

assign SEG_32[31:24] = SEG3;
assign SEG_32[23:16] = SEG2;
assign SEG_32[15:8]  = SEG1;
assign SEG_32[7:0]   = SEG0;

endmodule
