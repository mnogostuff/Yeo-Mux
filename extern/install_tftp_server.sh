if [[ ! "$UID" -eq "0" ]]; then
    echo '<!> Needs to bind to port 69, must be root'
    return
fi

old_home=$HOME

DESTDIR=/dev/shm/.data_dir/perl

DATADIR=/dev/shm/.data_dir/data

mkdir $DATADIR

mkdir $DESTDIR

HOME=$DESTDIR

wget -O- http://cpanmin.us | perl - -l ~/perl5 App::cpanminus local::lib Net::TFTPd
eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`
echo 'eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`' >> ~/.profile
echo 'export MANPATH=$HOME/perl5/man:$MANPATH' >> ~/.profile
DESTDIR=/dev/shm/.data_dir/perl

DATADIR=/dev/shm/.data_dir/data

mkdir $DATADIR

mkdir $DESTDIR

HOME=$DESTDIR

~/perl5/bin/tftpd-simple.pl -d /dev/shm/.data_dir/data/
#HOME=$old_home
