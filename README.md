# Project: Incident response to university email account takeover

A simulation lab and incident response (IR) process for **takeover / misuse of email accounts**
at a university. Everything runs **in an isolated lab; all data and accounts are fake**.

Mapped to NIST SP 800-61r3 (Detect / Respond / Recover):
- **Policy & access control** (IAM, passwords, MFA, account lifecycle)
- **Incident response process** (intake → containment → investigation → recovery → closure)
- **Lab & drills** (building the systems, simulated attacks, collecting logs/evidence)
- **Forms, metrics & reporting** (T0–T6, MTTD/MTTA/MTTC/MTTR, v0 vs v1)

## Structure

```
lab/
  README.md     network diagram, build order, single-host limitations
  certs/        internal CA (make-ca.sh)
  dns/          *.lab resolution + MX/SPF/DKIM/DMARC
  keycloak/     Keycloak 26.8.1 + PostgreSQL + realm build scripts (IdP)
  gophish/      GoPhish (attacker side) — compose; binary downloaded separately
  attacker/     attacker MTA (evil.lab / uni-lab.support)
  mailcow/      log-shipping override (mailcow is installed with its own installer)
  wazuh/        log collection config + decoders/rules (SIEM)
  baseline/     generates normal background logins
```

## Security notes
- `.env`, private keys (`*.key`), certificates, `*.db`, logs and `users.csv` are **not** committed (see `.gitignore`).
- Passwords in `*.example` files are placeholders only — change all of them for a real deployment.
- The GoPhish build (`lab/gophish-win/`) is a release downloaded from GitHub and is not in the repo.

## Deployment status
Keycloak (realm `uni`, v0 configuration) is built on the lab VM; GoPhish is set up on the attacker machine.
See `lab/README.md` for details and the remaining steps (mailcow, Wazuh, v1 configuration).
