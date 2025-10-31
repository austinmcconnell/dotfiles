# Executive Summary
**Date:** 2025-10-31
**Last updated:** 2025-10-31

**Goal.** Build a *learning-focused* TrueNAS box for a **10″ mini rack** (DeskPi T1 depth 200 mm; T1 Plus depth 260 mm), prioritizing **low noise and low heat** over raw performance. The rack and accessory dimensions are documented by DeskPi/GeeekPi. citeturn22search2turn22search5turn22search6

**Recommendation.** Pick **Architecture B (Embedded SBC with native SATA + NVMe boot)** using an **ODROID‑H4+ or H4 Ultra**: you get **dual 2.5 GbE**, **4× SATA** on board (on H4+ / Ultra), **Gen3 x4 M.2 NVMe for boot**, and **19 V DC‑in**. Put it on a quiet 2U shelf or use Hardkernel’s case (≈3U) if you want drive mounting with minimal metal work. It keeps wiring simple, stays cool at low RPMs, and meets 2.5 GbE with room to grow. citeturn17search0turn17search1turn17search6

**Two solid alternatives.**
- **A. Mini‑ITX DC‑in board + front 2.5″ SSD cage (SATA‑first).** Use a 19 V DC‑in Mini‑ITX (e.g., Intel N100 class) with 2× SATA onboard **plus an M.2→5‑port SATA (JMB585)** to reach 4–6 SSDs while keeping the PCIe slot free for a **2.5 GbE NIC**. Very quiet with 40 mm/60 mm low‑RPM fans. citeturn11search3turn12open0turn15search2turn14search0
- **C. Mini‑PC (MS‑01) with dual 2.5 GbE + multiple M.2 (all‑NVMe).** Fits as a 2U device; start with 2–3 NVMe SSDs, add a PCIe dual‑M.2 card later. Excellent networking (2×2.5 GbE + 2×10 GbE SFP+), but *watch NVMe thermals in 2U*. citeturn21search0turn21search8

**Why SATA SSDs (2.5″) first?** They run cooler and are easier to cool quietly than dense NVMe arrays in short 10″ racks. NVMe drives throttle in minimal airflow unless heat‑sinked/ducted. For learning TrueNAS/ZFS, SATA SSD mirrors/RAIDZ are ideal and quiet. (Thermal throttling behavior and the need for airflow are well‑documented.) citeturn13search2turn13search7

**ZFS at a glance.**
- Start small: 2–4 drives as **mirrors** or **RAIDZ1**; expand to **6 drives** as **three mirrors** or **RAIDZ2**.
- **Boot**: small NVMe (or SATA SSD); avoid USB sticks (numerous failures reported in community and docs). **Min 8 GB RAM** for SCALE; ARC defaults to ~50% RAM and is tunable. citeturn23search7turn23search8turn23search0turn23search9

**Noise & thermals.** Use **Noctua 40×20 mm (NF‑A4x20 PWM)** in 1U or **60×25 mm (NF‑A6x25 PWM)** in 2U, targeting sub‑20 dB(A) at idle. citeturn24search0turn24search1

**Power.** Favor a **19 V DC brick** to board (5.5×2.5 mm typical) and onboard SATA power headers / splitters for multiple SSDs. Optional: **PoE++ (802.3bt) 90 W splitter** to 12 V plus a **12→19 V step‑up** for boards that require 19 V. Mind the splitter’s current caps. citeturn10search4turn10search8turn25search2

**Rack integration.** Use DeskPi 10″ **1U shelves** and Geerling’s community **3D‑print brackets** to mount 2.5″ cages cleanly without drilling. citeturn22search3turn7search0

**Bottom line.** If you want the simplest, quietest path with 2.5 GbE and 4–6 SATA SSDs: **ODROID‑H4+/Ultra** in 2–3U total. If you want maximum tinkering and parts flexibility: **Mini‑ITX + JMB585**. NVMe‑only is doable (MS‑01) but needs thermal attention in 2U.
