class Resource
  attr_reader :pattern

  def initialize(noun, suffix, parent)
    @noun = noun.to_s
    @pattern = build_route_pattern(suffix, parent)
  end

  def build_route_pattern(suffix, parent)
    base = build_base(parent)
    Regexp.new(base + @noun + @suffix)
  end

  def build_base(parent)
    if parent.empty?
      "^/"
    else
      "^/#{parent}/(?<#{parent.singularize}_id>\d+)/"
    end
  end

  def classify
    Object.const_get(@noun.capitalize)
  end
end
