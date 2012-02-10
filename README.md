# Picket

Picket is a free web site monitoring application. Consider it your own [wasitup.com](http://wasitup.com): "Get a notice when your web page goes down."

![](http://cl.ly/0m2e2H0X0N1a0g3j1702/%E8%9E%A2%E5%B9%95%E5%BF%AB%E7%85%A7%202012-02-10%20%E4%B8%8B%E5%8D%8802.23.28.png)

## Requirements

- Ruby 1.9.3
- Rails 3.2
- Mongodb
- Redis

## Install

- Checkout this repository
- Install dependencies by running command:
```
bundle install
```
- Edit the configuartion files in config/*.yml
- Setup default users (optionally edit db/seed.rb first):
```
bundle exec rake db:seed
```
- Run the applications by running command:
```
bundle exec foreman start -p 3000
```
- Open the browser at http://localhost:3000/
- Login with default email: email@example.com and password: 9!cke7

## Install via Vagrant

- Checkout this repository
- Install VirtualBox
- Install dependencies by running command:
```
bundle install
```
- Startup VM:
```
bundle exec vagrant up
```
- Setup default users (optionally edit db/seed.rb first):
```
bundle exec rake db:seed
```
- Run the applications by running command:
```
bundle exec foreman start -p 3000
```
- Open the browser at http://localhost:3000/
- Login with default email: email@example.com and password: 9!cke7

## Usage

- Add sites by "Add" button
- Sites will be checked every 5 minutes (configurable at config/application.yml)
- On status change, email notification will be sent (configurable in config/application.yml)

## License

The MIT License

Copyright (c) 2012 Francis Chong

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