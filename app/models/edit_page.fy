class EditPage : Page {
  def initialize: @page {
    copy_slots: ['name, 'content, 'linked_pages, 'categories, 'author, 'created_at, 'updated_at] from: @page
  }

  def render {
    locals = <[
      "title" => name,
      "content" => content,
      "back_link" => Page[""] link,
      "menu" => Page Menu new render
    ]>
    Template new: "views/edit_page.fyhtml" . render: locals
  }
}