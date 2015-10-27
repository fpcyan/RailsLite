require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      query_string = req.query_string || query_string = ""
      body_params_string = req.body || body_params_string = ""

      query_params = parse_www_encoded_form(query_string)
      req_body_params = parse_www_encoded_form(body_params_string)
      @params = route_params.merge(query_params).merge(req_body_params)
    end

    def [](key)
      @params[key]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      param_arrays = URI::decode_www_form(www_encoded_form)
      param_arrays.reduce({}) { |accum, array| accum[array[0]] = array[1]; accum }
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/).
    end
  end
end
