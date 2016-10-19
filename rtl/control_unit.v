module control_unit
#(
  parameter SAD_WIDTH = 16,
  parameter CNT_WIDTH = 12,
  parameter TB_LENGTH = 16,
  parameter SW_LENGTH = 64
) (
  input  wire                 rst_n,
  input  wire                 clk,
  input  wire                 req,
  input  wire [SAD_WIDTH-1:0] sad,
  output wire                 clr,
  output wire                 en_addr_sw,
  output wire                 en_addr_tb,
  output wire                 en_pearray_sw,
  output reg                  en_pearray_tb,
  output reg  [CNT_WIDTH-1:0] min_cnt,
  output reg  [SAD_WIDTH-1:0] min_sad,
  output reg  [CNT_WIDTH-1:0] min_mvec,
  output wire                 ack
);

localparam INIT             = 2'b00;
localparam WAIT_REQ         = 2'b01;
localparam RUNNING          = 2'b10;
localparam WAIT_REQ_FALL    = 2'b11;
localparam WAIT_RUN         = 2'b01;
localparam ACTIVE           = 2'b10;
localparam DONE             = 2'b11;
localparam WAIT_DUMMY_CYCLE = 3'b100;
localparam WAIT_SRCH_END    = 2'b01;
localparam DONE_CNT         = 2'b10;
localparam DONE_ACTIVE      = 2'b11;

localparam CNT_ADDR_SW_END    = SW_LENGTH**2-2;
localparam CNT_ADDR_TB_END    = TB_LENGTH**2-1;
localparam CNT_PEARRAY_SW_END = SW_LENGTH**2+(SW_LENGTH-TB_LENGTH-1);
localparam CNT_DUMMY_CYCLE    = SW_LENGTH-TB_LENGTH+7;

reg [2-1:0]         state_main;
reg [CNT_WIDTH-1:0] cnt_min;
reg [1:0]           state_addr_sw;
reg [12:0]          cnt_addr_sw;
reg [1:0]           state_addr_tb;
reg [8:0]           cnt_addr_tb;
reg [1:0]           state_pearray_sw;
reg [12:0]          cnt_pearray_sw;
reg [2:0]           state_valid;
reg [10:0]          cnt_dummy;
reg [6:0]           cnt_x;
reg [6:0]           cnt_y;
reg [1:0]           state_done;
reg                 cnt_done;

assign ack           = (state_main == WAIT_REQ_FALL);
assign clr           = (state_main == WAIT_REQ);
assign en_addr_sw    = (cnt_addr_sw != 0);
assign en_addr_tb    = (cnt_addr_tb != 0);
assign en_pearray_sw = (cnt_pearray_sw != 0);
wire   valid         = (cnt_x > (TB_LENGTH-2)) && (cnt_y > (TB_LENGTH-2));
wire   done          = (state_done == DONE_ACTIVE);

// FSM main
always @(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    state_main <= INIT;
  end else begin
    case(state_main)
      INIT          :          state_main <= WAIT_REQ;
      WAIT_REQ      : if( req) state_main <= RUNNING;
      RUNNING       : if(done) state_main <= WAIT_REQ_FALL;
      WAIT_REQ_FALL : if(~req) state_main <= WAIT_REQ;
      default       :          state_main <= 2'bxx;
    endcase
  end
end

// FSM for addr_sw
always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    state_addr_sw <= INIT;
  end else begin
    case(state_addr_sw)
      INIT     :                                  state_addr_sw <= WAIT_RUN;
      WAIT_RUN : if(state_main==RUNNING)          state_addr_sw <= ACTIVE;
      ACTIVE   : if(cnt_addr_sw==CNT_ADDR_SW_END) state_addr_sw <= DONE;
      DONE     : if(state_main==WAIT_REQ_FALL)    state_addr_sw <= WAIT_RUN;
      default  :                                  state_addr_sw <= 2'bxx;
    endcase
  end
end

always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    cnt_addr_sw <= 0;
  end else begin
    case (state_addr_sw)
      INIT    : cnt_addr_sw <= 0;
      WAIT_RUN: cnt_addr_sw <= 0;
      ACTIVE  : cnt_addr_sw <= cnt_addr_sw + 1;
      DONE    : cnt_addr_sw <= 0;
      default : cnt_addr_sw <= 12'dx;
    endcase
  end
end

// FSM for addr_tb
always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    state_addr_tb <= INIT;
  end else begin
    case(state_addr_tb)
      INIT     :                                  state_addr_tb <= WAIT_RUN;
      WAIT_RUN : if(state_main==RUNNING)          state_addr_tb <= ACTIVE;
      ACTIVE   : if(cnt_addr_tb==CNT_ADDR_TB_END) state_addr_tb <= DONE;
      DONE     : if(state_main==WAIT_REQ_FALL)    state_addr_tb <= WAIT_RUN;
      default  :                                  state_addr_tb <= 2'bxx;
    endcase
  end
end

always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    cnt_addr_tb <= 0;
  end else begin
    case (state_addr_tb)
      INIT    : cnt_addr_tb <= 0;
      WAIT_RUN: cnt_addr_tb <= 0;
      ACTIVE  : cnt_addr_tb <= cnt_addr_tb + 1;
      DONE    : cnt_addr_tb <= 0;
      default : cnt_addr_tb <= 8'dx;
    endcase
  end
end

// FSM for pearray_sw
always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    state_pearray_sw <= INIT;
  end else begin
    case(state_pearray_sw)
      INIT     :                                        state_pearray_sw <= WAIT_RUN;
      WAIT_RUN : if(state_addr_sw==ACTIVE)              state_pearray_sw <= ACTIVE;
      ACTIVE   : if(cnt_pearray_sw==CNT_PEARRAY_SW_END) state_pearray_sw <= DONE;
      DONE     : if(state_main==WAIT_REQ_FALL)          state_pearray_sw <= WAIT_RUN;
      default  :                                        state_pearray_sw <= 2'bxx;
    endcase
  end
end

always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    cnt_pearray_sw <= 0;
  end else begin
    case (state_pearray_sw)
      INIT    : cnt_pearray_sw <= 0;
      WAIT_RUN: cnt_pearray_sw <= 0;
      ACTIVE  : cnt_pearray_sw <= cnt_pearray_sw + 1;
      DONE    : cnt_pearray_sw <= 0;
      default : cnt_pearray_sw <= 12'dx;
    endcase
  end
end

// pearray_tb
always @(posedge clk)
  en_pearray_tb <= en_addr_tb;

// FSM for valid
always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    state_valid <= INIT;
  end else begin
    case(state_valid)
      {1'b0, INIT}     :                                state_valid <= {1'b0, WAIT_RUN};
      {1'b0, WAIT_RUN} : if(state_main==RUNNING)        state_valid <= WAIT_DUMMY_CYCLE;
      WAIT_DUMMY_CYCLE : if(cnt_dummy==CNT_DUMMY_CYCLE) state_valid <= {1'b0, ACTIVE};
      {1'b0, ACTIVE}   : if((cnt_x==(SW_LENGTH-1))&&(cnt_y==(SW_LENGTH-1)))
                                                        state_valid <= {1'b0, DONE};
      {1'b0, DONE}     : if(state_main==WAIT_REQ_FALL)  state_valid <= {1'b0, WAIT_RUN};
      default          :                                state_valid <= 3'bxx;
    endcase
  end
end

always @(posedge clk or negedge rst_n) begin
  if (~rst_n)
    cnt_dummy <= 0;
  else if(state_valid==WAIT_DUMMY_CYCLE)
    cnt_dummy <= cnt_dummy + 1;
  else
    cnt_dummy <= 0;
end

always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    cnt_x <= 0;
    cnt_y <= 0;
  end else if(state_valid=={1'b0, ACTIVE})begin
    if(cnt_y < (SW_LENGTH-1))
      cnt_y <= cnt_y + 1;
    else begin
      cnt_y <= 0;
      cnt_x <= cnt_x + 1;
    end
  end else begin
    cnt_x <= 0;
    cnt_y <= 0;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (~rst_n)
    state_done <= INIT;
  else begin
    case (state_done)
      INIT          :                      state_done <= WAIT_SRCH_END;
      WAIT_SRCH_END : if(cnt_x==SW_LENGTH) state_done <= DONE_CNT;
      DONE_CNT      : if(cnt_done==1)      state_done <= DONE_ACTIVE;
      DONE_ACTIVE   :                      state_done <= WAIT_SRCH_END;
      default       :                      state_done <= 2'bxx;
    endcase
  end
end

always @(posedge clk or negedge rst_n) begin
  if (~rst_n)
    cnt_done <= 0;
  else if(state_done==DONE_CNT)
    cnt_done <= cnt_done + 1;
  else
    cnt_done <= 0;
end

always @(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    cnt_min <= 0;
  end else begin
    case(state_main)
      INIT          :           cnt_min <= 0;
      WAIT_REQ      :           cnt_min <= 0;
      RUNNING       : if(valid) cnt_min <= cnt_min + 1;
      WAIT_REQ_FALL : ;
      default       :           cnt_min <= 2'bxx;
    endcase
  end
end

always @(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    min_sad  <= {SAD_WIDTH{1'b1}};
    min_cnt  <= 0;
    min_mvec <= 0;
  end else begin
    case(state_main)
      INIT     : begin
        min_sad  <= {SAD_WIDTH{1'b1}};
        min_cnt  <= 0;
        min_mvec <= 0;
      end
      WAIT_REQ : begin
        min_sad  <= {SAD_WIDTH{1'b1}};
        min_cnt  <= 0;
        min_mvec <= 0;
      end
      RUNNING  : begin
        if(valid && (min_sad > sad)) begin
          min_sad  <= sad;
          min_cnt  <= cnt_min;
          min_mvec <= {cnt_y[5:0], cnt_x[5:0]};
        end
      end
      WAIT_REQ_FALL : ;
      default  : begin
        min_sad  <= {SAD_WIDTH{1'bx}};
        min_cnt  <= {CNT_WIDTH{1'bx}};
        min_mvec <= {CNT_WIDTH{1'bx}};;
      end
    endcase
  end
end

endmodule
