require 'gdata'

class Contacts
  class Gmail < Base
    
    CONTACTS_SCOPE = 'http://www.google.com/m8/feeds/'
    CONTACTS_FEED = CONTACTS_SCOPE + 'contacts/default/full/?max-results=1000'
    
    def contacts
      return @contacts if @contacts
    end
    
    def real_connect
      @client = GData::Client::Contacts.new
      @client.clientlogin(@login, @password, @captcha_token, @captcha_response)
      
      feed = @client.get(CONTACTS_FEED).to_xml
      
      File.open(File.join(RAILS_ROOT,'tmp',"gmail_#{@login}_#{Time.now.to_i}.xml"),'w') {|f| f << feed } rescue nil
      
      @full_contacts = feed.elements.to_a('entry').collect do |entry|
        hash={}
        hash[:id] = entry.text('id').split('/').pop
        hash[:contact_name] = entry.elements['title'].text
        entry.elements.each('gd:email') do |e|
          if e.attribute('primary')
            hash[:email] = e.attribute('address').value 
          else
            hash[:other_emails] ||= []
            hash[:other_emails] << e.attribute('address').value 
          end
        end
        hash[:company_name] = entry.text('gd:organization/gd:orgName')
        hash[:title] = entry.text('gd:organization/gd:orgTitle')
        entry.get_elements('gd:phoneNumber').to_a.each do |e|
          hash[:phones]||={}
          phone_type = e.attributes['rel'].to_s.split('#').last
          phone_type = 'default' if phone_type.blank?
          hash[:phones][phone_type.to_sym] ||= []
          hash[:phones][phone_type.to_sym] << e.text
        end
        entry.get_elements('gd:postalAddress').to_a.each do |e|
          hash[:addresses]||={}
          type = e.attributes['rel'].to_s.split('#').last
          type = 'default' if type.blank?
          hash[:addresses][type.to_sym] ||= []
          hash[:addresses][type.to_sym] << e.text
        end
        hash
      end
      @contacts=[]
      return

      @contacts = feed.elements.to_a('entry').collect do |entry|
        title, email = entry.elements['title'].text, nil
        entry.elements.each('gd:email') do |e|
          email = e.attribute('address').value if e.attribute('primary')
        end
        [title, email] unless email.nil?
      end
      @contacts.compact!
    rescue GData::Client::AuthorizationError => e
      raise AuthenticationError, "Username or password are incorrect"
    end
    
    private
    
    TYPES[:gmail] = Gmail
  end
end