# Session 4 - Networking Fundamentals

Student: Aditya Prasad  
Roll Number: 24BCS10179

## Tasks and implementation

The Google Doc asks to practice commands and repositories shared in the teacher repo, create an empty Markdown file, execute networking commands, add outputs and explain what each command shows. `networking-output.md` was created empty, then populated from actual command executions and explanations.

Read the teacher's Network-Troubleshooting and Networking repositories. Practiced the ten troubleshooting tools named in the former using bounded probes; results, nonzero exits and unavailable commands are preserved in [networking-output.md](networking-output.md). Local socket/ARP inventories are explicitly omitted to avoid publishing host details.

## What I learned

Troubleshooting should separate layers: inspect local interface/route configuration; resolve DNS; test reachability and TCP; then check HTTPS. A successful DNS query cannot prove web access. ICMP or traceroute failure may be filtering. ARP resolves a local link neighbor, generally the gateway for an internet destination, not a remote Google server's MAC address. DHCP's Discover, Offer, Request and Acknowledge assign configuration; switches forward Ethernet frames and routers forward IP packets between networks.

## Verification and limits

The output file contains the executed result for each command, including exit status. Missing traceroute/telnet/tcpdump or failed probes are not replaced with invented expected output. No privileged packet capture, interface changes or network-service restart was performed. Remaining hands-on packet capture should be done on a disposable lab machine with permission, using the teacher's `sudo tcpdump -i eth0 host google.com` example adapted to its actual interface. This session is partially verified rather than complete.

## Sources

- [Assignment document](https://docs.google.com/document/d/1cjXFYf2Thm8cBEN-0C48B-v02cj3jGLd47lcO18prHE/edit?tab=t.0)
- [Network troubleshooting commands](https://github.com/Nency-Ravaliya/Network-Troubleshooting/blob/main/README.md)
- [Networking and DHCP explanation](https://github.com/Nency-Ravaliya/Networking/blob/main/README.md)
- [PR 312 placement reference](https://github.com/Nency-Ravaliya/devops-heros/pull/312), not copied.
