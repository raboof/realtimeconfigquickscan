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
package MultiAudioCheck;

use base qw(Check);

sub new
{
	my($class) = shift;
        my($self) = Check->new($class);
	$self->{LABEL} = "Checking for multiple 'audio' groups";
	return (bless($self, $class));
}

sub execute
{
	my $self = shift;
	my $audioGroups = `cat /etc/group | grep audio | wc -l`;
	chomp($audioGroups);
	if ( $audioGroups eq "1" )
	{
		$self->{RESULTKIND} = "good";
		$self->{RESULT} = "no";
		$self->{COMMENT} = undef;
	} else {
		$self->{RESULTKIND} = "not good";
		$self->{RESULT} = "yes";
		$self->{COMMENT} = "Found $audioGroups groups with name 'audio'. You should not have duplicate 'audio' groups.\n".
			"For more information, see http://wiki.linuxaudio.org/wiki/system_configuration#audio_group";
	}
}

1;
