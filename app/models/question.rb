class Question < ApplicationRecord
  belongs_to :subject, counter_cache: true, inverse_of: :questions
  has_many :answers
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: :true

  scope :_search_, ->(term, page){
    includes(:answers, :subject)
    .order('created_at desc')
    .where("lower(description) LIKE ?", "%#{term.downcase}%")
    .page(page)
  }

  scope :last_questions, ->(page){
    includes(:subject)
    .order('created_at desc')
    .page(page).per(25)
  }

  scope :_search_subject_, ->(term, subject_id, page){
    includes(:answers, :subject)
    .order('created_at desc')
    .where(subject_id: subject_id)
    .page(page)
  }

end
