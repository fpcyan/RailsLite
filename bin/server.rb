require 'active_support'
require 'active_support/core_ext'
require 'webrick'
require_relative '../controllers/cats_controller'
require_relative '../controllers/statuses_controller'
require 'byebug'

router = Router.new
router.draw do
  resources :cats, only: [:index] do
    resources :statuses, only: [:index]
  end
    # get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
end
byebug

server = WEBrick::HTTPServer.new(Port: 3000)


trap('INT') do
  server.shutdown
end


server.mount_proc("/") do |req, res|

  route = router.run(req, res)
end

server.start
