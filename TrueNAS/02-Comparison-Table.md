# Options Comparison
**Date:** 2025-10-31
**Last updated:** 2025-10-31

| Option | Rack Height | Drives Supported | Network | Boot Device | Est. Idle/Load (W) | Approx. Cost (USD) | Noise | Expandability | Notes |
|---|---|---:|---|---|---:|---:|---|---|---|
| **A. Mini‑ITX + front SATA cage** | 2U total (1U board + 1U cage) | 2–6× 2.5″ SATA (JMB585) | 2.5 GbE via PCIe NIC | NVMe M.2 or SATA SSD | ~12 / 30–40 | ~$450–$700 (board, NIC, JMB585, cage, fans) | Very quiet with low‑RPM 40/60 mm | SATA to 6 via JMB585; PCIe slot free for NIC | ASRock N100DC‑ITX (19 V, SATA_PWR header), M.2→5×SATA (JMB585), TX201 NIC. citeturn11search3turn12open0turn15search2turn14search0 |
| **B. Embedded/SoC (ODROID‑H4+/Ultra)** | 2U (board shelf) or 3U (Type‑3 case) | 4× 2.5″ SATA native (H4+/Ultra) | 2× 2.5 GbE native | NVMe M.2 (Gen3 x4) | ~15 / 35–45 | ~$500–$750 (board, RAM, case/shelf, fans) | Very quiet w/ 60 mm @ <2k RPM | Native 4× SATA; M.2 free | Dual 2.5 GbE, 4× SATA on H4+/Ultra, 19 V DC‑in; Hardkernel case fits 4× 2.5″. citeturn17search0turn17search4 |
| **C. Mini‑PC (MS‑01) all‑NVMe** | 2U (device height ≈48 mm) | 2–3× NVMe (onboard), +2 via PCIe card | 2×2.5 GbE + 2×10 GbE SFP+ | NVMe M.2 | ~18 / 45–65 | ~$900–$1,300 (barebone + NVMe + fans) | Quiet at idle; NVMe hotspots under load | PCIe slot for dual‑M.2 card | MS‑01: 3× M.2 w/ mixed lanes; PCIe slot works with dual‑M.2; watch NVMe thermals. citeturn21search0turn21search8

**Notes on estimates.** Idle/load based on vendor specs/community measurements for low‑power N100/N305‑class systems and 2–4 SATA SSDs (~0.8–1.5 W/drive idle, ~2–3 W/drive active). Noise assumes Noctua PWM fans limited to ~1–2k RPM. Fan specs: NF‑A4x20 (max 14.9 dB(A)), NF‑A6x25 (max 19.3 dB(A)). citeturn24search0turn24search1
