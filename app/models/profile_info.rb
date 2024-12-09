# frozen_string_literal: true

ProfileInfo = Data.define(:id,
                          :display_name,
                          :birth_date,
                          :genders,
                          :orientations,
                          :age,
                          :picture,
                          :location_display_name,
                          :about_me,
                          :pronouns,
                          :languages,
                          :relationship_status,
                          :relationship_type,
                          :tobacco,
                          :alcohol,
                          :marijuana,
                          :other_recreational_drugs,
                          :kids,
                          :wants_kids,
                          :pets,
                          :wants_pets,
                          :religion,
                          :religion_importance,
                          :hide_age) do
  # TODO: remove default later, these are here to make it easier to create new profile page
  def initialize(id:,
                 display_name:,
                 birth_date:,
                 genders:,
                 orientations:,
                 location_display_name:,
                 about_me:,
                 languages:,
                 relationship_status:,
                 relationship_type:,
                 tobacco:,
                 alcohol:,
                 marijuana:,
                 other_recreational_drugs:,
                 pets:,
                 wants_pets:,
                 kids:,
                 wants_kids:,
                 religion:,
                 religion_importance:,
                 hide_age:,
                 pronouns: "She/Her",
                 age: nil,
                 picture: "/no_avatar.svg")
    super
  end

  # This is a little trick to use this model as a Rails model in the view.
  # @return [TrueClass]
  def persisted?
    true
  end

  # @param user_language [Symbol,nil]
  # @return [String]
  def location(user_language: nil)
    return nil if location_display_name.nil?

    location_display_name[user_language] || location_display_name[:en]
  end
end
