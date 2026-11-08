#!/usr/bin/env bash
# Kullanım: ./extract-files.sh ~/flute
# Kaynak klasörde açılmış imajlar olmalı: vendor_out/ odm_out/ vendor_dlkm_out/
set -euo pipefail
SRC="${1:?Kaynak klasör ver (vendor_out, odm_out, vendor_dlkm_out içeren)}"
HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="$HERE/proprietary"
for d in vendor_out odm_out vendor_dlkm_out; do
  [ -d "$SRC/$d" ] || { echo "HATA: $SRC/$d yok"; exit 1; }
done
rm -rf "$OUT/vendor" "$OUT/odm" "$OUT/vendor_dlkm"
miss=0; n=0
while read -r f; do
  case "$f" in ''|\#*) continue;; esac
  part="${f%%/*}"; rest="${f#*/}"
  s="$SRC/${part}_out/$rest"
  if [ -f "$s" ]; then
    mkdir -p "$OUT/$(dirname "$f")"; cp -p "$s" "$OUT/$f"; n=$((n+1))
  else
    echo "EKSİK: $f"; miss=$((miss+1))
  fi
done < "$HERE/proprietary-files.txt"

# vendor_dlkm: modüller + yükleme listeleri (build depmod'u kendisi çalıştırır)
mkdir -p "$OUT/vendor_dlkm/lib/modules"
cp -p "$SRC"/vendor_dlkm_out/lib/modules/*.ko "$OUT/vendor_dlkm/lib/modules/"
for l in modules.load modules.blocklist; do
  [ -f "$SRC/vendor_dlkm_out/lib/modules/$l" ] && cp -p "$SRC/vendor_dlkm_out/lib/modules/$l" "$OUT/vendor_dlkm/lib/modules/"
done
echo "vendor_dlkm: $(ls "$OUT"/vendor_dlkm/lib/modules/*.ko | wc -l) modül"
other=$(cd "$SRC/vendor_dlkm_out" && find . -type f ! -name '*.ko' ! -path './lib/modules/modules.*' ! -path './etc/build.prop')
[ -n "$other" ] && { echo "UYARI: vendor_dlkm'de ele alınmayan dosyalar:"; echo "$other"; }

# APK'larda dex var mı? (stock odex atlandığı için gerekli)
for a in $(grep '\.apk$' "$HERE/proprietary-files.txt"); do
  python3 -c 'import sys,zipfile; z=zipfile.ZipFile(sys.argv[1]); sys.exit(0 if any(n.startswith("classes") and n.endswith(".dex") for n in z.namelist()) or "overlay/" in sys.argv[1] else 1)' "$OUT/$a" \
    || echo "UYARI: dex yok (yalnızca odex ile çalışıyordu): $a"
done
echo "Kopyalanan: $n  Eksik: $miss"
[ "$miss" -eq 0 ]
