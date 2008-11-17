package App::SimpleAjaxDemo::DB::Twitter;

use strict;
use warnings;
use base qw/DBIx::Class/;
use DateTime::Format::SQLite;
__PACKAGE__->load_components(qw/ PK::Auto InflateColumn::DateTime Core/);
__PACKAGE__->table('twitter');
__PACKAGE__->add_columns(
	tweetid => {
		data_type => "integer",
		is_nullable => 0,
		is_auto_increment => 1,
	},
	time => {
		data_type => "datetime",
		is_nullable => 0,
	},
	user => {
		data_type => 'varchar',
		is_nullable => 0,
	},
	message => {
		data_type => "varchar",
		size => 256,
		is_nullable => 0,
	}
);
__PACKAGE__->set_primary_key('tweetid');

sub TO_JSON {
	my $self = shift;
	my $time = $self->time;
	{
		message => $self->message,
		user => $self->user,
		epochtime => $self->time->epoch,
		time => $self->time()->ymd . " " . $self->time()->hms,
	}
}

1;