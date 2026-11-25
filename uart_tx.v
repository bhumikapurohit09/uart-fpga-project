module uart_tx #(parameter CLKS_PER_BIT = 434)(
  input clk, start,
  input [7:0] data,
  output reg tx, busy);

  localparam IDLE=0, START=1, DATA=2, STOP=3;
  reg [1:0] state = IDLE;
  reg [8:0] cnt = 0;
  reg [2:0] idx = 0;
  reg [7:0] d;

  initial begin tx = 1; busy = 0; end

  always @(posedge clk) begin
    case (state)
      IDLE: begin
        tx <= 1; busy <= 0; cnt <= 0; idx <= 0;
        if (start) begin d <= data; busy <= 1; state <= START; end
      end
      START: begin
        tx <= 0;
        if (cnt == CLKS_PER_BIT-1) begin cnt <= 0; state <= DATA; end
        else cnt <= cnt + 1;
      end
      DATA: begin
        tx <= d[idx];
        if (cnt == CLKS_PER_BIT-1) begin
          cnt <= 0;
          if (idx == 7) state <= STOP;
          else idx <= idx + 1;
        end else cnt <= cnt + 1;
      end
      STOP: begin
        tx <= 1;
        if (cnt == CLKS_PER_BIT-1) begin cnt <= 0; state <= IDLE; end
        else cnt <= cnt + 1;
      end
    endcase
  end
endmodule