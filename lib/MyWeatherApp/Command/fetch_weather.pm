package MyWeatherApp::Command::fetch_weather;
use Mojo::Base 'Mojolicious::Command';

has description => 'Fetch and cache the current weather';
has usage => <<"USAGE";
$0 fetch_weather [SEARCH, ...]

All arguments are search terms.
If none are given, the "search" field in the configuration is used.

USAGE

sub run {
  my ($self, @args) = @_;
  my $app = $self->app;

  unless (@args) {
    @args = @{ $app->config->{search} || [] };
  }

  for my $search (@args) {
    my $result = $app->weather->fetch($search);
    $app->weather->insert($search, $result);
  }
}

1;

