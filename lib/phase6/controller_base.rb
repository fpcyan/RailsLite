require_relative '../phase5/controller_base'
require 'byebug'

module Phase6
  class ControllerBase < Phase5::ControllerBase
    # use this with the router to call action_name (:index, :show, :create...)
    def invoke_action(name)
      if already_built_response?
        (raise "Can only render once")
      else
        send(name)
      end
    end

  end
end
