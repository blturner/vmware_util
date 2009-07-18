# ~/bin/vm
#
# Shortcut to VMWare tools for starting and stopping headless VMs
# (I got tired of opening the VMWare Fusion application every time)

# TODO:
# * Show running VMs and enable stopping
# * Check VMWare exists and exit if it doesn't (cross-platform)

startflag=
pauseflag=
stopflag=
while getopts 'sp' OPTION
do
  case $OPTION in
  s)  startflag=1
    ;;
  p)  pauseflag=1
    ;;
  ?)  printf "Usage %s: [-s] [-p] args\n" $(basename $0) >&2
    exit 2
    ;;
  esac
done

VM_DIR="${HOME}/Documents/Virtual Machines.localized"
VMRUN="/Library/Application Support/VMware Fusion/vmrun"

if [ "$startflag" ]
then
  VM_LIST=`find "${VM_DIR}" -name "*.vmwarevm" | grep -v 'Win' | grep -v 'XP'`
  VM_COMMAND="start"
  EXTRA="nogui"
fi

if [ "$pauseflag" ]
then
  VM_LIST=`"${VMRUN}" list`
  VM_COMMAND="suspend"
  EXTRA="soft"
fi

# path separators so I can use spaces in filenames
OLD_IFS=${IFS}; IFS="
"

echo "Choose a non-Windows VM to $VM_COMMAND:"
select opt in $VM_LIST ; do
    # run file
    `"${VMRUN}" "$VM_COMMAND" "${opt}" "${EXTRA}"`
    # repair IFS
    IFS=${OLD_IFS}
    exit 0
done

IFS=${OLD_IFS}
exit 1