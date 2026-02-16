---
name: install-sh
description: 'Activate when the user asks to create a shell installer script for downloading pre-built binaries from GitHub Releases. Triggers include: install script, curl pipe sh, binary installer, release installer, download script. Do NOT activate for package manager installers (brew, apt, npm) or language-specific installers (go install, pip install).'
argument-hint: [github-owner/repo]
license: MIT
compatibility: Designed for Claude Code (and compatible)
metadata:
  author: thesmart
  version: '1.0'
---

# Install Shell Script Generator

You create POSIX-compatible shell installer scripts that download pre-built binaries from GitHub
Releases via `curl -fsSL <url> | sh`.

## Prerequisites

Before writing the script, gather this information from the user or infer from their project:

| Parameter           | Description                                    | Example                |
| ------------------- | ---------------------------------------------- | ---------------------- |
| `REPO`              | GitHub `owner/repo`                            | `thesmart/inigo`       |
| `BINARY`            | Name of the binary / CLI command               | `inigo`                |
| Asset naming        | How release assets are named per platform      | `inigo-darwin-arm64`   |
| Supported platforms | Which OS/arch combinations have release assets | linux, darwin, freebsd |
| Default install dir | Where the binary should be placed              | `~/.local/bin`         |

Infer the asset naming convention from the project's build system (Makefile, GoReleaser,
`.github/workflows`, etc.). Common patterns:

- `{binary}-{os}-{arch}` (e.g. `inigo-darwin-arm64`)
- `{binary}_{os}_{arch}` (e.g. `mytool_linux_amd64`)
- `{binary}-{os}-{arch}.tar.gz` (compressed archive)

## Script Template

```sh
#!/bin/sh
# install.sh — download and install the <BINARY> binary
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/<REPO>/main/install.sh | sh
#
# Environment variables:
#   VERSION      Version tag to install (default: latest release)
#   INSTALL_DIR  Directory to install into (default: ~/.local/bin)

set -eu

REPO="<owner/repo>"
BINARY="<binary-name>"
INSTALL_DIR="${INSTALL_DIR:-${HOME}/.local/bin}"

# --- helpers ---

log() {
  printf '%s\n' "$@"
}

err() {
  printf 'error: %s\n' "$@" >&2
  exit 1
}

# download URL to FILE using curl or wget
download() {
  url="$1"
  file="$2"
  if command -v curl >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -fsSL -o "$file" "$url"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$file" "$url"
  else
    err "curl or wget is required"
  fi
}

# --- detect platform ---

detect_os() {
  case "$(uname -s)" in
    Linux*)  echo "linux" ;;
    Darwin*) echo "darwin" ;;
    FreeBSD*) echo "freebsd" ;;
    *) err "unsupported OS: $(uname -s)" ;;
  esac
}

detect_arch() {
  case "$(uname -m)" in
    x86_64|amd64) echo "amd64" ;;
    aarch64|arm64) echo "arm64" ;;
    *) err "unsupported architecture: $(uname -m)" ;;
  esac
}

# --- resolve version ---

resolve_version() {
  if [ -n "${VERSION:-}" ]; then
    echo "$VERSION"
    return
  fi

  log "fetching latest release..."
  tmpfile=$(mktemp)
  trap 'rm -f "$tmpfile"' EXIT

  download "https://api.github.com/repos/${REPO}/releases/latest" "$tmpfile"

  tag=$(grep '"tag_name"' "$tmpfile" \
    | sed 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
  rm -f "$tmpfile"
  trap - EXIT

  if [ -z "$tag" ]; then
    err "could not determine latest version"
  fi

  echo "$tag"
}

# --- main ---

main() {
  os=$(detect_os)
  arch=$(detect_arch)
  version=$(resolve_version)
  asset="${BINARY}-${os}-${arch}"
  url="https://github.com/${REPO}/releases/download/${version}/${asset}"

  log "installing ${BINARY} ${version} (${os}/${arch})..."

  tmpfile=$(mktemp)
  trap 'rm -f "$tmpfile"' EXIT

  download "$url" "$tmpfile" \
    || err "download failed — check that ${version} has a release asset for ${os}/${arch}"

  mkdir -p "$INSTALL_DIR"
  dest="${INSTALL_DIR}/${BINARY}"
  mv "$tmpfile" "$dest"
  chmod +x "$dest"
  trap - EXIT

  log ""
  log "installed ${BINARY} to ${dest}"

  # hint about PATH if the install directory isn't already on PATH
  case ":${PATH}:" in
    *":${INSTALL_DIR}:"*) ;;
    *)
      log ""
      log "add to your PATH if needed:"
      log "  export PATH=\"${INSTALL_DIR}:\$PATH\""
      ;;
  esac
}

main
```

## Adaptations

Adapt the template based on what you find in the project:

### Compressed archives

If release assets are `.tar.gz` or `.zip`, add an extraction step after download:

```sh
# tar.gz
tar -xzf "$tmpfile" -C "$INSTALL_DIR"

# zip (less common on POSIX)
unzip -o "$tmpfile" -d "$INSTALL_DIR"
```

### OS/arch naming variations

Some projects use different naming. Map `uname` output accordingly:

| `uname -s` | Common names                |
| ---------- | --------------------------- |
| `Linux`    | `linux`, `Linux`            |
| `Darwin`   | `darwin`, `Darwin`, `macos` |
| `FreeBSD`  | `freebsd`, `FreeBSD`        |

| `uname -m`         | Common names             |
| ------------------ | ------------------------ |
| `x86_64`, `amd64`  | `amd64`, `x86_64`, `x64` |
| `aarch64`, `arm64` | `arm64`, `aarch64`       |

### Windows support

If the project ships `.exe` assets, add a Windows/MSYS2/Git Bash case:

```sh
detect_os() {
  case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
    # ...
  esac
}
```

And append `.exe` to the binary name when `os = "windows"`.

### Additional platforms

Only add OS/arch cases that the project actually builds for. Check the project's build matrix
(Makefile, CI config, GoReleaser) and only include those platforms.

## Instructions

1. Read the project's build configuration to determine:
   - Which platforms are built (OS/arch combinations)
   - How release assets are named
   - Whether assets are raw binaries or compressed archives
2. Identify the GitHub `owner/repo` and binary name.
3. Write `install.sh` at the project root using the template, adapted for the project's conventions.
4. Make the script executable: `chmod +x install.sh`
5. Update the project's README with install instructions:
   ```sh
   curl -fsSL https://raw.githubusercontent.com/<REPO>/main/install.sh | sh
   ```
6. Test by running `sh install.sh` locally.
