#!/usr/bin/zsh
function yeoHiddenService() {
    DEBUG $0
    if [ "$#" -ne 2 ]; then
	echo "$0 [listen_addr] [listen_port]"
	return
    fi
    yeoPut $YEODIR/static/
}
