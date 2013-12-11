package WWW::Firebase::API;

use Moose;
use LWP::UserAgent;
use JSON;
use Carp;
use URI;
use WWW::Firebase::TokenGenerator;

has base_uri    => (
    is          => 'ro',
    lazy        => 1,
    builder     => '_build_base_uri',
);

has firebase    => (
    is          => 'ro',
    required    => 1,
);

has secret      => (
    is          => 'rw',
    predicate   => 'has_secret',
);

has auth        => (
    is          => 'ro',
    lazy        => 1,
    builder     => '_build_auth',
);

has agent       => (
    is          => 'ro',
    lazy        => 1,
    builder     => '_build_agent',
);

sub _build_base_uri {
    my ($self) = @_;

    my $uri = 'https://'.$self->firebase.'.firebaseIO.com/';
    return $uri;
}

sub _build_auth {
    my ($self) = @_;

    my $auth = WWW::Firebase::TokenGenerator->new({
        secret  => $self->secret,
    });
    return $auth;
}

sub _build_agent {
    my ($self) = @_;

    my $agent = LWP::UserAgent->new(env_proxy => 1);
    $agent->proxy(['http'], 'http://applicationwebproxy.nomura.com');
    return $agent;
}

sub GET {
    my ($self, $path, $params) = @_;

    return $self->call({
        path    => $path,
        method  => 'GET',
        params  => $params,
    });
}

sub POST {
    my ($self, $path, $data, $params) = @_;

    return $self->call({
        path    => $path,
        method  => 'POST',
        params  => $params,
        data    => $data,
    });
}

sub PUT {
    my ($self, $path, $data, $params) = @_;

    return $self->call({
        path    => $path,
        method  => 'PUT',
        params  => $params,
        data    => $data,
    });
}

sub DELETE {
    my ($self, $path, $params) = @_;

    return $self->call({
        path    => $path,
        method  => 'DELETE',
        params  => $params,
    });
}

sub PATCH {
    my ($self, $path, $data, $params) = @_;

    return $self->call({
        path    => $path,
        method  => 'PATCH',
        params  => $params,
        data    => $data,
    });
}

sub call {
    my ($self, $args) = @_;

    my $params = $args->{params};
    
    if (defined $params) {
        $params .= '&';
    }
    else {
        $params = '';
    }
    $params .= 'auth='.$self->auth->create_token;
    
    my $uri = $self->base_uri.$args->{path}.'.json'."?$params";
    my $request = HTTP::Request->new($args->{method} => $uri);
    $request->content(encode_json($args->{data})) if $args->{data};

    print STDERR "CALL: $uri\n";
    my $response = $self->agent->request($request);

    if (not $response->is_success) {
        Carp::croak("HTTP Error (".$response->status_line.")");
    }
    return decode_json($response->content);
}
1;
