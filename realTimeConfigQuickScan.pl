#!/usr/bin/perl
#   Copyright 2010 Arnout Engelen
#
#     This file is part of realtimeconfigquickscan.
#
#    realtimeconfigquickscan is free software: you can redistribute it and/or 
#    modify it under the terms of the GNU General Public License as published 
#    by the Free Software Foundation, either version 2 of the License, or
#    (at your option) any later version.
#
#    realtimeconfigquickscan is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with realtimeconfigquickscan.  
#    If not, see <http://www.gnu.org/licenses/>.

use strict;
use FindBin;
use lib $FindBin::Bin;
use QuickScanEngine;;

my $engine = QuickScanEngine->new();

print "== GUI-enabled checks ==\n";
for my $check (@{$engine->{CHECKS}})
{
	$check->execute();
	$check->display();
}
print "== Other checks ==\n";

## File System
my @filesystems = $engine->getFilesystems();

print "Checking filesystem types... ";
my $foundMessage = 0;

foreach my $fsref (@filesystems)
{
	my %fs = %{$fsref};
	if ($fs{dev} =~ /^\/dev/ && $fs{mountpoint} !~ /^\/media/ &&(($fs{type} eq "fuseblk") || ($fs{type} eq "reiserfs")))
	{
		if (!$foundMessage)
		{
			print "\n";
			$foundMessage = 1;
		}
		print "** Warning: do not use $fs{mountpoint} for audio files.\n";
		print "   $fs{type} is not a good filesystem type for realtime use and large files.\n";
	}
}

if (!$foundMessage)
{
	print "ok.\n";
}
else
{
	print "   For more information, see http://wiki.linuxaudio.org/wiki/system_configuration#filesystems\n";
}

if (!defined $ENV{SOUND_CARD_IRQ})
{
	print "** Set \$SOUND_CARD_IRQ to the IRQ of your soundcard to enable more checks.\n";
	print "   Find your sound card's IRQ by looking at '/proc/interrupts' and lspci.\n";
}
elsif ($ENV{SOUND_CARD_IRQ} eq "none")
{
#	print "\$SOUND_CARD_IRQ set to 'none', skipping IRQ tests\n";
}
else
{
	print "Checking for devices at IRQ $ENV{SOUND_CARD_IRQ}... ";
	my $irqline = `cat /proc/interrupts | grep $ENV{SOUND_CARD_IRQ}:`;
	#my @fields = split(/\s+/, $irqline);
	if ($irqline =~ /,/)
	{
		print "found multiple. not ok.\n";
	}
	elsif ($irqline =~ /^\s*$/)
	{
		print "did not find any. not ok.\n";
	}
	else
	{
		print "did not find multiple. ok.\n";
	}
}

## PCI
#if (!defined $ENV{SOUND_CARD_PCI_ID})
#{
#	print "** Set \$SOUND_CARD_PCI_ID to the pci-id of your soundcard to enable more checks\n";
#}
#elsif ($ENV{SOUND_CARD_PCI_ID} eq "none")
#{
#	print "\$SOUND_CARD_PCI_ID set to 'none', skipping PCI tests\n";
#}
#else
#{
#	my $lspci = `lspci -v`;
#	# TODO latencies en burst settings bekijken
#}

## Hardware priority (IRQ)
# TODO: find out what APIC means.

## Software priority
# TODO:  ps -Leo rtprio,cmd,pid | grep -v -e "^     - "
# then check that watchdog, irq9, jack, rtapps are prioritized in that order.

# TODO Hardware memory: CAS-latency of '2' is advised - is this really that relevant?

# TODO check for iostat
#print "Checking for paging... ";
#if (not (-e `which iostat` ))
#{
#	print " can't find iostat.\n";
#	print "** Warning: install iostat (often in the sysstat package) to check for paging\n";
#}

# TODO Check out latency TOP

## JACK
# TODO: esben-stein mentions '/dev/shm' usage, but I don't see that in 'man jackd'.
# TODO: check if hardware supports --hwmon, if so check whether it's used

## Misc

# security/limits.conf
# TODO limits.conf settings




# TODO
# print "Checking for jack configuration... ";

#if ( File.exists("~/.jackdrc") )
#{
#	my $jackconf=`line < ~/.jackdrc`;
#	print "found ~/.jackdrc: $jackconf"
#} else {
#	print 'not found.'
#}

# security/limits.conf

