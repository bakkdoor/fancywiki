require: "page_renderer"

class Page {
  class EmptyNameError : StandardError {}

  read_slots: ['name, 'linked_pages, 'categories, 'author]
  read_write_slots: ['content, 'created_at, 'updated_at]
  @@pages = <[]>

  def Page pages {
    @@pages values
  }

  def Page [name] {
    { @@pages = <[]> } unless: @@pages
    if: (@@pages[name]) then: |page| {
      page
    } else: {
      Page new: name
    }
  }

  def initialize: @name content: @content ("") author: @author ("Anonymous") {
    if: (@name empty?) then: {
      EmptyNameError new raise!
    }
    @created_at = Time now
    @updated_at = Time now
    @categories = []
    @linked_pages = []
    @@pages at: @name put: self
  }

  def link {
    Link new: self . render
  }

  def render: request session: session (<[]>) {
    PageRenderer new: self . render: request session: session
  }

  def delete {
    @@pages delete: @name
  }

  def save_to: dirname {
    filename = File expand_path(@name + ".txt", dirname)
    "Saving to file: #{filename}" println
    File open: filename modes: ['truncate] with: |f| {
      f writeln: @content
    }
  }

  class Link {
    def initialize: @page {
    }

    def render {
      name = @page name
      Template["views/link.fyhtml"] render: <["title" => name, "url" => link_to: name]>
    }
  }

  class Menu {
    def render: locals (<[]>) {
      locals2 =  <["links" => Page pages sort_by: 'name . map: 'link . join: " - "]>
      locals2 merge!: locals
      Template["views/menu.fyhtml"] render: locals2
    }
  }
}