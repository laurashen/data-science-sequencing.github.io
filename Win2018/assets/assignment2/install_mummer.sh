wget https://sourceforge.net/projects/mummer/files/mummer/3.23/MUMmer3.23.tar.gz/download
mv download MUMmer3.23.tar.gz
PPWD=$PWD
tar -xvzf MUMmer3.23.tar.gz
cd MUMmer3.23/
make check
make install
echo "export PATH=\"\$PATH:$PPWD/MUMmer3.23/\"" >> ~/.profile
. ~/.profile
