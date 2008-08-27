class AdlibImage < ActiveRecord::Base
  belongs_to :page, :class_name => 'AdlibPage'
  
  validates_presence_of :page, :slot
  validates_length_of :slot, :maximum => 50, :allow_blank => true
  validates_format_of :slot, :with => /^\w*$/
  validates_uniqueness_of :slot, :scope => :page_id
  
  validates_numericality_of :size, :integer_only => true, :greater_than_or_equal_to => 0
  validates_numericality_of :width, :integer_only => true, :greater_than_or_equal_to => 0
  validates_numericality_of :height, :integer_only => true, :greater_than_or_equal_to => 0
end