# Panduan Setup Server Aina Nano (AWS GPU)

  ## 0. (Opsional) Setup Server Serving Ollama + Nginx + SSL

  Untuk server yang melayani Ollama via domain (Nginx reverse proxy + Let's Encrypt SSL):

  ```bash
  wget -qO- https://raw.githubusercontent.com/mutawakkilalallah/cloud-setup/main/aws-ollama | bash
  ```

  Mencakup: update sistem, driver NVIDIA, paket dasar, mount NVMe + swap 16G,
  Ollama, Nginx reverse proxy ke `127.0.0.1:11434`, firewall, dan SSL certbot.
  Setelah selesai: `sudo reboot`.

  ---

  Setup **training** dibagi 2 tahap karena driver GPU baru aktif setelah reboot.

  ## Tahap 1 — Sistem, Driver, Ollama, Clone Repo

  ```bash
  wget -qO- https://raw.githubusercontent.com/mutawakkilalallah/cloud-setup/main/tiarina_training_setup | bash
  ```

  Mencakup: update sistem, driver NVIDIA, paket dasar, mount disk `/data`,
  Ollama (model di `/data/models`), dan clone repo ke `~/aina-nano`.

  Setelah selesai, **reboot** agar driver GPU aktif:

  ```bash
  sudo reboot
  ```

  ## Tahap 2 — Virtualenv, PyTorch, Cek GPU

  Jalankan **setelah reboot**:

  ```bash
  nvidia-smi
  wget -qO- https://raw.githubusercontent.com/mutawakkilalallah/cloud-setup/main/tiarina_training_post_setup | bash
  ```

  Mencakup: buat venv, install `requirements.txt`, install PyTorch, dan cek device.
  Target output:

  ```
  cuda_available: True
  device: NVIDIA L4
  ```

  > Kalau `cuda_available: False`, script berhenti (`exit 1`) dan **jangan lanjut training**.

  ## Mulai Training

  ```bash
  cd ~/aina-nano
  source .venv/bin/activate
  ```

  Catatan:
  - aws-ollama vs aina-setup tumpang-tindih (keduanya pasang driver + Ollama). aws-ollama ditujukan untuk server serving (ada Nginx+SSL, model di /mnt/models), sedangkan
  aina-setup untuk server training (model di /data/models + clone repo). Jalankan sesuai peran server — biasanya tidak dua-duanya di mesin yang sama.
  - One-liner | bash mengandalkan passwordless sudo (default AMI AWS Ubuntu).
  - Ganti nama aina-setup / aina-setup-post sesuai nama file yang kamu upload ke repo cloud-setup.
