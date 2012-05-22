require 'pp'
class Service::PuppetModule < Service
  string :auth_token
  string :module_name
  
  def receive_push
    if tag? and created?
      pp "new tag (#{tag_name}) at #{tag_download_url}"
    else
      pp "not a tag:\n#{payload}"
    end
  end
  
  def tag_name
    ref =~ /^refs\/tags\.(.*)/
    $1
  end
  
  def tag_download_url(type=:tarball)
    "#{repo_url}/#{type}/#{tag_name}"
  end
end