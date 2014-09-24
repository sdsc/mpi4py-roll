NAME        = mpi4py-modules
RELEASE     = 1
PKGROOT     = /opt/modulefiles/applications/mpi4py

VERSION_SRC = $(REDHAT.ROOT)/src/mpi4py/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
