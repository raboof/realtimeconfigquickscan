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
package BackgroundCheck;

use base qw(Check);

sub new
{
	my($class) = shift;
        my($self) = Check->new($class);
	$self->{LABEL} = "Checking for resource-intensive background processes";
	return (bless($self, $class));
}

sub execute
{
	my $self = shift;
	$self->{RESULTKIND} = "good";
	$self->{RESULT} = "";
	$self->{COMMENT} = undef;

	$foundMessage = 0;
	foreach my $process (( 'powersaved', 'kpowersave' ))
	{
		if (`ps aux | grep $process | grep -v grep` ne "")
		{
			$self->{RESULT} .= "$process ";
			$self->{RESULTKIND} = "not good";
		}
	}
	if ($self->{RESULTKIND} eq "not good")
	{
		$self->{COMMENT} = "See also: http://wiki.linuxaudio.org/wiki/system_configuration#disabling_resource-intensive_daemons_services_and_processes";
	}
	else
	{
		$self->{RESULT} = "none found";
	}
}

1;
