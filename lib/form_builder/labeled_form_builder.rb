module FormBuilder
  class LabeledFormBuilder < ActionView::Helpers::FormBuilder
    def label_for(field, label = nil)
      label_text = label.blank? ? field.to_s.humanize : label
      %Q(<label for="#{object_name}_#{field}">#{label_text}</label>)
    end

    %W(
      check_box radio_button
    ).each do |form_tag_helper|
      form_tag_helper_with_label = <<-CODE
      #   Set a custom label by passing :label as an option.
      #
      #   <% form_for @model do |f| %>
      #     <%= f.#{form_tag_helper} :name, :label => "Your name" %>
      #     ...
      #   <% end %>
      #
      def #{form_tag_helper}_with_label(field, *args)
        options = args.first.kind_of?(Hash) ? args.shift : {}
        label = options.delete(:label)
        args.unshift options
        %Q(<div class="#{form_tag_helper}">\#{#{form_tag_helper}_without_label(field, *args)}\#{label_for(field, label)}</div>)
      end
      alias_method_chain :#{form_tag_helper}, :label
      CODE
      class_eval form_tag_helper_with_label, __FILE__, __LINE__
    end

    %W(
      collection_select date_select datetime_select file_field
      password_field select text_area text_field time_select time_zone_select
    ).each do |form_tag_helper|
      form_tag_helper_with_label = <<-CODE
      #   Set a custom label by passing :label as an option.
      #
      #   <% form_for @model do |f| %>
      #     <%= f.#{form_tag_helper} :name, :label => "Your name" %>
      #     ...
      #   <% end %>
      #
      def #{form_tag_helper}_with_label(field, *args)
        options = args.first.kind_of?(Hash) ? args.shift : {}
        label = options.delete(:label)
        args.unshift options
        %Q(<div class="#{form_tag_helper}">\#{label_for(field, label)}\#{#{form_tag_helper}_without_label(field, *args)}</div>)
      end
      alias_method_chain :#{form_tag_helper}, :label
      CODE
      class_eval form_tag_helper_with_label, __FILE__, __LINE__
    end

    def submit_tag
      %Q(<input type="submit" value="Save" />)
    end
  end
end