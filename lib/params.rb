require 'uri'
class Params

  def initialize(req, route_params = {})
    @params = {}
    @params.merge!(route_params)
    if req.body
      @params.merge!(parse_www_encoded_form(req.body))
    end

    if req.query_string
      @params.merge!(parse_www_encoded_form(req.query_string))
    end

    @strong_params = []
  end

  def [](key)
    @params[key.to_s] || @params[key.to_sym]
  end

  def permit(*keys)
    keys.each do |key|
      next if @strong_params.include?(key)
      @strong_params.push(key)
    end
  end

  def permitted?(key)
    return @strong_params.include?(key)
  end

  def require(key)
    unless @params[key]
      raise(AttributeNotFoundError)
    end
  end

  # this will be useful if we want to `puts params` in the server log
  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  # this should return deeply nested hash
  def parse_www_encoded_form(www_encoded_form)
    params = {}

    key_values = URI.decode_www_form(www_encoded_form)
    key_values.each do |full_key, value|
      scope = params

      key_seq = parse_key(full_key)
      key_seq.each_with_index do |key, idx|
        if (idx + 1) == key_seq.count
          scope[key] = value
        else
          scope[key] ||= {}
          scope = scope[key]
        end
      end
    end

    params
  end

  # this should return an array
  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end

end
