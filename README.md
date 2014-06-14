# ZeroAuth [![Build Status](https://travis-ci.org/bschaeffer/zero_auth.svg?branch=master)](https://travis-ci.org/bschaeffer/zero_auth)

**Zero configuration** authentication starter for your Rails project.

## Installation

Add this line to your application's Gemfile:

    gem 'zero_auth'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zero_auth

## Usage

### Models

#### `ZeroAuth::Model::Password`

* Provides password salting and hashing using `BCrypt`.
* Instance method authentication.
* **Requires** `password_salt` and `password_hash` attributes.

```ruby
class User
  include ZeroAuth::Model::Password
  attr_accessor :password_salt, :password_hash
end

user = User.new
user.password = 'password'

user.password_salt # => BCrypt::Engine.generate_salt
user.password_hash # => BCrypty::Password

user.has_password?('password') # => true
user.has_password?('pa$$w0rD') # => false
```

## Contributing

1. Fork it (http://github.com/bschaeffer/zero_auth/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
