class AdminsBackoffice::QuestionsController < AdminsBackofficeController
    before_action :set_question, only: [:update, :edit, :destroy]
    before_action :get_subjects, only: [:new, :edit]
  
    def index
      @questions = Question.includes(:subject)
                           .order(:description)
                           .page(params[:page]).per(25)
    end
  
    def edit
      get_subjects
    end
  
    def update
      if @question.update(params_question)
        redirect_to admins_backoffice_questions_path, notice: t('question.notice_update')
      else
        render :edit
      end
    end
  
    def new
      @question = Question.new
      get_subjects
    end
  
    def create
      @question = Question.new(params_question)
      if @question.save
        redirect_to admins_backoffice_questions_path, notice: t('question.notice_create')
      else
        render :new
      end
    end
  
    def destroy
      if @question.destroy
        redirect_to admins_backoffice_questions_path, notice: t('question.notice_delete')
      else
        render :index
      end
    end
  
    private

    def get_subjects
      @subjects = Subject.all
    end
  
    def params_question
      params.require(:question).permit(:description, :subject_id)
    end
  
    def set_question
      @question = Question.find(params[:id])
    end
  end
  