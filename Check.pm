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
package Check;

use strict;

sub new {
	my $class = shift;
	my %params = @_;
       	my $self  = {};
       	$self->{LABEL}     = undef;
       	$self->{RESULT}    = undef;
       	$self->{RESULTKIND}= undef;
       	$self->{COMMENT}  = undef;
      	return bless($self, $class);
}

sub display {
	my $self = shift;
	print $self->{LABEL} . "... " . $self->{RESULT} . " - " . $self->{RESULTKIND} . "\n";
	if (defined($self->{COMMENT}))
	{
		print $self->{COMMENT} . "\n";
	}
}

1;
