class AppetizrDbModel < ApplicationRecord
  self.abstract_class = true
  establish_connection :default
end
