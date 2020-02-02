#!/bin/sh

# Compile script for CASINO written by Synge Todo

SOURCE="$1"
PREFIX="$2"
PREFIX=`(cd $PREFIX && pwd)`
SCRIPTDIR=`dirname $0`
SCRIPTDIR=`(cd $SCRIPTDIR && pwd)`

if [ -z $PREFIX ]; then
  echo "Usage: $0 source_tarball prefix"
  exit 127
fi

BINDIR="$PREFIX/bin"
SHAREDIR="$PREFIX/share"
CASINODIR="$SHAREDIR/CASINO"

if [ -d "$CASINODIR" ]; then
  echo "Error: CASINO directory exists ($CASINODIR)"
  exit 127
fi

# Extract files from the tarball
if [ -f "$SOURCE" ]; then :; else
  echo "Error: source not found ($SOURCE)"
  exit 127
fi
mkdir -p "$SHAREDIR"
echo "Extracting $SOURCE into $SHAREDIR"
tar zxvf "$SOURCE" -C "$SHAREDIR"

# Compile
echo "Compiling CASINO"
(cd "$CASINODIR" && make CASINO_ARCH=linuxpc-gcc-parallel HAVE_BLAS=yes LDBLAS_yes=-lblas HAVE_LAPACK=yes LDLAPACK_yes=-llapack)

echo "Making runqmc script in $BINDIR"
mkdir -p $BINDIR
cat << EOF > $BINDIR/runqmc
#!/bin/sh
export CASINO_ARCH=linuxpc-gcc-parallel
$CASINODIR/bin_qmc/runqmc "\$@"
EOF
chmod +x $BINDIR/runqmc

echo "Compilation Done"