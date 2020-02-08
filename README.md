# Using the DandelionS0 gem

    # file: ds0.ru

    require 'dandelion_s0'

    use Rack::Auth::Basic, "Restricted Area" do |user, password|
      user == 'super' && password == 'secretsauce' 
    end

    h = {
      pkg_src: 'http://a0.jamesrobertson.eu/qbx/r/dandelion_a2'
    }

    run DandelionS0.new(h)

The above example was saved as a file called ds0.ru which was executed from the command using the command `rackup ds0.ru -o 0.0.0.0`. It was then access from a web page using the address http://clara.home:9292/do/r/hello which prompted for a user name and password. Once the authentication was completed the web page containing the current time was displayed.

* dandelion_s0 https://rubygems.org/gems/dandelion_s0

basicauthentication rack rackrscript dandelion authentication
