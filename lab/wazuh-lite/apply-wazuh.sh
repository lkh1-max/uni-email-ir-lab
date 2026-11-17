#!/usr/bin/env bash
# Nạp decoder/rule tùy biến + cấu hình đọc log Keycloak/mail + CDB list vào Wazuh manager.
set -euo pipefail
cd "$(dirname "$0")"
C=wazuh
docker cp custom/keycloak_decoders.xml $C:/var/ossec/etc/decoders/keycloak_decoders.xml
docker cp custom/uni_email_rules.xml   $C:/var/ossec/etc/rules/uni_email_rules.xml
docker cp custom/campus-ips            $C:/var/ossec/etc/lists/campus-ips
docker exec $C bash -c '
set -e
chown wazuh:wazuh /var/ossec/etc/decoders/keycloak_decoders.xml /var/ossec/etc/rules/uni_email_rules.xml /var/ossec/etc/lists/campus-ips
chmod 660 /var/ossec/etc/decoders/keycloak_decoders.xml /var/ossec/etc/rules/uni_email_rules.xml /var/ossec/etc/lists/campus-ips
if ! grep -q "/var/log/lab/keycloak/keycloak.log" /var/ossec/etc/ossec.conf; then
  sed -i "s#</ossec_config>#  <localfile>\n    <log_format>syslog</log_format>\n    <location>/var/log/lab/keycloak/keycloak.log</location>\n  </localfile>\n  <localfile>\n    <log_format>syslog</log_format>\n    <location>/var/log/lab/mail/mail.log</location>\n  </localfile>\n</ossec_config>#" /var/ossec/etc/ossec.conf
fi
if ! grep -q "etc/lists/campus-ips" /var/ossec/etc/ossec.conf; then
  sed -i "s#</ruleset>#  <list>etc/lists/campus-ips</list>\n  </ruleset>#" /var/ossec/etc/ossec.conf
fi
/var/ossec/bin/wazuh-makelists 2>&1 || true
'
docker exec $C /var/ossec/bin/wazuh-control restart >/dev/null 2>&1 || docker restart $C
echo "Applied. Cho ~25s cho manager khoi dong lai."
