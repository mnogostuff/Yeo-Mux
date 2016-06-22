echo "WARNING: BLINDLY TRUSTS BUILDS FROM https://github.com/andrew-d/static-binaries/"
echo "(REALLY SHOULDN'T TRUST THINGS)"
#git clone https://github.com/andrew-d/static-binaries
wget -c https://github.com/andrew-d/static-binaries/archive/master.zip -O bin-master.zip
unzip bin-master.zip
cp -r static-binaries-master/binaries/* ../extern/bin/
