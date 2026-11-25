module uart_rx #(parameter CLKS_PER_BIT = 434)(
  input clk, rx,
  output reg [7:0] data = 0,
  output reg valid = 0);

  localparam IDLE=0, START=1, DATA=2, STOP=3;
  reg [1:0] state = IDLE;
  reg [8:0] cnt = 0;
  reg [2:0] idx = 0;
  reg [7:0] shift = 0;
  reg rx_s1 = 1, rx_s2 = 1;

  // 2-flip-flop synchronizer
  always @(posedge clk) begin
    rx_s1 <= rx;
    rx_s2 <= rx_s1;
  end

  always @(posedge clk) begin
    valid <= 0;
    case (state)
      IDLE: begin
        cnt <= 0; idx <= 0;
        if (rx_s2 == 0) state <= START;
      end
      START: begin
        if (cnt == (CLKS_PER_BIT/2)-1) begin
          cnt <= 0;
          if (rx_s2 == 0) state <= DATA;
          else state <= IDLE;
        end else cnt <= cnt + 1;
      end
      DATA: begin
        if (cnt == CLKS_PER_BIT-1) begin
          cnt <= 0;
          shift[idx] <= rx_s2;
          if (idx == 7) state <= STOP;
          else idx <= idx + 1;
        end else cnt <= cnt + 1;
      end
      STOP: begin
        if (cnt == CLKS_PER_BIT-1) begin
          cnt <= 0;
          data <= shift;
          valid <= 1;
          state <= IDLE;
        end else cnt <= cnt + 1;
      end
    endcase
  end
endmodule