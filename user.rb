require_relative 'validation'

class User < Member
  include Validation

  NAME_FORMAT = /^[а-яa-z0-9\-\s]{2,}$/i.freeze
  USER_COLOR = 'blue'.freeze

  validate :name, :presence
  validate :name, :format, NAME_FORMAT
  validate :name, :type, String

  def initialize
    super
    @color = USER_COLOR
  end

  def name=(name)
    @name = name.capitalize
    validate!
  end
end
