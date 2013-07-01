require 'digest/sha1'

module RememberMe
  module Model
    extend ::ActiveSupport::Concern

    included { field :remember_created_at, type: Time } if defined?(Mongoid)

    def remember_me!
      self.remember_created_at = Time.now.utc
      save(validate: false) if self.changed?
    end

    def forget_me!
      return if self.remember_created_at.nil?
      self.remember_created_at = nil
      save(validate: false)
    end

    def remember_expired?
      remember_created_at.nil? || (remember_expires_at <= Time.now.utc)
    end

    def remember_expires_at
      remember_created_at + self.class.remember_for
    end

    def rememberable_options
      self.class.rememberable_options
    end

    def rememberable_value
      Digest::SHA1.hexdigest "#{self.id}"
    end

    module ClassMethods
      def serialize_into_cookie(record)
        [record.id, record.rememberable_value]
      end

      def serialize_from_cookie(id, remember_token)
        record = where(id: id).first
        record if record && record.rememberable_value == remember_token && !record.remember_expired?
      end

      def rememberable_options
        {}
      end

      def remember_for
        2.weeks
      end
    end
  end
end
