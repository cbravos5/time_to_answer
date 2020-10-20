class ApplicationController < ActionController::Base
    layout :layout_by_resource

    private

    def layout_by_resource
        devise_controller? ? get_layout : "application" 
    end

    def get_layout
        "#{resource_class.to_s.downcase}_devise"
    end

end

