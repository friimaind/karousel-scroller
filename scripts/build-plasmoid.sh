#!/usr/bin/env bash
# Builds the installable .plasmoid package into dist/.
# The archive must contain metadata.json at its root, as required by the KDE Store.
set -euo pipefail

readonly PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly PACKAGE_NAME="karousel-scroller"
readonly OUTPUT_DIR="${PROJECT_ROOT}/dist"

read_package_version() {
    python3 -c 'import json, sys; print(json.load(open(sys.argv[1]))["KPlugin"]["Version"])' \
        "${PROJECT_ROOT}/metadata.json"
}

build_package() {
    local version="$1"
    local output_file="${OUTPUT_DIR}/${PACKAGE_NAME}-${version}.plasmoid"

    mkdir -p "${OUTPUT_DIR}"
    rm -f "${output_file}"
    (cd "${PROJECT_ROOT}" && zip -qr "${output_file}" metadata.json contents)

    echo "${output_file}"
}

main() {
    build_package "$(read_package_version)"
}

main "$@"
