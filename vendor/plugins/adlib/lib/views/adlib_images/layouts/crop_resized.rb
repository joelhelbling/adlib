w = params[:width]  || 100
h = params[:height] || 100
img.crop_resized!(w.to_i, h.to_i)