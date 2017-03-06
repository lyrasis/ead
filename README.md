# EAD

Generate EAD records.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "ead", :github => "lyrasis/ead"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ead

## Usage

```ruby
ead = EAD::Generator.new

# create two c01 components
ead.add_c01('a123')
ead.add_c01('a456')

# add two c02 components to c01 'a123'
ead.add_c02_by_parent_id('a123', 'b123')
ead.add_c02_by_parent_id('a123', 'b456')

# add two c02 components to c01 'b456'
ead.add_c02_by_parent_id('a456', 'b678')
ead.add_c02_by_parent_id('a456', 'b901')

# add two c03 components to c01 'a123' c02 'b123'
ead.add_c03_by_parent_id('b123', 'c123')
ead.add_c03_by_parent_id('b123', 'c456')

# add two c03 components to c01 'a123' c02 'b456'
ead.add_c03_by_parent_id('b456', 'c789')
c03 = ead.add_c03_by_parent_id('b456', 'c012')
path = c03.path
path.did.unittitle = "A title!"

# display the generated ead
puts ead.to_xml
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lyrasis/ead.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
