module ApplicationHelper
  ALERT_TYPES = [:success, :info, :warning, :danger] unless const_defined?(:ALERT_TYPES)

  def active_link_to(name = nil, options = nil, html_options = nil, &block)
      active_class = html_options[:active] || "active"
      html_options.delete(:active)
      logger.info(current_page?(options, check_parameters: true))
      html_options[:class] = "#{html_options[:class]} #{active_class}" if current_page?(options, check_parameters: true)
      link_to(name, options, html_options, &block)
  end

  def bootstrap_flash(options = {})
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = type.to_sym
      type = :success if type == :notice
      type = :danger  if type == :alert
      type = :danger  if type == :error
      next unless ALERT_TYPES.include?(type)

      tag_class = options.extract!(:class)[:class]
      tag_options = {
        class: "alert fade in alert-#{type} #{tag_class}"
      }.merge(options)

      # close_button = content_tag(:button, raw("&times;"), type: "button", class: "btn-close", "data-bs-dismiss" => "alert")
      close_button = content_tag(:button, raw(""), type: "button", class: "btn-close", "data-bs-dismiss" => "alert")

      Array(message).each do |msg|
        text = content_tag(:div, close_button + msg.html_safe, tag_options)
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

end
