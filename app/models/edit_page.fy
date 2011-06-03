class EditPage : Page {
  def initialize: @page {
    copy_slots: ['name, 'content, 'linked_pages, 'categories, 'author, 'created_at, 'updated_at] from: @page
  }

  def render: request session: session (<[]>) {
    page_name = request referrer split: "/" . last
    locals = <[
      "title" => name,
      "content" => content,
      "back_link" => Page[page_name] link,
      "menu" => Page Menu new render
    ]>
    Template["views/edit_page.fyhtml"] render: locals
  }
}