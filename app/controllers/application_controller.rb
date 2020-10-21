class ApplicationController < ActionController::Base
    layout :layout_by_resource
    before_action :check_pagination
    before_action :set_global_params

    private

    def layout_by_resource
        devise_controller? ? get_layout : "application" 
    end

    def get_layout
        "#{resource_class.to_s.downcase}_devise"
    end

    def check_pagination
        unless user_signed_in?
            params.extract!(:page)
        end
    end

    def set_global_params
        $global_params = params 
    end

end

