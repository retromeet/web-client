# frozen_string_literal: true

ProfileInfo = Data.define(:display_name, :birth_date, :genders, :orientations, :age, :profile_picture) do
  # TODO: remove default later, these are here to make it easier to create new profile page
  def initialize(display_name: "Lommie Thorne", birth_date: Date.new(2083, 6, 12), genders: %i[genderfluid questioning], orientations: %i[asexual bisexual], age: nil, profile_picture: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fvignette.wikia.nocookie.net%2Fnightflyers8841%2Fimages%2F3%2F35%2FLommie_Profile_Image.jpg%2Frevision%2Flatest%3Fcb%3D20181127123914&f=1&nofb=1&ipt=77a78fb901bd3c8c0a52d4797b5535c097c153458aea337cdcaf63c62acba7b9&ipo=images")
    age ||= begin
      now = Time.now.utc.to_date
      extra_year_or_not = 0
      extra_year_or_not = 1 if now.month > birth_date.month || (now.month == birth_date.month && now.day >= birth_date.day)
      now.year - birth_date.year - extra_year_or_not
    end
    super
  end
end
