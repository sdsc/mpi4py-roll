SRCDIRS = `find * -prune\
	  -type d 	\
	  ! -name CVS	\
          ! -name mpi4py-modules \
	  ! -name .` mpi4py-modules
