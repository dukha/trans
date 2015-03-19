class CalmappsController < ApplicationController
  require 'translations_helper'
  include TranslationsHelper
  before_action :authenticate_user!
  before_action :set_calmapp, only: [ :edit, :update, :destroy, :show]
  filter_access_to :all
 
  @@model ="calmapp"
  
  def index
    #@applications = Calmapp.all
    @calmapps =  Calmapp.paginate(:page => params[:page], :per_page=>15)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @calmapps }
    end
  end

  # GET /calmapps/1
  # GET /applications/1.xml
  def show
    #binding.pry
    #@calmapp = Calmapp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @calmapp }
    end
  end

  # GET /calmapps/new
  # GET /applications/new.xml
  #def all_in_one_new
    #debugger
    #puts "qqqq all in one"
    #@calmapp = Calmapp.new
    #@application.id=nil
    #@languages = Language.all
    #@app_langs=[]
    #debugger
    #@languages.each {|l|
      #al=AppLang.new
      #debugger
      #al.language_id = l.id
      #al.iso_code = l.iso_code
      #al.write = false
      #@app_langs<<al
    #  al.language_id = l.id
    #  @application.languages << albinding.pry
    #}
    #@application.languages=@languages

    #debugger
    #respond_to do |format|
      #format.html # new.html.erb
      #format.xml  { render :xml => @calmapp }
    #end
  #end

  def new   
    @calmapp = Calmapp.new
    @calmapp_version = CalmappVersion.new
    #statuses = ReleaseStatus.all
    #@redis_database=RedisDatabase.new
    #@redis_database.release_status_id = ReleaseStatus.where{status =~  'development'}.limit(1)[0].id
    #statuses.each{|s|
      #rdb= RedisDatabase.new
      #rdb.release_status_id=s.id
      #@redis_databases << rdb
    #}
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @calmapp }
    end
  end
  def create
    @calmapp = Calmapp.new(calmapp_params) #params[:calmapp],without_protection: true)
    #binding.pry
    respond_to do |format|
      if @calmapp.save( )
        format.html { redirect_to calmapps_url, notice: 'Calmapp was successfully created.' }
        format.json { render action: 'show', status: :created, location: @calmapp }
      else
        #binding.pry
        format.html { render action: 'new' }
        format.json { render json: @calmapp.errors, status: :unprocessable_entity }
      end
    end
    #debugger
    #When a checkbox comes back to the controller the params has a value of either '1' or '0' for true and false.
    # Hence we have to test this differently here and 2 lines further
    #debugger
=begin   
    if params[:calmapp][:new_version] != '0' then
      @calmapp_version =CalmappVersion.new(params[:calmapp_version])
      if params[:calmapp_version][:add_languages] != '0' then
        @languages = params[:calmapp_version][:language_ids].collect{|li| Language.find(li)}
      end
      if params[:calmapp_version][:new_redis_dev_db] != '0' then
        @redis_database = RedisDatabase.new(params[:redis_database])
      else
        @redis_database =nil
      end
    else
      @calmapp_version = nil
      @redis_database=nil
      @languages=nil
    end
    begin
      #debugger5
      @calmapp.save_app_version_database_languages(@calmapp_version, @redis_database, @languages)
        #tflash('create', :success, {:model=>@@model, :count=>1})
        tflash("create", :success, {:model=> @@model })
        redirect_to(:action=> :index)  #@calmapp }#(:action=>:index, :controller => :calmapps) }


      rescue ActiveRecord::InvalidForeignKey => invalid_fk
        #debugger
        puts invalid_fk.message
        render :action => :new, :controller =>'calmapps'
      #rescue ActiveRecord::RecordInvalid => invalid
        #puts invalid.message
        #tflash[:error] = invalid.message
        #render :action=> :new
         #InvalidRecord needs to be rescued so that ValidatesExistence will work properly. (otherwise all you get is a silent rollback).
         #Needs to be fixed as you get many errors being trapped a 2nd time with this catchall @todo
        #tflash[:error]= invalid.message  #+ " invalid " + invalid.class.name
        #render :action => "new", :controller => "calmapps"
      #rescue ActiveRecord::Rollback => rollback
        #render :action => "new", :controller => "calmapps"
        #tflash[:error]= rollback.message + " rollback " + rollback.class.name
        #render :action => "new", :controller => "calmapps"


      #rescue Exception => exception
        #tflash[:error]= exception.message  + " general exception " + exception.class.name
        #render :action => "new", :controller => "calmapps"

      end

    #def tflash_exception
      #tflash[:error]= exception.message
      #render :action => "new", :controller => "calmapps"
    #end
    #if @calmapp.save_app_version_database_languages(@calmapp_version, @redis_database, @languages) then
     #    tflash('create', :success, {:model=>@@model, :count=>1})
     #    redirect_to(:action=> :index)  #@calmapp }#(:action=>:index, :controller => :calmapps) }
    #else
    #    tflash[:error] = "Save of calmapp name = " + @calmapp.name + " version = " + @calmapp_version.major_version.to_s + ' failed.'
    #    render :action => "new", :controller => "calmapps"
    # end
=end    
  end
  # GET /calmapps/1/edit
  def edit
    #@calmapp = Calmapp.find(params[:id])

  end

  # POST /calmapps
  # POST /applications.xml
=begin
  def all_in_one_create
    @calmapp = Calmapp.new(params[:calmapp])
    #puts @calmapp
    #@app_langs = params[:app_langs]
    #debugger

    respond_to do |format|
      if @calmapp.save
        puts "zzzzz" + @calmapp.languages.to_s
        #if params[:version_name] then
          #@application_version= {:version=>params[:version_name], :version_status_id=> VersionStatus.where( :status, 'development')}
          #@calmapp.version.create!( @application_version)
        
          #if @calmapp.version != nil then
            tflash('create', :success, {:model=>@@model, :count=>1})
            format.html { redirect_to(:action=>:index) }
            format.xml  { render :xml => @calmapp, :status => :created, :location => @calmapp }
          #else
            #tflash[:error] =  t(messages.errors.failed_to_save_version_in_application, :calmapp=>@application['name'], :version=>@calmapp_version['version'])
          #end
        #else
          #tflash('create', :success, {:model=>@@model))
          #format.html { redirect_to( :action => "index")} #(@application_version #, :notice => 'Application version was successfully created.') }
          #format.xml  { render :xml => @calmapp_version, :status => :created, :location => @application_version }
        #end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @calmapp.errors, :status => :unprocessable_entity }
      end
    end
  end
=end
  # PUT /applications/1
  # PUT /calmapps/1.xml
  def update
    #@calmapp = Calmapp.find(calmapp_params)#params[:id])
    #binding.pry
=begin
    if params[:calmapp][:language_ids]==nil then
      params[:calmapp][:language_ids] = Array.new
    end
=end   
    
    respond_to do |format|
      #binding.pry
      if @calmapp.update(calmapp_params) #params[:calmapp], without_protection: true)
        
        tflash('update', :success, {:model=>@@model, :count=>1})
        format.html { redirect_to(:action=>:index) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @calmapp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /applications/1
  # DELETE /calmapps/1.xml
  def destroy
    #binding.pry
    #@calmapp = Calmapp.find(params[:id])
    #binding.pry
    
    begin
      @calmapp.destroy
      #tflash('delete', :success, {:model=>@@model, :count=>1})
      respond_to do |format|
        tflash('delete', :success, {:model=>@@model, :count=>1})
        format.html { redirect_to(calmapps_url) }
        format.js {}
      end 
    rescue ActiveRecord::DeleteRestrictionError => e
      # We need to do this here as an calmapp cannot be deleted whilst it has dependent versions
      @calmapp.errors.add(:base, e)
      #redirect_to calmapps_path
      render :action=> "index"
    end
  end

  # rails 4 Strong Params needs this: Not tested yet
  def calmapp_params
    params.require(:calmapp).permit(:name,  {calmapp_versions_attributes: [:id, :version, :_destroy], :developer_ids => []})
  end
  
  def set_calmapp
    @calmapp = Calmapp.find(params[:id])
  end
  private
=begin
    def record_not_found exception
      flash[:warning] = t('messages.record_not_found', :model=>t(@@model, :count=>1})
      flash[:error] = exception.message
      respond_to do |format|
        format.html { redirect_to(calmapps_url) }
        format.xml  { head :ok }
      end
    end
=end
end
