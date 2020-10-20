module SiteHelper
    def msg_jumbotron
        case params[:action]
        when 'index'
            "Last Indexed Questions"
        when 'questions'
            "Results for \"#{params[:term]}\""
        when 'subject'
            "Showing questions for \"#{params[:subject]}\""
        end
    end
end
