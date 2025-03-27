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

### Custom Packages
In the context of this project, a custom package is any collection of libraries and dependencies which can be housed within a locally hosted conda channel. 
This channel is intended to house custom, novel, or specific builds of packages which are not broadly available, but are required for computational research through the ICRN.
A custom package can be hosted by NCSA without necessarily being included in a custom Kernel for use in the ICRN. 

A custom package may be a simple python package, or it may be a collection of various compiled and uncompiled languages. 

In the case of a package consisting of only Python files, Grayskull can be used to create the required Conda recipe, which makes inclusion of a pure-python package in the custom package channel fairly simple.

In the case in which the package is more complex, guidance on creating a recipe for these packages can be found: HERE

In either case, within the repository which contains your package's source, a directory './Recipes' should contain the required recipe, and an entry for this repository should be created in the json file in this repository.
(make this better)

### Sketch
1. what a custom package is
2. determining how you can create a recipe
   1. manually
   2. grayskull
5. Adding your recipe as a submodule to this repository
6. pull-request for this repository once recipe is added
7. Checks required


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