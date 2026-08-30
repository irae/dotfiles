# Hardware issues log

## RTX 3070 — "GPU has fallen off the bus" (Xid 79)

### Incidents

1. **Earlier, while gaming.** Screen went black, no GPU fan spin-up/noise.
   Turning the monitor off and back on brought the desktop back. Cause
   unconfirmed — never diagnosed at the time.
2. **2026-08-28, ~19:58, during sustained local-LLM (llama.cpp/CUDA) load.**
   Fan spun to max and got loud, screen went black, desktop did not
   recover. SSH still worked. Tried live recovery:
   `sudo rmmod nvidia_uvm nvidia_drm nvidia_modeset nvidia && sudo modprobe nvidia nvidia_modeset nvidia_uvm`
   — failed: `rmmod: ERROR: Module nvidia_uvm is in use` (Hyprland/the
   desktop session was still holding the modules, so they couldn't be
   unloaded live). Had to `sudo reboot`; driver reloaded cleanly at next
   boot and the GPU has been healthy since.

### Confirmed root cause (kernel log, `journalctl -k -b -1`)

```
NVRM: GPU at PCI:0000:01:00: GPU-6861a36a-dcba-bf17-4cd5-d395100bded5
NVRM: Xid (PCI:0000:01:00): 79, pid=11008, name=brave, GPU has fallen off the bus.
NVRM: GPU 0000:01:00.0: GPU has fallen off the bus.
NVRM: krcRcAndNotifyAllChannels_IMPL: RC all channels for critical error 79.
```

**Xid 79** = the GPU dropped off the PCIe bus entirely — a hardware/power-
level fault, not a clean CUDA out-of-memory error (we also hit a real OOM
during the same session, at a much later step, and it failed cleanly with
no ill effects — this is a different, more serious class of failure).
It hit mid prompt-eval, well under any VRAM ceiling, right after two full
depth-sweep passes had already completed successfully — consistent with a
power-transient trigger rather than a simple "used too much VRAM" bug.

### Hypotheses, ranked by evidence found online (2026-08-29 research)

1. **PSU age/quality vs. Ampere transient power spikes (most likely).**
   RTX 3070 is rated 220W but spikes momentarily to ~400-500W under load
   (documented by GamersNexus's GPU transient-power investigation). A PSU
   fine on average wattage can still brown out on these spikes if old or
   low quality.
   - **Confirmed real-world fix**: [Tom's Hardware thread](https://forums.tomshardware.com/threads/gigabyte-rtx-3070-keeps-restarting-my-computer-under-load.3785745/)
     — identical symptom (RTX 3070, random restarts under load) traced to
     an 18-year-old 850W PSU; replacing it with a Corsair RM850x fixed it
     completely ("played 2 days now on maxed out graphics... no hard
     crash/restarts").
2. **Loose/marginal PCIe power connector (also plausible, cheaper to check first).**
   - [NVIDIA dev forum, same error signature (Xid 79, RTX 3070)](https://forums.developer.nvidia.com/t/gpu-has-fallen-off-the-bus-xid-79-rtx-3070/309103):
     saw `IO_PAGE_FAULT` errors right before the disconnect; suggested
     gently touching the PCIe power cable while idle to find an
     intermittent connection.
   - [Arch Linux forum, same error](https://bbs.archlinux.org/viewtopic.php?id=304020):
     resolved after rewiring/reseating GPU power cables (tested with a
     multimeter) + cleaning the case/GPU fan — no crashes for several days
     after. Poster wasn't 100% sure which single change did it.
3. **Thermal paste — weak/no evidence.** Found no case where reapplying
   paste alone fixed a "fallen off the bus" Xid 79. This error is a
   bus/power fault, not a thermal-throttle event. Could matter indirectly
   if the card is throttling hard and drawing erratic power as a
   side-effect, but not a documented direct cause anywhere I found.
4. **Defective GPU (bad VRM/die) — fallback, least evidenced.** Nobody in
   what I found had solid proof beyond "I RMA'd it and it stopped" — hard
   to confirm from a forum post alone. Consider only after ruling out
   power/cabling.

### Suggested diagnostic before spending money

Run `gpu-burn` to stress the GPU to ~100% for 5-10 minutes. If the fault
reproduces reliably under pure compute load (not gaming-specific), that
points at the GPU/PSU/power path rather than a game- or workload-specific
driver bug.

### Notes for next time

- If the desktop dies like this again: SSH in, but a live
  `rmmod`/`modprobe` reload will almost certainly fail with
  "module in use" while Hyprland/the desktop session holds the GPU — a
  full reboot is the reliable recovery, not module reload.
- Before any further heavy sustained GPU/LLM load: physically check the
  PCIe power cable seating (the cheap check), and consider `nvidia-smi -q`
  for power-limit/throttle-reason fields as a read-only diagnostic.
- Both incidents happened under *sustained* load (long gaming session;
  long depth-sweep of LLM inference) rather than at load spikes alone,
  which is also consistent with a marginal PSU/connector under prolonged
  stress.
