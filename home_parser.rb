require 'cgi'

tab_page_directories = Dir.glob("../home/*").select { |file| File.directory?(file) }

def generate_template_index(base_home_directory, search_title, background_images)
    Dir.mkdir(base_home_directory) unless Dir.exist?(base_home_directory)

    template_index_contents = "<?php
$title = \"#{search_title}\";

// NewTabGallery: Edit these to change the rendered background images
$background_image_count = #{background_images.count};
$background_image_style = \"
<style>"

    background_images.each_with_index do |background_image, index|
        template_index_contents += "
  header.masthead.background-#{index + 1} {
    background-image: url('https://home.newtabgallery.com/#{base_home_directory}/#{(background_image.split('/').last).gsub(" ", "%20")}')
  }
"
    end
    
    template_index_contents += "</style>
\";

include('../template/index.php');
?>"
    
    File.write("#{base_home_directory}/index.php", template_index_contents)
end

directory = tab_page_directories.first
# tab_page_directories.each do |directory|
    base_home_directory = directory.split('/').last
    home_directory_images = Dir.glob("#{directory}/*").select { |file| File.file?(file) && !file.include?("icon") && ( File.extname(".jpg") || File.extname("jpeg") || File.extname("png") || File.extname("gif"))  }
    
    index = File.open("#{directory}/index.php", "r")
    search_title = ''
    index.each_line do |line|
        if line.include?("$title") 
            search_title = line[/\$title = '(.*)';/, 1]
        end
    end


    generate_template_index(base_home_directory, search_title, home_directory_images)
# end
# Dir.pwd

# .split('/').last