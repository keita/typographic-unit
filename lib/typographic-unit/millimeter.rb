module TypographicUnit
  # This is a class for representing millimeter(mm). Millimeter is defined as
  # 10/254 inch in this library.
  class Millimeter < Unit
    unit :mm, Inch, Rational(10, 254)
  end
end
