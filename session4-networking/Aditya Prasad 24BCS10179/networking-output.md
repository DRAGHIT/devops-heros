# Session 4 - Executed networking commands

Student: Aditya Prasad
Roll Number: 24BCS10179

## ping -c 2 -W 2 google.com

ICMP tests reachability; failure alone does not prove the website is down.

Exit code: 0

```text
PING google.com (173.194.43.113) 56(84) bytes of data.
64 bytes from yudlsqd-in-f113.1e100.net (173.194.43.113): icmp_seq=1 ttl=113 time=0.739 ms
64 bytes from yudlsqd-in-f113.1e100.net (173.194.43.113): icmp_seq=2 ttl=113 time=0.526 ms

--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.526/0.632/0.739/0.106 ms
```

## traceroute -m 5 -w 1 google.com

Hop probes show the route; missing replies can be filtering rather than failure.

Exit code: 127

```text
/bin/sh: 1: traceroute: Permission denied
```

## netstat -tuln

Lists local listening sockets; local listeners do not establish remote web access.

Exit code: 0

```text
[Local host inventory omitted from public submission.]
```

## timeout 6 telnet google.com 80

Tests a TCP port, not application correctness.

Exit code: 126

```text
timeout: failed to run command ‘telnet’: Permission denied
```

## tcpdump --version

Packet capture requires the tool and suitable privileges; no packet capture is claimed.

Exit code: 127

```text
/bin/sh: 1: tcpdump: Permission denied
```

## nslookup google.com

DNS resolves names to addresses; DNS success is separate from HTTP success.

Exit code: 0

```text
Server:		8.8.8.8
Address:	8.8.8.8#53

Non-authoritative answer:
Name:	google.com
Address: 173.194.43.139
Name:	google.com
Address: 173.194.43.100
Name:	google.com
Address: 173.194.43.113
Name:	google.com
Address: 173.194.43.102
Name:	google.com
Address: 173.194.43.101
Name:	google.com
Address: 173.194.43.138
Name:	google.com
Address: 2607:f8b0:400e:c1e::8a
Name:	google.com
Address: 2607:f8b0:400e:c1e::66
Name:	google.com
Address: 2607:f8b0:400e:c1e::71
Name:	google.com
Address: 2607:f8b0:400e:c1e::64
```

## dig google.com +short

Returns DNS records without dumping the local resolver configuration.

Exit code: 0

```text
173.194.43.101
173.194.43.139
173.194.43.138
173.194.43.102
173.194.43.113
173.194.43.100
```

## curl -I --max-time 12 https://www.google.com

HTTP response headers test HTTPS reachability.

Exit code: 0

```text
HTTP/2 200 
content-type: text/html; charset=ISO-8859-1
content-security-policy-report-only: object-src 'none';base-uri 'self';script-src 'nonce-Jb2wzw3thN5oqNn0pPHmFg' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https: http:;report-uri https://csp.withgoogle.com/csp/gws/other-hp
accept-ch: Sec-CH-Prefers-Color-Scheme
p3p: CP="This is not a P3P policy! See g.co/p3phelp for more info."
date: Wed, 07 Oct 2026 11:43:10 GMT
server: gws
x-xss-protection: 0
x-frame-options: SAMEORIGIN
expires: Wed, 07 Oct 2026 11:43:10 GMT
cache-control: private
set-cookie: __Secure-STRP=ABNhA6hJ24dZypyPLsO0YXzeIH6OvmDQeZ4gsdHlKFSwzNJlxqgA3ENZBRLCa0nnYbDFbon_MKd-1YTIYX0RMjYvGJEJPVnSHw; expires=Wed, 07-Oct-2026 11:48:10 GMT; path=/; domain=.google.com; Secure; SameSite=strict
set-cookie: AEC=Aaa9EJpIUaKLhzx1KhMVEiO5ycixc646oQdRoWXFxzqU51JLRKqWjoUZYg; expires=Mon, 05-Apr-2027 11:43:10 GMT; path=/; domain=.google.com; Secure; HttpOnly; SameSite=lax
set-cookie: NID=CvABCAESogEBOxGDSIx17cl_wtYVg8L4SjIzfiGozaJSJ5AcBGeqsL7yH_acrJbbuKRa0wY-bAJuieWkKClgsTeh7LqtX9xW9HlNjJeExP8hWs4suMh6yOrOLC8KaHr5ARC65rkbZ-bCvbOl658pDowoy5s9DZ4ZOlDj2jvGB4Kd8Fz2wozDYgVfCWn9L0LiQdJpqjABDBlcwKoAPBTIyFllxjKiMzssRfUoATJFAdKsB88pZDD6kWhuc9tgMbrH2rC5Xm4bz7r9vXuMU7j9O6FsiVKhvU1xm6dnO0C11YjWLtJ6FpH83ShTswIlfcHVW38J; expires=Thu, 08-Apr-2027 11:43:10 GMT; path=/; domain=.google.com; HttpOnly

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
```

## arp -a

ARP maps local next-hop addresses, not remote internet servers directly.

Exit code: 0

```text
[Local host inventory omitted from public submission.]
```

## systemctl is-active NetworkManager

Checks this service only; inactive/missing does not imply all networking is unavailable.

Exit code: 3

```text
inactive
```

