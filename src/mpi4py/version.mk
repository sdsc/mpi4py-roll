PKGROOT            = /opt/mpi4py
NAME               = mpi4py
VERSION            = 1.3.1
RELEASE            = 0
TARBALL_POSTFIX    = tar.gz

SRC_SUBDIR         = mpi4py

SOURCE_NAME        = $(NAME)
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tar.gz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS           = $(SOURCE_PKG)
