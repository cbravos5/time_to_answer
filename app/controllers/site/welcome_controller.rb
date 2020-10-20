class Site::WelcomeController < SiteController
  def index
    @questions = Question.includes(:subject)
                         .order('created_at desc')
                         .page(params[:page]).per(25)
  end
end
