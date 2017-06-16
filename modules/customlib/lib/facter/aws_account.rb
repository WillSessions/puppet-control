require 'net/http'
require 'rubygems'
require 'json'
require 'aws-sdk'

Facter.add(:aws_account) do
  confine :kernel => :Linux

  setcode do
    url = 'http://169.254.169.254/latest/meta-data/iam/info'
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = 3
    begin
      response = JSON.parse(http.get(uri.path).body)
    rescue
      nil
    else
      aws_account = {}
      aws_account['id'] = /\d{12}/.match(response['InstanceProfileArn']).to_s
      begin
        iam = Aws::IAM::Client.new(region: Facter.value(:aws_region)['name'])
      rescue
        nil
      else
        resp = iam.list_account_aliases({})
        aws_account['name'] = resp.account_aliases[0]
      end
      aws_account
    end
  end
end
