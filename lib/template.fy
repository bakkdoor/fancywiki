class Template {
  @@templates = <[]>
  def initialize: @filename {
  }

  def read_contents {
    @contents = File read: @filename
  }

  def render: locals (<[]>) {
    { read_contents } unless: @contents
    rendered_contents = @contents
    locals each: |name val| {
      pattern = "#" + "{" + name + "}"
      match rendered_contents {
        case Regexp new(pattern) ->
          rendered_contents = rendered_contents replace: pattern with: val
      }
    }
    rendered_contents
  }

  def Template [] filename {
    if: (@@templates[filename]) then: |t| {
      t
    } else: {
      t = Template new: filename
      t read_contents
      @@templates at: filename put: t
      t
    }
  }
}