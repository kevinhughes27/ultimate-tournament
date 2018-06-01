class Resolvers::BaseResolver
  def self.call(inputs, ctx)
    self.new.call(inputs, ctx)
  end
end
