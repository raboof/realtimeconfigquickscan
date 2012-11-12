#!/usr/bin/perl
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

use strict;
use Tk;
use Tk::Table;
use QuickScanEngine;

my $engine = QuickScanEngine->new;

my $mainWindow = MainWindow->new;
my $frame = $mainWindow->Frame;
my $table = $frame->Table(
	-columns => 5,
	-rows => @{$engine->{CHECKS}}.length);

my $row = 1;
foreach my $check (@{$engine->{CHECKS}})
{
	my $label = $table->Label(-text => $check->{LABEL});
	$table->put($row, 1, $label);
	$row++;
}

$table->pack();
$frame->Button(-text => 'start', -command => sub{
		my $row = 1;
		foreach my $check (@{$engine->{CHECKS}})
		{
			$mainWindow->update();
			$check->execute();
			$mainWindow->update();

			my $kind = $check->{RESULTKIND};
			my $kindForeground = 'black';
			if ($kind eq 'good') {
				$kindForeground = 'green';
			} elsif ($kind eq 'not good') {
				$kindForeground = 'red';
			}
        		my $kindLabel = $table->Label(
				-text => $kind,
				-foreground => $kindForeground
				);
        		$table->put($row, 3, $kindLabel);

			my $result = $check->{RESULT};
        		my $resultLabel = $table->Label(-text => $result);
        		$table->put($row, 2, $resultLabel);

        		my $commentLabel = $table->Label(-text => $check->{COMMENT});
        		$table->put($row, 4, $commentLabel);
        		$row++;
		}

	})->pack();
$frame->pack();

MainLoop;
