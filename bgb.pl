#!/usr/bin/perl
use bgb;
# Initialisation
#
my $initialise = 0;
my $period = &get_vars('Green');
if (!$period || $period == 0) {
  $initialise = 1;
} else {
  $initialise = 0;
}
if ($initialise ) {
  &init_globals();
}
while (my $line = <DATA>) {
  chop($line);
  $line =~ s/\s+//g;
  my ($player, $units1, $units2,
    $dayshift, $nightshift,$machinesbought,
        $sellingprice, $advert, $marketreport, $bonus) = split(',',$line);
        print "$player, $units1, $units2,$marketreport\n";
#  my $player = 1;
  my $period = &get_vars($player);
if ($initialise) {
  print "Initialising player $player, period $period\n";
	&init_player($player);
 	}
	# $player,$units1, $units2, $dayshift, $nightshift, $machinesbought, $selling price, $advert, $marketreport
#my $units1 = 10000;
#my $units2 = 10000;
#my $dayshift = 10000;
#my $nightshift = 10000;
#my $machinesbought = 0;
#my $sellingprice = 110;
#my $advert = 5000;
#my $marketreport = 'N';
#
&save_decisions($player, $units1, $units2,
	$dayshift, $nightshift, $machinesbought,
		$sellingprice, $advert, $marketreport, $bonus);
#
&run_simulation($player);
#
&print_report($player);
} # End of outter loop
&move_period_on();
exit;

#Player, Units1, Units2, Dayshift, Nightshift, Machines, Selling Price, Advert
__DATA__
Green,0,50000,0,0,0,320,1600000,N,0
Blue,0,0,40000,0,0,160,750000,N,0
Red,50000,150000,40000,40000,40,280,4000000,N,0
