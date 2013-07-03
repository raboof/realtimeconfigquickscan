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
package NoAtimeCheck;

use base qw(Check);

sub new
{
	my($class) = shift;
        my($self) = Check->new($class);
	$self->{LABEL} = "Checking filesystem 'noatime' parameter";
	return (bless($self, $class));
}

sub execute
{
	my $self = shift;
	$self->{RESULTKIND} = "good";
	$self->{RESULT} = "";
	$self->{COMMENT} = "";

	my $kernelVersion = `uname -r`;
	$kernelVersion =~ /^(\d+)\.(\d+)\.(\d+)/;
	if ($1 > 2 || ($1 == 2 && ($2 > 6 || ($2 == 6 && $3 >= 30))))
	{
		$self->{RESULT} = "$1.$2.$3 kernel";
		$self->{RESULTKIND} = "good";
		$self->{COMMENT} = "(relatime is default since 2.6.30)";
		return;
	}

	foreach my $fsref (QuickScanEngine::getFilesystems())
	{
		my %fs = %{$fsref};
		if ($fs{dev} =~ /^\/dev/ && $fs{params} !~ /noatime/)
		{
			$self->{RESULT} = "not found";
			$self->{RESULTKIND} = "warning";
			$self->{COMMENT} .= "$fs{mountpoint} does not have the 'noatime' parameter set\n";
		}
	}
	if ($self->{RESULTKIND} eq "warning")
	{
		$self->{COMMENT} .= "For more information, see http://wiki.linuxaudio.org/wiki/system_configuration#filesystems";
	}
}	

1;
