# SecondsValue
#
# Base class
#

package Date::Object::SecondsQuantity;

use Time::Local;

require Exporter;
@ISA=qw(Exporter);
@EXPORT=qw(
		  );
@EXPORT_OK=qw(
			 );

$Date::Object::SecondsQuantity::VERSION='0.01';

# use overload 
#   'bool' => \&in_seconds,
#   '0+' => \&in_seconds;

# ******************** Class Methods ******************************


# ******************** Instance Methods ******************************

sub new {
	my $class = shift;
	my $self = {};

	bless $self, $class;
	return $self;
}

sub in_seconds {
	my $self = shift;

	die "Please override in_seconds in your base class.";
}

# ******************** SecondsValue END ******************************
1;
