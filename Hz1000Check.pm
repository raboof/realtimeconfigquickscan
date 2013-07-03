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
package Hz1000Check;

use base qw(KernelConfigCheck);

sub new
{
	my($class) = shift;
        my($self) = KernelConfigCheck->new($class);
	$self->{LABEL} = "Checking if kernel system timer is set to 1000 hz";
	return (bless($self, $class));
}

sub executeWithKernelConfig($)
{
	my $self = shift;
	my $kernelConfig = shift;

	if ( $kernelConfig !~ /CONFIG_HZ=1000/)
	{
		$self->{RESULTKIND} = "not good";
		$self->{RESULT} = "not found";
		$self->{COMMENT} = "Try setting CONFIG_HZ to 1000\n";
			"For more information, see http://wiki.linuxaudio.org/wiki/system_configuration#installing_a_real-time_kernel\n".
			"http://www.rosegardenmusic.com/wiki/frequently_asked_questions#what_does_system_timer_resolution_is_too_low_mean\n".
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
