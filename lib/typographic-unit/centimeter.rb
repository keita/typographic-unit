module TypographicUnit
  # This is a class for representing centimeter(cm). Centimeter is defined as 10
  # millimeter in this library.
  class Centimeter < Unit
    unit :cm, Millimeter, 10
  end
end
