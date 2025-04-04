# met2go

A conda recipe for [MET](https://met.readthedocs.io/en/latest/) and [METplus](https://metplus.readthedocs.io/en/latest/)

## Build

To build a package and optionally upload to anaconda.org:

1. Clone this repo on an `aarch64` or `x86_64` Linux system. The built package will match the system architecture.
2. Run `./build`, which will by default upload the package to anaconda.org. To disable upload, run `ANACONDA_UPLOAD=no ./build`.
3. If prompted, enter your anaconda.org credentials for package upload.
4. When finished, you may remove the `conda` directory created by `build` to reclaim disk space. But if you disabled package upload in step 2 above and want to create a virtual environment based on the local package, retain the `conda` directory.

## Install

To create a `met2go` virtual environment based on a package uploaded to anaconda.org, activate your conda ([Miniforge](https://github.com/conda-forge/miniforge/releases) recommended), then:

``` bash
conda create -n met2go -c <channel> met2go[=version]
```

Set `<channel>` to the name of the channel corresponding to the credentials you supplied during the build.

To create a `met2go` virtual environment based on the locally built package:

``` bash
. conda/etc/profile.d/conda.sh
conda create -n met2go -c local met2go[=version]
```

In either case, you may optionally provide desired [version](https://docs.anaconda.com/working-with-conda/packages/install-packages/#installing-specific-versions-of-conda-packages) information; otherwise, conda will install the latest available version.

Activate the environment:

``` bash
conda activate met2go
```

## Run

When the environment is activated, the path to MET (e.g. `grid_stat`) and METplus (e.g. `run_metplus.py`) executables is prepended to `PATH`, and the following environment variables are exported:

- `METPLUS_PARM_BASE`: A directory containing the contents of the `parm/` directory from the [METplus](https://dtcenter.org/community-code/metplus) distribution.
- `MET_DATA`: A directory containing the contents of the `data/` directory from the [MET](https://dtcenter.org/community-code/model-evaluation-tools-met) distribution.
- `MET_PYTHON_EXE`: The path to the Python interpreter to be used by MET.

In addition, the following scripts are available as executables on `PATH`:

- From METdataio: `write_stat_ascii.py`
- From METplotpy: `line.py`
