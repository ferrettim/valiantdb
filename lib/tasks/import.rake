namespace :import do

	desc "Import books from CSV"
	task books: :environment do
		filename = File.join Rails.root, "books.csv"
		counter = 0
		CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
			p row
			book = Book.assign_from_row(row)
			if book.save
				counter += 1
			else
				puts "#{book.title} #{book.issue} by #{book.cover} - #{book.errors.full_messages.join(",")}"
			end
		end
		puts "Imported #{counter} books."
	end
end