package MyWeatherApp::Command::deploy;
use Mojo::Base 'Mojolicious::Command';

use Mojo::Util 'getopt';

has 'description' => 'Deploy or update the MyWeatherApp schema';
has 'usage' => <<"USAGE";
$0 deploy [OPTIONS]

OPTIONS:
  -v , --version  the version to deploy
                  defaults to latest
USAGE

sub run {
  my ($self, @args) = @_;

  getopt(
    \@args,
    'v|version=i' => \my $version,
  );

  my $app = $self->app;
  $app->sqlite->migrations->migrate(defined $version ? $version : ());
}

1;

