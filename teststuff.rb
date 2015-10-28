# "a=1&b=2&c=a%20space" #=> {"a" => "1", "b" => "2", c => "a space"}
# "user[address][street]=main&user[address][zip]=89436" => { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }

# URI::decode_www_form("user[address][street]=main&user[address][zip]=89436") => [["user[address][street]", "main"], ["user[address][zip]", "89436"]]


simple = "a=1&b=2&c=a%20space"
nested = "user[address][street]=main&user[address][zip]=89436"


def parse_key(key)
  key.split(/\]\[|\[|\]/)
end

simple_split = ["a=1&b=2&c=a%20space"] #=> send through basic wwww encoder instead
nested_split = ["user", "address", "street", "=main&user", "address", "zip", "=89436"]


def nest_key_in_array(key)
  level = 0
  params = {}
  key.each do |full_key, value|
    p scope = params

    parsed = full_key.split(/\]\[|\[|\]/)
    p parsed
    parsed[0].reverse.reduce({}) { |accum, key| }
  end

end
