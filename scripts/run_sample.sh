#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_dir"

# OpenCV's bundled Qt plugin set in this venv only includes xcb.
# Forcing xcb avoids Wayland plugin lookup failures inherited from the desktop session.
export QT_QPA_PLATFORM="xcb"
export QT_QPA_FONTDIR="/usr/share/fonts/TTF"
unset QT_STYLE_OVERRIDE
unset QT_QPA_PLATFORMTHEME

cv2_qt_fonts_dir="$repo_dir/.venv/lib/python3.12/site-packages/cv2/qt/fonts"
if [ ! -e "$cv2_qt_fonts_dir" ]; then
  mkdir -p "$(dirname "$cv2_qt_fonts_dir")"
  ln -s /usr/share/fonts/TTF "$cv2_qt_fonts_dir"
fi

exec "$repo_dir/.venv/bin/python" "$repo_dir/scripts/run_demo.py" \
  --model_dir "$repo_dir/weights/23-36-37/model_best_bp2_serialize.pth" \
  --left_file "$repo_dir/demo_data/left.png" \
  --right_file "$repo_dir/demo_data/right.png" \
  --intrinsic_file "$repo_dir/demo_data/K.txt" \
  --out_dir "$repo_dir/output/sample" \
  --remove_invisible 0 \
  --denoise_cloud 1 \
  --get_pc 1 \
  --show_disp 0 \
  --show_pcl 0 \
  "$@"
