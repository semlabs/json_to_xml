# JsonToXml
[![Build Status](https://semaphoreci.com/api/v1/semlabs/json_to_xml/branches/master/shields_badge.svg)](https://semaphoreci.com/semlabs/json_to_xml)
[![Hex.pm](https://img.shields.io/hexpm/v/json_to_xml.svg)](https://hex.pm/packages/json_to_xml)
[![Hex.pm](https://img.shields.io/hexpm/l/json_to_xml.svg)](https://github.com/semlabs/json_to_xml)

Convert JSON strings to XML.

## Installation
The package can be installed by adding `json_to_xml` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:json_to_xml, "~> 0.2.1"}]
end
```

## Usage

After adding the dependency you can use the converter like this:
```elixir
JsonToXml.convert(~s({ "name": "John" }))
#=> "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<name>John</name>\n</root>"
```

To convert files use `convertFile`:
```elixir
JsonToXml.convertFile("/path/to/file")
```

## Documentation

The docs can be found at [https://hexdocs.pm/json_to_xml](https://hexdocs.pm/json_to_xml).

## Known issues

- JSON with empty keys is not supported and leads to an empty XML tag:
JSON:
```json
{
    "": "content
}
```
XML:
```xml
<root>
    <>content</>
</root>
```
