module ApplicationHelper
  include Pagy::Frontend

  # Generates button tags for Turbo disable with
  # Preserve opacity-25 opacity-75 during purge
  def button_text(text = nil, disable_with: t("processing"), &block)
    text = capture(&block) if block

    tag.span(text, class: "when-enabled") +
      tag.span(class: "when-disabled") do
        render_svg("icons/spinner", styles: "animate-spin inline-block h-4 w-4 mr-2") + disable_with
      end
  end

  def disable_with(text)
    "<i class=\"far fa-spinner-third fa-spin\"></i> #{text}".html_safe
  end

  def render_svg(name, options = {})
    options[:title] ||= name.underscore.humanize
    options[:aria] = true
    options[:nocomment] = true
    options[:class] = options.fetch(:styles, "fill-current text-gray-500")

    filename = "#{name}.svg"
    inline_svg_tag(filename, options)
  end

  # fa_icon "thumbs-up", weight: "fa-solid"
  # <i class="fa-solid fa-thumbs-up"></i>
  def fa_icon(name, options = {})
    weight = options.delete(:weight) || "fa-regular"
    options[:class] = [weight, "fa-#{name}", options.delete(:class)]
    tag.i(nil, **options)
  end

  def badge(text, options = {})
    base = options.delete(:base) || "rounded py-0.5 px-2 text-xs inline-block font-semibold leading-normal mr-2"
    color = options.delete(:color) || "bg-gray-100 text-gray-800"
    options[:class] = Array.wrap(options[:class]) + [base, color]
    tag.div(text, **options)
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def viewport_meta_tag(content: "width=device-width, initial-scale=1", turbo_native: "maximum-scale=1.0, user-scalable=0")
    full_content = [content, (turbo_native if turbo_native_app?)].compact.join(", ")
    tag.meta name: "viewport", content: full_content
  end

  def first_page?
    @pagy.page == 1
  end

  def yes_no(a_boolean)
    a_boolean ? "yes" : "no"
  end

  def sidenav_highlight?(controller_name)
    if controller_name == controller.controller_name
      highlighted
    else
      unhighlighted
    end
  end

  def sidenav_highlight_icon?(controller_name)
    if controller_name == controller.controller_name
      highlighted_icon
    else
      unhighlighted_icon
    end
  end

  def dashboard_highlight?
    if current_page?(root_path)
      highlighted
    else
      unhighlighted
    end
  end

  def dashboard_highlight_icon?
    if current_page?(root_path)
      highlighted_icon
    else
      unhighlighted_icon
    end
  end

  def system_admin_highlight?
    if controller_name == "sites" || controller_name == "requestor" || controller_name == "interpreter"
      highlighted
    else
      unhighlighted
    end
  end

  def system_admin_highlight_icon?
    if controller_name == "sites" || controller_name == "requestor" || controller_name == "interpreter"
      highlighted_icon
    else
      unhighlighted_icon
    end
  end

  def highlighted
    "bg-gray-100 text-gray-900"
  end

  def highlighted_icon
    "text-gray-9"
  end

  def unhighlighted
    "text-gray-100 hover:bg-gray-50 hover:text-gray-900"
  end

  def unhighlighted_icon
    "text-gray-100 group-hover:text-gray-500"
  end
end
