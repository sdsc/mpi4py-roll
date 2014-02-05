#!/usr/bin/perl -w
# mpi4py roll installation test.  Usage:
# mpi4py.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend
my $compiler="ROLLCOMPILER";
my $mpi="ROLLMPI";
my $network="ROLLNETWORK";

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = 'Compute';
my $output;
my $TESTFILE = 'tmpmpi4py';

if ($appliance eq 'Frontend') {
  ok(-d '/var/www/html/roll-documentation/6.1/mpi4py', 'doc installed');
} else {
  ok(! -d '/var/www/html/roll-documentation/6.1/mpi4py', 'doc not installed');
}

if($appliance =~ /$installedOnAppliancesPattern/) {
  ok(-d "/opt/mpi4py", "mpi4py installed");
} else {
    ok(! -d "/opt/mpi4py", "mpi4py not installed");
}
SKIP: {
  skip 'mpi4py not installed', 1 if ! -d "/opt/mpi4py";
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
  if test -f /etc/profile.d/modules.sh; then
  . /etc/profile.d/modules.sh
   module load mpi4py
   mpirun -np 4 python $TESTFILE.py
  fi
END
close (OUT);
  open(OUT, ">$TESTFILE.py");
  print OUT <<END;
from mpi4py import MPI
import sys

comm = MPI.COMM_WORLD
rank = comm.Get_rank()

print "Hi, I am process ",rank
END
  close(OUT);
  
  `/bin/bash $TESTFILE.sh >& $TESTFILE.out`;
  $count=`grep -c  "Hi, I am process" $TESTFILE.out`;
  ok($count == 4, "mpi4py works");


}


SKIP: {

  skip 'mpi4py not installed', 1
    if $appliance !~ /$installedOnAppliancesPattern/;
  skip 'modules not installed', 1 if ! -f '/etc/profile.d/modules.sh';
    my ($noVersion) = mpi4py  =~ m#([^/]+)#;
    `/bin/ls /opt/modulefiles/applications/$noVersion/[0-9]* 2>&1`;
    ok($? == 0, "mpi4py module installed");
    `/bin/ls /opt/modulefiles/applications/$noVersion/.version.[0-9]* 2>&1`;
    ok($? == 0, "mpi4py version module installed");
    ok(-l "/opt/modulefiles/applications/$noVersion/.version",
       "mpi4py version module link created");
}


`rm -fr $TESTFILE*`;
