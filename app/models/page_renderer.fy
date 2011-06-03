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

  def render: request session: session {
    locals = <[
      "title" => @page name,
      "content" => content,
      "menu" => Page Menu new render,
      "notifications" => ""
    ]>

    error, info = session["error"], session["info"]
    if: (error || info) then: {
      notify_content = Template["views/notifications.fyhtml"] . render: <["info" => info, "error" => error]>
      locals at: "notifications" put: notify_content
    }

    Template["views/page.fyhtml"] render: locals
  }
}