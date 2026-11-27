# UART TX/RX in Verilog
FSM-based UART transmitter and receiver (8N1) with a self-checking loopback testbench.

## Tools
Icarus Verilog, EDA Playground, GTKWave

## How to run
iverilog -o sim src/uart_tx.v src/uart_rx.v tb/tb_loopback.v
vvp sim

## Results
Loopback test prints PASS for all test bytes. See docs/ for waveforms.

## Next steps
Stop-bit check, FPGA implementation

## Simulation Waveforms

### UART Transmitter Waveform
![UART TX Waveform](UART_TX_WAVE.png)

### UART Transmitter and Receiver Waveform
![UART TX RX Waveform](UART_TX_RX_WAVE.png)

## Project Objective
To design and simulate an FSM-based UART transmitter and receiver using Verilog HDL and verify serial data communication through a loopback testbench.

## Working Principle
- UART transmitter converts parallel data into serial data.
- UART receiver receives serial data and converts it back into parallel data.
- The loopback testbench connects TX output to RX input.
- The received data is compared with the transmitted data to verify correct communication.

## Project Architecture
The project consists of three main modules:
1. UART Transmitter (uart_tx.v)
2. UART Receiver (uart_rx.v)
3. Loopback Testbench (tb_loopback.v)

## Future Scope
- FPGA hardware implementation.
- Configurable baud rate.
- Parity bit support.
- Stop-bit error detection.

