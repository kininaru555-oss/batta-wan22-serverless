#!/usr/bin/env bash
set -uo pipefail

BASE_START="/start-base.sh"

LOG_ROOT="/runpod-volume/logs"

if ! mkdir -p "$LOG_ROOT" 2>/dev/null; then
    LOG_ROOT="/tmp/wan22-worker-logs"
    mkdir -p "$LOG_ROOT"
fi

STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
HOST="$(hostname 2>/dev/null || echo unknown)"

LOG_FILE="$LOG_ROOT/worker-${STAMP}-${HOST}.log"
LATEST_LINK="$LOG_ROOT/latest.log"

ln -sfn "$(basename "$LOG_FILE")" "$LATEST_LINK" 2>/dev/null || true

{
    echo "========================================"
    echo "Batta Wan2.2 Serverless worker boot"
    echo "========================================"
    echo "utc=$STAMP"
    echo "hostname=$HOST"
    echo "log_file=$LOG_FILE"
    echo

    echo "===== NVIDIA GPU ====="
    nvidia-smi || true
    echo

    echo "===== Python / PyTorch ====="

    python3 - <<'PY' || true
import sys

print("python:", sys.version.replace("\n", " "))

try:
    import torch

    print("torch:", torch.__version__)
    print("torch_cuda:", torch.version.cuda)
    print("cuda_available:", torch.cuda.is_available())

    if torch.cuda.is_available():
        print("gpu:", torch.cuda.get_device_name(0))
        print("capability:", torch.cuda.get_device_capability(0))
        print(
            "vram_gb:",
            round(
                torch.cuda.get_device_properties(0).total_memory
                / 1024**3,
                2,
            ),
        )

        # 実際のCUDA kernel実行テスト
        x = torch.zeros(8, device="cuda")
        y = (x + 1).sum().item()

        print("cuda_kernel_test:", y)

except Exception as exc:
    print("torch_probe_error:", repr(exc))
PY

    echo

    echo "===== Network Volume ====="

    mount | grep '/runpod-volume' || true
    df -h /runpod-volume 2>/dev/null || true

    echo
    echo "===== Model directories ====="

    find /runpod-volume/models \
        -maxdepth 2 \
        -type f \
        -printf '%p %s bytes\n' \
        2>/dev/null \
        | sort \
        | head -200 || true

    echo
    echo "===== Starting worker-comfyui ====="

} >> "$LOG_FILE" 2>&1

#
# 元のworker-comfyui /start.shをそのまま実行。
# stdout / stderrを
#
#   RunPod Logs
#   Network Volume
#
# の両方へ出す。
#

set +e

"$BASE_START" 2>&1 \
    | tee -a "$LOG_FILE"

RC=${PIPESTATUS[0]}

set -e

{
    echo
    echo "========================================"
    echo "worker-comfyui exited"
    echo "========================================"

    echo "exit_code=$RC"
    echo "utc=$(date -u +%Y%m%dT%H%M%SZ)"

    echo
    echo "===== Processes ====="

    ps auxww || true

    echo
    echo "===== ComfyUI internal log ====="

    if [ -f /comfyui/user/comfyui.log ]; then

        cat /comfyui/user/comfyui.log || true

        cp \
            /comfyui/user/comfyui.log \
            "$LOG_ROOT/comfyui-${STAMP}-${HOST}.log" \
            2>/dev/null || true

    else
        echo "/comfyui/user/comfyui.log not found"
    fi

    echo
    echo "===== dmesg tail ====="

    dmesg 2>/dev/null | tail -100 || true

} >> "$LOG_FILE" 2>&1

exit "$RC"
