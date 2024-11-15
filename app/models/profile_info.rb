# frozen_string_literal: true

ProfileInfo = Data.define(:display_name,
                          :birth_date,
                          :genders,
                          :orientations,
                          :age,
                          :profile_picture,
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
                          :religion_importance) do
  # TODO: remove default later, these are here to make it easier to create new profile page
  def initialize(display_name:,
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
                 pronouns: "She/Her",
                 age: nil,
                 profile_picture: "https://picsum.photos/id/433/256/256")
    if birth_date
      birth_date = Date.parse(birth_date) if birth_date.is_a? String
      age ||= begin
        now = Time.now.utc.to_date
        extra_year_or_not = 1
        extra_year_or_not = 0 if now.month > birth_date.month || (now.month == birth_date.month && now.day >= birth_date.day)
        now.year - birth_date.year - extra_year_or_not
      end
    end
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
