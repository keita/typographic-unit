module TypographicUnit
  # This is a class for representing PostScript point(ps_pt). PostScript point
  # is defined as 1 big point in this library.
  class PostScriptPoint < Unit
    unit :ps_pt, BigPoint, 1
  end
end
