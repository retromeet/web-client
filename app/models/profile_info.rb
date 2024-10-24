# frozen_string_literal: true

ABOUT_ME_TEXT = "I'm very much into computers. I spend most of my time jacked into the ship's computers using my neuro-port. I really am not that much into humans, but I'm hoping that maybe I can find someone that's into the same things that I am and we can maybe spend time in virtual.

I also make a mean carbonara, but most of the time I just live off Soylent Green, it has a distinct flavor that really pleases me."
ProfileInfo = Data.define(:display_name,
                          :birth_date,
                          :genders,
                          :orientations,
                          :age,
                          :profile_picture,
                          :location,
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
  def initialize(display_name: "Lommie Thorne",
                 birth_date: Date.new(2083, 6, 12),
                 genders: %i[genderfluid questioning],
                 orientations: %i[asexual bisexual],
                 age: nil,
                 profile_picture: "https://picsum.photos/id/433/256/256",
                 location: "Nightflyer, Space",
                 about_me: ABOUT_ME_TEXT,
                 pronouns: "She/Her",
                 languages: %i[por eng qaa],
                 relationship_status: :single,
                 relationship_type: :non_monogamous,
                 tobacco: :never,
                 alcohol: :often,
                 marijuana: :sometimes,
                 other_recreational_drugs: :sometimes,
                 pets: :have,
                 wants_pets: :do_not_want_more,
                 kids: :have_not,
                 wants_kids: :dont_know,
                 religion: :atheism,
                 religion_importance: :important)
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
end
