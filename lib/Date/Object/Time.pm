# Time object
#
# Makes working with time easier for my code
#

package Date::Object::Time;

use Time::Local;
use Date::Object::SecondsQuantity;

require Exporter;
@ISA=qw(Exporter Date::Object::SecondsQuantity);
@EXPORT=qw(
		  );
@EXPORT_OK=qw(
			 );

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

# ******************** Class Methods ******************************

sub valid_timestr {
	my $time_val = shift;

	if ((not defined($time_val)) && ($time_val !~ m/\d\d:\d\d:\d\d/)) {
		return 0;
	} else {
		return 1;
	}
}

sub timestr_to_ctime {
	my $time_val = shift;
	
	if (not valid_timestr($timestr)) {
		return undef;
	} else {
		my ($hours, $mins, $secs) = ($time_val =~ m/(\d\d):(\d\d):(\d\d)/);
		$hours = 0 + $hours;
		$mins = 0 + $mins;
		$secs = 0 + $secs;
		if ($hours > 23) { $hours = $hours - 24; }
		if ($mins > 59) { $hours = $hours - 60; }
		if ($secs > 59) { $hours = $hours - 59; }
		my @time = ($secs, $mins, $hours, 0, 0, 0, 0, 0, 0);
		return @time;
	}
}

sub ctime_to_hhmmss {
	my @time = @_;

	if (@time < 3) {
		return undef;
	}

	my $hours = $time[2];
	my $mins = $time[1];
	my $secs = $time[0];

	$hours = 0 + $hours;
	$mins = 0 + $mins;
	$secs = 0 + $secs;

	if ($hours < 10) {
		$hours = "0$hours";
	} else {
		$hours = "$hours";
	}
	if ($mins < 10) {
		$mins = "0$mins";
	} else {
		$mins = "$mins";
	}
	if ($secs < 10) {
		$secs = "0$secs";
	} else {
		$secs = "$secs";
	}

	return "$hours:$mins:$secs";
}

sub ctime_to_hmmssn {
	my @time = @_;

	if (@time < 3) {
		return undef;
	}

	my $hours = $time[2];
	my $mins = $time[1];
	my $secs = $time[0];

	$hours = 0 + $hours;
	$mins = 0 + $mins;
	$secs = 0 + $secs;

	my $night = 0;

	if ($hours < 10) {
		$hours = "$hours";
	} elsif ($hours > 12) {
		$hours = $hours - 12;
		$night = 1;
	} else {
		$hours = "$hours";
	}
	if ($mins < 10) {
		$mins = "0$mins";
	} else {
		$mins = "$mins";
	}
	if ($secs < 10) {
		$secs = "0$secs";
	} else {
		$secs = "$secs";
	}

	my $timestr = "$hours:$mins:$secs ";
	if ($night) {
		$timestr .= "PM";
	} else {
		$timestr .= "AM";
	}

	return $timestr;
}

sub timequant_to_secs {
	my $math_val = shift;

	my $hours = 0;
	my $mins = 0;
	my $secs = 0;

	if ($math_val !~ m/[hms]/i) {
		# if just a solid number, assume this is days
		$days = 0 + $math_val;
	} else {
		($hours) = ($math_val =~ m/\D*?(\d+?)[h]/i);
		($mins) = ($math_val =~ m/\D*?(\d+?)[m]/i);
		($secs) = ($math_val =~ m/\D*?(\d+?)[s]/i);
	}

	if (not defined($hours)) { $hours = 0; }
	if (not defined($mins)) { $mins = 0; }
	if (not defined($secs)) { $secs = 0; }

	my $secs_total = $secs;
	$secs_total += $hours * 60 * 60;
	$secs_total += $mins * 60;
	
	return $secs_total;
}

sub timequant_to_vals {
	my $math_val = shift;

	my $hours = 0;
	my $mins = 0;
	my $secs = 0;

	if ($math_val !~ m/[hms]/i) {
		# if just a solid number, assume this is days
		$days = 0 + $math_val;
	} else {
		($hours) = ($math_val =~ m/\D*?(\d+?)[h]/i);
		($mins) = ($math_val =~ m/\D*?(\d+?)[m]/i);
		($secs) = ($math_val =~ m/\D*?(\d+?)[s]/i);
	}

	if (not defined($hours)) { $hours = 0; }
	if (not defined($mins)) { $mins = 0; }
	if (not defined($secs)) { $secs = 0; }

	$hours = 0 + $hours;
	$mins = 0 + $mins;
	$secs = 0 + $secs;

	@vals = ($hours, $mins, $secs);
	return @vals;
}

sub secs_to_timequant {
	my $secs = shift;

	if (not defined($secs)) { return undef; }

	my $hours = int($secs / (60 * 60));
	$secs = $secs % (60 * 60);
	my $mins = int($secs / (60));
	$secs = $secs % (60);

	my $datequant = $hours;
	$datequant .= "H ";
	$datequant .= $mins;
	$datequant .= "M ";
	$datequant .= $secs;
	$datequant .= "S";

	return $datequant;
}

sub vals_to_timequant {
	my $hours = shift;
	my $mins = shift;
	my $secs = shift;

	if (not defined($hours)) { $hours = 0; }
	if (not defined($mins)) { $mins = 0; }
	if (not defined($secs)) { $secs = 0; }

	my $math_val = "";

	$math_val .= $hours;
	$math_val .= "H ";
	$math_val .= $mins;
	$math_val .= "M ";
	$math_val .= $secs;
	$math_val .= "S";

	return $math_val;
}

sub timestr_to_secs {
	my $time_val = shift;

	if (not valid_timestr($time_val)) {
		return undef;
	} else {
		@time = timestr_to_ctime($time_val);
		return timelocal(@time);
	}
}

sub timecmp {
	my $val1 = shift;
	my $val2 = shift;

	if ((not defined($val1)) || (not defined($val2))) {
		return undef;
	}

	my $secs1 = 0;
	my $secs2 = 0;

	if (UNIVERSAL::isa($val1, "Date::Object::Time")) {
		$secs1 = $val1->in_seconds();
	} else {
		$secs1 = 0 + $val1;
	}
	if (UNIVERSAL::isa($val2, "Date::Object::Time")) {
		$secs2 = $val2->in_seconds();
	} else {
		$secs2 = 0 + $val2;
	}

	my $result = 0;
	if ($secs1 < $secs2) {
		$result = -1;
	} elsif ($secs1 > $secs2) {
		$result =  1;
	} else {
		$result =  0;
	}
	return $result;
}


	

# ******************** Instance Methods ******************************

sub new {
	my $class = shift;
	my $time_val = shift;

	my $self = Date::Object::SecondsQuantity->new();
	
	$self->{id} = $self;

	if (not valid_timestr($time_val)) {
		$self->{hours} = $time[2];
		$self->{mins} = $time[1];
		$self->{secs} = $time[0];
	} else {
		@time = timestr_to_ctime($time_val);
		$self->{hours} = $time[2];
		$self->{mins} = $time[1];
		$self->{secs} = $time[0];
	}

	bless $self, $class;

	return $self;
}

sub set {
	my $self = shift;
	my $time_val = shift;

	my $hours;
	my $mins;
	my $secs;
	if (not defined($time_val)) {
		return $self;
	}
	if ($self == $time_val) {
		# are we trying to assign to ourselves?
		return $self;
	} elsif (UNIVERSAL::isa($time_val, "Date::Object::Time")) {
		$self->{hours} = $time_val->{hours};
		$self->{mins} = $time_val->{mins};
		$self->{secs} = $time_val->{secs};
		return $self;
	} elsif (not valid_datestr($time_val)) {
		return $self;
	} else {
		@time = timestr_to_ctime($time_val);
		$hours = $time[2];
		$mins = $time[1];
		$secs = $time[0];
		$self->{hours} = $hours;
		$self->{mins} = $mins;
		$self->{secs} = $secs;

		return $self;
	}
}

sub clone {
	my $self = shift;

	my $clone = Date::Object::Time->new();
	$clone->set( $self );

	return $clone;
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
		# God only knows why you would want to add two times since they will
		# probably wrap, but just in case
		if (UNIVERSAL::isa($val, "Date::Object::Time")) {
			$self->set_seconds( $self->in_seconds() + $val->in_seconds() );
		} else {
			my @vals = timequant_to_vals($val);
			$self->set_secs( $self->secs + $vals[2]);
			$self->set_mins($self->mins() + $vals[1]);
			$self->set_hours($self->hours() + $vals[0]);
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
		if (UNIVERSAL::isa($val, "RSH::SCH::Object::Date")) {
			if ($inversed) {
				$self->set_seconds($val->in_seconds() - $self->in_seconds() );
			} else {
				$self->set_seconds( $self->in_seconds() - $val->in_seconds() );
			}
		} else {
			my @vals = timequant_to_vals($val);
			if ($inversed) {
				$self->set_hours($vals[0] - $self->hours());
				$self->set_mins($vals[1] - $self->mins());
				$self->set_secs($vals[2] - $self->secs());
			} else {
				$self->set_hours($self->hours() - $vals[0]);
				$self->set_mins($self->mins() - $vals[1]);
				$self->set_secs($self->secs() - $vals[2]);
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
	if (timecmp($self, $rval) eq 0) {
		return 1;
	} else {
		return 0;
	}
}
	
sub same_obj {
	my $self = shift;
	my $rval = shift;
	if ($self->{id} == $rval->{id}) {
		return 1;
	} else {
		return 0;
	}
}
	
sub lthan {
	my $self = shift;
	my $rval = shift;
	if (timecmp($self, $rval) lt 0) {
		return 1;
	} else {
		return 0;
	}
}
	
sub lequal {
	my $self = shift;
	my $rval = shift;
	my $result = timecmp($self, $rval);
	if (($result lt 0) || ($result eq 0)) {
		return 1;
	} else {
		return 0;
	}
}
	
sub gthan {
	my $self = shift;
	my $rval = shift;
	if (timecmp($self, $rval) gt 0) {
		return 1;
	} else {
		return 0;
	}
}
	
sub gequal {
	my $self = shift;
	my $rval = shift;
	my $result = timecmp($self, $rval);
	if (($result gt 0) || ($result eq 0)) {
		return 1;
	} else {
		return 0;
	}
}

sub string {
	my $self = shift;
	my $format = shift;

	if (not defined($format)) { $format = "hh:mm:ss"; }

	if ($format =~ /h:mm:ss n/) {
		return ctime_to_hmmssn($self->{secs}, $self->{mins}, $self->{hours});
	} else {
		return ctime_to_hhmmss($self->{secs}, $self->{mins}, $self->{hours});
	}
}

sub hours {
	my $self = shift;
	return $self->{hours};
}

sub set_hours {
	my $self = shift;
	my $val = shift;

	if (not defined($val)) {
		return $self->hours;
	} else {
		if ($val > 23) {
			$val -= 24;
		}
		$self->{hours} = $val;
		return $self->hours;
	}
}

sub in_hours {
	my $self = shift;
	return $self->{hours};
}

sub mins {
	my $self = shift;
	return $self->{mins};
}

sub set_mins {
	my $self = shift;
	my $val = shift;

	if (not defined($val)) {
		return $self->mins;
	} else {
		if ($val > 59) {
			my $hours = int($val / 60);
			$val = $val % 60;
			$self->set_hours( $self->{hours} + $hours);
		}
		$self->{mins} = $val;
		return $self->mins;
	}
}

sub in_minutes {
	my $self = shift;
	
	my $mins = $self->mins;
	$mins += $self->hours * 60;
	return $mins;
}

sub secs {
	my $self = shift;
	return $self->{secs};
}

sub set_secs {
	my $self = shift;
	my $val = shift;

	if (not defined($val)) {
		return $self->secs;
	} else {
		if ($val > 59) {
			my $mins = int($val / 60);
			$val = $val % 60;
			$self->set_mins( $self->{mins} + $mins);
		}
		$self->{secs} = $val;
		return $self->secs;
	}
}

# Contrasted with secs, this is the whole time value in seconds, not just
# the seconds part of HH:MM:SS
sub in_seconds {
	my $self = shift;

	my $secs = $self->{hours} * 60 * 60;
	$secs += $self->{mins} * 60;
	$secs += $self->{secs};

	return $secs
}

# Actually makes a time object out of the raw seconds data, ignoring anything over
# a day in size (i.e. we focus only on the time portion
sub set_seconds {
	my $self = shift;
	my $secs_val = shift;

	if (defined($secs_val)) {
		@time = localtime($secs_val);
		$self->{hours} = $time[2];
		$self->{mins} = $time[1];
		$self->{secs} = $time[0];
	}
	return $self;
}	

# ******************** Time END ******************************
1;

__END__

=head1 NAME

Date::Object::Time - provides a way to work with time values in non-seconds forms

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 IMPLEMENTATION

=head1 BUGS

=cut
