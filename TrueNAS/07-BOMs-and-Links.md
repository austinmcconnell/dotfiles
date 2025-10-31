# BOMs and Links
**Date:** 2025-10-31
**Last updated:** 2025-10-31

Prices change quickly; all links are **US‑sourced** where possible with current stock notes.

## Architecture A — Mini‑ITX + front 2.5″ SSD cage
- **Mini‑ITX board (DC‑in, low‑TDP, SATA power header):** ASRock **N100DC‑ITX** — product page (specs). *US street price typically* **$160–$200**, stock varies (check local/online). citeturn11search3  
- **M.2→5× SATA (JMB585):** IO‑CREST / SI‑ADA40141, **$49–$69**, **in stock** at Newegg/Amazon. citeturn15search2turn15search10  
- **2.5 GbE NIC (low‑profile x1):** TP‑Link **TX201** (RTL8125), **$20–$30**, Amazon **in stock / varies**. citeturn14search0  
- **Front 2.5″ SSD cage (5.25″ bay form‑factor)**: ICY DOCK **MB996SP‑6SB** (6×2.5″ into 1×5.25″), **$129–$169**, Amazon **in stock**; alternative 4‑bay cages available. citeturn9search0turn9search1  
- **DeskPi 10″ 1U shelf (T0/T1):** **$19.99–$26.99**, **in stock** at DeskPi Store. citeturn22search3  
- **Fans (1U quiet):** Noctua **NF‑A4x20 PWM** (40×20 mm), **$14–$18** each, Amazon **in stock**. citeturn24search2  
- **SATA power splitters:** Cable Matters 1→4 (2‑pack), **$11.79**, Amazon **in stock**. citeturn16search4  
- **19 V brick (5.5×2.5 mm):** 90 W class laptop‑style adapter, **$18–$30**, Amazon **in stock**. citeturn10search4  
- **Optional PoE++ path:** LINOVISION **802.3bt 90 W** PoE++ splitter (12 V 5/6/7.5 A), **$79–$109**, **in stock**, *plus* **12→19 V 5 A step‑up** (**$18–$25**). Mind total current. citeturn10search8turn25search2  

*Example subtotal (board + JMB585 + NIC + cage + shelf + 2×fans + brick):* **~$420–$520** before SSDs.

## Architecture B — Embedded/SoC (ODROID‑H4+/Ultra)
- **Board:** **ODROID‑H4+ / H4 Ultra** (dual 2.5 GbE; 4× SATA on H4+/Ultra; M.2 Gen3×4), ameriDroid — **stock varies; typical** **$199–$289** range. citeturn17search0  
- **Case (optional, neat 3U build):** **ODROID‑H4 Case Type‑3**, **$17** (+ fan + short SATA/power kits), **in stock**. citeturn17search4  
- **DDR5 SODIMM:** 16–32 GB, typical **$35–$80**.  
- **NVMe boot:** 256–512 GB, **$25–$60** (e.g., Crucial P3 Plus 2 TB was ~$74 sale; prices vary). citeturn19search1  
- **Fans (2U shelf):** Noctua **NF‑A6x25 PWM** (60×25 mm), **$16–$20** each. citeturn24search3  
- **19 V brick:** 90 W class, **$18–$30**. citeturn10search4  
- **Short SATA/power harnesses:** 200 mm kits (for tidy 10″ rack runs), add as needed. citeturn17search4  

*Example subtotal (H4+, case+fan, 2×fans for shelf, 19 V brick, NVMe 256 GB):* **~$350–$420** before SSDs & RAM.

## Architecture C — Mini‑PC (MS‑01) all‑NVMe
- **Mini‑PC:** **Minisforum MS‑01** (2×10 GbE + 2×2.5 GbE; 3× M.2; PCIe slot). Amazon **barebone** has been **~$849**; stock/CPU variations exist. citeturn20view0  
- **NVMe SSDs:** e.g., Crucial **P3 Plus 2 TB** often **$74–$90**; WD **SN770 2 TB** around **$100–$140**, stock varies. citeturn19search1turn19news25  
- **Dual‑M.2 PCIe card:** validated use in MS‑01 testing; choose passive‑cooled card and add heatsinks/air. citeturn21search8  
- **DeskPi mini‑PC 1U/2U shelf:** **$26.99**, **in stock**. citeturn22search7  
- **Shelf fan:** Noctua **NF‑A6x25 PWM**, **$16–$20**. citeturn24search3  

*Example subtotal (MS‑01 barebone + 2×2 TB NVMe + shelf + fan):* **~$1,000–$1,200**.

## SSD Choices (2.5″ SATA) — quiet & low heat
- **Crucial MX500 1 TB** — Amazon, typical **$55–$75**; reliable, low idle draw. citeturn18search0  
- **Samsung 870 EVO 2 TB** — Amazon, often **$140–$190**. citeturn18search4  
- **Inland Platinum 2 TB** — Micro Center **in store**, typical **$110–$130**. citeturn18search2turn18search8  

## Racks / Fit
- **DeskPi T1 (200 mm depth)** and **T1 Plus (260 mm depth)**; 10″ accessories (1U shelves, blank panels). citeturn22search2turn22search6turn22search4  
- Geerling’s 10″ mini‑rack repo for **3D‑printed brackets**, cages, and community notes. citeturn7search0

**Availability notes.** Amazon items fluctuate between “in stock” and “temporarily unavailable”; ameriDroid lists H4 series with regular US shipping. Where a specific SKU is OOS, the link still anchors the exact spec, with a domestic alternative indicated in each section above.
