# typographic-unit

typographic-unit is a Ruby library for converting between typographic units
according to TeX's way. This library can handle the following units:

* TeX Scaled Point(sp)
* TeX Point(pt)
* Pica(pt)
* Inch(in)
* TeX Big Point(bp)
* PostScript Point(ps_pt)
* Meter(m)
* Centimeter(cm)
* Milimeter(mm)
* Didot Point(dd)
* Cicero(cc)
* Japanese Q(q)
* American Point(american_pt)
* JIS Point(jis_pt)
* Japanese Gou(gou)

## Installing

    gem install typographic-unit

## How to use

### Basics

```ruby
require "typographic-unit"
1.cm          # => #<1cm>
1.cm - 1.mm   # => #<0.9cm>
1.cm == 10.mm # => true
1.in >> :cm          # => #<2.54cm>
2.54.cm >> :in       # => #<1.0in>
1.in - 1.cm          # => #<0.606299212598425in>
(1.in - 1.cm) >> :cm # => #<1.54cm>
```

### Convert

```ruby
1.pt >> :mm     # => #<0.351459803514598mm>
7227.pt >> :cm  # => #<254.0cm>
1.in >> :bp     # => #<72.0bp>
1.pt >> :sp     # => #<65536.0sp>
1157.pt >> :pt  # => #<1238.0pt>
1.cc >> :dd     # => #<12.0dd>
10.q >> :mm     # => #<2.5mm>
1.jis_pt >> :mm # => #<0.3514mm>
```

### Calculate

```ruby
1.cm + 1.mm # => #<1.1cm>
1.cm + 1.in # => #<3.54cm>
1.pt - 1.bp # => #<-0.00131797426317971mm>
100.ps_pt - 100.jis_pt >> :mm # => #<0.137777777777779mm>
1.cm * 10   # => #<10cm>
```

### Step

```ruby
list = []
1.cm.step(3.cm, 0.5.cm) do |i|
  list << i
end
list # => [1.cm, 1.5.cm, 2.cm, 2.5.cm, 3.cm]
```

## License

This code is free to use under the terms of the MIT license.

## Reference

* "Wikipedia:活字":http://ja.wikipedia.org/wiki/%E6%B4%BB%E5%AD%97
* "歴史の文字 記載・活字・活版 第三部 活版の世界":http://www.um.u-tokyo.ac.jp/publish_db/1996Moji/05/5901.html
* "CyberLibrarian:文字サイズ":http://www.asahi-net.or.jp/~ax2s-kmtn/ref/type_size.html

## Links

* [Project Home](http://typographic-unit.github.com/)
* [Repository](http://rubyforge.org/projects/typographicunit/)
