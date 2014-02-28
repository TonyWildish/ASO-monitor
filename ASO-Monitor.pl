#!/usr/bin/env perl

use warnings;
use strict;

#die "OK: Need to read work directory on startup\n" .
#    "Need to create per-file-endstate dropbox files\n" .
#    "Need to debug the Reporter dropbox files\n" ,
#    "Need to report failures correctly\n";

##H ASO Monitor prototype, based on Utilities/fts-transfer.pl from PhEDEx
##H
##H Options:
##H 
##H --conf=$string	-> path to configuration file. The format is
##H   not yet documented
##H

#H --service=$string	=> name of FTS service to use.
#H   with this option only, it will go off and monitor your jobs on that
#H   service
#H
#H --copyjob=$string	=> name of an fts 'copyjob' file.
#H   i.e. one "$src $dst" pair per line, as many lines as you want. This will
#H   _not_ be submitted as a single job, see the --files_per_job option for
#H   how to control that. This file will simply serve as input.
#H
#H --max_parallel_jobs=$int	=> number of transfer jobs to run in parallel
#H   limit job-submission to this many jobs at a time. Does not take account
#H   of other jobs in the queue, only the ones this script submits.
#H
#H --q_interval=$int	=> queue-polling interval.
#H   i.e. interval in which to check the queue for new jobs.
#H
#H --j_interval=$int	=> job-polling interval.
#H   i.e. interval at which to look at a job in detail, whichever job is
#H   next in the priority queue.
#H
#H --files_per_job=$int	=> number of files to submit in one job.
#H   If there are more files than this in the file-queue, they will be taken
#H   this many at a time, and submitted as a number of jobs.
#H
#H --file_flush_interval=$int	=> interval before flushing the file queue
#H   If there are less than $files_per_job files in the queue they will be
#H   left there until this interval passes, to give time for more files to
#H   be added. This allows an external method to put more files in the queue.
#H
#H --file_poll_interval=$int	=> interval at which to look for new files
#H   Every so-many seconds, the file-queue is checked to see if there are
#H   enough files to make it worth submitting a job.
#H
#H --job_trace_dir=$string	=> directory for per-job trace files
#H   Every job has detailed logging which is written to STDOUT by default.
#H   If --job_trace_dir is given, per-job logging will be written to that
#H   directory instead, one file per job, with the job-ID in the name.
#H
#H --file_trace_dir=$string	=> directory for per-file trace files
#H   Every file has detailed logging which is written to the job logfile by
#H   default. If --file_trace_dir is given, per-file logging will be written
#H   to that directory instead, one logfile per file, with the logfile name
#H   based on the destination URL.
#H
#H --help		=> this!
#H --verbose		=> passed to the Glite component...
#H --debug		=> passed to the Glite component...
#H

# Use this for heavy debugging of POE session problems!
#sub POE::Kernel::TRACE_REFCNT () { 1 }

use Getopt::Long;
use POE;
use PHEDEX::Core::Help;
use ASO::GliteAsync;
use ASO::Monitor;

my ($config,$service,$q_interval,$j_interval,$help,$verbose,$debug,$copyjob);
my ($files_per_job,$flush_interval,$poll_interval,$poll_queue,$max_jobs);
my ($file_trace_dir,$job_trace_dir,$monalisa);
$service = 'https://prod-fts-ws.cern.ch:8443/glite-data-transfer-fts/services/FileTransfer';
$q_interval     =  60;
$j_interval     =   4;
$files_per_job  =  16;
$flush_interval = 600;
$poll_interval  =  60;
$max_jobs       =  10;

$verbose = $debug = 0;

GetOptions(	"service=s"		=> \$service,
		"q_interval=i"		=> \$q_interval,
		"j_interval=i"		=> \$j_interval,
		"copyjob=s"		=> \$copyjob,
		"files_per_job=i"	=> \$files_per_job,
		"file_flush_interval=i"	=> \$flush_interval,
		"file_poll_interval=i"	=> \$poll_interval,
		"max_parallel_jobs=i"	=> \$max_jobs,
		"job_trace_dir=s"	=> \$job_trace_dir,
		"file_trace_dir=s"	=> \$file_trace_dir,
		"config=s"		=> \$config,
		"help"			=> \&usage,
		"verbose+"		=> \$verbose,
		"debug+"		=> \$debug,
		"monalisa=s"		=> \$monalisa,
	  );

defined($config) or die "Missing argument for --config\n";
-r $config or die "$config: No such file or file not readable\n";

$help and die "No help yet, sorry...\n";

my $ASO = ASO::Monitor->new(
		  ME  		=> 'ASOMon',
		  CONFIG	=> $config,
		  VERBOSE	=> $verbose,
		  DEBUG		=> $debug,
		 );

POE::Kernel->run();
print "The POE kernel run has ended, now I shoot myself\n";
exit 0;
