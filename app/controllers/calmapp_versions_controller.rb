class CalmappVersionsController < ApplicationController
  require 'translations_helper'
  include TranslationsHelper
  # GET /application_versions
  # GET /application_versions.xml
  
  before_action :authenticate_user!
  before_action :set_calmapp_version, only: [ :edit, :update, :destroy, :show, :redisdbalter, 
      :deep_copy_params ]
  filter_access_to :all
  @@model="calmapp_version"
  
  def index
  
    @calmapp_versions = CalmappVersion.paginate(:page => params[:page], :per_page=>15)  #CalmappVersion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @calmapp_versions }
    end
  end

  # GET /calmapp_versions/1
  # GET /calmapp_versions/1.xml
  def show
    #@calmapp_version = CalmappVersion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @calmapp_version }
    end
  end

  # GET /calmapp_versions/new
  # GET /calmapp_versions/new.xmlcalmapp_version_tl.
  def new
    @calmapp_version = CalmappVersion.new
    #@calmapp_version.translation_languages << TranslationLanguage.where{iso_code == 'en'}.first#CalmappVersionsTranslationLanguage.new(:translation_language_id => TranslationLanguage.where{iso_code == 'en'}.first)
    #@calmapp_version.translation_languages_assigned = [] 
    #@calmapp_version.translation_languages_assigned << TranslationLanguage.where{iso_code == 'en'}.first#CalmappVersionsTranslationLanguage.new(:translation_language_id => TranslationLanguage.where{iso_code == 'en'}.first)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @calmapp_version }
    end
  end

  # GET /calmapp_versions/1/edit
  def edit
    #@calmapp_version = CalmappVersion.find(params[:id])
    #set_calmapp_version
  end

  # POST /calmapp_versions
  # POST /calmapp_versions.xml
  def create
    #binding.pry
=begin
    if not redis_db_update? then
      attr_hash = prepare_params_with_translation_language(params[:id], params[:calmapp_version][:calmapp_versions_translation_language_ids])
      params["calmapp_version"]["calmapp_versions_translation_languages_attributes"] = attr_hash
      params[:calmapp_version].delete(:calmapp_versions_translation_language_ids)
    end
=end
    prepare_params
    #new_calmapp_versions_translations_languages = new_languages()
    #We are going to create just the basic version with none of the assoications
    # We then use a delayed update to add all the associations
    @calmapp_version = CalmappVersion.new(calmapp_version_params)#{:version=>params[:calmapp_version][:version], :calmapp_id=>params[:calmapp_version][:calmapp_id] })
    #binding.pry
    respond_to do |format|
      if @calmapp_version.save
        #binding.pry
        #if @calmapp_version.delay.update_attributes(params[:calmapp_version])
        if @calmapp_version.update_attributes(params[:calmapp_version])  
          #binding.pry
          #ApplicationController.start_delayed_jobs_queue()
        #if @calmapp_version.delay.save
      #if @calmapp_version.valid? then
        #if version_create_detached then
          tflash('valid_version_on_queue', :success, {:model=>@@model, :count=>1})
          format.html { redirect_to( :action => "index")} #(@calmapp_version #, :notice => 'Application version was successfully created.') }
          format.xml  { render :xml => @calmapp_version, :status => :created, :location => @calmapp_version }
        #end 
        else
        #binding.pry
          format.html { render :action => "new" }
          format.xml  { render :xml => @calmapp_version.errors, :status => :unprocessable_entity }
        end # save
     else
       format.html { render :action => "new" }
        format.xml  { render :xml => @calmapp_version.errors, :status => :unprocessable_entity }
     end #save 2   
    end #do
  end

  # PUT /calmapp_versions/1
  # PUT /calmapp_versions/1.xml
  def update
    #set_calmapp_version
    prepare_params
    respond_to do |format|
        if @calmapp_version.update(calmapp_version_params)#params[:calmapp_version])
          #system "RAILS_ENV=#{Rails.env} bin/delayed_job start --exit-on-complete"
          tflash('update', :success, {:model=>@@model, :count=>1})
          
          flash[:warning] = @calmapp_version.warnings.messages[:base] if @calmapp_version.warnings 
          
          format.html { redirect_to( :action => "index")} #(@calmapp_version, :notice => 'Application version was successfully updated.') }
          format.xml  { head :ok }
        else
          #binding.pry
          # @todo get the errors from the after_save parts of the transaction and put them up
          flash[:error] = "Record not saved."
          if redis_db_update? then
            format.html { render :action => "redisdbalter" }
          else
            format.html { render :action => "edit" } 
          end
          
          format.xml  { render :xml => @calmapp_version.errors, :status => :unprocessable_entity }
        end
      
    end
  end

  # DELETE /calmapp_versions/1
  # DELETE /calmapp_versions/1.xml
  def destroy
    #set_calmapp_version
    @calmapp_version.destroy

    respond_to do |format|
      tflash('delete', :success, {:model=>@@model, :count=>1})
      format.html { redirect_to(calmapp_versions_url) }
      format.js {}
    end
  end

  def redisdbalter
    #binding.pry
    #set_calmapp_version
  end


=begin
 We are not going to use it. Too hard to call rake from within giving it params as json
 We'll fudge and use delayed_job instead 
 @deprecated until next version
=end  
  def version_create_detached
    #@calmapp_version = CalmappVersion.new(params[:calmapp_version])
    #params_json = JSON.generate(params)
    return call_rake("version:create")
  end
  
=begin  
  def version_alterwithredisdb
    #@calmapp_version = CalmappVersion.find(params[:id])
    set_calmapp_version
  end
  
  def publish_to_redis
    
  end
=end
  def deep_copy_params
    #binding.pry
    set_calmapp_version
    @previous_calmapp_version = @calmapp_version
    @calmapp_version = CalmappVersion.new(:calmapp_id => @previous_calmapp_version.calmapp_id, :previous_id =>@previous_calmapp_version.id, :copied_from_version => @previous_calmapp_version.version)
    
  end
  
  def deep_copy
    #set_calmapp_version
    @calmapp_version = CalmappVersion.new(:calmapp_id=> params["calmapp_version"]["calmapp_id"], :copied_from_version => params["calmapp_version"]["copied_from_version"], 
            :version => params["calmapp_version"][:version], :previous_id => params[:calmapp_version][:previous_id] )
      
    #end
    #begin
      #CalmappVersion.deep_copy(params[:calmapp_version][:previous_id], params[:calmapp_version][:version] )
      if @calmapp_version.deep_copy(params[:calmapp_version][:previous_id], current_user )
        flash[:success] = "Application Version copied. All the languages and translations are in a background process. You will get a mail to let you know the result"
        redirect_to action: "index"
      else
         #binding.pry
         flash[:error] = @calmapp_version.errors.messages[:version]
         @previous_calmapp_version =CalmappVersion.find(@calmapp_version.previous_id)
         #params["id"] = params["calmapp_version"]["previous_id"]
         #set_calmapp_version
         #@previous_calmapp_version = @calmapp_version
         #@calmapp_version = CalmappVersion.new(:calmapp_id => @previous_calmapp_version.calmapp_id, :previous_id =>@previous_calmapp_version.id)
         render action: "deep_copy_params"
      end    
        
        
    #rescue StandardError => e
      #binding.pry
      #params["id"] = params["calmapp_version"]["previous_id"]
      #set_calmapp_version
      #@previous_calmapp_version = @calmapp_version
      #@calmapp_version = CalmappVersion.new(:calmapp_id => @previous_calmapp_version.calmapp_id, :previous_id =>@previous_calmapp_version.id)
      #deep_copy_params()
      #@calmapp_version.version =  params[:calmapp_version][:version]
      #render action: "deep_copy_params"
    #end  
  end
  
  
  
   private
     def redis_db_update? 
       #binding.pry
       return params[:calmapp_version][:calmapp_versions_translation_language_ids] == nil
     end
     
   
=begin     
     def prepare_params
       #binding.pry
       return => [:translation_language_id] if not params[:calmapp_version]
   
       if not redis_db_update? then
         # This puts the params in the correct format for accepts_nested_attributes_for() 
         attr_hash = prepare_params_with_translation_language(params[:id], params[:calmapp_version][:calmapp_versions_translation_language_ids])
         params["calmapp_version"]["calmapp_versions_translation_languages_attributes"] = attr_hash
         # Now remove the param that is not part of the update: it only brought in the 2 languages
         # It will bomb if this delete is not done.
         params[:calmapp_version].delete(:calmapp_versions_translation_language_ids)
         params[:calmapp_version].delete(:translation_languages_available)
      end
     end
=end

    def prepare_params
       return if not params[:calmapp_version]
   
       if not redis_db_update? then
         # This puts the params in the correct format for accepts_nested_attributes_for() 
         attr_hash = prepare_params_with_translation_language(params[:id], params[:calmapp_version][:calmapp_versions_translation_language_ids])
         params["calmapp_version"]["calmapp_versions_translation_languages_attributes"] = attr_hash
         # Now remove the param that is not part of the update: it only brought in the 2 languages
         # It will bomb if this delete is not done.
         params[:calmapp_version].delete(:calmapp_versions_translation_language_ids)
         params[:calmapp_version].delete(:translation_languages_available)
      end
     end     
     def prepare_params_with_translation_language calmapp_version_id, translation_language_ids 

      translation_language_ids.delete ""
      #These lines should be in the model
      en_id = TranslationLanguage.where{iso_code=='en'}.first.id
=begin
      if not translation_language_ids.include?(en_id.to_s) then
        translation_language_ids << en_id.to_s
      end
=end
      attr_hash = {}
      if not calmapp_version_id.nil? then
        # a new version
        index = 0
        # Do deletes first
        languages_to_be_deleted = CalmappVersionsTranslationLanguage.find_languages_not_in_version(translation_language_ids ,calmapp_version_id).all
        #binding.pry
        if  not languages_to_be_deleted.count == 0 then
          languages_to_be_deleted.each do |l|
            attr_hash[index.to_s] = {"translation_language_id"=>l.translation_language_id, "calmapp_version_id"=>l.calmapp_version_id, "_destroy"=>"1", "id" =>l.id}
            index += 1  
          end
        end 
      end # calmapp_version not nil  
      # now the inserts and updates
      puts "in prepare_params_with_translation_language"

      translation_language_ids.each do |tlid|
        tl_id = tlid.to_i
        cvtl = CalmappVersionsTranslationLanguage.find_by_language_and_version(tl_id,calmapp_version_id )#.first
        
        if not cvtl.empty? then
          #puts "cvtl " + cvtl.to_s
          attr_hash[index.to_s] =  {"translation_language_id"=>cvtl.first.translation_language_id, 
              "calmapp_version_id"=>calmapp_version_id, "_destroy"=>false, "id"=>cvtl.first.id}
          index += 1
        else
          puts "cvtl empty"
          attr_hash[rand(1299999999999..1399999999999).to_s] = {"translation_language_id"=>tl_id, "calmapp_version_id"=>calmapp_version_id,  "_destroy"=>false}
        end # empty
        puts "end prepare_params_with_translation_language"
      end #each
    return attr_hash
   end

    # Use callbacks to share common setup or constraints between actions.
    def set_calmapp_version
      @calmapp_version = CalmappVersion.find(params[:id])
    end

   
    def calmapp_version_params
      params.require(:calmapp_version).permit(:calmapp_id, 
         :version,  
         :redis_databases, 
         :translation_languages, 
         :translation_languages_available, 
         :cavs_translation_language_id,
         :calmapp_version, 
         #:calmapp_versions_translation_languages => [:translation_language_id], 
         #:calmapp_versions_redis_database_attributes=>[:redis_database_id, :calmapp_version_id, :release_status_id, :_destroy, :id, :redis_database_attributes=>[:redis_instance_id, :redis_db_index]],
         :calmapp_versions_translation_languages_attributes=>[:translation_language_id, :calmapp_version_id, :_destroy, :id ], 
         #:calmapp_versions_redis_database => [:redis_database_id], 
         :redis_databases_attributes=>[:redis_db_index, :release_status_id, :redis_instance_id, :_destroy, :id],
         :calmapp_versions_translation_language_ids=>[]#,
         #:calmapp_versions_redis_database_ids=>[]
         )
    end
end
