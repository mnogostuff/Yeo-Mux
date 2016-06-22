#!/usr/bin/bash
pushd `dirname $0` > /dev/null
export YEODIR=`pwd`
popd > /dev/null
export YEOSCRIPT=$YEODIR/extern
echo "CORE"

export YEODATA=$YEODIR/data
mkdir $YEODATA
echo "MODULES"
for module in ./modules/*; do
    echo "loading "$module
    source $module
done

# load files to tmux past buffer
tmux source-file $PWD/yeomux.conf\; new-session -s yeo\; detach-client

#tmux load-buffer -b 0 $PWD/init.sh
echo "Please run: source YeoMux_Control.sh"
#tmux att -t yeo\; pipe-pane "exec cat >>$HOME/.yeo/`date +%M%Y%d%m%y`'#S#I#W-tmux.log'" \; display-message 'Started logging to $HOME/#H#W-tmux.log'
