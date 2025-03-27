## Guidelines for Contribution

### Contact
For questions regarding this repository, the interaction of this repository with the ICRN, and 
issues or problems around automation, and exposure of custom kernels to users, please contact 
[Christopher Heller](mailto:cheller@illinois.edu).

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
```conda init
conda init
bash
```
![img.png](img.png)
(note in particular the environment designator: 'base' )

#### Determine available custom kernels
At any given time, the custom Kernels hosted by the NCSA are listed in this directory:

```/sw/icrn/jupyter/icrn_ncsa_resources/icrn_ncsa_managed_environments```

And they can be listed by running the following command:

```ls -lhart /sw/icrn/jupyter/icrn_ncsa_resources/icrn_ncsa_managed_environments```

If you cannot find the Kernel of interest, please reach out to the maintainer or provider who instructed you to use that kernel. 
It is each individual contributor's responsibility to ensure their kernel is available.

#### Activate the custom Kernel
In order to use the custom Kernel, you will first need to create your own copy of it, and then you will need to install it in your jupyter lab.
This can be accomplished by running the following commands.

First, create a directory where you will keep your own custom kernels:

```mkdir ~/ICRN_custom_kernels/```

then, for a custom kernel (example here is named "IRC425"), run the following command:

``` conda create -p ~/ICRN_custom_kernels/IRC425 --clone /sw/icrn/jupyter/icrn_ncsa_resources/icrn_ncsa_managed_environments/IRC425/latest/```

Please keep in mind that hosted Kernels may change at any time. Updating these kernels is the responsibility of their maintainer. Creating a clone of the kernel ensures that your work will not be disrupted by updates to kernels.

After creating your own copy of the kernel, you must install it in your jupyter environment.

First, activate the kernel in your conda environment manager:

``` conda activate ~/ICRN_custom_kernels/IRC425```

and then, install it in your jupyterlab instance by running:

``` python -m ipykernel install --user --name IRC425-latest --display-name=IRC425-latest```

This kernel will be installed in your jupyterlab on the ICRN until you un-install it, via this command:

```jupyter kernelspec uninstall irc425-latest```

The list of kernels you currently have installed can be seen in the Jupyterlab interface, or on the command line by running:

```jupyter kernelspec list```

