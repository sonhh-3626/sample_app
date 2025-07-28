module RelationshipsHelper
  def get_followed_relationship_with user
    current_user.active_relationships.find_by followed_id: user
  end
end
