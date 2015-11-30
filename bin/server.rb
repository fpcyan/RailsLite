require 'active_support'
require 'active_support/core_ext'
require 'webrick'
require_relative '../lib/controller_base'
require_relative '../lib/router'

class MyController < ControllerBase
  def go
    session["count"] ||= 0
    session["count"] += 1
    render :counting_show
  end
end

class Cat
  attr_reader :name, :owner

  def self.all
    @cat ||= []
  end

  def initialize(params = {})
    params ||= {}
    @name, @owner = params["name"], params["owner"]
  end

  def save
    return false unless @name.present? && @owner.present?

    Cat.all << self
    true
  end

  def inspect
    { name: name, owner: owner }.inspect
  end
end

class CatsController < ControllerBase
  def create
    @cat = Cat.new(params["cat"])
    if @cat.save
      redirect_to("/cats")
    else
      render :new
    end
  end

  def index
    @cats = Cat.all
    render :index
  end

  def new
    @cat = Cat.new
    render :new
  end
end


$cats = [
  { id: 1, name: "Curie" },
  { id: 2, name: "Markov" }
]

$statuses = [
  { id: 1, cat_id: 1, text: "Curie loves string!" },
  { id: 2, cat_id: 2, text: "Markov is mighty!" },
  { id: 3, cat_id: 1, text: "Curie is cool!" }
]

class StatusesController < ControllerBase
  def index
    statuses = $statuses.select do |s|
      s[:cat_id] == Integer(params[:cat_id])
    end

    render_content(statuses.to_s, "text/text")
  end
end

class Cats2Controller < ControllerBase
  def index
    render_content($cats.to_s, "text/text")
  end
end

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
