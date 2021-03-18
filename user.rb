class User < Member
  def initialize(name)
    super
    @name = name
  end
end
