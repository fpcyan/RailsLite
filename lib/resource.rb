class Resource

  def initialize(noun, action_name, suffix, parent)
    @noun = noun.to_s
    @action_name = action_name
    @suffix = suffix
    @parent = parent_route
    @pattern = build_route_pattern
  end

  def build_route_pattern
    base = build_base
    Regexp.new(base + @noun + @suffix)
  end

  def build_base
    if @parent.empty?
      "^/"
    else
      "^/#{@parent}/(?<#{@parent.singularize}_id>\d+)/"
    end
  end
end
