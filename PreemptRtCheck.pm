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
package PreemptRtCheck;

use KernelConfigCheck;
use base qw(KernelConfigCheck);

sub new
{
	my($class) = shift;
	my($self) = KernelConfigCheck->new($class);
	$self->{LABEL} = "Kernel with Real-Time Preemption";
	return (bless($self, $class));
}

sub executeWithKernelConfig($)
{
	my $self = shift;
	my $kernelConfig = shift;

	if ( $kernelConfig =~ /CONFIG_PREEMPT_RT=y|CONFIG_PREEMPT_RT_FULL=y/)
	{
		$self->{RESULTKIND} = "good";
		$self->{RESULT} = "found";
		$self->{COMMENT} = undef;
		return
	}

	my $cmdline = `cat /proc/cmdline`;
	my $kernelVersion = `uname -r`;
	$kernelVersion =~ /^(\d+)\.(\d+)\.(\d+)/;
	if ( ($1 > 2 || ($1 == 2 && ($2 > 6 || ($2 == 6 && $3 >= 39)))) && $cmdline =~ /threadirqs/)
	{
		$self->{RESULTKIND} = "good";
		$self->{RESULT} = "'threadirqs' kernel parameter";
		$self->{COMMENT} = undef;
		return
	}

	$self->{RESULTKIND} = "not good";
	$self->{RESULT} = "not found";
	$self->{COMMENT} = "Kernel without 'threadirqs' parameter or real-time capabilities found\n".
		"For more information, see https://wiki.linuxaudio.org/wiki/system_configuration#do_i_really_need_a_real-time_kernel";
}

1;
