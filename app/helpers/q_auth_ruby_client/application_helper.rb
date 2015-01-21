module QAuthRubyClient
  module ApplicationHelper
    ## Returns new photo url or edit existing photo url based on
    #  object is associated with photo or not
    # == Examples
    #   >>> upload_image_link(@user, admin_user_path(@user), :profile_picture)
    #   => "/admin/images/new" OR
    #   => "/admin/images/1/edit"
    def upload_image_link(object, redirect_url, assoc_name=:photo)
      photo_object = nil
      photo_object =  object.send(assoc_name) if object.respond_to?(assoc_name)

      if photo_object.present? && photo_object.persisted?
        edit_admin_image_path(photo_object,
                                   :redirect_url => redirect_url,
                                   :imageable_id => object.id,
                                   :imageable_type => object.class.to_s,
                                   :image_type => photo_object.class.name)
      else
        photo_object = object.send("build_#{assoc_name}")
        new_admin_image_path(:redirect_url => redirect_url,
                                   :imageable_id => object.id,
                                   :imageable_type => object.class.to_s,
                                   :image_type => photo_object.class.name)
      end
    end
  end
end
