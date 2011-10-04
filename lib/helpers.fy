def wiki_word: name {
  name to_s split map: 'capitalize . join
}

def link_to: page_name {
  wiki_word: page_name
}

def redirect_to: page {
  redirect: $ link_to: $ page name
}