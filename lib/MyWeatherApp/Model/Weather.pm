package MyWeatherApp::Model::Weather;

use Mojo::Base -base;

use Carp ();
use Mojo::URL;
use Mojo::UserAgent;

has appid  => sub { Carp::croak 'appid is required' };
has sqlite => sub { Carp::croak 'sqlite is required' };
has ua     => sub { Mojo::UserAgent->new };
has 'units';

sub fetch {
  my ($self, $search) = @_;
  my $url = Mojo::URL->new('http://api.openweathermap.org/data/2.5/weather');
  $url->query(
    q => $search,
    APPID => $self->appid,
    units => $self->units || 'metric',
  );
  return $self->ua->get($url)->result->json;
}

sub insert {
  my ($self, $search, $result) = @_;
  $self->sqlite->db->query(<<'  SQL', $search, $result->{dt}, $result->{main}{temp});
    INSERT INTO weather (search, time, temperature)
    VALUES (?, ?, ?)
  SQL
}

sub recall {
  my ($self, $search) = @_;
  $self->sqlite->db->query(<<'  SQL', $search)->hashes;
    SELECT time, temperature
    FROM weather
    WHERE search=?
    ORDER BY time ASC
  SQL
}

1;


