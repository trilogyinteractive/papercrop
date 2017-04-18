require "paperclip"

module Paperclip
  class Papercrop < Thumbnail

    def transformation_command
      if crop_command
        crop_command + super.join(' ').sub(/ -crop \S+/, '').split(' ')
      else
        super
      end
    end


    def crop_command
      target = @attachment.instance

      if target.cropping?(@attachment.name)
        ::Papercrop.log("crop_w: #{Integer(target.send :"#{@attachment.name}_crop_w")}")
        ::Papercrop.log("crop_h: #{Integer(target.send :"#{@attachment.name}_crop_h")}")
        ::Papercrop.log("crop_x: #{Integer(target.send :"#{@attachment.name}_crop_x")}")
        ::Papercrop.log("crop_y: #{Integer(target.send :"#{@attachment.name}_crop_y")}")
        ::Papercrop.log("resized_h: #{Integer(target.send :"#{@attachment.name}_resized_h")}")
        ::Papercrop.log("resized_w: #{Integer(target.send :"#{@attachment.name}_resized_w")}")

        begin
          cropW = Integer(target.send :"#{@attachment.name}_crop_w")
          cropH = Integer(target.send :"#{@attachment.name}_crop_h")

          cropX = Integer(target.send :"#{@attachment.name}_crop_x")
          cropY = Integer(target.send :"#{@attachment.name}_crop_y")

          sizeX = Integer(target.send :"#{@attachment.name}_resized_h")
          sizeY = Integer(target.send :"#{@attachment.name}_resized_w")
          [
            "-resize", "#{sizeX}x#{sizeY}",
            "-crop",   "#{cropW}x#{cropH}+#{cropX}+#{cropY}"
          ]
        rescue Exception => e
          ::Papercrop.log("[papercrop] #{@attachment.name} crop w/h/x/y were non-integer. Error: #{e.to_s}")
          return 
        end
      end
    end

  end
end