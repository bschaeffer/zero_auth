module ZeroAuth
  module Model
    # The `Password` module includes the following features:
    #
    # * Password **salting** and **hashing** using `BCrypt`.
    # * Instance level authentication method.
    #
    # ...yup, that's it. The idea is to provide a quick, secure way to store
    # encrypted passwords. It is almost identical to Rails' own
    # [has_secure_password](http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html)
    # method, with the only exception being ZeroAuth uses a unique salt stored
    # alongside and used to compute a password's hash.
    #
    # ### Requirement
    #
    # Your object must be able to write to the `password_salt` and the
    # `password_hash` attributes (we handle the `password` attribute), so you
    # might want to do something like this in a Rails migration:
    #
    # ```ruby
    # change_table :users do |t|
    #   t.string :password_salt, null: false, default: ""
    #   t.string :password_hash, null: false, default: ""
    # end
    # ```
    #
    # ...or something like this using [`MongoMapper`](http://mongomapper.com/):
    #
    # ```ruby
    # class User
    #   include MongoMapper::Document
    #   include ZeroAuth::Model::Password
    #
    #   key :password_salt, String
    #   key :password_hash, String
    # end
    # ```
    #
    # ### Usage
    #
    # ```ruby
    # class User < ActiveRecord::Base
    #   include ZeroAuth::Model::Password
    # end
    #
    # user = User.create(email: 'email@me.com', password: 'password')
    #
    # user.has_password?('password') # => true
    # user.has_password?('pa$$w0rD') # => false
    #
    # user.authenticate!('password') # => true
    # user.authenticate!('pa$$word') # => raises ZeroAuth::Unauthorized
    # ```
    #
    # ### Implementing Validations
    #
    # This module provides a {#requires_password?} helper method that, by
    # default, simply checks whether this object is a `#new_record?` (if
    # we can check that) or if the `#password` attributes is `empty?`.
    #
    # Again, with ActiveRecord or ActiveModel as an example, you can utilize it
    # like this:
    #
    # ```ruby
    # class User < ActiveRecord
    #   include ZeroAuth::Model::Password
    #
    #   with_options if: :requires_password? do |pw|
    #     pw.validates :password, length: {in: 8..40}, confirmation: true
    #   end
    # end
    # ```
    #
    # You can also simply override the {#requires_password?} method to require
    # validation when an `:old_password` attribute is present:
    #
    # ```ruby
    # attr_accesor :old_password
    #
    # def requires_password?
    #   super || old_password.present?
    # end
    # ```
    #
    # ### Customize Authentication Class Method
    #
    # The {ZeroAuth::Model::Password} module leaves record retreival and the
    # exact authentication tree up to the developer, but implementing a
    # custom class method is trivial. An example using `ActiveRecord` might look
    # something like this:
    #
    # ```ruby
    # class User < ActiveRecord::Base
    #   include ZeroAuth::Model::Password
    #
    #   def self.authenticate(email, password)
    #     begin
    #       self.authenticate!(email, password)
    #     rescue ZeroAuth::Unauthorized
    #     end
    #   end
    #
    #   def self.authenticate!(email, password)
    #     begin
    #       record = self.find_by!(email: email)
    #       record.authenticate!(password) && record
    #     rescue ActiveRecord::RecordNotFound
    #       fail ZeroAuth::Unauthorized
    #     end
    #   end
    # end
    # ```
    #
    # **Note** the use of the {ZeroAuth::Unauthorized} exception. This is a
    # custom error class provided to allow a standard way for your application
    # to capture exceptions regarding authentication and authorization.
    #
    # The implementation above is certainly a personal perference, but the
    # logic, again, is left up to you.
    #
    module Password

      # Calls `attr_reader :password` on the including class.
      # @!visibility private
      #
      def self.included(base)
        base.class_eval { attr_reader :password }
      end

      # If the given password is not `nil?`, generates a `password_salt` and
      # encrypts the given password into the `password_hash` using that salt.
      # The salt and hash are generated using {ZeroAuth::Password.generate_salt}
      # and {ZeroAuth::Utils.create_password}.
      #
      # @param unencrypted_password [String] the unencrypted password_attribute
      # @return [Mixed] the unencrypted password
      #
      def password=(unencrypted_password)
        if unencrypted_password.nil?
          @password = nil
          self.password_salt = nil
          self.password_hash = nil
        else
          @password = unencrypted_password
          self.password_salt = ZeroAuth::Password.generate_salt
          self.password_hash = ZeroAuth::Password.create(password, password_salt)
        end
      end

      # Checks that the object is a `#new_record?` (if we can) or that the
      # `password` attribute is not empty.
      #
      # @return [Boolean]
      #
      def requires_password?
        is_new = (respond_to?(:new_record?) && new_record?)
        is_new || !ZeroAuth::Utils.empty?(password)
      end

      # A helper method that takes a given password and raises a
      # {ZeroAuth::Unauthorized} error if the call to `has_password?` fails.
      #
      # @params password [String] password to test
      #
      # @return [Nil]
      # @raise {ZeroAuth::Unauthorized} if the given password is not valid
      #
      def authenticate!(test_password)
        has_password?(test_password) || fail(ZeroAuth::Unauthorized)
      end

      # Compares the given password with the current password attributes using
      # {ZeroAuth::Utils.compare_password}.
      #
      # @param test_password [String] password to test
      # @return [Boolean]
      #
      def has_password?(test_password)
        return false unless !ZeroAuth::Utils.empty?(password_hash)
        ZeroAuth::Password.compare(password_hash, password_salt, test_password)
      end
    end
  end
end
