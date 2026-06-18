#!/bin/bash
set -e

# Jalankan SETELAH reboot (driver GPU sudah aktif).
# Prasyarat: setup.sh sudah dijalankan (repo sudah ter-clone) & sudo reboot sudah dilakukan.

REPO_DIR="$HOME/aina-nano"

echo "=== Verifikasi driver GPU ==="
nvidia-smi

echo "=== Masuk ke repo ==="
cd "$REPO_DIR"

echo "=== Buat virtualenv ==="
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip

echo "=== Install dependencies ==="
pip install -r requirements.txt

echo "=== Install PyTorch GPU ==="
pip install torch

echo "=== Cek device ==="
python scripts/check_device.py

if python scripts/check_device.py | grep -q "cuda_available: True"; then
  echo ""
  echo "GPU siap. Sebelum training, masuk repo & aktifkan venv:"
  echo "  cd $REPO_DIR"
  echo "  source .venv/bin/activate"
else
  echo ""
  echo "ERROR: cuda_available: False — JANGAN lanjut training."
  echo "Cek ulang driver (nvidia-smi) dan instalasi torch."
  exit 1
fi
