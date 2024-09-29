#!/bin/bash
USERHOME="${1:-${HOME}}"
KEY="$2"
SSHOWNER="$3"
SSHGROUP="$4"

if ! [ -d "${USERHOME}/.ssh" ]; then
    mkdir "${USERHOME}/.ssh"
    chmod 700 "${USERHOME}/.ssh"
    echo "${USERHOME}/.ssh directory created"
fi
if ! [ -f "${USERHOME}/.ssh/authorized_keys" ]; then
    touch "${USERHOME}/.ssh/authorized_keys"
    chmod 600 "${USERHOME}/.ssh/authorized_keys"
    echo "${USERHOME}/.ssh/authorized_keys file created"
fi
if [ -z "$(grep "$KEY" "${USERHOME}/.ssh/authorized_keys")" ]; then
    echo "$KEY" >> "${USERHOME}/.ssh/authorized_keys"
    echo key added
fi

chown -R "${SSHOWNER}:${SSHGROUP}" "${USERHOME}/.ssh"
