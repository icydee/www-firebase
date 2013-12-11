use lib '../lib';

use strict;
use warnings FATAL => 'all';
use Test::More;
use JSON::XS;
use MIME::Base64;

BEGIN {
    use_ok('WWW::Firebase::API') || die;
}

SKIP: {
    my $fb_name     = $ENV{www_firebase_test_name};
    my $fb_secret   = $ENV{www_firebase_test_secret};
    skip "www_firebase_test_name not defined", 22if not defined $fb_name;

    my $fb_api = WWW::Firebase::API->new({
        firebase    => $fb_name,
        secret      => $fb_secret,
    });
    isa_ok($fb_api, 'WWW::Firebase::API');

    my $response;
    $response = $fb_api->PUT('test/123', {
        foo     => 'bar',
        bar     => 3,
    });
   
}



done_testing();