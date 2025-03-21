## Guidelines for Contribution

### Contact
For questions regarding this repository, the interaction of this repository with the ICRN, and 
issues or problems around automation, and exposure of custom kernels to users, please contact 
[Christopher Heller](mailto:cheller@illinois.edu).

For questions regarding individual kernels, their current version, and updates, please contact the individual listed in 
the kernel description documentation.

### Using Custom Kernels in the ICRN

Sketch:
1. logging into ICRN - link to existing doc
2. how to access the command line in ICRN
3. locate custom kernel environment listing
4. Activate the custom Kernel
   5. do users need to clone it first?
5. Install the custom Kernel in your ICRN
   6. How long does this persist?
7. Change over to new custom Kernel
6. Un-installing the custom Kernel
7. Reproducible analysis with custom kernels (can kernel switch be done from within a ipynb?)

### Kernel organization
Each custom kernel should be contained with a directory under ./Kernels/ and should have a short but descriptive name 
relevant to individuals outside of the project. Ideally, these custom kernels are maintained through a CI pipeline and will not require manual updates.

Prior to pull requests integrating new custom kernels into the overall list of maintained kernels, the listing in the 
main readme should be expanded with the required information, as tabulated below.

### Workflow

1. Create a subdirectory for your kernel within the [kernels directory](./Kernels/)
2. create an 'update.sh' file that contains all of the needed commands to build and install your kernel as a custom ipy kernel
3. if your project has git submodules; create a 'tags.json' file which identifies the repositories and their branch/version leveraged by the custom kernel
4. include necessary git automation to checkout the appropriate branches/commits for each of the git submodules
5. create an entry in the kernel listing in the [kernels readme](./Kernel_listing.md)


### Kernel Update


### Kernel Uninstall



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