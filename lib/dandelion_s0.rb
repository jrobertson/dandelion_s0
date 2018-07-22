#!/usr/bin/env ruby

# file: dandelion_s0.rb

require 'rack-rscript'
require 'simple-config'


class DandelionS0 < RackRscript

  def initialize(opts={})

    h = {root: 'www'}.merge(opts)
    
    access_list = h[:access]
    @app_root = Dir.pwd

    #@access_list = {'/do/r/hello3' => 'user'}
        
    h2 = SimpleConfig.new(access_list).to_h
    conf_access = h2[:body] || h2
    @access_list = conf_access.inject({}) \
                                {|r,x| k,v = x; r.merge(k.to_s => v.split)}
    
    h3 = %i(log pkg_src rsc_host rsc_package_src root static debug)\
        .inject({}) {|r,x| r.merge(x => h[x])}
    
    super(h3)
  end

  def call(e)

    request = e['REQUEST_PATH']
    r = @access_list.detect {|k,v| request =~ Regexp.new(k)}
    private_user = r ? r.last : nil
    
    if private_user.nil? then 
      super(e)
    elsif private_user.is_a? String and private_user == e['REMOTE_USER']
      super(e)
    elsif private_user.is_a? Array and 
        private_user.any? {|x| x == e['REMOTE_USER']}
      super(e)
    else
      request = '/unauthorised/'
      content, content_type, status_code = run_route(request)        
      content_type ||= 'text/html'
      [status_code=401, {"Content-Type" => content_type}, [content]]
    end

  end
  
  def default_routes(env, params)

    super(env, params)

    get '/unauthorised/' do
      'unauthorised user'
    end
 
  end   

end

