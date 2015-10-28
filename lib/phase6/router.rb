require 'byebug'
module Phase6
  class Route
    attr_reader :pattern, :http_method, :controller_class, :action_name

    def initialize(pattern, http_method, controller_class, action_name)
      @pattern = pattern
      @http_method = http_method
      @controller_class = controller_class
      @action_name = action_name
    end

    # checks if pattern matches path and method matches request method
    def matches?(req)
      unless @http_method == req.request_method.downcase.to_sym
        return false
      end
      # @pattern = Regexp.new("^/#{controller_class}(/[a-z]+)?(/\d+(/[a-z]+)?)+?")
      unless @pattern =~ req.path
        return false
      end
      true
    end

    # use pattern to pull out route params (save for later?)
    # instantiate controller and call controller action
    def run(req, res)
      route_params = {}

      pattern_match = @pattern.match(req.path)
      unless pattern_match.nil?
        pattern_match.names.each { |name| route_params[name] = pattern_match[name] }
      end
      controller_instance = @controller_class.new(req, res, route_params)
      controller_instance.invoke_action(action_name)
    end
  end

  class Router
    attr_reader :routes

    def initialize
      @routes = []
    end

    # simply adds a new route to the list of routes
    def add_route(pattern, method, controller_class, action_name)
      @routes << Route.new(pattern, method, controller_class, action_name)
    end

    # evaluate the proc in the context of the instance
    # for syntactic sugar :)
    def draw(&proc)

      self.instance_eval(&proc)
      # .result(binding)
    end

    # make each of these methods that
    # when called add route
    # def route_adder(pattern, controller_class, action_name)
      # add_route(pattern, route_adder.name, controller_class, action_name)
    # end

    [:get, :post, :put, :delete].each do |http_method|
      define_method(http_method) do |pattern, controller_class, action_name|
        add_route(pattern, http_method, controller_class, action_name)
      end
    end

    # should return the route that matches this request
    def match(req)
      @routes.find { |route| route.matches?(req) }
    end

    # either throw 404 or call run on a matched route
    def run(req, res)
      if match(req)
        match(req).run(req, res)
      else
        res.status = 404
      end
    end

  end
end
