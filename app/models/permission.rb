class Permission < ActiveRecord::Base

  # these relationships model that the user is allowed to access this organisation
  belongs_to :user
  belongs_to :organisation
  belongs_to :profile

  # on production got error:
  # ActionView::Template::Error (undefined method `profile_id' for #<Permission:0xacf786c>):
  #attr_accessible :user_id, :organisation_id, :profile_id, :user, :organisation, :profile

 scope :for_user, lambda { |user| where( 'user_id = ?', user.id) }
 scope :under_location, lambda { |org| where( 'organisation_id IN (?)', org.accessible_organisations.collect{|each| each.id} ) }

  def to_s
    self.organisation.name + ", profile: " + self.profile.name + ", user: " + self.user.username
  end

  def display
    organisation.name + ", " + profile.name
  end
end

# == Schema Information
#
# Table name: permissions
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  organisation_id :integer         not null
#  created_at      :datetime
#  updated_at      :datetime
#  profile_id      :integer         not null
#

#--
# generated by 'annotated-rails' gem, please do not remove this line and content below, instead use `bundle exec annotate-rails -d` command
#++
# Table name: permissions
#
# * id              :integer         not null
#   user_id         :integer
#   organisation_id :integer         not null
#   created_at      :datetime        not null
#   updated_at      :datetime        not null
#   profile_id      :integer         not null
#--
# generated by 'annotated-rails' gem, please do not remove this line and content above, instead use `bundle exec annotate-rails -d` command
#++
