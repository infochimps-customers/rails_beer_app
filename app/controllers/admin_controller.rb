class AdminController < ApplicationController

  def index

    @customers = [
              { :id          => 7363,
                :name        => "Todd Alstrom",
                :twitter     => 'BeerAdvocate',
                :total_spent => 238.89
              },
              { :id          => 3827,
                :name        => "Carla",
                :twitter     => 'beerbabe',
                :total_spent => 957.22
              },
              { :id          => 3827,
                :name        => "Logan Thompson",
                :twitter     => 'blogaboutbeer',
                :total_spent => 25.87
              },
              { :id          => 3827,
                :name        => "Clare Goggin",
                :twitter     => 'beergoggins',
                :total_spent => 3450.11
              }
             ]
    @customers.each do |customer|
      trstrank = infochimps_api_request("/social/network/tw/influence/trstrank", :screen_name => customer[:twitter])
      customer[:trstrank] = trstrank['trstrank']
      
      wordbag = infochimps_api_request("/social/network/tw/token/wordbag", :screen_name => customer[:twitter])
      customer[:wordbag] = (wordbag['tokens'] || []).reject { |token, weight| token =~ /beer/ }.sort { |token, weight| weight[1] }.reverse[0..30].map(&:first).sort

      strong_links    = infochimps_api_request("/social/network/tw/graph/strong_links", :screen_name => customer[:twitter])
      strong_link_ids = (strong_links["strong_links"] ||[]).sort { |user_id, weight| weight[1] }.reverse.map(&:first)[0..5] # CAREFUL ADJUSTING THIS!

      strong_link_screen_names = [].tap do |us|
        strong_link_ids.each do |user_id|
          whois = infochimps_api_request("/social/network/tw/util/map_id", :user_id => user_id)
          us << whois["screen_name"]
        end
      end
      customer[:strong_links] = strong_link_screen_names
      
    end
    
  end
  
end
