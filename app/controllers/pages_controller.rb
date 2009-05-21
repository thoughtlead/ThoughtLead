class PagesController < ApplicationController
  before_filter :community_is_active
  before_filter :owner_login_required, :except => [ :catchall ]
  
  uses_tiny_mce(tiny_mce_options)
  
  def show
    @path = params[:id]
    catchall
  end
  
  def edit
    @page = current_community.pages.find_by_page_path(params[:id])
  end
  
  def update
    @page = current_community.pages.find_by_page_path(params[:id])
    @page.attributes = params[:page]

    return render(:action => :edit) unless @page.save
    
    flash[:notice] = "Successfully saved"
    redirect_to @page
  end
  
  def catchall
    @path ||= params[:path].join("/")
    if @page = current_community.pages.find_by_page_path(@path)
      render_custom_page(@page)
    else
      render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
    end
  end
end
