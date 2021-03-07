# base error/exception class for the application
# All the custom Exception classes should inherit from this
class AppBaseError < StandardError
  attr_accessor :meta_data

  def initialize(msg = nil)
    super(msg)
    self.meta_data = HashWithIndifferentAccess.new
  end
end
