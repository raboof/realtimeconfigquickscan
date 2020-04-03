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
package AudioGroupCheck;

use Check;
use base qw(Check);

sub new
{
	my($class) = shift;
        my($self) = Check->new($class);
	$self->{LABEL} = "Checking whether you're in the 'audio' group";
	return (bless($self, $class));
}

sub execute
{
	my $self = shift;
	if ( `groups | grep audio` eq "" )
	{
		$self->{RESULTKIND} = "not good";
		$self->{RESULT} = "no";
		$self->{COMMENT} = "add yourself to the audio group with 'adduser \$USER audio'"
	} else {
		$self->{RESULTKIND} = "good";
		$self->{RESULT} = "yes";
		$self->{COMMENT} = undef;
	}
}

1;
