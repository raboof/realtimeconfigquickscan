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
package GovernorCheck;

use base qw(Check);

sub new
{
	my($class) = shift;
        my($self) = Check->new($class);
	$self->{LABEL} = "Checking CPU Governors";
	return (bless($self, $class));
}

sub execute
{
	my $self = shift;
	$self->{RESULTKIND} = "good";
	$self->{RESULT} = "";
	$self->{COMMENT} = undef;

	my $syscpus = `ls /sys/devices/system/cpu/`;
	foreach my $syscpu (split('\n', $syscpus))
	{
		if ($syscpu =~ /cpu(\d+)/)
		{
			my $cpunr = $1;
			my $governor = `cat /sys/devices/system/cpu/cpu$cpunr/cpufreq/scaling_governor`;
			chomp($governor);
			$self->{RESULT} .= "CPU $cpunr: '$governor' ";
			if ($governor ne 'performance')
			{
				$self->{RESULTKIND} = "not good";
			} 
		}
	}

	if ($self->{RESULTKIND} eq "not good")
	{
		$self->{COMMENT} = "Set CPU Governors to 'performance' with 'cpufreq-set -c <cpunr> -g performance'\n" .
			"See also: http://linuxmusicians.com/viewtopic.php?f=27&t=844";
	}
}

1;
