# Parameterized Round Robin Arbiter

## Overview
This project implements a parameterized Round Robin Arbiter in Verilog HDL. It provides fair access among multiple requesters by rotating the priority after each successful grant.

## Features
- Parameterized number of requesters (N)
- One-hot grant output
- Fair round robin arbitration
- Synchronous reset
- Synthesizable RTL design

## Files
- `rtl/round_robin_arbiter.v` – RTL implementation
- `tb/round_robin_arbiter_tb.v` – Testbench
- `waveforms/sim.png` – Simulation waveform

## Tools Used
- Verilog HDL
- Icarus Verilog
- GTKWave

## Simulation
The design was verified using a self-checking testbench. The waveform confirms that only one requester is granted at a time and the priority rotates fairly among active requesters.
