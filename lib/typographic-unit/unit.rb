module TypographicUnit
  # This is a base class for all unit classes.
  class Unit < ::Numeric
    class << self
      # @api private
      def register(short, unit)
        TypographicUnit::TABLE[short] = unit
      end
      private :register

      # Define a unit. This method is used in concrete unit classes.
      #
      # @param short [Symbol]
      #   short name for the unit
      # @param base [Unit]
      #   base unit class
      # @param size [Rational]
      #   unit size
      # @return [void]
      def unit(short, base, size)
        @short = short
        @base = base
        @size = size
        register(short, self)
      end

      # Return short name of the unit.
      #
      # @return [Symbol]
      #   short name of the unit
      def short
        @short
      end

      # Return base unit class.
      #
      # @return [Class]
      #   base unit class
      def base
        @base
      end

      # Return size of the unit.
      #
      # @return [Rational]
      #   size of the unit
      def size
        @size
      end
    end

    attr_reader :value

    def initialize(value)
      unless value.kind_of?(Numeric) and not(value.kind_of?(Unit))
        raise ArgumentError.new, value
      end
      @value = value
    end

    # Convert the value into scaled point.
    #
    # @return [ScaledPoint]
    #   scaled point representation of the length
    def scaled_point
      val = self.class.base.new(@value * self.class.size)
      val.kind_of?(ScaledPoint) ? val : val.scaled_point
    end

    # @api private
    def <=>(other)
      raise ArgumentError, other unless other.kind_of?(Unit)
      self.scaled_point.value.to_i <=> other.scaled_point.value.to_i
    end

    # Convert the length into other unit.
    #
    # @param other [Unit]
    #    target unit
    def >>(other)
      oclass = other.kind_of?(Symbol) ? TABLE[other] : other
      u = oclass.new(1)
      oclass.new((self.scaled_point.value / u.scaled_point.value).to_f)
    end

    alias :convert :>>

    # Same as +Number#%+.
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

    # Same as +Number#div+.
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

    # Same as +Number#quo+.
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

    # Same as Number#+@.
    def +@
      self.class.new(+@value)
    end

    # Same as +Number#-@+.
    def -@
      self.class.new(-@value)
    end

    # Same as +Number#abs+.
    def abs
      self.class.new(@value.abs)
    end

    # Perform addition.
    #
    # @param other [Unit]
    #   additional value
    # @return [Unit]
    #   new value of the unit
    # @example
    #   1.cm + 1.mm #=> 1.1.cm
    def +(other)
      raise ArgumentError, other unless other.kind_of?(Unit)
      self.class.new((@value + (other >> self.class).value).to_f)
    end

    # Perform subtraction.
    #
    # @param other [Unit]
    #   subtractional value
    # @return [Unit]
    #   new value of the unit
    # @example
    #   1.cm - 1.mm #=> 0.9.cm
    def -(other)
      raise ArgumentError, other unless other.kind_of?(Unit)
      self.class.new((@value - (other >> self.class).value).to_f)
    end

    # Same as +Number#*+.
    def *(other)
      raise ArgumentError, other unless other.kind_of?(Integer) or other.kind_of?(Float)
      self.class.new(@value * other)
    end

    # Same as +Number#ceil+.
    def ceil
      self.class.new(@value.ceil)
    end

    # Same as +Number#floor+.
    def floor
      self.class.new(@value.floor)
    end

    # Same as +Number#round+.
    def round
      self.class.new(@value.round)
    end

    # Same as +Number#truncate+.
    def truncate
      self.class.new(@value.truncate)
    end

    # Same as +Number#integer?+.
    def integer?
      @value.integer?
    end

    # Same as +Number#nonzero?+.
    def nonzero?
      @value.nonzero?
    end

    # Convert to float representation.
    #
    # @return [Unit]
    #   same unit but the value is float
    # @example
    #   1.cm.to_f #=> 1.0.cm
    def to_f
      self.class.new(@value.to_f)
    end

    # Convert to int representaion.
    #
    # @return [Unit]
    #   same unit but the value is int
    # @example
    #   1.0.cm.to_i #=> 1.cm
    def to_i
      self.class.new(@value.to_i)
    end

    # Convert to int representation.
    #
    # @return [Unit]
    #   same unit but the value is float
    # @example
    #   1.cm.to_f #=> 1.0.cm
    def to_int
      @value.to_i
    end

    # Same as +Number#zero?+.
    def zero?
      @value.zero?
    end

    # Same as +Number#step+ but you can specify +step+ as unit length.
    #
    # @param limit [Unit]
    #   limit length
    # @param step [Unit]
    #   step
    def step(limit, step=1)
      step = step.kind_of?(Unit) ? step : self.class.new(step)
      @value.step(limit.value, (step >> self.class).value) do |n|
        yield(self.class.new(n)) if block_given?
      end
    end

    # Return string format.
    def to_s
      @value.to_s + self.class.short.to_s
    end

    # @api private
    def inspect
      "#<#{@value.to_s}#{self.class.short.to_s}>"
    end

    alias :eql? :"=="
  end
end
