require 'net/http'
require 'rubygems'
require 'json'

Facter.add(:aws_region) do
  confine :kernel => :Linux

  setcode do
    url = 'http://169.254.169.254/latest/dynamic/instance-identity/document'
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = 3
    begin
      response = JSON.parse(http.get(uri.path).body)
    rescue
      nil
    else
      region_codes = {
        'ap-southeast-2' => 'apse2',
        'us-east-1' => 'usea1'
      }
      aws_region = {}
      aws_region['name'] = response['region'].to_s
      aws_region['code'] = region_codes[response['region'].to_s]
      aws_region
    end
  end
end
