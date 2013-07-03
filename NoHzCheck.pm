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
package NoHzCheck;

use base qw(KernelConfigCheck);

sub new
{
	my($class) = shift;
        my($self) = KernelConfigCheck->new($class);
	$self->{LABEL} = "Checking kernel support for tickless timer";
	return (bless($self, $class));
}

sub executeWithKernelConfig($)
{
	my $self = shift;
	my $kernelConfig = shift;

	if ( $kernelConfig !~ /CONFIG_NO_HZ=y/)
	{
		$self->{RESULTKIND} = "not good";
		$self->{RESULT} = "not found";
		$self->{COMMENT} = "Try enabling tickless timer support (CONFIG_NO_HZ)\n";
			"For more information, see http://wiki.linuxaudio.org/wiki/system_configuration#installing_a_real-time_kernel\n";
			"http://irc.esben-stien.name/mediawiki/index.php/Setting_Up_Real_Time_Operation_on_GNU/Linux_Systems#Kernel"
	}
	else
	{	
		$self->{RESULTKIND} = "good";
		$self->{RESULT} = "found";
		$self->{COMMENT} = undef;
	}
}

1;
