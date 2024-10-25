# frozen_string_literal: true

# This module contain helper functions used in the Profile controller and views
module ProfileHelper
  PREFER_NOT_TO_ANSWER = [I18n.t("prefer_not_to_answer"), nil].freeze
  # @return [Array<List<String,String>>] An array containing the symbols for each frequency and their translations
  def frequency_options
    @frequency_options ||= [PREFER_NOT_TO_ANSWER] + I18n.translate("frequency").map(&:reverse)
  end

  # @return [Array<List<String,String>>] An array containing the symbols for each wants option and their translations
  def wants_options
    @wants_options ||= [PREFER_NOT_TO_ANSWER] + I18n.translate("wants").map(&:reverse)
  end

  # @return [Array<List<String,String>>] An array containing the symbols for each kid option and their translations
  def have_kids_options # rubocop:disable Naming/PredicateName
    @have_kids_options ||= begin
      o = [PREFER_NOT_TO_ANSWER]
      I18n.translate("have_or_have_nots").each_key do |k|
        o << [I18n.translate(k, scope: :have_or_have_nots, this: "kids"), k]
      end
      o
    end
  end

  # @return [Array<List<String,String>>] An array containing the symbols for each pet option and their translations
  def have_pets_options # rubocop:disable Naming/PredicateName
    @have_pets_options ||= begin
      o = [PREFER_NOT_TO_ANSWER]
      I18n.translate("have_or_have_nots").each_key do |k|
        o << [I18n.translate(k, scope: :have_or_have_nots, this: "pets"), k]
      end
      o
    end
  end

  # @return [Array<List<String,String>>] An array containing the symbols for each religion option and their translations
  def religion_options
    @religion_options ||= [PREFER_NOT_TO_ANSWER] + I18n.translate("religion_list").map(&:reverse)
  end

  # @return [Array<List<String,String>>] An array containing the symbols for each importance option and their translations
  def importance_options
    @importance_options ||= [PREFER_NOT_TO_ANSWER] + I18n.translate("importance").map(&:reverse)
  end

  # @return [Array<List<String,String>>] An array containing the symbols for each language option and their translations
  def language_options
    @language_options ||= I18n.translate("languages_known_list").map(&:reverse)
  end

  # @return [Array<List<String,String>>] An array containing the symbols for each gender option and their translations
  def gender_options
    @gender_options ||= I18n.translate("genders").map(&:reverse)
  end

  # @return [Array<List<String,String>>] An array containing the symbols for each orientation option and their translations
  def orientation_options
    @orientation_options ||= I18n.translate("orientations").map(&:reverse)
  end
end
