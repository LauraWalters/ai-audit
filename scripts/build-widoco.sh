#!/usr/bin/env bash
set -euo pipefail

WIDOCO_JAR="tools/widoco.jar"
REPO="ai-audit"

build_module () {
  local module="$1"
  local ont="ontologies/ai-audit-${module}.ttl"
  local conf="widoco/${module}/widoco.conf"
  local out="docs/${module}"
  local base="/${REPO}/${module}/"

  rm -rf "${out}"
  mkdir -p "${out}"

java -jar "${WIDOCO_JAR}" \
  -ontFile "${ont}" \
  -outFolder "${out}" \
  -getOntologyMetadata \
  -includeAnnotationProperties \
  -webVowl \
  -rewriteAll \
  -rewriteBase "${base}"

  # Add index.html redirect for GitHub Pages
  if [[ -f "${out}/index-en.html" && ! -f "${out}/index.html" ]]; then
    cat > "${out}/index.html" <<'HTML'
<!doctype html>
<meta charset="utf-8">
<meta http-equiv="refresh" content="0; url=index-en.html">
<link rel="canonical" href="index-en.html">
<title>Redirecting…</title>
<p>Redirecting to <a href="index-en.html">index-en.html</a></p>
HTML
  fi
}

build_module workflow
build_module questions
build_module infrastructure

echo "WIDOCO docs generated into docs/{workflow,questions,infrastructure}"
