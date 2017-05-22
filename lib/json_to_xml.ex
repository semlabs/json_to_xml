defmodule JsonToXml do
  import XmlBuilder

  @moduledoc """
  Documentation for JsonToXml.
  """

  @doc """
  Converts the given json string into a xml string.

  ## Examples
  iex>JsonToXml.convert(~s({ "firstname": "john", "lastname": "doe" }))
  "<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\n<root>\n\t<firstname>john</firstname>\n\t<lastname>doe</lastname>\n</root>"

  iex>JsonToXml.convert(~s({ "name": { "first": "john", "last": "doe" } }))
  "<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\n<root>\n\t<name>\n\t\t<first>john</first>\n\t\t<last>doe</last>\n\t</name>\n</root>"

  iex>JsonToXml.convert(~s({ "person": { "name": "doe", "address": { "street": "Huffman Road", "number": "12"}} }))
  "<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\n<root>\n\t<person>\n\t\t<address>\n\t\t\t<number>12</number>\n\t\t\t<street>Huffman Road</street>\n\t\t</address>\n\t\t<name>doe</name>\n\t</person>\n</root>"

  iex>JsonToXml.convert(~s({ "list": ["apple", "banana", "lemon"] }))
  "<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\n<root>\n\t<list>\n\t\t<element>apple</element>\n\t\t<element>banana</element>\n\t\t<element>lemon</element>\n\t</list>\n</root>"
  """
  def convert(json) do
    content =
      Poison.decode!(json)
      |> map_elements()

    XmlBuilder.doc("root", content)
  end

  @doc """
  Converts the given json file into a xml string. 
  
  ## Examples
  iex>JsonToXml.convertFile("test/fixtures/example.json")
  "<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\n<root>\n\t<address>\n\t\t<number>12</number>\n\t\t<street>Huffman Road</street>\n\t</address>\n\t<array>\n\t\t<element>apple</element>\n\t\t<element>banana</element>\n\t\t<element>lemon</element>\n\t</array>\n\t<name>John Doe</name>\n</root>"
  """
  def convertFile(file) do
    File.read!(file)
    |> convert()
  end

  defp map_elements(elements) do
    Enum.map(elements, &create_element/1)
  end

  defp create_element({key, value}) when is_map(value) do
    element(key, map_elements(value))
  end

  defp create_element({key, value}) when is_binary(value) do
    element(key, value)
  end

  defp create_element({key, value}) when is_list(value) do
    array =
      Enum.reduce(value, [], &create_array_item/2)
      |> Enum.reverse()
    element(key, array)
  end

  defp create_array_item(element, acc) do
   [element("element", element) | acc]
  end
end
