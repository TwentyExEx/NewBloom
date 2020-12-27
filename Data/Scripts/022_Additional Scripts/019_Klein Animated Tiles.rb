# See the documentation on the wiki to learn how to edit this file.
#-------------------------------#===============================================================================
# ■ Animated tiles by KleinStudio V1.1
# http://kleinstudio.deviantart.com
#
# *Note that the animated tile will have the same priority and terrain tag that 
#  the tile in the original tileset.
#
#===============================================================================
# General Settings
#===============================================================================
# Tileset id for animated tiles
#===============================================================================
Animate_Tileset_Id=26

#===============================================================================
# Settings for animated scripts
# *How this works
#   KleinTiles[TilesetId].push([tileid,[animatedTilesId])
# ** Example
# - This will replace the tile 22 from Tileset 1 with the
#   tiles 1, 2 and 3 (making the animation) in the animated tileset
# KleinTiles[1].push([22,[1,2,3])
#
# * How to get the tile id 
#    Imagine this is a tileset, tiles id are like this
#    [00][01][02][03][04][05][06][07]
#    [08][09][10][11][12][13][14][15]
#    [16][17][18][19][20][21][22][23]...
#
#   You can use pbMakeNumericTileset(TILESETNAME) for create a new .png
#   in the game's folder with a tileset and a numeric patron.
#
# *Before adding animated tiles to a tileset, you need to initialize it
#  to make that just write this before the tileset tile setting:
#    KleinTiles[TilesetId]=[]
#==============================================================================
KleinTiles=[]

# Initialize the array for tileset 1
KleinTiles[1]=[]
# Water animation
KleinTiles[1].push([136,[0,3,24,27,48,51,72,75]])
KleinTiles[1].push([137,[1,4,25,28,49,52,73,76]])
KleinTiles[1].push([138,[2,5,26,29,50,53,74,77]])
KleinTiles[1].push([144,[8,11,32,35,56,59,80,83]])
KleinTiles[1].push([145,[9,12,33,36,57,60,81,84]])
KleinTiles[1].push([146,[10,13,34,37,58,61,82,85]])
KleinTiles[1].push([152,[16,19,40,43,64,67,88,91]])
KleinTiles[1].push([153,[17,20,41,44,65,68,89,92]])
KleinTiles[1].push([154,[18,21,42,45,66,69,90,93]])
KleinTiles[1].push([139,[96,99,120,123,208,211,232,235]])
KleinTiles[1].push([140,[97,100,121,124,209,212,233,236]])
KleinTiles[1].push([141,[98,101,122,125,210,213,234,237]])
KleinTiles[1].push([147,[104,107,128,131,216,219,240,243]])
KleinTiles[1].push([149,[106,109,130,133,218,221,242,245]])
KleinTiles[1].push([155,[112,115,136,139,224,227,248,251]])
KleinTiles[1].push([156,[113,116,137,140,225,228,249,252]])
KleinTiles[1].push([157,[114,117,138,141,226,229,250,253]])

# Untagged water animation
KleinTiles[1].push([135,[9,12,33,36,57,60,81,84]])
KleinTiles[1].push([143,[9,12,33,36,57,60,81,84]])

# Impassable water animation
KleinTiles[1].push([165,[16,19,40,43,64,67,88,91]])
KleinTiles[1].push([166,[17,20,41,44,65,68,89,92]])
KleinTiles[1].push([167,[18,21,42,45,66,69,90,93]])
KleinTiles[1].push([173,[0,3,24,27,48,51,72,75]])
KleinTiles[1].push([174,[1,4,25,28,49,52,73,76]])
KleinTiles[1].push([175,[2,5,26,29,50,53,74,77]])

# Waterfall animation
KleinTiles[1].push([160,[144,148,176,180]])
KleinTiles[1].push([161,[145,149,177,181]])
KleinTiles[1].push([162,[146,150,178,182]])
KleinTiles[1].push([163,[147,151,179,183]])

KleinTiles[1].push([168,[152,156,184,188]])
KleinTiles[1].push([169,[153,157,185,189]])
KleinTiles[1].push([170,[154,158,186,190]])
KleinTiles[1].push([171,[155,159,187,191]])

KleinTiles[1].push([176,[160,164,192,196]])
KleinTiles[1].push([177,[161,165,193,197]])
KleinTiles[1].push([178,[162,166,194,198]])
KleinTiles[1].push([179,[163,167,195,199]])

KleinTiles[1].push([184,[168,172,200,204]])
KleinTiles[1].push([185,[169,173,201,205]])
KleinTiles[1].push([186,[170,174,202,206]])
KleinTiles[1].push([187,[171,175,203,207]])

class Interpreter
  alias klein_transfer_inter command_201
  def command_201
    $kleinAnimatedInfo.clear if $kleinAnimatedInfo
    $kleinAnimatedInfo=[]
    klein_transfer_inter
  end
end

class CustomTilemapSprite
  attr_accessor :id
  def id
    @id=-1 if !@id
    return @id
  end
end

class TilemapLoader
  alias klein_animate_tl_initialize initialize
  def initialize(viewport)
    @tileset_id=$PokemonGlobal.next_tileset_id
    klein_animate_tl_initialize(viewport)
  end
  
  def setClass(cls)
    if cls==CustomTilemap
      newtilemap=cls.new(@viewport,@tileset_id)
    else
      newtilemap=cls.new(@viewport)
    end
    if @tilemap 
      newtilemap.tileset=@tilemap.tileset
      newtilemap.map_data=@tilemap.map_data
      newtilemap.flash_data=@tilemap.flash_data
      newtilemap.priorities=@tilemap.priorities
      newtilemap.visible=@tilemap.visible
      newtilemap.ox=@tilemap.ox
      newtilemap.oy=@tilemap.oy
      newtilemap.tileset_id=@tileset_id
      for i in 0...7
        newtilemap.autotiles[i]=@tilemap.autotiles[i]
      end
      @tilemap.dispose
      @tilemap=newtilemap
      newtilemap.update if cls!=SynchronizedTilemap
    else
      @tilemap=newtilemap
    end
  end
end

class Game_Map
  def tileset_id
    return @map.tileset_id
  end
end

class PokemonGlobalMetadata
  attr_accessor :next_tileset_id
  def next_tileset_id
    @next_tileset_id=0 if !@next_tileset_id
    return @next_tileset_id
  end
end

class Spriteset_Map
  alias klein_animate_sp_initialize initialize
  def initialize(map=nil)
    if $PokemonGlobal && map!=nil 
      $PokemonGlobal.next_tileset_id=map.tileset_id
    end
    klein_animate_sp_initialize(map)
    $PokemonGlobal.next_tileset_id=0
  end
end

class CustomTilemap
  alias klein_animate_initialize initialize
  def initialize(viewport,tileset_id)
    klein_animate_initialize(viewport)
    @tileset_id=tileset_id
    @kleinTiles=[]
    $kleinAnimatedInfo=[] if !$kleinAnimatedInfo=[] 
    @animateTileset=$data_tilesets[Animate_Tileset_Id]  
    @animateTilesetBitmap=pbGetTileset(@animateTileset.tileset_name)
    @kleinTilesInfo=[]
    tilesetKleinTiles=KleinTiles[@tileset_id]
    if tilesetKleinTiles!=nil
      for kleinTiles in tilesetKleinTiles
        @kleinTilesInfo.push([kleinTiles[0],kleinTiles[1]]) 
      end
    end
  end

  def tileset_id=(value)
    return if @kleinTilesInfo.length!=0
    @tileset_id=value
    @kleinTilesInfo.clear
    tilesetKleinTiles=KleinTiles[@tileset_id]
    if tilesetKleinTiles!=nil
      for kleinTiles in tilesetKleinTiles
        @kleinTilesInfo.push([kleinTiles[0],kleinTiles[1]]) 
      end
    end
  end
  
  alias klein_animate_dispose dispose
  def dispose
    klein_animate_dispose
    i=0;len=@kleinTiles.length;while i<len
      @kleinTiles[i].dispose
      @kleinTiles[i]=nil
      i+=2
    end
    @kleinTiles.clear
  end
  
  def kleinTileFrame(ktb)
   frame=(Graphics.frame_count/Animated_Autotiles_Frames)%ktb.length
   return ktb[frame]
  end

  def refreshLayer0(autotiles=false, onlykleintiles=false)
    if autotiles
      return true if !shown?
    end
    ptX=@ox-@oxLayer0
    ptY=@oy-@oyLayer0
    if !autotiles && !@firsttime && !@usedsprites &&
       ptX>=0 && ptX+@viewport.rect.width<=@layer0.bitmap.width &&
       ptY>=0 && ptY+@viewport.rect.height<=@layer0.bitmap.height
      if @layer0clip && @viewport.ox==0 && @viewport.oy==0
        @layer0.ox=0
        @layer0.oy=0
        @layer0.src_rect.set(ptX.round,ptY.round,
           @viewport.rect.width,@viewport.rect.height)
      else
        @layer0.ox=ptX.round
        @layer0.oy=ptY.round
        @layer0.src_rect.set(0,0,@layer0.bitmap.width,@layer0.bitmap.height)
      end
      return true
    end
    
    width=@layer0.bitmap.width
    height=@layer0.bitmap.height
    bitmap=@layer0.bitmap
    ysize=@map_data.ysize
    xsize=@map_data.xsize
    zsize=@map_data.zsize
    twidth=@tileWidth
    theight=@tileHeight
    mapdata=@map_data

    if autotiles
      return true if @fullyrefreshedautos && @prioautotiles.length==0
      xStart=(@oxLayer0/twidth)
      xStart=0 if xStart<0
      yStart=(@oyLayer0/theight)
      yStart=0 if yStart<0
      xEnd=xStart+(width/twidth)+1
      yEnd=yStart+(height/theight)+1
      xEnd=xsize if xEnd>xsize
      yEnd=ysize if yEnd>ysize
      return true if xStart>=xEnd || yStart>=yEnd
      trans=Color.new(0,0,0,0)
      temprect=Rect.new(0,0,0,0)
      tilerect=Rect.new(0,0,twidth,theight)
      zrange=0...zsize
      overallcount=0
      count=0
      if !@fullyrefreshedautos
        for y in yStart..yEnd
          for x in xStart..xEnd
            haveautotile=false
            for z in zrange
              id = mapdata[x, y, z]
              next if !id || id<48 || id>=384
              prioid=@priorities[id]
              next if prioid!=0 || !prioid
              fcount=@framecount[id/48-1]
              next if !fcount || fcount<2
              
              next if onlykleintiles && !isKleinTile?(id)
              
              if !haveautotile
                haveautotile=true
                overallcount+=1
                xpos=(x*twidth)-@oxLayer0
                ypos=(y*theight)-@oyLayer0
                bitmap.fill_rect(xpos,ypos,twidth,theight,trans) if overallcount<=2000
                break
              end
            end
            for z in zrange
              id = mapdata[x,y,z]
              next if !id || id<48
              prioid=@priorities[id]
              next if prioid!=0 || !prioid
              next if onlykleintiles && !isKleinTile?(id)
              
              if overallcount>2000
                xpos=(x*twidth)-@oxLayer0
                ypos=(y*theight)-@oyLayer0
                
                count=addTile(@autosprites,count,xpos,ypos,id)
                next
              elsif id>=384 && !isKleinTile?(id)
                temprect.set(((id - 384)&7)*@tileSrcWidth,((id - 384)>>3)*@tileSrcHeight,
                   @tileSrcWidth,@tileSrcHeight)
                xpos=(x*twidth)-@oxLayer0
                ypos=(y*theight)-@oyLayer0
                if @diffsizes
                  bitmap.stretch_blt(Rect.new(xpos,ypos,twidth,theight),@tileset,temprect)
                else
                  bitmap.blt(xpos,ypos,@tileset,temprect)
                end
            elsif id>=384 && isKleinTile?(id)
                # Klein tiles
                ktbitmap=nil
                ktbitmap=$kleinAnimatedInfo[id] if $kleinAnimatedInfo[id]!=nil

                if ktbitmap==nil
                  for kleinTiles in @kleinTilesInfo
                    kt=kleinTiles if kleinTiles[0]+384==id
                  end
                  barray=[]
                  for tileids in kt[1]
                    barray.push(kleinTileRects(tileids+384))
                  end
                  $kleinAnimatedInfo[id]=barray
                  ktbitmap=$kleinAnimatedInfo[id]
                end
                
               xpos=(x*twidth)-@oxLayer0
               ypos=(y*theight)-@oyLayer0
               bitmap.fill_rect(xpos,ypos,32,32,Color.new(0,0,0,0)) if z==0
               bitmap.blt(xpos,ypos,@animateTilesetBitmap,kleinTileFrame(ktbitmap))
            elsif id<384
                tilebitmap=@autotileInfo[id]
                
                if !tilebitmap
                  anim=autotileFrame(id)
                  next if anim<0
                  tilebitmap=Bitmap.new(twidth,theight)
                  bltAutotile(tilebitmap,0,0,id,anim)
                  @autotileInfo[id]=tilebitmap
                end
                xpos=(x*twidth)-@oxLayer0
                ypos=(y*theight)-@oyLayer0
                bitmap.blt(xpos,ypos,tilebitmap,tilerect)
              end
            end
          end
        end
        Graphics.frame_reset
      else
        if !@priorect || !@priorectautos || @priorect[0]!=xStart ||
           @priorect[1]!=yStart ||
           @priorect[2]!=xEnd ||
           @priorect[3]!=yEnd
          @priorectautos=@prioautotiles.find_all{|tile|
             x=tile[0]
             y=tile[1]
             # "next" means "return" here
             next !(x<xStart||x>xEnd||y<yStart||y>yEnd)
          }
          @priorect=[xStart,yStart,xEnd,yEnd]
        end
   #   echoln ["autos",@priorect,@priorectautos.length,@prioautotiles.length]
        for tile in @priorectautos
          x=tile[0]
          y=tile[1]
          overallcount+=1
          xpos=(x*twidth)-@oxLayer0
          ypos=(y*theight)-@oyLayer0
          bitmap.fill_rect(xpos,ypos,twidth,theight,trans)
          z=0
          while z<zsize
            id = mapdata[x,y,z]
            z+=1
            next if !id || id<48
            prioid=@priorities[id]
            next if prioid!=0 || !prioid
            # Klein tiles
            if id>=384 && !isKleinTile?(id)
              temprect.set(((id - 384)&7)*@tileSrcWidth,((id - 384)>>3)*@tileSrcHeight,
                 @tileSrcWidth,@tileSrcHeight)
              if @diffsizes
                bitmap.stretch_blt(Rect.new(xpos,ypos,twidth,theight),@tileset,temprect)
              else
                bitmap.blt(xpos,ypos,@tileset,temprect)
              end
            elsif id>=384 && isKleinTile?(id)
                # Klein tiles
                ktbitmap=nil
                ktbitmap=$kleinAnimatedInfo[id] if $kleinAnimatedInfo[id]!=nil

                if ktbitmap==nil
                  for kleinTiles in @kleinTilesInfo
                    kt=kleinTiles if kleinTiles[0]+384==id
                  end
                  barray=[]
                  for tileids in kt[1]
                    barray.push(kleinTileRects(tileids+384))
                  end
                  $kleinAnimatedInfo[id]=barray
                  ktbitmap=$kleinAnimatedInfo[id]
                end
                
               xpos=(x*twidth)-@oxLayer0
               ypos=(y*theight)-@oyLayer0
               bitmap.fill_rect(xpos,ypos,32,32,Color.new(0,0,0,0)) if z==0
               bitmap.blt(xpos,ypos,@animateTilesetBitmap,kleinTileFrame(ktbitmap))

             elsif id<384
              tilebitmap=@autotileInfo[id]
              if !tilebitmap
                anim=autotileFrame(id)
                next if anim<0
                tilebitmap=Bitmap.new(twidth,theight)
                bltAutotile(tilebitmap,0,0,id,anim)
                @autotileInfo[id]=tilebitmap
              end
              bitmap.blt(xpos,ypos,tilebitmap,tilerect)
            end
          end
        end
        Graphics.frame_reset if overallcount>500
      end
      @usedsprites=false
      return true
    end
    return false if @usedsprites
    @firsttime=false
    @oxLayer0=@ox-(width>>2)
    @oyLayer0=@oy-(height>>2)
    if @layer0clip
      @layer0.ox=0
      @layer0.oy=0
      @layer0.src_rect.set(width>>2,height>>2,
         @viewport.rect.width,@viewport.rect.height)
    else
      @layer0.ox=(width>>2)
      @layer0.oy=(height>>2)
    end
    @layer0.bitmap.clear
    @oxLayer0=@oxLayer0.floor
    @oyLayer0=@oyLayer0.floor
    xStart=(@oxLayer0/twidth)
    xStart=0 if xStart<0
    yStart=(@oyLayer0/theight)
    yStart=0 if yStart<0
    xEnd=xStart+(width/twidth)+1
    yEnd=yStart+(height/theight)+1
    xEnd=xsize if xEnd>=xsize
    yEnd=ysize if yEnd>=ysize
    if xStart<xEnd && yStart<yEnd
      tmprect=Rect.new(0,0,0,0)
      yrange=yStart...yEnd
      xrange=xStart...xEnd
      for z in 0...zsize
        for y in yrange
          ypos=(y*theight)-@oyLayer0
          for x in xrange
            xpos=(x*twidth)-@oxLayer0
            id = mapdata[x, y, z]
            next if id==0 || @priorities[id]!=0 || !@priorities[id]
            
            if id>=384 && !isKleinTile?(id)
              tmprect.set( ((id - 384)&7)*@tileSrcWidth,((id - 384)>>3)*@tileSrcHeight,
                 @tileSrcWidth,@tileSrcHeight)
              if @diffsizes
                bitmap.stretch_blt(Rect.new(xpos,ypos,twidth,theight),@tileset,tmprect)
              else
                bitmap.blt(xpos,ypos,@tileset,tmprect)
              end
            elsif id>=384 && isKleinTile?(id)
                # Klein tiles
                ktbitmap=nil
                ktbitmap=$kleinAnimatedInfo[id] if $kleinAnimatedInfo[id]!=nil

                if ktbitmap==nil
                  for kleinTiles in @kleinTilesInfo
                    kt=kleinTiles if kleinTiles[0]+384==id
                  end
                  barray=[]
                  for tileids in kt[1]
                    barray.push(kleinTileRects(tileids+384))
                  end
                  $kleinAnimatedInfo[id]=barray
                  ktbitmap=$kleinAnimatedInfo[id]
                end
                
               xpos=(x*twidth)-@oxLayer0
               ypos=(y*theight)-@oyLayer0
               bitmap.fill_rect(xpos,ypos,32,32,Color.new(0,0,0,0)) if z==0
               bitmap.blt(xpos,ypos,@animateTilesetBitmap,kleinTileFrame(ktbitmap))
            elsif id<384
              frames=@framecount[id/48-1]
              if frames<=1
                frame=0
              else
                frame=(Graphics.frame_count/Animated_Autotiles_Frames)%frames
              end
              bltAutotile(bitmap,xpos,ypos,id,frame)
            end
          end
        end
      end
      Graphics.frame_reset
    end
    return true
  end
  
  def kleinTileBitmap(id)
    bitmap=Bitmap.new(@tileWidth,@tileHeight)
    bitmap.blt(0,0,@animateTilesetBitmap,
    Rect.new(((id - 384)&7)*@tileSrcWidth,((id - 384)>>3)*@tileSrcHeight,
    @tileWidth,@tileHeight))
    return bitmap
  end
  
  def kleinTileRects(id)    
    return Rect.new(((id - 384)&7)*@tileSrcWidth,((id - 384)>>3)*@tileSrcHeight,
    @tileWidth,@tileHeight) 
  end
  
  def isKleinTilePlusAuto?(id)
    return true if id<384
    for kleinTiles in @kleinTilesInfo
       return true if kleinTiles[0]+384==id
    end
    return false
  end
  
  def isKleinTile?(id)
    for kleinTiles in @kleinTilesInfo
       return true if kleinTiles[0]+384==id
    end
    return false
  end
  
  def addTile(tiles,count,xpos,ypos,id)
    if id>=384
      if count>=tiles.length
        sprite=CustomTilemapSprite.new(@viewport)
        tiles.push(sprite,isKleinTile?(id) ? 3 : 0) 
      else
        sprite=tiles[count]
        tiles[count+1]=isKleinTile?(id) ? 3 : 0
      end
      if isKleinTile?(id)
        ktbitmap=nil
        ktbitmap=$kleinAnimatedInfo[id] if $kleinAnimatedInfo[id]!=nil
        if ktbitmap==nil
          for kleinTiles in @kleinTilesInfo
            kt=kleinTiles if kleinTiles[0]+384==id
          end
          barray=[]
          for tileids in kt[1]
            barray.push(kleinTileRects(tileids+384))
          end
          $kleinAnimatedInfo[id]=barray
          ktbitmap=$kleinAnimatedInfo[id]
        end
      end
      sprite.visible=@visible
      sprite.x=xpos
      sprite.y=ypos
      sprite.tone=@tone
      sprite.color=@color
      sprite.id=id
      if isKleinTile?(id) && ktbitmap!=nil
        getRegularKleinTile(sprite,id,kleinTileFrame(ktbitmap))   
      else
        getRegularTile(sprite,id)
      end
      spriteZ=(@priorities[id]==0 || !@priorities[id]) ? 0 : ypos+@priorities[id]*32+32
      spriteZ=1 if @priorities[id]==4 && $PokemonGlobal && $PokemonGlobal.bridge>0
      sprite.z=spriteZ
      count+=2
    else
      if count>=tiles.length
        sprite=CustomTilemapSprite.new(@viewport)
        tiles.push(sprite,1)
      else
        sprite=tiles[count]
        tiles[count+1]=1
      end
      sprite.visible=@visible
      sprite.x=xpos
      sprite.y=ypos
      sprite.tone=@tone
      sprite.color=@color
      getAutotile(sprite,id)
      spriteZ=(@priorities[id]==0 || !@priorities[id]) ? 0 : ypos+@priorities[id]*32+32
      spriteZ=1 if @priorities[id]==4 && $PokemonGlobal && $PokemonGlobal.bridge>0
      sprite.z=spriteZ
      count+=2
    end
    return count
  end

  alias klein_repaintauto repaintAutotiles
  def repaintAutotiles
    for s in 0...@tiles.length
      next if @tiles[s+1]!=3
      id=@tiles[s].id
      ktbitmap=nil
      ktbitmap=$kleinAnimatedInfo[id] if $kleinAnimatedInfo[id]!=nil
      if ktbitmap==nil
        for kleinTiles in @kleinTilesInfo
          kt=kleinTiles if kleinTiles[0]+384==id
        end
        barray=[]
        for tileids in kt[1]
          barray.push(kleinTileRects(tileids+384))
        end
        $kleinAnimatedInfo[id]=barray
        ktbitmap=$kleinAnimatedInfo[id]
      end
        
      @tiles[s].src_rect=kleinTileFrame(ktbitmap) 
    end
    klein_repaintauto
  end
  
  def getRegularKleinTile(sprite,id,rect)
    if sprite.bitmap!=@animateTilesetBitmap
      sprite.bitmap=@animateTilesetBitmap
    end
    sprite.src_rect=rect
  end  
  
  def refresh_autotiles
    i=0;len=@autotileInfo.length;while i<len
      if @autotileInfo[i]
        @autotileInfo[i].dispose
        @autotileInfo[i]=nil
      end
      i+=1
    end
    i=0;len=@autosprites.length;while i<len
      if @autosprites[i]
        @autosprites[i].dispose
        @autosprites[i]=nil
      end
      i+=2
    end
    @autosprites.clear
    @autotileInfo.clear
    @prioautotiles.clear
    @priorect=nil
    @priorectautos=nil
    hasanimated=false
    for i in 0...7
      numframes=autotileNumFrames(48*(i+1))
      hasanimated=true if numframes>=2
      @framecount[i]=numframes
    end
    hasanimated=true if @kleinTilesInfo.length!=0
    if hasanimated
      ysize=@map_data.ysize
      xsize=@map_data.xsize
      zsize=@map_data.zsize
      if xsize>100 || ysize>100
        @fullyrefreshedautos=false
      else
        for y in 0...ysize
          for x in 0...xsize
            haveautotile=false
            for z in 0...zsize
              id = @map_data[x, y, z]
              next if id==0 || !isKleinTilePlusAuto?(id) || @priorities[id]!=0 || !@priorities[id]
              next if id<384 && @framecount[id/48-1]<2
              haveautotile=true
              break
            end
            @prioautotiles.push([x,y]) if haveautotile
          end
        end
        @fullyrefreshedautos=true
      end
    else
      @fullyrefreshedautos=true 
    end
  end
end

################################################################################
# User functions
#===============================================================================
#===============================================================================
# Zeus81's Bitmap Exporter
# This will allow to save the bitmap
#===============================================================================
class Bitmap
  RtlMoveMemory = Win32API.new('kernel32', 'RtlMoveMemory', 'ppi', 'i')
  def last_row_address
    return 0 if disposed?
    RtlMoveMemory.call(buf=[0].pack('L'), __id__*2+16, 4)
    RtlMoveMemory.call(buf, buf.unpack('L')[0]+8 , 4)
    RtlMoveMemory.call(buf, buf.unpack('L')[0]+16, 4)
    buf.unpack('L')[0]
  end
  def bytesize
    width * height * 4
  end
  def get_data
    data = [].pack('x') * bytesize
    RtlMoveMemory.call(data, last_row_address, data.bytesize)
    data
  end
  def set_data(data)
    RtlMoveMemory.call(last_row_address, data, data.bytesize)
  end
  def get_data_ptr
    data = String.new
    RtlMoveMemory.call(data.__id__*2, [0x2007].pack('L'), 4)
    RtlMoveMemory.call(data.__id__*2+8, [bytesize,last_row_address].pack('L2'), 8)
    def data.free() RtlMoveMemory.call(__id__*2, String.new, 16) end
    return data unless block_given?
    yield data ensure data.free
  end
  def _dump(level)
    get_data_ptr do |data|
      dump = Marshal.dump([width, height, Zlib::Deflate.deflate(data, 9)])
      dump
    end
  end
  def self._load(dump)
    width, height, data = *Marshal.load(dump)
    data.replace(Zlib::Inflate.inflate(data))
    bitmap = new(width, height)
    bitmap.set_data(data)
    bitmap
  end
  def export(filename)
    export_png("#{filename}.png")
  end
  def export_png(filename)
    data, i = get_data, 0
      (0).step(data.bytesize-4, 4) do |i|
        data[i,3] = data[i,3].reverse!
    end
    deflate = Zlib::Deflate.new(9)
      null_char, w4 = [].pack('x'), width*4
      (data.bytesize-w4).step(0, -w4) {|i| deflate << null_char << data[i,w4]}
      data.replace(deflate.finish)
    deflate.close
    File.open(filename, 'wb') do |file|
      def file.write_chunk(chunk)
        write([chunk.bytesize-4].pack('N'))
        write(chunk)
        write([Zlib.crc32(chunk)].pack('N'))
      end
      file.write("\211PNG\r\n\32\n")
      file.write_chunk(['IHDR',width,height,8,6,0,0,0].pack('a4N2C5'))
      file.write_chunk(data.insert(0, 'IDAT'))
      file.write_chunk('IEND')
    end
  end
end

class String
  alias getbyte  []
  alias setbyte  []=
  alias bytesize size
end
 
class Font
  def marshal_dump()     end
  def marshal_load(dump) end
end

module Graphics
    FindWindow             = Win32API.new('user32', 'FindWindow'            , 'pp'       , 'i')
    GetDC                  = Win32API.new('user32', 'GetDC'                 , 'i'        , 'i')
    ReleaseDC              = Win32API.new('user32', 'ReleaseDC'             , 'ii'       , 'i')
    BitBlt                 = Win32API.new('gdi32' , 'BitBlt'                , 'iiiiiiiii', 'i')
    CreateCompatibleBitmap = Win32API.new('gdi32' , 'CreateCompatibleBitmap', 'iii'      , 'i')
    CreateCompatibleDC     = Win32API.new('gdi32' , 'CreateCompatibleDC'    , 'i'        , 'i')
    DeleteDC               = Win32API.new('gdi32' , 'DeleteDC'              , 'i'        , 'i')
    DeleteObject           = Win32API.new('gdi32' , 'DeleteObject'          , 'i'        , 'i')
    GetDIBits              = Win32API.new('gdi32' , 'GetDIBits'             , 'iiiiipi'  , 'i')
    SelectObject           = Win32API.new('gdi32' , 'SelectObject'          , 'ii'       , 'i')
    def self.snap_to_bitmap
      bitmap  = Bitmap.new(width, height)
      info    = [40,width,height,1,32,0,0,0,0,0,0].pack('LllSSLLllLL')
      hDC     = GetDC.call(hwnd)
      bmp_hDC = CreateCompatibleDC.call(hDC)
      bmp_hBM = CreateCompatibleBitmap.call(hDC, width, height)
      bmp_obj = SelectObject.call(bmp_hDC, bmp_hBM)
      BitBlt.call(bmp_hDC, 0, 0, width, height, hDC, 0, 0, 0xCC0020)
      GetDIBits.call(bmp_hDC, bmp_hBM, 0, height, bitmap.last_row_address, info, 0)
      SelectObject.call(bmp_hDC, bmp_obj)
      DeleteObject.call(bmp_hBM)
      DeleteDC.call(bmp_hDC)
      ReleaseDC.call(hwnd, hDC)
      bitmap
  end
    
  class << self
    def hwnd() @hwnd ||= FindWindow.call('RGSS Player', nil) end
    def width()  640 end unless method_defined?(:width)
    def height() 480 end unless method_defined?(:height)
    def export(filename=Time.now.strftime("snapshot %Y-%m-%d %Hh%Mm%Ss #{frame_count}"))
      bitmap = snap_to_bitmap
      bitmap.export(filename)
      bitmap.dispose
    end
    alias save     export
    alias snapshot export
  end
end

def pbMakeNumericTileset(name)
  file=sprintf("Graphics/Tilesets/"+name)
  return if !FileTest.image_exist?(file)
  tileset=BitmapCache.load_bitmap(file)
  numericSet=tileset.clone
  pbSetSystemFont(numericSet)
  numericSet.font.size=21
  for width in 0...numericSet.width/32
    for height in 0...numericSet.height/32
    number=(width+(height*8)).to_s
    nsize=numericSet.text_size(number)
    text=[[
    number,(width+1)*32-16,height*32,2,Color.new(255,0,0),Color.new(0,0,0)
    ]]
    pbDrawTextPositions(numericSet,text)
    end
  end
  numericSet.export(sprintf(name+"_numeric"))
  Kernel.pbMessage(_INTL("Saved in game's folder: {1}_numeric",name))
end
