# frozen_string_literal: true

OtherProfileInfo = Data.define(:id,
                               :display_name,
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
                               :location_distance) do
  def initialize(id:, display_name:, age:, genders:, orientations:, location_display_name:, relationship_status:, location_distance:, about_me: nil, languages: nil, relationship_type: nil, tobacco: nil, alcohol: nil, marijuana: nil, other_recreational_drugs: nil, pets: nil, wants_pets: nil, kids: nil, wants_kids: nil, religion: nil, religion_importance: nil, pronouns: "She/Her", picture: "/no_avatar.svg")
    super
  end

  # @param user_language [Symbol,nil]
  # @return [String]
  def location(user_language: nil)
    return nil if location_display_name.nil?

    location_display_name[user_language] || location_display_name[:en]
  end

  # Returns a user-friendly distance string.
  # Either the requested distance or a very near your string
  # @return [String]
  def distance
    if location_distance < Float::EPSILON
      I18n.t("very_near_you")
    else
      "~#{format("%.1f", location_distance)}km"
    end
  end
end
