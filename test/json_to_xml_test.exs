defmodule JsonToXmlTest do
  use ExUnit.Case
  doctest JsonToXml

  test "it can convert various data types" do
    assert JsonToXml.convert(~s({ "foo": true })) === ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<foo>true</foo>\n</root>)
    assert JsonToXml.convert(~s({ "foo": 12 })) === ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<foo>12</foo>\n</root>)
    assert JsonToXml.convert(~s({ "foo": false })) === ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<foo>false</foo>\n</root>)
    assert JsonToXml.convert(~s({ "foo": 12.3456 })) === ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<foo>12.3456</foo>\n</root>)
  end

  test "it can convert null types" do
    assert JsonToXml.convert(~s({ "foo": null })) === ~s(<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<foo/>\n</root>)
  end
end
