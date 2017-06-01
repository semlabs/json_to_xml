defmodule JsonToXmlTest do
  use ExUnit.Case
  doctest JsonToXml

  test "it can convert various data types" do
    assert JsonToXml.convert!(~s({ "foo": true })) === ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<foo>true</foo>\n</root>)
    assert JsonToXml.convert!(~s({ "foo": 12 })) === ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<foo>12</foo>\n</root>)
    assert JsonToXml.convert!(~s({ "foo": false })) === ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<foo>false</foo>\n</root>)
    assert JsonToXml.convert!(~s({ "foo": 12.3456 })) === ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<foo>12.3456</foo>\n</root>)
    assert JsonToXml.convert!(~s({ "foo": "StRinG" })) === ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<foo>StRinG</foo>\n</root>)
  end

  test "it can convert objects" do
    assert JsonToXml.convert!(~s({ "foo": {"bar" : "baz"} })) === ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<foo>\n\t\t<bar>baz</bar>\n\t</foo>\n</root>)
  end

  test "it can convert arrays" do
    assert JsonToXml.convert!(~s({ "foo": ["bar", "baz"] })) === ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<foo>\n\t\t<element>bar</element>\n\t\t<element>baz</element>\n\t</foo>\n</root>)
  end

  test "it can convert null types" do
    assert JsonToXml.convert!(~s({ "foo": null })) === ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<foo/>\n</root>)
  end

  test "it can convert mixed" do
    assert JsonToXml.convert!(~s(
      { 
        "element1": true,
        "element2": 123,
        "element3": {
          "list": [
            {
              "inner1": false,
              "inner2": true
            },
            {
              "inner3": "string",
              "inner4": 12.34
            }
          ]
        }
      }
    )) === ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<element1>true</element1>\n\t<element2>123</element2>\n\t<element3>\n\t\t<list>\n\t\t\t<element>\n\t\t\t\t<inner1>false</inner1>\n\t\t\t\t<inner2>true</inner2>\n\t\t\t</element>\n\t\t\t<element>\n\t\t\t\t<inner3>string</inner3>\n\t\t\t\t<inner4>12.34</inner4>\n\t\t\t</element>\n\t\t</list>\n\t</element3>\n</root>)
  end

end
