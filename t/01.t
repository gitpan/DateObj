# -*- perl -*-

# ------------------------------------------------------------------------------
#  Copyright © 2003 by Matt Luker.  All rights reserved.
# 
#  Revision:
# 
#  $Header: /usr/local/src/cvs/DateObj/t/01.t,v 1.1 2003/01/18 23:12:44 kostya Exp $
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

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 01.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 5;

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

# --------------------
# Test 1
# --------------------
BEGIN { use_ok('Date::Object::Date') };

# --------------------
# Test 2
# --------------------
BEGIN { use_ok('Date::Object::Time') };

# --------------------
# Test 3
# --------------------
BEGIN { use_ok('Date::Object::DateTime') };

# --------------------
# Test 4
# --------------------

BEGIN {
	my $now = Date::Object::Date->new();
	isa_ok($now, 'Date::Object::Date', 'Date creation (now)');
};

# --------------------
# Test 5
# --------------------

BEGIN {
	my $now = Date::Object::Date->new('2003-01-17');
	isa_ok($now, 'Date::Object::Date', 'Date creation (2003-01-17)');
};


exit 0;

# ------------------------------------------------------------------------------
# 
#  $Log: 01.t,v $
#  Revision 1.1  2003/01/18 23:12:44  kostya
#  Basic use and instantiation tests.
#
# 
# ------------------------------------------------------------------------------
__END__
