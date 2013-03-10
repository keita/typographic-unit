# -*- coding: utf-8 -*-
module TypographicUnit
  # Gou is a unit of Japanese Gou(号).
  # See http://www.um.u-tokyo.ac.jp/publish_db/1996Moji/05/5901.html and
  # http://www.asahi-net.or.jp/~ax2s-kmtn/ref/type_size.html for details.
  # In this library, "初号" is Gou.new(:first) or 0.gou.
  class Gou < Unit
    unit :gou, AmericanPoint, nil

    def initialize(value)
      if value.kind_of?(Unit)
        raise ArgumentError.new, value
      end
      unless (0..8).include?(value) or value == :first
        raise ArgumentError.new, value
      end
      @value = value
    end

    # Return a size according to "初号".
    def self.first
      0.gou
    end

    # Convert the value into american point.
    def scaled_point
      val = case @value
            when :first, 0
              42.american_pt
            when 1
              27.5.american_pt
            when 2
              21.american_pt
            when 3
              15.75.american_pt
            when 4
              13.75.american_pt
            when 5
              10.5.american_pt
            when 6
              7.875.american_pt
            when 7
              5.25.american_pt
            when 8
              3.9375.american_pt
            end
      val.kind_of?(ScaledPoint) ? val : val.scaled_point
    end
  end
end
