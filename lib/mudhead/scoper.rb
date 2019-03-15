module Mudhead
  class Scoper

    def initialize scoper
      @scoper = scoper
    end

    def routes
      @routes ||= all_routes.select do |_ctrl, _action, _name|
        _name.starts_with?("#{scoper}")
      end.map do |ctrl, action, name|
        {
          :controller => ctrl,
          :action => action,
          :name => name
        }
      end
    end

    private
    attr_reader :scoper

    def all_routes
      scope_routes = Rails.application.routes.routes.map do |route|
        route.defaults.values_at(:controller, :action).map(&:to_s).push(route.name) if route.name.present?
      end.uniq
      scope_routes.compact
    end
  end
end