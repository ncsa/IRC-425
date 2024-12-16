# manual install record; much changes needed for automation
conda config --add channels conda-forge

# parameterize name, target, versions; can we do as straight dep. management
# Conda creation section
conda create -y -n irc425 python=3.11
conda init bash
bash
conda activate irc425
pip install jupyterlab
conda install -y git

# submodule section
# auth required?

################################
git submodule add https://github.com/cropsinsilico/jupyterlab_nodeeditor
git submodule update --init jupyterlab_nodeeditor
################################


################################
git submodule add https://github.com/cropsinsilico/Soybean-BioCro
git submodule update --init Soybean-BioCro
################################

################################
git submodule add https://github.com/cropsinsilico/yggdrasil
git submodule update --init yggdrasil
################################

################################
# Start ePhotosynthesis build
git submodule add https://github.com/cropsinsilico/ePhotosynthesis_C.git
git submodule update --init ePhotosynthesis_C
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
# ePhotosynthesis_C done
################################


# Jupyter Install
python -m ipykernel install --user --name astro --display-name="astro"
jupyter kernelspec list