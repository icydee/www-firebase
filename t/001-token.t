use lib '../lib';

use strict;
use warnings FATAL => 'all';
use Test::More;
use JSON::XS;
use MIME::Base64;

BEGIN {
    use_ok('WWW::Firebase::TokenGenerator') || die;
}

my $secret = 'onetwothree';
my $token_generator = WWW::Firebase::TokenGenerator->new({
    secret  => 'EiFR06EdQcht5WCiwSSPNGOcUK16dpUXc1OHp1cS',
    admin   => 1,
});

isa_ok($token_generator, 'WWW::Firebase::TokenGenerator');

my $my_data = {
    auth_data       => 'foo',
    other_auth_data => 'bar',
};

my $token = $token_generator->create_token($my_data);

diag $token;

my ($header, $claims, $signature) = split(/\./, $token);

is decode_json(decode_base64($claims))->{admin}, 1, 'claims encoded correctly';

done_testing();