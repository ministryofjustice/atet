module SimpleForm
  module Inputs
    class CollectionInput < Base
      def translate_collection
        if translated_collection = translate_from_namespace(:options)
          @collection = collection.map do |key|
            html_key = "#{key}_html".to_sym
            if translated_collection[html_key]
              [translated_collection[html_key].html_safe || key, key.to_s]
            else
              [translated_collection[key.to_sym] || key, key.to_s]
            end
          end
          true
        end
      end

      def detect_common_display_methods(collection_classes = detect_collection_classes)
        collection_translated = translate_collection if collection_classes.all? { |c| c == Symbol || c == String }

        if collection_translated || collection_classes.include?(Array)
          { label: :first, value: :second }
        elsif collection_includes_basic_objects?(collection_classes)
          { label: :to_s, value: :to_s }
        else
          detect_method_from_class(collection_classes)
        end
      end
    end
  end
end
