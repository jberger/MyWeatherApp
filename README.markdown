This demo was created to support <https://mojolicious.io/blog/2017/12/06/day-6-adding-your-own-commands>.
It is not intended for production use.

It requires an API key from <http://home.openweathermap.org/users/sign_up>.

Configuation is given via `myweatherapp.conf`.
Only the `appid` field is required.

    {
      appid => 'XXXXXXXXXX',
      search => ['Chicago', 'Seattle'],
      units => 'imperial', # default is "metric"
      file => 'weather.db', # the default value
    }

This code is copyright (c) 2017 Joel Berger.
It is released under the same terms as Perl 5.
