# Parameterized Round Robin Arbiter (Verilog)

## Overview

This project implements a parameterized Round Robin Arbiter in Verilog HDL. The arbiter provides fair access among multiple requesters by rotating the grant priority after every successful arbitration. Unlike fixed-priority arbiters, the round robin scheduling algorithm prevents starvation by ensuring that every requester eventually receives service.

The design supports a configurable number of request inputs through parameterization, making it reusable for different arbitration requirements.

---

## Features

- Parameterized number of requesters
- Fair round robin arbitration
- Rotating priority pointer
- One-hot grant output
- Starvation-free scheduling
- Synthesizable RTL design
- Functional verification using a Verilog testbench

---

## Project Structure

```
round_robin_arbiter/
│── round_robin.v          // RTL Design
│── round_robin_tb.v       // Testbench
│── waveform.png           // Simulation Waveform
└── README.md
```

---

## Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| N | Number of requesters | 4 |

---

## Module Interface

### Inputs

| Signal | Width | Description |
|--------|-------|-------------|
| clk | 1 | System clock |
| rst | 1 | Synchronous reset |
| req | N | Request inputs |

### Outputs

| Signal | Width | Description |
|--------|-------|-------------|
| grant | N | One-hot grant output |

---

## Block Diagram

```text
                    +--------------------------------+
                    |     Round Robin Arbiter        |
                    |                                |
req[N-1:0] -------->|                                |-------> grant[N-1:0]
clk ---------------->|                                |
rst ---------------->|                                |
                    |                                |
                    |      Priority Pointer          |
                    |              │                 |
                    |              ▼                 |
                    |    Round Robin Scheduler       |
                    |              │                 |
                    |              ▼                 |
                    |      Grant Generation Logic    |
                    +--------------------------------+
```

---

## Working Principle

### Request Arbitration

- The arbiter continuously monitors all request inputs.
- Requests are evaluated starting from the current priority pointer.
- The first active request encountered is granted access.

### Grant Generation

- Only one requester is granted at any clock cycle.
- The grant output is one-hot encoded.

### Pointer Update

- After a successful grant, the priority pointer advances to the next requester.
- This ensures that the next arbitration begins from the subsequent requester.

### Fairness

Unlike fixed-priority arbiters, every requester eventually receives service if it continuously requests access. This eliminates starvation and distributes access fairly among all requesters.

---

## Arbitration Example

Assume four requesters (N = 4).

| Current Pointer | Active Requests | Granted Request | Next Pointer |
|-----------------|-----------------|-----------------|--------------|
| 0 | 0101 | Request 0 | 1 |
| 1 | 0101 | Request 2 | 3 |
| 3 | 1111 | Request 3 | 0 |
| 0 | 1111 | Request 0 | 1 |

---

## Testbench Verification

The testbench verifies the following scenarios:

- Reset operation
- No active requests
- Single request
- Multiple simultaneous requests
- Continuous arbitration
- Pointer rotation
- Fair grant distribution

---

## Simulation Result

Add the GTKWave waveform screenshot below.

```markdown
![Waveform](waveform.png)
```

---

## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Visual Studio Code

---

## Concepts Practiced

- Parameterized RTL Design
- Arbitration Algorithms
- Round Robin Scheduling
- One-Hot Encoding
- Pointer-Based Priority Management
- Sequential Logic Design
- Verilog Testbench Development
- RTL Simulation and Debugging

---

## Applications

- Network-on-Chip (NoC) Routers
- Bus Arbitration
- Shared Memory Controllers
- DMA Controllers
- AXI/AHB Bus Arbitration
- Multi-core Processor Interconnects
- FPGA Communication Fabrics

---

## Future Improvements

- Weighted Round Robin Arbiter
- Dynamic Priority Arbitration
- Lock and Parking Support
- Request Masking
- Pipelined Arbitration
- Parameterized Priority Rotation Schemes
- SystemVerilog Assertions (SVA)
- Self-checking Testbench
- Constrained-Random Verification

---
