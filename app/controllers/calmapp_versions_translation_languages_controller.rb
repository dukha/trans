class CalmappVersionsTranslationLanguagesController < ApplicationController
  before_action :authenticate_user!
  filter_access_to :all
  before_action :set_calmapp_versions_translation_language, only: [:show, :edit, :update, :destroy, :deepdestroy]
  require 'translations_helper'
  include TranslationsHelper
  require 'will_paginate/array'
  
  @@model = "calmapp_versions_translation_language"
 # before_action :set_calmapp_versions_translation_language, only: [:show, :edit, :update, :destroy]

  # GET /calmapp_versions_translation_languages
  # GET /calmapp_versions_translation_languages.json
  def index
    if CalmappVersionsTranslationLanguage.respond_to? :searchable_attr  
      searchable_attr = CalmappVersionsTranslationLanguage.searchable_attr 
    else 
      searchable_attr = [] 
    end

    criteria=criterion_list(searchable_attr)
    operators=operator_list( searchable_attr, criteria)

    if CalmappVersionsTranslationLanguage.respond_to? :sortable_attr  
      sortable_attr = CalmappVersionsTranslationLanguage.sortable_attr     
    else   
      sortable_attr = []   
    end

    sorting=sort_list(sortable_attr)
    search_info = init_search(current_user, CalmappVersionsTranslationLanguage.searchable_attr, CalmappVersionsTranslationLanguage.sortable_attr)
    if searchable_attr.nil? || searchable_attr.empty?  
      @calmapp_versions_translation_languages = CalmappVersionsTranslationLanguage.paginate(:page => params[:page], :per_page=>20)
    else
      search_info = init_search(current_user, searchable_attr, sortable_attr)#init_search(criterion_list(searchable_attr), operator_list( searchable_attr, criterion_list(searchable_attr)),sort_list(sortable_attr))
      #@delayed_jobs = DelayedJob.search(current_user, criterion_list(searchable_attr), operator_list( searchable_attr, criterion_list(searchable_attr)),sort_list(sortable_attr)).paginate(:page => params[:page], :per_page=>15)
      @calmapp_versions_translation_languages = CalmappVersionsTranslationLanguage.search(current_user, search_info).paginate(:page => params[:page], :per_page=>20)
    end
    
    #@calmapp_versions_translation_languages = CalmappVersionsTranslationLanguage.search(current_user, search_info)
    #@calmapp_versions_translation_languages = @calmapp_versions_translation_languages.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @calmapp_versions_translation_languages }
    end
  end

  # GET /calmapp_versions_translation_languages/1
  # GET /calmapp_versions_translation_languages/1.json
  def show
  end

  # GET /calmapp_versions_translation_languages/new
  def new
    @calmapp_versions_translation_language = CalmappVersionsTranslationLanguage.new
  end

  # GET /calmapp_versions_translation_languages/1/edit
  def edit
  end

  # POST /calmapp_versions_translation_languages
  # POST /calmapp_versions_translation_languages.json
  def create
    @calmapp_versions_translation_language = CalmappVersionsTranslationLanguage.new(calmapp_versions_translation_language_params) 
    
    respond_to do |format|
      if @calmapp_versions_translation_language.save
        tflash('create', :success, {:model=>@@model, :count=>1})
        format.html { redirect_to( calmapp_versions_translation_languages_path, notice: 'Calmapp versions translation language was successfully created.') }
        format.json { render action: 'show', status: :created, location: @calmapp_versions_translation_language }
      else
        format.html { render action: 'new' }
        format.json { render json: @calmapp_versions_translation_language.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calmapp_versions_translation_languages/1
  # PATCH/PUT /calmapp_versions_translation_languages/1.json
  def update
    @calmapp_versions_translation_language.assign_attributes(calmapp_versions_translation_language_params)  
    respond_to do |format|
      begin
      if @calmapp_versions_translation_language.save
    
        tflash('update', :success, {:model=>@@model, :count=>1})
        flash[:notice] = "The contents of any uploaded translation files will be written to the database later. At the moment they await processing on a queue."
        format.html { redirect_to( calmapp_versions_translation_languages_path)}
        format.json { head :no_content }
      else
    
        format.html { render action: 'edit' }
        format.json { render json: @calmapp_versions_translation_language.errors, status: :unprocessable_entity }
      end # save
      rescue PsychSyntaxErrorWrapper => psew
        flash[:error]= "Format of file : " + psew.file_name + " is bad. Copy the following error message and contact tech support with the file. Error message : " + psew.message
        format.html { render action: 'edit' }
      rescue UploadTranslationError => ute
    
        flash[:error]= ute.message
        flash[:notice] = "Failed to write file : " + ute.file_name + ". No upload done."
        format.html { render action: 'edit' } 
      end  
    end
  end

  # DELETE /calmapp_versions_translation_languages/1
  # DELETE /calmapp_versions_translation_languages/1.json
  def destroy
    begin 
      @calmapp_versions_translation_language.destroy
      respond_to do |format|
        format.html { redirect_to calmapp_versions_translation_languages_path }
        format.json { head :no_content }
        format.js {}
      end  
    rescue StandardError => e
      @calmapp_versions_translation_language = nil
      flash[:error] = e.message
      respond_to do |format|
        format.js
      end
    end #rescue  
  end
  
  def deepdestroy
     description = @calmapp_versions_translation_language.description
     begin
      @calmapp_versions_translation_language.deep_destroy
      respond_to do |format|
          tflash('deep_destroy', :success, {:model=>@@model, :description=> description, :count=>1})
          format.html { redirect_to(calmapp_versions_path) }
          format.js {}
        end
    rescue StandardError => e
      @calmapp_version = nil
      flash[:error] = e.message
      respond_to do |format|
        format.js
      end
    end #rescue  
  end

=begin
 publish_language publishes a single language translations of a particular version to the chosen redis_database  
=end
  def languagepublish
    # a 
    #@calmapp_versions_translation_language_id = params[:id]
    calmapp_versions_translation_language = CalmappVersionsTranslationLanguage.find(params[:id])
    #calmapp_versions_translation_language.translation_language
    #count = Translation.where{cavs_translation_language_id == calmapp_versions_translation_language.id}.where{incomplete == false}
    begin
      RedisDatabase.validate_redis_db_params(params[:redis_database_id])
  
      redis_db = RedisDatabase.find(params[:redis_database_id])
      count = redis_db.version_language_ready_to_publish(calmapp_versions_translation_language.translation_language).count  
      #count = redis_db.publish_version_language(calmapp_versions_translation_language.translation_language)
      PublishLanguageToRedisJob.perform_later(calmapp_versions_translation_language.calmapp_version_tl.id, calmapp_versions_translation_language.translation_language.id, redis_db.id)
     
      if request.xhr? then
        payload = {"result" => count, "status" =>200}
        flash[:notice] = "Queued #{count} translations to '#{redis_db.description}' to be published."
        respond_to do |format|
          format.js
        end
      end
    rescue StandardError=> e
      payload = {"result" => (e.message + ((params[:redis_database_id].blank?) ? '' : (" on #{redis_db.description}." + " Try again later or contact yor system administrator."))), "status" => 400}
      flash[:error] = payload["result"] 
      Rails.logger.error(payload["result"])
      respond_to do |format|
          format.js
      end
    end  
  end

  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calmapp_versions_translation_language
      @calmapp_versions_translation_language = CalmappVersionsTranslationLanguage.find(params[:id])
    end

    
    def calmapp_versions_translation_language_params
=begin 
      
      nested_keys = params.require(:calmapp_versions_translation_language).fetch(:translations_uploads_attributes, {}).keys
  params.require(:calmapp_versions_translation_language).permit(:translation_language_id, :calmapp_version_id,
                       :calmapp_version, :translation_language,:translations_uploads_attributes => nested_keys)
     
      params.require(:calmapp_versions_translation_language).permit(
                 :translation_language_id, :calmapp_version_id,
                       :calmapp_version, :translation_language,
                       :translations_uploads_attributes=>[:description, :_destroy, :yaml_upload]) #, :translations_uploads_attributes[], :calmapp_versions_translation_languages_attributes[]
=end   
      params.require(:calmapp_versions_translation_language).permit!
    end
end
