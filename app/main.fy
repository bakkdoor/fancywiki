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
  redirect: "/Index"
}

# default page
Page["Index"] content: """
Welcome to FancyWiki. This is a new experimental and self-hosted documentation Wiki written in Fancy for Fancy.
<br/>
You can link to other pages by using [[ and ]], e.g. [[Help]].
"""

def cleanup_notifications: session {
  session at: "info" put: nil
  session at: "error" put: nil
}

# page handler
get: /^\/([a-zA-Z0-9_]+)$/ do: |page| {
  p = Page[page]
  content = if: (p content empty?) then: {
    EditPage new: p . render: request session: session
  } else: {
    p render: request session: session
  }
  cleanup_notifications: session
  content
}

get: /^\/([a-zA-Z0-9_]+)\/edit$/ do: |page| {
  EditPage new: (Page[page]) . render: request session: session
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
  try {
    title = params['title]
    redirect_to: $ Page[title]
  } catch Page EmptyNameError => e {
    session at: "error" put: "Page name can't be blank!"
    redirect_to: $ Page["Index"]
  }
}

not_found: { "Fancy doesn't know this ditty!" }
