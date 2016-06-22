# Scripts to run first

yeo__GetHistory() {
    if [ "$#" -ne 1 ]; then
	echo "$0 [window_num]"
	return
    fi
    yeoRunCommand "find /home/ | grep _history | while read hist; do cat \$hist; done" $1 | read ident
    yeoGetLog $1 $ident
    yeoRunCommand "find /root/ | grep _history | while read hist; do cat \$hist; done" $1 | read ident
    yeoGetLog $1 $ident
}

yeo__UnsetHistory() {
    if [ "$#" -ne 1 ]; then
	echo "$0 [window_num]"
	return
    fi
    yeoRunCommand "unset HISTFILE"
}

yeo__ShredHistory() {
    # Use Flame's C&C script to erase history
    if [ "$#" -ne 1 ]; then
	echo "$0 [window_num]"
	return
    fi
    yeoRunScriptFile $YEODIR/extern/flame_c2_erase.sh $1
}

yeo__DisableHistory() {
    # I don't have anything for this presently
    # non-destructively disable further history
    echo "In Progress"
}

yeo__ShowAutorun() {
    if [ "$#" -ne 1 ]; then
	echo "$0 [window_num]"
	return
    fi
    yeoRunScriptFile $YEODIR/extern/boot_explorer.sh $1
}
