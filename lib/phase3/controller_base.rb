require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
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
  end
end
