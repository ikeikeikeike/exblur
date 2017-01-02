back = "rel/exblur/releases/#{File.read! "VERSION"}/sys.config.back"
path = "rel/exblur/releases/#{File.read! "VERSION"}/sys.config"

{:ok, conf} = File.read path
{:ok, tokens, _} = :erl_scan.string '#{conf}'
{:ok, erl} = :erl_parse.parse_term tokens

content = Keyword.delete erl, :quantum
content = put_in content, [:exblur, :toon_filters], []
content = put_in content, [:exblur, :char_filters], []
content = put_in content, [:exblur, :translate_filters], []

File.rename path, back
File.write path, :io_lib.fwrite("~p.\n", [content])
