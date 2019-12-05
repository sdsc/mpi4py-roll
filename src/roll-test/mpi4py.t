#!/usr/bin/perl -w
# mpi4py roll installation test.  Usage:
# mpi4py.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = '.';
my $mpi4pyHome = '/opt/mpi4py';
my $isInstalled = -d $mpi4pyHome;
my $output;

my $TESTFILE = 'tmpmpi4py';

if($appliance =~ /$installedOnAppliancesPattern/) {
  ok($isInstalled, "mpi4py installed");
} else {
  ok(! $isInstalled, "mpi4py not installed");
}

open(OUT, ">$TESTFILE.sh");
print OUT <<END;
module load mpi4py
output=`mpirun -np 4 python3 $TESTFILE.py 2>&1`
if [[ "\$output" =~ "run-as-root" ]]; then
  output=`mpirun --allow-run-as-root -np 4 python3 $TESTFILE.py 2>&1`
fi
echo "\$output"
END
close (OUT);

open(OUT, ">$TESTFILE.py");
print OUT <<END;
import mpi4py
mpi4py.rc(initialize=False, finalize=False)
from mpi4py import MPI
import sys
MPI.Init()
comm = MPI.COMM_WORLD
rank = comm.Get_rank()
print("Hi, I am process ",rank)
MPI.Finalize()
END
close(OUT);
  
SKIP: {
  skip 'mpi4py not installed', 1 if ! $isInstalled;
  `/bin/bash $TESTFILE.sh >& $TESTFILE.out`;
  $count=`grep -o  "Hi, I am process" $TESTFILE.out|wc -l`;
  ok($count == 4, "mpi4py works");
}

SKIP: {
  skip 'mpi4py not installed', 1 if ! $isInstalled;
  `/bin/ls /opt/modulefiles/applications/mpi4py/[0-9]* 2>&1`;
  ok($? == 0, "mpi4py module installed");
  `/bin/ls /opt/modulefiles/applications/mpi4py/.version.[0-9]* 2>&1`;
  ok($? == 0, "mpi4py version module installed");
  ok(-l "/opt/modulefiles/applications/mpi4py/.version",
     "mpi4py version module link created");
}


`rm -fr $TESTFILE*`;
