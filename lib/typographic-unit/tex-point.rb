module TypographicUnit
  # TeXPoint is a unit of TeX point. 1 TeX point equals 65536 scaled point.
  class TeXPoint < Unit
    unit :pt, ScaledPoint, 65536
  end
end
