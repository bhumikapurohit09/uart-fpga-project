module tb;
  reg clk = 0, start = 0;
  reg [7:0] din;
  wire tx, busy, valid;
  wire [7:0] dout;

  uart_tx #(4) TX (clk, start, din, tx, busy);
  uart_rx #(4) RX (clk, tx, dout, valid);

  always #5 clk = ~clk;

  task send(input [7:0] b);
    begin
      din = b;
      @(posedge clk); start = 1;
      @(posedge clk); start = 0;
      wait (valid);
      if (dout == b) $display("PASS: sent %h got %h", b, dout);
      else           $display("FAIL: sent %h got %h", b, dout);
      wait (!busy);
    end
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
    send(8'h41); send(8'h55); send(8'hFF); send(8'h00);
    $finish;
  end

  initial begin
    #20000 $display("TIMEOUT");
    $finish;
  end
endmodule