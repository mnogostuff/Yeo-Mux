#!/usr/bin/zsh

yeo__IsVirtualMachine() {
    # from https://unix.stackexchange.com/questions/3685/find-out-if-the-os-is-running-in-a-virtual-environment
    # assuming there's no trickery being done to disguise

    if [ "$#" -ne 1 ]; then
	echo "$0 [window_num]"
	return
    fi

    yeoRunScriptFile $YEOSCRIPT/is_vm.sh $1
}

yeo__RootkitCheck() {
    if [ "$#" -ne 1 ]; then
	echo "$0 [window_num]"
	return
    fi

    yeoRunPerlFile $YEOSCRIPT/check_rootkit.pl $1
}

yeo__RootkitCheck_Log() {
    if [ "$#" -ne 1 ]; then
	echo "$0 [window_num]"
	return
    fi

    yeoRootkitCheck $1 | read ident
    sleep $SLEEPTIME # would need to increase by lag...
    yeoGetLog $1 $ident
}

yeo__IsVirtualMachine_Log() {
    if [ "$#" -ne 1 ]; then
	echo "$0 [window_num]"
	return
    fi

    yeo__IsVirtualMachine $1 | read ident
    sleep $SLEEPTIME # would need to increase by lag...
    yeoGetLog $1 $ident    
}
