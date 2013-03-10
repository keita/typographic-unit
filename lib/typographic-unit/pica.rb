module TypographicUnit
  # This is a class for representing Pica(pc). Pica is defined as 12 tex point
  # in this library.
  class Pica < Unit
    unit :pc, TeXPoint, 12
  end
end
