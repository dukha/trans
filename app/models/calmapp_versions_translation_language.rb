class CalmappVersionsTranslationLanguage < ActiveRecord::Base
  include Validations
  extend SearchModel
  include SearchModel

  def self.searchable_attr 
     %w(calmapp_version_id translation_language_id )
  end
  def self.sortable_attr
      []
  end
  belongs_to :calmapp_version_tl, :inverse_of=>:calmapp_versions_translation_languages, :class_name => "CalmappVersion", :foreign_key =>"calmapp_version_id"
  belongs_to :translation_language
  has_many :translations, :foreign_key=> "cavs_translation_language_id"
  has_many :translations_uploads
  validates :translation_language_id, :uniqueness => {:scope=> :calmapp_version_id}
  validates :calmapp_version_id, :uniqueness => {:scope=> :translation_language_id}
  #validates :calmapp_version, :existence=>true
  #validates :language, :existence=>true
  #attr_accessor :write
  has_many :translations_uploads, :foreign_key=> "cavs_translation_language_id"
  accepts_nested_attributes_for :translations_uploads, :reject_if => :all_blank, :allow_destroy => true
  
  has_many :cavs_tl_translators, :foreign_key=> "cavs_translation_language_id"
  has_many :translators, :through => :cavs_tl_translators, :class_name => 'User', :source=> 'user'
  
  has_many :developer_jobs, :foreign_key => "cavs_translation_language_id" , :class_name=> "CavsTlDeveloper"
  has_many :developers, :through => :developer_jobs, :source => :user,  :class_name => "User", :foreign_key => :user_id 
  
  has_many :administrator_jobs, :foreign_key => "cavs_translation_language_id" , :class_name=> "CavsTlDeveloper"
  has_many :administrators, :through => :administrator_jobs, :source => :user,  :class_name => "User", :foreign_key => :user_id
  
  # once we have saved a new language then we upload the base file for that translation 
  after_create :base_locale_translations_for_new_translation_languages, :add_this_to_sysadmin_users
  after_commit :after_commit_on_create, :on => :create
  #after_update :do_after_update
  before_destroy :deep_destroy

=begin  
  def do_after_update
    binding.pry
    puts "after translation upload"
  end 
=end  
  def self.permitted_for_translators
     #all.load - [TranslationLanguage.TL_EN ]
     en_id = TranslationLanguage.TL_EN.id
     where{translation_language_id != my{en_id} }.load 
  end
  def self.permitted_for_developers
     #all.load - [TranslationLanguage.TL_EN ]
     en_id = TranslationLanguage.TL_EN.id
     where{translation_language_id == my{en_id} }.load 
  end
  def self.permitted_for_administrators
     all
  end
  
  def redis_databases
    return calmapp_version_tl.redis_databases
  end
  
  def redis_databases_count
    return redis_databases.count
  end
  def description
    #return (CalmappVersion.find(calmapp_version_id).description + " " + TranslationLanguage.find(translation_language_id).name).titlecase
    return (calmapp_version_tl.description + " " + translation_language.name).titlecase
  end
  def show_me
    return "CAVTL " + calmapp_version_tl.show_me + " " + translation_language.show_me + " cavtl-id = " + id.to_s
  end
  
=begin
 Sysadmin profiled users must have access to all cav_tls for translation purposes 
=end
  def add_this_to_sysadmin_users
    #Profile.sysadmin
    #binding.pry
    users = User.includes(:profiles).where(profiles: { name: $SYSADMIN }).all
    users.each do |u|
      if not u.administrator_cavs_tls.include?(self) then
        u.administrator_cavs_tls << self
      end  
    end
  end  
=begin
 Uploads the base translation for a new language after added (ie created)
 saves new upload
=end
  def base_locale_translations_for_new_translation_languages
    #binding.pry
    puts "after save in base_locale_translations_for_new_translation_languages"
    
    uploads =  TranslationsUpload.where{cavs_translation_language_id == my{id}}.load
    found=false
    # Check to see that this is not a reupload
    if not uploads.empty? then
      # the file is already uploaded
      uploads.each do |u|
        # This doesn't always work: if u.yaml_upload.identifier == base_locale_file_name then
        if u.yaml_upload_identifier == base_locale_file_name then
          found=true
          return
        end
      end  #each       
    end # not empty
    if not found then
         # all the standard base files are in a rails dir as below (they havebeen downloaded from /home/mark/.rvm/gems/ruby-2.0.0-p247/gems/rails-i18n-4.0.1/rails/locale/)
        file_to_upload = File.join(TranslationsUpload.base_locales_folder,  base_locale_file_name())
        
        if File.exists?(file_to_upload) then          
          tu = TranslationsUpload.new(:cavs_translation_language_id=>id, 
               :yaml_upload=> File.open(file_to_upload) , :description=> "Automatic base locale upload " + base_locale_file_name())
          
          tu.save
          #if tu.save then
            #tu.write_file_to_db2 #Translation.Overwrite[:continue_unless_blank]
          #end #upload saved
        else
          # The file may not exist, in which case we don"t write but warn"
          calmapp_version_tl.warnings=ActiveModel::Errors.new(self) if calmapp_version_tl.warnings.nil?
          calmapp_version_tl.warnings.add(:base, I18n.t($MS + "base_locale_file_not_found.warning", :folder => TranslationsUpload.base_locales_folder, :file_name=> base_locale_file_name,:fuchs=> "https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale"))
          #flash.now[:warning] = "The file " + base_locale_file_name + " does not exist in " + File.join(Rails.root, "base_locales") + " You will have to fill in about 160 more translations if you can't find this file. You can also copy and rename a file from a close locale. e.g. copy zh-CN.yml renaming to zh-MY.yml for Mayaysian Chinese."
          Rails.logger.warn "The file " + base_locale_file_name + " does not exist in " + TranslationsUpload.base_locales_folder + " You will have to fill in about 160 more translations if you can't find this file. You can also copy and rename a file from a close locale. e.g. copy zh-CN.yml renaming to zh-MY.yml for Mayaysian Chinese."
        end # base file exists
   end # not found
  end # def
  
  def after_commit_on_create
    CalmappVersionsTranslationLanguage.add_all_dot_keys_from_en_for_new_translation_language(id)
  end
  def self.add_all_dot_keys_from_en_for_new_translation_language(cavtl_id)
    #after commit on create : add_all_en_dot_keys_for_new_translation_languages
    #binding.pry
    cavtl = CalmappVersionsTranslationLanguage.find(cavtl_id)
    en_trans = Translation.single_lang_translations_arr("en", cavtl.calmapp_version_id).all
    count =0 
    en_trans.each do |t|
      #binding.pry
      tt = Translation.find(t.id)
      #new_cavtl = CalmappVersionsTranslationLanguage.create!(  :calmapp_version_id => cavtl.calmapp_version_id, :translation_language_id => cavtl.id)
      plural_incomplete = nil
      # because we only put in dot_key_codes, no translations at this point
      plural_incomplete = true if tt.is_plural?
      
      Translation.create!(
           :dot_key_code => t.dot_key_code, 
           :cavs_translation_language_id => cavtl.id, 
           :translation => ActiveSupport::JSON.encode(''),
           :plural_incomplete => plural_incomplete) unless Translation.where{dot_key_code == my{t.dot_key_code}}.where{cavs_translation_language_id == my{cavtl.id}}.exists?
      count = count + 1
      return if count == 3
    end
    
  end
  
  def base_locale_file_name
    translation_language.iso_code + ".yml"
  end
  def self.find_by_language_and_version language_id, version_id
    where{calmapp_version_id == version_id}.where{translation_language_id == language_id}
    
  end
  
  def self.find_languages_not_in_version  language_ids_array, version_id
    where{calmapp_version_id == version_id}.where{translation_language_id << language_ids_array}
  end
  
  def deep_destroy()
    #if current_user.role_symbols.include?(:calmapp_versions_translation_languages_deepdestroy)
      transaction do
         translations.find_each {|t| t.delete}
         translations_uploads.find_each{|tl| tl.delete}
         translators.find_each { |tor| tor.delete}
         #destroy 
         delete
      end # transaction
    #else
      #raise Exceptions::NoLanguageDeleteAuthorisation.new({version: calmapp_version_tl.name, language: translation_language.full_name})
    #end # if user  
  end # def
end #class
