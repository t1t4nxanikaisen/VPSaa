#!/bin/sh
set -e

# Flags you can override with Render environment variables:
#  GOTTY_CREDENTIAL -> "user:pass"  (enable basic auth)
#  GOTTY_FLAGS      -> extra flags (e.g. "--title-format 'MyShell'")
#  GOTTY_CMD        -> what to run (default /bin/bash, set "tmux new -A -s web" to use tmux)
#  GOTTY_PRE_CMD    -> optional pre-start command (e.g. "tmux new -s web -d")
#  PORT             -> Render will set this automatically; default 8080 locally.

flags="${GOTTY_FLAGS:---permit-write}"
if [ -n "${GOTTY_CREDENTIAL:-}" ]; then
  flags="$flags --credential $GOTTY_CREDENTIAL"
fi

port="${PORT:-8080}"
cmd="${GOTTY_CMD:-/bin/bash}"

# Optional pre-start (useful for starting a detached tmux session)
if [ -n "${GOTTY_PRE_CMD:-}" ]; then
  sh -c "${GOTTY_PRE_CMD}" || true
fi

# exec gotty binding to $PORT and 0.0.0.0 so Render can forward traffic
exec gotty --port "$port" --address 0.0.0.0 $flags $cmd
