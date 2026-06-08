# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Kubernetes training course delivered as a sequence of self-contained labs (`00_app` through `10_secrets`). Trainees open it as a GitHub Codespace built from `quay.io/kubermatic-labs/training-ghcs-kubernetes-fundamentals-for-developers-trainee-environment` (see `.devcontainer/devcontainer.json`); `postCreateCommand` runs `/setup_kind_cluster.sh` (provided by the image, not in this repo) to spin up a local kind cluster plus an ingress controller. Trainees source `~/.trainingrc` and run `make verify` against the top-level `makefile` before starting `00_app`.

`INGRESS_IP` and `INGRESS_URL` are exported by `~/.trainingrc` and used verbatim throughout the lab READMEs — assume they exist when editing manifests or instructions.

## Architecture

Two distinct kinds of content live side-by-side:

1. **`00_app/`** — the only real source code: a small Go HTTP server (`main.go`) that exposes `/`, `/liveness`, `/readiness`, and `/downward-api`. It reads its message string from `./conf/app.conf` via `magiconair/properties`, and toggles liveness/readiness in response to `set dead` / `set unready` typed on stdin (this is what powers lab 04's `kubectl attach` flow). It is published as four image variants — `2.0.0`, `2.0.0-A`, `2.0.0-B`, `2.0.0-distroless` — all under `quay.io/kubermatic-labs/training-application`. The `-A`/`-B` variants exist specifically for `06_graceful_shutdown_dragons`.

2. **`NN_<topic>/`** — every other top-level directory is a lab consisting of a `README.md` plus a `k8s/` folder of manifests. Labs do **not** rebuild the application; they pull the already-published `training-application` images and demonstrate one Kubernetes concept by applying YAML and observing behaviour via `curl http://${INGRESS_IP}/...`. Lab READMEs are the authoritative content — they are what trainees read in the rendered Markdown preview.

The devcontainer's `files.exclude` hides `.git/`, `.gitignore`, `.devcontainer/`, `.99_todos/`, `pre-checks.sh`, `makefile`, `.claude/`, and `CLAUDE.md` from the trainee's VS Code file tree. Keep that list in sync when adding new meta files that shouldn't appear in the trainee view.

## Commands

```bash
# Top-level — verify the trainee environment (kind containers, kubectl, helm, INGRESS_IP, image pulls)
make verify

# 00_app — build the Go binary / image (only place with code)
cd 00_app
make build              # local Go binary
make docker-build       # default 2.0.0 image
make docker-push-all    # 2.0.0, -A, -B, -distroless (-distroless uses buildx multi-arch)

# Within any lab
kubectl apply -f k8s/
kubectl delete -f k8s/
```

There is no test suite; verification is manual via `make verify` plus per-lab `curl` checks against `${INGRESS_IP}`.

## Editing conventions

- Lab READMEs are the product. Code blocks must be copy-pasteable as-is into the trainee shell.
- Pinned image tags (`2.0.0`, `2.0.0-A`, `2.0.0-B`, `2.0.0-distroless`) and Kubernetes/Go versions are deliberate — do not bump them as part of unrelated edits.
- `.99_todos/` and `.secrets/` are out of scope for any automated check or edit.
- Placeholders like `TODO`, `XXXXX`, `TODO-STUDENT-EMAIL@...` are intentional fill-in spots — leave them alone.
- The `md-linter` and `code-linter` skills under `.claude/skills/` encode the project's lint rules; prefer invoking them over ad-hoc checks.
