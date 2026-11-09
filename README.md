# vendor/xiaomi/flute

Redmi Pad 2 Pro (**flute**) için blob tabanlı vendor tree.
Device tree: [device_xiaomi_flute](https://github.com/mahirburaktekin/device_xiaomi_flute)

- **Kaynak:** stock HyperOS **OS3.0.303.0.WPWMIXM** (Global), vendor API 34
- `vendor`, `odm` ve `vendor_dlkm` imajları build sırasında bu blob'lardan oluşturulur.
- Test eden cihaz da aynı firmware'de olmalı (modem/DSP/TrustZone ROM tarafından yazılmıyor).

## Branch'ler

| Branch | Ne için |
|---|---|
| `main` | Ana branch |
| `bringup` | `main` + GKI 6.1.176'nın imzalı `zram.ko`/`zsmalloc.ko`'su + stock `vendor/etc/fstab.qcom` kaldırıldı (temiz fstab device tree'den gelir) |

## İçerik

| Dosya | Ne |
|---|---|
| `proprietary-files.txt` | 3140 blob listesi |
| `flute-vendor.mk` | `PRODUCT_COPY_FILES` + paketler |
| `Android.bp` | 262 symlink, 6 rc (`prebuilt_etc`), 2 `prefer` prebuilt kütüphane |
| `Android.mk` | 13 APK (presigned, preopt kapalı) |
| `proprietary/vendor_ramdisk` | `vendor_boot`'un 330 modülü |
| `proprietary/vendor_dlkm` | 297 modül |

## Stock'tan farklar

ROM'un kendisinin ürettiği ya da sağladığı dosyalar listeden çıkarıldı (ikisi aynı yola yazınca derleme bozuluyordu):

| Çıkarılan / değiştirilen | Neden |
|---|---|
| vendor/odm `build.prop`, VINTF ana manifest ve matris, odex/vdex | Build üretiyor |
| `vendor/etc/linker.config.pb` | Build üretiyor (bağımlılık döngüsü) |
| `vendor/etc/NOTICE.xml.gz`, `odm/etc/NOTICE.xml.gz` | Build üretiyor (imaj dosya listesinde çift kayıt) |
| `android.hardware.cas-service.example` + manifest | `com.android.hardware.cas` APEX'i ile çakışıyordu |
| `libvmmem.so`, `libtinycompress.so` | `PRODUCT_COPY_FILES` yerine `prefer: true` prebuilt. Kopyalanınca aynı adlı kaynak modül de derleniyor ve kernel header'ı istiyordu. |
| `vendor/etc/selinux/vendor_sepolicy.cil` | **Sonuna blok eklendi:** 49 Qualcomm system_ext tipi için 34.0 eşlemesi (stock'ta Xiaomi'nin system_ext'indeydi). |

## Blob'ları yeniden çekme

```bash
./extract-files.sh ~/flute   # vendor_out/, odm_out/, vendor_dlkm_out/ içermeli
```

Dikkat: script `vendor_sepolicy.cil` dosyasının **stock** halini kopyalar. Sonundaki eşleme bloğu
(`; --- flute:` ile başlayan kısım) elle geri eklenmeli. `vendor_boot` modülleri
(`proprietary/vendor_ramdisk`) script tarafından değiştirilmez.
