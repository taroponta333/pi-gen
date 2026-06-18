# Check if qemu-arm and /proc/sys/fs/binfmt_misc are present
if [[ "${binfmt_misc_required}" == "1" ]]; then

  if qemu_arm=$(which qemu-arm 2>/dev/null); then
    echo "Found qemu-arm: ${qemu_arm}"
  elif qemu_arm=$(which qemu-arm-static 2>/dev/null); then
    echo "Found qemu-arm-static: ${qemu_arm}"
  else
    echo "qemu-arm not found"
    echo "Install qemu-user-static or qemu-user-binfmt"
    exit 1
  fi

  if [ ! -f /proc/sys/fs/binfmt_misc/register ]; then
    echo "binfmt_misc required but not mounted, trying to mount it..."
    if ! mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc ; then
      echo "mounting binfmt_misc failed"
      exit 1
    fi
    echo "binfmt_misc mounted"
  fi

  if ls /proc/sys/fs/binfmt_misc/qemu-arm* >/dev/null 2>&1; then
    if ! grep -q "^interpreter ${qemu_arm}" /proc/sys/fs/binfmt_misc/qemu-arm* ; then
      reg="echo ':qemu-arm-rpi:M::"\
"\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:"\
"\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:"\
"${qemu_arm}:F' > /proc/sys/fs/binfmt_misc/register"
      echo "Registering qemu-arm for binfmt_misc..."
      sudo bash -c "${reg}" 2>/dev/null || true
    fi
  fi

fi
