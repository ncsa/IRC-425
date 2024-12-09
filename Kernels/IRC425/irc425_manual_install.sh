# manual install record; much changes needed for automation
conda config --add channels conda-forge
mkdir Environments
cd Environments
mkdir Repositories
# parameterize name, target, versions; can we do as straight dep. management
conda create -y -n irc425 python=3.11
conda init bash
bash
conda activate irc425
pip install jupyterlab
conda install -y git

cd Repositories
# auth required?
git clone https://github.com/cropsinsilico/ePhotosynthesis_C.git
cd ePhotosynthesis_C/
git checkout SoybeanParameterization

conda install -y boost
conda install -y 'sundials<=5.7.0'
conda install -y cmake
conda install -y make
conda install -y cxx-compiler
mkdir Build
cd Build
cmake ../
make
make install