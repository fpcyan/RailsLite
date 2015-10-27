require_relative '../phase3/controller_base'
require_relative './session'


# WEBRick::Cookie has name and value
# Our default name: _rails_lite_app
module Phase4
  class ControllerBase < Phase3::ControllerBase
    def redirect_to(url)
      super
      @res.cookies << session.store_session(@res)
    end

    def render_content(content, content_type)
      super
      @res.cookies << session.store_session(@res)
      end

    # method exposing a `Session` object
    def session
      @session ||= Session.new(@req)
    end
  end
end
