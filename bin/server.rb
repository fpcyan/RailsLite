require 'active_support'
require 'active_support/core_ext'
require 'webrick'
require_relative '../controllers/cats_controller'
require_relative '../controllers/statuses_controller'
require 'byebug'

$cats = [
  { id: 1, name: "Curie" },
  { id: 2, name: "Markov" }
]
class ToysController < ControllerBase
  def new
    render_content($cats.to_s, "text/text")
  end
end
class StrategiesController < ControllerBase
  def edit
    render_content($cats.to_s, "text/text")
  end
end

router = Router.new
router.draw do

  resources :cats, :parent, only: [:index]  do
    resources :statuses, :nested, only: [:index]
    resources :toys, :nested, except: [:index, :show, :create, :edit, :update, :destroy]
  end
  resources :strategies, :parent, only: [:edit]
    # get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
end

server = WEBrick::HTTPServer.new(Port: 3000)


trap('INT') do
  server.shutdown
end


server.mount_proc("/") do |req, res|

  route = router.run(req, res)
end

server.start
