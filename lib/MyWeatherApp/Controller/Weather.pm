package MyWeatherApp::Controller::Weather;
use Mojo::Base 'Mojolicious::Controller';

sub recall {
  my $c = shift;
  my $search = $c->param('q');

  return $c->render(
    status => 400,
    text => 'q parameter is required',
  ) unless $search;

  my $data = $c->weather->recall($search);
  $c->render(json => $data);
}

1;

