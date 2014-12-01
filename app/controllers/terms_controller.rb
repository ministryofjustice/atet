class TermsController < MarkdownController
  add_markdown_path   Rails.root.join(*%w<app views terms markdown>)
  add_markdown_files  %w<general applicable_law applicable_law_responsible_use privacy_policy privacy_policy_personal_information privacy_policy_non_personal_information privacy_policy_data_storage online_payment session_management data_protection disclaimer cookies>
end
