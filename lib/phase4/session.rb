require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req, res = nil)
      cookie = req.cookies.find { |cookie| cookie.name == "_rails_lite_app" }
      if cookie.nil?
        @session_data = {}
      else
        @session_data = JSON.parse(cookie.value)
      end
    end


    def [](key) #read cookie
      @session_data[key]
    end

    def []=(key, val)
      @session_data[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies << WEBrick::Cookie.new("_rails_lite_app", @session_data.to_json)
    end
  end
end
