class Card

  def initialize(name)
    @name = name
    @trains = []
    validate!
    register_instance
    self.class.all << self
  end

end
