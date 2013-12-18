class Room < ActiveRecord::Base

	has_many :line_items
	
	before_destroy :ensure_not_referenced_by_any_line_item
	
	validates :title, :roomtype, :description, :image_url, presence: true
	validates :price, numericality: {greater_that_or_equal_to: 500.0}
	validates :quantity, numericality: {greater_than_or_equal_to: 0}
	validates :image_url, allow_blank: true, format: {
		with: /\.(gif|jpg|jpeg|png)\z/i,
		message: ': Must be a URL for GIF, JPEG, JPG or PNG image'
	}
	
	private
	
	def ensure_not_referenced_by_any_line_item
		if line_items.empty?
			return true
		else
			errors.add(:base, 'Line items exists')
			return false
		end
	end
	
end
