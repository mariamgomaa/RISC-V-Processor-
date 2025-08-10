RISC-V Single-Cycle RV-32I Processor

📌 Project Overview
This project implements a 32-bit Single-Cycle RV-32I RISC-V Processor based on the Harvard architecture.
The processor executes an entire instruction in a single clock cycle — including instruction fetch, decode, execute, memory access, write-back, and PC update.
The design was implemented in Verilog HDL and deployed on a Cyclone® IV FPGA device.
It was developed as the final project for the IEEE Digital Design Workshop.

🛠 Features
. Single-Cycle Execution for all instructions
. ALU supporting multiple arithmetic & logic operations
. Program Counter with Next-PC calculation for sequential and branch instructions
. Instruction Memory (ROM) and Data Memory (RAM) modules
. Register File with dual read ports and single write port
. Control Unit with opcode & funct-based decoding
. Sign Extension and MUX modules
