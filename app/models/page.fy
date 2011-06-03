class Page {
  read_slots: ['name, 'linked_pages, 'categories, 'author]
  read_write_slots: ['content, 'created_at, 'updated_at]
  @@pages = <[]>

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
    Template new: "views/page.fyhtml" . render: <["title" => name, "content" => content, "menu" => Menu new render]>
  }

  def delete {
    @@pages delete: @name
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

  class Menu {
    def render {
      Template new: "views/menu.fyhtml" . render: <["links" => Page pages sort: |a b| { a name <=>(b name) } . map: 'link . join: " - "]>
    }
  }
}