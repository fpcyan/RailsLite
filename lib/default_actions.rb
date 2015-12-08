require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'

class DefaultActions
  def initialize(resource)
    @resource = resource.to_s
    @resource_id = @resource.singularize + "_id"
  end

  def all
    DefaultActions.instance_methods(false).drop(1).reduce({}) do |accum, method|
      accum.merge(send(method))
    end
  end

  def index
    { index: { suffix: "", method: :get } }
  end

  def show
    { show: { suffix: "/(?<#{@resource_id}>\d+)", method: :post } }
  end

  def new
    { new: { suffix: "/new", method: :get } }
  end

  def create
    { create: { suffix: "", method: :post } }
  end

  def edit
    { edit: { suffix: "/(?<#{@resource_id}>\d+)/edit", method: :get } }
  end

  def update
    { update: { suffix: "/(?<#{@resource_id}>\d+)", method: :put } }
  end

  def destroy
    { destroy: { suffix: "/(?<#{@resource_id}>\d+)", method: :delete } }
  end


end
