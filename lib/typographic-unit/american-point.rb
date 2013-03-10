module TypographicUnit
  # AmericanPoint is a unit of American point.
  # See http://www.ops.dti.ne.jp/~robundo/TMTaroY01.html for details.
  class AmericanPoint < Unit
    unit :american_pt, Millimeter, Rational(3514, 10000)
  end
end
