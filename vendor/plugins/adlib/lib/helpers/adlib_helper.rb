module AdlibHelper
  
  def adlib_user
    @adlib_user ||= AdlibUser.find_by_id(session[:adlib_user_id])
  end
  
  def adlib_snippet(slot, options = {})
    page = options[:page] || @page
    richtext = options[:richtext].nil? ? true : options[:richtext]
    
    page, snippet = find_adlib_page_and_snippet_by_self_or_ancestor_page_and_slot(page, slot, options[:inherit])

    content = snippet ? snippet.content : snippet_placeholder_text
    content = h(content) unless richtext
    
    if adlib_user
      snippet_edit_wrapper(content, richtext, page, snippet, slot)
    else
      content
    end
  end
  
  def adlib_image(slot, options = {})
    page = options[:page] || @page
    layout = extract_layout(options)

    page, image_id = find_adlib_page_and_image_id_by_self_or_ancestor_page_and_slot(page, slot, options[:inherit])

    path_args = [page.id, image_id || 0]
    path_args << layout if layout
    content = tag(:img, { :src => adlib_page_adlib_image_path(*path_args), :alt => slot.to_s.humanize }, false, false)

    if adlib_user
      image_edit_wrapper(content, image_id, path_args, slot)
    else
      content
    end
  end
  
  private

  def find_adlib_page_and_snippet_by_ancestor_page_and_slot(page, slot)
    snippet = nil
    while !snippet and page = page.parent
      snippet = AdlibSnippet.find_by_page_id_and_slot(page.id, slot)
    end
    [page, snippet]
  end

  def find_adlib_page_and_snippet_by_self_or_ancestor_page_and_slot(page, slot, inherit)
    snippet = AdlibSnippet.find_by_page_id_and_slot(page.id, slot)
    if !snippet and inherit
      find_adlib_page_and_snippet_by_ancestor_page_and_slot(page, slot)
    else
      [page, snippet]
    end
  end  

  def snippet_placeholder_text
    "Lorem ipsum dolor sit amet, consectetur adipisicing elit, " +
    "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
  end

  def find_adlib_image_id_by_page_and_slot(page, slot)
    image = AdlibImage.find(:first, :select => 'id', :conditions => { :page_id => page.id, :slot => slot })
    image ? image.id : nil
  end
  
  def find_adlib_page_and_image_id_by_ancestor_page_and_slot(page, slot)
    image_id = nil
    while !image_id and page = page.parent
      image_id = find_adlib_image_id_by_page_and_slot(page, slot)
    end 
    [page, image_id]
  end
  
  def find_adlib_page_and_image_id_by_self_or_ancestor_page_and_slot(page, slot, inherit)
    image_id = find_adlib_image_id_by_page_and_slot(page, slot)
    if !image_id and inherit
      find_adlib_page_and_image_id_by_ancestor_page_and_slot(page, slot)
    else
      [page, image_id]
    end
  end
  
  def extract_layout(options)
    options[:layout] && options.except(:page, :inherit).update(:layout => options[:layout].join(','))  
  end
  
  def image_edit_wrapper(content, image_id, path_args, slot)
    content = content_tag(:span, 'EDIT', :class => 'adlib-edit') + content
    if image_id
      href = edit_adlib_page_adlib_image_path(*path_args)
    else
      path_args.delete_at 1
      path_args << { :slot => slot }
      href = new_adlib_page_adlib_image_path(*path_args)
    end
    content = link_to(content, href, :class => 'adlib-image')
  end

  def snippet_edit_wrapper(content, richtext, page, snippet, slot)
    encoding = richtext ? 'richtext' : 'plaintext'
    content = content_tag(:span, 'EDIT', :class => 'adlib-edit') + content
    if snippet
      href = edit_adlib_page_adlib_snippet_path(page.id, snippet.id, :encoding => encoding)
    else
      href = new_adlib_page_adlib_snippet_path(page.id, :slot => slot, :encoding => encoding)
    end
    content = link_to(content, href, :class => "adlib-#{encoding}")
  end
  
end
