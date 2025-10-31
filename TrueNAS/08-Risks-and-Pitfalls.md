# Risks and Pitfalls
**Date:** 2025-10-31
**Last updated:** 2025-10-31

## PCIe / Lane Bottlenecks
- **Mini‑ITX (A):** M.2 (Gen3×2) used by **JMB585 → 5× SATA** caps total SATA bandwidth at ~1.6–1.8 GB/s—fine for SSD mirrors/RAIDZ in a learning box. Keep the PCIe slot for the **2.5 GbE NIC** (x1). citeturn15search2turn14search0
- **MS‑01 (C):** Mixed lane widths across M.2 (e.g., 3×2, 3×1 shared, 4×4) can constrain aggregate throughput; PCIe dual‑M.2 works but watch shared lanes. citeturn20view0turn21search8

## NVMe Thermals in 2U
- NVMe SSDs **throttle** without adequate airflow/heatsinks in compact enclosures; add heatsinks and keep steady low airflow to avoid temperature cycling. citeturn13search2
- Prefer **2U** for NVMe‑heavy layouts; set gentle fan curves. **Noctua** 60 mm PWM at <2k RPM keeps noise <20 dB(A). citeturn24search1

## SATA Backplane Power Limits
- Don’t power many drives from a single tiny header unless the board **explicitly supports it**. The N100DC‑ITX **SATA_PWR1** exposes **+5 V / +12 V** for drives, but assume **SSD‑only** and split power conservatively. citeturn12open0

## USB Boot & USB‑Attached Pools
- **Avoid USB boot**; frequent failure reports and bootloader issues. Use NVMe or SATA SSD for boot. citeturn23search8
- **Avoid USB enclosures** for ZFS pool devices due to disconnects/quirks; use native SATA/NVMe. citeturn23search12

## Noisy 40 mm Fans
- 1U builds typically use 40 mm fans which can be loud. Choose **40×20 mm PWM** (NF‑A4x20) and low RPM tables; for room to breathe, go **2U** and **60 mm**. citeturn24search0turn24search1

## Mechanical Fit
- **1U = 44.45 mm, 2U = 88.9 mm.** Check your board heatsink, **M.2 underside** clearance, and drive cage height. T1 **200 mm depth** is tight for front cages; T1 Plus **260 mm** eases cable bend radius. citeturn22search2turn22search6

## Mitigations
- **Vdev choice for resilver speed:** prefer **mirrors** with SSDs to keep resilvers fast and limit heat bursts; RAIDZ2 for 6‑drive pools if you want parity.  
- **Fan tables:** use PWM curves that hold ~40–50 °C SSD temps under scrub; avoid saw‑toothing.  
- **Spares & monitoring:** keep 1 spare SSD and alert on **SMART/temperature**; scrub every 2–4 weeks.

