#!/usr/bin/perl

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PRAGMAS

use 5.10.1;
use warnings;
use strict;
$|++;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ VARS

my $subs = {};

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INIT

scalar(@ARGV) == 3
	? &extract_subs()
	: (die "Need a URL, E-Mail & Name!\n");
	

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FUNC

# Extract Subsitutions
sub extract_subs
{
	
	# Fill in all subsitutions
	for (@ARGV)
	{	
		chomp;
		
		if    (m~[^@]+@[^@]+~)       { $subs->{EMAIL} = $_ }
		elsif (m~^https?://github~)  { $subs->{URL}   = $_ }
		else 						 { $subs->{NAME}  = $_ }
			
	}
	
	# Check if everything is there, abort if not.
	for (qw~EMAIL URL NAME~)
	{
		
		die "Incorrect ${_} detected! Aborting!\n" 
			unless $subs->{$_} && $subs->{$_} =~ m~^.{2,}~;
		
	}
	
	# Process Commands
	&run_cmds()
	
}

sub run_cmds
{

	# chomp (my $url = shift);
	
	# Create additional Goodness
	
	# .gitignore
	system qq~touch .gitignore && echo '.DS_Store' | tee -a .gitignore~;
		
	# README.md
	system q~perl -e 'print scalar localtime' > README.md~;
	
	while (<DATA>)
	{
		
		chomp;
		next if m~^\#|^$~;
		
		s~<INSERT_(URL|NAME|EMAIL)>~$subs->{$1}~;
		
		system $_;
		
		die "Somthing went wrong!\n$!\n" if $?;
		
	}
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ DB

__END__
git init

git config --global user.name <INSERT_NAME>
git config --global user.email <INSERT_EMAIL>

git add --all
# git status

git commit -m "Initial Commit"

git remote add origin <INSERT_URL>
git push -u origin master
