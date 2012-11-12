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
package RootCheck;

use base qw(Check);

sub new
{
	my($class) = shift;
        my($self) = Check->new($class);
	$self->{LABEL} = "Checking if you are root";
	return (bless($self, $class));
}

sub execute
{
	my $self = shift;
	my $result = $self;
	if ($< == 0)
	{
		$result->{RESULT} = "yes";
		$result->{RESULTKIND} = "not good";
		$result->{COMMENT} = "You are running this script as root. Please run it as a regular user for the most reliable results.";
	}
	else
	{
		$result->{RESULT} = "no";
		$result->{RESULTKIND} = "good";
	}

	return $result;
}

1;
