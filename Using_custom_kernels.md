## Guidelines for Contribution

### Contact
For questions regarding this repository, the interaction of this repository with the ICRN, and 
issues or problems around automation, and exposure of custom kernels to users, please contact 
[Henry Priest](mailto:hdpriest@illinois.edu).

For questions regarding individual kernels, their current version, and updates, please contact the individual listed in 
the kernel description documentation.

### Using Custom Kernels in the ICRN

#### logging into ICRN 
The ICRN is a resource available to all University of Illinois students and researchers. For more information on how to 
log in to and use this service, please see the [NCSA's documentation](https://docs.ncsa.illinois.edu/systems/icrn/en/latest/index.html).

#### Accessing the command line from the ICRN
In order to fully leverage the custom Kernels hosted by NCSA, you will very likely need to run a few commands directly on the command line. This is relatively simple to access from the ICRN, and can be found by opening a new launcher:

![img.png](readme_resources/icrn_terminal_access.png)
Use the 'terminal' option on this screen to open a command line prompt via the ICRN.

In order to correctly prepare your terminal for using custom kernels and extensions, you will need to initialize your terminal for use with Conda:
```bash
username@jupyter-username:~$ conda init
no change     /opt/conda/condabin/conda
no change     /opt/conda/bin/conda
no change     /opt/conda/bin/conda-env
no change     /opt/conda/bin/activate
no change     /opt/conda/bin/deactivate
no change     /opt/conda/etc/profile.d/conda.sh
no change     /opt/conda/etc/fish/conf.d/conda.fish
no change     /opt/conda/shell/condabin/Conda.psm1
no change     /opt/conda/shell/condabin/conda-hook.ps1
no change     /opt/conda/lib/python3.11/site-packages/xontrib/conda.xsh
no change     /opt/conda/etc/profile.d/conda.csh
no change     /home/hdpriest/.bashrc
No action taken.
username@jupyter-username:~$ bash
(base) username@jupyter-username:~$ 
```

(note in particular the environment designator: 'base' )

#### Determine available custom kernels
At any given time, the custom Kernels hosted by the NCSA can be listed by running the following command:

```shell
(base) username@jupyter-username:~$ ls -lhart /sw/icrn/jupyter/icrn_ncsa_resources/icrn_ncsa_managed_environments
```

If you cannot find the Kernel of interest, please reach out to the maintainer or provider who instructed you to use that 
kernel. It is each individual contributor's responsibility to ensure their kernel is available.

#### Installing the custom Kernel
In order to use the custom Kernel, you will first need to create your own copy of it, and then you will need to install
it in your jupyter lab. This can be accomplished by running the following commands.

First, create a directory where you will keep your own custom kernels:

```shell
(base) username@jupyter-username:~$ mkdir ~/ICRN_custom_kernels/
```

then, for a custom kernel (example here is named "IRC425"), run the following command:

```shell
(base) username@jupyter-username:~$ conda create -p ~/ICRN_custom_kernels/IRC425 --clone /sw/icrn/jupyter/icrn_ncsa_resources/icrn_ncsa_managed_environments/IRC425/latest/
```

Please keep in mind that hosted Kernels may change at any time. Updating these kernels is the responsibility of their 
maintainer. Creating a clone of the kernel ensures that your work will not be disrupted by updates to kernels.

After creating your own copy of the kernel, you must install it in your jupyter environment.

First, activate the kernel in your conda environment manager:

```shell
(base) username@jupyter-username:~$ conda activate ~/ICRN_custom_kernels/IRC425
```

and then, install it in your jupyterlab instance by running:

```shell
(base) username@jupyter-username:~$ python -m ipykernel install --user --name IRC425-latest --display-name=IRC425-latest
```

Note: The kernel name that you will see on the JupyterLab interface is the kernel's __display name__. It is a good idea 
to keep your installed kernels well-organized so you always know which version of particular Kernels are which, and what 
Kernel was in-use when particular results were generated.


#### Removing the custom Kernel
You may need to remove one or more kernels from your JupyterLab environment. Kernels will persist in your environment 
until you uninstall them. You will first need to understand the current Kernels you have installed. Their names within
the Kernel system may differ from their display names.
The list of kernels you currently have installed can be seen on the command line by running:

```shell
(base) username@jupyter-username:~$ jupyter kernelspec list
```

This will yield the Kernel names and display names, and enable you to uninstall the Kernel via:

```shell
(base) username@jupyter-username:~$ jupyter kernelspec uninstall irc425-latest
```



