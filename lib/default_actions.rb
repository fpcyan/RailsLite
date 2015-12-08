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
    { action: :show, suffix: "/(?<#{@resource_id}>\d+)", method: :post }
  end

  def new
    { action: :new, suffix: "/new", method: :get }
  end

  def create
    { action: :create, suffix: "", method: :post }
  end

  def edit
    { action: :edit, suffix: "/(?<#{@resource_id}>\d+)/edit", method: :get }
  end

  def update
    { action: :update, suffix: "/(?<#{@resource_id}>\d+)", method: :put }
  end

  def destroy
    { action: :destroy, suffix: "/(?<#{@resource_id}>\d+)", method: :delete }
  end


end
