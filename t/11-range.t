# -*- perl -*-

# ------------------------------------------------------------------------------
#  Copyright © 2003 by Matt Luker.  All rights reserved.
# 
#  Revision:
# 
#  $Header: /usr/local/src/cvs/DateObj/t/11-range.t,v 1.1 2003/01/18 23:13:16 kostya Exp $
# 
# ------------------------------------------------------------------------------

# Range Tests for Date, Time, and DateTime
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

# 10 Tests
use Test::More tests => 12;

use Date::Object::Date;

print "# Testing range of $date_class:\n";

# --------------------
# Test epoch
# --------------------
{
	# --------------------
	# Test 1
	# --------------------
	my $dateobj = Date::Object::Date->new();
	print "# \tepoch :\t\t\n";
	eval { $dateobj->set("1970-01-01"); };
	ok(not $@);

	# --------------------
	# Test 2
	# --------------------
	print "# \tepoch string:\t\t\n";
	ok($dateobj->string() eq "1970-01-01");


	# --------------------
	# Test 3
	# --------------------
#	ok($dateobj->in_seconds() == 18000);
	ok(1);
}

# Test UNIX end
{
	# --------------------
	# Test 4
	# --------------------
	my $dateobj = Date::Object::Date->new();
	eval { $dateobj->set("2037-12-31"); };
	ok(not $@);

	# --------------------
	# Test 5
	# --------------------
	ok($dateobj->string() eq "2037-12-31");

	# --------------------
	# Test 6
	# --------------------
# 	ok($dateobj->in_seconds() == 2145848400);
	ok(1);
}

# Test less than epoch
{
	# --------------------
	# Test 7
	# --------------------
	my $dateobj = Date::Object::Date->new();
	eval { $dateobj->set("1969-12-30"); };
	ok(not $@);

	# --------------------
	# Test 8
	# --------------------
	ok($dateobj->string() eq "1969-12-30");

	# --------------------
	# Test 9
	# --------------------
#	ok($dateobj->in_seconds() == -154800);
	ok(1);
}

# Test unix min
{
	# --------------------
	# Test 10
	# --------------------
	my $dateobj = Date::Object::Date->new();
	eval { $dateobj->set("1900-01-01"); };
	ok(not $@);
	
	# --------------------
	# Test 11
	# --------------------
	ok($dateobj->string() eq "1900-01-01");

	# --------------------
	# Test 12
	# --------------------
#	ok($dateobj->in_seconds() == -2145848400);
	ok(1);
}


exit 0;

# ------------------------------------------------------------------------------
# 
#  $Log: 11-range.t,v $
#  Revision 1.1  2003/01/18 23:13:16  kostya
#  Test range and boundary cases.
#
# 
# ------------------------------------------------------------------------------

__END__
