package MyWeatherApp;
use Mojo::Base 'Mojolicious';

use Mojo::SQLite;
use MyWeatherApp::Model::Weather;

has sqlite => sub {
  my $app = shift;
  my $file = $app->config->{file} // 'weather.db';
  my $sqlite = Mojo::SQLite->new("dblite:$file");
  $sqlite->migrations->from_data;
  return $sqlite;
};

sub startup {
  my $app = shift;

  $app->moniker('myweatherapp');
  $app->plugin('Config');

  push @{ $app->commands->namespaces }, 'MyWeatherApp::Command';

  $app->helper('weather' => sub {
    my $c = shift;
    my $config = $c->app->config;
    return MyWeatherApp::Model::Weather->new(
      sqlite => $app->sqlite,
      appid => $config->{appid},
      units => $config->{units} || 'metric',
    );
  });

  my $r = $app->routes;
  $r->get('/weather' => sub {
    my $c = shift;
    my $search = $c->param('q');
    return $c->render(status => 400, text => 'q parameter is required')
      unless $search;
    my $data = $c->weather->recall($search);
    $c->render(json => $data);
  });
}

1;

__DATA__

@@ migrations

-- 1 up

CREATE TABLE weather (
  id INTEGER PRIMARY KEY,
  search TEXT NOT NULL,
  time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  temperature REAL NOT NULL
);

-- 1 down

DROP TABLE IF EXISTS weather;

