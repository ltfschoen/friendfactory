namespace :ff do
  namespace :fix do
    task :eliminate_wave_proxies => :environment do
      ActiveRecord::Base.transaction do
        Posting::WaveProxy.includes(:resource).find_each do |proxy|
          if resource = proxy.resource
            Publication.update_all({ :posting_id => resource[:id] }, { :id => proxy.publishable_ids })
            Posting::Base.update_all({ :parent_id => resource[:id] }, { :id => proxy.child_ids })
          else
            Publication.delete(proxy.publishable_ids)
          end
        end
      end
    end
  end
end
