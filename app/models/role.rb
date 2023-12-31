class Role < ApplicationRecord
  NAME = ['Admin', 'Manager']
  validates :name, uniqueness: true
  has_and_belongs_to_many :admins, :join_table => :admins_roles
  
  belongs_to :resource,
             :polymorphic => true,
             :optional => true
  

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify
end
