
# Initialise Player variables.
sub init_player {
my $player = $_[0];
dbmopen(%P,"playervar$player",0600);
$P{'PLAYER_NUMBER'} = $player;
$P{'TOTAL_MACHINES'} = 20;
$P{'MACHINES_COST'} = 0;
$P{'TOTAL_UNIT1_BOUGHT'} = 0;
$P{'TOTAL_UNIT2_BOUGHT'} = 0;
$P{'TOTAL_DAY_SHIFT'} = 0;
$P{'TOTAL_NIGHT_SHIFT'} = 0;
$P{'MAINTENANCE_COST'} = 0;
$P{'RAW_BF'} = 0;
$P{'RAW_CF'} = 50000;
$P{'RAW_VALUE_CF'} = 0;
$P{'SALES'} = 0;
$P{'MARKET_SHARE'} = 0;
$P{'FINISHED_CF'} = 0;
$P{'TOTAL_COST_NEW_RAW'} = 0;
$P{'TOTAL_PROD_COST'} = 0;
$P{'MARKET_REPORT'} = 0;
$P{'INITIAL_CASH_FLOW'} = 0;
$P{'SALES_REVENUE'} = 0;
$P{'OVERDRAFT_REQUIRED'} = 0;
$P{'CASH_BF'} = 0;
$P{'FINAL_CASH_FLOW'} = 0;
$P{'CASH_CF'} = 500000;
$P{'GROSS_PROFIT'} = 0;
$P{'DEPRECIATION'} = 0;
$P{'OVERDRAFT_INTEREST'} = 0;
$P{'NET_PROFIT'} = 0;
$P{'OVERDRAFT_CF'} = 0;
$P{'REVENUE_RESERVES'} = 0;
$P{'VALUE_MACHINERY'} = 4500000;
$P{'TOTAL_ASSETS'} = 0;
$P{'SHARE_PRICE'} = 100;
$P{'TEMP'} = 0;
$P{'BONUS'} = 0;
dbmclose(%P);
}

sub init_globals {
# Run variables
dbmopen(%G,'globalvar',0600);
$G{'PERIOD'} = 0;
$G{'MARKET_THEORY'} = 0;
$G{'PLAYERS'} = 3;
$G{'MARKET_SIZE'} = 500000;
dbmclose(%G);
}

sub save_decisions {
my ($player,$u1, $u2, $ds, $ns, $mb, $price, $advert, $marketreport, $bonus) = @_;
dbmopen(%D, "decisionvar$player",0600);
# Purchasing Decisions
$D{'UNITS_BOUGHT_1'} = $u1;
$D{'UNITS_BOUGHT_2'} = $u2;
# Production Decisions
$D{'DAY_SHIFT'} = $ds;
$D{'NIGHT_SHIFT'} = $ns;
# Capacity Decisions
$D{'MACHINES_BOUGHT'} = $mb;
# Marketing Decisions
$D{'PRICE'} = $price;
$D{'ADVERTISING'} = $advert;
$D{'MARKET_REPORT'} = $marketreport;
$D{'BONUS'} = $bonus;
dbmclose(%D);
}

sub print_report {
my $player = $_[0];
dbmopen(%P,'playervar'.$player,0600);
dbmopen(%G,'globalvar',0600);
dbmopen(%D,'decisionvar'.$player,0600);
open(OUT, '>playerres'.$player.'.txt');
print OUT <<EOT;
-----------------------------------------------------------------------------------------
          PLAYER NUMBER : $P{'PLAYER_NUMBER'}    PERIOD NUMBER : $G{'PERIOD'}
-----------------------------------------------------------------------------------------

                                 PRODUCTION REPORT
                                 =================

NEW PURCHASES

Supplier      Quantity      Cost/Unit      Total Cost

 one          $D{'UNITS_BOUGHT_1'}  E 50         E $P{'TOTAL_UNIT1_BOUGHT'}
 two          $D{'UNITS_BOUGHT_2'}  E 45         E $P{'TOTAL_UNIT2_BOUGHT'}

 machinery    $D{'MACHINES_BOUGHT'} E 250,000     E $P{'MACHINES_COST'}

PRODUCTION

                 Produced      Cost/Unit      Total Cost

Day Shift   :    $D{'DAY_SHIFT'}  E 10         E $P{'TOTAL_DAY_SHIFT'}
Night Shift :    $D{'NIGHT_SHIFT'}  E 15         E $P{'TOTAL_NIGHT_SHIFT'}

MAINTENANCE

Cost/Machine      Total Cost

 E 10,000        E $P{'MAINTENANCE_COST'}

END OF PERIOD SUMMARY

Total Machines          : $P{'TOTAL_MACHINES'}
Raw Materials in stock  : $P{'RAW_CF'}
Raw Materials value     : E $P{'RAW_VALUE_CF'}
Finished Goods in stock : $P{'FINISHED_CF'}

                                     SALES REPORT
                                     ============

Sales Price : E $D{'PRICE'}
Advertising : E $D{'ADVERTISING'}

Sales Achieved : $P{'SALES'}
Sales Revenue  : E $P{'SALES_REVENUE'}

                                   CASH FLOW REPORT
                                   ================

START OF PERIOD

New Raw Materials : E $P{'TOTAL_COST_NEW_RAW'}
Production Costs  : E $P{'TOTAL_PROD_COST'}
Maintenance       : E $P{'MAINTENANCE_COST'}
Advertising       : E $D{'ADVERTISING'}
Fixed Costs       : E 1,000,000
Marketing Report  : E $P{'MARKET_REPORT'}
                   ----------------
Cost Goods/Sold   : E $P{'INITIAL_CASH_FLOW'}

END OF PERIOD

Sales Revenue     : E $P{'SALES_REVENUE'}
- New Machines    : E $P{'MACHINES_COST'}
- OD Interest (5%): E $P{'OVERDRAFT_INTEREST'}
                   ----------------
Final Cash Flow   : E $P{'FINAL_CASH_FLOW'}

OVERALL CASH FLOW POSITION

Cash BF          : E $P{'CASH_BF'}
Initial Cash Flow : E $P{'INITIAL_CASH_FLOW'}
                   ----------------
Overdraft Req'd   : E $P{'OVERDRAFT_REQUIRED'}
Final Cash Flow   : E $P{'FINAL_CASH_FLOW'}
                   ----------------
Cash CF          : E $P{'CASH_CF'}

                              PROFIT AND LOSS STATEMENT

Sales Revenue        : E $P{'SALES_REVENUE'}
Cost/Goods Sold      : E $P{'INITIAL_CASH_FLOW'}
                      ----------------
Gross Trading Profit : E $P{'GROSS_PROFIT'}
- Depreciation (5%)  : E $P{'DEPRECIATION'}
- OD Interest (5%)   : E $P{'OVERDRAFT_INTEREST'}
                      ----------------
Bonus                : E $P{'BONUS'}
Net Profit/Earnings  : E $P{'NET_PROFIT'}

                                    BALANCE SHEET
                                    =============

Equity                : E 10,000,000      Property       : E 5,000,000
Revenue Reserves      : E $P{'REVENUE_RESERVES'}  Machinery      : E $P{'VALUE_MACHINERY'}
Outstanding Overdraft : E $P{'OVERDRAFT_CF'}  Raw Materials  : E $P{'RAW_VALUE_CF'}
                                          Finished Goods : E $P{'FINISHED_VALUE_CF'}
                                          Cash In Bank   : E $P{'CASH_CF'}
                       ---------------                    ---------------
TOTAL LIABILITIES     : E $P{'TOTAL_ASSETS'}  TOTAL ASSETS   : E $P{'TOTAL_ASSETS'}

                                  KEY STATISTICS
                                  ==============

Period Number : $G{'PERIOD'}
Number Of Players This Period : $G{'PLAYERS'}
Total Profit/Loss This Period : E $P{'NET_PROFIT'}
Total Sales : $P{'SALES'}
Share Price : E $P{'SHARE_PRICE'}
EOT

print OUT <<EOT1 if ($G{'PERIOD'} == 3);
                               SPECIAL ANNOUNCEMENT
                               ====================

The Advertising Agency you employ has gone on strike this Period.

EOT1
print OUT <<EOT2 if ($G{'PERIOD'} == 5);
                               SPECIAL ANNOUNCEMENT
                               ====================

Supplier 2 has unfortunately been unable to deliver any Raw Materials this Period.

EOT2

print OUT <<EOT3 if ($D{'MARKET_REPORT'} eq 'Y');
                                  MARKETING REPORT
                                  ================

Cost Of Report : E 250,000

Total Market Size : $G{'MARKET_SIZE'}
Actual Sales      : $P{'SALES'}
Market Share (%)  : $P{'MARKET_SHARE'}
EOT3

dbmclose(%D);
dbmclose(%G);
dbmclose(%P);
close(OUT);
}

sub run_simulation {
my $player = $_[0];
dbmopen(%P,'playervar'.$player,0600);
dbmopen(%G,'globalvar',0600);
dbmopen(%D,'decisionvar'.$player,0600);
#
# START OF GLOBAL FORMULAE SECTION
# if ($G{'PERIOD  < 10) { $G{'MARKET_SIZE  = 750000
if ($G{'PERIOD'}  >= 10) { $G{'MARKET_SIZE'}  = 900000; }
if ($G{'PERIOD'}  < 10) { $G{'MARKET_SIZE'}  = 750000; }
if ($G{'PERIOD'}  < 5) { $G{'MARKET_SIZE'}  = 500000; }
# START OF MULTI PLAYER FORMULAE SECTION
# Surprise - Advertising Agency strike in Period 3 !!
if ($G{'PERIOD'}  == 3) { $D{'ADVERTISING'}  = 0; }

# Surprise - Supplier 2 cannot deliver in Period 5 !!
if ($G{'PERIOD'}  == 5) { $D{'UNITS_BOUGHT_2'}  = 0; }
$P{'MACHINES_COST'}  =  $D{'MACHINES_BOUGHT'}  * 250000;
$P{'TOTAL_UNIT1_BOUGHT'}  =  $D{'UNITS_BOUGHT_1'}  * 50;
$P{'TOTAL_UNIT2_BOUGHT'}  =  $D{'UNITS_BOUGHT_2'}  * 45;

# Available Raw Material calculations
$P{'RAW_BF'}  =  $P{'RAW_CF'};
$P{'RAW_CF'}  =  $D{'UNITS_BOUGHT_1'}  +  $D{'UNITS_BOUGHT_2'};

# Production calculations
if ($D{'DAY_SHIFT'}  >  $P{'RAW_BF'} ) { $D{'DAY_SHIFT'}  =  $P{'RAW_BF'}; }
$P{'TEMP'}  =  $P{'TOTAL_MACHINES'}  * 2000;
if ($D{'DAY_SHIFT'}  >  $P{'TEMP'} ) { $D{'DAY_SHIFT'}  =  $P{'TEMP'}; }
$P{'TOTAL_DAY_SHIFT'}  =  $D{'DAY_SHIFT'}  * 10;
$P{'RAW_BF'}  =  $P{'RAW_BF'}  -  $D{'DAY_SHIFT'};
if ($D{'NIGHT_SHIFT'}  >  $P{'RAW_BF'} ) { $D{'NIGHT_SHIFT'}  =  $P{'RAW_BF'}; }
$P{'TEMP'}  =  $P{'TOTAL_MACHINES'}  * 1500;
if ($D{'NIGHT_SHIFT'}  >  $P{'TEMP'} ) { $D{'NIGHT_SHIFT'}  =  $P{'TEMP'}; }
$P{'TOTAL_NIGHT_SHIFT'}  =  $D{'NIGHT_SHIFT'}  * 15;
$P{'RAW_BF'}  =  $P{'RAW_BF'}  -  $D{'NIGHT_SHIFT'};
$P{'RAW_CF'}  =  $P{'RAW_CF'}  +  $P{'RAW_BF'};

# Maintenance Cost calculations
$P{'MAINTENANCE_COST'}  =  $P{'TOTAL_MACHINES'}  * 10000;

# Theoretical Sales calculations (advertising sensitive, but not very price sensitive)
$P{'SALES'}  = 1000000 /  $D{'PRICE'};
$P{'TEMP'}  =  $D{'PRICE'}  + 50;
$P{'TEMP'}  =  $P{'TEMP'}  / 10;
$P{'TEMP'}  =  $D{'ADVERTISING'}  /  $P{'TEMP'};
$P{'SALES'}  =  $P{'SALES'}  +  $P{'TEMP'};
$G{'MARKET_THEORY'}  =  $G{'MARKET_THEORY'}  +  $P{'SALES'};

# if (the total theoretical sales > the market) {use the market percentage gained
# START OF OPTIONAL SECTION :
if ($G{'MARKET_THEORY'}  >  $G{'MARKET_SIZE'}) {
        $P{'TEMP'}  =  $P{'SALES'}  /  $G{'MARKET_THEORY'};
        $P{'TEMP'}  =  $P{'TEMP'}  * 100;
        $P{'TEMP'}  =  $G{'MARKET_SIZE'}  *  $P{'TEMP'};
        $P{'SALES'}  =  $P{'TEMP'}  / 100;
}
# END OF OPTIONAL SECTION

# Actual Sales & Stock CF calculations
$P{'FINISHED_CF'}  =  $P{'FINISHED_CF'}  +  $D{'DAY_SHIFT'};
$P{'FINISHED_CF'}  =  $P{'FINISHED_CF'}  +  $D{'NIGHT_SHIFT'};
if ($P{'SALES'}  >  $P{'FINISHED_CF'}  - 1) { $P{'SALES'}  =  $P{'FINISHED_CF'}; }
if ($P{'SALES'}  >  $P{'FINISHED_CF'}  - 1) { $P{'FINISHED_CF'}  = 0; }
if ($P{'SALES'}  <  $P{'FINISHED_CF'} ) { $P{'FINISHED_CF'}  =  $P{'FINISHED_CF'}  -  $P{'SALES'}; }

# Market Share & Sales Revenue calculations
$P{'TEMP'}  =  $P{'SALES'}  /  $G{'MARKET_SIZE'};
$P{'MARKET_SHARE'}  =  $P{'TEMP'}  * 100;
$P{'SALES_REVENUE'}  =  $P{'SALES'}  *  $D{'PRICE'};
# End Of Period Summary calculations

$P{'TOTAL_MACHINES'}  =  $P{'TOTAL_MACHINES'}  +  $D{'MACHINES_BOUGHT'};
$P{'RAW_VALUE_CF'}  =  $P{'RAW_CF'}  * 45;
$P{'FINISHED_VALUE_CF'}  =  $P{'FINISHED_CF'}  * 60;

# Cash Flow calculations
$P{'TOTAL_COST_NEW_RAW'}  =  $P{'TOTAL_UNIT1_BOUGHT'}  +  $P{'TOTAL_UNIT2_BOUGHT'};
$P{'TOTAL_PROD_COST'}  =  $P{'TOTAL_DAY_SHIFT'}  +  $P{'TOTAL_NIGHT_SHIFT'};
$P{'MARKET_REPORT'}  = 0;
if ($D{'MARKET_REPORT'}  eq 'Y' ) { $P{'MARKET_REPORT'}  = 250000; } else { $P{'MARKET_REPORT'}  = 0; }
if ($D{'BONUS'} > 0 ) { $P{'BONUS'}  = $D{'BONUS'}; } else { $P{'BONUS'}  = 0; }
$P{'INITIAL_CASH_FLOW'}  = 1000000 +  $P{'TOTAL_COST_NEW_RAW'};
$P{'INITIAL_CASH_FLOW'}  =  $P{'INITIAL_CASH_FLOW'}  +  $P{'TOTAL_PROD_COST'};
$P{'INITIAL_CASH_FLOW'}  =  $P{'INITIAL_CASH_FLOW'}  +  $P{'MAINTENANCE_COST'};
$P{'INITIAL_CASH_FLOW'}  =  $P{'INITIAL_CASH_FLOW'}  +  $D{'ADVERTISING'};
$P{'INITIAL_CASH_FLOW'}   =  $P{'INITIAL_CASH_FLOW'}  +  $P{'MARKET_REPORT'};
$P{'CASH_BF'}  =  $P{'CASH_CF'};

# Overdraft Calculations
$P{'OVERDRAFT_REQUIRED'}  =  $P{'INITIAL_CASH_FLOW'}  -  $P{'CASH_BF'};
$P{'OVERDRAFT_REQUIRED'}  =  $P{'OVERDRAFT_REQUIRED'}  +  $P{'OVERDRAFT_CF'};
if ($P{'OVERDRAFT_REQUIRED'}  < 0) { $P{'OVERDRAFT_REQUIRED'}  = 0; }
$P{'OVERDRAFT_INTEREST'}  =  $P{'OVERDRAFT_REQUIRED'}  / 20;
$P{'FINAL_CASH_FLOW'}  =  $P{'SALES_REVENUE'}  -  $P{'MACHINES_COST'};
$P{'FINAL_CASH_FLOW'}  =  $P{'FINAL_CASH_FLOW'}  -  $P{'OVERDRAFT_INTEREST'};
$P{'CASH_CF'}  =  $P{'FINAL_CASH_FLOW'}  -  $P{'OVERDRAFT_REQUIRED'};
$P{'OVERDRAFT_CF'}  = 0;
if ($P{'CASH_CF'}  < 0) { $P{'OVERDRAFT_CF'}  = 0 -  $P{'CASH_CF'}; }
if ($P{'CASH_CF'}  < 0) { $P{'CASH_CF'}  = 0; }

# Profit & Loss Statement calculations
$P{'GROSS_PROFIT'}  =  $P{'SALES_REVENUE'}  -  $P{'INITIAL_CASH_FLOW'};
$P{'VALUE_MACHINERY'}  =  $P{'VALUE_MACHINERY'}  +  $P{'MACHINES_COST'};
$P{'DEPRECIATION'}  =  $P{'VALUE_MACHINERY'}  / 20;
$P{'VALUE_MACHINERY'}  =  $P{'VALUE_MACHINERY'}  -  $P{'DEPRECIATION'};
$P{'NET_PROFIT'}  =  $P{'GROSS_PROFIT'}  -  $P{'DEPRECIATION'};
$P{'NET_PROFIT'}  =  $P{'NET_PROFIT'}  + $P{'BONUS'} -  $P{'OVERDRAFT_INTEREST'};

# Balance Sheet calculations
$P{'TOTAL_ASSETS'}  = 5000000 +  $P{'VALUE_MACHINERY'};
$P{'TOTAL_ASSETS'}  =  $P{'TOTAL_ASSETS'}  +  $P{'RAW_VALUE_CF'};
$P{'TOTAL_ASSETS'}  =  $P{'TOTAL_ASSETS'}  +  $P{'FINISHED_VALUE_CF'};
$P{'TOTAL_ASSETS'}  =  $P{'TOTAL_ASSETS'}  +  $P{'CASH_CF'};
$P{'REVENUE_RESERVES'}  =  $P{'TOTAL_ASSETS'}  - 10000000;
$P{'REVENUE_RESERVES'}  =  $P{'REVENUE_RESERVES'}  -  $P{'OVERDRAFT_CF'};

# Share Price calculations
$P{'TEMP'}  =  $P{'NET_PROFIT'}  / 100000;
$P{'SHARE_PRICE'}  =  $P{'SHARE_PRICE'}  +  $P{'TEMP'};
#
# move period on, by one
#$G{'PERIOD'}++;
#
dbmclose(%D);
dbmclose(%G);
dbmclose(%P);
}

sub move_period_on {
dbmopen(%G,'globalvar',0600);
$G{'PERIOD'}++;
dbmclose(%G);
}

sub get_vars {
my $player = $_[0];
dbmopen(%P,'playervar'.$player,0600);
dbmopen(%G,'globalvar',0600);
dbmopen(%D,'decisionvar'.$player,0600);
my $period = $G{'PERIOD'};
dbmclose(%D);
dbmclose(%G);
dbmclose(%P);
return $period;
}

1;
