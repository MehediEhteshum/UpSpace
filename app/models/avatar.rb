class Avatar < ApplicationRecord
    belongs_to :user, optional: true 

    #Mounts paperclip image
    has_attached_file :image, styles: { medium: "350x350>", thumb: "100x100#" } 

    #Validates file, file type and file size
    validates_attachment :image, presence: true,
    content_type: { content_type: /\Aimage\/.*\z/ },
    size: { in: 0..3.megabytes }
end
