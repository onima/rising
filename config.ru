require './orgiac'

$:.push('.').uniq!
run Sinatra::Application
