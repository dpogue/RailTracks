module ApplicationHelper
  def inline_svg(path)
    File.open(asset_file_path!(path)).read.gsub(/\r?\n/, '').gsub(/ ( )+/, '').html_safe
  end
end
