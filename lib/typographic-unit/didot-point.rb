module TypographicUnit
  # This is a class for representing didot point(dd). Didot point is defined as
  # 1238/1157 tex point in this library.
  class DidotPoint < Unit
    unit :dd, TeXPoint, Rational(1238, 1157)
  end
end
