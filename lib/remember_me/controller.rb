module RememberMe
  module Controller
    def cookie_values
      Rails.configuration.session_options.slice(:path, :domain, :secure)
    end

    def remember_me?
      params.has_key?(:remember_me) && params[:remember_me]
    end

    def scope_of(resource)
      resource.class.to_s.underscore
    end

    def remember_me(resource)
      resource.remember_me!
      cookies.signed[remember_key(scope_of resource)] = remember_cookie_values(resource)
    end

    def forget_me(resource)
      resource.forget_me!
      cookies.delete remember_key(scope_of resource), forget_cookie_values(resource)
    end

    def remember_cookie_values(resource)
      options = { httponly: true }
      options.merge!(forget_cookie_values(resource))
      options.merge!(
        value: resource.class.serialize_into_cookie(resource),
        expires: resource.remember_expires_at
      )
    end

    def forget_cookie_values(resource)
      cookie_values.merge!(resource.rememberable_options)
    end

    def remember_key(scope)
      # remember_token_for_user
      :"_rtf#{scope}"
    end

    def remember(scope)
      cookie = cookies.signed[remember_key(scope)]
      "#{scope.classify}".constantize.serialize_from_cookie(*cookie) if cookie
    end
  end
end
