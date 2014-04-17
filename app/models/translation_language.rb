=begin

 Represents a (virtual)location used for all translations in a specific language
 
=end

class TranslationLanguage < ActiveRecord::Base
  #set_table_name :language
  has_many :calmapp_versions_translation_language
  has_many :calmapp_versions, :through => :calmapp_versions_translation_language
  
  #
  validates :iso_code, :name, :presence => true,:uniqueness => true
  validates :name, :presence => true, :uniqueness => true
  
  attr_accessible :iso_code, :name #,  :calm_reg_language, :course_l
  
  #validates_with VenueValidator
  def self.seed
     TranslationLanguage.create!(:iso_code=> "en", :name=>"English")
  end
  def self.demo
    TranslationLanguage.create!(:iso_code=> "nl", :name=>"Dutch")
    TranslationLanguage.create!(:iso_code=> "es", :name=>"Spanish")
    TranslationLanguage.create!(:iso_code=> "fr", :name=>"French")
    TranslationLanguage.create!(:iso_code=> "de", :name=>"German")
    TranslationLanguage.create!(:iso_code=> "en-US", :name=>"English(US)")
    TranslationLanguage.create!(:iso_code=> "zh-TW", :name=>"Chinese(Taiwan)")
    TranslationLanguage.create!(:iso_code=> "zh-CN", :name=>"Chinese(China)")
    TranslationLanguage.create!(:iso_code=> "dk", :name=>"Danish")
    TranslationLanguage.create!(:iso_code=> "pt", :name=>"Portuguese")
    TranslationLanguage.create!(:iso_code=> "it", :name=>"Italian")
    TranslationLanguage.create!(:iso_code=> "el", :name=>"Greek")
    TranslationLanguage.create!(:iso_code=> "ja", :name=>"Japanese")
    TranslationLanguage.create!(:iso_code=> "sv", :name=>"Swedish")
    TranslationLanguage.create!(:iso_code=> "hu", :name=>"Hungarian")
    TranslationLanguage.create!(:iso_code=> "sr", :name=>"Serbian")
    TranslationLanguage.create!(:iso_code=> "id", :name=>"Indonesian")
    TranslationLanguage.create!(:iso_code=> "th", :name=>"Thai")
    TranslationLanguage.create!(:iso_code=> "hi", :name=>"Hindi")
    TranslationLanguage.create!(:iso_code=> "ne", :name=>"Nepali")
    TranslationLanguage.create!(:iso_code=> "ko", :name=>"Korean")
    TranslationLanguage.create!(:iso_code=> "nb", :name=>"Norwegian")
    TranslationLanguage.create!(:iso_code=> "fi", :name=>"Finnish")
    TranslationLanguage.create!(:iso_code=> "en-AU", :name=>"English(Australia)")
    TranslationLanguage.create!(:iso_code=> "en-UK", :name=>"English(UK)")
    TranslationLanguage.create!(:iso_code=> "zh-HK", :name=>"Chinese(Hong Kong)")
    TranslationLanguage.create!(:iso_code=> "pl", :name=>"Polish")
    TranslationLanguage.create!(:iso_code=> "et", :name=>"Estonian")
    TranslationLanguage.create!(:iso_code=> "lt", :name=>"Lithuanian")
    TranslationLanguage.create!(:iso_code=> "lv", :name=>"Latvian")
    TranslationLanguage.create!(:iso_code=> "sk", :name=>"Slovak")
    TranslationLanguage.create!(:iso_code=> "cs", :name=>"Czech")
    TranslationLanguage.create!(:iso_code=> "sl", :name=>"Slovenian")
    TranslationLanguage.create!(:iso_code=> "kh", :name=>"Khymer")
    TranslationLanguage.create!(:iso_code=> "vi", :name=>"Vietnamese")
    TranslationLanguage.create!(:iso_code=> "my", :name=>"Burmese")
    TranslationLanguage.create!(:iso_code=> "mk", :name=>"Macedonian")
    TranslationLanguage.create!(:iso_code=> "af", :name=>"Afrikaans")
    TranslationLanguage.create!(:iso_code=> "zh-MY", :name=>"Chinese(Malaysia)")
    TranslationLanguage.create!(:iso_code=> "ru", :name=>"Russian")
    TranslationLanguage.create!(:iso_code=> "uk", :name=>"Ukrainian")
    TranslationLanguage.create!(:iso_code=> "mn", :name=>"Mongolian")
    
    puts "Translation Languages inserted"
  end
=begin 
  def allow_organisation_child?
    false
  end

  def allow_area_child?
    false
  end

  def allow_translation_language_child?
    false
  end

  # return false if self would not be under an organisation
  def allow_to_be_translation_language?
    has_organisation_ancestor?
  end

  
  def self.accessible_translation_languages(current_user)
    return current_user.current_organisation.accessible_translation_languages
  end
=end
  
end

# == Schema Information
#
# Table name: locations
#
#  id               :integer         not null, primary key
#  name             :string(255)     not null
#  type             :string(255)     not null
#  parent_id        :integer
#  translation_code :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  marked_deleted   :boolean         default(FALSE)
#

