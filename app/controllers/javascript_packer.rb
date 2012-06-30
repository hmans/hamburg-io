class JavaScriptPacker < Happy::Controller
  def route
    content_type 'text/javascript'

    plain = [settings[:files]].flatten.map do |filename|
      File.read("./app/assets/#{filename}")
    end.join("\n")

    Packr.pack(plain)
  end
end
