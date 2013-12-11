package WWW::Firebase::TokenGenerator;

use Moose;
use JSON;
use JSON::WebToken;
use DateTime;
use Data::Dumper;

has 'secret' => (
    is          => 'rw',
    isa         => 'Str',
    required    => 1,
);

has 'version' => (
    is          => 'ro',
    isa         => 'Int',
    default     => 0,
);

has 'expires' => (
    is          => 'rw',
    isa         => 'Maybe[DateTime]',
);

has 'not_before' => (
    is          => 'rw',
    isa         => 'Maybe[DateTime]',
);

has 'debug' => (
    is          => 'rw',
    isa         => 'Maybe[Int]',
);

has 'admin' => (
    is          => 'rw',
    isa         => 'Maybe[Int]',
);

has 'algorithm' => (
    is          => 'rw',
    isa         => 'Str',
    default     => 'HS256',
);

sub create_token {
    my ($self, $data) = @_;

    # ensure that data is JSONifiable
    $data = $data || {};
    my $json = encode_json($data);

    my $claims = {
        d       => $data,
        v       => $self->version,
        iat     => time,
    };
    $claims->{admin}    = $self->admin if $self->admin;
    $claims->{debug}    = $self->debug if $self->debug;
    $claims->{nbf}      = $self->not_before->epoch if defined $self->not_before;
    $claims->{exp}      = $self->expires->epoch if defined $self->expires;

    my $jwt = encode_jwt($claims, $self->secret, $self->algorithm);
}


1;

=head1 NAME

WWW::Firebase::TokenGenerator - Authentication token generation for firebase.com

=head1 SYNOPSIS

 use WWW::Firebase::TokenGenerator;

 my $token = WWW::Firebase::TokenGenerator->new({
     secret     => 'mysecret',
     admin      => 1,
 })->create_token({this => 'is', some => 'data'});

=head1 DESCRIPTION

This module provides a Perl class to generate authentication tokens for
L<http://www.firebase.com>.

See L<http://www.firebase.com/docs/security/custom-login.html> for full
details of the specification.

=head1 METHODS

=head2 new

Constructor.

=over

=item secret (Required)

The API secret provided by firebase.com

=item admin (optional)

Defaults to C<false>. If set to C<true> then full access will be granted for
this token.

=item debug (optional)

Defaults to C<false>. If set to C<true> then verbose messages will be returned
from service calls.

=item expires (optional)

Defaults to 24 hours from the issued date. An epoch date.

=item not_before (optional)

Defaults to now. The token will not be valid before this date. An epoch date.

=item token_version (optional)

Defaults to C<0>.

=back

=head2 create_token

Generates a signed token.

=over

=item data (required)

A hash reference of parameters you with to pass to the service.

=back

=head1 AUTHOR

Iain C Docherty (icydee) C<< <cpan at iain-docherty.com> >>

=head1 SUPPORT

=over

=item Source Code Repository

L<https://github.com/icydee/www-firebase>

=item Issue Tracker

L<https://github.com/icydee/www-firebase/issues>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Iain C Docherty (icydee)

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut



