# Operations Plan
**Date:** 2025-10-31
**Last updated:** 2025-10-31

## Initial TrueNAS Setup (SCALE)
- **Install** to a **small NVMe** (or SATA SSD), **not to USB** (USB boot is widely discouraged and failure‑prone). Minimum **8 GB RAM**. citeturn23search7turn23search8
- **Create pool**: start with mirrors (2–4 drives) or RAIDZ1 (3–4 SSDs). For 6 drives, use 3× mirrors or RAIDZ2.
- **Datasets:** enable **zstd compression**, set **atime=off** unless needed, and **autotrim=on** for SSD pools (SCALE default compatible). citeturn23search1
- **ARC**: SCALE defaults ARC target ≈50% of RAM; adjust with tunables if needed after baseline testing. citeturn23search9
- **L2ARC/SLOG:** Avoid at first; add later only for specific read‑heavy/low‑latency needs (and with enough RAM). citeturn23search11

## Replication target from Synology
- On Synology: enable **rsync** or **ZFS‑aware replication** if using Synology with Btrfs; otherwise use **rsync + snapshots** at TrueNAS.
- On TrueNAS: create a **Periodic Snapshot Task** (e.g., hourly, keep 1–3 days) and an **rsync module** or **pull task** from Synology.

## iSCSI target for Proxmox
- Create a **zvol** (thick) on SSD pool for iSCSI.
- Enable **iSCSI service**; create **Portal** (bind to 2.5 GbE), **Initiators**, and **Target/Extents**; add multipath later if you add a second NIC.

## Health / Maintenance
- **SMART short** daily, **long** monthly; **scrub** every 2–4 weeks (SSD pools scrub quickly).
- **Email/Discord alerts** on SMART failures, pool degradation, and high temps.
- **Back up** `/data/freenas-v1.db` (config) after changes.

## When to consider 2U vs 1U
- If fans need >40 mm at low RPMs or you pack >4 SSDs up front, use **2U** for cooler/quieter airflow.
- NVMe‑heavy builds benefit from **2U** to avoid throttling without loud fans. citeturn13search2
