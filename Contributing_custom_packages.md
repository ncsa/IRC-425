## Guidelines for Contribution

### Contact
For questions regarding this repository, the interaction of this repository with the ICRN, and 
issues or problems around automation, and exposure of custom kernels to users, please contact 
[Henry Priest](mailto:hdpriest@illinois.edu).

For questions regarding individual kernels, their current version, and updates, please contact the individual listed in 
the kernel description documentation.

### Custom Packages
In the context of this project, a custom package is any collection of libraries and dependencies which can be housed within a locally hosted conda channel. 
This channel is intended to house custom, novel, or specific builds of packages which are not broadly available, but are required for computational research through the ICRN.
A custom package can be hosted by NCSA without necessarily being included in a custom Kernel for use in the ICRN. 

A custom package may be a simple python package, or it may be a collection of various compiled and uncompiled languages. 

In the case of a package consisting of only Python files, Grayskull can be used to create the required Conda recipe, which makes inclusion of a pure-python package in the custom package channel fairly simple.

In the case in which the package is more complex, guidance on creating a recipe for these packages can be found [here](https://docs.conda.io/projects/conda-build/en/stable/concepts/recipe.html).

In either case, within the repository which contains your package's source, a directory (e.g.: './recipe') should 
contain the required recipe. It is the responsibility of the package maintainer to ensure this recipe successfully 
creates a conda package when invoked through conda-build. Once the recipe is functional, the 
[recipe_tags.json](./Recipes/recipe_tags.json) file in this repository should be updated with the necessary JSON stanza 
for each recipe created: An example of such a json stanza for the package 
[yggdrasil](https://github.com/cropsinsilico/yggdrasil) can be seen below:
```json
  "yggdrasil": {
    "tag": "conda_recipe",
    "url": "https://github.com/cropsinsilico/BML-yggdrasil",
    "resourcePath": "recipes/",
    "type": "recipe",
  }
```

### Contribution Workflow

1. Create a branch for your new custom package in this repository
2. Within the package repository, create and test a conda recipe, suitable for conda-build
3. Add the necessary JSON information to the [recipe_tags.json](./Recipes/recipe_tags.json) file
4. submit a pull request in this repository to have your additions pulled into the production branch
