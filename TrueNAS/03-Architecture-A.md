# Architecture A — Mini‑ITX + Front 2.5″ SSD Cage (SATA‑first)
**Date:** 2025-10-31
**Last updated:** 2025-10-31

**Why this fits a quiet 10″ rack.** Thin/low‑TDP Mini‑ITX with **19 V DC‑in**, **onboard SATA power header**, and an **M.2→5× SATA (JMB585)** lets you run 4–6× 2.5″ SATA SSDs with minimal heat and keep the PCIe slot free for a quiet **2.5 GbE** NIC. The DeskPi 10″ **1U shelf** and 3D‑printed brackets make a tidy, tool‑less front SSD row. citeturn11search3turn12open0turn15search2turn22search3turn7search0

## Airflow (ASCII)
```
Front (rack)                  Rear
[ 1U SSD cage -> ] ==> 40x20 PWM ==> | ITX board | ==> 40x20 PWM
          cool intake                 heatsink (passive/N100)       exhaust
```

## Lanes / Ports
```
CPU (e.g., Intel N100 SoC)
 ├─ PCIe x2 (Gen3) -> M.2 M-key (NVMe or JMB585 5×SATA)
 ├─ PCIe slot (x2 electrical) -> 2.5GbE NIC (x1)
 ├─ 2× SATA 6G -> drives (use for boot or data)
 └─ Realtek GbE (unused) + USB, etc.
```
**Board example/spec reference:** ASRock **N100DC‑ITX** — 19 V DC‑in, **SATA_PWR1** header (+5 V/+12 V), 2× SATA, M.2 (PCIe Gen3 x2). citeturn11search3turn12open0  
**SATA fan‑out:** JMB585 M.2 to **5× SATA** (Gen3 x2 ≈ 16 Gb/s aggregate). citeturn15search2

## 10‑step Build
- Mount a **DeskPi 1U shelf** and 3D‑print front brackets (see Geerling’s repo issues). citeturn22search3turn7search0
- Standoff‑mount the Mini‑ITX board; route a **19 V brick** to DC‑in (5.5×2.5 mm typical). citeturn10search4
- Install **NVMe** (boot) in M.2 temporarily for OS install.
- If expanding beyond 2 SATA, replace boot NVMe with **M.2→5× SATA (JMB585)** and move boot to a small **SATA SSD**.
- Fit **2× Noctua 40×20 PWM** fans; set PWM curve for <2k RPM idle. citeturn24search0
- Wire **SATA_PWR1** to a **1→4 SATA power splitter**; mind current on the header (use SSDs only). citeturn12open0turn16search0
- Plug **2.5 GbE PCIe NIC** (x1) and route Ethernet to front if desired via keystone. citeturn14search0
- Install **TrueNAS SCALE** to the boot SSD; import/create pool.
- Burn **smartd** and **scrub** schedules (see Ops plan).
- Run a **memtest** overnight; then tune fan curves and ZFS ARC cap.

> **Clearance & 1U:** With passive N100 heatsink plus 40×20 fans, this fits **1U** board height; cables for the front SSD cage bend within 200 mm depth (T1). T1 Plus (260 mm) is more comfortable. Verify your specific heatsink height and M.2 underside clearance.

**BOM:** See [07-BOMs-and-Links.md](07-BOMs-and-Links.md#architecture-a-mini-itx--front-25-ssd-cage).

