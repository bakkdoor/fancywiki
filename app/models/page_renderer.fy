class PageRenderer {
  def initialize: @page {
  }

  def content {
    content = @page content
    content replace: /\[\[([a-zA-Z0-9_]+)\]\]/ with: |m, link| {
      page_name = m from: 2 to: -3 # skip surrounding [[ and ]]
      Page[page_name] link
    }
  }

  def render {
    Template["views/page.fyhtml"] render: <["title" => @page name, "content" => content, "menu" => Page Menu new render]>
  }
}