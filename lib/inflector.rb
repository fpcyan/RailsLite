module String
  module Inflector
    def singularize
      return self unless self.last == "s"

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
