class IntermediateController < ApplicationController
  def redirect
    unless params[:notice] && params[:redirect_to]
      redirect_back_or_default(community_home_url)
    else
      flash[:notice] = params[:notice]
      redirect_to params[:redirect_to]
    end
  end
end
