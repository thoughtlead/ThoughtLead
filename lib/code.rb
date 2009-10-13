module Code
  class Short < String
    def initialize
      code = rand(36**8).to_s(36)
      super(code)
    end
  end
end