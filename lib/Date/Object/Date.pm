# Date object
#
# Makes handling dates a lot easier on my code
#
#
#

package Date::Object::Date;

use Time::Local;
use Date::Object::SecondsQuantity;

require Exporter;
@ISA=qw(Exporter Date::Object::SecondsQuantity);
@EXPORT=qw(
		  );
@EXPORT_OK=qw(
		   $WEEKBEGIN
		   $WEEKEND
		   &datestr_to_secs
		   &secs_to_datestr
		   &days_to_secs
		   &secs_to_days
		   &datequant_to_vals
		   &vals_to_datequant
		   &datequant_to_secs
		   &secs_to_datequant
		   &datecmp
		   &monthcmp
		   &yearcmp
		   &prev_month
			 );

our $VERSION = '0.90.3';

use overload 
  '+' => \&add,
  '-' => \&subtract,
  '++' => \&incr,
  '--' => \&decr,
  'eq' => \&equal,
  'lt' => \&lthan,
  'le' => \&lequal,
  'gt' => \&gthan,
  'ge' => \&gequal,
  '==' => \&same_obj,
  '<'  => \&lthan,
  '<=' => \&lequal,
  '>'  => \&gthan,
  '>=' => \&gequal,
  '='  => \&clone,
  'bool' => \&in_seconds,
  '0+' => \&in_seconds,
  '""' => \&string;
#   'nomethod' => \&method_not_found;

@DoW = ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');
@DNoW = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
@DAoW = ('S','M','T','W','R','F','S');
@MoY = ('January','February','March','April','May','June',
	    'July','August','September','October','November','December');
@MNoY = ('Jan','Feb','Mar','Apr','May','Jun',
	    'Jul','Aug','Sep','Oct','Nov','Dec');
@MAoY = ('J','F','M','A','M','J',
	    'J','A','S','O','N','D');

#       Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec 
@DoM = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
@DoMLY = (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

$WEEKBEGIN = 0;
$WEEKEND = 6;

# ******************** Class Methods ******************************

sub valid_datestr {
	my $date_val = shift;

	if ((not defined($date_val)) || ($date_val !~ m/\d\d\d\d-\d\d-\d\d/)) {
		return 0;
	} else {
		return 1;
	}
}

sub datestr_to_ctime {
	my $date_val = shift;

	my $year;
	my $month;
	my $day;
	if (not valid_datestr($date_val)) {
		return undef;
	} else {
		($year, $month, $day) = ($date_val =~ m/(\d\d\d\d)-(\d\d)-(\d\d)/);
		$year = 0 + $year;
		$month = 0 + $month;
		$day = 0 + $day;
		$year -= 1900;
		$month -= 1;
	}
	my @time = (0, 0, 0, $day, $month, $year, 0, 0, 0);
	return @time;
}
	
sub datestr_to_secs {
	my $date_val = shift;

	my $year;
	my $month;
	my $day;
	if (not valid_datestr($date_val)) {
		return undef;
	} else {
		@time = datestr_to_ctime($date_val);
		return timelocal(@time);
	}
}
	
sub secs_to_datestr {
	my $secs_val = shift;

	@time = localtime($secs_val);
	$time[5] += 1900;
	$time[4] += 1;

	if ($time[4] lt 10) {
		$time[4] = "0$time[4]";
	}
	if ($time[3] lt 10) {
		$time[3] = "0$time[3]";
	}

	return "$time[5]-$time[4]-$time[3]";
}

sub days_to_secs {
	my $days_val = shift;

	my $secs_val = $secs_val * 3600 * 24;
	$days_val = int($days_val);

	return $days_val;
}

sub secs_to_days {
	my $secs_val = shift;

	my $days_val = $secs_val / (3600 * 24);
	$days_val = int($days_val);

	return $days_val;
}

# Breaks down a "math quantity" into values we can use accurately
# with a date.  Returns an list of the values:
#   0       1        2
# ($years, $months, $days);
#
# If you include a weeks number, it is converted to days.
#
sub datequant_to_vals {
	my $math_val = shift;

	my $years = 0;
	my $months = 0;
	my $weeks = 0;
	my $days = 0;

	if ($math_val !~ m/[ymwd]/i) {
		# if just a solid number, assume this is days
		$days = 0 + $math_val;
	} else {
		($years) = ($math_val =~ m/\D*?(\d+?)[y]/i);
		($months) = ($math_val =~ m/\D*?(\d+?)[m]/i);
		($weeks) = ($math_val =~ m/\D*?(\d+?)[m]/i);
		($days) = ($math_val =~ m/\D*?(\d+?)[d]/i);
	}

	if (not defined($years)) { $years = 0; }
	if (not defined($months)) { $months = 0; }
	if (not defined($weeks)) { $weeks = 0; }
	if (not defined($days)) { $days = 0; }

	$days += $weeks * 7;

	my @vals = ($years, $months, $days);
	return @vals;
}

sub vals_to_datequant {
	my $years = shift;
	my $months = shift;
	my $days = shift;

	my $weeks = 0;

	if (not defined($years)) { return undef; }
	if (not defined($months)) { return undef; }
	if (not defined($days)) { return undef; }

	$weeks = int($days / 7);
	$days = $days % 7;

	my $datequant = $years;
	$datequant .= "Y ";
	$datequant .= $months;
	$datequant .= "M ";
	$datequant .= $weeks;
	$datequant .= "W ";
	$datequant .= $days;
	$datequant .= "D";

	return $datequant;
}

# Contraversial and perhaps not reliable, since there is no
# accurate way to compute how many seconds a month is.  At best,
# when you input months, you are effectively choosing 4 weeks
# or 28 days.
#
# Still, might be useful.
#
sub datequant_to_secs {
	my $math_val = shift;

	my $years = 0;
	my $months = 0;
	my $weeks = 0;
	my $days = 0;

	if ($math_val !~ m/[ymwd]/i) {
		# if just a solid number, assume this is days
		$days = 0 + $math_val;
	} else {
		($years) = ($math_val =~ m/\D*?(\d+?)[y]/i);
		($months) = ($math_val =~ m/\D*?(\d+?)[m]/i);
		($weeks) = ($math_val =~ m/\D*?(\d+?)[m]/i);
		($days) = ($math_val =~ m/\D*?(\d+?)[d]/i);
	}

	if (not defined($years)) { $years = 0; }
	if (not defined($months)) { $months = 0; }
	if (not defined($weeks)) { $weeks = 0; }
	if (not defined($days)) { $days = 0; }

	my $secs = 0;
	$secs += $years * 365 * 24 * 60 * 60;
	$secs += $months * 28 * 24 * 60 * 60;
	$secs += $weeks * 7 * 24 * 60 * 60;
	$secs += $days * 24 * 60 * 60;
	
	return $secs;
}
	
# See datequant_to_secs for precision problems.
#
sub secs_to_datequant {
	my $secs = shift;

	if (not defined($secs)) { return undef; }

	my $years = int($secs / (365 * 24 * 60 * 60));
	$secs = $secs % (365 * 24 * 60 * 60);
	my $months = int($secs / (28 * 24 * 60 * 60));
	$secs = $secs % (28 * 24 * 60 * 60);
	my $days = int($secs / (24 * 60 * 60));

	my $weeks = 0;

	$weeks = int($days / 7);
	$days = $days % 7;

	my $datequant = $years;
	$datequant .= "Y ";
	$datequant .= $months;
	$datequant .= "M ";
	$datequant .= $weeks;
	$datequant .= "W ";
	$datequant .= $days;
	$datequant .= "D";

	return $datequant;
}

sub datecmp {
	my $val1 = shift;
	my $val2 = shift;

	if ((not defined($val1)) || (not defined($val2))) {
		return undef;
	}

	my $sec1 = 0;
	my $sec2 = 0;

	if (UNIVERSAL::isa($val1, "Date::Object::Date")) {
		$sec1 = $val1->in_seconds();
	} else {
		# Ok, is it a date string?
		if (valid_datestr($val1)) { $sec1 = datestr_to_secs($val1); }
		# IF NOT, **ASSUME** seconds
		else { $sec1 = 0 + $val1; }
	}
	if (UNIVERSAL::isa($val2, "Date::Object::Date")) {
		$sec2 = $val2->in_seconds();
	} else {
		# Ok, is it a date string?
		if (valid_datestr($val2)) { $sec2 = datestr_to_secs($val2); }
		# IF NOT, **ASSUME** seconds
		else { $sec2 = 0 + $val2; }
	}

	return ($sec1 <=> $sec2);
}

# Mainly a convience method (can be achieved through other combinations) to get whether
# two dates are in the same month, same year.
sub monthcmp {
	my $val1 = shift;
	my $val2 = shift;

	if (not (UNIVERSAL::isa($val1, "Date::Object::Date"))) {
		die "Cannot compare the month of $val1";
	}
	if (not (UNIVERSAL::isa($val2, "Date::Object::Date"))) {
		die "Cannot compare the month of $val2";
	}

	my $result = yearcmp($val1, $val2);
	if ($result == 0) {
		# if the years are equal, check the months
		if ($val1->month() < $val2->month()) {
			$result = -1;
		} elsif ($val1->month() > $val2->month()) {
			$result =  1;
		} else {
			$result =  0;
		}
	}
	return $result;
}

# Mainly a convience method (can be achieved through other combinations) to get whether
# two dates are in the same year.
sub yearcmp {
	my $val1 = shift;
	my $val2 = shift;

	if (not (UNIVERSAL::isa($val1, "Date::Object::Date"))) {
		die "Cannot compare the year of $val1";
	}
	if (not (UNIVERSAL::isa($val2, "Date::Object::Date"))) {
		die "Cannot compare the year of $val2";
	}

	my $result = 0;
	if ($val1->year() < $val2->year()) {
		$result = -1;
	} elsif ($val1->year() > $val2->year()) {
		$result =  1;
	} else {
		$result =  0;
	}
	return $result;
}

# Used to get the previous month, irregardless of the day.  I.e. this
# will always be a date in the previous month, even if the days don't work
# out (i.e. July 31 will be June 30).
sub previous_month {
	my $date = shift;
	my $month_val = shift;

	if (not defined($date)) {
		return undef;
	} else {
		if (not defined($month_val)) {
			$month_val = 1;
		}
		my $val = $date->clone();
		$val->set_month( $val->month() - $month_val);
		$val->trunc_month_day_vals();
		return $val;
	}
}

sub days_in_month {
	my $month = shift;
	my $year = shift;

	# If not february
	if ($month != 1) { return $DoM[$month]; }

	# Else
	if ( (not defined($year)) || (not leapyear($year)) ) { return $DoM[$month]; }
	else { return $DoMLY[$month]; }
}

sub leapyear {
	my $year = shift;

	return (($year1 % 400 == 0) || (($year1 % 4 == 0) && ($year1 % 100 != 0))) ? 1 : 0;
}

sub leapyear_cnt {
	my $year1 = shift;
	my $year2 = shift;

	if ($year1 > $year2) {
		my $t = $year2;
		$year2 = $year1;
		$year1 = $t;
	}

	my $lyc = 0;
	if (($year1 % 400 == 0) || (($year1 % 4 == 0) && ($year1 % 100 != 0))) { $lyc++; }
	
	return $lyc;
}

# ******************** Instance Methods ******************************
sub new {
	my $class = shift;
	my $date_val = shift;
	my $self = Date::Object::SecondsQuantity->new();

	my $year;
	my $month;
	my $day;
	if (not defined($date_val)) {
		my @time = localtime;
		$year = $time[5];
		$month = $time[4];
		$day = $time[3];
	} elsif (UNIVERSAL::isa($date_val, "Date::Object::Date")) {
		# we have all we need, clone and return
		$self = $date_val->clone();
		return $self;
	} elsif (not valid_datestr($date_val)) {
		my @time = localtime;
		$year = $time[5];
		$month = $time[4];
		$day = $time[3];
	} else {
		my @time = datestr_to_ctime($date_val);
		$year = $time[5];
		$month = $time[4];
		$day = $time[3];
	}
	
	# Ok, this will seem redundant at first.
	# We do this so we can tell objects apart later.  With string overloading,
	# there's no real way to find out if two references point to the same thing,
	# since they both call string() and that will be true if the values are equal
	# even if they are not the same reference.  See same_obj().
	$self->{id} = $self;
	
	$self->{year} = $year;
	$self->{month} = $month;
	$self->{day} = $day;

	bless $self, $class;

	return $self;
}

sub set {
	my $self = shift;
	my $date_val = shift;

	my $year;
	my $month;
	my $day;
	if (not defined($date_val)) {
		return $self;
	} elsif (UNIVERSAL::isa($date_val, "Date::Object::Date")) {
		if ($self == $date_val) {
			# are we trying to assign to ourselves?
			return $self;
		} else {
			$self->{year} = $date_val->{year};
			$self->{month} = $date_val->{month};
			$self->{day} = $date_val->{day};
			return $self;
		}
	} elsif (not valid_datestr($date_val)) {
		return $self;
	} else {
		@time = datestr_to_ctime($date_val);
		$year = $time[5];
		$month = $time[4];
		$day = $time[3];
		$self->{year} = $year;
		$self->{month} = $month;
		$self->{day} = $day;

		return $self;
	}
	
}

sub set_seconds {
	my $self = shift;
	my $secs_val = shift;

	if (defined($secs_val)) {
		@time = localtime($secs_val);
		$self->{year} = $time[5];
		$self->{month} = $time[4];
		$self->{day} = $time[3];
	}
	return $self;
}	

sub add_self {
	my $self = shift;
	my $val = shift;
	my $inversed = shift;

	if (not defined($inversed)) { $inversed = 0; }

	if (not defined($val)) {
		if ($inversed) {
			return $self->in_seconds();
		} else {
			return $self;
		}
	} else {
		my $sec_val = 0;
		# God only knows why you would want to add two dates, but just
		# in case
		if (UNIVERSAL::isa($val, "Date::Object::Date")) {
			$self->set_seconds( $self->in_seconds() + $val->in_seconds() );
		} else {
			my @vals = datequant_to_vals($val);
			$self->set_year($self->year() + $vals[0]);
			$self->set_month($self->month() + $vals[1]);
			# If we don't do it this way, we totally screw up.
			# The current value serves as a place holder.
			# Now we add on the seconds--thus shifting the appropriate
			# number of days.
			$self->round_month_day_vals();
			$sec_val = $vals[2] * 24 * 60 * 60;
			$self->set_seconds( $self->in_seconds + $sec_val);
		}
	}
	if ($inversed) {
		return $self->in_seconds();
	} else {
		return $self;
	}
}		

sub add {
	my $self = shift;
	my $val = shift;
	my $inversed = shift;

	my $clone = $self->clone();

	return $clone->add_self($val, $inversed);
}		

sub subtract_self {
	my $self = shift;
	my $val = shift;
	my $inversed = shift;

	if (not defined($inversed)) { $inversed = 0; }

	if (not defined($val)) {
		if ($inversed) {
			return $self->in_seconds();
		} else {
			return $self;
		}
	} else {
		# God only knows why you would want to add two dates, but just
		# in case
		if (UNIVERSAL::isa($val, "Date::Object::Date")) {
			if ($inversed) {
				$self->set_seconds($val->in_seconds() - $self->in_seconds() );
			} else {
				$self->set_seconds( $self->in_seconds() - $val->in_seconds() );
			}
		} else {
			my @vals = datequant_to_vals($val);
			if ($inversed) {
				$self->set_year($vals[0] - $self->year());
				$self->set_month($vals[1] - $self->month());
				$self->round_month_day_vals();
				$self->set_seconds(($vals[2] * 24 * 60 * 60) - $self->in_seconds());
			} else {
				$self->set_year($self->year() - $vals[0]);
				$self->set_month($self->month() - $vals[1]);
				$self->round_month_day_vals();
				$self->set_seconds($self->in_seconds() - ($vals[2] * 24 * 60 * 60));
			}
		}
	}
	if ($inversed) {
		return $self->in_seconds();
	} else {
		return $self;
	}
}		

sub subtract {
	my $self = shift;
	my $val = shift;
	my $inversed = shift;

	my $clone = $self->clone();

	return $clone->subtract_self($val, $inversed);
}		

sub incr {
	my $self = shift;
	return $self->add_self(1);
}
	
sub decr {
	my $self = shift;
	return $self->subtract_self(1);
}

sub equal {
	my $self = shift;
	my $rval = shift;
	if (datecmp($self, $rval) eq 0) {
		return 1;
	} else {
		return 0;
	}
}
	
sub same_obj {
	my $self = shift;
	my $rval = shift;

	if ( (not defined($self)) && (not defined($self)) ) {
		return undef;
	} elsif ( (not defined($self)) || (not defined($self)) ) {
		return 0;
	}

	if ($self->{id} == $rval->{id}) {
		return 1;
	} else {
		return 0;
	}
}
	
sub lthan {
	my $self = shift;
	my $rval = shift;
	if (datecmp($self, $rval) lt 0) {
		return 1;
	} else {
		return 0;
	}
}
	
sub lequal {
	my $self = shift;
	my $rval = shift;
	my $result = datecmp($self, $rval);
	if (($result lt 0) || ($result eq 0)) {
		return 1;
	} else {
		return 0;
	}
}
	
sub gthan {
	my $self = shift;
	my $rval = shift;
	if (datecmp($self, $rval) gt 0) {
		return 1;
	} else {
		return 0;
	}
}
	
sub gequal {
	my $self = shift;
	my $rval = shift;
	my $result = datecmp($self, $rval);
	if (($result gt 0) || ($result eq 0)) {
		return 1;
	} else {
		return 0;
	}
}

sub clone {
	my $self = shift;

	my $clone = Date::Object::Date->new();

	$clone->set( $self->string() );
	return $clone;
}
	
sub in_seconds {
	my $self = shift;
	
	@time = (0, 0, 0, $self->{day}, $self->{month}, $self->{year}, 0, 0, 0);
	return timelocal(@time);
}

sub in_days {
	my $self = shift;
	
	return secs_to_days($self->in_seconds);
}

sub in_months {
	my $self = shift;
	
	my $months = $self->month;
	$months += ($self->year - 1970) * 12;

	return $months;
}

sub in_years {
	my $self = shift;
	
	return ($self->year - 1970);
}

sub string {
	my $self = shift;
	
	my $year = $self->{year} + 1900;
	my $month = $self->{month} + 1;
	my $day = $self->{day};
	
	if ($month < 10) {
		$month = "0$month";
	}
	if ($day < 10) {
		$day = "0$day";
	}

	return "$year-$month-$day";
}

sub year {
	my $self = shift;
	
	return $self->{year} + 1900;
}

sub set_year {
	my $self = shift;
	my $val = shift;

	if (not defined($val)) {
		return $self->year();
	} else {
		$self->{year} = $val - 1900;
		return $self->year();
	}
}
	

sub month {
	my $self = shift;
	
	return $self->{month} + 1;
}

sub set_month {
	my $self = shift;
	my $val = shift;

	if (not defined($val)) {
		return $self->month();
	} else {
		if ($val < 1) {
			my $year_diff = int($val / 12);
			$val = $val % 12;
			$val = (12 - $val); # because we use 0 indexed arrays, this works out ok
			$self->{year} = $self->{year} - $year_diff;
			$self->{month} = $val;
		} elsif ($val > 12) {
			my $year_diff = int($val / 12);
			$val = $val % 12;
			$val = ($val - 12 - 1); # the minus one is because we use 0 indexed arrays
			$self->{year} = $self->{year} + $year_diff;
			$self->{month} = $val;
		} else {
			$self->{month} = $val - 1; # we're fine
		}
		$self->round_month_day_vals();
		return $self->month();
	}
}

sub month_name {
	my $self = shift;
	
	return $MoY[$self->{month}];
}

sub month_nick {
	my $self = shift;
	
	return $MNoY[$self->{month}];
}

sub month_abbrev {
	my $self = shift;
	
	return $MAoY[$self->{month}];
}

sub day {
	my $self = shift;
	
	return $self->{day};
}

sub set_day {
	my $self = shift;
	my $val = shift;

	if (not defined($val)) {
		return $self->day;
	} else {
		if ($val < 1) {
			die "Invalid day for the month of ". $self->month();
		} elsif ($val > days_in_month($self->{month}, $self->{year})) {
			die "Invalid day for the month of ". $self->month();
		} else {
			$self->{day} = $val; # we're fine
			return $self->day();
		}
	}
}

sub add_days {
	my $self = shift;
	my $val = shift;

	$self->add_self($val);
	return $self;
}

sub subtract_days {
	my $self = shift;
	my $val = shift;

	$self->subtract_self($val);
	return $self;
}

sub weekday {
	my $self = shift;
	
	@time = (0, 0, 0, $self->{day}, $self->{month}, $self->{year}, 0, 0, 0);
	@time = localtime(timelocal(@time));
	return $time[6];
}

sub weekday_name {
	my $self = shift;
	
	return $DoW[$self->weekday()];
}

sub weekday_nick {
	my $self = shift;
	
	return $DNoW[$self->weekday()];
}

sub weekday_abbrev {
	my $self = shift;
	
	return $DAoW[$self->weekday()];
}

sub is_weekday_begin {
	my $self = shift;

	return ($self->weekday eq $WEEKBEGIN) ? 1 : 0;
}

sub is_weekday_end {
	my $self = shift;

	return ($self->weekday eq $WEEKEND) ? 1 : 0;
}

sub round_month_day_vals {
	my $self = shift;

	my $too_large = 0;
	# check to see if the day is too large for the month
	if (($self->month eq 1) && (leapyear($self->year))) {
		# if month is feb and a leap year, use leapyear vals
		$too_large = ($self->{day} > $DoMLY[$self->{month}])
	} else {
		$too_large = ($self->{day} > $DoM[$self->{month}])
	}

	# if too large, we need to reduce the day to the appropriate value
	# and then increment the month
	if ($too_large) {
		if (($self->month eq 1) && (leapyear($self->year))) {
			# if month is feb and a leap year, use leapyear vals
			$self->{day} = $self->{day} - $DoMLY[$self->{month}];
		} else {
			$self->{day} = $self->{day} - $DoM[$self->{month}];
		}
		if ($self->{month} == 11) {
			# if this is the last month, we need to increment the year and wrap around
			$self->{month} = 0;
			$self->{year}++;
		} else {
			# otherwise just increment
			$self->{month}++;
		}
	}
}
	
# Method #1 as described above, implemented to be called by a special
# function that might need it.
sub trunc_month_day_vals {
	my $self = shift;

	my $too_large = 0;
	if (($self->month eq 1) && (leapyear($self->year))) {
		# if month is feb and a leap year, use leapyear vals
		$too_large = ($self->{day} > $DoMLY[$self->{month}])
	} else {
		$too_large = ($self->{day} > $DoM[$self->{month}])
	}

	if ($too_large) {
		if (($self->month eq 1) && (leapyear($self->year))) {
			$self->{day} = $DoMLY[$self->{month}];
		} else {
			$self->{day} = $DoM[$self->{month}];
		}
	}
}	

# ******************** Date.pm END ******************************
1;

__END__

=head1 NAME

Date::Object::Date - wrap date functions to allow date quantities to be treated as numbers.

=head1 SYNOPSIS

    $date1 = Date::Object::Date->new();
    $date1->set("1999-09-09");
    $date2 = Date::Object::Date->new("2001-01-01");
    $date3 = $date1 + 1;
    $date4 = $date1 + "1y 2m 2d";
    for (my $idx = $date1; $idx < $date2; $idx++) {
        print $idx . "\n";
    }

=head1 DESCRIPTION

This object wraps calls to time and localtime to make date values
usable as mathemagical objects.  This allows you to perform date
arithmetic and use dates where you would normally use a number (like
a loop index).

Since this objects wraps perl's calls to ctime functions, it is
limited in the same way.  The same limitations and problems of using
UNIX seconds from the epoch apply to these objects.

=head1 IMPLEMENTATION

Please note that "==" is VERY different from "eq".  The first
checks to see if they are the same referenced object, while the
second checks if they are the same "value".

When setting via month or day, we "round" the date if it is too
large for the month.  Now, for the discussion:

Ok, there are two ways we could do this:
1) "Truncate" the days to fit the month
2) "Round" the date to the appropriate date next month

I am unsure which one to use.  I'm going to go with #2 for now,
until I hear a better reason.

Now if you are working with months, it doesn't seem to be a good
idea, since when you set month to month - 1, you want the last month
(e.g. under #2 "2001-07-31" month - 1 becomes "2001-07-01").
However, it preserves the weekday, mainly, you keep yourself in the
same "place" in the week, moving back a month--well, kind of.

If you want to be "accurate" by weekday, always use weeks.  If you
want accurately iterate over months, set the date to the 1st and add
away.

This becomes an issue if you want to get a date from the previous
month or want the previous month.  I provide both methods
(round_month_day_vals and trunc_month_day_vals), so if you need the
truncation, use it.  But the reality is that if you want the
previous month, you need to copy the date, set the day to 1, and the
subtract a month via set_month or addition.

Again, if you want weekday accuracy, you need to stick to days and
weeks.  The gregorian calendar system is just insane, and it
isn't my fault.

If you add a quantity to an existing date and cross a leap year, you
might lose a day due to the leap day.  I.e. adding days is accurate
except when spanning multiple years.  Use year quantities for moving
years at a time, since this will preserve your place in the calendar.

This isn't necessarily a bug, but a "feature" of the gregorian
calendar.

=head1 BUGS

This object currently wraps localtime.  This is probably an issue.

Should probably use gmtime.  Need to handle timezones and such, since
plays havoc with seconds values.  But it gets the job done.

=cut
