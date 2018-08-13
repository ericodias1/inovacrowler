require 'open-uri'
module QuoteCrawler
  class << self
    attr_accessor :search, :doc, :term
    def search_crawler(term)
      @term = term
      @search = Search.find_or_initialize_by term: @term
      unless @search.persisted?
        populate_quotes
      end
      @search.quotes
    end

    def populate_quotes
      url = "http://quotes.toscrape.com/tag/#{term}/"
      @doc = Nokogiri::HTML(open(url))
      create_quotes
    end

    def create_quotes
      @doc.css('.quote').each do |doc_quote|
        author_about_url = "http://quotes.toscrape.com#{doc_quote.css('a:contains("(about)")').first['href']}"
        author_about_doc = Nokogiri::HTML(open(author_about_url))
        quote = Quote.create extract_quote_attr(doc_quote, author_about_doc)
      end
    end

    def extract_quote_attr(quote, author_about)
      {
        quote: quote.css('.text').text[1..-2],
        author: quote.css('.author').text,
        tags: quote.css('.tags .tag').collect(&:text),
        author_about: CGI::unescapeHTML(author_about.css('.author-description').text.strip),
        search: @search
      }
    end
  end
end
