package DB::Twitter;

use strict;
use warnings;
use base qw/DBIx::Class/;
__PACKAGE__->load_components(qw/ PK::Auto Core /);
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
1;