## Enabling "Kernel" like behavior for R-Studio & Jupyter

#### Rationale
One of the value drivers of the ICRN is that it enables individuals within the UIUC system to access compute resources and environments with a very low barrier-to-entry. They can simply navigate to a URL, login, and they're ready to work. This benefit is lost, if they must immediately undertake a complex procedure to obtain the needed software libraries to work within their domain of interest. As scientific computing becomes more complex, large-scale, and specialized, this will become more and more common. This project is aimed at making the configuration of the scientific compute environment simple and easy for new and moderately experienced users of the ICRN's resources.

### Brief Requirements:
1) we want the user to be able to select from a list of pre-configured kernel/libraries (each containing a set of installed packages). These will contain all the needed libraries and environment parameters needed to begin work within a domain.
2) the selection of a kernel or set of libraries must be constrained to the user
3) users must be able to see a list of available kernels/libraries
3) the selection should persist through R-sessions/restarts
4) Kernels and libraries must be versioned, so they can be maintained, and evolve over time

#### not required:
1) users do not need to be able to persistently extend upon packages on-their-own
2) users do not need to be able to share their own environments


### Experimentation within R's library machinery

#### R internals, envronment, and library resourcing
Broadly speaking, R-startup and environment configuartion proceeds as follows [source](https://rstats.wtf/r-startup.html):
1) R uses the 'R_ENVIRON' variable to identify the site-level .Renviron file, and obtain environment variables
2) R uses the 'R_ENVIRON_USER' variable to identify the user-level.Renviron file, and obtains env vars
3) R uses the 'R_PROFILE' variable to identify site-level Rprofile file, and executes that script
4) R uses the 'R_PROFILE_USER' variable to identify the user level .Rprofile file, and executes that script
5) R loads the prior session's .Rdata file, if it exists
6) R uses the R_HISTFILE variable to identify the correct history file, and loads it

From the [libPath manual page](https://stat.ethz.ch/R-manual/R-devel/library/base/html/libPaths.html):
> At startup, the library search path is initialized from the environment variables R_LIBS, R_LIBS_USER and R_LIBS_SITE ... 

These environment variables would be set for the R session during steps 1 and 2 in the startup process, above.

> First, .Library.site is initialized from R_LIBS_SITE. If this is unset or empty, the ‘site-library’ subdirectory of R_HOME is used. Only directories which exist at the time of initialization are retained. Then, .libPaths() is called with the combination of the directories given by R_LIBS and R_LIBS_USER. By default R_LIBS is unset, and if R_LIBS_USER is unset or empty, it is set to directory ‘R/R.version$platform-library/x.y’ of the home directory on Unix-alike systems

Note that 'R_LIBS' by default is not set, and is therefore available to us.

We'd prefer then to use either the site level Renviron, or (much less preferred) the user's ~/.Renviron file. 

Rprofile contents (either user or site) get executed after libPaths is initially set (see below).

#### Symlinks are expanded by R
Testing a symlink target within R_LIBS on ICRN
In my own user ~/.Renviron:  (we would need to use the system Renviron to test this fully)

```sh
R_LIBS=${HOME}/.icrn/icrn-library
```

which points to a symlink:
```sh
hdpriest@jupyter-hdpriest:~/.icrn$ ls -lhart
lrwxrwxrwx 1 hdpriest hdpriest   61 May 15 20:53 icrn-library -> /sw/icrn/jupyter/TEST_icrn_ncsa_resources/R_libraries/LibSetB
```

Confirmed on ICRN that a symlink to a library location creates a switchable library set:
```R
> .libPaths()
[1] "/sw/icrn/jupyter/TEST_icrn_ncsa_resources/R_libraries/LibSetB"
[2] "/home/hdpriest/R/x86_64-pc-linux-gnu-library/4.4"             
[3] "/usr/local/lib/R/site-library"                                
[4] "/usr/lib/R/site-library"                                      
[5] "/usr/lib/R/library"      

> library(assertthat) ## exists in set B
> library(cowplot) ## exists in set A
Error in library(cowplot) : there is no package called 'cowplot'
```

Change-over the symlink:
```sh
hdpriest@jupyter-hdpriest:~/.icrn$ rm icrn-library
hdpriest@jupyter-hdpriest:~/.icrn$ ln -s /sw/icrn/jupyter/TEST_icrn_ncsa_resources/R_libraries/LibSetA icrn-library
```

and then restart R and attempt to load libraries...
```R
Restarting R session...

> .libPaths()
[1] "/sw/icrn/jupyter/TEST_icrn_ncsa_resources/R_libraries/LibSetA"
[2] "/home/hdpriest/R/x86_64-pc-linux-gnu-library/4.4"             
[3] "/usr/local/lib/R/site-library"                                
[4] "/usr/lib/R/site-library"                                      
[5] "/usr/lib/R/library"                                           
> library(assertthat) ## exists in set B
Error in library(assertthat) : there is no package called 'assertthat'
> library(cowplot) ## exists in set A
```

libpaths and rprofiles interactions:
```R
[1] "libpaths on entry to rprofile:"
[1] "/sw/icrn/jupyter/TEST_icrn_ncsa_resources/R_libraries/LibSetA"
[2] "/home/hdpriest/R/x86_64-pc-linux-gnu-library/4.4"             
[3] "/usr/local/lib/R/site-library"                                
[4] "/usr/lib/R/site-library"                                      
[5] "/usr/lib/R/library"                                           
[1] "setting env var"
[1] ""
[1] ""
[1] "R_LIBS environment variable:"
[1] "/home/hdpriest/"
[1] ""
[1] ""
[1] "Libpaths after setting env var in rprofile"
[1] "/sw/icrn/jupyter/TEST_icrn_ncsa_resources/R_libraries/LibSetA"
[2] "/home/hdpriest/R/x86_64-pc-linux-gnu-library/4.4"             
[3] "/usr/local/lib/R/site-library"                                
[4] "/usr/lib/R/site-library"                                      
[5] "/usr/lib/R/library"
```     
the short-short version is i think we can use a symlink to maintain a switchable pointer to a custom R library. if we didn't want to do a bunch of careful editing of environment variables, we'd need to use R_LIBS. We'd have to write an interface - maybe through addins - that allows the user to pick which one they want from a list, but the environment var + symlink lets us make it persist through session resets/crashes and protect it from most common user files