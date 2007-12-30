require "rational"

module TypographicUnit
  Table = Hash.new

  def self.open #:nodoc:
    Table.values.each do |unit|
      ::Numeric.instance_eval do
        define_method(unit.short) do
          unit.new(self)
        end
      end
    end
  end

  class Unit < ::Numeric
    def self.register(short, unit)
      TypographicUnit::Table[short] = unit
    end

    def self.unit(short, base, size)
      @short = short
      @base = base
      @size = size
      register(short, self)
    end

    def self.short; @short; end
    def self.base; @base; end
    def self.size; @size; end

    attr_reader :value

    def initialize(value)
      unless value.kind_of?(Numeric) and not(value.kind_of?(Unit))
        raise ArgumentError.new, value
      end
      @value = value
    end

    # Convert the value into scaled point.
    def scaled_point
      val = self.class.base.new(@value * self.class.size)
      val.kind_of?(ScaledPoint) ? val : val.scaled_point
    end

    def <=>(other)
      raise ArgumentError, other unless other.kind_of?(Unit)
      self.scaled_point.value.to_i <=> other.scaled_point.value.to_i
    end

    # Convert the length into other unit
    # other:: unit
    def >>(other)
      oclass = other.kind_of?(Symbol) ? Table[other] : other
      u = oclass.new(1)
      oclass.new((self.scaled_point.value / u.scaled_point.value).to_f)
    end

    def %(other)
      case other
      when Unit
        self.class.new(@value % (other >> self.class).value)
      when Integer, Float
        self.class.new(@value % other)
      else
        raise ArgumentError, other
      end
    end

    def div(other)
      case other
      when Unit
        @value.div((other >> self.class).value)
      when Integer, Float
        @value.div(other)
      else
        raise ArgumentError, other
      end
    end

    def quo(other)
      case other
      when Unit
        @value.quo((other >> self.class).value)
      when Integer, Float
        @value.quo(other)
      else
        raise ArgumentError, other
      end
    end

    def +@
      self.class.new(+@value)
    end

    def -@
      self.class.new(-@value)
    end

    def abs
      self.class.new(@value.abs)
    end

    def +(other)
      raise ArgumentError, other unless other.kind_of?(Unit)
      self.class.new((@value + (other >> self.class).value).to_f)
    end

    def -(other)
      raise ArgumentError, other unless other.kind_of?(Unit)
      self.class.new((@value - (other >> self.class).value).to_f)
    end

    def *(other)
      raise ArgumentError, other unless other.kind_of?(Integer) or other.kind_of?(Float)
      self.class.new(@value * other)
    end

    def ceil
      self.class.new(@value.ceil)
    end

    def floor
      self.class.new(@value.floor)
    end

    def round
      self.class.new(@value.round)
    end

    def truncate
      self.class.new(@value.truncate)
    end

    def integer?
      @value.integer?
    end

    def nonzero?
      @value.nonzero?
    end

    def to_i
      self.class.new(@value.to_i)
    end

    def to_f
      self.class.new(@value.to_f)
    end

    def to_int
      @value.to_i
    end

    def to_float
      @value.to_f
    end

    def zero?
      @value.zero?
    end

    def step(limit, _step=1)
      step = _step.kind_of?(Unit) ? _step : self.class.new(_step)
      @value.step(limit.value, (step >> self.class).value) do |n|
        yield(self.class.new(n)) if block_given?
      end
    end

    def to_s
      @value.to_s + self.class.short.to_s
    end

    def inspect
      "#<#{@value.to_s}#{self.class.short.to_s}>"
    end

    alias :eql? :==
    alias :convert :>>
  end

  class ScaledPoint < Unit
    unit :sp, self, 1
  end

  # TeXPoint is a unit of TeX point. 1 TeX point equals 65536 scaled point.
  class TeXPoint < Unit
    unit :pt, ScaledPoint, 65536
  end

  class Pica < Unit
    unit :pc, TeXPoint, 12
  end

  # Inch is a unit of inch. 7227 TeX point equals 100 inch.
  class Inch < Unit
    unit :in, TeXPoint, Rational(7227, 100)
  end

  class BigPoint < Unit
    unit :bp, Inch, Rational(1, 72)
  end

  class PostScriptPoint < Unit
    unit :ps_pt, BigPoint, 1
  end

  class Millimeter < Unit
    unit :mm, Inch, Rational(10, 254)
  end

  class Centimeter < Unit
    unit :cm, Millimeter, 10
  end

  class Meter < Unit
    unit :m, Centimeter, 100
  end

  class DidotPoint < Unit
    unit :dd, TeXPoint, Rational(1238, 1157)
  end

  class Cicero < Unit
    unit :cc, DidotPoint, 12
  end

  # Q is a unit of Japanese Q(級).
  class Q < Unit
    unit :q, Millimeter, Rational(25, 100)
  end

  # AmericanPoint is a unit of American point.
  # See http://www.ops.dti.ne.jp/~robundo/TMTaroY01.html for details.
  class AmericanPoint < Unit
    unit :american_pt, Millimeter, Rational(3514, 10000)
  end

  # JISPoint is a unit of JIS point. JIS point is just same as American point.
  class JISPoint < AmericanPoint
    unit :jis_pt, AmericanPoint, 1
  end

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

require "typographic-unit/version"

TypographicUnit.open
