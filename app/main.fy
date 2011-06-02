require("rubygems")
require: "sinatra"
require: "../lib/template"
require: "../lib/helpers"
require: "models/page"
require: "models/edit_page"

configure: { enable: 'sessions }
configure: 'production with: { disable: 'show_errors }
configure: ['production, 'development] with: {
  enable: 'logging
}

Page["Help"]

before: { "request coming in" println }
get: "/" do: {
  Template new: "views/main.fyhtml" . render: <["links" => Page pages map: 'link . join: " - "]>
}

# page handler
get: /\/([a-zA-Z0-9_]+)$/ do: |page| {
  p = Page[page]
  if: (p content empty?) then: {
    EditPage new: p . render
  } else: {
    p render
  }
}

post: "/save" do: {
  p = params()
  title, content = p['title], p['content]
  Page[title] content: content
  redirect(to(link_to: title))
}

not_found: { "Fancy doesn't know this ditty!" }
