#!/usr/bin/perl

use strict;
use warnings;
use English qw( -no_match_vars );
use File::Basename;
use Getopt::Long;
# use Carp;
# use File::Temp qw( tempfile );
# use File::Spec;
# use POSIX qw ( strftime );
# use Pod::Usage;

my $PROG = basename $PROGRAM_NAME;

my $Error;

sub main {
	my $fh;
	my $line;

	# Parse the command line
	(? ? ?) = assertParseArgs();

	if (! open($fh, "<", ...)) {
		printf STDERR "%s: unable to open file '%s': %s\n",
			$PROG, ..., lcfirst($OS_ERROR);
		exit 1;
	}

	while ($line = <$fh>) {
		chomp $line;
	}

	close $fh;
} # main

sub assertParseArgs {
	my %options;
	my $result;
	my $save;

	# Trap warnings so we can handle them ourselves
	$save = $SIG{__WARN__};
	$SIG{__WARN__} = \&trap;

	# Let GetOptions() do the actual parsing
	$result = GetOptions(
		\%options,
		"int|i=i",
		"float|f=f",
		"string|s=s",
		"optional|o:_",
		#
		"man"     => sub { pod2usage(-exitstatus => 0, -verbose => 2) },
		"help"    => sub { pod2usage(-exitstatus => 0, -verbose => 2) },
	);
	if (! $result) {
		printf STDERR "%s: %s\n\n", $PROG, lcfirst($Error);
		pod2usage(-exitstatus => 2, -verbose => 0);
	}

	# Restore warnings
	$SIG{__WARN__} = $save;

	###
	### Validation goes here
	###
	if (! defined($options{"string"})) {
		printf STDERR "%s: no string specified (-s | --string)\n\n", $PROG;
		pod2usage(-exitstatus => 2, -verbose => 0);
	}

	return (
		$options{'int'},
		$options{'float'},
		$options{'string'},
		$options{'optional'},
	);
} # assertParseArgs

sub trap {
	($Error) = @_;    # *NOT* my $Error -- this is the global variable!
	chomp $Error;
	return;
} # trap

main();
