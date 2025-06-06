### Testing the use of manipulating R_LIBS_USER environment variable for library stack swaps

We can see that environment variables in linux work as expected:
```sh
export R_LIBS_USER=/home/jovyan/R_Libraries/passed_lib_01:/home/jovyan/R_Libraries/original_user_lib
```

and 
```sh
env
...
R_LIBS_USER=/home/jovyan/R_Libraries/passed_lib_01:/home/jovyan/R_Libraries/original_user_lib
...
```

We can see this is respected within R:
```R
Sys.getenv()
...
R_INCLUDE_DIR           /usr/share/R/include
R_LIBS                  /home/jovyan/.icrn/icrn-library     # set in this case during docker build
R_LIBS_SITE             /usr/local/lib/R/site-library/:/usr/local/lib/R/site-library:/usr/lib/R/site-library:/usr/lib/R/library
R_LIBS_USER             /home/jovyan/R_Libraries/passed_lib_01:/home/jovyan/R_Libraries/original_user_lib
...
```

These are also respected when evaluating libPaths for install/loading of packages within R:
```sh
(base) jovyan@8a809389c3a0:~$ Rscript -e '.libPaths()'
[1] "/home/jovyan/R_Libraries/passed_lib_01"    
[2] "/home/jovyan/R_Libraries/original_user_lib"
[3] "/usr/local/lib/R/site-library"
[4] "/usr/lib/R/site-library"
[5] "/usr/lib/R/library"
```

And you can see they are processed in order (so, pre-pending or appending will have the expected behavior) and that user libraries are referenced prior to system libraries.

Critically, from the documentation for R's 'install.packages()' method:

> lib
> character vector giving the library directories where to install the packages. Recycled as needed. **If missing, defaults to the first element of .libPaths().**


So, if we assume the User installs packages without specifying the target library location, the installed packages will be targeted at the first entry of R_USER_LIBS. We can prove this to ourselves via:
```sh
(base) jovyan@8a809389c3a0:~$ Rscript -e 'install.packages("cowsay")'
Installing package into ‘/home/jovyan/R_Libraries/passed_lib_01’
(as ‘lib’ is unspecified)
trying URL 'https://cloud.r-project.org/src/contrib/cowsay_1.2.0.tar.gz'
...
```

and
```sh
(base) jovyan@8a809389c3a0:~$ ls -lhart /home/jovyan/R_Libraries/passed_lib_01/
total 0
drwxrwxrwx 1 root   root  512 May 27 19:23 ..
drwxrwxr-x 1 jovyan users 512 May 27 19:34 cowsay
drwxrwxrwx 1 root   root  512 May 27 19:34 .
```


We can also comment out the correct entries in /etc/R/Renviron and /etc/R/Renviron.site to get rid of the R_LIBS_SITE:
```R
Sys.getenv()
R_LIBS                  /home/jovyan/.icrn/icrn-library
R_LIBS_SITE
R_LIBS_USER             /home/jovyan/R_Libraries/passed_lib_01
```

resulting in:
```R
(base) jovyan@9c4e7b6705c3:~$ Rscript -e '.libPaths()'
[1] "/home/jovyan/R_Libraries/passed_lib_01"
[2] "/usr/lib/R/library"
```

and now, when i install fairly small packages, i see more deps are required:
```R
also installing the dependencies ‘cli’, ‘glue’, ‘lifecycle’, ‘rlang’

trying URL 'https://cloud.r-project.org/src/contrib/cli_3.6.5.tar.gz'
trying URL 'https://cloud.r-project.org/src/contrib/glue_1.8.0.tar.gz'
trying URL 'https://cloud.r-project.org/src/contrib/lifecycle_1.0.4.tar.gz'
trying URL 'https://cloud.r-project.org/src/contrib/rlang_1.1.6.tar.gz'
trying URL 'https://cloud.r-project.org/src/contrib/vctrs_0.6.5.tar.gz'
```

and we can see these on disk:
```sh
(base) jovyan@9c4e7b6705c3:~$ ll R_Libraries/passed_lib_01/
total 0
drwxrwxrwx 1 root   root  512 May 27 20:04 ./
drwxrwxrwx 1 root   root  512 May 27 19:23 ../
drwxrwxr-x 1 jovyan users 512 May 27 20:01 cli/
drwxrwxr-x 1 jovyan users 512 May 27 20:02 glue/
drwxrwxr-x 1 jovyan users 512 May 27 20:03 lifecycle/
drwxrwxr-x 1 jovyan users 512 May 27 20:02 rlang/
drwxrwxr-x 1 jovyan users 512 May 27 20:03 vctrs/
```

So, lets try messing with this:

If we specify a pair of locations as libraries, can we safely move a single library from one to another?
```sh
export R_LIBS_USER=/home/jovyan/R_Libraries/passed_lib_01:/home/jovyan/R_Libraries/passed_lib_02
```

We can see R is able to identify these two locs:
```R
(base) jovyan@9c4e7b6705c3:~$ export R_LIBS_USER=/home/jovyan/R_Libraries/passed_lib_01:/home/jovyan/R_Libraries/passed_lib_02
(base) jovyan@9c4e7b6705c3:~$ Rscript -e '.libPaths()'
[1] "/home/jovyan/R_Libraries/passed_lib_01"
[2] "/home/jovyan/R_Libraries/passed_lib_02"
[3] "/usr/lib/R/library"
```

```sh
(base) jovyan@9c4e7b6705c3:~$ mv /home/jovyan/R_Libraries/passed_lib_01/vctrs/ /home/jovyan/R_Libraries/passed_lib_02/
(base) jovyan@9c4e7b6705c3:~$ ll /home/jovyan/R_Libraries/passed_lib_02/
total 0
drwxrwxrwx 1 root   root  512 May 27 20:16 ./
drwxrwxrwx 1 root   root  512 May 27 19:23 ../
drwxrwxr-x 1 jovyan users 512 May 27 20:03 vctrs/
```

and R:
```sh
(base) jovyan@9c4e7b6705c3:~$ Rscript -e 'library(vctrs)'
```

completed without errors.

then:
```sh
(base) jovyan@9c4e7b6705c3:~$ rm -rf /home/jovyan/R_Libraries/passed_lib_01/glue/
(base) jovyan@9c4e7b6705c3:~$ Rscript -e 'library(vctrs)'
```

and oddly, that worked !?

Looked in the namespace file and found that vctrs only seemed to directly import rlang, so removed rlang:
```sh
(base) jovyan@9c4e7b6705c3:~$ rm -rf R_Libraries/passed_lib_01/rlang/
(base) jovyan@9c4e7b6705c3:~$ Rscript -e 'library(vctrs)'
Error: package or namespace load failed for ‘vctrs’ in loadNamespace(i, c(lib.loc, .libPaths()), versionCheck = vI[[i]]):
 there is no package called ‘rlang’
Execution halted
```

So, we confirmed that if a package is installed in the context of a loaded library stack, and then the dependency of that library stack leaves the environment variable/libPaths identified libraries, R will error when trying to load that package.

It's quite possible that secondary depencies may not be revealed as missing unless the code which actually routes to that dependency is called (as it may not be evaluated at loading of the namespace?)

So, can we install to the 2nd library, depending on the first?

```sh
(base) jovyan@9c4e7b6705c3:~$ ls -lhart /home/jovyan/R_Libraries/passed_lib_01/
total 0
drwxrwxrwx 1 root   root  512 May 27 19:23 ..
drwxrwxr-x 1 jovyan users 512 May 27 20:01 cli
drwxrwxr-x 1 jovyan users 512 May 27 20:03 lifecycle
drwxrwxr-x 1 jovyan users 512 May 27 20:19 glue
drwxrwxrwx 1 root   root  512 May 27 20:28 .
(base) jovyan@9c4e7b6705c3:~$ ls -lhart /home/jovyan/R_Libraries/passed_lib_02/
total 0
drwxrwxrwx 1 root root 512 May 27 19:23 ..
drwxrwxrwx 1 root root 512 May 27 20:19 .
(base) jovyan@9c4e7b6705c3:~$ export R_LIBS_USER=/home/jovyan/R_Libraries/passed_lib_02:/home/jovyan/R_Libraries/passed_lib_01
```

answer is yes:
```R
(base) jovyan@9c4e7b6705c3:~$ Rscript -e 'install.packages("vctrs")'
Installing package into ‘/home/jovyan/R_Libraries/passed_lib_02’
(as ‘lib’ is unspecified)
also installing the dependency ‘rlang’

trying URL 'https://cloud.r-project.org/src/contrib/rlang_1.1.6.tar.gz'
trying URL 'https://cloud.r-project.org/src/contrib/vctrs_0.6.5.tar.gz'
```

and unsurprisingly, we can load the library after:
```sh
(base) jovyan@9c4e7b6705c3:~$ Rscript -e 'library(vctrs)'
```

But, what happens if we remove the deps, by removing the 'passed_lib_01' path from the environment variable
```sh
(base) jovyan@9c4e7b6705c3:~$ export R_LIBS_USER=/home/jovyan/R_Libraries/passed_lib_02
```

The answer is - it loads just fine. TF?

I am going to install r-lang into library_01, and then remove that library, and see what happens.

Experimental state:
```sh
(base) jovyan@9c4e7b6705c3:~$ ls -lhart /home/jovyan/R_Libraries/passed_lib_02/
total 0
drwxrwxrwx 1 root   root  512 May 27 19:23 ..
drwxrwxr-x 1 jovyan users 512 May 27 21:16 vctrs
drwxrwxrwx 1 root   root  512 May 27 21:21 .
(base) jovyan@9c4e7b6705c3:~$ ls -lhart /home/jovyan/R_Libraries/passed_lib_01/
total 0
drwxrwxrwx 1 root   root  512 May 27 19:23 ..
drwxrwxr-x 1 jovyan users 512 May 27 20:01 cli
drwxrwxr-x 1 jovyan users 512 May 27 20:03 lifecycle
drwxrwxr-x 1 jovyan users 512 May 27 20:19 glue
drwxrwxr-x 1 jovyan users 512 May 27 21:22 rlang
drwxrwxrwx 1 root   root  512 May 27 21:22 .
(base) jovyan@9c4e7b6705c3:~$ export R_LIBS_USER=/home/jovyan/R_Libraries/passed_lib_02
```

Can we load rlang?
```sh
(base) jovyan@9c4e7b6705c3:~$ Rscript -e 'library(rlang)'
Error in library(rlang) : there is no package called ‘rlang’
Execution halted
```

no.

can we load vctrs?

```sh
(base) jovyan@9c4e7b6705c3:~$ Rscript -e 'library(vctrs)'
Error: package or namespace load failed for ‘vctrs’ in loadNamespace(i, c(lib.loc, .libPaths()), versionCheck = vI[[i]]):
 there is no package called ‘rlang’
Execution halted
(base) jovyan@9c4e7b6705c3:~$ export R_LIBS_USER=/home/jovyan/R_Libraries/passed_lib_02:/home/jovyan/R_Libraries/passed_lib_01
(base) jovyan@9c4e7b6705c3:~$ Rscript -e 'library(vctrs)'
(base) jovyan@9c4e7b6705c3:~$
(base) jovyan@9c4e7b6705c3:~$ export R_LIBS_USER=/home/jovyan/R_Libraries/passed_lib_02
(base) jovyan@9c4e7b6705c3:~$ Rscript -e 'library(vctrs)'
Error: package or namespace load failed for ‘vctrs’ in loadNamespace(i, c(lib.loc, .libPaths()), versionCheck = vI[[i]]):
 there is no package called ‘rlang’
Execution halted
```
No.

Which means that, if a user has a library loaded, and they install packages, and then that library is unloaded, or changed, we can induce dependency issues between their installed packages by changing out the environment.


What about if there are two copies of the same library?
```sh
(base) jovyan@9c4e7b6705c3:~$ ls -lhart /home/jovyan/R_Libraries/passed_lib_01/
total 0
drwxrwxrwx 1 root   root  512 May 27 19:23 ..
drwxrwxr-x 1 jovyan users 512 May 27 20:01 cli
drwxrwxr-x 1 jovyan users 512 May 27 20:03 lifecycle
drwxrwxr-x 1 jovyan users 512 May 27 20:19 glue
drwxrwxr-x 1 jovyan users 512 May 27 21:22 rlang
drwxrwxr-x 1 jovyan users 512 May 27 21:33 vctrs
drwxrwxrwx 1 root   root  512 May 27 21:33 .
(base) jovyan@9c4e7b6705c3:~$ ls -lhart /home/jovyan/R_Libraries/passed_lib_02/
total 0
drwxrwxrwx 1 root   root  512 May 27 19:23 ..
drwxrwxrwx 1 root   root  512 May 27 21:21 .
drwxrwxr-x 1 jovyan users 512 May 27 21:25 vctrs
(base) jovyan@9c4e7b6705c3:~$
(base) jovyan@9c4e7b6705c3:~$ Rscript -e 'library(vctrs)'
(base) jovyan@9c4e7b6705c3:~$ export R_LIBS_USER=/home/jovyan/R_Libraries/passed_lib_02:/home/jovyan/R_Libraries/passed_lib_01
(base) jovyan@9c4e7b6705c3:~$ Rscript -e 'library(vctrs)'
(base) jovyan@9c4e7b6705c3:~$
```

At least with 'vctrs' it doesn't seem to care. It might with more complex packages, or especially with different versions of packages.


next question: can we copy a directory to a library, in order to use it as a dependency?
state:
```sh
(base) jovyan@9c4e7b6705c3:~$ export R_LIBS_USER=/home/jovyan/R_Libraries/passed_lib_02:/home/jovyan/R_Libraries/passed_lib_01
total 0
drwxrwxrwx 1 root   root  512 May 27 19:23 ..
drwxrwxrwx 1 root   root  512 May 27 21:21 .
drwxrwxr-x 1 jovyan users 512 May 27 21:25 vctrs
(base) jovyan@9c4e7b6705c3:~$ ls -lhart /home/jovyan/R_Libraries/passed_lib_01
total 0
drwxrwxrwx 1 root   root  512 May 27 19:23 ..
drwxrwxr-x 1 jovyan users 512 May 27 20:01 cli
drwxrwxr-x 1 jovyan users 512 May 27 20:03 lifecycle
drwxrwxr-x 1 jovyan users 512 May 27 20:19 glue
drwxrwxr-x 1 jovyan users 512 May 27 21:22 rlang
drwxrwxrwx 1 root   root  512 May 28 14:52 .
(base) jovyan@9c4e7b6705c3:~$ export R_LIBS_USER=/home/jovyan/R_Libraries/passed_lib_02
(base) jovyan@9c4e7b6705c3:~$ Rscript -e 'library(vctrs)'
Error: package or namespace load failed for ‘vctrs’ in loadNamespace(i, c(lib.loc, .libPaths()), versionCheck = vI[[i]]):
 there is no package called ‘rlang’
Execution halted
```

operation:
```sh
(base) jovyan@9c4e7b6705c3:~$ cp -pr /home/jovyan/R_Libraries/passed_lib_01/rlang /home/jovyan/R_Libraries/passed_lib_02/
(base) jovyan@9c4e7b6705c3:~$ ls -lhart /home/jovyan/R_Libraries/passed_lib_02/
total 0
drwxrwxrwx 1 root   root  512 May 27 19:23 ..
drwxrwxr-x 1 jovyan users 512 May 27 21:22 rlang
drwxrwxr-x 1 jovyan users 512 May 27 21:25 vctrs
drwxrwxrwx 1 root   root  512 May 28 14:54 .
```

test:
```sh
(base) jovyan@9c4e7b6705c3:~$ Rscript -e 'library(vctrs)'
(base) jovyan@9c4e7b6705c3:~$
```
This lends credence to the idea that we could copy a packaged R library to a user's local lib area (somewhere) and it would be functional thereafter.



So, a couple of key points from this experimentation, which mostly are not a surprise.
1. When installing a package, R will install only the dependencies that are missing, and it will install them to the first entry in .libPaths()
2. When loading a package, R will only directly check for packages imported by the loaded package; other packages which are installed during dependency resolution may not always be checked for.
3. If a direct import is missing from the locations provided in .libPaths(), package loading will fail
4. If a package is present at install, and becomes missing later, package loading will fail
5. package installs can be moved, and as long as they are positioned correctly within the paths specified by .libPaths(), they will still be discovered and used.



