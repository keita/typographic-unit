module TypographicUnit
  # JISPoint is a unit of JIS point. JIS point is just same as American point.
  class JISPoint < AmericanPoint
    unit :jis_pt, AmericanPoint, 1
  end
end
