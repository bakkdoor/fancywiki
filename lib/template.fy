class Template {
  def initialize: @filename {
  }

  def read_contents {
    @contents = File read: @filename
  }

  def render: locals (<[]>) {
    read_contents
    locals each: |name val| {
      pattern = "#" + "{" + name + "}"
      match @contents {
        case Regexp new(pattern) ->
          @contents replace!: pattern with: val
      }
    }
    @contents
  }
}