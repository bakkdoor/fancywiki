def wiki_word: name {
  name to_s split map: 'capitalize . join
}

def link_to: page_name {
  "http://localhost:4567/" + (wiki_word: page_name)
}
