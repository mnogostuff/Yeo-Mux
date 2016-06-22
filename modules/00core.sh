#!/usr/bin/zsh
NEWLINE=$'\n'
LOGGET_MAXTRIES=10
export SLEEPTIME=0.5s

DEBUG() {
    echo $1 >> $YEODIR/yeo.log
}

RANDOM() {
    od -A n -t d -N 3 /dev/urandom | tr -d ' '
}
# ARGCHECK $# 2
ARGCHECK() {
    if  [ $1 -ne $2 ]; then
	echo $3
    fi
}

yeoGetLog() {
    DEBUG $0
    if [ "$#" -ne 2 ]; then
	echo "$0 [WINDOW_NUM] [SEPERATOR]"
	return
    fi
    NUM_TRIES=0
    old_data="0"
    while [ "$NUM_TRIES" -le "$LOGGET_MAXTRIES" ] ; do
	data=`cat ~/.yeo/$1 | awk "/$2/{out=1;} /END$2/{out=0;} {if (out) {print;}}"`
	if [[ $data == $old_data ]]; then
	    # if old_data and data are the same, we've received the final copy of the data
	    break
	else
	    sleep 0.1s
	    old_data=$data
	    if [ "$NUM_TRIES" -gt 1 ]; then
		sleep 0.25s
	    fi
	fi

	let "NUM_TRIES++"
    done
    echo $data
    
}

yeoGetLog__OneLiner() {
    DEBUG $0
    yeoGetLog $1 $2 | tail -n +3
}

yeoRunCommand() {
    DEBUG $0
    if [ "$#" -ne 2 ]; then
	echo "$0 [command] [window_num]"
	return
    fi
    SEPERATOR=`RANDOM`
    tmux attach-session -t yeo\; select-window -t $2 \; send-keys -l "# $SEPERATOR $NEWLINE $1 $NEWLINE $NEWLINE # END$SEPERATOR $NEWLINE"\; detach-client
    echo $SEPERATOR >> $YEODIR/seperators.log
    echo $SEPERATOR
    # there's no convenient way of knowing when it will be done...
}

yeoWriteString() {
    DEBUG $0
    if [ "$#" -ne 2 ]; then
	echo "$0 [string] [window_num]"
	return
    fi
    tmux attach-session -t yeo\; select-window -t $2 \; send-keys -l "$1" \; detach-client
}
yeoRunScriptFile() {
    DEBUG $0
    if [ "$#" -ne 2 ]; then
	echo "$0 [script_file] [window_num]"
	return
    fi
    if [ ! -f $1 ]; then
	echo "ERROR: $1 doesn't exist"
	return
    fi
    data=`cat $1`
   
    yeoRunCommand $data $2
}

yeoPut() {
    DEBUG $0
    if [ "$#" -ne 3 ]; then
	echo "$0 [local_src] [remote_dst] [window_num]"
	return
    fi

    # compress locally, decompress remotely
    data=`cat "$1" | gzip | base64 -w0`
    # send literal -l
    size=`echo $data | wc -c`
    DEBUG "sending file $1 - $size bytes in size"
    yeoRunCommand "echo \$data\" | base64 -d | gunzip > $2"
    #tmux att -t yeo\; select-window -t $3\; send-keys -l "echo \"$data\" | base64 -d | gunzip > $dst${NEWLINE}"\; detatch-client
}

yeoGet() {
    DEBUG $0
    # Start logging in session to local file
    # echo --random seperator
    # execute command
    # echo --seperator
    # stop logging to local file
    # extract from seperator to string
    # write to file
    if [ "$#" -ne 3 ]; then
	echo "$0 [remote_src] [local_dst] [window_num]"
	return
    fi

    yeoRunCommand "cat $1 | gzip | base64 -w0; echo" $3 | read ident
    echo $ident
    yeoGetLog $3 $ident | tail -n +3 | head -n -1 | base64 -di | gunzip >> $2
    #tmux att -t yeo \; pipe-pane -t $3 \; detach-client
    #head -n -1 $tmp_filename.log | tail -n +2 | base64 -di | gunzip > $tmp_filename
    #cp $tmp_filename $2
}

yeoClip() {
    DEBUG $0
    # send to clipboard
    if [ "$#" -ne 1 ]; then
	echo "$0 [file]"
	return
    fi
    tmux att -t yeo \; load-buffer $1
}

yeoRunPythonFile() {
    if [ "$#" -ne 2 ]; then
	echo "$0 [remote_src] [window_num]"
	return
    fi
    data=`cat $1 | base64 -w0`
    
    if [ -z $data ]; then
	echo "Couldn't load $1"
	return
    fi

    yeoRunCommand "echo \"$data\" | base64 -d | python" $3
}

yeoRunPerlFile() {
    if [ "$#" -ne 2 ]; then
	echo "$0 [remote_src] [window_num]"
	return
    fi
    data=`cat $1 | base64 -w0`
    
    if [ -z $data ]; then
	echo "Couldn't load $1"
	return
    fi

    yeoRunCommand "echo \"$data\" | base64 -d | perl" $2
}
