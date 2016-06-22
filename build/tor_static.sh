echo "BUILDING Tor"
echo "Note: requires openssl, libevent, development packages"
echo "This isn't actually static idk what I was thinking, working on this though - maybe somebody else is"
#git clone https://github.com/libevent/libevent
git clone https://github.com/torproject/tor
cd tor/
./autogen.sh
./configure --prefix= --disable-asciidoc --enable-static-libevent --enable-static-openssl --enable-static-zlib  && make 

