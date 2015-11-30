require_relative '../lib/controller_base'
require_relative '../lib/router'

$cats = [
  { id: 1, name: "Curie" },
  { id: 2, name: "Markov" }
]
class CatsController < ControllerBase
  def index
    render_content($cats.to_s, "text/text")
  end
end
