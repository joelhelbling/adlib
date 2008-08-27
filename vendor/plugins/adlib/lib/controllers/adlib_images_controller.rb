class AdlibImagesController < ActionController::Base

  append_view_path File.expand_path(File.dirname(__FILE__) + '/../views') 

  def show
    image = AdlibImage.find(params[:id].to_i)
    
    if params[:layout]
      image_content = apply_layouts_to(image.content)    
    else
      image_content = image.content
    end
    
    send_data image_content, :disposition => 'inline', :type => image.content_type
  rescue ActiveRecord::RecordNotFound
    send_file File.expand_path(File.dirname(__FILE__) + '/../../public/images/image_not_found.gif'),
              :disposition => 'inline', :type => 'image/gif'
  end

  protected
  
  def apply_layouts_to(image_content)
      image_layouts_path = File.expand_path(File.dirname(__FILE__) + "/../views/adlib_images/layouts")
      img = Magick::Image.from_blob(image_content).first
      params[:layout].split(',').each do |format|
        formatting_instructions = File.read("#{image_layouts_path}/#{format}.rb")
        eval formatting_instructions
      end
      img.to_blob
  end

end
