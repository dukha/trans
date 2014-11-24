log=Logger.new(STDOUT)
User.delete_all

UserWork.delete_all

#UploadsRedisDatabase.delete_all 
RedisDatabase.delete_all
RedisInstance.delete_all
CalmappVersion.delete_all
Calmapp.delete_all

Language.delete_all
TranslationLanguage.delete_all
Whiteboard.delete_all
ReleaseStatus.delete_all
WhiteboardType.delete_all
Location.delete_all
Profile.delete_all    
#Permission.delete_all
SpecialPartialDotKey.delete_all
DotKeyCodeTranslationEditor.delete_all
TranslationEditorParam.delete_all

systemWBType = WhiteboardType.create(:name_english=>"system", :translation_code=>"system")
regionalWBType =WhiteboardType.create(:name_english=>"regional admin", :translation_code=>"regionaladmin")
localWBType = WhiteboardType.create(:name_english=>"local admin", :translation_code=>"localadmin")
userWBType = WhiteboardType.create(:name_english=>"user", :translation_code=>"user")
log.info("Whiteboard Type data inserted successfully.")


vs_dev = ReleaseStatus.create!(:status => "Development")
vs_test = ReleaseStatus.create!(:status => "Test")
vs_integration = ReleaseStatus.create!(:status => "Integration")
ReleaseStatus.create!(:status => "Production")
log.info("Release Status data inserted successfully.")


Whiteboard.create!(:whiteboard_type_id=> systemWBType.id, :info=>"Translator application under development." )
Whiteboard.create!(:whiteboard_type_id=> userWBType.id, :info=>"We need translators for Russian.")
log.info("Whiteboards data inserted successfully.")
#User.create!(  :email=> 'translator@calm.org', :password=>'123456', :confirm_password=>'123456', :actual_name=> 'joe smith', :username => "joe",:current_permission_id=>1)

#en = Language.create!(:iso_code=> "en", :name=>"English")
#nl = Language.create!(:iso_code=> "nl", :name=>"Nederlands")
#log.info("Languages inserted")




# delete or change below usernameonce login is added
en = TranslationLanguage.seed#.create!(:iso_code=> "en", :name=>"English")



#red_reg4_loc_dev = RedisDatabase.create!(:calmapp_version_id => reg4.id, :redis_instance_id => ri_local.id, :redis_db_index => 1, :release_status_id => vs_dev.id)
#red_reg4_loc_test = RedisDatabase.create!(:calmapp_version_id => reg4.id, :redis_instance_id => ri_local.id, :redis_db_index => 2, :release_status_id => vs_test.id)
#red_trans1_int_dev = RedisDatabase.create!(:calmapp_version_id => trans1.id, :redis_instance_id => ri_integration.id, :redis_db_index => 1, :release_status_id => vs_dev.id)
#red_trans1_int_test = RedisDatabase.create!(:calmapp_version_id => trans1.id, :redis_instance_id => ri_integration.id, :redis_db_index => 2, :release_status_id => vs_test.id)
#log.info("Redis databases inserted")


Profile.seed
log.info("profiles seeded")
Location.seed
log.info("Locations seeded")
User.create_root_user
#global = Area.create :name => "Global" , :parent_id => Location.localhost.id
vipassana =  Area.create :name => "Vipassana" , :parent_id => Location.find_by_name(Location.localhost_name).id
translation_organisation = Organisation.create :name=>"translation_organisation", :parent_id => vipassana.id
 #, :parent_id=>translation_organisation.id)
SpecialPartialDotKey.seed  
DotKeyCodeTranslationEditor.seed
#TranslationLanguage.create!(:iso_code=> "en_US", :name=>"American English")
#TranslationLanguage.create!(:iso_code=> "zh", :name=>"Mandarin")
#TranslationLanguage.create!(:iso_code=> "zh_MY", :name=>"Malaysia Mandarin")
#TranslationLanguage.create!(:iso_code=> "el", :name=>"Greek")  
#TranslationLanguage.create!(:iso_code=> "hi", :name=>"Hindi") 
#TranslationLanguage.create!(:iso_code=> "id", :name=>"Indonesian")
#TranslationLanguage.create!(:iso_code=> "it", :name=>"Italian")
#TranslationLanguage.create!(:iso_code=> "es", :name=>"Spanish")     





# These are languages for this application
Language.create!(:iso_code=> "en", :name=>"English") #, :parent_id=>translation_organisation.id)

#log.info("Global area and vipassana org inserted")
#current_perm = Permission.create!  :organisation => Location.world, :profile => Profile.root
#log.info(" Loc world =" + Location.world.to_s)
    #log.info(" Profile root=" + Profile.root.to_s)
     #log.info("current permission create id = " +current_perm.id.to_s)
# ceate users which can log-in
    #this block is not needed as root user is not created
    #User.all.each do |each|
      #if each.username == 'root'; next; end
      #each.destroy
    #end

    pw = '123456'
    
    
   
    param = {:password => pw,:password_confirmation => pw,:username => 'sysadmin',:email => 'admin@calm.org', 
              :actual_name=> 'admin'}
    #puts "current permission i d= " +current_perm.id.to_s
    admin = User.create! param
    admin.profiles << Profile.sysadmin
    #admin.add_permission location: Location.world, profile: Profile.sysadmin, make_current: true
    param = {:password => pw,:password_confirmation => pw,:username => 'albert',:email => 'albert@calm.org', 
              :actual_name=> 'albert'}
    #puts "current permission i d= " +current_perm.id.to_s
    albert = User.create! param
    albert.profiles << Profile.sysadmin
    #albert.add_permission location: Location.world, profile: Profile.sysadmin, make_current: true
    param = {:password => pw,:password_confirmation => pw,:username => 'a',:email => 'a@calm.org', 
              :actual_name=> 'a'}
    #puts "current permission i d= " +current_perm.id.to_s
    a = User.create! param
    a.profiles << Profile.sysadmin
    #a.add_permission location: Location.world, profile: Profile.sysadmin, make_current: true
    #admin.add_permission current_perm

    #prof_guest = Profile.create! :name => 'guest', :roles => ['guest']
    #perm = Permission.create!  :organisation => vipassana,  :profile => prof_guest
    #admin.add_permission perm
    #param[:organisation]=translationLanguages
    param[:username]='translator'
    param[:email]= 'translator@calm.org'
    param[:actual_name] = 'trannie'
    translator=User.create! param
    translator.profiles << Profile.guest
    #translator.add_permission location: Location.world, profile: Profile.guest, make_current: true
    log.info("trannie created")
    param[:username]='developer'
    param[:actual_name] = 'devvie'
    param[:email]= 'developer@calm.org'
    developer=User.create! param
    developer.profiles << Profile.guest
    #developer.add_permission location: Location.world, profile: Profile.guest, make_current: true
    log.info("devvie created")

#User.create!( :username=>'translator', :email=> 'translator@calm.org', :password=>'123456', :confirm_password=>'123456')
#User.create!( :username=>'admin', :email=> 'admin@calm.org', :password=>'123456', :confirm_password=>'123456')
#User.create!( :username=>'developer', :email=> 'developer@calm.org', :password=>'123456', :confirm_password=>'123456')
log.info("Users inserted")
#binding.pry
#user_id = User.find_by_username('translator').id
#nl_id = nl.id
#c_rd_db_id = red_reg4_loc_test.id 
#UserWork.create!(:user_id=> User.find_by(username: 'translator').id, :translation_language_id => nl.id, :current_redis_database_id=> red_reg4_loc_test.id )
#UserWork.create!(:user_id=> User.find_by(username: 'developer').id, :translation_language_id => en.id, :current_redis_database_id=> red_trans1_int_dev.id)
#log.info("User works inserted")
#=end