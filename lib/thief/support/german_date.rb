# encoding: utf-8
require 'date'

class GermanDate < Date
  TRANSLATIONS = { "Januar"   => "January",
                   "Februar"  => "February",
                   "März"     => "March",
                   "April"    => "April",
                   "Mai"      => "May",
                   "Juni"     => "June",
                   "Juli"     => "July",
                   "August"   => "August",
                   "September"=> "September",
                   "Oktober"  => "October",
                   "November" => "November",
                   "Dezember" => "December" }

  def self.parse(date_string, *args)
    if date_string =~ Regexp.new(TRANSLATIONS.keys.join('|'))
      german_month = Regexp.last_match.to_s
      date_string.gsub!(german_month, TRANSLATIONS[german_month])
    end
    super(date_string, args)
  end
end