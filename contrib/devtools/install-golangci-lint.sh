#!/bin/bash

set -euo pipefail

installer="$(mktemp)"
trap "rm -f ${installer}" EXIT

GOBIN="${1}"
CURL="$(which curl)"
VERSION="${2}"
HASHSUM="${3}"

f_sha256() {
  local l_file
  l_file=$1
  python -sBc "import hashlib;print(hashlib.sha256(open('$l_file','rb').read()).hexdigest())"
}

echo "Downloading golangci-lint ${VERSION} installer ..." >&2
"${CURL}" -sfL "https://raw.githubusercontent.com/golangci/golangci-lint/${VERSION}/install.sh" > "${installer}"

echo "Checking hashsum ..." >&2
echo "${installer}"
[ "${HASHSUM}" = "$(f_sha256 ${installer})" ]
chmod +x "${installer}"

echo "Launching installer ..." >&2
exec "${installer}" -d -b "${GOBIN}" "${VERSION}"
