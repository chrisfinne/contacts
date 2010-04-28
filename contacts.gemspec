Gem::Specification.new do |s|
  s.name = "contacts"
  s.version = "11.0.0"
  s.date = "2010-01-20"
  s.summary = "A universal interface to grab contact list information from various providers including Yahoo, AOL, Gmail, Hotmail, and Plaxo."
  s.email = "chris.finne@gmail.com"
  s.homepage = "http://github.com/chrisfinne/contacts"
  s.description = "A universal interface to grab contact list information from various providers including Yahoo, AOL, Gmail, Hotmail, and Plaxo."
  s.has_rdoc = false
  s.authors = ["Lucas Carlson","Chris Finne"]
  s.files = ["LICENSE", "Rakefile", "README", "examples/grab_contacts.rb", "lib/contacts.rb", "lib/contacts/base.rb", "lib/contacts/json_picker.rb", "lib/contacts/gmail.rb", "lib/contacts/aol.rb", "lib/contacts/hotmail.rb", "lib/contacts/plaxo.rb", "lib/contacts/yahoo.rb"]
  s.add_dependency("json", ">= 1.1.1")
  s.add_dependency('gdata', '>= 1.1.1')
end
