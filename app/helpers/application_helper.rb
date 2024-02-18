module ApplicationHelper
    def active_link_to(name = nil, options = nil, html_options = nil, &block)
        active_class = html_options[:active] || "active"
        html_options.delete(:active)
        logger.info(current_page?(options, check_parameters: true))
        html_options[:class] = "#{html_options[:class]} #{active_class}" if current_page?(options, check_parameters: true)
        link_to(name, options, html_options, &block)
      end
end
