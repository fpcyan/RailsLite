module CoreExtensions
  module String
    module Inflector
      def singularize
        return self unless self[-1] == "s"

        self[-3..-1] == "ies" ? singular_irregular : singular_regular
      end

      def singular_irregular
        self[0...-3] + "y"
      end

      def singular_regular
        self[0...-1]
      end

    end
  end
end

String.include CoreExtensions::String::Inflector

class DefaultActions
  def initialize(resource)
    @resource = resource.to_s
    @resource_id = @resource.singularize + "_id"
  end

  def all
    DefaultActions.instance_methods(false).drop(1).map do |method|
      send(method)
    end
  end

  def index
    { action: :index, suffix: "", method: :get }
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
