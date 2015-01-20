class IndexController < ApplicationController
  before_filter :setup_negative_captcha, :only => [:new, :create]

  private
  def setup_negative_captcha
    @captcha  = NegativeCaptcha.new(
        secret:  NEGATIVE_CAPTCHA_SECRET,
        spinner:  request.remote_ip,
        fields: [:felhasznalo_nev, :jelszo],
        params: params
    )
  end

  def create
    @comment = Comment.new(@captcha.values)

    if @captcha.valid? && @comment.save
      redirect_to @comment
    else
      flash[:notice] = @captcha.error if @captcha.error
      render :action => 'new'
    end
  end
end
