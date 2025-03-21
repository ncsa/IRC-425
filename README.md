## About
This project is aimed at enabling the 
Illinois Computes Research Notebook community to leverage jupyter notebook kernels which have pre-installed software libraries without the need for each user to perform extensive configuration on their own. This will enable more rapid development, as well as standardization between researchers leveraging specialized packages.

Overall, This enables individuals that are less familiar with environment 
management and package installation to nevertheless access custom software in an easy and maintainable way.

## Overview
This project consists of two main parts.

### Custom Kernels for Illinois Computes Research Notebook
The most commonly used portion of this project involves the use of custom jupyter notebook kernels for scientific computing.
Individuals may wish to execute code or computing methods which are difficult to configure or install, or may leverage custom 
or novel methods. This project has created a way in which NCSA can support these researchers through the provision of pre-compiled
custom kernels which can be easily used within the Illinois Computes Research Notebook environment.

Custom Kernels represent either novel combinations of packages, or combinations of packages with experimental versions. 
The custom kernels hosted by NCSA are not intended to be further customized by researchers. If a new custom kernel is required,
please contact the NCSA contact listed in the appropriate readme document.

### Custom package repository for researchers applying novel methodologies
In addition to accessing pre-compiled kernels for their novel work, researchers may also need assess novel combinations of these approaches.
These custom packages can be difficult to compile or install, however, this cannot be a barrier to new and impactful research.

To support scientists and researchers in leveraging these packages within the ICRN, the NCSA is hosting a custom, local Conda package channel for specialized builds of commonly used packages. These could represent package builds which have novel or experimental functionality, as well as specific builds for old or otherwise obsolete versions of packages which are critical to long-term support of software.
The packages hosted by NCSA are not broadly available from public package repositories.

## How to use custom kernels in ICRN
To leverage NCSA-maintained custom kernels for the ICRN, please refer to the [Using custom kernels](./Using_custom_kernels.md) readme document. 

## How to contribute custom kernels 
Please refer to the [Contributing kernels](./Contributing_kernels.md) document in this repository on standards for contribution to 
pre-compiled kernels within the ICRN.

## How to contribute custom packages
Please refer to the [Contributing custom packages](./Contributing_custom_packages.md) readme in this repository for guidance on how to incorporate a new custom package into the NCSA-hosted custom conda channel.

## Kernel listing & information
Please refer to the [Kernels](./Kernel_listing) readme document in this repository for a listing of the custom kernels 
available for use within the ICRN. If you have questions or concerns regarding a particular kernel, you will find 
contact information for the individual responsible for its upkeep.
