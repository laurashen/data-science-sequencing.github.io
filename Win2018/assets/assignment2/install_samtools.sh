wget https://github.com/samtools/samtools/releases/download/1.7/samtools-1.7.tar.bz2
tar -vxjf samtools-1.7.tar.bz2
mkdir -p /home/$1/bin
cd samtools-1.7/
./configure prefix=/home/$1
make
make install
