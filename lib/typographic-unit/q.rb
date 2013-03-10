# -*- coding: utf-8 -*-

module TypographicUnit
  # Q is a unit of Japanese Q(級).
  class Q < Unit
    unit :q, Millimeter, Rational(25, 100)
  end
end
