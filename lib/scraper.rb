require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []

    doc = Nokogiri::HTML(open(index_url))
    
    doc.css(".roster-cards-container div.student-card").each_with_index do |student, index|
      students[index] = {
        :name => student.css("h4").text,
        :location => student.css("p.student-location").text,
        :profile_url => "./fixtures/student-site/" + student.css("a").attribute("href").value
      }
    end

    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    
    student = {
      :profile_quote => doc.css("div.vitals-text-container .profile-quote").text,
      :bio => doc.css("div.bio-content .description-holder").text.strip
    }

    doc.css(".social-icon-container a").each do |link|
      if link.attribute("href").value.include? "twitter"
        student[:twitter] = link.attribute("href").value
      elsif link.attribute("href").value.include? "linkedin"
        student[:linkedin] = link.attribute("href").value
      elsif link.attribute("href").value.include? "github"
        student[:github] = link.attribute("href").value
      else
        student[:blog] = link.attribute("href").value
      end
    end

    student
  end

end

