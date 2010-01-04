class PagesController < ApplicationController
  include AdminHelper
  
  before_filter :community_is_active
  before_filter :owner_login_required, :except => [ :catchall ]
  
  uses_tiny_mce(tiny_mce_options_with_code_toggle)
  
  def index
    @active_pages = current_community.pages.active.user_defined.all
    @inactive_pages = current_community.pages.inactive.user_defined.all 
    @editable_pgs = current_community.pages.active.app_defined.all
  end
  
  def show
    @path = params[:id]
    catchall
  end
  
  def new
    @mce = params[:standalone] ? false : true
    @editing = false
    
    @page = current_community.pages.new(:active => true, :standalone => !@mce)
  end
  
  def create
    @page = current_community.pages.new(params[:page])
    return render(:action => :new) unless @page.save
    
    flash[:notice] = "Successfully created"
    if @page.active?
      redirect_to "/#{@page.page_path}"
    else 
      redirect_to :action => 'index'
    end
  end
  
  def edit
    @editing = true
    
    @page = current_community.pages.find_by_page_path(params[:id], :conditions => {})
    @mce = @page.standalone? ? false : true
    
  end
  
  def update
    @page = current_community.pages.find_by_page_path(params[:id])
    @page.attributes = params[:page]

    return render(:action => :edit) unless @page.save
    
    flash[:notice] = "Successfully saved"
    if @page.active?
      redirect_to "/#{@page.page_path}"
    else 
      redirect_to :action => 'index'
    end
  end
  
  def destroy
    @page = current_community.pages.find_by_page_path(params[:id])
    if @page.update_attribute(:active, false)
      redirect_to :action => 'index'
    else
      redirect_to "/#{@page.page_path}"
    end
  end
  
  def catchall
    @path ||= params[:path].join("/")
    if @page = current_community.pages.active.find_by_page_path(@path)
      render_custom_page(@page)
    else
      render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
    end
  end

end
