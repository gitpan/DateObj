# ------------------------------------------------------------------------------
#  Copyright © 2003 by Matt Luker.  All rights reserved.
# 
#  Revision:
# 
#  $Header: /usr/local/src/cvs/DateObj/lib/Date/Object/DateStrFormat.pm,v 1.1 2003/01/17 19:19:10 kostya Exp $
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

package Date::Object::DateStrFormat;

require Exporter;
@ISA=qw(Exporter);
@EXPORT=qw(
		  );
@EXPORT_OK=qw(
			 );

use Date::Object::DateTime;
use POSIX qw(strptime);

$Date::Object::DateStrFormat::VERSION='0.01';



# ******************** Class Methods ********************

sub convert_datetimestr {
	my $datestr = shift;
	my $datestr_format = shift;

	if (not defined(

# ------------------------------------------------------------------------------
# 
#  $Log: DateStrFormat.pm,v $
#  Revision 1.1  2003/01/17 19:19:10  kostya
#  Module for outputing objects in different formats.
#
# 
# ------------------------------------------------------------------------------
