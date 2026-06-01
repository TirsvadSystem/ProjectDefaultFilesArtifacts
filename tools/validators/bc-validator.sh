#!/usr/bin/env bash
# =============================================================================
# bc-validator.sh — Validates a Business Case (BC) artifact against QC-BC
# Usage: ./tools/validators/bc-validator.sh [path-to-bc-file]
# Default file: docs/specs/bc/business-case.md
# Exit codes: 0 = pass, 1 = fail
# =============================================================================

set -euo pipefail

FILE="${1:-docs/specs/bc/business-case.md}"
PASS=0
FAIL=0
ERRORS=()

# Colour codes (disabled when not a terminal)
if [ -t 1 ]; then
  RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'; BOLD='\033[1m'
else
  RED=''; GREEN=''; YELLOW=''; NC=''; BOLD=''
fi

pass() { echo -e "  ${GREEN}checkmark${NC} $1"; ((PASS++)); }
fail() { echo -e "  ${RED}X${NC} $1"; ERRORS+=("$1"); ((FAIL++)); }
warn() { echo -e "  ${YELLOW}!${NC} $1"; }
header() { echo -e "\n${BOLD}$1${NC}"; }

# =============================================================================
echo -e "${BOLD}BC Validator -- ${FILE}${NC}"
echo "============================================================"

# --- File existence -----------------------------------------------------------
header "File"
if [ ! -f "$FILE" ]; then
  fail "File not found: $FILE"
  echo -e "\n${RED}RESULT: FAIL${NC} -- File does not exist."
  exit 1
fi
pass "File exists: $FILE"

# --- YAML frontmatter --------------------------------------------------------
header "YAML Frontmatter"

check_yaml() {
  local key="$1" pattern="$2" label="$3"
  if grep -qE "^${key}:[[:space:]]*${pattern}" "$FILE"; then
    pass "$label"
  else
    fail "$label"
  fi
}

check_yaml "id"            "BC"              'id: BC'
check_yaml "artifact_type" "BC"              'artifact_type: BC'
check_yaml "version"       '"[0-9]{3}"'      'version is 3-digit zero-padded string'

# inputs: must have at least one non-empty entry
if awk '/^inputs:/,/^[a-z]/' "$FILE" | grep -qE '^\s+-\s+".+"'; then
  pass "inputs array has >= 1 entry"
else
  fail "inputs array is empty or missing"
fi

# metadata.domain
if grep -qE 'domain:[[:space:]]+"[^{]+"' "$FILE"; then
  pass "metadata.domain is set"
else
  warn "metadata.domain is not set (template placeholder may still be present)"
fi

# traceability block
if grep -qE 'traceability:' "$FILE"; then
  pass "metadata.traceability block is present"
else
  fail "metadata.traceability block is missing"
fi

# --- Required sections (## headings) -----------------------------------------
header "Required Sections"

required_sections=(
  "Executive Summary"
  "Problem Statement"
  "Objectives"
  "Options & Alternatives"
  "Cost-Benefit Analysis"
  "Risks & Assumptions"
  "Timeline"
  "Success Criteria"
  "Recommendation"
)

for section in "${required_sections[@]}"; do
  if grep -qE "^## ${section}" "$FILE"; then
    pass "Section present: ## ${section}"
  else
    fail "Section missing:  ## ${section}"
  fi
done

# --- Scenario model -----------------------------------------------------------
header "Scenario Model (0 / 1 / 2)"

for scenario in "Scenario 0" "Scenario 1" "Scenario 2"; do
  if grep -qE "^### ${scenario}" "$FILE"; then
    pass "Present: ### ${scenario}"
  else
    fail "Missing: ### ${scenario}"
  fi
done

# --- JSON Snapshot ------------------------------------------------------------
header "JSON Snapshot"

if grep -qE "^## JSON Snapshot" "$FILE"; then
  pass "## JSON Snapshot section present"
else
  fail "## JSON Snapshot section missing"
fi

if grep -qE '"id":[[:space:]]*"BC"' "$FILE"; then
  pass 'JSON Snapshot id is "BC"'
else
  fail 'JSON Snapshot id is not "BC" or is missing'
fi

if grep -qE '"artifact_type":[[:space:]]*"BC"' "$FILE"; then
  pass 'JSON Snapshot artifact_type is "BC"'
else
  fail 'JSON Snapshot artifact_type is not "BC" or is missing'
fi

# --- Content completeness checks ---------------------------------------------
header "Content Completeness"

# Objectives -- check for at least one table row beyond the header
obj_rows=$(awk '/^## Objectives/,/^## /' "$FILE" | grep -cE '^\|[[:space:]]*[0-9]' || true)
if [ "$obj_rows" -ge 1 ]; then
  pass "Objectives table has >= 1 row"
else
  warn "Objectives table appears empty (found ${obj_rows} data rows)"
fi

# Risks -- check for at least one risk row
risk_rows=$(awk '/^## Risks/,/^## /' "$FILE" | grep -cE '^\|[[:space:]]*R-[0-9]' || true)
if [ "$risk_rows" -ge 1 ]; then
  pass "Risk table has >= 1 risk entry (R-NNN)"
else
  warn "Risk table appears empty -- add at least one risk with ID R-NNN"
fi

# Success criteria -- check for at least one row
sc_rows=$(awk '/^## Success Criteria/,/^## /' "$FILE" | grep -cE '^\|[[:space:]]*[0-9]' || true)
if [ "$sc_rows" -ge 1 ]; then
  pass "Success Criteria table has >= 1 row"
else
  warn "Success Criteria table appears empty"
fi

# Recommendation names a scenario
if grep -A5 "^## Recommendation" "$FILE" | grep -qiE 'scenario [0-9]|scenario[0-9]'; then
  pass "Recommendation references a specific scenario"
else
  warn "Recommendation does not clearly name a scenario (Scenario 0/1/2)"
fi

# =============================================================================
header "Summary"
echo "  Passed : $PASS"
echo "  Failed : $FAIL"

if [ ${#ERRORS[@]} -gt 0 ]; then
  echo ""
  echo -e "${RED}Failures:${NC}"
  for err in "${ERRORS[@]}"; do
    echo "  - $err"
  done
fi

echo ""
if [ $FAIL -eq 0 ]; then
  echo -e "${GREEN}${BOLD}RESULT: PASS${NC} -- Business Case meets all validation rules."
  exit 0
else
  echo -e "${RED}${BOLD}RESULT: FAIL${NC} -- $FAIL check(s) failed. Fix the issues above and re-run."
  exit 1
fi
