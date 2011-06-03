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
configure: 'development with: {
  Template caching: false # disable caching in dev mode
}

get: "/" do: {
  Template["views/main.fyhtml"] render: <["links" => Page Menu new render]>
}

# page handler
get: /^\/([a-zA-Z0-9_]+)$/ do: |page| {
  p = Page[page]
  if: (p content empty?) then: {
    EditPage new: p . render
  } else: {
    p render
  }
}

get: /^\/([a-zA-Z0-9_]+)\/edit$/ do: |page| {
  EditPage new: (Page[page]) . render
}

post: /^\/([a-zA-Z0-9_]+)\/delete$/ do: |page| {
  Page[page] delete
  redirect: "/"
}

post: "/save" do: {
  title, content = params['title], params['content]
  page = Page[title]
  page content: content
  redirect_to: page
}

post: "/new" do: {
  title = params['title]
  redirect_to: $ Page[title]
}

not_found: { "Fancy doesn't know this ditty!" }
