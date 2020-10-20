namespace :dev do
  
  DEFAULT_PASSWORD = 123456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc "Clear the db an fill it with seeds"
  task setup: :environment do
    if Rails.env.development?
      success_spinner("Cleaning db") {%x(rails db:drop:_unsafe)}
      success_spinner("Creating db") {%x(rails db:create)}
      success_spinner("Migrating db") {%x(rails db:migrate)}
      success_spinner("Getting default administrator") {%x(rails dev:add_admin)}
      success_spinner("Getting extra administrators") {%x(rails dev:add_admin_extra)}
      success_spinner("Getting default user") {%x(rails dev:add_user)}
      success_spinner("Getting default subjects...") {%x(rails dev:add_subjects)}
      success_spinner("Getting default questions...") {%x(rails dev:add_questions)}
    else
      puts "Invalid task during non-dev enviroment"
    end
  end

  desc "Add default Admin"
  task add_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Add Another admins"
  task add_admin_extra: :environment do
    10.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc "Add default User"
  task add_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Add default subjects"
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc "Add default questions"
  task add_questions: :environment do
    Subject.all.each do |subject|
      rand(5..10).times do |i|
        params = create_params(subject)
        
        rand(2..5).times do |j|
          get_answers_attr(params).push({description: Faker::Lorem.sentence, correct: false})
        end

        choice = rand(get_answers_attr(params).size)
        get_answers_attr(params)[choice][:correct] = true

        Question.create!(params[:question])
      end
    end
  end

  desc "Reset subjects counter"
  task reset_subjects_counter: :environment do
    success_spinner("Reseting subjects counter...") do 
      Subject.all.each do |subject|
        Subject.reset_counters(subject.id, :questions)
      end
    end
  end



  private

  def success_spinner(spin_text)
    spinner = TTY::Spinner.new("[:spinner] #{spin_text}")
    spinner.auto_spin
    yield
    spinner.success('(successful)')
  end

  def create_params(subject)
    { question: {
          description: "#{Faker::Lorem.paragraph}?",
          subject: subject, 
          answers_attributes: []
      }
    }
  end

  def get_answers_attr(params)
    params[:question][:answers_attributes]
  end
end
