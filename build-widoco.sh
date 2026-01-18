#!/usr/bin/env bash
set -euo pipefail

WIDOCO_JAR="tools/widoco.jar"
REPO="ai-audit"   # your GitHub repo name (used for Pages base path)

build_module () {
  local module="$1"
  local ont="ontologies/${module}/ai-audit-${module}.ttl"
  local conf="widoco/${module}/widoco.conf"
  local out="docs/${module}"
  local base="/${REPO}/${module}/"

  rm -rf "${out}"
  mkdir -p "${out}"

  java -jar "${WIDOCO_JAR}" \
    -ontFile "${ont}" \
    -outFolder "${out}" \
    -confFile "${conf}" \
    -webVowl \
    -rewriteAll \
    -rewriteBase "${base}"
}

build_module workflow
build_module question
build_module infrastructure

echo "WIDOCO docs generated into docs/{workflow,question,infrastructure}"
