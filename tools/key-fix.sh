key_patch(){
  ## Check if the installed rom has treble enabled.
  device=$(file_getprop $home/anykernel.sh device.name1)
  keylayout=/system/vendor/usr/keylayout
  mountpoint=/system
  for i in /system/build.prop /vendor/build.prop /system/system/build.prop /system/vendor/build.prop /system/system/vendor/build.prop; do
    if [ "$(file_getprop $i ro.treble.enabled)" == "true" ]; then
      treble=true
      keylayout=/vendor/usr/keylayout
      mountpoint=/vendor
      break;
    fi
   done
	if [ ! -f $keylayout/ft5x06_ts.kl ]
	then
		ui_print "Mounting $mountpoint as rw"
		mount -o ,rw,remount $mountpoint
		ui_print "Linking Missing Keylayout..."
		cp $keylayout/ft5x06_720p.kl $keylayout/ft5x06_ts.kl
	fi
}



