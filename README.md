# vendor/xiaomi/flute — blob tabanlı vendor

Kaynak: stock OS3.0.303.0.WPWMIXM (Android 15 build, vendor API 34).
vendor ve odm imajları AOSP tarafından bu blob'lardan derlenir.

## Kurulum
    ./extract-files.sh ~/flute     # vendor_out, odm_out, vendor_dlkm_out içermeli

## İçerik (gen.py ile stock listeden üretildi)
- proprietary-files.txt : 3145 dosya (3132 kopya + 13 APK)
- flute-vendor.mk       : PRODUCT_COPY_FILES + paketler
- Android.bp            : 262 symlink (install_symlink)
- Android.mk            : 13 APK (presigned, preopt kapalı)
- proprietary/vendor_ramdisk : vendor_boot'un 330 modülü (hazır)
- proprietary/vendor_dlkm    : extract-files.sh doldurur (297 modül)

AOSP'nin kendisinin ürettiği dosyalar listeden çıkarıldı:
vendor/odm build.prop, VINTF ana manifest ve matrix, stock odex/vdex,
/vendor/lib/modules ve /vendor/odm symlink'leri.
