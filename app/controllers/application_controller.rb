class ApplicationController < ActionController::Base
  def index
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    @markdown_content = markdown.render(File.open(Rails.root + 'README.md', 'r').read)
  end
end
