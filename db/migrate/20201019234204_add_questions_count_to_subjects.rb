class AddQuestionsCountToSubjects < ActiveRecord::Migration[5.2]
  def change
    add_column :subjects, :questions_count, :string
    add_column :subjects, :integer, :string
  end
end
