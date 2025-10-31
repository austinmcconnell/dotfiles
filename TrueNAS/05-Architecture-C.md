# Architecture C — Mini‑PC (MS‑01), Dual 2.5 GbE + Multi‑M.2 (All‑NVMe or Hybrid)
**Date:** 2025-10-31
**Last updated:** 2025-10-31

**Why this fits a quiet 10″ rack.** The **Minisforum MS‑01** has **2×10 GbE SFP+ + 2×2.5 GbE** and **3× M.2** by default, with a PCIe slot for a **dual‑M.2 carrier**. It’s **48 mm tall**, so treat it as a clean **2U** unit on a DeskPi shelf. Great for NVMe‑only pools (fast resilver, but mind thermals). citeturn21search0turn21search5

## Airflow (ASCII)
```
Front               Rear
[ 2U shelf intake ] => MS-01 chassis intakes => rear exhaust
(NVMe heatsinks + gentle airflow are essential in 2U)
```

## Lanes / Ports
```
Intel 13th-gen mobile SoC
 ├─ 3× M.2 (mixed lanes: e.g., 3×2, 3×4, 4×4 per community testing)
 ├─ PCIe slot (works with dual-M.2 cards)
 ├─ 2× SFP+ 10GbE + 2× 2.5GbE
 └─ USB4, etc.
```
Lane mix & PCIe use validated in reviews; dual‑M.2 in the PCIe slot works. citeturn20view0turn21search8

## 10‑step Build
- Mount MS‑01 on a **DeskPi 1U/2U mini‑PC shelf** (it’s ≈48 mm tall → allocate **2U**). citeturn22search7
- Install **2–3 NVMe**; add **dual‑M.2 PCIe** card later if scaling.
- Fit **heatsinks** to all NVMe; ensure front‑to‑back airflow.
- Optionally add a quiet 60 mm fan on the shelf to push air across SSDs. citeturn24search1
- Install TrueNAS SCALE to a small NVMe; create initial mirror/RAIDZ pool.
- Set **compression=zstd**, **autotrim=on** (SSD), and **sync=standard** (see Ops plan).
- Cable **2.5 GbE** to core switch; keep 10 GbE for future tests.
- Add **scrub** and **SMART** schedules.
- Track NVMe temps; stay below throttling thresholds with heatsinks/air. citeturn13search2
- Document lane usage for future PCIe add‑ins.

**BOM:** See [07-BOMs-and-Links.md](07-BOMs-and-Links.md#architecture-c-mini-pc-ms-01-all-nvme).

