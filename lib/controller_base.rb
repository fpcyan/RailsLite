require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'

require_relative './session'
require_relative './params'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @already_built_response = false
    @params = Params.new(req, route_params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response?
      raise "Can only render once"
    else
      @already_built_response = true
      @res.status = 302
      @res.header["location"] = "#{url}"
      @res.cookies << session.store_session(@res)
    end
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    if already_built_response?
      raise "Can only render once"
    else
      @already_built_response = true
      @res.content_type = "#{content_type}"
      @res.body = "#{content}"
      @res.cookies << session.store_session(@res)
    end
  end

  def render(template_name)
    if already_built_response?
      (raise "Can only render once")
    else
      template_path = "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
      template = File.read(template_path)
      content = ERB.new(template).result(binding)
      render_content(content, "text/html")
    end
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  def invoke_action(name)
    if already_built_response?
      (raise "Can only render once")
    else
      send(name)
    end
  end
end
