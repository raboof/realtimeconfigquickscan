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
package KernelConfigCheck;

use base qw(Check);

sub new
{
	my($class) = shift;
        my($self) = Check->new($class);
	return (bless($self, $class));
}

sub getkernelconfig
{
	if ( -e ("/proc/config.gz") )
	{
		return `zcat /proc/config.gz`;
	}
	my $configfile = "/boot/config-" . `uname -r`;
	chomp($configfile);
	if (-e $configfile)
	{
		return `cat $configfile`;
	}
	return "none";
}

sub execute
{
	my $self = shift;

	my $kernelConfig = getkernelconfig();

	if ($kernelConfig eq "none")
	{
		$self->{COMMENT} = undef;
		$self->{RESULTKIND} = "undetermined";
		$self->{RESULT} = "Could not find kernel configuration";
	}
	else
	{
		$self->executeWithKernelConfig($kernelConfig);
	}
}

1;
