# TypographicUnit is a namespece for unit classes.
module TypographicUnit
  # @api private
  TABLE = Hash.new

  # Initialize typographic-unit. This makes unit methods for Numeric.
  def self.init
    TABLE.values.each do |unit|
      ::Numeric.instance_eval do
        define_method(unit.short) do
          unit.new(self)
        end
      end
    end
  end
end

require "rational"

require 'typographic-unit/version'
require 'typographic-unit/unit'
require 'typographic-unit/scaled-point'
require 'typographic-unit/tex-point'
require 'typographic-unit/pica'
require 'typographic-unit/inch'
require 'typographic-unit/big-point'
require 'typographic-unit/postscript-point'
require 'typographic-unit/millimeter'
require 'typographic-unit/centimeter'
require 'typographic-unit/meter'
require 'typographic-unit/didot-point'
require 'typographic-unit/cicero'
require 'typographic-unit/q'
require 'typographic-unit/american-point'
require 'typographic-unit/jis-point'
require 'typographic-unit/gou'

TypographicUnit.init
