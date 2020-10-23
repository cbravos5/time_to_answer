prawn_document do |pdf|
  pdf.text 'Subjects', :align => :center
  pdf.move_down 20
  pdf.table @subjects.collect{|p| [p.id,p.description]}, :position => :center
end