defmodule JsonToXml.Mixfile do
  use Mix.Project

  def project do
    [app: :json_to_xml,
     version: "0.4.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: [
       maintainers: ["Marian Bäuerle"],
       licenses: ["MIT"],
       links: %{github: "https://github.com/semlabs/json_to_xml"}
     ],
     description: "JSON to XML converter for Elixir",

     # Docs
     name: "JsonToXml",
     source_url: "https://github.com/semlabs/json_to_xml",
     homepage_url: "https://github.com/semlabs/json_to_xml",
     docs: [main: "JsonToXml", # The main page in the docs
            extras: ["README.md"]]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:poison, "~> 3.0"},
     {:ex_doc, "~> 0.14", only: :dev, runtime: false}, 
     {:xml_builder, "~>0.1.1"}
    ]
  end
end
