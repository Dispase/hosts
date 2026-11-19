#!/bin/bash

HOSTS="$HOME/etc/hosts"

verify-IP() {
  name="$1"
  expected_ip="$2"

  actual_ips=$(nslookup -type=A "$name" 2>/dev/null |
    awk '/^Name:/ { answer=1; next }
             answer && /^Address:/ { print $2 }')

  if [ -z "$actual_ips" ]; then
    return 2
  fi

  for ip in $actual_ips; do
    if [ "$ip" = "$expected_ip" ]; then
      return 0
    fi
  done

  echo "Bogus IP for $name in $HOME/etc/hosts!"
  return 1
}

while read -r ip name; do
  [[ -z "$ip" || "$ip" == \#* ]] && continue

  verify-IP "$name" "$ip"

done <"$HOSTS"
