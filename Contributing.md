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