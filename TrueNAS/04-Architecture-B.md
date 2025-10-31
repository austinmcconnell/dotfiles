# Architecture B — Embedded/SoC SBC (ODROID‑H4+/Ultra) + NVMe boot
**Date:** 2025-10-31
**Last updated:** 2025-10-31

**Why this fits a quiet 10″ rack.** The ODROID‑H4+/Ultra gives **dual 2.5 GbE**, **4× SATA native**, and an **M.2 NVMe (Gen3 x4)** for boot in a tiny 120×120 mm board with **19 V DC‑in**. You can either: (1) mount the bare board on a **2U shelf** with slow 60 mm fans (quietest), or (2) drop the board into **Hardkernel’s Type‑3 case** (roughly **3U height**) that can hold up to **4× 2.5″** SSDs internally—very neat, no drilling. citeturn17search0turn17search4

## Airflow (ASCII)
```
Front (rack)                         Rear
[ 2U shelf intake ] ==> 60x25 PWM  -->  Heatsink + 92mm assist  -->  60x25 PWM (exhaust)
```
(If using the official case, its internal 92×92 mm fan handles CPU/drive airflow.) citeturn17search4

## Lanes / Ports
```
Alder Lake-N SoC (N97/N305)
 ├─ M.2 M-key (PCIe Gen3 x4) -> NVMe boot
 ├─ 4× SATA 6G (H4+/Ultra) -> SSDs
 ├─ 2× 2.5GbE
 └─ USB, DP/HDMI, etc.
```
**Board refs:** H4/H4+/Ultra overview (ports), case Type‑3 drive options. citeturn17search0turn17search4

## 10‑step Build
- Decide shelf vs. **Type‑3 case** (quicker, ~3U). citeturn17search4
- Add **DDR5 SODIMM** (up to 48 GB supported) and an **NVMe** (boot). citeturn17search6
- If using the case, add 92 mm fan kit; else fit **2× Noctua 60×25** on the 2U shelf. citeturn17search4turn24search1
- Mount **2–4× 2.5″ SATA SSDs** using the case sleds or a 1U front cage + short SATA cables.
- Use **Hardkernel 200 mm SATA data+power** harnesses for tidy runs in a 10″ rack. citeturn17search4
- Feed **19 V DC** from a brick to the DC jack (center‑positive); avoid ATX.
- Install TrueNAS SCALE to the NVMe; create pool and datasets.
- Set **autotrim** for SSD pools; enable **SMART** for SATA.
- Tune **fan curves** to keep the 92 mm at low duty; set 60 mm shelf fans to <1.5k RPM.
- Validate NICs at **2.5 GbE**; (10 GbE optional via SFP+ elsewhere).

**BOM:** See [07-BOMs-and-Links.md](07-BOMs-and-Links.md#architecture-b-embeddedsoC-odroid-h4ultra).

