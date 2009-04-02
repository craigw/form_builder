module FormBuilder
  module FormHelper
    def labeled_form_for(record_or_name_or_array, *args, &block)
      options = args.extract_options!
      form_for(record_or_name_or_array, *(args << options.merge(:builder => LabeledFormBuilder)), &block)
    end
  end
end