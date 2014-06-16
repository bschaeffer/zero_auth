# ZeroAuth [![Build Status](https://travis-ci.org/bschaeffer/zero_auth.svg?branch=master)](https://travis-ci.org/bschaeffer/zero_auth)

**Zero configuration** authentication starter for your Rails project.

* Docs: http://rdoc.info/github/bschaeffer/zero_auth

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

* Docs: http://rdoc.info/github/bschaeffer/zero_auth/ZeroAuth/Model/Password
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

user.authenticate!('password') # => true
user.authenticate!('pa$$word') # => raises ZeroAuth::Unauthorized
```

##### Rails Setup

```ruby
# migration
change_table :users do |t|
  t.string :password_salt, null: false, default: ""
  t.string :password_hash, null: false, default: ""
end

# model
class User < ActiveRecord::Base
  include ZeroAuth::Model::Password
end
```

##### MongoMapper Setup

```ruby
class User < ActiveRecord::Base
  include MongoMapper::Document
  include ZeroAuth::Model::Password

  key :password_salt, String
  key :password_hash, String
end
```

## Contributing

1. Fork it (http://github.com/bschaeffer/zero_auth/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
