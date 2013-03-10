module TypographicUnit
  # This is a class for big point(bp). Big point is defined as 1/72 inch in this
  # library.
  class BigPoint < Unit
    unit :bp, Inch, Rational(1, 72)
  end
end
