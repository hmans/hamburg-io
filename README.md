# hamburg.io

This is the source code for [hamburg.io](http://hamburg.io). It also serves as
an example application for the [Happy Web Application Toolkit](http://github.com/hmans/happy).

Feel free to clone and use this for building a similar site for your own city! The code
should run on pretty much any Ruby 1.9.x environment - hamburg.io is hosted on
[Heroku](http://www.heroku.com).

The code assumes the following environment variables to be set:

* `MONGOLAB_URI`, `MONGOHQ_URL` or `MONGO_URL` - the connection URLs to your MongoDB database. (Heroku will set these variables for you if you're using one of the available MongoDB addons.)
* `TWITTER_KEY` and `TWITTER_SECRET` - used for authenticating against Twitter. You'll get these by creating a Twitter API application at [dev.twitter.com](https://dev.twitter.com/).
* `NEW_RELIC_APP_NAME`, `NEW_RELIC_ID`, `NEW_RELIC_LICENSE_KEY` and `NEW_RELIC_LOG` - Heroku will set these automatically once you add the New Relic addon to your app.

## License

Copyright (c) 2012 Hendrik Mans

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
