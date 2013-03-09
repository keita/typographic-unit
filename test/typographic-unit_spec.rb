require File.dirname(__FILE__) + '/spec_helper.rb'

TypographicUnit.open

describe TypographicUnit do
  it "1pt == 65536sp" do
    1.pt.should == 65536.sp
    1.pt.should_not == 65535.sp
    1.pt.should_not == 65537.sp
  end

  it "1pc == 12pt" do
    1.pc.should == 12.pt
  end

  it "1in == 72.27pt" do
    1.in.should == 72.27.pt
  end

  it "72bp == 1in" do
    72.bp.should == 1.in
  end

  it "10mm == 1cm" do
    25.4.mm.should == 2.54.cm
  end

  it "1cm == 10mm" do
    1.cm.should == 10.mm
  end

  it "2.54cm == 1in" do
    2.54.cm.should == 1.in
  end

  it "1m == 100cm" do
    1.m.should == 100.cm
  end

  it "1157dd == 1238pt" do
    1157.dd.should == 1238.pt
  end

  it "1cc == 12dd" do
    1.cc.should == 12.dd
  end

  it "1.q == 0.25.mm" do
    1.q.should == 0.25.mm
  end

  it "1.jis_pt == 0.3514.mm" do
    1.jis_pt.should == 0.3514.mm
  end

  it "1.american_pt == 1.jis_pt" do
    1.american_pt.should == 1.jis_pt
  end

  it "1.cm - 1.mm == 0.8.cm + 1.mm" do
    (1.cm - 1.mm).should == 0.8.cm + 1.mm
  end
end

describe Numeric do
  it "%" do
    (10.cm % 3.cm).should.kind_of?(TypographicUnit::Centimeter)
    (10.cm % 3.cm).should == 1.cm
  end

  it "div" do
    (10.cm.div 3.cm).should.kind_of?(Integer)
    (10.cm.div 3.cm).should == 3
    (10.cm.div 3).should == 3
  end

  it "quo" do
    (10.cm.quo 3.cm).should.kind_of?(Rational)
    (10.cm.quo 3.cm).should == Rational(10, 3)
    (10.cm.quo 3).should == Rational(10, 3)
  end

  it "+@" do
    (+(1.cm)).should == +(10.mm)
  end

  it "1.cm + 1.cm == 2.cm" do
    (1.cm + 1.cm).should == 2.cm
  end

  it "1.cm + 1.mm == 1.1cm" do
    (1.cm + 1.mm).should be_kind_of(TypographicUnit::Centimeter)
    (1.cm + 1.mm).should == 1.1.cm
  end

  it "-@" do
    (-(1.cm)).should == -(10.mm)
  end

  it "2.cm - 1.cm == 1.cm" do
    (2.cm - 1.cm).should == 1.cm
  end

  it "1.cm - 1.mm == 0.9cm" do
    (1.cm - 1.mm).should be_kind_of(TypographicUnit::Centimeter)
    (1.cm - 1.mm).should == 0.9.cm
  end

  it "*" do
    (1.cm * 10).should be_kind_of(TypographicUnit::Centimeter)
    (1.cm * 10).should == 10.cm
    Proc.new{1.cm * 10.cm}.should raise_error(ArgumentError)
  end

  it "abs" do
    (-(1.cm)).abs.should == 1.cm
    (-(1.cm)).abs.should_not == -1.cm
  end

  it "ceil" do
    1.5.cm.ceil.should == 2.cm
    1.5.cm.ceil.should_not == 1.cm
  end

  it "floor" do
    1.5.cm.floor.should == 1.cm
    1.5.cm.floor.should_not == 2.cm
  end

  it "round" do
    1.4.cm.round.should == 1.cm
    1.5.cm.round.should == 2.cm
  end

  it "truncate" do
    1.4.cm.truncate.should == 1.cm
    1.5.cm.truncate.should == 1.cm
  end

  it "integer?" do
    1.cm.should be_integer
    1.5.cm.should_not be_integer
  end

  it "nonzero?" do
    1.cm.should be_nonzero
    0.cm.should_not be_nonzero
  end

  it "to_i" do
    1.cm.to_i.should be_kind_of(TypographicUnit::Centimeter)
    1.cm.to_i.should == 1.cm
    1.4.cm.to_i.should == 1.cm
    1.5.cm.to_i.should == 1.cm
  end

  it "to_int" do
    1.cm.to_int.should be_kind_of(Integer)
    1.cm.to_int.should == 1
    1.4.cm.to_int.should == 1
    1.5.cm.to_int.should == 1
  end

  it "zero?" do
    0.cm.should be_zero
    0.0.cm.should be_zero
    0.1.cm.should_not be_zero
  end

  it "step from 1cm to 5cm" do
    list = []
    1.cm.step(5.cm) do |i|
      list << i
    end
    list.should == [1.cm, 2.cm, 3.cm, 4.cm, 5.cm]
  end

  it "step from 1cm to 3cm by 0.5cm" do
    list = []
    1.cm.step(3.cm, 0.5.cm) do |i|
      i.should be_kind_of(TypographicUnit::Centimeter)
      list << i
    end
    list.should == [1.cm, 1.5.cm, 2.cm, 2.5.cm, 3.cm]
  end

  it "step from 1cm to 3cm by 5mm" do
    list = []
    1.cm.step(3.cm, 5.mm) do |i|
      i.should be_kind_of(TypographicUnit::Centimeter)
      list << i
    end
    list.should == [1.cm, 1.5.cm, 2.cm, 2.5.cm, 3.cm]
  end
end

describe Range do
  it "Range.new(1.cm, 5.cm) should be valid" do
    Proc.new{1.cm..5.cm}.should_not raise_error(ArgumentError)
  end

  it "Range.new(1.cm, 1.in) should be valid" do
    Proc.new{1.cm..1.in}.should_not raise_error(ArgumentError)
  end

  it "#include should work" do
    (1.cm..1.in).should include(25.4.mm)
    (1.cm..1.in).should_not include(25.5.mm)
  end

  it "#each should raise a TypeError" do
    Proc.new{(1.cm..5.cm).each{}}.should raise_error(TypeError)
  end

  it "#step" do
    Proc.new{(1.cm..5.cm).step{}}.should raise_error(ArgumentError)
  end
end

describe TypographicUnit::Millimeter do
  it "1mm => 1mm" do
    (1.mm >> :mm).should == 1.mm
  end

  it "1mm => 0.1cm" do
    (1.mm >> :cm).should be_a_kind_of(TypographicUnit::Centimeter)
    (1.mm >> :cm).should == 0.1.cm
  end

  it "1mm => 0.001m" do
    (1.mm >> :m).should == 0.001.m
  end

  it "10mm => 1cm" do
    (10.mm >> :cm).should == 1.cm
  end

  it "1000mm => 1m" do
    (1000.mm >> :m).should == 1.m
  end

  it "25.4mm => 1in" do
    (25.4.mm >> :in).should == 1.in
  end
end

describe TypographicUnit::Centimeter do
  it "1cm => 1cm" do
    (1.cm >> :cm).should == 1.cm
  end

  it "1cm => 10mm" do
    (1.cm >> :mm).should == 10.mm
  end

  it "1cm => 0.01m" do
    (1.cm >> :m).should == 0.01.m
  end

  it "2.54cm => 1in" do
    (2.54.cm >> :in).should == 1.in
  end

  it "254cm => 7227pt" do
    (254.cm >> :pt).should == 7227.pt
  end
end

describe TypographicUnit::Meter do
  it "1m => 1m" do
    (1.m >> :m).should == 1.m
  end

  it "1m => 1000mm" do
    (1.m >> :mm).should == 1000.mm
  end

  it "1m => 100cm" do
    (1.m >> :cm).should == 100.cm
  end

  it "0.0254m => 1in" do
    (0.0254.m >> :in).should == 1.in
  end
end

describe TypographicUnit::Gou do
  it "0.gou => 42.american_pt" do
    (0.gou >> :american_pt).should == 42.american_pt
  end

  it "Gou.first => 0.gou" do
    TypographicUnit::Gou.first.should == 0.gou
  end

  it "0.gou => 2.gou x 2" do
    (0.gou >> :american_pt).should == (2.gou >> :american_pt) * 2
  end

  it "2.gou => 5.gou x 2" do
    (2.gou >> :american_pt).should == (5.gou >> :american_pt) * 2
  end

  it "5.gou => 7.gou x 2" do
    (5.gou >> :american_pt).should == (7.gou >> :american_pt) * 2
  end

  it "1.gou => 27.5.american_pt" do
    (1.gou >> :american_pt).should == 27.5.american_pt
  end

  it "1.gou => 4.gou x 2" do
    (1.gou >> :american_pt).should == (4.gou >> :american_pt) * 2
  end

  it "3.gou => 15.75.american_pt" do
    (3.gou >> :american_pt).should == 15.75.american_pt
  end

  it "3.gou => 6.gou x 2" do
    (3.gou >> :american_pt).should == (6.gou >> :american_pt) * 2
  end

  it "6.gou => 8.gou x 2" do
    (6.gou >> :american_pt).should == (8.gou >> :american_pt) * 2
  end
end
