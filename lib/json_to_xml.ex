defmodule JsonToXml do
  import XmlBuilder

  @moduledoc """
  Documentation for JsonToXml.
  """

  @doc """
  Converts the given json string into a xml string. Raise exceptions if someting goes wrong.

  The document root is added with the tag `<root>`. 
  Elements in arrays are wrapped in `<element>` tags like so:
  ``` json
  {
    "list": ["apple", "banana"]
  }
  ```
  is converted to  
  ``` xml
  <root>
    <list>
      <element>apple</element> 
      <element>banana</element>
    </list>
  </root> 
  ```

  ## Examples

      iex>JsonToXml.convert!(~s({ "firstname": "John", "lastname": "Doe" }))
      "<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\\n<root>\\n\\t<firstname>John</firstname>\\n\\t<lastname>Doe</lastname>\\n</root>"

      iex>JsonToXml.convert!(~s({ "name": { "first": "John", "last": "Doe" } }))
      "<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\\n<root>\\n\\t<name>\\n\\t\\t<first>John</first>\\n\\t\\t<last>Doe</last>\\n\\t</name>\\n</root>"

      iex>JsonToXml.convert!(~s({ "person": { "name": "Doe", "address": { "street": "Huffman Road", "number": 12}} }))
      "<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\\n<root>\\n\\t<person>\\n\\t\\t<address>\\n\\t\\t\\t<number>12</number>\\n\\t\\t\\t<street>Huffman Road</street>\\n\\t\\t</address>\\n\\t\\t<name>Doe</name>\\n\\t</person>\\n</root>"

      iex>JsonToXml.convert!(~s({ "list": ["apple", "banana", "lemon"] }))
      "<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\\n<root>\\n\\t<list>\\n\\t\\t<element>apple</element>\\n\\t\\t<element>banana</element>\\n\\t\\t<element>lemon</element>\\n\\t</list>\\n</root>"
  """
  def convert!(json) do
    content =
      Poison.decode!(json)
      |> map_elements()

    XmlBuilder.doc("root", content)
  end

  @doc """

  Converts the given json string into a xml string. 

  The document root is added with the tag `<root>`. 
  Elements in arrays are wrapped in `<element>` tags like so:
  ``` json
  {
    "list": ["apple", "banana"]
  }
  ```
  is converted to  
  ``` xml
  <root>
    <list>
      <element>apple</element> 
      <element>banana</element>
    </list>
  </root> 
  ```


  ## Examples

      iex>JsonToXml.convert(~s({ "firstname": "John", "lastname": "Doe" }))
      {:ok, "<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\\n<root>\\n\\t<firstname>John</firstname>\\n\\t<lastname>Doe</lastname>\\n</root>"}

      iex>JsonToXml.convert(~s({ "name": { "first": "John", "last": "Doe" } }))
      {:ok, "<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\\n<root>\\n\\t<name>\\n\\t\\t<first>John</first>\\n\\t\\t<last>Doe</last>\\n\\t</name>\\n</root>"}

      iex>JsonToXml.convert(~s({ "person": { "name": "Doe", "address": { "street": "Huffman Road", "number": 12}} }))
      {:ok, "<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\\n<root>\\n\\t<person>\\n\\t\\t<address>\\n\\t\\t\\t<number>12</number>\\n\\t\\t\\t<street>Huffman Road</street>\\n\\t\\t</address>\\n\\t\\t<name>Doe</name>\\n\\t</person>\\n</root>"}

      iex>JsonToXml.convert(~s({ "list": ["apple", "banana", "lemon"] }))
      {:ok, "<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\\n<root>\\n\\t<list>\\n\\t\\t<element>apple</element>\\n\\t\\t<element>banana</element>\\n\\t\\t<element>lemon</element>\\n\\t</list>\\n</root>"}

      iex>JsonToXml.convert(~s( { "bogus": 1 ))
      {:error, {:invalid, 14}}
  """
  def convert(json) do
    case Poison.decode(json) do
      {:ok, decoded} -> 
        content = map_elements(decoded) 
        {:ok, XmlBuilder.doc("root", content)}
      {:error, reason, line} -> {:error, {reason, line}}
    end
  end

  @doc """
  Converts the given json file into a xml string. 

  ## Examples

      iex>JsonToXml.convert_file!("test/fixtures/example.json")
      "<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\\n<root>\\n\\t<address>\\n\\t\\t<number>12</number>\\n\\t\\t<street>Huffman Road</street>\\n\\t</address>\\n\\t<array>\\n\\t\\t<element>first</element>\\n\\t\\t<element>\\n\\t\\t\\t<content>sweet</content>\\n\\t\\t\\t<peel>indigestive</peel>\\n\\t\\t</element>\\n\\t\\t<element>lemon</element>\\n\\t</array>\\n\\t<name>John Doe</name>\\n</root>"
  """
  def convert_file!(file) do
    File.read!(file)
    |> convert!()
  end

  defp map_elements(elements) do
    Enum.map(elements, &create_element/1)
  end

  defp create_element({key, value}) when is_map(value) do
    element(key, map_elements(value))
  end

  defp create_element({key, value}) when is_list(value) do
    array =
      Enum.reduce(value, [], &create_array_item/2)
      |> Enum.reverse()
    element(key, array)
  end

  defp create_element({key, value}) do
    element(key, value)
  end

  defp create_array_item(element, acc) do
    [create_element({"element", element}) | acc]
  end
end
