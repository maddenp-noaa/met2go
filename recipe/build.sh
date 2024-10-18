exec 2>&1

bufr() {
  (
    set -eux
    cd bufr
    mkdir -pv build
    cd build
    flags=(
      -DENABLE_TESTS=OFF
      -DCMAKE_INSTALL_PREFIX=$PREFIX
      -DCMAKE_MAKE_PROGRAM=$(which make)
      -Wno-dev
    )
    cmake ${flags[*]} ..
    make -j
    make install
  )
}

met() {
  (
    set -eux
    cd met
    export BUFRLIB_NAME=-lbufr_4_DA
    export GRIB2CLIB_NAME=-lg2c
    export MET_BUFR=$PREFIX
    export MET_GRIB2CINC=$PREFIX
    export MET_GRIB2CLIB=$PREFIX
    export MET_GSL=$PREFIX
    export MET_HDF5=$PREFIX
    export MET_NETCDF=$PREFIX
    export MET_PYTHON_BIN_EXE=$PYTHON
    export MET_PYTHON_CC=$(python3-config --cflags)
    export MET_PYTHON_LD=$(python3-config --ldflags --embed)
    flags=(
      --enable-grib2
      --enable-python
      --prefix=$PREFIX
    )
    ./configure ${flags[*]}
    make install
  )
}

metplus() {
  (
    cd metplus
    pip install -v .
    cp -dv ush/*.py $PREFIX/bin/
    rsync -av metplus/ $SP_DIR/metplus/
    rsync -av produtil/ $SP_DIR/produtil/
    mkdir -pv $PREFIX/etc/
    rsync -av parm/ $PREFIX/etc/metplus/
  )
}

netcdf_cxx() {
  (
    set -eux
    cd netcdf-cxx
    mkdir -pv build
    cd build
    flags=(
      -DBUILD_TESTING=OFF
      -DCMAKE_INSTALL_PREFIX=$PREFIX
      -DCMAKE_MAKE_PROGRAM=$(which make)
      -Wno-dev
    )
    cmake ${flags[*]} ..
    make -j
    make install
    ln -s $PREFIX/lib/libnetcdf-cxx4.so $PREFIX/lib/libnetcdf_c++4.so
  )
}

set -eux

bufr
netcdf_cxx
met
metplus

rsync -av $RECIPE_DIR/etc/ $PREFIX/etc/
