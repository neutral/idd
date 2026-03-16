#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF' >&2
Usage:
  scripts/verify-idd.sh
  scripts/verify-idd.sh --source-only
  scripts/verify-idd.sh --target <repo-root>
  scripts/verify-idd.sh --runtime-only --target <repo-root>

Validates the IDD source package in this repo and, when requested, validates
runtime IDD surfaces in a target repo.
EOF
}

source_only=0
runtime_only=0
target_root=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source-only)
      source_only=1
      shift
      ;;
    --runtime-only)
      runtime_only=1
      shift
      ;;
    --target)
      if [[ $# -lt 2 ]]; then
        echo "Usage error: --target requires a repo path." >&2
        usage
        exit 2
      fi
      target_root="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Usage error: unknown option: $1" >&2
      usage
      exit 2
      ;;
  esac
done

if [[ "$source_only" -eq 1 && "$runtime_only" -eq 1 ]]; then
  echo "Usage error: --source-only and --runtime-only cannot be combined." >&2
  usage
  exit 2
fi

if [[ "$runtime_only" -eq 1 && -z "$target_root" ]]; then
  echo "Usage error: --runtime-only requires --target <repo-root>." >&2
  usage
  exit 2
fi

if [[ "$source_only" -eq 1 && -n "$target_root" ]]; then
  echo "Usage error: --source-only cannot be combined with --target." >&2
  usage
  exit 2
fi

if [[ -n "$target_root" && ! -d "$target_root" ]]; then
  echo "Usage error: target repo does not exist: $target_root" >&2
  exit 2
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

if [[ "$source_only" -eq 1 ]]; then
  do_source=1
  do_runtime=0
  do_durable=0
elif [[ "$runtime_only" -eq 1 ]]; then
  do_source=0
  do_runtime=1
  do_durable=0
else
  do_source=1
  if [[ -n "$target_root" ]]; then
    do_runtime=1
    do_durable=1
  else
    do_runtime=0
    do_durable=0
  fi
fi

python3 - "$repo_root" "$do_source" "$do_runtime" "$do_durable" "$target_root" <<'PY'
from __future__ import annotations

import re
import sys
import os
from pathlib import Path
from typing import Any


REPO_ROOT = Path(sys.argv[1]).resolve()
DO_SOURCE = sys.argv[2] == "1"
DO_RUNTIME = sys.argv[3] == "1"
DO_DURABLE = sys.argv[4] == "1"
TARGET_ROOT = Path(sys.argv[5]).resolve() if sys.argv[5] else None

SECTION_RE = re.compile(r"^## (.+?)\s*$")
SUBSECTION_RE = re.compile(r"^### (.+?)\s*$")
FIELD_RE = re.compile(r"^- ([^:]+):(?:\s*(.*))?$")
PLAIN_FIELD_RE = re.compile(r"^([^:#][^:]*):(?:\s*(.*))?$")
NESTED_BULLET_RE = re.compile(r"^\s+- (.+?)\s*$")
INTENT_TARGET_ITEM_RE = re.compile(
    r"^(?:goal/[^#\s]+|assurance/[^#\s]+|feature/[^#\s]+#[a-z]+(?:-[a-z]+)*|scenario/[^#\s]+#[a-z]+(?:-[a-z]+)*|behavior/[^#\s]+#[a-z]+(?:-[a-z]+)*)$"
)
LOCAL_NAME_RE = re.compile(r"^[a-z]+(?:-[a-z]+)*$")
RUN_LEDGER_RE = re.compile(
    r"^- `?(?P<entry_id>L\d+)`? \| `?(?P<timestamp>[^`|]+)`? "
    r"\| Operation: `?(?P<operation>[^`|]+)`? "
    r"\| Status before: `?(?P<before>[^`|]+)`? "
    r"\| Status after: `?(?P<after>[^`|]+)`? "
    r"\| Inputs: (?P<inputs>[^|]+?) "
    r"\| Changes: (?P<changes>[^|]+?) "
    r"\| Checks: (?P<checks>[^|]+?) "
    r"\| Evidence: (?P<evidence>[^|]+?) "
    r"\| Next stage: `?(?P<route>[^`|]+?)`? "
    r"\| Outcome: (?P<outcome>.+?)\s*$"
)
REGISTER_RE = re.compile(
    r"^- `?(?P<step_id>[^`|]+)`? \| Title: `?(?P<title>[^`|]+)`? "
    r"\| Status: `?(?P<status>[^`|]+)`? \| Depends on: `?(?P<depends>[^`|]+)`? "
    r"\| Unlocks: `?(?P<unlocks>[^`|]+)`? \| Done when: `?(?P<done>[^`]+)`?\s*$"
)
REGISTER_BULLET_RE = re.compile(r"^\s+- (?P<field>[^:]+):(?:\s*(?P<value>.*))?$")
TRACE_ITEM_RE = re.compile(r"^`(?P<path>[^`]+)`(?:\s+.*)?$")
TIMESTAMP_RE = re.compile(r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$")
RUNTIME_ENTRY_RE = re.compile(
    r"^- Runtime entrypoint:\s+`?(?P<filename>[^`/]+\.md)`?\s*$",
    re.MULTILINE,
)
PASS_CATALOG_ITEM_RE = re.compile(
    r"^- `(?P<name>[a-z]+(?:-[a-z]+)*(?:/[a-z]+(?:-[a-z]+)*)+)`: .+\s*$"
)
REGISTER_CAPABILITY_RE = re.compile(
    r"^Context (?P<context>low|medium|high); "
    r"Novelty (?P<novelty>low|medium|high); "
    r"Proof (?P<proof>low|medium|high); "
    r"Edit breadth (?P<edit_breadth>low|medium|high); "
    r"Review burden (?P<review_burden>low|medium|high); "
    r"Rationale (?P<rationale>.+)$"
)
FRONTMATTER_DELIM_RE = re.compile(r"^---\s*$")
BULLET_RE = re.compile(r"^(?P<indent>\s*)- (?P<text>.+?)\s*$")
ARTIFACT_REF_RE = re.compile(r"^`(?P<id>[^`]+)`\s*\|\s*`(?P<path>[^`]+)`(?:\s+.*)?$")
URL_SURFACE_RE = re.compile(r"^`?(?:https?://|mailto:)[^`\s]+`?$")

STEP_SECTION_ORDER = [
    "Metadata",
    "Step Charter",
    "Constraint Envelope",
    "Capability Fit",
    "Planned Layer Delta",
    "References",
    "Proof Target",
    "Working Record",
    "Proof Packet",
    "Review Packet",
    "Outcome",
    "Run Ledger",
]
STEP_FIELDS = {
    "Metadata": ["Step ID", "Title", "Status", "Owner", "Created at", "Updated at"],
    "Step Charter": ["Goal", "Done when", "Depends on", "Unlocks"],
    "Constraint Envelope": [
        "Write scope",
        "Read-only scope",
        "Forbidden scope",
        "Authority limits",
        "External dependency posture",
        "Escalation triggers",
    ],
    "Capability Fit": [
        "Context load",
        "Novelty load",
        "Proof load",
        "Edit breadth",
        "Review burden",
        "Sizing rationale",
    ],
    "Planned Layer Delta": ["Intent", "Blueprint", "Code", "Descriptions", "Tests"],
    "References": ["Intent refs", "Blueprint refs", "Code refs", "Description refs", "Test refs", "Decision refs"],
    "Proof Target": [
        "Intent targets",
        "Required checks",
        "Required evidence",
        "Closure conditions",
        "Failure triggers",
    ],
    "Working Record": ["Evidence run", "Active evidence", "Current posture", "Execution notes", "Open questions"],
    "Proof Packet": [
        "Evidence refs",
        "Checks run",
        "Results",
        "Intent verdict",
        "Blueprint verdict",
        "Code verdict",
        "Residual gaps",
        "Conflict and authority handling",
    ],
    "Review Packet": [
        "Change summary",
        "Artifacts changed",
        "Reviewer focus",
        "Downstream assumptions",
        "Handoff summary",
    ],
    "Outcome": ["Decision", "Reason", "Next action", "Step summary"],
}
ARC_FIELDS = {
    "Metadata": ["Arc ID", "Branch", "Arc Status", "Updated at"],
    "Arc Objective": ["Request served", "Success condition"],
    "Completion Rule": [
        "Completion standard",
        "Required step proof coverage",
        "Failure posture",
    ],
    "Final Validation": [
        "Validation status",
        "Checks run",
        "Proof synthesis",
        "Outstanding gaps",
        "Follow-up action",
    ],
    "Closeout": ["Arc outcome", "Carry-forward obligations", "Reset and retention"],
}
REQUIRED_STATUS_SECTIONS = ["Sources", "Operating scope", "Permissions"]
REQUIRED_ARC_SECTIONS = [
    "Metadata",
    "Arc Objective",
    "Completion Rule",
    "Step Register",
    "Final Validation",
    "Closeout",
    "Notes",
]
REQUIRED_REGISTER_BULLETS = [
    "Goal",
    "Constraint envelope",
    "Planned layer delta",
    "Proof target",
    "Capability fit",
]
REQUIRED_SOURCE_FILES = [
    "methodology/IDD.md",
    "methodology/ARC.md",
    "methodology/ARTIFACTS.md",
    "methodology/LIBRARY.md",
    "methodology/LABELS.md",
    "methodology/arc/overview.md",
    "methodology/arc/stages/map-arc.md",
    "methodology/arc/stages/shape-step.md",
    "methodology/arc/stages/run-step.md",
    "methodology/arc/stages/prove-step.md",
    "methodology/arc/stages/close-step.md",
    "methodology/arc/stages/finalize-arc.md",
    "methodology/arc/artifacts/arc.md",
    "methodology/arc/artifacts/step.md",
    "methodology/arc/contracts/state-machine.md",
    "methodology/arc/contracts/loop.md",
    "methodology/arc/contracts/step-schema.md",
    "methodology/arc/contracts/layer-sync-invariants.md",
    "methodology/arc/contracts/conflict-resolution.md",
    "methodology/arc/templates/step.md",
    "methodology/arc/templates/proof-packet.md",
    "methodology/arc/templates/evidence/index.md",
    "methodology/arc/templates/evidence/EVIDENCE.md",
    "methodology/artifacts/overview.md",
    "methodology/artifacts/intent/goals.md",
    "methodology/artifacts/intent/feature.md",
    "methodology/artifacts/intent/scenario.md",
    "methodology/artifacts/intent/behavior.md",
    "methodology/artifacts/intent/assurances.md",
    "methodology/artifacts/intent/decision.md",
    "methodology/artifacts/blueprint/blueprint.md",
    "methodology/artifacts/blueprint/explainer.md",
    "methodology/artifacts/code/description.md",
    "methodology/structure/layout.md",
    "methodology/structure/traceability.md",
    "methodology/structure/frontmatter.md",
    "methodology/structure/archival.md",
    "methodology/validation/verifying-idd.md",
    "library/overview.md",
    "library/claims/README.md",
    "library/passes/index.md",
    "library/claims/intent-target/claim.md",
    "library/claims/intent-target/evidence.md",
    "library/claims/boundary-compliance/claim.md",
    "library/claims/boundary-compliance/evidence.md",
    "library/claims/authority-basis/claim.md",
    "library/claims/authority-basis/evidence.md",
    "library/claims/verification-posture/claim.md",
    "library/claims/verification-posture/evidence.md",
    "library/claims/residual-uncertainty/claim.md",
    "library/claims/residual-uncertainty/evidence.md",
    "library/claims/governance-ownership/claim.md",
    "library/claims/governance-ownership/evidence.md",
    "library/claims/layer-sync/claim.md",
    "library/claims/layer-sync/evidence.md",
    "library/claims/conflict-resolution/claim.md",
    "library/claims/conflict-resolution/evidence.md",
    "library/claims/outcome-posture/claim.md",
    "library/claims/outcome-posture/evidence.md",
    "library/claims/pass-effect/claim.md",
    "library/claims/pass-effect/evidence.md",
    "library/passes/intent/from-upstream/bound-scope-and-non-goals.md",
    "library/passes/intent/from-upstream/derive-behaviors.md",
    "library/passes/intent/from-upstream/derive-goal-stack.md",
    "library/passes/intent/from-upstream/derive-scenarios.md",
    "library/passes/intent/from-upstream/distill-durable-promises.md",
    "library/passes/intent/from-upstream/extract-product-why.md",
    "library/passes/intent/from-upstream/promote-tradeoffs-to-decisions.md",
    "library/passes/intent/from-upstream/strip-unsettled-material.md",
    "library/passes/intent/from-upstream/surface-quality-constraints.md",
    "library/passes/intent/within-intent/align-intent-decomposition.md",
    "library/passes/intent/within-intent/classify-assurance-criticality.md",
    "library/passes/intent/within-intent/de-duplicate-overlapping-promises.md",
    "library/passes/intent/within-intent/merge-fragmented-intent.md",
    "library/passes/intent/within-intent/route-constraints-to-assurances.md",
    "library/passes/intent/within-intent/sharpen-satisfaction-signals.md",
    "library/passes/intent/within-intent/split-overloaded-intent.md",
    "library/passes/intent/within-intent/stabilize-intent-traceability.md",
    "library/passes/intent/within-intent/surface-negative-space.md",
    "library/passes/intent/within-intent/tighten-applicability-context.md",
    "library/passes/intent/within-intent/tighten-behavior-checks.md",
    "library/passes/intent/within-intent/tighten-behavior-definitions.md",
    "library/passes/intent/within-intent/tighten-decision-records.md",
    "library/passes/intent/within-intent/tighten-feature-outcomes.md",
    "library/passes/intent/within-intent/tighten-goal-outcomes.md",
    "library/passes/intent/within-intent/tighten-scenario-checks.md",
    "library/passes/intent/to-blueprint/align-blueprint-targets.md",
    "library/passes/intent/to-blueprint/derive-verification-obligations.md",
    "library/passes/intent/to-blueprint/extract-blueprint-contract-pressure.md",
    "library/passes/intent/to-blueprint/map-intent-to-code-impact.md",
    "library/passes/intent/to-execution/raise-verification-specificity.md",
    "library/passes/intent/to-execution/shape-executable-step.md",
    "library/passes/intent/to-execution/split-overloaded-step.md",
]
STEP_STATUSES = {"planned", "shaped", "executing", "proving", "blocked", "complete"}
ARC_STATUSES = {"planning", "shaped", "executing", "proving", "blocked", "finalizing", "complete"}
VALID_STEP_TRANSITIONS = {
    ("planned", "shaped"),
    ("shaped", "executing"),
    ("shaped", "blocked"),
    ("executing", "proving"),
    ("executing", "blocked"),
    ("proving", "executing"),
    ("proving", "blocked"),
    ("proving", "complete"),
    ("blocked", "shaped"),
}
LOAD_VALUES = {"low", "medium", "high"}
PROOF_VERDICTS = {"updated", "unchanged-justified", "not-applicable"}
OUTCOME_DECISIONS = {"continue", "block", "complete"}
EXTERNAL_DEP_POSTURES = {"none", "existing-approved", "needs-user-input"}
VALIDATION_STATUSES = {"open", "follow-up-required", "passed"}
BASELINE_CLAIMS = ["`intent-target`", "`boundary-compliance`", "`layer-sync`", "`verification-posture`"]
CONDITIONAL_CLAIMS = [
    "`authority-basis`",
    "`conflict-resolution`",
    "`residual-uncertainty`",
    "`governance-ownership`",
    "`outcome-posture`",
    "`pass-effect`",
]
DURABLE_STATUSES = {"draft", "active", "deprecated", "disabled"}
FILE_BACKED_ID_TYPES = {
    "feature",
    "scenario",
    "behavior",
    "decision",
    "blueprint",
    "explainer",
    "description",
    "goal-catalog",
    "assurance-catalog",
}
CATALOG_ENTRY_ID_TYPES = {"goal", "assurance"}
ALL_DURABLE_ID_TYPES = FILE_BACKED_ID_TYPES | CATALOG_ENTRY_ID_TYPES
DURABLE_FRONTMATTER_FIELDS = {"id", "status", "owner"}
FILE_ARTIFACT_SECTION_ORDER = {
    "feature": ["Summary", "Background and Problem", "Definition", "Required Outcomes", "Refs"],
    "scenario": ["Summary", "Details", "Checks (Scenario)", "Refs"],
    "behavior": ["Summary", "Inputs and Conditions", "Outputs and Effects", "Definitions", "Checks (Behavior)", "Refs"],
    "decision": ["Summary", "Context", "Decision", "Options Considered", "Consequences", "Implementation Details", "Verification", "Refs", "Status and History"],
    "blueprint": ["Summary", "Scope and Consumers", "Contract", "Failure and Boundary Conditions", "Verification Notes", "Refs", "Change Notes"],
    "explainer": ["Summary", "Explanation", "Refs", "Boundaries and Non-Goals"],
    "description": ["Purpose", "Source Surface", "Key Logic", "Refs", "Interfaces and Models", "Verification Notes"],
    "goal-catalog": ["Summary", "Goal Catalog", "Guardrails", "Catalog Notes"],
}
FILE_ARTIFACT_REF_ORDER = {
    "feature": ["Goal refs", "Scenario refs", "Assurance refs", "Blueprint refs", "Decision refs"],
    "scenario": ["Feature ref", "Behavior refs", "Assurance refs", "Blueprint refs", "Decision refs"],
    "behavior": ["Scenario ref", "Assurance refs", "Blueprint refs", "Decision refs"],
    "decision": ["Intent refs", "Blueprint refs", "Step refs", "Evidence refs"],
    "blueprint": ["Intent refs", "Decision refs", "Explainer refs", "Verification refs"],
    "explainer": ["Canonical contract refs", "Intent refs"],
    "description": ["Intent refs", "Blueprint refs", "Decision refs", "Verification refs"],
}
ARTIFACT_ONLY_REF_FIELDS = {
    "feature": set(FILE_ARTIFACT_REF_ORDER["feature"]),
    "scenario": set(FILE_ARTIFACT_REF_ORDER["scenario"]),
    "behavior": set(FILE_ARTIFACT_REF_ORDER["behavior"]),
    "decision": {"Intent refs", "Blueprint refs", "Step refs"},
    "blueprint": {"Intent refs", "Decision refs", "Explainer refs"},
    "explainer": set(FILE_ARTIFACT_REF_ORDER["explainer"]),
    "description": {"Intent refs", "Blueprint refs", "Decision refs"},
}
SURFACE_ALLOWED_REF_FIELDS = {
    "decision": {"Evidence refs"},
    "blueprint": {"Verification refs"},
    "description": {"Verification refs"},
}
GOAL_ENTRY_FIELDS = [
    "Goal ID",
    "Outcome",
    "Why it matters",
    "Success signals",
    "Feature refs",
    "Assurance refs",
    "Decision refs",
]
ASSURANCE_ENTRY_FIELDS = [
    "Assurance ID",
    "Applies to",
    "Category",
    "Criticality",
    "Priority",
    "Quality scenario",
    "Metric definition",
    "Targets and budgets",
    "Evidence",
    "Implementation patterns and examples",
    "Refs",
    "Lifecycle",
    "Conflicts and Tradeoffs",
]
ASSURANCE_ENTRY_OPTIONAL_FIELDS = ["Notes"]
ASSURANCE_REFS_FIELDS = [
    "Feature refs",
    "Scenario refs",
    "Blueprint refs",
    "Description refs",
    "Verification refs",
    "Decision refs",
]
BASELINE_DISPOSITION_FIELDS = [
    "Assurance ID",
    "Disposition",
    "Rationale",
    "Compensating controls",
    "Review-by",
    "Decision refs",
]
ALLOWED_DISPOSITIONS = {"Inherited", "Overrides", "Not applicable"}
CLAIM_MD_OPENING_FIELDS = [
    "Claim type name",
    "Summary",
    "Why this claim matters",
    "Primary trust question",
    "Default evidence kind",
]
CLAIM_MD_SECTION_ORDER = [
    "Use This Claim When",
    "Claim Sentence Template",
    "Required Inputs",
    "Update These Artifacts When",
    "Related Claim Types",
]
EVIDENCE_GUIDE_SECTION_ORDER = [
    "Claim",
    "Methodology References",
    "Method Or Context",
    "Observations",
    "Raw Artifacts",
    "Verdict Guidance",
    "Evidence Thread Rules",
    "Closeout Conditions",
]
ARC_PROOF_PACKET_TEMPLATE_SECTION_ORDER = ["Proof Packet", "Review Packet", "Outcome"]
EVIDENCE_INDEX_PREFACE_FIELDS = [
    "Arc ID",
    "Methodology",
    "Run definition",
    "Status",
    "Started",
    "Ended",
    "Claim catalog path",
    "Arc path",
    "Evidence folder",
]
EVIDENCE_INDEX_SECTION_ORDER = [
    "Scope Or Boundary",
    "Baseline Claim Coverage",
    "Conditional Claim Coverage",
    "Evidence Inventory",
    "Open Or Incomplete Threads",
    "Arc Summary",
]
EVIDENCE_ITEM_PREFACE_FIELDS = [
    "Evidence ID",
    "Arc ID",
    "Title",
    "Kind",
    "Claim type",
    "Claim type path",
    "Status",
    "Created",
    "Updated",
]
EVIDENCE_ITEM_SECTION_ORDER = [
    "Claim",
    "Methodology References",
    "Method Or Context",
    "Observations",
    "Raw Artifacts",
    "Verdict",
    "Open Questions Or Follow-Ups",
]
STEP_CHECK_CATEGORY_FIELDS = [
    "Success-path checks",
    "Negative-path checks",
    "Invariant or regression checks",
    "Review-only checks",
]
PASS_INDEX_SECTION_ORDER = [
    "Start Here",
    "Path Context",
    "What Passes Are For",
    "Pass Topology",
    "How To Select A Pass",
    "Pass File Contract",
    "Pass-Effect Claims",
    "Starter Skeleton",
    "Pass Catalog",
    "Runtime Use",
]
PASS_FILE_SECTION_ORDER = [
    "Purpose",
    "Pipeline position",
    "Strengthens",
    "Creates or updates",
    "Use This Pass When",
    "Not for",
    "Inputs",
    "Preconditions",
    "Pass Steps",
    "Pass-effect claim",
    "Outputs",
    "Hand-off",
    "Quality checks",
    "Escalation triggers",
    "Arc use",
    "Runtime notes",
]
PASS_EFFECT_CLAIM_FIELDS = [
    "Use claim type",
    "Claim when",
    "Before posture",
    "After posture",
    "Evidence this pass can supply",
]
PASS_PIPELINE_ORDER = [
    "intent/from-upstream",
    "intent/within-intent",
    "intent/to-blueprint",
    "intent/to-execution",
]
PASS_PIPELINE_POSITIONS = set(PASS_PIPELINE_ORDER)
PASS_RUNTIME_NOTE_NEEDLES = [
    "same Arc phase that used the pass",
    "Do not defer pass-effect capture to a later phase.",
]
EXPECTED_PASS_FILES = [
    "intent/from-upstream/distill-durable-promises",
    "intent/from-upstream/extract-product-why",
    "intent/from-upstream/bound-scope-and-non-goals",
    "intent/from-upstream/derive-goal-stack",
    "intent/from-upstream/derive-scenarios",
    "intent/from-upstream/derive-behaviors",
    "intent/from-upstream/surface-quality-constraints",
    "intent/from-upstream/promote-tradeoffs-to-decisions",
    "intent/from-upstream/strip-unsettled-material",
    "intent/within-intent/align-intent-decomposition",
    "intent/within-intent/tighten-goal-outcomes",
    "intent/within-intent/tighten-feature-outcomes",
    "intent/within-intent/tighten-applicability-context",
    "intent/within-intent/tighten-scenario-checks",
    "intent/within-intent/tighten-behavior-definitions",
    "intent/within-intent/tighten-behavior-checks",
    "intent/within-intent/sharpen-satisfaction-signals",
    "intent/within-intent/surface-negative-space",
    "intent/within-intent/route-constraints-to-assurances",
    "intent/within-intent/classify-assurance-criticality",
    "intent/within-intent/stabilize-intent-traceability",
    "intent/within-intent/de-duplicate-overlapping-promises",
    "intent/within-intent/merge-fragmented-intent",
    "intent/within-intent/split-overloaded-intent",
    "intent/within-intent/tighten-decision-records",
    "intent/to-blueprint/align-blueprint-targets",
    "intent/to-blueprint/extract-blueprint-contract-pressure",
    "intent/to-blueprint/derive-verification-obligations",
    "intent/to-blueprint/map-intent-to-code-impact",
    "intent/to-execution/raise-verification-specificity",
    "intent/to-execution/shape-executable-step",
    "intent/to-execution/split-overloaded-step",
]
FEATURE_DEFINITION_FIELDS = ["Value statement", "In scope", "Out of scope"]
FEATURE_OUTCOME_FIELDS = ["Outcome ID", "Statement", "Why it matters", "Satisfaction signals"]
SCENARIO_DETAIL_HEADINGS = [
    "Actors",
    "Triggers",
    "Entry Conditions",
    "High-Level Flow (Narrative)",
    "Out of Scope for This Scenario",
]
SCENARIO_CHECK_FIELDS = ["Check ID", "Requirement", "Why it matters", "Evidence expectations"]
BEHAVIOR_DEFINITION_FIELDS = [
    "Interface refs",
    "State and error refs",
    "Authorization and audit refs",
    "Telemetry refs",
]
BEHAVIOR_CHECK_FIELDS = ["Check ID", "Requirement", "Why it matters", "Evidence expectations"]
BLUEPRINT_SCOPE_FIELDS = ["Scope", "Consumers", "Intent targets"]
ASSURANCE_EVIDENCE_FIELDS = ["Checks", "Operational signals", "Reviews"]
ASSURANCE_IMPLEMENTATION_FIELDS = [
    "Preferred patterns and helpers",
    "Do",
    "Do not",
    "Reference examples",
]
ASSURANCE_LIFECYCLE_FIELDS = ["Owner", "Status", "Review-by"]
ARTIFACT_REF_TARGET_TYPES = {
    "Goal refs": {"goal"},
    "Feature ref": {"feature"},
    "Feature refs": {"feature"},
    "Scenario ref": {"scenario"},
    "Scenario refs": {"scenario"},
    "Behavior refs": {"behavior"},
    "Assurance refs": {"assurance"},
    "Intent refs": {"goal", "feature", "scenario", "behavior", "assurance"},
    "Blueprint refs": {"blueprint"},
    "Decision refs": {"decision"},
    "Explainer refs": {"explainer"},
    "Canonical contract refs": {"blueprint"},
    "Description refs": {"description"},
    "Step refs": {"step"},
    "Evidence refs": {"evidence"},
}


class Reporter:
    def __init__(self) -> None:
        self.errors = 0
        self.warnings = 0

    def emit(self, level: str, code: str, path: Path | str, message: str) -> None:
        display = str(path)
        print(f"{level} {code} {display}: {message}")
        if level == "ERROR":
            self.errors += 1
        else:
            self.warnings += 1

    def error(self, code: str, path: Path | str, message: str) -> None:
        self.emit("ERROR", code, path, message)

    def warn(self, code: str, path: Path | str, message: str) -> None:
        self.emit("WARN", code, path, message)

    def summary(self) -> None:
        print(f"SUMMARY errors={self.errors} warnings={self.warnings}")


report = Reporter()


def relpath(path: Path, root: Path | None = None) -> str:
    base = root or REPO_ROOT
    try:
        return path.relative_to(base).as_posix()
    except ValueError:
        return path.as_posix()


def strip_backticks(value: str) -> str:
    value = value.strip()
    if value.startswith("`") and value.endswith("`") and value.count("`") == 2:
        return value[1:-1]
    return value


def normalize_inline_whitespace(value: str) -> str:
    return " ".join(value.split())


def normalize_relpath(value: str) -> str:
    value = strip_backticks(value.strip()).replace("\\", "/")
    if value.startswith("./"):
        value = value[2:]
    while value.endswith("/") and value not in {"", "."}:
        value = value[:-1]
    return "." if value == "" else value


def is_repo_relative(value: str) -> bool:
    if value == "":
        return False
    if value.startswith("/"):
        return False
    parts = [part for part in value.split("/") if part not in {"", "."}]
    return ".." not in parts


def read_text(path: Path) -> str | None:
    try:
        return path.read_text(encoding="utf-8")
    except FileNotFoundError:
        report.error("MISSING_FILE", relpath(path), "required file is missing")
    except OSError as exc:
        report.error("READ_FAILURE", relpath(path), f"could not read file: {exc}")
    return None


def parse_sections(text: str) -> list[dict[str, Any]]:
    sections: list[dict[str, Any]] = []
    current: dict[str, Any] | None = None
    in_fence = False
    for line in text.splitlines():
        if line.strip().startswith("```"):
            in_fence = not in_fence
            if current is not None:
                current["lines"].append(line)
            continue
        if in_fence:
            if current is not None:
                current["lines"].append(line)
            continue
        match = SECTION_RE.match(line)
        if match:
            current = {"name": match.group(1).strip(), "lines": []}
            sections.append(current)
            continue
        if current is not None:
            current["lines"].append(line)
    return sections


def sections_by_name(sections: list[dict[str, Any]]) -> dict[str, list[str]]:
    return {section["name"]: section["lines"] for section in sections}


def parse_subsections(lines: list[str]) -> dict[str, list[str]]:
    result: dict[str, list[str]] = {}
    current: str | None = None
    for line in lines:
        sub_match = SUBSECTION_RE.match(line)
        if sub_match:
            current = sub_match.group(1).strip()
            result.setdefault(current, [])
            continue
        bullet_match = FIELD_RE.match(line)
        if current and bullet_match and bullet_match.group(1) != "":
            result[current].append(strip_backticks((bullet_match.group(2) or "").strip()) if ":" in line else "")
            continue
        nested_match = NESTED_BULLET_RE.match(line)
        if current and nested_match:
            result[current].append(nested_match.group(1).strip())
            continue
        if current and line.startswith("- "):
            result[current].append(strip_backticks(line[2:].strip()))
    return result


def parse_fields(lines: list[str], expected_fields: list[str]) -> dict[str, dict[str, Any]]:
    fields: dict[str, dict[str, Any]] = {}
    current: str | None = None
    expected = set(expected_fields)
    for line in lines:
        field_match = FIELD_RE.match(line)
        if field_match and field_match.group(1) in expected:
            current = field_match.group(1)
            fields[current] = {
                "value": strip_backticks((field_match.group(2) or "").strip()),
                "items": [],
            }
            continue
        nested_match = NESTED_BULLET_RE.match(line)
        if nested_match and current:
            fields[current]["items"].append(nested_match.group(1).strip())
    return fields


def parse_preface_fields(text: str, expected_fields: list[str]) -> dict[str, str]:
    fields: dict[str, str] = {}
    expected = set(expected_fields)
    for line in text.splitlines():
        if SECTION_RE.match(line):
            break
        field_match = FIELD_RE.match(line)
        if field_match and field_match.group(1) in expected:
            fields[field_match.group(1)] = strip_backticks((field_match.group(2) or "").strip())
            continue
        plain_match = PLAIN_FIELD_RE.match(line.strip())
        if plain_match and plain_match.group(1) in expected:
            fields[plain_match.group(1)] = strip_backticks((plain_match.group(2) or "").strip())
    return fields


def parse_plain_preface_fields(text: str, expected_fields: list[str]) -> tuple[list[str], dict[str, str]]:
    fields: dict[str, str] = {}
    order: list[str] = []
    expected = set(expected_fields)
    for line in text.splitlines():
        if SECTION_RE.match(line):
            break
        match = PLAIN_FIELD_RE.match(line.strip())
        if match and match.group(1) in expected:
            name = match.group(1)
            order.append(name)
            fields[name] = strip_backticks((match.group(2) or "").strip())
    return order, fields


def field_value(parsed: dict[str, dict[str, Any]], field_name: str) -> str:
    return str(parsed.get(field_name, {}).get("value", "")).strip()


def field_items(parsed: dict[str, dict[str, Any]], field_name: str) -> list[str]:
    field = parsed.get(field_name)
    items: list[str] = []
    if field is None:
        return items
    value = str(field.get("value", "")).strip()
    if value:
        items.append(value)
    items.extend([str(item).strip() for item in field.get("items", [])])
    return items


def validate_timestamp(value: str, code: str, path: Path) -> None:
    if not TIMESTAMP_RE.match(value):
        report.error(code, relpath(path), f"timestamp must use ISO 8601 UTC: {value}")


def sequence_key(step_id: str) -> tuple[int, str, str]:
    match = re.match(r"^step-(\d+)([a-z]?)(?:-|$)", step_id)
    if not match:
        return (10**9, "", step_id)
    return (int(match.group(1)), match.group(2) or "", step_id)


def is_none_item(value: str) -> bool:
    return strip_backticks(value).strip() == "(none)"


def is_none_like(value: str) -> bool:
    cleaned = strip_backticks(value).strip().lower()
    return cleaned in {"(none)", "none", "no residual gaps", "no gaps"}


def parse_evidence_ids(value: str) -> list[str]:
    cleaned = strip_backticks(value).strip().lower()
    if is_none_like(value) or value.strip() == "" or cleaned in {"(none yet)", "(not yet updated)"}:
        return []
    parts = [part.strip() for part in strip_backticks(value).split(",")]
    return [part for part in parts if part]


def has_non_none_items(items: list[str]) -> bool:
    return any(strip_backticks(item).strip().lower() not in {"", "(none)", "none"} for item in items)


def has_completed_proof_items(items: list[str]) -> bool:
    return any(
        strip_backticks(item).strip().lower()
        not in {"", "(none)", "none", "(not yet run)", "(not yet updated)"}
        for item in items
    )


def extract_path_item(item: str, path: Path, code: str) -> str | None:
    item = item.strip()
    if is_none_item(item):
        return None
    match = TRACE_ITEM_RE.match(item)
    if not match:
        report.error(code, relpath(path), "path item must start with one repo-relative backticked path")
        return None
    candidate = normalize_relpath(match.group("path"))
    if not is_repo_relative(candidate):
        report.error(code, relpath(path), f"path must be repo-relative: {match.group('path')}")
        return None
    return candidate


def path_matches_rule(path_value: str, rule: str) -> bool:
    rule = normalize_relpath(rule)
    path_value = normalize_relpath(path_value)
    if rule == ".":
        return True
    return path_value == rule or path_value.startswith(rule + "/")


def split_anchor(path_value: str) -> str:
    return path_value.split("#", 1)[0]


def parse_frontmatter(text: str, path: Path, root: Path) -> tuple[dict[str, str] | None, str]:
    lines = text.splitlines()
    if not lines or not FRONTMATTER_DELIM_RE.match(lines[0]):
        report.error("ARTIFACT_FRONTMATTER_MISMATCH", relpath(path, root), "artifact file must begin with frontmatter")
        return None, text

    closing_index: int | None = None
    for index, line in enumerate(lines[1:], start=1):
        if FRONTMATTER_DELIM_RE.match(line):
            closing_index = index
            break
    if closing_index is None:
        report.error("ARTIFACT_FRONTMATTER_MISMATCH", relpath(path, root), "frontmatter must end with `---`")
        return None, text

    fields: dict[str, str] = {}
    for raw_line in lines[1:closing_index]:
        stripped = raw_line.strip()
        if not stripped:
            continue
        if ":" not in raw_line:
            report.error(
                "ARTIFACT_FRONTMATTER_MISMATCH",
                relpath(path, root),
                f"frontmatter line must use `key: value` syntax: {raw_line.strip()}",
            )
            continue
        name, value = raw_line.split(":", 1)
        key = name.strip()
        if key in fields:
            report.error("ARTIFACT_FRONTMATTER_MISMATCH", relpath(path, root), f"frontmatter repeats `{key}`")
        fields[key] = strip_backticks(value.strip())

    body = "\n".join(lines[closing_index + 1 :])
    return fields, body


def normalize_node_id(value: str) -> str:
    return strip_backticks(value).strip()


def parse_bullet_tree(lines: list[str]) -> list[dict[str, Any]]:
    root_nodes: list[dict[str, Any]] = []
    stack: list[tuple[int, list[dict[str, Any]]]] = [(-1, root_nodes)]
    for line in lines:
        match = BULLET_RE.match(line)
        if not match:
            continue
        indent = len(match.group("indent"))
        node = {"text": match.group("text").strip(), "children": []}
        while len(stack) > 1 and indent <= stack[-1][0]:
            stack.pop()
        stack[-1][1].append(node)
        stack.append((indent, node["children"]))
    return root_nodes


def split_field_text(text: str) -> tuple[str, str]:
    if ":" not in text:
        return text.strip(), ""
    name, value = text.split(":", 1)
    return name.strip(), value.strip()


def build_field_map(nodes: list[dict[str, Any]], path: Path, root: Path, code: str) -> tuple[list[str], dict[str, dict[str, Any]]]:
    order: list[str] = []
    fields: dict[str, dict[str, Any]] = {}
    for node in nodes:
        name, value = split_field_text(str(node["text"]))
        order.append(name)
        if name in fields:
            report.error(code, relpath(path, root), f"repeated field `{name}`")
        fields[name] = {"value": value, "node": node}
    return order, fields


def validate_required_field_order(
    root: Path,
    path: Path,
    section_name: str,
    lines: list[str],
    expected: list[str],
) -> dict[str, dict[str, Any]]:
    order, fields = build_field_map(parse_bullet_tree(lines), path, root, "ARTIFACT_SCHEMA_MISMATCH")
    if order != expected:
        report.error(
            "ARTIFACT_SCHEMA_MISMATCH",
            relpath(path, root),
            f"`{section_name}` fields do not match the required order",
        )
    for field_name in expected:
        if field_name not in fields:
            report.error(
                "ARTIFACT_SCHEMA_MISMATCH",
                relpath(path, root),
                f"`{section_name}` is missing `{field_name}`",
            )
    return fields


def validate_required_subheading_order(
    root: Path,
    path: Path,
    section_name: str,
    lines: list[str],
    expected: list[str],
) -> None:
    found = [match.group(1).strip() for line in lines for match in [SUBSECTION_RE.match(line)] if match]
    if found != expected:
        report.error(
            "ARTIFACT_SCHEMA_MISMATCH",
            relpath(path, root),
            f"`{section_name}` subheadings do not match the required order",
        )


def validate_intent_target_items(
    root: Path,
    path: Path,
    field_name: str,
    items: list[str],
    *,
    allow_none: bool,
) -> list[str]:
    cleaned = [strip_backticks(item).strip() for item in items if item.strip()]
    if not cleaned:
        report.error(
            "ARTIFACT_SCHEMA_MISMATCH" if "step-" not in path.name else "STEP_SCHEMA_MISMATCH",
            relpath(path, root),
            f"`{field_name}` must contain at least one intent target item",
        )
        return []
    if any(is_none_item(item) for item in cleaned):
        if len(cleaned) != 1 or not allow_none:
            report.error(
                "ARTIFACT_SCHEMA_MISMATCH" if "step-" not in path.name else "STEP_SCHEMA_MISMATCH",
                relpath(path, root),
                f"`{field_name}` cannot use `(none)` here",
            )
        return []

    seen: set[str] = set()
    result: list[str] = []
    code = "ARTIFACT_SCHEMA_MISMATCH" if "step-" not in path.name else "STEP_SCHEMA_MISMATCH"
    for item in cleaned:
        if not INTENT_TARGET_ITEM_RE.match(item):
            report.error(
                code,
                relpath(path, root),
                f"`{field_name}` uses unsupported intent target `{item}`",
            )
            continue
        if item in seen:
            report.error(
                code,
                relpath(path, root),
                f"`{field_name}` repeats intent target `{item}`",
            )
            continue
        seen.add(item)
        result.append(item)
    return result


def validate_structured_local_targets(
    root: Path,
    path: Path,
    section_name: str,
    lines: list[str],
    expected_fields: list[str],
    id_field: str,
    id_pattern: re.Pattern[str],
    id_description: str,
) -> list[str]:
    entries = split_level3_entries(lines)
    if not entries:
        report.error(
            "ARTIFACT_SCHEMA_MISMATCH",
            relpath(path, root),
            f"`{section_name}` must contain at least one level-3 entry",
        )
        return []

    seen_local_ids: set[str] = set()
    targets: list[str] = []
    for entry in entries:
        order, fields = build_field_map(parse_bullet_tree(entry["lines"]), path, root, "ARTIFACT_SCHEMA_MISMATCH")
        if order != expected_fields:
            report.error(
                "ARTIFACT_SCHEMA_MISMATCH",
                relpath(path, root),
                f"`{section_name}` entry `{entry['heading']}` fields do not match the required order",
            )
        for field_name in expected_fields:
            if field_name not in fields:
                report.error(
                    "ARTIFACT_SCHEMA_MISMATCH",
                    relpath(path, root),
                    f"`{section_name}` entry `{entry['heading']}` is missing `{field_name}`",
                )
        local_id = strip_backticks(fields.get(id_field, {}).get("value", "")).strip()
        if not local_id or not id_pattern.match(local_id):
            report.error(
                "ARTIFACT_SCHEMA_MISMATCH",
                relpath(path, root),
                f"`{section_name}` entry `{entry['heading']}` must use a stable {id_description}",
            )
            continue
        if local_id in seen_local_ids:
            report.error(
                "ARTIFACT_SCHEMA_MISMATCH",
                relpath(path, root),
                f"`{section_name}` repeats local ID `{local_id}`",
            )
            continue
        seen_local_ids.add(local_id)
        targets.append(local_id)
    return targets


def first_nonempty_line(text: str) -> str:
    for line in text.splitlines():
        if line.strip():
            return line.strip()
    return ""


def describe_allowed_types(types: set[str]) -> str:
    return ", ".join(f"`{item}`" for item in sorted(types))


def node_items(node: dict[str, Any]) -> list[str]:
    items: list[str] = []
    name, value = split_field_text(str(node["text"]))
    if value:
        items.append(value)
    for child in node.get("children", []):
        items.append(str(child["text"]).strip())
    return [item for item in items if item]


def nested_field_map(node: dict[str, Any], path: Path, root: Path, code: str) -> tuple[list[str], dict[str, dict[str, Any]]]:
    return build_field_map(list(node.get("children", [])), path, root, code)


def split_level3_entries(lines: list[str]) -> list[dict[str, Any]]:
    entries: list[dict[str, Any]] = []
    current: dict[str, Any] | None = None
    for line in lines:
        match = SUBSECTION_RE.match(line)
        if match:
            if current is not None:
                entries.append(current)
            current = {"heading": match.group(1).strip(), "lines": []}
            continue
        if current is not None:
            current["lines"].append(line)
    if current is not None:
        entries.append(current)
    return entries


def parse_artifact_ref(item: str) -> dict[str, str] | None:
    match = ARTIFACT_REF_RE.match(item.strip())
    if not match:
        return None
    raw_path = normalize_relpath(match.group("path"))
    return {
        "id": normalize_node_id(match.group("id")),
        "path": normalize_relpath(split_anchor(raw_path)),
        "raw_path": raw_path,
    }


def validate_surface_ref(root: Path, source_path: Path, field_name: str, item: str) -> None:
    raw = item.strip()
    if URL_SURFACE_RE.match(raw):
        return

    plain_path = normalize_relpath(strip_backticks(raw))
    if is_repo_relative(plain_path):
        if not (root / plain_path).exists():
            report.error(
                "ARTIFACT_SCHEMA_MISMATCH",
                relpath(source_path, root),
                f"`{field_name}` surface path does not resolve: {plain_path}",
            )
        return

    parsed_path = extract_path_item(raw, source_path, "ARTIFACT_SCHEMA_MISMATCH")
    if parsed_path is None:
        report.error(
            "ARTIFACT_SCHEMA_MISMATCH",
            relpath(source_path, root),
            f"`{field_name}` items must be artifact refs, repo-relative backticked paths, or URLs",
        )
        return
    if not (root / parsed_path).exists():
        report.error(
            "ARTIFACT_SCHEMA_MISMATCH",
            relpath(source_path, root),
            f"`{field_name}` surface path does not resolve: {parsed_path}",
        )


def validate_ref_items(
    root: Path,
    source_path: Path,
    field_name: str,
    items: list[str],
    *,
    allow_none: bool,
    artifact_only: bool,
    outgoing_refs: list[dict[str, str]],
    source_id: str,
) -> list[dict[str, str]]:
    cleaned = [item.strip() for item in items if item.strip()]
    if not cleaned:
        report.error(
            "ARTIFACT_SCHEMA_MISMATCH",
            relpath(source_path, root),
            f"`{field_name}` must contain at least one ref item or `(none)`",
        )
        return []
    if any(is_none_item(item) for item in cleaned):
        if len(cleaned) != 1 or not allow_none:
            report.error(
                "ARTIFACT_SCHEMA_MISMATCH",
                relpath(source_path, root),
                f"`{field_name}` cannot use `(none)` here",
            )
        return []

    parsed_refs: list[dict[str, str]] = []
    for item in cleaned:
        parsed_ref = parse_artifact_ref(item)
        if parsed_ref is not None:
            record = {
                "source_id": source_id,
                "source_path": relpath(source_path, root),
                "field_name": field_name,
                "target_id": parsed_ref["id"],
                "target_path": parsed_ref["path"],
            }
            parsed_refs.append(record)
            outgoing_refs.append(record)
            if not (root / parsed_ref["path"]).exists():
                report.error(
                    "BROKEN_ARTIFACT_REF",
                    relpath(source_path, root),
                    f"`{field_name}` target path does not resolve: {parsed_ref['path']}",
                )
            continue
        if artifact_only:
            report.error(
                "BROKEN_ARTIFACT_REF",
                relpath(source_path, root),
                f"`{field_name}` must use `` `id` | `path` `` artifact refs",
            )
            continue
        validate_surface_ref(root, source_path, field_name, item)
    return parsed_refs


def register_graph_node(
    nodes: dict[str, dict[str, str]],
    root: Path,
    node_id: str,
    path: Path,
    node_type: str,
) -> None:
    if node_id in nodes:
        report.error(
            "ARTIFACT_GRAPH_MISMATCH",
            relpath(path, root),
            f"artifact ID `{node_id}` is duplicated; first declared at `{nodes[node_id]['path']}`",
        )
        return
    nodes[node_id] = {"path": relpath(path, root), "type": node_type}


def validate_section_order(root: Path, path: Path, body: str, expected: list[str]) -> dict[str, list[str]]:
    sections = parse_sections(body)
    order = [section["name"] for section in sections]
    if order != expected:
        report.error(
            "ARTIFACT_SCHEMA_MISMATCH",
            relpath(path, root),
            "section headings do not match the required order",
        )
    return sections_by_name(sections)


def validate_claim_docs(root: Path, display_root: Path | None = None) -> None:
    claims_root = root / "library" / "claims"
    if not claims_root.is_dir():
        return
    rel_root = display_root or root

    for claim_dir in sorted(path for path in claims_root.iterdir() if path.is_dir()):
        claim_path = claim_dir / "claim.md"
        claim_text = read_text(claim_path)
        if claim_text is not None:
            claim_lines = claim_text.splitlines()
            if not claim_lines or claim_lines[0].strip() != "# Claim Type":
                report.error("SOURCE_CLAIM_FAMILY_MISMATCH", relpath(claim_path, rel_root), "`claim.md` must start with `# Claim Type`")
            opening_order, opening_fields = parse_plain_preface_fields(claim_text, CLAIM_MD_OPENING_FIELDS)
            if opening_order != CLAIM_MD_OPENING_FIELDS:
                report.error(
                    "SOURCE_CLAIM_FAMILY_MISMATCH",
                    relpath(claim_path, rel_root),
                    "`claim.md` opening fields must match the required order",
                )
            for field_name in CLAIM_MD_OPENING_FIELDS:
                if field_name not in opening_fields:
                    report.error(
                        "SOURCE_CLAIM_FAMILY_MISMATCH",
                        relpath(claim_path, rel_root),
                        f"`claim.md` is missing opening field `{field_name}`",
                    )
            claim_sections = parse_sections(claim_text)
            claim_order = [section["name"] for section in claim_sections]
            if claim_order != CLAIM_MD_SECTION_ORDER:
                report.error(
                    "SOURCE_CLAIM_FAMILY_MISMATCH",
                    relpath(claim_path, rel_root),
                    "`claim.md` sections must match the required order",
                )

        evidence_path = claim_dir / "evidence.md"
        evidence_text = read_text(evidence_path)
        if evidence_text is not None:
            evidence_lines = evidence_text.splitlines()
            if not evidence_lines or evidence_lines[0].strip() != "# Evidence Capture":
                report.error(
                    "SOURCE_CLAIM_FAMILY_MISMATCH",
                    relpath(evidence_path, rel_root),
                    "`evidence.md` must start with `# Evidence Capture`",
                )
            pre_section_lines: list[str] = []
            for line in evidence_lines[1:]:
                if SECTION_RE.match(line):
                    break
                if line.strip():
                    pre_section_lines.append(line.strip())
            if not pre_section_lines:
                report.error(
                    "SOURCE_CLAIM_FAMILY_MISMATCH",
                    relpath(evidence_path, rel_root),
                    "`evidence.md` must include one short orientation paragraph or sentence before the first section",
                )
            evidence_sections = parse_sections(evidence_text)
            evidence_order = [section["name"] for section in evidence_sections]
            if evidence_order != EVIDENCE_GUIDE_SECTION_ORDER:
                report.error(
                    "SOURCE_CLAIM_FAMILY_MISMATCH",
                    relpath(evidence_path, rel_root),
                    "`evidence.md` sections must match the required order",
                )


def validate_evidence_templates(root: Path, display_root: Path) -> None:
    index_path = root / "methodology" / "arc" / "templates" / "evidence" / "index.md"
    index_text = read_text(index_path)
    if index_text is not None:
        index_lines = index_text.splitlines()
        if not index_lines or index_lines[0].strip() != "# IDD Arc Evidence Index":
            report.error(
                "ARC_TEMPLATE_MISMATCH",
                relpath(index_path, display_root),
                "`index.md` must start with `# IDD Arc Evidence Index`",
            )
        preface = parse_preface_fields(index_text, EVIDENCE_INDEX_PREFACE_FIELDS)
        for field_name in EVIDENCE_INDEX_PREFACE_FIELDS:
            if field_name not in preface:
                report.error(
                    "ARC_TEMPLATE_MISMATCH",
                    relpath(index_path, display_root),
                    f"`index.md` is missing preface field `{field_name}`",
                )
        sections = parse_sections(index_text)
        order = [section["name"] for section in sections]
        if order != EVIDENCE_INDEX_SECTION_ORDER:
            report.error(
                "ARC_TEMPLATE_MISMATCH",
                relpath(index_path, display_root),
                "`index.md` sections must match the required evidence-index order",
            )
        by_name = sections_by_name(sections)
        baseline = parse_fields(by_name.get("Baseline Claim Coverage", []), BASELINE_CLAIMS)
        for claim_name in BASELINE_CLAIMS:
            if claim_name not in baseline:
                report.error(
                    "ARC_TEMPLATE_MISMATCH",
                    relpath(index_path, display_root),
                    f"`Baseline Claim Coverage` is missing {claim_name}",
                )
        conditional = parse_fields(by_name.get("Conditional Claim Coverage", []), CONDITIONAL_CLAIMS)
        for claim_name in CONDITIONAL_CLAIMS:
            if claim_name not in conditional:
                report.error(
                    "ARC_TEMPLATE_MISMATCH",
                    relpath(index_path, display_root),
                    f"`Conditional Claim Coverage` is missing {claim_name}",
                )

    item_path = root / "methodology" / "arc" / "templates" / "evidence" / "EVIDENCE.md"
    item_text = read_text(item_path)
    if item_text is not None:
        item_lines = item_text.splitlines()
        if not item_lines or item_lines[0].strip() != "# IDD Arc Evidence Item":
            report.error(
                "ARC_TEMPLATE_MISMATCH",
                relpath(item_path, display_root),
                "`EVIDENCE.md` must start with `# IDD Arc Evidence Item`",
            )
        preface = parse_preface_fields(item_text, EVIDENCE_ITEM_PREFACE_FIELDS)
        for field_name in EVIDENCE_ITEM_PREFACE_FIELDS:
            if field_name not in preface:
                report.error(
                    "ARC_TEMPLATE_MISMATCH",
                    relpath(item_path, display_root),
                    f"`EVIDENCE.md` is missing preface field `{field_name}`",
                )
        sections = parse_sections(item_text)
        order = [section["name"] for section in sections]
        if order != EVIDENCE_ITEM_SECTION_ORDER:
            report.error(
                "ARC_TEMPLATE_MISMATCH",
                relpath(item_path, display_root),
                "`EVIDENCE.md` sections must match the required evidence-item order",
            )


def validate_template_grouped_field(
    root: Path,
    path: Path,
    display_root: Path,
    section_name: str,
    lines: list[str],
    field_name: str,
    expected_fields: list[str],
) -> None:
    _, section_fields = build_field_map(parse_bullet_tree(lines), path, root, "ARC_TEMPLATE_MISMATCH")
    node = section_fields.get(field_name, {}).get("node")
    if node is None:
        report.error(
            "ARC_TEMPLATE_MISMATCH",
            relpath(path, display_root),
            f"`{section_name}` is missing `{field_name}`",
        )
        return

    found_order, nested_fields = nested_field_map(node, path, root, "ARC_TEMPLATE_MISMATCH")
    if found_order != expected_fields:
        report.error(
            "ARC_TEMPLATE_MISMATCH",
            relpath(path, display_root),
            f"`{section_name} > {field_name}` fields must match the required order",
        )

    for nested_name in expected_fields:
        if nested_name not in nested_fields:
            report.error(
                "ARC_TEMPLATE_MISMATCH",
                relpath(path, display_root),
                f"`{section_name} > {field_name}` is missing `{nested_name}`",
            )
            continue
        items = node_items(nested_fields[nested_name]["node"])
        if not items:
            report.error(
                "ARC_TEMPLATE_MISMATCH",
                relpath(path, display_root),
                f"`{section_name} > {field_name} > {nested_name}` must contain at least one item",
            )


def validate_arc_templates(root: Path, display_root: Path) -> None:
    step_template_path = root / "methodology" / "arc" / "templates" / "step.md"
    step_text = read_text(step_template_path)
    if step_text is not None:
        step_lines = step_text.splitlines()
        if not step_lines or step_lines[0].strip() != "# Arc Step":
            report.error(
                "ARC_TEMPLATE_MISMATCH",
                relpath(step_template_path, display_root),
                "`step.md` must start with `# Arc Step`",
            )
        step_sections = parse_sections(step_text)
        step_order = [section["name"] for section in step_sections]
        if step_order != STEP_SECTION_ORDER:
            report.error(
                "ARC_TEMPLATE_MISMATCH",
                relpath(step_template_path, display_root),
                "`step.md` sections must match the required step heading order",
            )
        step_by_name = sections_by_name(step_sections)
        for section_name, expected_fields in STEP_FIELDS.items():
            parsed = parse_fields(step_by_name.get(section_name, []), expected_fields)
            for field_name in expected_fields:
                if field_name not in parsed:
                    report.error(
                        "ARC_TEMPLATE_MISMATCH",
                        relpath(step_template_path, display_root),
                        f"`step.md` is missing `{section_name} > {field_name}`",
                    )
        validate_template_grouped_field(
            root,
            step_template_path,
            display_root,
            "Proof Target",
            step_by_name.get("Proof Target", []),
            "Required checks",
            STEP_CHECK_CATEGORY_FIELDS,
        )
        validate_template_grouped_field(
            root,
            step_template_path,
            display_root,
            "Proof Packet",
            step_by_name.get("Proof Packet", []),
            "Checks run",
            STEP_CHECK_CATEGORY_FIELDS,
        )
        validate_template_grouped_field(
            root,
            step_template_path,
            display_root,
            "Proof Packet",
            step_by_name.get("Proof Packet", []),
            "Results",
            STEP_CHECK_CATEGORY_FIELDS,
        )

    proof_template_path = root / "methodology" / "arc" / "templates" / "proof-packet.md"
    proof_text = read_text(proof_template_path)
    if proof_text is not None:
        proof_lines = proof_text.splitlines()
        if not proof_lines or proof_lines[0].strip() != "# Arc Proof Packet Snippet":
            report.error(
                "ARC_TEMPLATE_MISMATCH",
                relpath(proof_template_path, display_root),
                "`proof-packet.md` must start with `# Arc Proof Packet Snippet`",
            )
        proof_sections = parse_sections(proof_text)
        proof_order = [section["name"] for section in proof_sections]
        if proof_order != ARC_PROOF_PACKET_TEMPLATE_SECTION_ORDER:
            report.error(
                "ARC_TEMPLATE_MISMATCH",
                relpath(proof_template_path, display_root),
                "`proof-packet.md` sections must match the required order",
            )
        proof_by_name = sections_by_name(proof_sections)
        for section_name, expected_fields in (
            ("Proof Packet", STEP_FIELDS["Proof Packet"]),
            ("Review Packet", STEP_FIELDS["Review Packet"]),
            ("Outcome", STEP_FIELDS["Outcome"]),
        ):
            parsed = parse_fields(proof_by_name.get(section_name, []), expected_fields)
            for field_name in expected_fields:
                if field_name not in parsed:
                    report.error(
                        "ARC_TEMPLATE_MISMATCH",
                        relpath(proof_template_path, display_root),
                        f"`proof-packet.md` is missing `{section_name} > {field_name}`",
                    )
        validate_template_grouped_field(
            root,
            proof_template_path,
            display_root,
            "Proof Packet",
            proof_by_name.get("Proof Packet", []),
            "Checks run",
            STEP_CHECK_CATEGORY_FIELDS,
        )
        validate_template_grouped_field(
            root,
            proof_template_path,
            display_root,
            "Proof Packet",
            proof_by_name.get("Proof Packet", []),
            "Results",
            STEP_CHECK_CATEGORY_FIELDS,
        )
    validate_evidence_templates(root, display_root)


def validate_library_pass_entrypoints(root: Path, display_root: Path) -> None:
    checks = [
        (
            root / "library" / "overview.md",
            [
                "Open `passes/index.md` when authored quality or hand-off quality",
                "`passes/index.md`: pass catalog, pipeline routing, and pass-family rules",
            ],
        ),
        (
            root / "methodology" / "LIBRARY.md",
            [
                "`../library/passes/index.md`: pass catalog for authoring-strengthening",
                "Open `../library/passes/index.md` when authored quality or hand-off quality",
            ],
        ),
    ]
    for path, needles in checks:
        if not path.is_file():
            report.error("PASS_CATALOG_MISMATCH", relpath(path, display_root), "required library entrypoint surface is missing")
            continue
        text = read_text(path)
        if text is None:
            continue
        for needle in needles:
            if needle not in text:
                report.error(
                    "PASS_CATALOG_MISMATCH",
                    relpath(path, display_root),
                    f"library entrypoint must include `{needle}`",
                )


def validate_source_pass_support_docs(root: Path) -> None:
    checks = [
        (
            root / "setup" / "idd-setup.md",
            [
                "Use `.methodologies/idd/library/passes/index.md` when authored quality or",
                "including `pass-effect` when a local pass materially strengthens the current",
            ],
        ),
        (
            root / "methodology" / "ARC.md",
            [
                "same Arc phase that used the pass",
                "Do not defer pass-effect capture to a later phase.",
            ],
        ),
        (
            root / "methodology" / "arc" / "stages" / "map-arc.md",
            [
                "pass-effect",
                "before leaving `Map Arc`",
            ],
        ),
        (
            root / "methodology" / "arc" / "stages" / "shape-step.md",
            [
                "pass-effect",
                "before leaving `Shape Step`",
            ],
        ),
        (
            root / "methodology" / "arc" / "stages" / "run-step.md",
            [
                "pass-effect",
                "before leaving `Run Step`",
            ],
        ),
        (
            root / "methodology" / "arc" / "stages" / "prove-step.md",
            [
                "pass-effect",
                "before leaving `Prove Step`",
            ],
        ),
    ]
    for path, needles in checks:
        if not path.is_file():
            report.error("PASS_CATALOG_MISMATCH", relpath(path, root), "required source setup surface is missing")
            continue
        text = read_text(path)
        if text is None:
            continue
        normalized_text = normalize_inline_whitespace(text)
        for needle in needles:
            if normalize_inline_whitespace(needle) not in normalized_text:
                report.error(
                    "PASS_CATALOG_MISMATCH",
                    relpath(path, root),
                    f"source setup surface must include `{needle}`",
                )


def validate_pass_docs(root: Path, display_root: Path) -> None:
    passes_root = root / "library" / "passes"
    if not passes_root.is_dir():
        report.error("PASS_CATALOG_MISMATCH", relpath(passes_root, display_root), "pass catalog directory is missing")
        return

    index_path = passes_root / "index.md"
    if not index_path.is_file():
        report.error("PASS_CATALOG_MISMATCH", relpath(index_path, display_root), "pass catalog index is missing")
        return

    index_text = read_text(index_path)
    if index_text is None:
        return
    index_lines = index_text.splitlines()
    if not index_lines or index_lines[0].strip() != "# IDD Pass Catalog":
        report.error("PASS_CATALOG_MISMATCH", relpath(index_path, display_root), "`index.md` must start with `# IDD Pass Catalog`")
    index_sections = parse_sections(index_text)
    index_order = [section["name"] for section in index_sections]
    if index_order != PASS_INDEX_SECTION_ORDER:
        report.error(
            "PASS_CATALOG_MISMATCH",
            relpath(index_path, display_root),
            "`index.md` sections must match the required order",
        )
    by_name = sections_by_name(index_sections)
    declared_passes: list[str] = []
    for raw_line in by_name.get("Pass Catalog", []):
        line = raw_line.strip()
        if not line.startswith("- "):
            continue
        match = PASS_CATALOG_ITEM_RE.match(line)
        if not match:
            report.error(
                "PASS_CATALOG_MISMATCH",
                relpath(index_path, display_root),
                "`Pass Catalog` items must use `` `pass-name`: description `` format",
            )
            continue
        declared_passes.append(match.group("name"))
    if declared_passes != EXPECTED_PASS_FILES:
        report.error(
            "PASS_CATALOG_MISMATCH",
            relpath(index_path, display_root),
            "`Pass Catalog` must declare the full starter pass set in the required order",
        )

    topology_items = [
        strip_backticks(split_field_text(str(node["text"]).strip())[0]).rstrip("/")
        for node in parse_bullet_tree(by_name.get("Pass Topology", []))
    ]
    if topology_items != PASS_PIPELINE_ORDER:
        report.error(
            "PASS_CATALOG_MISMATCH",
            relpath(index_path, display_root),
            "`Pass Topology` must declare the full pipeline split in the required order",
        )

    actual_pass_files = sorted(
        path.relative_to(passes_root).with_suffix("").as_posix()
        for path in passes_root.rglob("*.md")
        if path.is_file() and path.name != "index.md"
    )
    if actual_pass_files != sorted(EXPECTED_PASS_FILES):
        report.error(
            "PASS_CATALOG_MISMATCH",
            relpath(passes_root, display_root),
            "pass catalog files must match the declared starter pass set",
        )

    for pass_name in EXPECTED_PASS_FILES:
        pass_path = passes_root / f"{pass_name}.md"
        if not pass_path.is_file():
            report.error("PASS_CATALOG_MISMATCH", relpath(pass_path, display_root), "declared pass file is missing")
            continue
        pass_text = read_text(pass_path)
        if pass_text is None:
            continue
        pass_lines = pass_text.splitlines()
        leaf_name = pass_name.rsplit("/", 1)[-1]
        expected_heading = f"# Pass: {leaf_name}"
        if not pass_lines or pass_lines[0].strip() != expected_heading:
            report.error(
                "PASS_CATALOG_MISMATCH",
                relpath(pass_path, display_root),
                f"pass file must start with `{expected_heading}`",
            )
        pass_sections = parse_sections(pass_text)
        pass_order = [section["name"] for section in pass_sections]
        if pass_order != PASS_FILE_SECTION_ORDER:
            report.error(
                "PASS_CATALOG_MISMATCH",
                relpath(pass_path, display_root),
                "pass sections must match the required order",
            )
        pass_by_name = sections_by_name(pass_sections)
        for section_name in PASS_FILE_SECTION_ORDER:
            lines = pass_by_name.get(section_name, [])
            if not any(line.strip() for line in lines):
                report.error(
                    "PASS_CATALOG_MISMATCH",
                    relpath(pass_path, display_root),
                    f"`{section_name}` must contain content",
                )
        runtime_notes_text = normalize_inline_whitespace("\n".join(pass_by_name.get("Runtime notes", [])))
        for needle in PASS_RUNTIME_NOTE_NEEDLES:
            if normalize_inline_whitespace(needle) not in runtime_notes_text:
                report.error(
                    "PASS_CATALOG_MISMATCH",
                    relpath(pass_path, display_root),
                    f"`Runtime notes` must include `{needle}`",
                )

        expected_position = pass_name.rsplit("/", 1)[0]
        pipeline_items = [
            strip_backticks(str(node["text"]).strip())
            for node in parse_bullet_tree(pass_by_name.get("Pipeline position", []))
        ]
        if pipeline_items != [expected_position]:
            report.error(
                "PASS_CATALOG_MISMATCH",
                relpath(pass_path, display_root),
                "`Pipeline position` must contain exactly the pass pipeline path",
            )
        elif pipeline_items[0] not in PASS_PIPELINE_POSITIONS:
            report.error(
                "PASS_CATALOG_MISMATCH",
                relpath(pass_path, display_root),
                f"`Pipeline position` uses unsupported value `{pipeline_items[0]}`",
            )

        pass_effect_lines = pass_by_name.get("Pass-effect claim", [])
        effect_order, effect_fields = build_field_map(
            parse_bullet_tree(pass_effect_lines),
            pass_path,
            root,
            "PASS_CATALOG_MISMATCH",
        )
        if effect_order != PASS_EFFECT_CLAIM_FIELDS:
            report.error(
                "PASS_CATALOG_MISMATCH",
                relpath(pass_path, display_root),
                "`Pass-effect claim` fields must match the required order",
            )
        for field_name in PASS_EFFECT_CLAIM_FIELDS:
            if field_name not in effect_fields:
                report.error(
                    "PASS_CATALOG_MISMATCH",
                    relpath(pass_path, display_root),
                    f"`Pass-effect claim` is missing `{field_name}`",
                )
                continue
            value = effect_fields[field_name]["value"].strip()
            if field_name == "Evidence this pass can supply":
                if not node_items(effect_fields[field_name]["node"]):
                    report.error(
                        "PASS_CATALOG_MISMATCH",
                        relpath(pass_path, display_root),
                        "`Pass-effect claim > Evidence this pass can supply` must contain at least one item",
                    )
            elif not value:
                report.error(
                    "PASS_CATALOG_MISMATCH",
                    relpath(pass_path, display_root),
                    f"`Pass-effect claim > {field_name}` must be populated",
                )
        if effect_fields.get("Use claim type", {}).get("value", "").strip() != "`pass-effect`" and (
            strip_backticks(effect_fields.get("Use claim type", {}).get("value", "")).strip() != "pass-effect"
        ):
            report.error(
                "PASS_CATALOG_MISMATCH",
                relpath(pass_path, display_root),
                "`Pass-effect claim > Use claim type` must be `pass-effect`",
            )


def validate_installed_package(target_root: Path) -> None:
    package_root = target_root / ".methodologies" / "idd"
    if not package_root.is_dir():
        report.error(
            "MISSING_INSTALLED_PACKAGE",
            relpath(package_root, target_root),
            "target repo is missing the installed `.methodologies/idd/` package",
        )
        return
    validate_arc_templates(package_root, target_root)
    validate_library_pass_entrypoints(package_root, target_root)
    validate_pass_docs(package_root, target_root)
    validate_claim_docs(package_root, target_root)


def validate_ref_subsections(
    root: Path,
    path: Path,
    body: str,
    artifact_type: str,
    source_id: str,
    outgoing_refs: list[dict[str, str]],
) -> dict[str, list[dict[str, str]]]:
    by_name = validate_section_order(root, path, body, FILE_ARTIFACT_SECTION_ORDER[artifact_type])
    refs_lines = by_name.get("Refs", [])
    found_order = [
        match.group(1).strip()
        for line in refs_lines
        for match in [SUBSECTION_RE.match(line)]
        if match
    ]
    expected_order = FILE_ARTIFACT_REF_ORDER[artifact_type]
    if found_order != expected_order:
        report.error(
            "ARTIFACT_SCHEMA_MISMATCH",
            relpath(path, root),
            "`Refs` subsections do not match the required order",
        )
    parsed = parse_subsections(refs_lines)
    validated: dict[str, list[dict[str, str]]] = {}
    for field_name in expected_order:
        items = [item for item in parsed.get(field_name, []) if item]
        validated[field_name] = validate_ref_items(
            root,
            path,
            field_name,
            items,
            allow_none=field_name not in {"Feature ref", "Scenario ref"},
            artifact_only=field_name in ARTIFACT_ONLY_REF_FIELDS.get(artifact_type, set()),
            outgoing_refs=outgoing_refs,
            source_id=source_id,
        )
    return validated


def classify_candidate_artifact(path: Path, root: Path) -> str | None:
    relative = relpath(path, root)
    if path.name.startswith("_") and path.name.endswith(".desc.md"):
        return "description"
    if relative == "intents/system/goals.md":
        return "goal-catalog"
    if relative.startswith("intents/system/") and path.name == "assurances.md":
        return "assurance-catalog"
    if relative.startswith("intents/system/") and path.name == "feature.md":
        return "feature"
    if relative.startswith("intents/system/") and "/scenarios/" in relative and path.name == "scenario.md":
        return "scenario"
    if relative.startswith("intents/system/") and "/scenarios/" in relative and "/behaviors/" in relative and path.suffix == ".md":
        return "behavior"
    if relative.startswith("intents/") and (relative.startswith("intents/blueprints/") or "/blueprints/" in relative):
        return "blueprint-or-explainer"
    if relative.startswith("intents/") and (relative.startswith("intents/decisions/") or "/decisions/" in relative):
        return "decision"
    if relative.startswith("intents/"):
        return "unknown-intent-artifact"
    return None


def validate_frontmatter_for_candidate(
    root: Path,
    path: Path,
    candidate_type: str,
    frontmatter: dict[str, str] | None,
) -> tuple[str, str] | None:
    if frontmatter is None:
        return None
    extra_fields = sorted(set(frontmatter) - DURABLE_FRONTMATTER_FIELDS)
    missing_fields = [field_name for field_name in ("id", "status", "owner") if not frontmatter.get(field_name, "").strip()]
    if extra_fields:
        report.error(
            "ARTIFACT_FRONTMATTER_MISMATCH",
            relpath(path, root),
            f"frontmatter uses unsupported fields: {', '.join(extra_fields)}",
        )
    for field_name in missing_fields:
        report.error(
            "ARTIFACT_FRONTMATTER_MISMATCH",
            relpath(path, root),
            f"frontmatter must populate `{field_name}`",
        )

    node_id = normalize_node_id(frontmatter.get("id", ""))
    status = frontmatter.get("status", "").strip()
    if status and status not in DURABLE_STATUSES:
        report.error(
            "ARTIFACT_FRONTMATTER_MISMATCH",
            relpath(path, root),
            f"frontmatter `status` uses unsupported value `{status}`",
        )

    id_type = node_id.split("/", 1)[0] if node_id else ""
    if id_type and id_type not in ALL_DURABLE_ID_TYPES:
        report.error(
            "ARTIFACT_FRONTMATTER_MISMATCH",
            relpath(path, root),
            f"frontmatter `id` uses unsupported type `{id_type}`",
        )

    allowed_types = {
        "blueprint-or-explainer": {"blueprint", "explainer"},
        "goal-catalog": {"goal-catalog"},
        "assurance-catalog": {"assurance-catalog"},
        "feature": {"feature"},
        "scenario": {"scenario"},
        "behavior": {"behavior"},
        "decision": {"decision"},
        "description": {"description"},
    }.get(candidate_type, set())
    if candidate_type == "unknown-intent-artifact":
        report.error(
            "ARTIFACT_PATH_MISMATCH",
            relpath(path, root),
            "unrecognized durable artifact location under `intents/`",
        )
    elif id_type and allowed_types and id_type not in allowed_types:
        report.error(
            "ARTIFACT_PATH_MISMATCH",
            relpath(path, root),
            f"path shape does not match frontmatter type `{id_type}`",
        )

    return node_id, id_type


def collect_candidate_artifact_paths(root: Path) -> list[Path]:
    candidates: set[Path] = set()
    intents_dir = root / "intents"
    if intents_dir.is_dir():
        for current_root, _, filenames in os.walk(intents_dir):
            current_path = Path(current_root)
            for filename in filenames:
                if filename.endswith(".md"):
                    candidates.add(current_path / filename)
    else:
        report.error("MISSING_DURABLE_ARTIFACTS", root.as_posix(), "target repo is missing `intents/`")

    for current_root, dirnames, filenames in os.walk(root):
        dirnames[:] = [name for name in dirnames if name not in {".git", ".hg", ".svn", "node_modules", "__pycache__", ".methodologies"}]
        current_path = Path(current_root)
        for filename in filenames:
            if filename.startswith("_") and filename.endswith(".desc.md"):
                candidates.add(current_path / filename)
    return sorted(candidates)


def collect_runtime_ref_nodes(root: Path) -> dict[str, dict[str, str]]:
    nodes: dict[str, dict[str, str]] = {}
    arc_dir = root / ".methodologies" / "idd" / "scratch" / "arc"
    if arc_dir.is_dir():
        for step_path in sorted(arc_dir.glob("step-*.md")):
            text = read_text(step_path)
            if text is None:
                continue
            step_id = parse_preface_fields(text, ["Step ID"]).get("Step ID") or step_path.stem
            register_graph_node(nodes, root, normalize_node_id(step_id), step_path, "step")

    evidence_root = root / ".methodologies" / "idd" / "scratch" / "evidence"
    if evidence_root.is_dir():
        for item_path in sorted(evidence_root.glob("**/E*.md")):
            if not item_path.is_file():
                continue
            text = read_text(item_path)
            if text is None:
                continue
            evidence_id = parse_preface_fields(text, ["Evidence ID"]).get("Evidence ID") or item_path.stem
            register_graph_node(nodes, root, normalize_node_id(evidence_id), item_path, "evidence")
    return nodes


def parse_status(root: Path) -> dict[str, Any] | None:
    status_path = root / ".methodologies" / "idd" / "status.md"
    text = read_text(status_path)
    if text is None:
        return None
    sections = parse_sections(text)
    by_name = sections_by_name(sections)

    for section_name in REQUIRED_STATUS_SECTIONS:
        if section_name not in by_name:
            report.error(
                "MISSING_STATUS_SECTION",
                relpath(status_path, root),
                f"required status section `{section_name}` is missing",
            )

    operating = parse_subsections(by_name.get("Operating scope", []))
    permissions = parse_subsections(by_name.get("Permissions", []))

    mode_items = [normalize_relpath(item) for item in operating.get("Mode", []) if item]
    mode = mode_items[0] if mode_items else ""
    if mode not in {"entire-repo", "selected-paths"}:
        report.error("STATUS_SCOPE_MISMATCH", relpath(status_path, root), "Operating scope mode must be `entire-repo` or `selected-paths`")

    roots = [normalize_relpath(item) for item in operating.get("In-scope roots", []) if item and not item.startswith("(set during setup")]
    roots = [item for item in roots if item != "(none)"]
    if mode == "entire-repo":
        roots = ["."]
    elif mode == "selected-paths" and not roots:
        report.error("STATUS_SCOPE_MISMATCH", relpath(status_path, root), "`selected-paths` mode requires at least one in-scope root")

    buckets = {
        "read_write": [
            normalize_relpath(item)
            for item in permissions.get("Read and write allowed", [])
            if item and item != "(none)"
        ],
        "read_only": [
            normalize_relpath(item)
            for item in permissions.get("Read-only", [])
            if item and item != "(none)"
        ],
        "no_access": [
            normalize_relpath(item)
            for item in permissions.get("No access", [])
            if item and item != "(none)"
        ],
    }
    return {"path": status_path, "mode": mode, "roots": roots, "permissions": buckets}


def path_in_operating_scope(path_value: str, status_info: dict[str, Any]) -> bool:
    return any(path_matches_rule(path_value, root) for root in status_info.get("roots", []))


def effective_permission(path_value: str, status_info: dict[str, Any]) -> str:
    if not path_in_operating_scope(path_value, status_info):
        return "no_access"

    best = ("", "no_access")
    for permission_name, bucket_name in (
        ("read_write", "read_write"),
        ("read_only", "read_only"),
        ("no_access", "no_access"),
    ):
        for rule in status_info.get("permissions", {}).get(bucket_name, []):
            if path_matches_rule(path_value, rule) and len(rule) > len(best[0]):
                best = (rule, permission_name)
    return best[1]


def validate_goal_catalog(
    root: Path,
    path: Path,
    body: str,
    outgoing_refs: list[dict[str, str]],
    graph_nodes: dict[str, dict[str, str]],
) -> None:
    by_name = validate_section_order(root, path, body, FILE_ARTIFACT_SECTION_ORDER["goal-catalog"])
    entries = split_level3_entries(by_name.get("Goal Catalog", []))
    if not entries:
        report.error("ARTIFACT_SCHEMA_MISMATCH", relpath(path, root), "`Goal Catalog` must contain at least one goal entry")
        return

    for entry in entries:
        order, fields = build_field_map(parse_bullet_tree(entry["lines"]), path, root, "ARTIFACT_SCHEMA_MISMATCH")
        if order != GOAL_ENTRY_FIELDS:
            report.error(
                "ARTIFACT_SCHEMA_MISMATCH",
                relpath(path, root),
                f"goal entry `{entry['heading']}` fields do not match the required order",
            )
        for field_name in GOAL_ENTRY_FIELDS:
            if field_name not in fields:
                report.error(
                    "ARTIFACT_SCHEMA_MISMATCH",
                    relpath(path, root),
                    f"goal entry `{entry['heading']}` is missing `{field_name}`",
                )
        goal_id = normalize_node_id(fields.get("Goal ID", {}).get("value", ""))
        if goal_id and not goal_id.startswith("goal/"):
            report.error("ARTIFACT_SCHEMA_MISMATCH", relpath(path, root), f"`Goal ID` must use the `goal/...` type: {goal_id}")
        if goal_id:
            register_graph_node(graph_nodes, root, goal_id, path, "goal")
        for field_name in ("Feature refs", "Assurance refs", "Decision refs"):
            node = fields.get(field_name, {}).get("node")
            items = node_items(node) if node is not None else []
            validate_ref_items(
                root,
                path,
                field_name,
                items,
                allow_none=True,
                artifact_only=True,
                outgoing_refs=outgoing_refs,
                source_id=goal_id or relpath(path, root),
            )


def validate_assurance_entries(
    root: Path,
    path: Path,
    entries: list[dict[str, Any]],
    outgoing_refs: list[dict[str, str]],
    graph_nodes: dict[str, dict[str, str]],
    *,
    scoped: bool,
) -> set[str]:
    assurance_ids: set[str] = set()
    for entry in entries:
        order, fields = build_field_map(parse_bullet_tree(entry["lines"]), path, root, "ARTIFACT_SCHEMA_MISMATCH")
        allowed_order = ASSURANCE_ENTRY_FIELDS + ASSURANCE_ENTRY_OPTIONAL_FIELDS
        if order[: len(ASSURANCE_ENTRY_FIELDS)] != ASSURANCE_ENTRY_FIELDS or any(
            name not in allowed_order for name in order
        ):
            report.error(
                "ARTIFACT_SCHEMA_MISMATCH",
                relpath(path, root),
                f"assurance entry `{entry['heading']}` fields do not match the required order",
            )
        for field_name in ASSURANCE_ENTRY_FIELDS:
            if field_name not in fields:
                report.error(
                    "ARTIFACT_SCHEMA_MISMATCH",
                    relpath(path, root),
                    f"assurance entry `{entry['heading']}` is missing `{field_name}`",
                )

        assurance_id = normalize_node_id(fields.get("Assurance ID", {}).get("value", ""))
        if assurance_id and not assurance_id.startswith("assurance/"):
            report.error(
                "ARTIFACT_SCHEMA_MISMATCH",
                relpath(path, root),
                f"`Assurance ID` must use the `assurance/...` type: {assurance_id}",
            )
        if assurance_id:
            register_graph_node(graph_nodes, root, assurance_id, path, "assurance")
            assurance_ids.add(assurance_id)

        evidence_node = fields.get("Evidence", {}).get("node")
        if evidence_node is not None:
            evidence_order, evidence_fields = nested_field_map(evidence_node, path, root, "ARTIFACT_SCHEMA_MISMATCH")
            if evidence_order != ASSURANCE_EVIDENCE_FIELDS:
                report.error(
                    "ARTIFACT_SCHEMA_MISMATCH",
                    relpath(path, root),
                    f"`Evidence` fields for assurance entry `{entry['heading']}` do not match the required order",
                )
            for field_name in ASSURANCE_EVIDENCE_FIELDS:
                if field_name not in evidence_fields:
                    report.error(
                        "ARTIFACT_SCHEMA_MISMATCH",
                        relpath(path, root),
                        f"`Evidence` for assurance entry `{entry['heading']}` is missing `{field_name}`",
                    )

        implementation_node = fields.get("Implementation patterns and examples", {}).get("node")
        if implementation_node is not None:
            implementation_order, implementation_fields = nested_field_map(
                implementation_node,
                path,
                root,
                "ARTIFACT_SCHEMA_MISMATCH",
            )
            if implementation_order != ASSURANCE_IMPLEMENTATION_FIELDS:
                report.error(
                    "ARTIFACT_SCHEMA_MISMATCH",
                    relpath(path, root),
                    f"`Implementation patterns and examples` fields for assurance entry `{entry['heading']}` do not match the required order",
                )
            for field_name in ASSURANCE_IMPLEMENTATION_FIELDS:
                if field_name not in implementation_fields:
                    report.error(
                        "ARTIFACT_SCHEMA_MISMATCH",
                        relpath(path, root),
                        f"`Implementation patterns and examples` for assurance entry `{entry['heading']}` is missing `{field_name}`",
                    )

        lifecycle_node = fields.get("Lifecycle", {}).get("node")
        if lifecycle_node is not None:
            lifecycle_order, lifecycle_fields = nested_field_map(lifecycle_node, path, root, "ARTIFACT_SCHEMA_MISMATCH")
            if lifecycle_order != ASSURANCE_LIFECYCLE_FIELDS:
                report.error(
                    "ARTIFACT_SCHEMA_MISMATCH",
                    relpath(path, root),
                    f"`Lifecycle` fields for assurance entry `{entry['heading']}` do not match the required order",
                )
            for field_name in ASSURANCE_LIFECYCLE_FIELDS:
                if field_name not in lifecycle_fields:
                    report.error(
                        "ARTIFACT_SCHEMA_MISMATCH",
                        relpath(path, root),
                        f"`Lifecycle` for assurance entry `{entry['heading']}` is missing `{field_name}`",
                    )

        refs_node = fields.get("Refs", {}).get("node")
        if refs_node is None:
            continue
        refs_order, refs_fields = nested_field_map(refs_node, path, root, "ARTIFACT_SCHEMA_MISMATCH")
        if refs_order != ASSURANCE_REFS_FIELDS:
            report.error(
                "ARTIFACT_SCHEMA_MISMATCH",
                relpath(path, root),
                f"`Refs` fields for assurance entry `{entry['heading']}` do not match the required order",
            )

        parsed_feature_refs = []
        parsed_scenario_refs = []
        for field_name in ASSURANCE_REFS_FIELDS:
            node = refs_fields.get(field_name, {}).get("node")
            items = node_items(node) if node is not None else []
            parsed = validate_ref_items(
                root,
                path,
                field_name,
                items,
                allow_none=True,
                artifact_only=field_name != "Verification refs",
                outgoing_refs=outgoing_refs,
                source_id=assurance_id or relpath(path, root),
            )
            if field_name == "Feature refs":
                parsed_feature_refs = parsed
            elif field_name == "Scenario refs":
                parsed_scenario_refs = parsed
        if scoped and not parsed_feature_refs and not parsed_scenario_refs:
            report.error(
                "ARTIFACT_GRAPH_MISMATCH",
                relpath(path, root),
                f"scoped assurance entry `{entry['heading']}` must link at least one feature or scenario",
            )
    return assurance_ids


def validate_baseline_dispositions(root: Path, path: Path, lines: list[str], outgoing_refs: list[dict[str, str]]) -> list[dict[str, str]]:
    entries = split_level3_entries(lines)
    dispositions: list[dict[str, str]] = []
    seen_ids: set[str] = set()
    for entry in entries:
        order, fields = build_field_map(parse_bullet_tree(entry["lines"]), path, root, "ARTIFACT_SCHEMA_MISMATCH")
        if order != BASELINE_DISPOSITION_FIELDS:
            report.error(
                "ARTIFACT_SCHEMA_MISMATCH",
                relpath(path, root),
                f"baseline disposition `{entry['heading']}` fields do not match the required order",
            )
        for field_name in BASELINE_DISPOSITION_FIELDS:
            if field_name not in fields:
                report.error(
                    "ARTIFACT_SCHEMA_MISMATCH",
                    relpath(path, root),
                    f"baseline disposition `{entry['heading']}` is missing `{field_name}`",
                )
        assurance_id = normalize_node_id(fields.get("Assurance ID", {}).get("value", ""))
        if assurance_id and assurance_id in seen_ids:
            report.error(
                "ARTIFACT_GRAPH_MISMATCH",
                relpath(path, root),
                f"`Baseline Disposition` repeats assurance `{assurance_id}`",
            )
        if assurance_id:
            seen_ids.add(assurance_id)
        disposition = fields.get("Disposition", {}).get("value", "").strip()
        if disposition and disposition not in ALLOWED_DISPOSITIONS:
            report.error(
                "ARTIFACT_SCHEMA_MISMATCH",
                relpath(path, root),
                f"`Disposition` uses unsupported value `{disposition}`",
            )
        if disposition in {"Overrides", "Not applicable"} and not fields.get("Rationale", {}).get("value", "").strip():
            report.error(
                "ARTIFACT_SCHEMA_MISMATCH",
                relpath(path, root),
                f"`Baseline Disposition` for `{assurance_id}` must include `Rationale`",
            )
        if disposition == "Overrides" and not fields.get("Compensating controls", {}).get("value", "").strip():
            report.error(
                "ARTIFACT_SCHEMA_MISMATCH",
                relpath(path, root),
                f"`Baseline Disposition` for `{assurance_id}` must include `Compensating controls`",
            )
        if disposition == "Overrides" and not fields.get("Review-by", {}).get("value", "").strip():
            report.error(
                "ARTIFACT_SCHEMA_MISMATCH",
                relpath(path, root),
                f"`Baseline Disposition` for `{assurance_id}` must include `Review-by`",
            )

        decision_node = fields.get("Decision refs", {}).get("node")
        decision_items = node_items(decision_node) if decision_node is not None else []
        parsed_decisions = validate_ref_items(
            root,
            path,
            "Decision refs",
            decision_items,
            allow_none=disposition != "Overrides",
            artifact_only=True,
            outgoing_refs=outgoing_refs,
            source_id=assurance_id or relpath(path, root),
        )
        if disposition == "Overrides" and not parsed_decisions:
            report.error(
                "ARTIFACT_GRAPH_MISMATCH",
                relpath(path, root),
                f"`Overrides` disposition for `{assurance_id}` must include `Decision refs`",
            )
        dispositions.append({"assurance_id": assurance_id, "disposition": disposition})
    return dispositions


def validate_assurance_catalog(
    root: Path,
    path: Path,
    body: str,
    outgoing_refs: list[dict[str, str]],
    graph_nodes: dict[str, dict[str, str]],
    global_baseline_ids: set[str],
    scoped_catalogs: list[dict[str, Any]],
) -> None:
    sections = parse_sections(body)
    order = [section["name"] for section in sections]
    global_order = ["Summary", "Baseline Catalog", "Conflict Policy", "Review and Ownership"]
    scoped_order = ["Summary", "Scoped Critical Paths", "Baseline Disposition", "Scoped Assurance Entries", "Overrides and Review Dates"]
    by_name = sections_by_name(sections)

    if relpath(path, root) == "intents/system/assurances.md" and order != global_order:
        report.error("ARTIFACT_SCHEMA_MISMATCH", relpath(path, root), "global assurances file must use the baseline catalog section order")
    if relpath(path, root) != "intents/system/assurances.md" and order != scoped_order:
        report.error("ARTIFACT_SCHEMA_MISMATCH", relpath(path, root), "scoped assurances file must use the scoped catalog section order")

    if order == global_order:
        entries = split_level3_entries(by_name.get("Baseline Catalog", []))
        global_baseline_ids.update(
            validate_assurance_entries(root, path, entries, outgoing_refs, graph_nodes, scoped=False)
        )
        return

    if order != scoped_order:
        return

    dispositions = validate_baseline_dispositions(root, path, by_name.get("Baseline Disposition", []), outgoing_refs)
    scoped_entries = split_level3_entries(by_name.get("Scoped Assurance Entries", []))
    scoped_ids = validate_assurance_entries(root, path, scoped_entries, outgoing_refs, graph_nodes, scoped=True)
    scoped_catalogs.append(
        {
            "path": relpath(path, root),
            "dispositions": dispositions,
            "scoped_ids": scoped_ids,
        }
    )


def validate_file_backed_artifact(
    root: Path,
    path: Path,
    body: str,
    artifact_type: str,
    node_id: str,
    outgoing_refs: list[dict[str, str]],
) -> None:
    refs = validate_ref_subsections(root, path, body, artifact_type, node_id, outgoing_refs)
    by_name = sections_by_name(parse_sections(body))
    title_line = first_nonempty_line(body)

    if artifact_type == "scenario" and len(refs.get("Feature ref", [])) != 1:
        report.error("ARTIFACT_GRAPH_MISMATCH", relpath(path, root), "scenario files must contain exactly one `Feature ref`")
    if artifact_type == "behavior" and len(refs.get("Scenario ref", [])) != 1:
        report.error("ARTIFACT_GRAPH_MISMATCH", relpath(path, root), "behavior files must contain exactly one `Scenario ref`")
    if artifact_type == "feature" and not refs.get("Goal refs"):
        report.error("ARTIFACT_GRAPH_MISMATCH", relpath(path, root), "feature files must contain at least one `Goal ref`")
    if artifact_type == "blueprint" and not refs.get("Intent refs"):
        report.error("ARTIFACT_GRAPH_MISMATCH", relpath(path, root), "Blueprint files must contain at least one `Intent ref`")
    if artifact_type == "explainer" and not refs.get("Canonical contract refs"):
        report.error("ARTIFACT_GRAPH_MISMATCH", relpath(path, root), "explainer files must contain at least one `Canonical contract ref`")
    if artifact_type == "decision" and not refs.get("Intent refs") and not refs.get("Blueprint refs"):
        report.error(
            "ARTIFACT_GRAPH_MISMATCH",
            relpath(path, root),
            "decision files must contain at least one `Intent ref` or `Blueprint ref`",
        )
    if artifact_type == "description":
        if not refs.get("Intent refs"):
            report.error("ARTIFACT_GRAPH_MISMATCH", relpath(path, root), "description files must contain at least one `Intent ref`")
        if not refs.get("Blueprint refs") and not refs.get("Decision refs"):
            report.error(
                "ARTIFACT_GRAPH_MISMATCH",
                relpath(path, root),
                "description files must contain at least one `Blueprint ref` or `Decision ref`",
            )
        source_nodes = parse_bullet_tree(by_name.get("Source Surface", []))
        source_items = [str(node["text"]).strip() for node in source_nodes]
        if not title_line.startswith("# Description: "):
            report.error("ARTIFACT_SCHEMA_MISMATCH", relpath(path, root), "description files must use `# Description: <source file name>` as the H1")
        if len(source_items) != 1:
            report.error("ARTIFACT_SCHEMA_MISMATCH", relpath(path, root), "`Source Surface` must list exactly one source path")
        for item in source_items:
            source_path = extract_path_item(item, path, "ARTIFACT_SCHEMA_MISMATCH")
            if source_path is None:
                continue
            if not (root / source_path).exists():
                report.error(
                    "ARTIFACT_SCHEMA_MISMATCH",
                    relpath(path, root),
                    f"`Source Surface` path does not resolve: {source_path}",
                )
                continue
            if title_line.startswith("# Description: "):
                heading_name = strip_backticks(title_line[len("# Description: ") :].strip())
                if heading_name != Path(source_path).name:
                    report.error(
                        "ARTIFACT_SCHEMA_MISMATCH",
                        relpath(path, root),
                        "`Description` H1 must match the source file name named in `Source Surface`",
                    )
    if artifact_type == "feature":
        validate_required_field_order(root, path, "Definition", by_name.get("Definition", []), FEATURE_DEFINITION_FIELDS)
        validate_structured_local_targets(
            root,
            path,
            "Required Outcomes",
            by_name.get("Required Outcomes", []),
            FEATURE_OUTCOME_FIELDS,
            "Outcome ID",
            LOCAL_NAME_RE,
            "kebab-case local ID",
        )
    if artifact_type == "scenario":
        validate_required_subheading_order(root, path, "Details", by_name.get("Details", []), SCENARIO_DETAIL_HEADINGS)
        validate_structured_local_targets(
            root,
            path,
            "Checks (Scenario)",
            by_name.get("Checks (Scenario)", []),
            SCENARIO_CHECK_FIELDS,
            "Check ID",
            LOCAL_NAME_RE,
            "kebab-case local ID",
        )
    if artifact_type == "behavior":
        validate_required_field_order(root, path, "Definitions", by_name.get("Definitions", []), BEHAVIOR_DEFINITION_FIELDS)
        validate_structured_local_targets(
            root,
            path,
            "Checks (Behavior)",
            by_name.get("Checks (Behavior)", []),
            BEHAVIOR_CHECK_FIELDS,
            "Check ID",
            LOCAL_NAME_RE,
            "kebab-case local ID",
        )
    if artifact_type == "blueprint":
        scope_fields = validate_required_field_order(root, path, "Scope and Consumers", by_name.get("Scope and Consumers", []), BLUEPRINT_SCOPE_FIELDS)
        target_node = scope_fields.get("Intent targets", {}).get("node")
        target_items = node_items(target_node) if target_node is not None else []
        validate_intent_target_items(root, path, "Intent targets", target_items, allow_none=False)
    if artifact_type == "blueprint" and not any(line.strip() for line in by_name.get("Contract", [])):
        report.error("ARTIFACT_SCHEMA_MISMATCH", relpath(path, root), "`Contract` must contain the Blueprint definition")


def resolve_outgoing_artifact_refs(root: Path, graph_nodes: dict[str, dict[str, str]], outgoing_refs: list[dict[str, str]]) -> None:
    for ref in outgoing_refs:
        target = graph_nodes.get(ref["target_id"])
        if target is None:
            report.error(
                "BROKEN_ARTIFACT_REF",
                ref["source_path"],
                f"`{ref['field_name']}` references unknown artifact ID `{ref['target_id']}`",
            )
            continue
        if normalize_relpath(ref["target_path"]) != normalize_relpath(target["path"]):
            report.error(
                "BROKEN_ARTIFACT_REF",
                ref["source_path"],
                f"`{ref['field_name']}` path `{ref['target_path']}` does not match `{ref['target_id']}` at `{target['path']}`",
            )
        allowed_types = ARTIFACT_REF_TARGET_TYPES.get(ref["field_name"])
        if allowed_types is not None and target["type"] not in allowed_types:
            report.error(
                "ARTIFACT_GRAPH_MISMATCH",
                ref["source_path"],
                f"`{ref['field_name']}` must target {describe_allowed_types(allowed_types)}; got `{ref['target_id']}` of type `{target['type']}`",
            )


def validate_assurance_scope_relations(root: Path, global_baseline_ids: set[str], scoped_catalogs: list[dict[str, Any]]) -> None:
    if scoped_catalogs and not global_baseline_ids:
        for catalog in scoped_catalogs:
            report.error(
                "ARTIFACT_GRAPH_MISMATCH",
                catalog["path"],
                "scoped assurance catalogs require a global baseline catalog at `intents/system/assurances.md`",
            )
        return

    for catalog in scoped_catalogs:
        disposition_ids = {entry["assurance_id"] for entry in catalog["dispositions"] if entry["assurance_id"]}
        missing = sorted(global_baseline_ids - disposition_ids)
        extra = sorted(disposition_ids - global_baseline_ids)
        for assurance_id in missing:
            report.error(
                "ARTIFACT_GRAPH_MISMATCH",
                catalog["path"],
                f"`Baseline Disposition` is missing inherited assurance `{assurance_id}`",
            )
        for assurance_id in extra:
            report.error(
                "ARTIFACT_GRAPH_MISMATCH",
                catalog["path"],
                f"`Baseline Disposition` references unknown baseline assurance `{assurance_id}`",
            )
        if any(entry["disposition"] == "Overrides" for entry in catalog["dispositions"]) and not catalog["scoped_ids"]:
            report.error(
                "ARTIFACT_GRAPH_MISMATCH",
                catalog["path"],
                "`Overrides` dispositions require at least one scoped assurance entry",
            )


def validate_durable_artifact_graph(root: Path) -> None:
    candidate_paths = collect_candidate_artifact_paths(root)
    if not candidate_paths:
        report.error("MISSING_DURABLE_ARTIFACTS", root.as_posix(), "target repo has no durable artifacts to validate")
        return

    graph_nodes = collect_runtime_ref_nodes(root)
    outgoing_refs: list[dict[str, str]] = []
    global_baseline_ids: set[str] = set()
    scoped_catalogs: list[dict[str, Any]] = []

    for path in candidate_paths:
        candidate_type = classify_candidate_artifact(path, root)
        if candidate_type is None:
            continue

        text = read_text(path)
        if text is None:
            continue

        frontmatter, body = parse_frontmatter(text, path, root)
        frontmatter_result = validate_frontmatter_for_candidate(root, path, candidate_type, frontmatter)
        if frontmatter_result is None:
            continue
        node_id, id_type = frontmatter_result
        if not node_id or not id_type:
            continue
        register_graph_node(graph_nodes, root, node_id, path, id_type)

        if id_type == "goal-catalog":
            validate_goal_catalog(root, path, body, outgoing_refs, graph_nodes)
        elif id_type == "assurance-catalog":
            validate_assurance_catalog(root, path, body, outgoing_refs, graph_nodes, global_baseline_ids, scoped_catalogs)
        else:
            validate_file_backed_artifact(root, path, body, id_type, node_id, outgoing_refs)

    resolve_outgoing_artifact_refs(root, graph_nodes, outgoing_refs)
    validate_assurance_scope_relations(root, global_baseline_ids, scoped_catalogs)


def check_source_package(root: Path) -> None:
    entry_path = root / "methodology" / "IDD.md"
    entry_text = read_text(entry_path)
    runtime_surface = None
    if entry_text is not None:
        match = RUNTIME_ENTRY_RE.search(entry_text)
        if not match:
            report.error(
                "MISSING_RUNTIME_ENTRYPOINT",
                relpath(entry_path),
                "entry document must declare `Runtime entrypoint: <FILENAME>.md`",
            )
        else:
            runtime_name = match.group("filename")
            if runtime_name in {"IDD.md", "ARTIFACTS.md", "LIBRARY.md", "LABELS.md"}:
                report.error(
                    "INVALID_RUNTIME_ENTRYPOINT",
                    relpath(entry_path),
                    f"`{runtime_name}` is not a valid runtime entrypoint filename",
                )
            else:
                runtime_surface = f"methodology/{runtime_name}"
    for relative in REQUIRED_SOURCE_FILES:
        path = root / relative
        if not path.is_file():
            report.error("MISSING_SOURCE_SURFACE", relpath(path), "required source package surface is missing")
    if runtime_surface is not None:
        path = root / runtime_surface
        if not path.is_file():
            report.error("MISSING_SOURCE_SURFACE", relpath(path), "declared runtime entrypoint surface is missing")
    validate_arc_templates(root, root)
    validate_library_pass_entrypoints(root, root)
    validate_source_pass_support_docs(root)
    validate_pass_docs(root, root)
    validate_claim_docs(root, root)


def parse_arc(root: Path) -> tuple[dict[str, Any] | None, dict[str, dict[str, str]]]:
    arc_path = root / ".methodologies" / "idd" / "scratch" / "arc" / "arc.md"
    text = read_text(arc_path)
    if text is None:
        return None, {}
    sections = parse_sections(text)
    found_order = [section["name"] for section in sections]
    for required in REQUIRED_ARC_SECTIONS:
        if required not in found_order:
            report.error("ARC_SCHEMA_MISMATCH", relpath(arc_path, root), f"missing required section `{required}`")
    by_name = sections_by_name(sections)

    parsed_sections: dict[str, dict[str, dict[str, Any]]] = {}
    for section_name, fields in ARC_FIELDS.items():
        parsed_sections[section_name] = parse_fields(by_name.get(section_name, []), fields)
        for field_name in fields:
            if field_name not in parsed_sections[section_name]:
                report.error("ARC_SCHEMA_MISMATCH", relpath(arc_path, root), f"missing field `{field_name}` in section `{section_name}`")

    metadata = parsed_sections["Metadata"]
    arc_id = field_value(metadata, "Arc ID")
    arc_status = field_value(metadata, "Arc Status")
    if arc_status and arc_status not in ARC_STATUSES:
        report.error("ARC_STATUS_MISMATCH", relpath(arc_path, root), f"unsupported Arc Status `{arc_status}`")
    updated_at = field_value(metadata, "Updated at")
    if updated_at:
        validate_timestamp(updated_at, "ARC_SCHEMA_MISMATCH", arc_path)

    final_validation = parsed_sections["Final Validation"]
    validation_status = field_value(final_validation, "Validation status")
    if validation_status and validation_status not in VALIDATION_STATUSES:
        report.error(
            "ARC_SCHEMA_MISMATCH",
            relpath(arc_path, root),
            f"unsupported Validation status `{validation_status}`",
        )

    register_entries: dict[str, dict[str, str]] = {}
    register_order: list[str] = []
    current_entry: dict[str, str] | None = None
    current_bullets: dict[str, str] = {}
    current_bullet_order: list[str] = []

    def finalize_entry() -> None:
        nonlocal current_entry, current_bullets, current_bullet_order
        if current_entry is None:
            return

        entry = dict(current_entry)
        entry["bullet_order"] = ",".join(current_bullet_order)
        for bullet_name in REQUIRED_REGISTER_BULLETS:
            value = current_bullets.get(bullet_name, "").strip()
            if not value:
                report.error(
                    "STEP_REGISTER_MISMATCH",
                    relpath(arc_path, root),
                    f"`{entry['step_id']}` is missing required Step Register bullet `{bullet_name}`",
                )
            entry[bullet_name] = value

        positions: list[int] = []
        for bullet_name in REQUIRED_REGISTER_BULLETS:
            if bullet_name in current_bullet_order:
                positions.append(current_bullet_order.index(bullet_name))
        if len(positions) == len(REQUIRED_REGISTER_BULLETS) and positions != sorted(positions):
            report.error(
                "STEP_REGISTER_MISMATCH",
                relpath(arc_path, root),
                f"`{entry['step_id']}` Step Register bullets must keep the required order",
            )

        capability_fit = entry.get("Capability fit", "")
        capability_match = REGISTER_CAPABILITY_RE.match(capability_fit)
        if not capability_match:
            report.error(
                "STEP_REGISTER_MISMATCH",
                relpath(arc_path, root),
                f"`{entry['step_id']}` has invalid `Capability fit` formatting",
            )
        else:
            entry.update({key: value.strip() for key, value in capability_match.groupdict().items()})
            high_count = sum(
                1
                for field_name in ("context", "novelty", "proof", "edit_breadth", "review_burden")
                if entry.get(field_name) == "high"
            )
            if high_count > 1:
                report.error(
                    "STEP_CAPABILITY_MISMATCH",
                    relpath(arc_path, root),
                    f"`{entry['step_id']}` may not declare more than one `high` capability-fit load",
                )

        register_entries[entry["step_id"]] = entry
        register_order.append(entry["step_id"])
        current_entry = None
        current_bullets = {}
        current_bullet_order = []

    for raw_line in by_name.get("Step Register", []):
        stripped = raw_line.strip()
        match = REGISTER_RE.match(stripped)
        if match:
            finalize_entry()
            entry = {key: strip_backticks(value.strip()) for key, value in match.groupdict().items()}
            current_entry = entry
            if entry["status"] not in STEP_STATUSES:
                report.error(
                    "STEP_REGISTER_MISMATCH",
                    relpath(arc_path, root),
                    f"register uses unsupported step status `{entry['status']}` for `{entry['step_id']}`",
                )
            continue
        bullet_match = REGISTER_BULLET_RE.match(raw_line)
        if bullet_match and current_entry is not None:
            bullet_name = bullet_match.group("field").strip()
            bullet_value = strip_backticks((bullet_match.group("value") or "").strip())
            if bullet_name in current_bullets:
                report.error(
                    "STEP_REGISTER_MISMATCH",
                    relpath(arc_path, root),
                    f"`{current_entry['step_id']}` repeats Step Register bullet `{bullet_name}`",
                )
            current_bullets[bullet_name] = bullet_value
            current_bullet_order.append(bullet_name)
            continue
        if current_entry is not None and raw_line.startswith("  ") and stripped:
            continue
        if stripped:
            report.error("ARC_SCHEMA_MISMATCH", relpath(arc_path, root), "Step Register contains a non-machine-checkable line")
    finalize_entry()
    if not register_entries:
        report.error("ARC_SCHEMA_MISMATCH", relpath(arc_path, root), "Step Register has no machine-checkable step lines")

    sorted_order = sorted(register_order, key=sequence_key)
    if register_order != sorted_order:
        report.error("STEP_REGISTER_MISMATCH", relpath(arc_path, root), "Step Register lines must be sorted by step sequence")

    for step_id, entry in register_entries.items():
        depends = entry["depends"]
        if depends != "(none)" and depends not in register_entries:
            report.error("STEP_REGISTER_MISMATCH", relpath(arc_path, root), f"`{step_id}` depends on missing step `{depends}`")
        if depends != "(none)" and sequence_key(depends) >= sequence_key(step_id):
            report.error("STEP_REGISTER_MISMATCH", relpath(arc_path, root), f"`{step_id}` depends on non-earlier step `{depends}`")
        unlocks = [item.strip() for item in entry["unlocks"].split(",")] if entry["unlocks"] != "(none)" else []
        for unlock in [item for item in unlocks if item]:
            if unlock not in register_entries:
                report.error("STEP_REGISTER_MISMATCH", relpath(arc_path, root), f"`{step_id}` unlocks missing step `{unlock}`")
                continue
            if sequence_key(unlock) <= sequence_key(step_id):
                report.error("STEP_REGISTER_MISMATCH", relpath(arc_path, root), f"`{step_id}` unlocks non-later step `{unlock}`")

    closeout = parsed_sections["Closeout"]
    closeout_complete = field_value(closeout, "Arc outcome").lower() == "complete"
    return {
        "path": arc_path,
        "arc_id": arc_id,
        "status": arc_status,
        "validation_status": validation_status,
        "closeout_complete": closeout_complete,
        "register_order": register_order,
        "register_entries": register_entries,
    }, register_entries


def parse_evidence_index(root: Path, arc_id: str) -> dict[str, Any] | None:
    evidence_dir = root / ".methodologies" / "idd" / "scratch" / "evidence" / arc_id
    index_path = evidence_dir / "index.md"
    text = read_text(index_path)
    if text is None:
        return None

    preface = parse_preface_fields(text, EVIDENCE_INDEX_PREFACE_FIELDS)
    for field_name in EVIDENCE_INDEX_PREFACE_FIELDS:
        if field_name not in preface:
            report.error("EVIDENCE_SCHEMA_MISMATCH", relpath(index_path, root), f"missing field `{field_name}` in evidence index preface")
    if preface.get("Arc ID") and preface.get("Arc ID") != arc_id:
        report.error("EVIDENCE_SCHEMA_MISMATCH", relpath(index_path, root), "evidence index `Arc ID` must match `arc.md`")
    if preface.get("Methodology") and preface.get("Methodology") != "IDD":
        report.error("EVIDENCE_SCHEMA_MISMATCH", relpath(index_path, root), "evidence index `Methodology` must be `IDD`")
    expected_arc_path = ".methodologies/idd/scratch/arc/arc.md"
    if preface.get("Arc path") and normalize_relpath(preface.get("Arc path", "")) != expected_arc_path:
        report.error("EVIDENCE_SCHEMA_MISMATCH", relpath(index_path, root), f"evidence index `Arc path` must point to `{expected_arc_path}`")
    expected_evidence_folder = f".methodologies/idd/scratch/evidence/{arc_id}"
    if preface.get("Evidence folder") and normalize_relpath(preface.get("Evidence folder", "")) != expected_evidence_folder:
        report.error("EVIDENCE_SCHEMA_MISMATCH", relpath(index_path, root), f"evidence index `Evidence folder` must point to `{expected_evidence_folder}`")
    for timestamp_field in ("Started", "Ended"):
        value = preface.get(timestamp_field, "")
        if value:
            validate_timestamp(value, "EVIDENCE_SCHEMA_MISMATCH", index_path)

    sections = parse_sections(text)
    order = [section["name"] for section in sections]
    if order != EVIDENCE_INDEX_SECTION_ORDER:
        report.error(
            "EVIDENCE_SCHEMA_MISMATCH",
            relpath(index_path, root),
            "evidence index sections must match the required order",
        )
    by_name = sections_by_name(sections)

    baseline = parse_fields(by_name.get("Baseline Claim Coverage", []), BASELINE_CLAIMS)
    for claim_name in BASELINE_CLAIMS:
        if claim_name not in baseline:
            report.error("EVIDENCE_SCHEMA_MISMATCH", relpath(index_path, root), f"baseline claim coverage is missing {claim_name}")

    conditional = parse_fields(by_name.get("Conditional Claim Coverage", []), CONDITIONAL_CLAIMS)
    for claim_name in CONDITIONAL_CLAIMS:
        if claim_name not in conditional:
            report.error(
                "EVIDENCE_SCHEMA_MISMATCH",
                relpath(index_path, root),
                f"conditional claim coverage is missing {claim_name}",
            )

    return {
        "path": index_path,
        "dir": evidence_dir,
        "preface": preface,
        "baseline": baseline,
        "conditional": conditional,
    }


def parse_evidence_items(root: Path, arc_id: str, evidence_dir: Path) -> dict[str, dict[str, Any]]:
    records: dict[str, dict[str, Any]] = {}
    for item_path in sorted([path for path in evidence_dir.glob("E*.md") if path.is_file()]):
        text = read_text(item_path)
        if text is None:
            continue
        preface = parse_preface_fields(text, EVIDENCE_ITEM_PREFACE_FIELDS)
        for field_name in EVIDENCE_ITEM_PREFACE_FIELDS:
            if field_name not in preface:
                report.error("EVIDENCE_SCHEMA_MISMATCH", relpath(item_path, root), f"missing field `{field_name}` in evidence item preface")
        evidence_id = preface.get("Evidence ID", "") or item_path.stem
        if evidence_id and not item_path.name.startswith(f"{evidence_id}.") and item_path.stem != evidence_id:
            report.error("EVIDENCE_SCHEMA_MISMATCH", relpath(item_path, root), "evidence filename stem must match `Evidence ID`")
        if preface.get("Arc ID") and preface.get("Arc ID") != arc_id:
            report.error("EVIDENCE_SCHEMA_MISMATCH", relpath(item_path, root), "evidence item `Arc ID` must match `arc.md`")
        for timestamp_field in ("Created", "Updated"):
            value = preface.get(timestamp_field, "")
            if value:
                validate_timestamp(value, "EVIDENCE_SCHEMA_MISMATCH", item_path)
        claim_type_path = normalize_relpath(preface.get("Claim type path", ""))
        if claim_type_path and claim_type_path != "." and not (root / claim_type_path).exists():
            report.error("EVIDENCE_SCHEMA_MISMATCH", relpath(item_path, root), f"`Claim type path` does not resolve: {claim_type_path}")

        sections = parse_sections(text)
        order = [section["name"] for section in sections]
        if order != EVIDENCE_ITEM_SECTION_ORDER:
            report.error(
                "EVIDENCE_SCHEMA_MISMATCH",
                relpath(item_path, root),
                "evidence item sections must match the required order",
            )
        by_name = sections_by_name(sections)
        for section_name in EVIDENCE_ITEM_SECTION_ORDER:
            if section_name not in by_name:
                report.error("EVIDENCE_SCHEMA_MISMATCH", relpath(item_path, root), f"missing required section `{section_name}`")
        verdict = parse_fields(by_name.get("Verdict", []), ["Current verdict", "Verdict rationale", "Confidence or strength (optional)"])
        if "Current verdict" not in verdict or not field_value(verdict, "Current verdict"):
            report.error("EVIDENCE_SCHEMA_MISMATCH", relpath(item_path, root), "evidence item must populate `Verdict > Current verdict`")

        records[evidence_id] = {"path": item_path, "preface": preface}
    return records


def validate_reference_items(root: Path, step_path: Path, parsed_fields: dict[str, dict[str, Any]]) -> None:
    refs = parsed_fields["References"]
    code_like_fields = {"Code refs", "Description refs", "Test refs"}
    for field_name in ("Intent refs", "Blueprint refs", "Code refs", "Description refs", "Test refs", "Decision refs"):
        items = field_items(refs, field_name)
        if not items:
            report.error("BROKEN_TRACE_REF", relpath(step_path, root), f"`{field_name}` is missing a machine-checkable ref item")
            continue
        if any(is_none_item(item) for item in items) and len(items) != 1:
            report.error("BROKEN_TRACE_REF", relpath(step_path, root), f"`{field_name}` cannot mix `(none)` with real refs")
            continue
        for item in items:
            parsed_path = extract_path_item(item, step_path, "BROKEN_TRACE_REF")
            if parsed_path is None:
                continue
            if field_name not in code_like_fields and not (root / parsed_path).exists():
                report.error("BROKEN_TRACE_REF", relpath(step_path, root), f"`{field_name}` path does not resolve: {parsed_path}")


def validate_step_grouped_field(
    root: Path,
    step_path: Path,
    section_name: str,
    lines: list[str],
    field_name: str,
    expected_fields: list[str],
) -> dict[str, list[str]]:
    _, section_fields = build_field_map(parse_bullet_tree(lines), step_path, root, "STEP_SCHEMA_MISMATCH")
    node = section_fields.get(field_name, {}).get("node")
    if node is None:
        return {}

    found_order, nested_fields = nested_field_map(node, step_path, root, "STEP_SCHEMA_MISMATCH")
    if found_order != expected_fields:
        report.error(
            "STEP_SCHEMA_MISMATCH",
            relpath(step_path, root),
            f"`{section_name} > {field_name}` fields do not match the required order",
        )

    result: dict[str, list[str]] = {}
    for nested_name in expected_fields:
        if nested_name not in nested_fields:
            report.error(
                "STEP_SCHEMA_MISMATCH",
                relpath(step_path, root),
                f"`{section_name} > {field_name}` is missing `{nested_name}`",
            )
            result[nested_name] = []
            continue
        items = node_items(nested_fields[nested_name]["node"])
        if not items:
            report.error(
                "STEP_SCHEMA_MISMATCH",
                relpath(step_path, root),
                f"`{section_name} > {field_name} > {nested_name}` must contain at least one item",
            )
        result[nested_name] = items
    return result


def validate_envelope_items(root: Path, step_path: Path, parsed_fields: dict[str, dict[str, Any]], status_info: dict[str, Any] | None) -> None:
    envelope = parsed_fields["Constraint Envelope"]
    for field_name in ("Write scope", "Read-only scope", "Forbidden scope"):
        items = field_items(envelope, field_name)
        if not items:
            report.error("STEP_SCHEMA_MISMATCH", relpath(step_path, root), f"`{field_name}` is missing a machine-checkable path item")
            continue
        if any(is_none_item(item) for item in items) and len(items) != 1:
            report.error("STEP_SCHEMA_MISMATCH", relpath(step_path, root), f"`{field_name}` cannot mix `(none)` with real paths")
            continue
        for item in items:
            parsed_path = extract_path_item(item, step_path, "STEP_SCHEMA_MISMATCH")
            if parsed_path is None:
                continue
            if status_info is None:
                continue
            if not path_in_operating_scope(parsed_path, status_info):
                report.error("STEP_SCOPE_MISMATCH", relpath(step_path, root), f"`{field_name}` path is outside Operating scope: {parsed_path}")
                continue
            permission = effective_permission(parsed_path, status_info)
            if field_name == "Write scope" and permission != "read_write":
                report.error("STEP_SCOPE_MISMATCH", relpath(step_path, root), f"`{field_name}` path is not writable under status.md: {parsed_path}")
            if field_name == "Read-only scope" and permission not in {"read_write", "read_only"}:
                report.error("STEP_SCOPE_MISMATCH", relpath(step_path, root), f"`{field_name}` path is not readable under status.md: {parsed_path}")


def parse_step(root: Path, step_path: Path, status_info: dict[str, Any] | None) -> dict[str, Any] | None:
    text = read_text(step_path)
    if text is None:
        return None
    sections = parse_sections(text)
    section_order = [section["name"] for section in sections]
    if section_order != STEP_SECTION_ORDER:
        report.error("STEP_SCHEMA_MISMATCH", relpath(step_path, root), "step headings do not match the required order")
    by_name = sections_by_name(sections)

    parsed_fields: dict[str, dict[str, dict[str, Any]]] = {}
    for section_name, expected_fields in STEP_FIELDS.items():
        parsed_fields[section_name] = parse_fields(by_name.get(section_name, []), expected_fields)
        for field_name in expected_fields:
            if field_name not in parsed_fields[section_name]:
                report.error(
                    "STEP_SCHEMA_MISMATCH",
                    relpath(step_path, root),
                    f"missing field `{field_name}` in section `{section_name}`",
                )

    metadata = parsed_fields["Metadata"]
    step_id = field_value(metadata, "Step ID") or step_path.stem
    title = field_value(metadata, "Title")
    status = field_value(metadata, "Status")
    owner = field_value(metadata, "Owner")
    if step_id and step_id != step_path.stem:
        report.error("STEP_SCHEMA_MISMATCH", relpath(step_path, root), "step filename stem must match `Step ID`")
    if status and status not in STEP_STATUSES:
        report.error("INVALID_STEP_STATUS", relpath(step_path, root), f"unsupported step status `{status}`")
    if owner and owner not in {"user", "agent", "shared"}:
        report.error("STEP_SCHEMA_MISMATCH", relpath(step_path, root), f"unsupported owner `{owner}`")
    for field in ("Created at", "Updated at"):
        value = field_value(metadata, field)
        if value:
            validate_timestamp(value, "STEP_SCHEMA_MISMATCH", step_path)

    capability = parsed_fields["Capability Fit"]
    high_count = 0
    for load_field in ("Context load", "Novelty load", "Proof load", "Edit breadth", "Review burden"):
        value = field_value(capability, load_field)
        if value and value not in LOAD_VALUES:
            report.error("STEP_SCHEMA_MISMATCH", relpath(step_path, root), f"unsupported `{load_field}` value `{value}`")
        if value == "high":
            high_count += 1
    if high_count > 1:
        report.error("STEP_CAPABILITY_MISMATCH", relpath(step_path, root), "a step may not declare more than one `high` capability-fit load")

    dep_posture = field_value(parsed_fields["Constraint Envelope"], "External dependency posture")
    if dep_posture and dep_posture not in EXTERNAL_DEP_POSTURES:
        report.error("STEP_SCHEMA_MISMATCH", relpath(step_path, root), f"unsupported External dependency posture `{dep_posture}`")

    validate_reference_items(root, step_path, parsed_fields)
    validate_envelope_items(root, step_path, parsed_fields, status_info)

    planned_delta = parsed_fields["Planned Layer Delta"]
    references = parsed_fields["References"]
    for delta_field, refs_field in (
        ("Intent", "Intent refs"),
        ("Blueprint", "Blueprint refs"),
        ("Code", "Code refs"),
        ("Descriptions", "Description refs"),
        ("Tests", "Test refs"),
    ):
        delta_value = field_value(planned_delta, delta_field)
        if not delta_value:
            report.error(
                "STEP_SCHEMA_MISMATCH",
                relpath(step_path, root),
                f"`Planned Layer Delta > {delta_field}` must be populated; use `(none)` when not applicable",
            )
        ref_items = field_items(references, refs_field)
        has_refs = any(not is_none_item(item) for item in ref_items)
        if delta_value and not is_none_item(delta_value) and not has_refs:
            report.error(
                "STEP_SCHEMA_MISMATCH",
                relpath(step_path, root),
                f"non-`(none)` `Planned Layer Delta > {delta_field}` requires matching `{refs_field}`",
            )

    proof_target = parsed_fields["Proof Target"]
    intent_targets = validate_intent_target_items(
        root,
        step_path,
        "Intent targets",
        field_items(proof_target, "Intent targets"),
        allow_none=False,
    )
    required_checks = validate_step_grouped_field(
        root,
        step_path,
        "Proof Target",
        by_name.get("Proof Target", []),
        "Required checks",
        STEP_CHECK_CATEGORY_FIELDS,
    )
    if required_checks and not any(has_non_none_items(items) for items in required_checks.values()):
        report.error(
            "STEP_SCHEMA_MISMATCH",
            relpath(step_path, root),
            "`Proof Target > Required checks` must contain at least one non-`(none)` check item",
        )

    proof_packet = parsed_fields["Proof Packet"]
    evidence_refs = field_value(proof_packet, "Evidence refs")
    checks_run = validate_step_grouped_field(
        root,
        step_path,
        "Proof Packet",
        by_name.get("Proof Packet", []),
        "Checks run",
        STEP_CHECK_CATEGORY_FIELDS,
    )
    results_by_category = validate_step_grouped_field(
        root,
        step_path,
        "Proof Packet",
        by_name.get("Proof Packet", []),
        "Results",
        STEP_CHECK_CATEGORY_FIELDS,
    )
    for verdict_field in ("Intent verdict", "Blueprint verdict", "Code verdict"):
        verdict = field_value(proof_packet, verdict_field)
        if verdict and verdict not in PROOF_VERDICTS:
            report.error("STEP_SCHEMA_MISMATCH", relpath(step_path, root), f"unsupported `{verdict_field}` value `{verdict}`")
    if status in {"proving", "blocked", "complete"} and not evidence_refs:
        report.error("STEP_SCHEMA_MISMATCH", relpath(step_path, root), "`Proof Packet > Evidence refs` must be populated once proof begins")

    outcome = parsed_fields["Outcome"]
    decision = field_value(outcome, "Decision")
    if decision and decision not in OUTCOME_DECISIONS:
        report.error("STEP_SCHEMA_MISMATCH", relpath(step_path, root), f"unsupported `Decision` value `{decision}`")
    if status == "complete" and decision != "complete":
        report.error("STEP_OUTCOME_MISMATCH", relpath(step_path, root), "completed step must use `Decision: complete`")
    if status == "blocked" and decision != "block":
        report.error("STEP_OUTCOME_MISMATCH", relpath(step_path, root), "blocked step must use `Decision: block`")

    run_ledger_lines = by_name.get("Run Ledger", [])
    log_entries: list[dict[str, str]] = []
    for line in run_ledger_lines:
        stripped = line.strip()
        if not stripped.startswith("- "):
            continue
        match = RUN_LEDGER_RE.match(stripped)
        if not match:
            report.error("STEP_SCHEMA_MISMATCH", relpath(step_path, root), "Run Ledger line is not machine-checkable")
            continue
        entry = {key: strip_backticks(value.strip()) for key, value in match.groupdict().items()}
        validate_timestamp(entry["timestamp"], "STEP_SCHEMA_MISMATCH", step_path)
        before = entry["before"]
        after = entry["after"]
        if before not in STEP_STATUSES or after not in STEP_STATUSES:
            report.error("INVALID_STEP_STATUS", relpath(step_path, root), "Run Ledger uses unsupported step status")
        elif before != after and (before, after) not in VALID_STEP_TRANSITIONS:
            report.error(
                "INVALID_STATUS_TRANSITION",
                relpath(step_path, root),
                f"Run Ledger transition `{before} -> {after}` is not allowed",
            )
        log_entries.append(entry)

    if not log_entries:
        report.error("STEP_SCHEMA_MISMATCH", relpath(step_path, root), "Run Ledger must contain at least one machine-checkable entry")
    else:
        expected_ids = [f"L{index:02d}" for index in range(1, len(log_entries) + 1)]
        actual_ids = [entry["entry_id"] for entry in log_entries]
        if actual_ids != expected_ids:
            report.error("STEP_SCHEMA_MISMATCH", relpath(step_path, root), "Run Ledger entry IDs must be sequential starting at `L01`")
        final_after = log_entries[-1]["after"]
        if status and final_after != status:
            report.error("STEP_SCHEMA_MISMATCH", relpath(step_path, root), "last Run Ledger `Status after` must match the step `Status`")

    if status == "complete":
        for section_name, field_name in (
            ("Proof Packet", "Evidence refs"),
            ("Review Packet", "Change summary"),
            ("Review Packet", "Artifacts changed"),
            ("Review Packet", "Reviewer focus"),
            ("Review Packet", "Downstream assumptions"),
            ("Review Packet", "Handoff summary"),
            ("Outcome", "Reason"),
            ("Outcome", "Step summary"),
        ):
            value = field_value(parsed_fields[section_name], field_name)
            if not value:
                report.error("STEP_CLOSEOUT_MISMATCH", relpath(step_path, root), f"completed step must populate `{section_name} > {field_name}`")
        for category in STEP_CHECK_CATEGORY_FIELDS:
            if has_non_none_items(required_checks.get(category, [])) and not has_completed_proof_items(checks_run.get(category, [])):
                report.error(
                    "STEP_CLOSEOUT_MISMATCH",
                    relpath(step_path, root),
                    f"completed step must record executed `{category}` under `Proof Packet > Checks run`",
                )
            if has_non_none_items(required_checks.get(category, [])) and not has_completed_proof_items(results_by_category.get(category, [])):
                report.error(
                    "STEP_CLOSEOUT_MISMATCH",
                    relpath(step_path, root),
                    f"completed step must record `{category}` under `Proof Packet > Results`",
                )
        residual_gaps = field_value(proof_packet, "Residual gaps")
        if residual_gaps and not is_none_like(residual_gaps):
            report.error("STEP_CLOSEOUT_MISMATCH", relpath(step_path, root), "completed step must not leave `Residual gaps` open")

    return {
        "path": step_path,
        "step_id": step_id,
        "title": title,
        "status": status,
        "goal": field_value(parsed_fields["Step Charter"], "Goal"),
        "done_when": field_value(parsed_fields["Step Charter"], "Done when"),
        "depends_on": field_value(parsed_fields["Step Charter"], "Depends on"),
        "intent_targets": intent_targets,
        "evidence_run": field_value(parsed_fields["Working Record"], "Evidence run"),
        "active_evidence": parse_evidence_ids(field_value(parsed_fields["Working Record"], "Active evidence")),
        "proof_evidence_refs": parse_evidence_ids(evidence_refs),
        "capability_loads": {
            "context": field_value(capability, "Context load"),
            "novelty": field_value(capability, "Novelty load"),
            "proof": field_value(capability, "Proof load"),
            "edit_breadth": field_value(capability, "Edit breadth"),
            "review_burden": field_value(capability, "Review burden"),
        },
        "log_entries": log_entries,
    }


def validate_runtime(root: Path) -> None:
    status_info = parse_status(root)
    arc, register_entries = parse_arc(root)
    if arc is None:
        return
    arc_id = str(arc.get("arc_id", "")).strip()
    if not arc_id:
        report.error("ARC_SCHEMA_MISMATCH", relpath(arc["path"], root), "`Metadata > Arc ID` must be populated")
        return

    evidence_index = parse_evidence_index(root, arc_id)
    evidence_items: dict[str, dict[str, Any]] = {}
    if evidence_index is not None:
        evidence_items = parse_evidence_items(root, arc_id, evidence_index["dir"])

    arc_dir = root / ".methodologies" / "idd" / "scratch" / "arc"
    step_paths = sorted(
        [path for path in arc_dir.glob("step-*.md") if path.is_file()],
        key=lambda item: sequence_key(item.stem),
    )
    done_paths = list((arc_dir / "_done").glob("step-*.md")) if (arc_dir / "_done").is_dir() else []
    for path in done_paths:
        report.error("STEP_LOCATION_MISMATCH", relpath(path, root), "completed steps must remain in the main Arc folder; `_done/` is not part of this workflow")

    step_records: dict[str, dict[str, Any]] = {}
    for path in step_paths:
        parsed = parse_step(root, path, status_info)
        if parsed is None:
            continue
        step_id = str(parsed["step_id"])
        step_records[step_id] = parsed
        if step_id not in register_entries:
            report.error("STEP_REGISTER_MISMATCH", relpath(arc["path"], root), f"Step Register is missing `{step_id}`")
            continue
        register_entry = register_entries[step_id]
        if register_entry["status"] != parsed["status"]:
            report.error(
                "STEP_REGISTER_MISMATCH",
                relpath(arc["path"], root),
                f"Step Register status `{register_entry['status']}` does not match `{step_id}` status `{parsed['status']}`",
            )
        if register_entry["title"] != parsed["title"]:
            report.error(
                "STEP_REGISTER_MISMATCH",
                relpath(arc["path"], root),
                f"Step Register title `{register_entry['title']}` does not match `{step_id}` title `{parsed['title']}`",
            )
        if register_entry["done"] != parsed["done_when"]:
            report.error(
                "STEP_REGISTER_MISMATCH",
                relpath(arc["path"], root),
                f"Step Register `Done when` does not match `{step_id}`",
            )
        if register_entry["depends"] != parsed["depends_on"]:
            report.error(
                "STEP_REGISTER_MISMATCH",
                relpath(arc["path"], root),
                f"Step Register `Depends on` does not match `{step_id}`",
            )
        if register_entry.get("Goal", "") != parsed["goal"]:
            report.error(
                "STEP_REGISTER_MISMATCH",
                relpath(arc["path"], root),
                f"Step Register `Goal` does not match `{step_id}`",
            )
        for field_name, register_key in (
            ("context", "Context load"),
            ("novelty", "Novelty load"),
            ("proof", "Proof load"),
            ("edit_breadth", "Edit breadth"),
            ("review_burden", "Review burden"),
        ):
            if register_entry.get(field_name) != parsed["capability_loads"][field_name]:
                report.error(
                    "STEP_REGISTER_MISMATCH",
                    relpath(arc["path"], root),
                    f"Step Register `{register_key}` does not match `{step_id}`",
                )

    ordered_entries = [register_entries[step_id] for step_id in arc["register_order"] if step_id in register_entries]
    active_candidates = [entry for entry in ordered_entries if entry["status"] != "complete"]
    active_step_id = active_candidates[0]["step_id"] if active_candidates else None

    required_step_files = {
        step_id
        for step_id, entry in register_entries.items()
        if entry["status"] != "planned"
    }
    if active_step_id is not None:
        required_step_files.add(active_step_id)

    for step_id in required_step_files:
        if step_id not in step_records:
            report.error(
                "STEP_REGISTER_MISMATCH",
                relpath(arc["path"], root),
                f"Step `{step_id}` requires a step file in the Arc folder",
            )

    for step_id, record in step_records.items():
        status = register_entries.get(step_id, {}).get("status")
        if status == "planned" and step_id != active_step_id:
            report.error(
                "STEP_REGISTER_MISMATCH",
                relpath(record["path"], root),
                "future `planned` steps must keep their detail in `arc.md` until they become active",
            )
        expected_evidence_run = f".methodologies/idd/scratch/evidence/{arc_id}"
        if record.get("evidence_run") and normalize_relpath(str(record["evidence_run"])) != expected_evidence_run:
            report.error(
                "STEP_EVIDENCE_MISMATCH",
                relpath(record["path"], root),
                f"`Working Record > Evidence run` must point to `{expected_evidence_run}`",
            )
        for evidence_id in record.get("active_evidence", []) + record.get("proof_evidence_refs", []):
            if evidence_id not in evidence_items:
                report.error(
                    "STEP_EVIDENCE_MISMATCH",
                    relpath(record["path"], root),
                    f"step references missing evidence item `{evidence_id}`",
                )
        for entry in record.get("log_entries", []):
            for evidence_id in parse_evidence_ids(entry.get("evidence", "")):
                if evidence_id not in evidence_items:
                    report.error(
                        "STEP_EVIDENCE_MISMATCH",
                        relpath(record["path"], root),
                        f"Run Ledger references missing evidence item `{evidence_id}`",
                    )

    if active_candidates:
        active = active_candidates[0]
        for later in active_candidates[1:]:
            if later["status"] != "planned":
                report.error(
                    "STEP_ORDER_MISMATCH",
                    relpath(arc["path"], root),
                    "later steps must remain `planned` while an earlier step is open",
                )
        expected_arc_status = {
            "planned": "planning",
            "shaped": "shaped",
            "executing": "executing",
            "proving": "proving",
            "blocked": "blocked",
        }.get(str(active["status"]), "")
        actual_arc_status = str(arc["status"])
        if expected_arc_status and actual_arc_status != expected_arc_status:
            report.error(
                "ARC_STATUS_MISMATCH",
                relpath(arc["path"], root),
                f"Arc Status `{actual_arc_status}` does not match expected `{expected_arc_status}`",
            )
        if actual_arc_status in {"finalizing", "complete"}:
            report.error("ARC_STATUS_MISMATCH", relpath(arc["path"], root), "Arc may not be `finalizing` or `complete` while an open step remains")
    elif ordered_entries:
        actual_arc_status = str(arc["status"])
        if actual_arc_status not in {"finalizing", "complete"}:
            report.error("ARC_STATUS_MISMATCH", relpath(arc["path"], root), "Arc must be `finalizing` or `complete` when every step is complete")
        if actual_arc_status == "complete":
            if arc["validation_status"] != "passed":
                report.error("ARC_STATUS_MISMATCH", relpath(arc["path"], root), "Arc `complete` requires `Final Validation > Validation status: passed`")
            if not arc["closeout_complete"]:
                report.error("ARC_STATUS_MISMATCH", relpath(arc["path"], root), "Arc `complete` requires `Closeout > Arc outcome: complete`")
    if str(arc["status"]) == "finalizing" and active_candidates:
        report.error("ARC_STATUS_MISMATCH", relpath(arc["path"], root), "Arc `finalizing` may begin only after every step is complete")

    baseline_started = any(entry["status"] != "planned" for entry in register_entries.values())
    if evidence_index is not None and baseline_started:
        for claim_name in BASELINE_CLAIMS:
            if not field_value(evidence_index["baseline"], claim_name):
                report.error(
                    "EVIDENCE_SCHEMA_MISMATCH",
                    relpath(evidence_index["path"], root),
                    f"baseline claim coverage must populate {claim_name} once execution begins",
                )
        if not evidence_items:
            report.error(
                "EVIDENCE_SCHEMA_MISMATCH",
                relpath(evidence_index["path"], root),
                "Arc evidence run must contain evidence items once execution begins",
            )


try:
    if DO_SOURCE:
        check_source_package(REPO_ROOT)
    if TARGET_ROOT is not None and (DO_RUNTIME or DO_DURABLE):
        validate_installed_package(TARGET_ROOT)
    if DO_RUNTIME:
        if TARGET_ROOT is None:
            report.error("USAGE_ERROR", "<runtime>", "runtime validation requires a target repo")
        else:
            validate_runtime(TARGET_ROOT)
    if DO_DURABLE:
        if TARGET_ROOT is None:
            report.error("USAGE_ERROR", "<durable-artifacts>", "durable artifact validation requires a target repo")
        else:
            validate_durable_artifact_graph(TARGET_ROOT)
except Exception as exc:  # pragma: no cover - defensive CLI handling
    print(f"ERROR INTERNAL <verifier>: {exc}")
    sys.exit(2)

report.summary()
sys.exit(1 if report.errors else 0)
PY
