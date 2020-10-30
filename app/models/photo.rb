class Photo < ApplicationRecord
  belongs_to :space

  has_attached_file :image, styles: { cover: "1600x1100#", tile: "600x400#", medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

end
