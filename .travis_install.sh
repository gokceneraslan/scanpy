set -e

# Deactivate the travis-provided virtual environment and setup a
# conda-based environment instead
deactivate

pushd .
cd
mkdir -p download
cd download
echo "Cached in $HOME/download :"
ls -l
echo
if [[ ! -f miniconda.sh ]]
   then
   wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
       -O miniconda.sh
   fi
chmod +x miniconda.sh && ./miniconda.sh -b
cd ..
export PATH=/home/travis/miniconda3/bin:$PATH
conda update --yes conda
popd

conda create -n testenv --yes python=$TRAVIS_PYTHON_VERSION pip pytest hdf5 \
      numba scikit-learn statsmodels


source activate testenv

pip install -r requires.txt
ldd /home/travis/miniconda3/envs/testenv/lib/python*/site-packages/h5py/h5.*so
pip install docutils
python setup.py develop
