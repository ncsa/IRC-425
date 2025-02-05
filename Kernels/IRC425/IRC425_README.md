### About this Kernel: Yggdrasil-roots-IRC425
| Field        | Value                                       | 
|--------------|---------------------------------------------|
| Kernel Name  | IRC425                                      |
| Version      | 0.0.0                                       |
| Contact      | hdpriest@illinois.edu                       |
| Project      | IRC425                                      |
| Description  | Kernel in support of root modeling software |
| expiration   | 4/1/2026                                    |
| last updated | 12/9/2024                                   | 

## How to prepare this kernel
From within the repository root, run:

```source ./Kernels/IRC425/install.sh ```

Note, this essentially sources, in sequence:
1. kernel_prepare.sh
2. kernel_install.sh

which installs, in order:

| Submodule             | Repository                                             | branch/tag              | installation script      |
|-----------------------|--------------------------------------------------------|-------------------------|--------------------------|
| ePhotosynthesis_C     | https://github.com/cropsinsilico/ePhotosynthesis_C     | SoybeanParameterization | ePhotosynthesis.sh       |
| yggdrasil             | https://github.com/cropsinsilico/yggdrasil             | main                    | yggdrasil.sh             | 
| Soybean-BioCro        | https://github.com/cropsinsilico/Soybean-BioCro        | main                    | soybean-biocro.sh        | 
| jupyterlab_nodeeditor | https://github.com/cropsinsilico/jupyterlab_nodeeditor | main                    | jupyterlab_nodeeditor.sh |

