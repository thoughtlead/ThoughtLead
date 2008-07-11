class IntermediateController < ApplicationController
  def redirect
    unless params[:notice] && params[:redirect_to]
      redirect_to request.referer
    else
      flash[:notice] = params[:notice]
      redirect_to params[:redirect_to]
    end
  end
end
