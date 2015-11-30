require 'active_support'
require 'active_support/core_ext'
require 'webrick'
require_relative '../controllers/cats_2_controller'
require_relative '../controllers/statuses_controller'

router = Router.new
router.draw do
  # resources :cats, only: [:index] do
  #   resources :statuses, only: [:index]
  # end
  # get "/cats", Cats2Controller, :index
  # get "/cats/id/statuses", StatusesController, :index
  get Regexp.new("^/cats$"), Cats2Controller, :index
  get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
end


server = WEBrick::HTTPServer.new(Port: 3000)


trap('INT') do
  server.shutdown
end


server.mount_proc("/") do |req, res|

  # case [req.request_method, req.path]
  # when ['GET', '/cats']
  #   CatsController.new(req, res, {}).index
  # when ['POST', '/cats']
  #   CatsController.new(req, res, {}).create
  # when ['GET', '/cats/new']
  #   CatsController.new(req, res, {}).new
  # end

  route = router.run(req, res)
end

server.start
