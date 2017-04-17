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