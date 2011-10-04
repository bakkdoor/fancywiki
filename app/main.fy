require("rubygems")
require: "sinatra"
require: "../lib/template"
require: "../lib/helpers"
require: "models/page"
require: "models/edit_page"

WIKI_ROOT = File expand_path(".", File dirname(__FILE__))
Template path_prefix: WIKI_ROOT
PERSISTENCE_DIR = File expand_path("../saved/", File dirname(__FILE__))
Directory create!: PERSISTENCE_DIR

configure: { enable: 'sessions }
configure: 'production with: { disable: 'show_errors }
configure: ['production, 'development] with: {
  enable: 'logging
}
configure: 'development with: {
  Template caching: false # disable caching in dev mode
}
set: 'port to: 3000

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

post: /^\/([a-zA-Z0-9_]+)\/save/ do: |page| {
  p = Page[page]
  p save_to: PERSISTENCE_DIR
  redirect_to: p
}

post: "/save-all" do: {
  Page pages size println
  Page pages each: |p| {
    p save_to: PERSISTENCE_DIR
  }
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
