class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def generate_msg_scope(action_msg)
    'errors.messages.' + caller[0][/`.*'/][1..-2] + '_' + action_msg
  end
end
