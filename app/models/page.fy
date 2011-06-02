class Page {
  read_slots: ['name, 'linked_pages, 'categories, 'author]
  read_write_slots: ['content, 'created_at, 'updated_at]
  @@pages = <[]>

  def initialize: @name content: @content ("") author: @author ("Anonymous") {
    @created_at = Time now
    @updated_at = Time now
    @categories = []
    @linked_pages = []
    @@pages at: @name put: self
  }

  def link {
    Link new: self . render
  }

  def render {
    Template new: "views/page.fyhtml" . render: <["title" => name, "content" => content]>
  }

  class Link {
    def initialize: @page {
    }

    def render {
      name = @page name
      title = name
      { title = "Index" } if: (name empty?)
      Template new: "views/link.fyhtml" . render: <["title" => title, "url" => link_to: name]>
    }
  }

  def Page pages {
    @@pages values
  }

  def Page [] name {
    { @@pages = <[]> } unless: @@pages
    if: (@@pages[name]) then: |page| {
      page
    } else: {
      Page new: name
    }
  }
}