require 'pp'
class Service::PuppetModule < Service
  string :api_version
  string :auth_token
  string :module_name
  string :server_url
  
  def receive_push
    if tag? and created?
      pp "new tag (#{tag_name}) at #{tag_download_url}"
      pp "posting to #{create_release_url}"
      http_post create_release_url do |req|
        req.headers['auth_token'] = auth_token
        req.headers['release_file'] = tag_download_url
        req.headers['Accept'] = 'application/json'
      end
    else
      pp "not a tag:\n#{payload}"
    end
  end
  
  def tag_name
    ref =~ /^refs\/tags\/(.*)/
    $1
  end
  
  def tag_download_url(type=:tarball)
    "#{repo_url}/#{type}/#{tag_name}"
  end
  
  def create_release_url
    shorten_url "#{server_url}/#{api_version}/modules/#{module_name}/release/create"
  end
  
  def module_name
    data["module_name"]
  end
  
  def auth_token
    data["auth_token"]
  end
  
  def api_version
    data["api_version"] || "v1"
  end
  
  def server_url
    data["server_url"] || "https://forge.puppetlabs.com"
  end
end