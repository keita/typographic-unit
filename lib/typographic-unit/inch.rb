module TypographicUnit
  # Inch is a unit of inch. 7227 TeX point equals 100 inch.
  class Inch < Unit
    unit :in, TeXPoint, Rational(7227, 100)
  end
end
