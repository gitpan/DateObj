# -*- perl -*-

# ------------------------------------------------------------------------------
#  Copyright © 2003 by Matt Luker.  All rights reserved.
# 
#  Revision:
# 
#  $Header: /usr/local/src/cvs/DateObj/t/10-math.t,v 1.1 2003/01/18 23:13:00 kostya Exp $
# 
# ------------------------------------------------------------------------------

# (description)
# 
# @author  Matt Luker
# @version $Revision: 1.1 $

# (one-liner)
# 
# Copyright (C) 2003, Matt Luker
# 
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Library General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Library General Public License for more details.
# 
# You should have received a copy of the GNU Library General Public
# License along with this library; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA  02111-1307, USA.

# If you have any questions about this software,
# or need to report a bug, please contact me.
# 
# Matt Luker
# Norwood, MA
# kostya@redstarhackers.com
# 
# TTGOG

use Test::More tests => 35;

use Date::Object::Date datecmp, datequant_to_secs, datestr_to_secs;

# --------------------
# Test 1
# --------------------
print "# datecmp(undef, undef) == ". (datecmp(undef, undef)) ."\n";
ok((not defined(datecmp(undef, undef))), 'comparing undefs');

my $date1 = Date::Object::Date->new('2003-01-17');
my $date2 = Date::Object::Date->new('2003-01-17');
print "# \$date1 == $date1\n";
print "# \$date2 == $date2\n";

# --------------------
# Test 2
# --------------------
my $quant = "1y2D";
print "# $quant == ". datequant_to_secs($quant) ."\n";
ok(datequant_to_secs($quant) == 31708800, 'datequant_to_secs("1y2D")');

# --------------------
# Test 3
# --------------------
$quant = "100";
print "# $quant == ". datequant_to_secs($quant) ."\n";
ok(datequant_to_secs($quant) == 8640000, 'datequant_to_secs("100")');

# --------------------
# Test 4
# --------------------
$quant = 100;
print "# $quant == ". datequant_to_secs($quant) ."\n";
ok(datequant_to_secs($quant) == 8640000, 'datequant_to_secs(100)');

# --------------------
# Test 5
# --------------------
$quant = "1m 2y 3D";
print "# $quant == ". datequant_to_secs($quant) ."\n";
ok(datequant_to_secs($quant) == 66355200, 'datequant_to_secs("1m 2y 3D")');

# --------------------
# Test 6
# --------------------
print "# \+\+$date2\n";
++$date2;
ok($date2 eq "2003-01-18", '++$date2') or diag("\$date2 == $date2");
# print "# \$date2->in_seconds() == ". $date2->in_seconds() . "\n";
# print "# datestr_to_secs(\"2003-01-18\") == ". datestr_to_secs("2003-01-18") . "\n";

# --------------------
# Test 7
# --------------------
print "# $date2\+\+\n";
my $date3 = $date2++;
ok($date3 eq "2003-01-18", 'postfix check $date2++');

# --------------------
# Test 8
# --------------------
ok($date2 eq "2003-01-19", 'postfix incr check $date2++');

# --------------------
# Test 9
# --------------------
print "# decr $date2\n";
$date3 = $date2--;
ok($date3 eq "2003-01-19", 'postfix check $date2--');

# --------------------
# Test 10
# --------------------
ok($date2 eq "2003-01-18", 'postfix decr check $date2--') or diag("\$date2 == $date2") ;

# --------------------
# Test 11
# --------------------
print "# +=5  $date2\n";
$date2+=5;
ok($date2 eq "2003-01-23", 'in-place add') or diag("\$date2 == $date2") ;

# --------------------
# Test 12
# --------------------
print "# -=30 $date2\n";
$date2-=30;
ok($date2 eq "2002-12-24", 'in-place subtract across month boundary') or diag("\$date2 == $date2") ;

# --------------------
# Test 13
# --------------------
print "# $date2 + 1\t\t == ". ($date2 + 2) ."\n";
ok(($date2 + 1) eq "2002-12-25", 'addition') or diag("(\$date2 + 1) == ". ($date2+ 1)) ;

# --------------------
# Test 14
# --------------------
print "# 0 + $date2\t\t == ". (0 + $date2) ."\n";
ok((0 + $date2) eq "1040716800", 'addition') or diag("(0 + \$date2) == ". (0 + $date2)) ;

# --------------------
# Test 15
# --------------------
print "# $date2 + $date1\t == ". ($date1+$date2) ."\n";
ok(($date2 + $date1) eq "2036-01-09", 'add two dates') or diag("(\$date2 + \$date1) == ". ($date2 + $date1)) ;

# --------------------
# Test 16
# --------------------
print "# \$date1\t\t\t == ". $date1 ."\n";
ok($date1 eq "2003-01-17", '$date1 still intact') or diag("\$date1 == $date1");

# --------------------
# Test 17
# --------------------
print "# $date1 - $date2\t == ". ($date1-$date2) ."\n";
ok(($date1 - $date2) eq "1970-01-24", 'subtract two dates') or diag("(\$date1 - \$date2) == ". ($date1 - $date2)) ;

# --------------------
# Test 18
# --------------------
print "# ($date1 - $date2)->in_days == ". ($date1-$date2)->in_days ."\n";
ok(($date1 - $date2)->in_days() == 23, 'subtract two dates, diff result in days') or
  diag("(\$date1 - \$date2)->in_days == ". ($date1 - $date2)->in_days) ;

# --------------------
# Test 19
# --------------------
print "# \$date1\t\t\t == ". $date1 ."\n";
ok($date1 eq "2003-01-17", '$date1 still intact') or diag("\$date1 == $date1");

# --------------------
# Test 20
# --------------------
print "# is $date2 eq $date1? ". (($date2 eq $date1) ? "true" : "false") . "\n";
ok((($date2 eq $date1) == 0), 'eq test');

# --------------------
# Test 21
# --------------------
print "# is \$date2 == \$date1? ". (($date2 == $date1) ? "true" : "false") . "\n";
ok((($date2 == $date1) == 0), '== test');

# --------------------
# Test 22
# --------------------
print "# is $date2 eq $date2? ". (($date2 eq $date2) ? "true" : "false") . "\n";
ok((($date2 eq $date2) == 1), 'eq test (self)');

# --------------------
# Test 23
# --------------------
print "# is \$date2 == \$date2? ". (($date2 == $date2) ? "true" : "false") . "\n";
ok((($date2 == $date2) == 1), '== test (self)');

# --------------------
# Test 24
# --------------------
print "# is $date2 gt $date1? ". (($date2 gt $date1) ? "true" : "false") . "\n";
ok((($date2 gt $date1) == 0), 'gt test');

# --------------------
# Test 25
# --------------------
print "# is $date2 >  $date1? ". (($date2 > $date1) ? "true" : "false") . "\n";
ok((($date2 > $date1) == 0), '> test');

# --------------------
# Test 26
# --------------------
print "# is $date2 ge $date1? ". (($date2 ge $date1) ? "true" : "false") . "\n";
ok((($date2 ge $date1) == 0), 'ge test');

# --------------------
# Test 27
# --------------------
print "# is $date2 >= $date1? ". (($date2 >= $date1) ? "true" : "false") . "\n";
ok((($date2 >= $date1) == 0), '>= test');

# --------------------
# Test 28
# --------------------
print "# is $date2 lt $date1? ". (($date2 lt $date1) ? "true" : "false") . "\n";
ok((($date2 lt $date1) == 1), 'lt test');

# --------------------
# Test 29
# --------------------
print "# is $date2 <  $date1? ". (($date2 < $date1) ? "true" : "false") . "\n";
ok((($date2 < $date1) == 1), '< test');

# --------------------
# Test 30
# --------------------
print "# is $date2 le $date1? ". (($date2 le $date1) ? "true" : "false") . "\n";
ok((($date2 le $date1) == 1), 'le test');

# --------------------
# Test 31
# --------------------
print "# is $date2 <= $date1? ". (($date2 <= $date1) ? "true" : "false") . "\n";
ok((($date2 <= $date1) == 1), '<= test');

# --------------------
# Test 32
# --------------------
my $date1_secs = $date1->in_seconds();
print "# is $date2 >  $date1_secs? ". (($date2 > $date1_secs) ? "true" : "false") . "\n";
ok((($date2 > $date1_secs) == 0), '> secs quant test');

# --------------------
# Test 33
# --------------------
print "# is $date1_secs <  $date2? ". (($date1_secs < ($date2)) ? "true" : "false") . "\n";
ok((($date1_secs < $date2) == 1), 'secs quant < test');

# --------------------
# Test 34
# --------------------
print "# is $date2? ". (($date2) ? "true" : "false") . "\n";
ok($date2, 'bool test');

print "# \n";

# --------------------
# Test 35
# --------------------
print "# 1990-12-17 == ". datestr_to_secs("1990-12-17") ."\n";;
my $special = Date::Object::Date->new("1990-12-17");
my $anniv_25 = $special + "25y";
print "# 25th anniversary is on a ". $anniv_25->weekday_name() ."\n";
ok($anniv_25->weekday_name() eq "Thursday", '25 anniv test');


exit 0;

# ------------------------------------------------------------------------------
# 
#  $Log: 10-math.t,v $
#  Revision 1.1  2003/01/18 23:13:00  kostya
#  Test math and logic operations.
#
# 
# ------------------------------------------------------------------------------

__END__
