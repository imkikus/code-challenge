class Company < ApplicationRecord
  has_rich_text :description
  validates :email, format: { with: /\@getmainstreet\.com/, message: 'of the company should be of <example@getmainstreet.com>'}, uniqueness: true, allow_blank: true, on: :create #validated only on create as the problem statement says for new companies, on: :create exclusion validates for both create & edit
  validates :zip_code, length: {is: 5}
  validate :valid_zip_code?
  before_save :update_city_state, if: -> { zip_code_changed? }

  private

  def update_city_state
    zip_code = ZipCodes.identify(self.zip_code)
    self.city = zip_code[:city]
    self.state = zip_code[:state_name]
  end

  def valid_zip_code?
    return if ZipCodes.identify(self.zip_code)
    errors.add(:zip_code, I18n.t('error.invalid_zipcode'))
  end
end
