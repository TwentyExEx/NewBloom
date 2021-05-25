# Using mkxp-z v2.2.0 - https://gitlab.com/mkxp-z/mkxp-z/-/releases/v2.2.0
$VERBOSE = nil
Font.default_shadow = false if Font.respond_to?(:default_shadow)
Graphics.frame_rate = 40

def pbSetWindowText(string)
  System.set_window_title(string || System.game_title)
end

class Bitmap
  alias mkxp_draw_text draw_text unless method_defined?(:mkxp_draw_text)

  def draw_text(x, y, width, height, text, align = 0)
    height = text_size(text).height
    mkxp_draw_text(x, y, width, height, text, align)
  end
end

module Graphics
  def self.delta_s
    return self.delta.to_f / 1_000_000
  end

    def saveToPng(filename)
    bytes=[
       0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A,0x00,0x00,0x00,0x0D
    ].pack("CCCCCCCCCCCC")
    ihdr=[
       0x49,0x48,0x44,0x52,swap32(self.width),swap32(self.height),
       0x08,0x06,0x00,0x00,0x00
    ].pack("CCCCVVCCCCC")
    crc=Zlib::crc32(ihdr)
    ihdr+=[swap32(crc)].pack("V")
    bytesPerScan=self.width*4
    row=(self.height-1)*bytesPerScan
    data=self.getData
    data2=data.clone
    x=""
    len=bytesPerScan*self.height
    ttt=Time.now
    if SwapRgb
      SwapRgb.call(data2,data2.length)
    else
      # the following is considerably slower
      b=0; c=2
      while b!=len
        data2[b]=data[c]
        data2[c]=data[b]
        b+=4; c+=4;
      end
    end
#    $times.push(Time.now-ttt)
    filter="\0"
    while row>=0
      thisRow=data2[row,bytesPerScan]
      x.concat(filter)
      x.concat(thisRow)
      row-=bytesPerScan
    end
    x=Zlib::Deflate.deflate(x)
    length=x.length
    x="IDAT"+x
    crc=Zlib::crc32(x)
    idat=[swap32(length)].pack("V")
    idat.concat(x)
    idat.concat([swap32(crc)].pack("V"))
    idat.concat([0,0x49,0x45,0x4E,0x44,0xAE,0x42,0x60,0x82].pack("VCCCCCCCC"))
    File.open(filename,"wb") { |f|
      f.write(bytes)
      f.write(ihdr)
      f.write(idat)
    }
  end
end

def pbSetResizeFactor(factor)
  if !$ResizeInitialized
    Graphics.resize_screen(Settings::SCREEN_WIDTH, Settings::SCREEN_HEIGHT)
    $ResizeInitialized = true
  end
  if factor < 0 || factor == 4
    Graphics.fullscreen = true if !Graphics.fullscreen
  else
    Graphics.fullscreen = false if Graphics.fullscreen
    Graphics.scale = (factor + 1) * 0.5
    Graphics.center
  end
end
