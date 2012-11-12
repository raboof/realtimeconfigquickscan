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
package SwappinessCheck;

use base qw(Check);

sub new
{
	my($class) = shift;
        my($self) = Check->new($class);
	$self->{LABEL} = "Checking swappiness";
	return (bless($self, $class));
}

sub execute
{
	my $self = shift;
	$self->{RESULTKIND} = "good";
	$self->{RESULT} = "";
	$self->{COMMENT} = undef;

	my $swappiness = `/sbin/sysctl vm.swappiness`;
	if ($swappiness =~ /vm.swappiness = (\d+)/)
	{
		$self->{RESULT} = $1;
		if ($1 > 10)
		{
			$self->{COMMENT} = "** vm.swappiness is larger than 10\n" .
				"set it with '/sbin/sysctl -w vm.swappiness=10'\n".
				"See also: http://linuxmusicians.com/viewtopic.php?f=27&t=452&start=30#p8916";
			$self->{RESULTKIND} = "not good";
		}
		else
		{
			$self->{RESULTKIND} = "good";
		}
	}
	else
	{
		$self->{RESULTKIND} = "warning";
		print "warning: '/sbin/sysctl vm.swappiness' did not produce a parsable result\n";
	}
}

1;
