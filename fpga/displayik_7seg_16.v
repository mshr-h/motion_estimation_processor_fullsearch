module displayIK_7seg_16
(
  input  wire        CLK,
  input  wire        RSTN,
  input  wire [15:0] data0,
  input  wire [15:0] data1,
  input  wire [15:0] data2,
  input  wire [15:0] data3,
  input  wire [15:0] data4,
  input  wire [15:0] data5,
  input  wire [15:0] data6,
  input  wire [15:0] data7,
  input  wire [15:0] data8,
  input  wire [15:0] data9,
  input  wire [15:0] data10,
  input  wire [15:0] data11,
  input  wire [15:0] data12,
  input  wire [15:0] data13,
  input  wire [15:0] data14,
  input  wire [15:0] data15,
  output wire [7:0]  SEG_A,
  output wire [7:0]  SEG_B,
  output wire [7:0]  SEG_C,
  output wire [7:0]  SEG_D,
  output wire [7:0]  SEG_E,
  output wire [7:0]  SEG_F,
  output wire [7:0]  SEG_G,
  output wire [7:0]  SEG_H,
  output wire [8:0]  SEG_SEL
);

wire [31:0] SEG_0,SEG_1,SEG_2,SEG_3,SEG_4,SEG_5,SEG_6,SEG_7;
wire [31:0] SEG_8,SEG_9,SEG_10,SEG_11,SEG_12,SEG_13,SEG_14,SEG_15;

display_module_async_16b
i0
(
  .data   (data0),
  .SEG_32 (SEG_0)
);
display_module_async_16b
i1
(
  .data   (data1),
  .SEG_32 (SEG_1)
);
display_module_async_16b
i2
(
  .data   (data2),
  .SEG_32 (SEG_2)
);
display_module_async_16b
i3
(
  .data   (data3),
  .SEG_32 (SEG_3)
);
display_module_async_16b
i4
(
  .data   (data4),
  .SEG_32 (SEG_4)
);
display_module_async_16b
i5
(
  .data   (data5),
  .SEG_32 (SEG_5)
);
display_module_async_16b
i6
(
  .data   (data6),
  .SEG_32 (SEG_6)
);
display_module_async_16b
i7
(
  .data   (data7),
  .SEG_32 (SEG_7)
);
display_module_async_16b
i8
(
  .data   (data8),
  .SEG_32 (SEG_8)
);
display_module_async_16b
i9
(
  .data   (data9),
  .SEG_32 (SEG_9)
);
display_module_async_16b
i10
(
  .data   (data10),
  .SEG_32 (SEG_10)
);
display_module_async_16b
i11
(
  .data   (data11),
  .SEG_32 (SEG_11)
);
display_module_async_16b
i12
(
  .data   (data12),
  .SEG_32 (SEG_12)
);
display_module_async_16b
i13
(
  .data   (data13),
  .SEG_32 (SEG_13)
);
display_module_async_16b
i14
(
  .data   (data14),
  .SEG_32 (SEG_14)
);
display_module_async_16b
i15
(
  .data   (data15),
  .SEG_32 (SEG_15)
);
dynamic_displayIK_16
i16
(
  .CLK     (CLK),
  .RST     (RSTN),
  .SEG_0   (SEG_0),
  .SEG_1   (SEG_1),
  .SEG_2   (SEG_2),
  .SEG_3   (SEG_3),
  .SEG_4   (SEG_4),
  .SEG_5   (SEG_5),
  .SEG_6   (SEG_6),
  .SEG_7   (SEG_7),
  .SEG_8   (SEG_8),
  .SEG_9   (SEG_9),
  .SEG_10  (SEG_10),
  .SEG_11  (SEG_11),
  .SEG_12  (SEG_12),
  .SEG_13  (SEG_13),
  .SEG_14  (SEG_14),
  .SEG_15  (SEG_15),
  .SEG_A   (SEG_A),
  .SEG_B   (SEG_B),
  .SEG_C   (SEG_C),
  .SEG_D   (SEG_D),
  .SEG_E   (SEG_E),
  .SEG_F   (SEG_F),
  .SEG_G   (SEG_G),
  .SEG_H   (SEG_H),
  .SEG_SEL (SEG_SEL)
);

endmodule
