# 16x8 Synchronous RAM — SystemVerilog Verification Testbench

A class-based (UVM-style) verification environment for a 16-deep, 8-bit
wide synchronous single-port RAM, built with a generator/driver/monitor/
scoreboard/coverage architecture and SystemVerilog Assertions.

## DUT

- 16x8 synchronous RAM, single port
- Synchronous active-high reset
- One clock of read latency: address/`rd_en` sampled on cycle N, `dout`
  valid on cycle N+1

## Testbench architecture

| Component | Role |
|---|---|
| `transaction_ram` | Randomized stimulus item (`wr_en`, `rd_en`, `addr`, `wr_data`) with a constraint preventing simultaneous read+write |
| `generator_ram` | Produces N randomized transactions into a mailbox |
| `driver_ram` | Drives transactions onto the DUT interface after a reset sequence |
| `monitor_ram` | Samples the bus and reconstructs completed transactions, including `dout` |
| `scoreboard_ram` | Self-checks DUT reads against an internal reference memory model |
| `coverage_ram` | Functional coverage: operation type, address, data value, and operation×address cross coverage |
| `assertions_ram` | SVA checks: no simultaneous read/write, known address/data on valid ops, `dout` reset value |
| `enviroment_ram` | Instantiates and connects all components, manages run/shutdown |

## A bug worth mentioning

The first working version of the monitor sampled `wr_en/rd_en/addr/din`
and `dout` **in the same cycle**. Because this RAM has a 1-cycle read
latency, that pairs each request with the *previous* cycle's `dout`,
not its own — so back-to-back reads to different addresses produced
false scoreboard failures (or worse, coincidental false passes).

Fixed with a one-transaction shift-register in the monitor: each
sampled request is held back one cycle and only emitted once its
matching `dout` has actually appeared on the bus.

## Results

- **Assertion checks:** 0 failures across all 6 SVA properties over a 100-transaction random run
- **Functional coverage:** 96.35% (operation type, address, data value, and operation×address cross) — see `reports/coverage_report.txt`
- Full run transcript in `reports/sim.log`

## Waveform

Write to addr 5 followed by a matching read (confirms correct 1-cycle read latency):

![RAM read/write waveform](waveform/image.png)

## Running it

```
vlib work
vlog -sv +cover=bcesfx tb/*.sv rtl/*.sv
vsim -c -coverage -assertdebug work.top -l reports/sim.log -do "run -all; coverage report -details -output reports/coverage_report.txt; assertion report -recursive -file reports/assertion_report.txt; coverage save reports/ram_cov.ucdb; quit -sim"
```

or from inside the QuestaSim console:
```
do sim/run.do
```

## Tools

QuestaSim 10.7c, gVim

