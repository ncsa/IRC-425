## Guidelines for Contribution

### Contact
For questions regarding this repository, the interaction of this repository with the ICRN, and 
issues or problems around automation, and exposure of custom kernels to users, please contact 
[Christopher Heller](mailto:cheller@illinois.edu).

For questions regarding individual kernels, their current version, and updates, please contact the individual listed in 
the kernel description documentation.

### Kernel organization
Each custom kernel should be contained with a directory under ./Kernels/ and should have a short but descriptive name 
relevant to individuals outside of the project. Ideally, these custom kernels are maintained through a CI pipeline and will not require manual updates.

Prior to pull requests integrating new custom kernels into the overall list of maintained kernels, the listing in the 
main readme should be expanded with the required information, as tabulated below.

### Workflow

In order to fully support a custom Kernel on the ICRN, you will need to understand the components of the JupyterLab interface.

There are three main components which must be supported:
- A conda environment, which is installable into JupyterLab as a custom kernel
- If the conda environment depends on novel, custom, or specific versions of packages, you will need to create a conda recipe
- If the research requires extensions in the JupyterLab interface, you will need to create a shell script which installs those extensions 
  - If the extensions rely on custom packages, you will also need to create conda recipes for those custom packages as well




### Template Kernel Definition (Use me for your next kernel!)
| Field        | Value                                       |
|--------------|---------------------------------------------|
| Kernel Name  | novel_custom_kernel                         |
| Version      | 1.0.0                                       |
| Contact      | email@emailhost.com                         |
| Project      | IRC425                                      |
| Description  | Kernel in support of root modeling software |
| expiration   | Kernels are supported for 1 year by default |
| last updated | 12/9/2024                                   |