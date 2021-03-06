RememberMe
==========

[![Gem Version](https://badge.fury.io/rb/remember_me.png)][gem]
[![Build Status](https://secure.travis-ci.org/linyows/remember_me.png?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/linyows/remember_me.png?travis)][gemnasium]
[![Code Climate](https://codeclimate.com/github/linyows/remember_me.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/linyows/remember_me/badge.png?branch=master)][coveralls]

[gem]: https://rubygems.org/gems/remember_me
[travis]: http://travis-ci.org/linyows/remember_me
[gemnasium]: https://gemnasium.com/linyows/remember_me
[codeclimate]: https://codeclimate.com/github/linyows/remember_me
[coveralls]: https://coveralls.io/r/linyows/remember_me

RememberMe is a simple remember-me login solution on Rails.
Manages generating and clearing a token for remembering the user from a saved cookie.

![remember me](http://blog-imgs-60.fc2.com/k/u/g/kugibera/remember-me-robert.jpg)

Installation
------------

Add this line to your application's Gemfile:

    gem 'remember_me'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install remember_me

Usage
-----

controllers/application_controller.rb:

```ruby
class ApplicationController < ActionController::Base
  include RememberMe::Controller
end
```

models/user.rb:

```ruby
class User < ActiveRecord::Base
  include RememberMe::Model
end
```

if mongoid

```ruby
class User
  include Mongoid::Document
  include RememberMe::Model
end
```

controllers/sessions_controller.rb:

```ruby
class SessionsController < ApplicationController
  def create
    # ... authenticated ...

    self.current_user = @user
    remember_me(current_user) if remember_me?

    redirect_to root_path, notice: 'Success'
  end

  def destroy
    forget_me(current_user)
    self.current_user = nil
    redirect_to login_path, notice: 'Success'
  end
```

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Author
------

- [linyows](https://github.com/linyows)

License
-------

MIT
