#!/vendor/bin/sh

setprop ro.vendor.ril.oem.psno `cat /mnt/vendor/persist/serialno/.psno`
setprop ro.vendor.ril.oem.sno `cat /mnt/vendor/persist/serialno/.sno`
if [ -a /mnt/vendor/persist/factory_id/.factory_id ]
then
  setprop ro.vendor.ril.oem.factory_id `cat /mnt/vendor/persist/factory_id/.factory_id`
fi
