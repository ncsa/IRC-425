Based on the assumptions:

1) we want the user to be able to select from a list of pre-loaded libraries (each containing a set of installed packages), 
2) that selection to be constrained to the user
3) the selection should persist through R-sessions/restarts
	 
Natively, R’s library paths seem to be set at the conclusion of its environment resolution during startup ( https://rstats.wtf/r-startup.html). We'd prefer then to use either the site level Renviron, or (much less preferred) the user's ~/.Renviron file.

We would need to have any changes made within the site-level Renviron file to enable user-specific library selections.

### Testing a symlink target within R_LIBS on ICRN

In my own user ~/.Renviron:  (we would need to use the system Renviron to test this fully)
```env
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
Error in library(cowplot) : there is no package called ‘cowplot’
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
Error in library(assertthat) : there is no package called ‘assertthat’
> library(cowplot) ## exists in set A
```


### longer version/other notes

There are three environment variables which flow into the path libraries:
	- R_LIBS_SITE
	- R_LIBS_USER
	- R_LIBS
 
R_LIBS_SITE may be available for us to manipulate on a per-user basis, depending on how the ICRN R environments are provisioned. I am assuming it is not at the moment. Regardless, this would contain other basic shared packages and we would need to do environment variable munging to manage it. 

R_LIBS_USER is intended for the user to manipulate, and I doubt we wish to use it.

R_LIBS is un-set and is available to us.

The library paths R uses 
 
As you mentioned below, leveraging the user’s existing ~/.Renviron or ~/.Rprofile aren’t ideal, as they both have access and these are common ways for the user to setup their R environment – its likely they would edit these files and cause issues.