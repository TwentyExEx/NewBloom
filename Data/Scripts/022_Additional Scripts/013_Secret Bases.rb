#===============================================================================
# ■ Klein's Secret Bases script for Essentials
#      Version 1 (4/5/15)
# Most completely updated by Vendily for v17
# - http://kleinstudio.deviantart.com
# Be sure to give credits if you're using this.
# - How to use
# * Creating the secret base map
#   - Create a blank map with the Secret base tileset
#   - Set SECRETBASEMAP to the blank map id
#   - Create template maps that contain 2 events
#     * an event with the name DOOR that has "pbExitBase"
#        as the only script command
#     * an event with a blank first page, and a second page with a script
#        command of "pbSecretBasePC" and a switch condition named "s:pbIsMyBase?"
#     * See the contained base map templates
#     * Holes must be on the second layer
#
# * Creating the entrance for a secret base
#   - Event for entrance needs to be called SecretBase(X,Y), 
#      where X is the id of the base (not map, just identification)
#      and Y is the template name (see SECRETBASETEMPLATES's keys)
#     * so a base event can be called SecretBase(1,treeSquare), and
#        the secret base will load map 32 as a base for the SECRETBASEMAP
#
# * Creating a mart for base items
#   - Call pbSecretBaseMart(stock,speech=nil).
#     * stock is an array of secret base item names
#       ["Brick Desk","Big Appliance"] is a valid stock.
#       Alternatively, you can use one of methods to get all items of a
#       particular type.
#        - getAllSurfaces
#        - getAllComforts
#        - getAllWalls
#        - getAllAppliances
#        - getAllFloors
#        - getAllElectronics
#        - getAllHobbies
#        - getAllMilestones
#
# * Creating a locator NPC
#   - pbGetBaseLocation(mapname=-1,mapid=-1)
#      * Sets game variables mapname and mapid to the map name and mapid 
#         the secret base is located on.
# * Gifting a Base Item
#   - pbGetBaseItem(item)
#     * item is the secret base item name, in quotes
#       "Lapras Hobbie" is a valid item.
#===============================================================================
# ■ General settings
#===============================================================================

# Map id where items events are allocated                   
ITEMSMAP=54

# Map used to load secret bases on
# It is a dummy map, and can be left completly blank
SECRETBASEMAP=50

# Secret Bases tileset name                                 
SECRETBASETILESET="Homes"

# Templates for the secret base
# keyName (used in events) => [map id to copy,
#                              number of steps to walk in when creating base,
#                              type of entrance]
SECRETBASETEMPLATES={
                      "forestCabin"=>[51,2,"Cabin"],
                      "mountainHouse"=>[52,2,"House"],
                      "caveSquare"=>[53,3,"Apartment"]
                    }
                    
# Messages for the secret entrances
# the type of entrance set for the template in SECRETBASETEMPLATES is used here
#  to determine the message
SECRETBASEMESSAGES={
                    "Cabin"=>_INTL("The door is locked."),
                    "House"=>_INTL("The door is locked."),
                    "Apartment"=>_INTL("IThe door is locked.")
                   }

# Allow to place dolls and cushions everywhere              
HOBBIESEVERYWHERE=true

# Terrain tag for ground decorations that already are in    
# base, for example rocks or bushes in layer 1
# if your ground decoration is in layer 2 or 3, don't worry
# about this.
GROUNDDECORATION=20

# Terrain tag for walls                                     
# You can post posters in every tile with this terrain tag                       
WALLTERRAINTAG=21

# Terrain tag for special items that can be used
# for place dolls.
ITEMFORHOBBIE=22

# Move needed for make secret bases
BASEMOVENEEDED=:SECRETPOWER

#===============================================================================
# ■ Secret Base Bag pockets
# [Pocket name, max items]
#===============================================================================
BASEBAGPOCKETS=[
["Surfaces",10],
["Comfort",10],
["Appliances",10],
["Electronics",30],
["Floor Decor",30],
["Wall Decor",10],
["Hobbies",40],
["Milestones",10],
]

#===============================================================================
# Type of items
#===============================================================================
module ItemType
  SURFACE=0
  COMFORT=1
  APPLIANCE=2
  ELECTRONIC=3
  FLOOR=4
  WALL=5
  HOBBIE=6
  MILESTONE=7
end

#===============================================================================
# ■ Items are stored here
# To add a new item place this in the last position (* New Items)
# ["name", tileid, width, height, prize, event, type, board, "description"],
#
# -Explanation
# * Name - Item name
# * Tileid - Item tile id **************READ*****************
#     Imagine this is a tileset, tiles id are like this
#     [00][01][02][03][04][05][06][07]
#     [08][09][10][11][12][13][14][15]
#     [16][17][18][19][20][21][22][23]...
#
#     The tile id placed here has to be the top-left tile id of the item-
#     **********FAST USER FUNCTION**********
#     You can use pbMakeNumericTileset(TILESETNAME) for create a new .png
#     in the game's folder with a tileset and a numeric patron.
#
# * Width 
#   - Width in tiles (1, 2...)
#   *If the item is an event item, leave this in 1
# * Height 
#   - Height in tiles (1, 2...)
#   *If the item is an event item, leave this in 1
# * Price - Price when shopping
# * Event - Event id
#     If you don't want you item to be an event just place 'nil' here
#     * Creating interactable items **************READ*****************
#     If you want your item to be interactable create a new event in the
#     ITEMSMAP and write here the event id. Interactable items are not tiles
#     so you need to select a graphic in the event if you don't want it to be
#     invisible.
#  
# * Type - Type of item (ItemType::WALL, ItemType::SURFACE...)
#     Some types has specials features:
#       *WALL - This item only can be placed in a WALLTERRAINTAG tile.
#     Also *MILESTONE and *HOBBIE can only be placed in items marked as table if
#     you don't enable HOBBIESEVERYWHERE. Hobbies and cushions ALWAYS needs to be
#     events items.
#
# * Board
#   - This kind of item can be placed upside holes
#   if you don't want it, just place 'false'
#
# * Description - Item description (A small chair...)
#
#===============================================================================
# ■ Items
#===============================================================================
SECRETBASEITEMS=[
  [-1],
  #* Surfaces
["Small Table",119,1,2,500,nil,ItemType::SURFACE,false,"A small table with two drawers."],
["Bamboo Drawers",1104,2,2,1000,nil,ItemType::SURFACE,false,"A bamboo set of drawers."],
["Bamboo Drawers",1098,2,2,1000,nil,ItemType::SURFACE,false,"A bamboo set of drawers."],
["Bamboo Dresser",1100,2,2,1000,nil,ItemType::SURFACE,false,"A bamboo dresser."],
["Bamboo Tall Drawers",1068,2,2,1000,nil,ItemType::SURFACE,false,"A tall bamboo dresser."],
["Bamboo Low Table",1046,2,3,1000,nil,ItemType::SURFACE,false,"A bamboo low table."],
["Plaid Table S",158,1,2,1000,nil,ItemType::SURFACE,false,"Who knew tables came in plaid?"],
["Dark Round Table",968,4,2,2000,nil,ItemType::SURFACE,false,"A round dark table"],
["Dark Console Table",972,2,2,1000,nil,ItemType::SURFACE,false,"A dark console table."],
["Plaid Table W",174,2,2,1000,nil,ItemType::SURFACE,false,"Who knew tables came in plaid?"],
["Plaid Table L",173,1,3,100,nil,ItemType::SURFACE,false,"Who knew tables came in plaid?"],
["Wood Plank Table W",917,2,3,1000,nil,ItemType::SURFACE,false,"A rustic long wood table."],
["Redwood Dresser",882,2,2,1000,nil,ItemType::SURFACE,false,"A redwood styled dresser."],
["SL Table X",196,2,2,1500,nil,ItemType::SURFACE,false,"A Santalune brand large table."],
["Redwood End Table",884,1,2,500,nil,ItemType::SURFACE,false,"A redwood styled end table."],
["SL Table S",198,1,1,1000,nil,ItemType::SURFACE,false,"A Santalune brand small table"],
["SL Table L",199,1,2,1000,nil,ItemType::SURFACE,false,"A Santalune brand long table"],
["SL Table W",214,2,2,1000,nil,ItemType::SURFACE,false,"A Santalune brand wide table"],
["White Desk",867,3,2,1200,nil,ItemType::SURFACE,false,"A long white desk."],
["PB Table X",200,2,2,1500,nil,ItemType::SURFACE,false,"A Petalberg brand large table"],
["PB Table S",218,1,1,1000,nil,ItemType::SURFACE,false,"A Petalberg brand small table"],
["PB Table L",202,1,2,1000,nil,ItemType::SURFACE,false,"A Petalberg brand long table"],
["PB Table W",216,2,1,1000,nil,ItemType::SURFACE,false,"A Petalberg brand wide table"],
["MT Table X",211,2,2,1500,nil,ItemType::SURFACE,false,"A Mistralton brand large table"],
["MT Table S",227,1,2,1000,nil,ItemType::SURFACE,false,"A Mistralton brand small table"],
["MT Table L",226,1,2,1000,nil,ItemType::SURFACE,false,"A Mistralton brand long table"],
["MT Table W",224,2,2,1000,nil,ItemType::SURFACE,false,"A Mistralton brand wide table"],
["Wood Dresser",360,2,3,1000,nil,ItemType::SURFACE,false,"A old wooden dresser with a photo and mirror."],
["Drawers",372,1,2,1000,nil,ItemType::SURFACE,false,"A set of plain drawers."],
["Desk with Laptop",394,2,2,1000,nil,ItemType::SURFACE,false,"A desk with an old laptop on it."],
["Display Cabinet ",408,2,2,1000,nil,ItemType::SURFACE,false,"A display cabinet full of fun trinkets."],

  #* Comforts
  ["Floor Mattress",1134,2,3,1000,nil,ItemType::COMFORT,false,"A floor mattress for a good nights sleep."],
  ["Stool R",125,1,1,1000,nil,ItemType::COMFORT,false,"A small red stool with wooden legs. It is somewhat comfortable."],
  ["Chair G",133,1,1,1000,nil,ItemType::COMFORT,false,"The blandest green chair imagineable."],
  ["Zen Cushion",1060,1,1,1000,nil,ItemType::COMFORT,false,"A zen styled cushion."],
  ["Dark Stool",125,1,1,1000,nil,ItemType::COMFORT,false,"A dark wooden stool. It hurts to sit on, but art requires suffering."],
  ["Chair Y",165,1,1,1000,nil,ItemType::COMFORT,false,"The blandest yellow chair imagineable."],
  ["Red Couch Lft",987,2,3,1500,nil,ItemType::COMFORT,false,"A left facing red couch."],
  ["Red Couch Rght",989,2,3,1500,nil,ItemType::COMFORT,false,"A right facing red couch."],
  ["Red Couch Dwn",984,3,2,1500,nil,ItemType::COMFORT,false,"A downwards facing red couch."],
  ["Wood Plank Chair Lft",952,1,2,1000,nil,ItemType::COMFORT,false,"A left facing wooden chair."],
  ["Wood Plank Chair Rght",953,1,2,1000,nil,ItemType::COMFORT,false,"A right facing wooden chair."],
  ["Wood Plank Chair Up",938,1,2,1000,nil,ItemType::COMFORT,false,"A downwards facing wooden chair."],
  ["Wood Plank Chair Dbl Rght",936,1,2,2000,nil,ItemType::COMFORT,false,"A double set of right facing chairs."],
  ["Wood Plank Chair Dbl Lft",937,1,2,2000,nil,ItemType::COMFORT,false,"A double set of left facing chairs."],
  ["Ugly Stool",192,1,1,50,nil,ItemType::COMFORT,false,"Look how ugly it is."], 
  ["Velvet Stool",194,1,1,1500,nil,ItemType::COMFORT,false,"A lovely red velvet stool."],
  ["Log Couch Lft",912,2,3,1000,nil,ItemType::COMFORT,false,"A green cushioned, left facing couch."],
  ["Log Couch Rght",914,2,3,1000,nil,ItemType::COMFORT,false,"A green cushioned, right facing couch."],
  ["Candy Stool",193,1,1,1500,nil,ItemType::COMFORT,false,"A tasty looking stool."],
  ["Choc Stool",195,1,1,1500,nil,ItemType::COMFORT,false,"A short, dark and handsome stool."],
  ["Log Bed",898,3,2,1000,nil,ItemType::COMFORT,false,"A cozy leg bed."],
  ["Redwood Bed Red",792,2,3,1000,nil,ItemType::COMFORT,false,"A redwood bed, in red."],
  ["Redwood Bed Blue",794,2,3,1000,nil,ItemType::COMFORT,false,"A redwood bed, in blue."],
  ["Redwood Bed Yellow",796,2,3,1000,nil,ItemType::COMFORT,false,"A redwood bed, in yellow."],
  ["Redwood Bed Green",798,2,3,1000,nil,ItemType::COMFORT,false,"A redwood bed, in green."],
  ["Antique Bed G",245,3,4,2000,nil,ItemType::COMFORT,false,"An antique washed out bed."],
  ["Antique Bed B",264,3,4,2000,nil,ItemType::COMFORT,false,"An antique blue bed."],
  ["Antique Bed C",275,3,4,2000,nil,ItemType::COMFORT,false,"An antique cookie themed bed."],
  ["Antique Bed R",296,3,4,2000,nil,ItemType::COMFORT,false,"An antique red bed."],
  ["Grey Couch F",328,5,2,2000,nil,ItemType::COMFORT,false,"A large grey couch, viewed from the front."],
  ["Grey Couch B",344,5,2,2000,nil,ItemType::COMFORT,false,"A large grey couch, viewed from the back."],
  ["Cushion G",442,1,1,500,nil,ItemType::COMFORT,false,"A green cushion."],
  ["Cushion R",450,1,1,500,nil,ItemType::COMFORT,false,"A red cushion."],
  ["Cushion B",458,1,1,500,nil,ItemType::COMFORT,false,"A blue cushion."],
  ["Square Cushion",466,1,1,500,nil,ItemType::COMFORT,false,"A very square cushion."],
  ["Short Stool R",443,1,1,500,nil,ItemType::COMFORT,false,"A small, red stool."],
  ["Short Stool G",451,1,1,500,nil,ItemType::COMFORT,false,"A small, green stool."],
  ["Short Stool B",459,1,1,500,nil,ItemType::COMFORT,false,"A small, blue stool."],
  ["Plastic Stool B",445,1,1,500,nil,ItemType::COMFORT,false,"A plastic, blue stool."],
  ["Plastic Stool G",453,1,1,500,nil,ItemType::COMFORT,false,"A plastic, green stool."],
  ["Plastic Stool R",461,1,1,500,nil,ItemType::COMFORT,false,"A plastic, red stool."],

  #* Appliances
["Brown Fridge",121,1,2,1500,nil,ItemType::APPLIANCE,false,"A simple brown fridge."],
["White Fridge",137,1,2,1500,nil,ItemType::APPLIANCE,false,"A simple white fridge."],
["Long Red Basin",138,3,2,2000,nil,ItemType::APPLIANCE,false,"A long red basin with a tap."],
["Long Yellow Basin",154,3,2,2000,nil,ItemType::APPLIANCE,false,"A long yellow basin with a tap."],
["Sink and Stove",141,2,2,1500,nil,ItemType::APPLIANCE,false,"A standard domestic sink and stove."],
["SL Sink",228,1,2,1300,nil,ItemType::APPLIANCE,false,"A sink from the Santalune furniture line."],
["Stove",229,1,2,1000,nil,ItemType::APPLIANCE,false,"A standard domestic stove."],
["SL Counter",230,1,2,1000,nil,ItemType::APPLIANCE,false,"A counter-top from the Santalune furniture line."],
["Buetic Bathtub",490,2,3,2500,nil,ItemType::APPLIANCE,false,"A bathtub from the Buetic brand line."],
["Buetic Vanity S",508,1,2,2000,nil,ItemType::APPLIANCE,false,"A small vanity from the Buetic brand line. "],
["Buetic Vanity L",509,2,2,2500,nil,ItemType::APPLIANCE,false,"A large vanity from the Buetic brand line. "],
["Cabin Fireplace",847,1,3,2000,nil,ItemType::APPLIANCE,false,"A fireplace to keep cabins warm in winter."],
["Pizza Oven",880,2,4,3000,nil,ItemType::APPLIANCE,false,"An unneccessarily large pizza oven."],
["Coffee Machine",942,1,2,1500,nil,ItemType::APPLIANCE,false,"A coffee machine that gets you up in the morning. "],
["Metal Furnace Double",1132,2,2,1000,nil,ItemType::APPLIANCE,false,"A larger metal furnace, perfect for cooking up a meal."],
["Metal Furnace w/ Pans",1080,1,2,1000,nil,ItemType::APPLIANCE,false,"A metal furnace with wall hanging pans. "],
["Wood and Metal Sink",1082,1,2,1000,nil,ItemType::APPLIANCE,false,"A metal sink on a wooden stand. "],
["Television",178,3,2,2500,nil,ItemType::APPLIANCE,false,"A large television with an entertaining blue channel."],
["Redwood TV Set",885,2,2,5000,nil,ItemType::APPLIANCE,false,"A television on top of a redwood set of drawers."],
["Sci-Fi Machine",388,2,3,2000,nil,ItemType::APPLIANCE,false,"A strange sci-fi machine. It can sound too human sometimes. "],
["Nintendo Wii",444,1,1,2000,36,ItemType::APPLIANCE,false,"A Nintendo Wii. You have always wanted one."],
["Nintendo Wii G",452,1,1,2000,37,ItemType::APPLIANCE,false,"A green Nintendo Wii. You have always wanted one."],
["Nintendo Wii R",460,1,1,2000,38,ItemType::APPLIANCE,false,"A red Nintendo Wii. You have always wanted one."],
["Nintendo Wii C",468,1,1,2000,39,ItemType::APPLIANCE,false,"A cute Nintendo Wii. You have always wanted one."],

  #* Electronics

  #* Floors
["Shoji Screen",1178,2,2,1000,nil,ItemType::FLOOR,false,"A traditional Shoji screen."],
["Stacked Bamboo Shelf",1114,2,3,1250,nil,ItemType::FLOOR,false,"A serene stacked bamboo shelf."], 
["Rounded Bamboo Shelf",1110,2,3,1500,nil,ItemType::FLOOR,false,"A serene rounded bamboo shelf"],
["Bonsai Tree R",1116,1,2,1000,nil,ItemType::FLOOR,false,"A red bonsai tree."],
["Bonsai Tree G",1117,1,2,1000,nil,ItemType::FLOOR,false,"A green bonsai tree."],
["Firewood Stack",1081,1,2,1000,nil,ItemType::FLOOR,false,"A small stack of firewood."],
["Rounded Plant",126,1,2,1000,nil,ItemType::FLOOR,false,"A tall rounded plant in a pot."],
["Flower Display",143,1,2,1000,nil,ItemType::FLOOR,false,"A large display of well kept flowers. "],
["Zen Table Lamp",1064,1,1,1000,nil,ItemType::FLOOR,false,"A small Zen table lamp."],
["Houseplant Bamboo ",1071,1,2,1000,nil,ItemType::FLOOR,false,"A small pot of bamboo."],
["Bamboo Rug Vert",1024,2,4,1000,nil,ItemType::FLOOR,false,"A vertical bamboo rug."],
["Floor Pot Beige",1061,1,1,1000,nil,ItemType::FLOOR,false,"A beige pot. "],
["Bonsai Tree Big",1030,2,2,2000,nil,ItemType::FLOOR,false,"A large bonsai tree."],
["Bamboo Rug Horiz",1011,4,2,1000,nil,ItemType::FLOOR,false,"A horizontal bamboo rug. "],
["Dark Rug",1000,3,3,1000,nil,ItemType::FLOOR,false,"A large dark rug. "],
["Zen Floor Lamp",974,1,2,1000,nil,ItemType::FLOOR,false,"A large zen lamp. "],
["Flower Vase",958,1,2,1000,nil,ItemType::FLOOR,false,"A small vase of flowers."],
["Door Mat",170,2,1,1000,nil,ItemType::FLOOR,false,"A simple door mat that practically screams ""Welcome""."],
["Grandfather Clock",168,2,3,3000,nil,ItemType::FLOOR,false,"A massive and expensive clock. It tells the time."],
["Houseplant Tall",887,1,2,1000,nil,ItemType::FLOOR,false,"A tall houseplant"],
["Houseplant Medium ",871,1,2,1000,nil,ItemType::FLOOR,false,"A medium sized houseplant."],
["Floor Pot Yellow",902,1,1,1000,nil,ItemType::FLOOR,false,"A yellow pot."],
["Green Plaid Rug",844,3,3,1000,nil,ItemType::FLOOR,false,"A comfy plaid rug."],
["Houseplant Red Vase",842,1,2,1000,nil,ItemType::FLOOR,false,"A tall houseplant in a red vase."],
["Houseplant White Vase",851,1,1,1000,nil,ItemType::FLOOR,false,"A miniscule houseplant in a white vase."],
["Cardboard Box",821,1,1,25,nil,ItemType::FLOOR,false,"A cardboard box. You'd buy these?"],
["Cardboard Box Stack",822,2,2,75,nil,ItemType::FLOOR,false,"A stack of cardboard boxes. You'd buy multiple of these?"],
["Soft Carpet L",240,3,3,1500,nil,ItemType::FLOOR,false,"A large red carpet. Try not to spill anything on it."],
["Soft Carpet S",243,2,2,1000,nil,ItemType::FLOOR,false,"A small red carpet. Try not to spill anything on it."],
["Table with Flower",259,1,2,1000,nil,ItemType::FLOOR,false,"A table with a pot of flowers."],
["Small Bush",307,1,2,1000,nil,ItemType::FLOOR,false,"A very green bush."],
["Wide Bush",309,2,2,1500,nil,ItemType::FLOOR,false,"Kinda just a tree in a pot."],
["Red Blossom",311,1,2,1000,nil,ItemType::FLOOR,false,"A beautiful red blossom plant."],
["Colourful Bush",325,2,2,1000,nil,ItemType::FLOOR,false,"A colourful bush full of personality."],
["Mini Palm Tree",327,1,2,1000,nil,ItemType::FLOOR,false,"A taste of the tropical life."],
["Sudo-hairdo",341,2,2,1000,nil,ItemType::FLOOR,false,"Looking like a Sudowoodo with a fresh cut."],
["Books",469,1,1,300,nil,ItemType::FLOOR,false,"A pile of books. Much to read about. "],
  #* Walls
["Red Lantern Long",1121,1,2,1000,nil,ItemType::WALL,false,"A beautiful long red lantern."],
["Japanese Tapestry Grn",1120,1,2,1000,nil,ItemType::WALL,false,"A tapestry speaking of great power. "],
["Zen Window LBrwn Sqr",1102,1,1,1000,nil,ItemType::WALL,false,"A decorative window. "],
["Zen Window LBrwn Rect",1103,1,1,1000,nil,ItemType::WALL,false,"A decorative window. "],
["Notes",130,1,1,500,nil,ItemType::WALL,false,"A set of paper notes. Recipes? Calendar? Crushing debt? All up to you!"],
["Plant and Mirror",123,2,2,1000,nil,ItemType::WALL,false,"A wall shelf with a plant and mirror. "],
["Japanese Text Poster",1096,2,1,1000,nil,ItemType::WALL,false,"A poster that speaks of a land far away. "],
["Mounted Katana",1084,2,2,5000,nil,ItemType::WALL,false,"A katana to display, or to use against enemies. "],
["Zen Window L Brwn Rnd",1086,2,2,1000,nil,ItemType::WALL,false,"A decorative window. "],
["Hanging Herbs",1067,1,2,500,nil,ItemType::WALL,false,"A convienant way to collect your herbs. "],
["Red Lantern Short",1070,1,2,1000,nil,ItemType::WALL,false,"A beautiful short red lantern"],
["Japanese Tapestry Gry",1051,1,2,1000,nil,ItemType::WALL,false,"A tapestry speaking of great wisdom."],
["Zen Window DBrwn Sq",1042,1,1,1000,nil,ItemType::WALL,false,"A decorative window. "],
["Zen Window DBrwn Rect",1043,1,1,1000,nil,ItemType::WALL,false,"A decorative window. "],
["Great Wave Walll Partition",1044,2,2,1500,nil,ItemType::WALL,false,"A traditional wall partition."],
["Zen Window DBrwn Intricate",1026,2,2,1000,nil,ItemType::WALL,false,"A decorative window. "],
["Zen Window LBrwn Intricate",1028,2,2,1000,nil,ItemType::WALL,false,"A decorative window. "],
["Single Mirror",939,1,2,1000,nil,ItemType::WALL,false,"A single mirror that always shows a beautiful person in it. "],
["Double Mirror",940,2,2,1000,nil,ItemType::WALL,false,"A double mirror that always shows a beautiful person in it... or two? "],
["Landscape Painting Trees",954,2,2,2000,nil,ItemType::WALL,false,"A painting of a forest, painted by a local Smeargle."],
["Landscape Painting Water",956,2,2,2000,nil,ItemType::WALL,false,"A painting of the beach, painted by a local Smeargle."],
["Cuckoo Clock",901,1,2,1000,nil,ItemType::WALL,false,"A cuckoo clock. Quite annoying, but the gimmick is fun"],
["Pale Red Ladder",870,1,2,500,nil,ItemType::WALL,false,"A small red ladder. (Not for climbing)"],
["Wall Tear",203,1,1,500,nil,ItemType::WALL,false,"A tear in the wall that shows how bad you really are."],
["Light Switch",213,1,1,500,nil,ItemType::WALL,false,"A light switch. Purely cosmetic."],
["Power Outlet",221,1,1,500,nil,ItemType::WALL,false,"A power outlet. Purely cosmetic."],
["Bird Clock",278,2,2,1000,nil,ItemType::WALL,false,"Just your everyday bird clock."],
["Pokéball Art",358,1,1,500,nil,ItemType::WALL,false,"An art piece depicting a Pokéball."],
["Treecko Art",359,1,1,500,nil,ItemType::WALL,false,"An art piece depicting a Treecko."],
["Torchic Art",366,1,1,500,nil,ItemType::WALL,false,"An art piece depicting a Torchic."],
["Mudkip Art",367,1,1,500,nil,ItemType::WALL,false,"An art piece depicting a Mudkip."],
["Marill Art",374,1,1,500,nil,ItemType::WALL,false,"An art piece depicting a Marill."],
["Pikachu Art",382,2,1,500,nil,ItemType::WALL,false,"An art piece depicting a Pikachu family."],
["Map",386,2,1,500,nil,ItemType::WALL,false,"A map of a distant land."],
["Seviper Art",390,2,1,500,nil,ItemType::WALL,false,"An art piece depicting a Seviper."],
["Relicanth Art",398,2,1,500,nil,ItemType::WALL,false,"An art piece depicting a Relicanth."],
["Wingull Art",406,2,1,500,nil,ItemType::WALL,false,"An art piece depicting a Wingull."],
["Smoochum Art",414,2,1,500,nil,ItemType::WALL,false,"An art piece depicting a Smoochum."],
["Word Poster Y",440,1,1,500,nil,ItemType::WALL,false,"A yellow poster with inspirational quotes."],
["Word Poster R",448,1,1,500,nil,ItemType::WALL,false,"A red poster with inspirational quotes."],
["Word Poster B",456,1,1,500,nil,ItemType::WALL,false,"A blue poster with inspirational quotes."],
["Word Poster G",464,1,1,500,nil,ItemType::WALL,false,"A green poster with inspirational quotes."],
["Clock Y",441,1,1,500,nil,ItemType::WALL,false,"A yellow clock. "],
["Clock R",449,1,1,500,nil,ItemType::WALL,false,"A red clock. "],
["Clock B",457,1,1,500,nil,ItemType::WALL,false,"A blue clock. "],
["Clock G",465,1,1,500,nil,ItemType::WALL,false,"A green clock. "],

  #* Hobbies
["Jump Mat",128,1,1,1500,1,ItemType::HOBBIE,false,"A jump mat. Standing on it will make you jump. Who would have known?"],
["Water Balloon ",136,1,1,1000,4,ItemType::HOBBIE,false,"A small red water balloon that explodes on touch. "],
["Plate",159,1,1,600,nil,ItemType::HOBBIE,false,"An inexpensive plate for dining. "],
["Apple Juice",161,1,1,1000,nil,ItemType::HOBBIE,false,"It's apple juice ok?"],
["Bookshelf",370,2,2,1000,nil,ItemType::HOBBIE,false,"A bookshelf full of fun reading. "],
["Pokéball",381,1,1,5000,40,ItemType::HOBBIE,false,"A mysterious Pokéball, full of wonder."],
["Torchic Doll",200,1,1,1000,3,ItemType::HOBBIE,false,"A small Torchic doll."],
["Treecko Doll",200,1,1,1000,5,ItemType::HOBBIE,false,"A small Treecko doll."],
["Mudkip Doll",200,1,1,1000,6,ItemType::HOBBIE,false,"A small Mudkip doll."],
["Bonsly Doll",200,1,1,1000,18,ItemType::HOBBIE,false,"A small Bonsly doll."],
["Cyndaquil Doll",200,1,1,1000,19,ItemType::HOBBIE,false,"A small Cyndaquil doll."],
["Chikorita Doll",200,1,1,1000,20,ItemType::HOBBIE,false,"A small Chikorita doll."],
["Totodile Doll",200,1,1,1000,21,ItemType::HOBBIE,false,"A small Totodile doll."],
["Turtwig Doll",200,1,1,1000,27,ItemType::HOBBIE,false,"A small Turtwig doll."],
["Piplup Doll",200,1,1,1000,28,ItemType::HOBBIE,false,"A small Piplup doll."],
["Chimchar Doll",200,1,1,1000,29,ItemType::HOBBIE,false,"A small Chimchar doll."],
["Bulbasaur Doll",200,1,1,1000,30,ItemType::HOBBIE,false,"A small Bulbasaur doll."],
["Squirtle Doll",200,1,1,1000,31,ItemType::HOBBIE,false,"A small Squirtle doll."],
["Charmander Doll",200,1,1,1000,32,ItemType::HOBBIE,false,"A small Charmander doll."],
["Jigglypuff Doll",200,1,1,1000,33,ItemType::HOBBIE,false,"A small Jigglypuff doll."],
["Pikachu Doll",200,1,1,1000,34,ItemType::HOBBIE,false,"A small Pikachu doll."],
["Lucario Doll",200,1,1,1000,35,ItemType::HOBBIE,false,"A small Lucario doll."],
  
#Milestone

["Mew Statue",1248,2,3,0,nil,ItemType::MILESTONE,false,"A statue of Mew found in the Battle Gauntlet."],
["Electro Pad",200,1,1,0,41,ItemType::MILESTONE,false,"A pad used to transform Rotom."],
["Electro Fridge",200,1,2,0,42,ItemType::MILESTONE,false,"A fridge used to transform Rotom."],
["Electro Mower",200,1,2,0,43,ItemType::MILESTONE,false,"A mower used to transform Rotom."],
["Electro Oven",200,1,1,0,44,ItemType::MILESTONE,false,"An oven used to transform Rotom."],
["Electro Washer",200,1,1,0,45,ItemType::MILESTONE,false,"A washer used to transform Rotom."],
["Electro Fan",200,1,1,0,46,ItemType::MILESTONE,false,"A fan used to transform Rotom."],
  #* New Items
]

#===============================================================================
# ■ Holes
# There are made like items.
# [tile id, width in tiles, height in tiles]
# Holes needs to be in Layer 2.
#===============================================================================

BASEHOLES=[
  [-1],
  [7,1,2],
  [22,2,1],
  [38,2,2],
]

#===============================================================================
# ■ Script start here
# - Do not touch anything if you don't know what you're doing.
#===============================================================================
def pbGetBaseItem(item)
  $PokemonGlobal.baseItemBag[baseItemPocket(item)].push([item,false])
end

def getAllSurfaces
  items=[]
  for i in 1...SECRETBASEITEMS.length
    items.push(i) if baseItemPocket(i)==ItemType::SURFACE
  end
  return items
end

def getAllComforts
  items=[]
  for i in 1...SECRETBASEITEMS.length
    items.push(i) if baseItemPocket(i)==ItemType::COMFORT
  end
  return items
end

def getAllWalls
  items=[]
  for i in 1...SECRETBASEITEMS.length
    items.push(i) if baseItemPocket(i)==ItemType::WALL
  end
  return items
end

def getAllAppliances
  items=[]
  for i in 1...SECRETBASEITEMS.length
    items.push(i) if baseItemPocket(i)==ItemType::APPLIANCE
  end
  return items
end

def getAllFloors
  items=[]
  for i in 1...SECRETBASEITEMS.length
    items.push(i) if baseItemPocket(i)==ItemType::FLOOR
  end
  return items
end

def getAllElectronics
  items=[]
  for i in 1...SECRETBASEITEMS.length
    items.push(i) if baseItemPocket(i)==ItemType::ELECTRONIC
  end
  return items
end

def getAllHobbies
  items=[]
  for i in 1...SECRETBASEITEMS.length
    items.push(i) if baseItemPocket(i)==ItemType::HOBBIE
  end
  return items
end

def getAllMilestones
  items=[]
  for i in 1...SECRETBASEITEMS.length
    items.push(i) if baseItemPocket(i)==ItemType::MILESTONE
  end
  return items
end

class PokemonGlobalMetadata
  attr_accessor :baseinfo
  attr_accessor :baseItemBag
  attr_accessor :placedItems
  attr_accessor :mybaseid
  attr_accessor :mybaselocation
  attr_accessor :mybasetype
  attr_accessor :installed
  attr_accessor :outdoordata
  
  def baseInstalled?
    return !@installed ? false : @installed
  end
  
  def getBaseOutdoor
    return !@outdoordata ? false : @outdoordata
  end
  def getBaseId
    return !@mybaseid ? -1 : @mybaseid
  end
  
  def getBaseLocation
    return !@mybaselocation ? -1 : @mybaselocation
  end
  
  def getPlacedItems(id)
    @placedItems={} if !@placedItems
    @placedItems[id]=[] if !@placedItems[id]
    return @placedItems[id] 
  end
  
  def setPlacedInfo(id,x,y,item)
    @placedItems={} if !@placedItems
    @placedItems[id]=[] if !@placedItems[id]
    @placedItems[id].push([x,y,item])
  end
  
  def baseBag
    if !@baseItemBag
      @baseItemBag={} 
      for i in 0...BASEBAGPOCKETS.length
        @baseItemBag[i]=[] if !@baseItemBag[i]
      end
    end
  end
  
  def getBasePocket(pocket)
    baseBag
    return @baseItemBag[pocket]
  end
  
  def basePocketLength(pocket)
    baseBag
    return @baseItemBag[pocket].length
  end
  
  def notBaseData?(id)
    return false if !@baseinfo || !@baseinfo[id]
    return true
  end
  
  def setBaseInfo(id,eventlist,tiledata)
    @baseinfo={} if !@baseinfo
    @baseinfo[id].clear if @baseinfo[id]
    @baseinfo[id]=[eventlist,tiledata]
  end
end

def getMaxSecretBagPocket(pocket)
  return BASEBAGPOCKETS[pocket][1]
end

class TileDrawingHelper
  def bltTileWithSize(bitmap,cxTile,cyTile,id)
    return if !@tileset || id<384 || @tileset.disposed?
    rect=Rect.new((id - 384) % 8 * 32, (id - 384) / 8 * 32,32*cxTile,32*cyTile)
    bitmap.stretch_blt(Rect.new(0,0,32*cxTile,32*cyTile),@tileset,rect)
  end
end

def getBaseItemByName(itemname)
  for i in 0...SECRETBASEITEMS.length
    return i if baseItemName(i)==itemname
  end
end

def baseItemDesc(id)
  return SECRETBASEITEMS[id][8]
end

def baseItemEvent(id)
  return SECRETBASEITEMS[id][5]
end

def baseItemPocket(id)
  return SECRETBASEITEMS[id][6]
end

def isABoard?(id)
  return SECRETBASEITEMS[id][7]
end

def isAWall?(id)
  return SECRETBASEITEMS[id][6]==ItemType::WALL
end

def isAHobbie?(id)
  return SECRETBASEITEMS[id][6]==ItemType::HOBBIE
end

def isAMilestone?(id)
  return SECRETBASEITEMS[id][6]==ItemType::MILESTONE
end

def isAFloor?(id)
  return SECRETBASEITEMS[id][6]==ItemType::FLOOR
end

def isASurface?(id)
  return SECRETBASEITEMS[id][6]==ItemType::SURFACE
end

def baseItemName(id)
  return SECRETBASEITEMS[id][0]
end

def baseItemCost(id)
  return SECRETBASEITEMS[id][4]
end

def baseItemWidth(id)
  return SECRETBASEITEMS[id][2]*32
end

def baseItemHeight(id)
  return SECRETBASEITEMS[id][3]*32
end

def baseItemTileid(id)
  return SECRETBASEITEMS[id][1]+384
end

def getBaseItemBitmap(id)
  if baseItemEvent(id)!=nil # Load the event bitmap
    map=load_data(sprintf("Data/Map%03d.%s", ITEMSMAP,$RPGVX ? "rvdata" : "rxdata"))
    map.events.each do |i, event|
      if event.id==baseItemEvent(id)
        dollEvent=Game_BaseEvent.new(nil, event)
        dollBitmap=AnimatedBitmap.new("Graphics/Characters/"+dollEvent.character_name,
          dollEvent.character_hue)
        width = dollBitmap.width / 4
        height = dollBitmap.height / 4
        sx = dollEvent.pattern * width
        sy = (dollEvent.direction - 2) / 2 * height
        iconItem=Bitmap.new(width,height)
        iconItem.blt(0,0,dollBitmap.bitmap,Rect.new(sx,sy,width,height))
        return iconItem
       end
     end
  else # Load bitmap from tileset
    bitmap=pbGetTileset(SECRETBASETILESET)
    itemWidth=baseItemWidth(id)
    itemHeight=baseItemHeight(id)
    iconItem=Bitmap.new(itemWidth,itemHeight)
    tileId=baseItemTileid(id)
    tilehelper=TileDrawingHelper.new(bitmap,nil)
    tilehelper.bltTileWithSize(iconItem,itemWidth/32,itemHeight/32,tileId)
    return iconItem
  end
end

def pbGetBaseLocation(mapname=-1,mapid=-1)
  pbSet(mapid,$PokemonGlobal.getBaseLocation) if mapid>0
  name=pbGetMapNameFromId($PokemonGlobal.getBaseLocation) rescue ""
  pbSet(mapname,name) if mapname>0
  return [name,$PokemonGlobal.getBaseLocation]
end

class Game_Map
  alias old_setup_bases setup
  def setup(map_id)
    old_setup_bases(map_id)
    if @map_id==SECRETBASEMAP
      baselineMap
      loadSecretBaseEvents
    end
  end
  
  def isItemEvent?(event)
    return true if event!=nil && event.is_a?(Game_BaseEvent) && event.item==true
    return false
  end
 
  def baselineMap
    map_id=SECRETBASETEMPLATES[$PokemonGlobal.mybasetype][0]
    @map=load_data(sprintf("Data/Map%03d.%s", map_id,$RPGVX ? "rvdata" : "rxdata"))
    @events = {}
    for i in @map.events.keys
      @events[i] = Game_Event.new(@map_id, @map.events[i],self)
    end
  end
  
  def backToOriginal
    map_id=SECRETBASETEMPLATES[$PokemonGlobal.mybasetype][0]
    @map=load_data(sprintf("Data/Map%03d.%s", map_id,$RPGVX ? "rvdata" : "rxdata"))
    @events = {}
    for i in @map.events.keys
      @events[i] = Game_Event.new(@map_id, @map.events[i],self)
    end
    $PokemonGlobal.baseinfo[@map_id].clear
    $PokemonGlobal.baseinfo[@map_id]=nil
  end
  
  def reloadBaseEvents
    map_id=SECRETBASETEMPLATES[$PokemonGlobal.mybasetype][0]
    @map=load_data(sprintf("Data/Map%03d.%s", map_id,$RPGVX ? "rvdata" : "rxdata"))
    @events = {}
    for i in @map.events.keys
      @events[i] = Game_Event.new(@map_id, @map.events[i],self)
    end
    loadSecretBaseEvents(true)
  end
  
  def terrain_tag_id(tileid)
    return @terrain_tags[tileid]
  end
  
  def loadSecretBaseEvents(savedPositions=false)
    return if !$PokemonGlobal.notBaseData?(@map_id)
    @realdata=@map.data
    @map.data=$PokemonGlobal.baseinfo[@map_id][1]
    
    for i in 0...$PokemonGlobal.baseinfo[@map_id][0].length+1
      savedEvent=$PokemonGlobal.baseinfo[@map_id][0][i]
      next if savedEvent==nil      
      nEvent=savedEvent.rEvent
      newId=getNewId
      itemEvent=Game_BaseEvent.new(@map_id, nEvent)
      itemEvent.id=newId
      itemEvent.moveto(savedEvent.x,savedEvent.y)
      itemEvent.item=true
      itemEvent.direction=savedEvent.direction if savedPositions
      itemEvent.itemtileid=savedEvent.itemtileid
      itemEvent.rEvent=nEvent
      @events[newId] = itemEvent
    end
  end
  
  def getNewId
    newId = 1
    while $game_map.events[newId] != nil do
      newId += 1
    end
    return newId
  end
  
  def copy_event(mapid, eventid, x, y,tileid)
    map = load_data(sprintf("Data/Map%03d.rxdata", mapid))
    map.events.each do |i, event|
      if event.id == eventid
        newId=getNewId
        nEvent=event.clone # Clone the event
        # Create the new event in new map
        eMap=Game_BaseEvent.new(@map_id, nEvent)
        eMap.id=newId
        eMap.moveto(x,y)
        eMap.itemtileid=tileid
        eMap.item=true
        eMap.rEvent=nEvent
        @events[newId] = eMap
      end
    end
  end
end

# Functions for events
def movingRightToThis(event=nil)
  return $game_player.x==event.x && $game_player.y==event.y && 
  $game_player.direction==6 && $game_player.moving? &&
  (Input.press?(Input::RIGHT) || Input.trigger?(Input::RIGHT) || 
  Input.release?(Input::RIGHT))
end

def movingLeftToThis(event=nil)
  return $game_player.x==event.x && $game_player.y==event.y && 
  $game_player.direction==4 && $game_player.moving? && 
  (Input.press?(Input::LEFT) || Input.trigger?(Input::LEFT) || Input.release?(Input::LEFT))
end

def movingUpToThis(event)
  return $game_player.x==event.x && $game_player.y==event.y && 
  $game_player.direction==8 && $game_player.moving? && 
  (Input.press?(Input::UP) || Input.trigger?(Input::UP) || Input.release?(Input::UP))
end

def movingDownToThis(event=nil)
  return $game_player.x==event.x && $game_player.y==event.y && 
  $game_player.direction==2 && $game_player.moving? && 
  (Input.press?(Input::DOWN) || Input.trigger?(Input::DOWN) || Input.release?(Input::DOWN))
end

class Game_Event
  attr_accessor :rEvent
    
  def rEvent
    return !@rEvent ? false : @rEvent
  end
  
  def direction=(value)
    @direction=value
  end
end

class Game_BaseEvent < Game_Event
  attr_accessor :item
  attr_accessor :itemtileid

end

class Spriteset_Map
  attr_accessor :character_sprites
  attr_accessor :player
  
  alias old_initialize_base initialize
  def initialize(map=nil)
    old_initialize_base(map)
    @player=@playersprite
  end
end

def copyMapData
  baseEvents=[]
  for i in 0...$game_map.events.length+1
    event=$game_map.events[i]
    baseEvents.push(event) if event.is_a?(Game_BaseEvent)
  end

  $PokemonGlobal.setBaseInfo($game_map.map_id,baseEvents,$game_map.data)
end

def placeItemInBase(item,pos)
  x=pos[0]
  y=pos[1]
  width=baseItemWidth(item)/32
  height=baseItemHeight(item)/32
  
  map = load_data(sprintf("Data/Map%03d.rxdata", $game_map.map_id))
  tilesets=load_data("Data/Tilesets.rxdata")
  tileset=tilesets[map.tileset_id]  
  priorities=tileset.priorities
  passages=tileset.passages


  # Check if it's an event item
  if baseItemEvent(item)
    tileid=baseItemTileid(item)
    $game_map.copy_event(ITEMSMAP,baseItemEvent(item),x,y,tileid)
  else # Draw a tile
    for i in 0...width
      for e in 0...height
        tileid=baseItemTileid(item)+i+(e*8)
        layer=priorities[tileid]==0 ? 1 : 2
        #layer=2 if passages[tileid] & 0x80 == 0x80 # Counter
        $game_map.data[x+i,y+e,layer]=tileid
      end
    end
  end
  copyMapData
end

#===============================================================================
# PC System
#===============================================================================

class Game_Character
  def screen_x_scroll(scroll)
    return (@real_x - scroll + 3) / 4 + (Game_Map::TILE_WIDTH/2)
  end
  
  def screen_y_scroll(scroll)
    y = (@real_y - scroll + 3) / 4 + (Game_Map::TILE_HEIGHT)
    if jumping?
      if @jump_count >= @jump_peak
        n = @jump_count - @jump_peak
      else
        n = @jump_peak - @jump_count
      end
      return y - (@jump_peak * @jump_peak - n * n) / 2
    else
      return y
    end
  end
end

class DecorationMap
  attr_accessor :scroll
  def initialize(viewport)
    $scene.disposeSpritesets
    @map=load_data(sprintf("Data/Map%03d.rxdata",$game_map.map_id))
    @viewport=Viewport.new(viewport.rect.x,viewport.rect.y,viewport.rect.width,
    viewport.rect.height)
    @viewport.z=99999
    @totalscroll=[0,0]
    pbLoad
  end
  
  def pbLoad
    @scroll=[0,0]
    
    @bitmap=BitmapWrapper.new(@map.width*32,@map.height*32)
    tilesets=load_data("Data/Tilesets.rxdata")
    @tileset=tilesets[@map.tileset_id]    
    helper=TileDrawingHelper.fromTileset(@tileset)
    for y in 0...@map.height
      for x in 0...@map.width
        for z in 0..2
          id=$game_map.data[x,y,z]
          id=0 if !id
          helper.bltTile(@bitmap,x*32,y*32,id)
        end
      end
    end

    @rsprite=Sprite_Character.new(nil, $game_player)
    x=@rsprite.x-16
    y=@rsprite.y-32
    @rsprite.dispose
    
    @scroll[0]+=x-$game_player.x*32
    @scroll[1]+=y-$game_player.y*32
    
    @mapSprite=Sprite.new(@viewport)
    @mapSprite.bitmap=@bitmap
    @mapSprite.x+=@scroll[0]
    @mapSprite.y+=@scroll[1]
    @character_sprites = []
        
    for i in $game_map.events.keys.sort
      sprite=Sprite_Character.new(@viewport, $game_map.events[i])
      sprite.x=$game_map.events[i].screen_x_scroll(0)
      sprite.y=$game_map.events[i].screen_y_scroll(0)
      sprite.x+=@scroll[0]
      sprite.y+=@scroll[1]
      @character_sprites.push(sprite)
    end
    @scroll=[0,0]
  end
  
  def pbReloadTiles
    @bitmap=BitmapWrapper.new(@map.width*32,@map.height*32)
    helper=TileDrawingHelper.fromTileset(@tileset)
    for y in 0...@map.height
      for x in 0...@map.width
        for z in 0..2
          id=$game_map.data[x,y,z]
          id=0 if !id
          helper.bltTile(@bitmap,x*32,y*32,id)
        end
      end
    end
    @mapSprite.bitmap=@bitmap
  end
  
  def pbReloadEvents
    for sprite in @character_sprites
      sprite.dispose
    end
    
    @rsprite=Sprite_Character.new(nil, $game_player)
    x=@rsprite.x-16
    y=@rsprite.y-32
    @rsprite.dispose
    
    @character_sprites.clear
    for i in $game_map.events.keys.sort
      sprite=Sprite_Character.new(@viewport, $game_map.events[i])
      sprite.x=$game_map.events[i].screen_x_scroll(0)
      sprite.y=$game_map.events[i].screen_y_scroll(0)
      sprite.x+=x-$game_player.x*32+@totalscroll[0]
      sprite.y+=y-$game_player.y*32+@totalscroll[1]
      @character_sprites.push(sprite)
    end
  end
  
  def reload
    pbReloadTiles
    pbReloadEvents
  end
  
  def disposed?
    @mapSprite.disposed?
  end
  
  def color
    return @mapSprite.color
  end
  
  def color=(value)
    @mapSprite.color=value
    for sprite in @character_sprites
      sprite.color=value
    end
  end
  
  def visible
    return @mapSprite.visible
  end
  
  def visible=(value)
    @mapSprite.visible=value
    for sprite in @character_sprites
      sprite.visible=value
    end
  end
  
  def dispose
    @mapSprite.dispose
    for sprite in @character_sprites
      sprite.dispose
    end
    $scene.createSpritesets
  end
  
  def updateScrollPos
    @mapSprite.x+=@scroll[0]
    @mapSprite.y+=@scroll[1]
    for sprite in @character_sprites
      sprite.x+=@scroll[0]
      sprite.y+=@scroll[1]
    end
    @totalscroll[0]+=@scroll[0]
    @totalscroll[1]+=@scroll[1]
    @scroll=[0,0]
  end
    
end
  
def pbShowCommandsBase(msgwindow,commands=nil,cmdIfCancel=0,defaultCmd=0)
  ret=0
  if commands
    cmdwindow=Window_CommandPokemonEx.new(commands)
    cmdwindow.z=99999
    cmdwindow.visible=true
    cmdwindow.resizeToFit(cmdwindow.commands)
    pbPositionNearMsgWindow(cmdwindow,msgwindow,:right)
    cmdwindow.index=defaultCmd
    command=0
    loop do
      Graphics.update
      Input.update
      cmdwindow.update
      msgwindow.update if msgwindow
      yield if block_given?
      if Input.trigger?(Input::B)
        if cmdIfCancel>0
          command=cmdIfCancel-1
          break
        elsif cmdIfCancel<0
          command=cmdIfCancel
          break
        end
      end
      if Input.trigger?(Input::C)
        command=cmdwindow.index
        break
      end
    end
    ret=command
    cmdwindow.dispose
    Input.update
  end
  return ret
end

def pbMessageBase(message,commands=nil,cmdIfCancel=0,skin=nil,defaultCmd=0,&block)
  ret=0
  msgwindow=pbCreateMessageWindow(nil,skin)
  if commands
    ret=pbMessageDisplayBase(msgwindow,message,true,
       proc {|msgwindow|
          next pbShowCommandsBase(msgwindow,commands,cmdIfCancel,defaultCmd,&block)
    },&block)
  else
    pbMessageDisplayBase(msgwindow,message,&block)
  end
  pbDisposeMessageWindow(msgwindow)
  Input.update
  return ret
end

def pbMessageDisplayBase(msgwindow,message,letterbyletter=true,commandProc=nil)
  return if !msgwindow
  oldletterbyletter=msgwindow.letterbyletter
  msgwindow.letterbyletter=(letterbyletter ? true : false)
  ret=nil
  count=0
  commands=nil
  facewindow=nil
  goldwindow=nil
  coinwindow=nil
  cmdvariable=0
  cmdIfCancel=0
  msgwindow.waitcount=0
  autoresume=false
  text=message.clone
  msgback=nil
  linecount=(SCREEN_HEIGHT>400) ? 3 : 2
  ### Text replacement
  text.gsub!(/\\\\/,"\5")
  if $game_actors
    text.gsub!(/\\[Nn]\[([1-8])\]/){ 
       m=$1.to_i
       next $game_actors[m].name
    }
  end
  text.gsub!(/\\[Ss][Ii][Gg][Nn]\[([^\]]*)\]/){ 
     next "\\op\\cl\\ts[]\\w["+$1+"]"
  }
  text.gsub!(/\\[Pp][Nn]/,$Trainer.name) if $Trainer
  text.gsub!(/\\[Pp][Mm]/,_INTL("${1}",$Trainer.money)) if $Trainer
  text.gsub!(/\\[Nn]/,"\n")
  text.gsub!(/\\\[([0-9A-Fa-f]{8,8})\]/){ "<c2="+$1+">" }
  text.gsub!(/\\[Pp][Gg]/,"")
  text.gsub!(/\\[Pp][Oo][Gg]/,"")
  text.gsub!(/\\[Bb]/,"<c2=6546675A>")
  text.gsub!(/\\[Rr]/,"<c2=043C675A>")
  text.gsub!(/\\1/,"\1")
  colortag=""
  isDarkSkin=isDarkWindowskin(msgwindow.windowskin)
  if ($game_message && $game_message.background>0) ||
     ($game_system && $game_system.respond_to?("message_frame") &&
      $game_system.message_frame != 0)
    colortag=getSkinColor(msgwindow.windowskin,0,true)
  else
    colortag=getSkinColor(msgwindow.windowskin,0,isDarkSkin)
  end
  text.gsub!(/\\[Cc]\[([0-9]+)\]/){ 
     m=$1.to_i
     next getSkinColor(msgwindow.windowskin,m,isDarkSkin)
  }
  begin
    last_text = text.clone
    text.gsub!(/\\[Vv]\[([0-9]+)\]/) { $game_variables[$1.to_i] }
  end until text == last_text
  begin
    last_text = text.clone
    text.gsub!(/\\[Ll]\[([0-9]+)\]/) { 
       linecount=[1,$1.to_i].max;
       next "" 
    }
  end until text == last_text
  text=colortag+text
  ### Controls
  textchunks=[]
  controls=[]
  while text[/(?:\\([WwFf]|[Ff][Ff]|[Tt][Ss]|[Cc][Ll]|[Mm][Ee]|[Ss][Ee]|[Ww][Tt]|[Ww][Tt][Nn][Pp]|[Cc][Hh])\[([^\]]*)\]|\\([Gg]|[Cc][Nn]|[Ww][Dd]|[Ww][Mm]|[Oo][Pp]|[Cc][Ll]|[Ww][Uu]|[\.]|[\|]|[\!]|[\x5E])())/i]
    textchunks.push($~.pre_match)
    if $~[1]
      controls.push([$~[1].downcase,$~[2],-1])
    else
      controls.push([$~[3].downcase,"",-1])
    end
    text=$~.post_match
  end
  textchunks.push(text)
  for chunk in textchunks
    chunk.gsub!(/\005/,"\\")
  end
  textlen=0
  for i in 0...controls.length
    control=controls[i][0]
    if control=="wt" || control=="wtnp" || control=="." || control=="|"
      textchunks[i]+="\2"
    elsif control=="!"
      textchunks[i]+="\1"
    end
    textlen+=toUnformattedText(textchunks[i]).scan(/./m).length
    controls[i][2]=textlen
  end
  text=textchunks.join("")
  unformattedText=toUnformattedText(text)
  signWaitCount=0
  haveSpecialClose=false
  specialCloseSE=""
  for i in 0...controls.length
    control=controls[i][0]
    param=controls[i][1]
    if control=="f"
      facewindow.dispose if facewindow
      facewindow=PictureWindow.new("Graphics/Pictures/#{param}")
    elsif control=="op"
      signWaitCount=21
    elsif control=="cl"
      text=text.sub(/\001\z/,"") # fix: '$' can match end of line as well
      haveSpecialClose=true
      specialCloseSE=param
    elsif control=="se" && controls[i][2]==0
      startSE=param
      controls[i]=nil
    elsif control=="ff"
      facewindow.dispose if facewindow
      facewindow=FaceWindowVX.new(param)
    elsif control=="ch"
      cmds=param.clone
      cmdvariable=pbCsvPosInt!(cmds)
      cmdIfCancel=pbCsvField!(cmds).to_i
      commands=[]
      while cmds.length>0
        commands.push(pbCsvField!(cmds))
      end
    elsif control=="wtnp" || control=="^"
      text=text.sub(/\001\z/,"") # fix: '$' can match end of line as well
    end
  end
  if startSE!=nil
    pbSEPlay(pbStringToAudioFile(startSE))
  elsif signWaitCount==0 && letterbyletter
    pbPlayDecisionSE()
  end
  ########## Position message window  ##############
  pbRepositionMessageWindow(msgwindow,linecount)
  if $game_message && $game_message.background==1
    msgback=IconSprite.new(0,msgwindow.y,msgwindow.viewport)
    msgback.z=msgwindow.z-1
    msgback.setBitmap("Graphics/System/MessageBack")
  end
  if facewindow
    pbPositionNearMsgWindow(facewindow,msgwindow,:left)
    facewindow.viewport=msgwindow.viewport
    facewindow.z=msgwindow.z
  end
  atTop=(msgwindow.y==0)
  ########## Show text #############################
  msgwindow.text=text
  Graphics.frame_reset if Graphics.frame_rate>40
  begin
    if signWaitCount>0
      signWaitCount-=1
      if atTop
        msgwindow.y=-(msgwindow.height*(signWaitCount)/20)
      else
        msgwindow.y=SCREEN_HEIGHT-(msgwindow.height*(20-signWaitCount)/20)
      end
    end
    for i in 0...controls.length
      if controls[i] && controls[i][2]<=msgwindow.position && msgwindow.waitcount==0
        control=controls[i][0]
        param=controls[i][1]
        if control=="f"
          facewindow.dispose if facewindow
          facewindow=PictureWindow.new("Graphics/Pictures/#{param}")
          pbPositionNearMsgWindow(facewindow,msgwindow,:left)
          facewindow.viewport=msgwindow.viewport
          facewindow.z=msgwindow.z
        elsif control=="ts"
          if param==""
            msgwindow.textspeed=-999
          else
            msgwindow.textspeed=param.to_i
          end
        elsif control=="ff"
          facewindow.dispose if facewindow
          facewindow=FaceWindowVX.new(param)
          pbPositionNearMsgWindow(facewindow,msgwindow,:left)
          facewindow.viewport=msgwindow.viewport
          facewindow.z=msgwindow.z
        elsif control=="g" # Display gold window
          goldwindow.dispose if goldwindow
          goldwindow=pbDisplayGoldWindow(msgwindow)
        elsif control=="cn" # Display coins window
          coinwindow.dispose if coinwindow
          coinwindow=pbDisplayCoinsWindow(msgwindow,goldwindow)
        elsif control=="wu"
          msgwindow.y=0
          atTop=true
          msgback.y=msgwindow.y if msgback
          pbPositionNearMsgWindow(facewindow,msgwindow,:left)
          msgwindow.y=-(msgwindow.height*(signWaitCount)/20)
        elsif control=="wm"
          atTop=false
          msgwindow.y=(SCREEN_HEIGHT/2)-(msgwindow.height/2)
          msgback.y=msgwindow.y if msgback
          pbPositionNearMsgWindow(facewindow,msgwindow,:left)
        elsif control=="wd"
          atTop=false
          msgwindow.y=(SCREEN_HEIGHT)-(msgwindow.height)
          msgback.y=msgwindow.y if msgback
          pbPositionNearMsgWindow(facewindow,msgwindow,:left)
          msgwindow.y=SCREEN_HEIGHT-(msgwindow.height*(20-signWaitCount)/20)
        elsif control=="."
          msgwindow.waitcount+=Graphics.frame_rate/4
        elsif control=="|"
          msgwindow.waitcount+=Graphics.frame_rate
        elsif control=="wt" # Wait
          param=param.sub(/\A\s+/,"").sub(/\s+\z/,"")
          msgwindow.waitcount+=param.to_i*2
        elsif control=="w" # Windowskin
          if param==""
            msgwindow.windowskin=nil
          else
            msgwindow.setSkin("Graphics/Windowskins/#{param}")
          end
          msgwindow.width=msgwindow.width  # Necessary evil
        elsif control=="^" # Wait, no pause
          autoresume=true
        elsif control=="wtnp" # Wait, no pause
          param=param.sub(/\A\s+/,"").sub(/\s+\z/,"")
          msgwindow.waitcount=param.to_i*2
          autoresume=true
        elsif control=="se" # Play SE
          pbSEPlay(pbStringToAudioFile(param))
        elsif control=="me" # Play ME
          pbMEPlay(pbStringToAudioFile(param))
        end
        controls[i]=nil
      end
    end
    break if !letterbyletter
    Graphics.update
    Input.update
    facewindow.update if facewindow
    if $DEBUG && Input.trigger?(Input::F6)
      pbRecord(unformattedText)
    end
    if autoresume && msgwindow.waitcount==0
      msgwindow.resume if msgwindow.busy?
      break if !msgwindow.busy?
    end
    if (Input.trigger?(Input::C) || Input.trigger?(Input::B))
      if msgwindow.busy?
        pbPlayDecisionSE() if msgwindow.pausing?
        msgwindow.resume
      else
        break if signWaitCount==0
      end
    end
    msgwindow.update
    yield if block_given?
  end until (!letterbyletter || commandProc || commands) && !msgwindow.busy?
  Input.update # Must call Input.update again to avoid extra triggers
  msgwindow.letterbyletter=oldletterbyletter
  if commands
    $game_variables[cmdvariable]=pbShowCommands(
       msgwindow,commands,cmdIfCancel)
    $game_map.need_refresh = true if $game_map
  end
  if commandProc
    ret=commandProc.call(msgwindow)
  end
  msgback.dispose if msgback
  goldwindow.dispose if goldwindow
  coinwindow.dispose if coinwindow
  facewindow.dispose if facewindow
  if haveSpecialClose
    pbSEPlay(pbStringToAudioFile(specialCloseSE))
    atTop=(msgwindow.y==0)
    for i in 0..20
      if atTop
        msgwindow.y=-(msgwindow.height*(i)/20)
      else
        msgwindow.y=SCREEN_HEIGHT-(msgwindow.height*(20-i)/20)
      end
      Graphics.update
      Input.update
      msgwindow.update
    end
  end
  return ret
end

def pbConfirmMessageBase(message,&block)
  return (pbMessageBase(message,[_INTL("Yes"),_INTL("No")],2,&block)==0)
end

class PokemonDecoration
  def initialize; end
  
  def pbStartScene
    @viewport=Viewport.new(0,0,Graphics.width,SCREEN_HEIGHT)
    @viewport.z=999999
    @sprites={}
  end
  
  def getSecretArrow
    bitmapname=_INTL("Graphics/Pictures/SecretBases/secretBaseArrow{1}",$Trainer.metaID)
    return BitmapCache.load_bitmap(bitmapname)
  end
  
  def getMapPassable(x,y)
    for event in $game_map.events.values
      return false if event.x==x && event.y==y
    end
    if $game_map.data[x,y,0]
      return false if isWallWall($game_map.data[x,y,0])
    end
    return $game_map.passable?(x,y,0)
  end
  
  def isWallWall(tileid)
    #map = load_data(sprintf("Data/Map%03d.rxdata", $game_map.map_id))
    #tilesets=load_data("Data/Tilesets.rxdata")
    #tileset=tilesets[map.tileset_id]  
    #priorities=tileset.priorities
    #passages=tileset.passages
    #pass=[]
    #pass[0]=passages[tileid] & 0x01 == 0x01 # Down arrow
    #pass[1]=passages[tileid] & 0x02 == 0x02 # Left arrow
    #pass[2]=passages[tileid] & 0x04 == 0x04 # Up arrow
    #pass[3]=passages[tileid] & 0x08 == 0x08 # Up arrow
    #if pass[0]==true && pass[1]==false && 
    #  pass[2]==false && pass[3]==false
    #  return true
    #end
    if $game_map.terrain_tag_id(tileid)==WALLTERRAINTAG
      return true
    end
    return false
  end

  def canPlaceItem?(item,pos)
    map = load_data(sprintf("Data/Map%03d.rxdata", $game_map.map_id))
    tilesets=load_data("Data/Tilesets.rxdata")
    tileset=tilesets[map.tileset_id]  
    priorities=tileset.priorities
    passages=tileset.passages
    width=baseItemWidth(item)/32
    height=baseItemHeight(item)/32
        
    # Do not put anything above player!
    for w in 0...width
      for h in 0...height
        tileid=baseItemTileid(item)+w+(h*8)
        notblocked=passages[tileid] & 0x0f == 0x0f
        if notblocked && pos[0]+w==$game_player.x && pos[1]+h==$game_player.y
          return false 
        end
      end
    end
    # Avoids to put items above others 
    if !HOBBIESEVERYWHERE && !(isAHobbie?(item) || isAMilestone?(item))
      for e in 0...height
        tileid=baseItemTileid(item)+(e*8)
        prio=priorities[tileid]
        #prio=1 if passages[tileid] & 0x80 == 0x80
        next if prio>0
        for i in 0...width
           tileid=baseItemTileid(item)+i+(e*8)
           prio=priorities[tileid]
           #prio=1 if passages[tileid] & 0x80 == 0x80
           pass=passages[tileid] & 0x0f == 0x0f
           if $game_map.data[pos[0]+i,pos[1]+e,1]!=0 && prio==0
             # Check for holes
             isahole=thereIsAHole?([pos[0]+i,pos[1]+e])
             if isahole && isABoard?(item)
               holewidth=isahole[0]
               holeheight=isahole[1]
               positions=getTopLeftWithATileHole([pos[0]+i,pos[1]+e])
               if positions[0]==pos[0] && positions[1]==pos[1] &&
                  holewidth==width && holeheight==height
                  return true
               end
             end
           return false
           elsif $game_map.data[pos[0]+i,pos[1]+e,2]!=0 && prio==0
             topleft=getTopLeftWithATile(pos)   
             if !topleft.is_a?(Range)
               if pos[1]+e!=topleft[1]
                 return false
               end
             end
           end
         end
       end
     end
    # Check if it's a poster
    if isAWall?(item) 
      putInWall=true
      for i in 0...width
        for e in 0...height
          tileid=baseItemTileid(item)+i+(e*8)
            for w in 0...width
              for h in 0...height
                alreadyp=$game_map.data[pos[0]+w,pos[1]+h,1]
                newp=isWallWall($game_map.data[pos[0]+w,pos[1]+h,0])
                if !newp || alreadyp>0
                  putInWall=false 
                end
              end
            end
            return true if putInWall 
          return false
        end
      end
    # Placing dolls only in mats and counter tiles
    elsif isAHobbie?(item) || isAMilestone?(item)
      placed=getItemIn(pos)
      # If it's a mat or a counter tile and it's not an interactive one
      if isAFloor?(placed) && baseItemEvent(placed)==nil
        return true
      elsif isASurface?(placed) && baseItemEvent(placed)==nil
        tileid=$game_map.data[pos[0],pos[1],1] 
        counter=passages[tileid] & 0x80 == 0x80
        return true if counter  
      elsif HOBBIESEVERYWHERE
        newp=getMapPassable(pos[0],pos[1])
        if $game_map.terrain_tag(pos[0],pos[1])==GROUNDDECORATION
            return false # Avoid to put tiles in layer 0 decorations
        end
        return true if newp
      end
    return false
    else
      for i in 0...width
        for e in 0...height
          tileid=baseItemTileid(item)+i+(e*8)
          prio=priorities[tileid]
          pass=passages[tileid] & 0x0f == 0x0f
          mappass=getMapPassable(pos[0]+i,pos[1]+e)
          upasable=true
          #counter=passages[tileid] & 0x80 == 0x80
          
          # Is first line passable?
          (0...width).each do |w| 
            np=getMapPassable(pos[0]+w,pos[1])
            upasable=false if !np
          end
          
          # Make counter tiles priorities
          if counter
            upasable=false 
            prio=1
          end
          
          if !upasable && prio>0
            (0...height).each do |h|
              (0...width).each do |w|
                # Tile to place data
                tileplace=baseItemTileid(item)+w+(h*8)
                tileprio=priorities[tileplace]
                placep=passages[tileplace] & 0x0f == 0x0f
                counter=passages[tileplace] & 0x80 == 0x80
                #tileprio=1 if counter
                # Tile in map data
                if tileprio==0 && $game_map.terrain_tag(pos[0]+w,pos[1]+h)==GROUNDDECORATION
                  return false # Avoid to put tiles in layer 0 decorations
                end
                newp=getMapPassable(pos[0]+w,pos[1]+h)
                return false if h==0 && !newp && tileprio==0
                return false if h>0 && !newp
              end
            end
            return true
          elsif mappass
            for w in 0...width
              for h in 0...height
                tileplace=baseItemTileid(item)+w+(h*8)
                newp=getMapPassable(pos[0]+w,pos[1]+h)
                tileprio=priorities[tileplace]
                if tileprio==0 && $game_map.terrain_tag(pos[0]+w,pos[1]+h)==GROUNDDECORATION
                  return false # Avoid to put tiles in layer 0 decorations
                end                
                #tileprio=1 if passages[tileplace] & 0x80 == 0x80
                return false if !newp 
              end
            end
            return true 
          end
        end
      end
    end
    return false
  end
    
  # Get a placed item
  def getItemIn(pos)
    x=@pos[0]
    y=@pos[1]
    for i in 1...SECRETBASEITEMS.length
      thisId=baseItemTileid(i)
      width=baseItemWidth(i)/32
      height=baseItemHeight(i)/32
      (0...height).each do |h|
        (0...width).each do |w|
          actualTile=baseItemTileid(i)+w+(h*8)
          for l in 0...3
            if actualTile==$game_map.data[x,y,l]
              return i
            end
          end
        end
      end
    end
  end
  
  def getTopLeftWithATileHole(pos)
    x=pos[0]
    y=pos[1]
    for i in 1...BASEHOLES.length
      thisId=BASEHOLES[i][0]+384
      width=BASEHOLES[i][1]
      height=BASEHOLES[i][2]
      (0...height).each do |h|
        (0...width).each do |w|
          actualTile=(BASEHOLES[i][0]+384)+w+(h*8)
          for l in 0...3
            # Get top item
            if actualTile==$game_map.data[x,y,l]
              return getTopLeftHole(i,actualTile,x,y)
            end
          end
        end
      end
    end
    return false
  end
  
  def getTopLeftHole(item,actualTile,x,y)
    width=BASEHOLES[item][1]
    height=BASEHOLES[item][2]
    (0...height).each do |h|
      (0...width).each do |w|
         if (BASEHOLES[item][0]+384)+w+(h*8)==actualTile
           x-=w
           y-=h
         end
      end
    end
    return [x,y]
  end
  
  def thereIsAHole?(pos)
    x=pos[0]
    y=pos[1]
    for i in 1...BASEHOLES.length
      thisId=BASEHOLES[i][0]+384
      width=BASEHOLES[i][1]
      height=BASEHOLES[i][2]
      (0...height).each do |h|
        (0...width).each do |w|
          actualTile=(BASEHOLES[i][0]+384)+w+(h*8)
          for l in 0...3
            # Get top item
            if actualTile==$game_map.data[x,y,l]
              return [width,height]
            end
          end
        end
      end
    end
    return false
  end
  
  # Get top left position of a tiled item
  def getTopLeftWithATile(pos)
    x=@pos[0]
    y=@pos[1]
    for i in 1...SECRETBASEITEMS.length
      thisId=baseItemTileid(i)
      width=baseItemWidth(i)/32
      height=baseItemHeight(i)/32
       
      (0...height).each do |h|
        (0...width).each do |w|
          actualTile=baseItemTileid(i)+w+(h*8)
          for l in 0...3
            # Get top item
            if actualTile==$game_map.data[x,y,l]
              return getTopLeft(i,actualTile,x,y)
            end
          end
        end
      end
    end
  end
  
  # Delete items
  def deleteItemIn(pos,delete=true)
    x=pos[0]
    y=pos[1]
    isEvent=false

    for i in 1...SECRETBASEITEMS.length
       thisId=baseItemTileid(i)
       width=baseItemWidth(i)/32
       height=baseItemHeight(i)/32
       # Check if there's an event
       for event in $game_map.events.values
          if !isEvent && event.is_a?(Game_BaseEvent) && event.x==x && event.y==y
            isEvent=true
            itemEvent=event
          end
        end
        if isEvent
          return true if !delete 
          deleteEvent(@pos)
          return
        else
        (0...height).each do |h|
          (0...width).each do |w|
            actualTile=baseItemTileid(i)+w+(h*8)
            # Get top item
            tileMiddle=$game_map.data[x,y,1]
            tileTop=$game_map.data[x,y,2]
            # Delete top tile
            if tileTop>0 && actualTile==tileTop
              return true if !delete
              # Delete item
              topleft=getTopLeft(i,actualTile,x,y)
              deleteTiledItem(i,topleft)
              return
            # Delete middle tile
            elsif actualTile==tileMiddle && tileTop==0 
              return true if !delete
              topleft=getTopLeft(i,actualTile,x,y)
               # Delete item
              if isABoard?(i) && 
                $game_player.x>=topleft[0] && $game_player.x<topleft[0]+width &&
                $game_player.y>=topleft[1] && $game_player.y<topleft[1]+height
                pbMessageBase("You can't delete this right now.")
              else
                deleteTiledItem(i,topleft)
              end
              return
            end
          end
        end
      end
    end
    return false if !delete
  end
  
  # Delete event
  def deleteEvent(pos)
    x=pos[0]
    y=pos[1]
    for event in $game_map.events.values
      if event.x==x && event.y==y
        thisEvent=event
      end
    end
    
    return if thisEvent==nil
    
    # Back item to PC
    placedInfo=$PokemonGlobal.getPlacedItems($game_map.map_id)
    for i in 0...placedInfo.length
      actualItem=placedInfo[i]
      if actualItem[0]==x && actualItem[1]==y &&
      baseItemTileid(actualItem[2][0])==thisEvent.itemtileid
        actualItem[2][1]=false 
      end
    end

    savedEvent=$PokemonGlobal.baseinfo[$game_map.map_id][0]
    for i in 0...savedEvent.length+1
      next if savedEvent[i]==nil
      if savedEvent[i]==thisEvent
        savedEvent[i]=nil
        savedEvent.compact!
        
        $game_map.reloadBaseEvents
        copyMapData
        return
      end
    end
  end
  
  # Delete a tiled item
  def deleteTiledItem(item,pos)
    x=pos[0]
    y=pos[1]
    width=baseItemWidth(item)/32
    height=baseItemHeight(item)/32
    map_id=SECRETBASETEMPLATES[$PokemonGlobal.mybasetype][0]
    map = load_data(sprintf("Data/Map%03d.%s", map_id,$RPGVX ? "rvdata" : "rxdata"))
    tilesets=load_data("Data/Tilesets.rxdata")
    tileset=tilesets[map.tileset_id]  
    priorities=tileset.priorities
    passages=tileset.passages
    
    # Back item to PC
    placedInfo=$PokemonGlobal.getPlacedItems($game_map.map_id)
    for i in 0...placedInfo.length
      actualItem=placedInfo[i]
      if actualItem[0]==x && actualItem[1]==y &&
        baseItemTileid(actualItem[2][0])==baseItemTileid(item)
        actualItem[2][1]=false 
      end
    end
    
    (0...height).each do |h|
      (0...width).each do |w|
        tileid=baseItemTileid(item)+w+(h*8)
        layer=priorities[tileid]==0 ? 1 : 2
        #layer=2 if passages[tileid] & 0x80 == 0x80
        # Delete also decorations over a mat or a desk
        if (isAFloor?(item) || isASurface?(item)) && baseItemEvent(item)==nil
          deleteEvent([x+w,y+h])
        end
        $game_map.data[x+w,y+h,layer]=map.data[x+w,y+h,layer]
      end
    end
  end
  
  # Get top left for deleting
  def getTopLeft(item,actualTile,x,y)
    width=baseItemWidth(item)/32
    height=baseItemHeight(item)/32
    (0...height).each do |h|
      (0...width).each do |w|
         if baseItemTileid(item)+w+(h*8)==actualTile
           x-=w
           y-=h
         end
      end
    end
    return [x,y]
  end
  
  def pbCreatePutAway
    @sprites["map"]=DecorationMap.new(@viewport)
    @sprites["item"]=ItemBaseSprite.new(@viewport)
    @sprites["item"].bitmap=RPG::Cache.picture("SecretBases/secretBaseDeleter")
    
    @rsprite=Sprite_Character.new(nil, $game_player)
    x=@rsprite.x-16
    y=@rsprite.y-32
    @rsprite.dispose
    
    @sprites["item"].x=x
    @sprites["item"].y=y
    
    @pos=[$game_player.x,$game_player.y]
    @sprites["arrow"]=Sprite.new(@viewport)
    @sprites["arrow"].bitmap=getSecretArrow
    @sprites["arrow"].oy=@sprites["arrow"].bitmap.height
    @sprites["arrow"].x=@sprites["item"].x+@sprites["item"].bitmap.width
    @sprites["arrow"].y=@sprites["item"].y+@sprites["item"].bitmap.height
    
    @sprites["item"].update
  end
  
  def pbPutAway
    loop do 
      Graphics.update
      Input.update
      @sprites["item"].update
      if Input.trigger?(Input::UP)
        @sprites["map"].scroll[1]+=32
        @sprites["map"].updateScrollPos
        @pos[1]-=1
      elsif Input.trigger?(Input::DOWN)
        @sprites["map"].scroll[1]-=32
        @sprites["map"].updateScrollPos
        @pos[1]+=1
      elsif Input.trigger?(Input::RIGHT)
        @sprites["map"].scroll[0]-=32
        @sprites["map"].updateScrollPos
        @pos[0]+=1
      elsif Input.trigger?(Input::LEFT)
        @sprites["map"].scroll[0]+=32
        @sprites["map"].updateScrollPos
        @pos[0]-=1
      elsif Input.trigger?(Input::C)
        @sprites["item"].makeVisible
        if !deleteItemIn(@pos,false)
          pbMessageBase("There is no decoration item here.")
        else
          if pbConfirmMessageBase("Return this decoration to the PC?")
            deleteItemIn(@pos)
            @sprites["map"].reload
          end
        end
      elsif Input.trigger?(Input::B)
        break
      end
    end
    @sprites["item"].dispose
    @sprites["arrow"].dispose
    @sprites["map"].dispose
  end

  def pbCreatePlaceItem(item)
    @placed=false
  
    @sprites["map"]=DecorationMap.new(@viewport)
    @sprites["item"]=ItemBaseSprite.new(@viewport)
    @sprites["item"].bitmap=getBaseItemBitmap(item[0])
        
    @rsprite=Sprite_Character.new(nil, $game_player)
    x=@rsprite.x-16
    y=@rsprite.y-32
    @rsprite.dispose
    
    @sprites["item"].x=x
    @sprites["item"].y=y
    
    if baseItemEvent(item[0])!=nil
      @sprites["item"].ox=@sprites["item"].bitmap.width/2-16
      @sprites["item"].oy=@sprites["item"].bitmap.height-32
    end

    @pos=[$game_player.x,$game_player.y]
    @sprites["arrow"]=Sprite.new(@viewport)
    @sprites["arrow"].bitmap=getSecretArrow
    @sprites["arrow"].oy=@sprites["arrow"].bitmap.height
    @sprites["arrow"].x=@sprites["item"].x+@sprites["item"].bitmap.width
    @sprites["arrow"].y=@sprites["item"].y+@sprites["item"].bitmap.height
    
    @sprites["arrow"].x-=@sprites["item"].ox
    @sprites["arrow"].y-=@sprites["item"].oy
    @sprites["item"].update
  end
  
  def pbPlaceItem(item)
    loop do 
      Graphics.update
      Input.update
      @sprites["item"].update
      if Input.trigger?(Input::UP)
        @sprites["map"].scroll[1]+=32
        @sprites["map"].updateScrollPos
        @pos[1]-=1
      elsif Input.trigger?(Input::DOWN)
        @sprites["map"].scroll[1]-=32
        @sprites["map"].updateScrollPos
        @pos[1]+=1
      elsif Input.trigger?(Input::RIGHT)
        @sprites["map"].scroll[0]-=32
        @sprites["map"].updateScrollPos
        @pos[0]+=1
      elsif Input.trigger?(Input::LEFT)
        @sprites["map"].scroll[0]+=32
        @sprites["map"].updateScrollPos
        @pos[0]-=1
      elsif Input.trigger?(Input::C)
        @sprites["item"].makeVisible
        if canPlaceItem?(item[0],@pos)
          placeItemInBase(item[0],@pos)
          $PokemonGlobal.setPlacedInfo($game_map.map_id,@pos[0],@pos[1],item)
          @placed=true
          break
        else
          pbMessageBase("It can't be placed here.")
        end
      elsif Input.trigger?(Input::B)
        @placed=false
        break
      end
    end
    @sprites["item"].dispose
    @sprites["arrow"].dispose
    @sprites["map"].dispose

    return @placed
  end
  
end

####### Bitmap save
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
####################

class ItemBaseSprite < RPG::Sprite
  def initialize(*args)
    super
    @frameEffect=0
  end
  
  def makeVisible
    self.visible=true
    @frameEffect=0
  end
  
  def update
    super
    @frameEffect+=1
    if @frameEffect==12
      self.visible=false
    elsif @frameEffect==24
      self.visible=true
      @frameEffect=0
    end
  end
end
class Window_PocketsList < Window_DrawableCommand
  attr_accessor :stock

  def initialize(stock,x,y,width,height,viewport=nil)
    @stock=stock
    super(x,y,width,height,viewport)
    @baseColor=Color.new(88,88,80)
    @shadowColor=Color.new(168,184,184)
    @commands=@stock
  end

  def itemsInPocket
    return @stock[self.index][1]>0
  end
  
  def itemCount
    return @stock.length
  end
  
  def drawItem(index,count,rect)
    pbSetSystemFont(self.contents) if @starting
    rect=drawCursor(index,rect)
    if index!=@stock.length-1
      maxitems=@stock[index][2]
      items=@stock[index][1]
      pbDrawTextPositions(self.contents,[
      [_INTL("{1}/{2}",items,maxitems),rect.width,rect.y,1,self.baseColor,self.shadowColor]
      ])
    end
    pbDrawShadowText(self.contents,rect.x,rect.y,rect.width,rect.height,
       @stock[index][0],self.baseColor,self.shadowColor)
  end
end

class Window_ItemListBase < Window_DrawableCommand
  def initialize(stock,x,y,width,height,viewport=nil)
    @stock=stock
    @itemUsing=AnimatedBitmap.new("Graphics/Pictures/SecretBases/secretBaseUsing")
    super(x,y,width,height,viewport)
    @baseColor=Color.new(88,88,80)
    @shadowColor=Color.new(168,184,184)
  end

  def itemCount
    return @stock.length
  end

  def item
    return self.index==itemCount-1 ? 0 : @stock[self.index][0]
  end
  
  def drawItem(index,count,rect)
    textpos=[]
    rect=drawCursor(index,rect)
    ypos=rect.y
    if index==itemCount-1
      itemname=@stock[index]
    else
      itemname=baseItemName(@stock[index][0])
      if @stock[index][1]
        pbCopyBitmap(self.contents,@itemUsing.bitmap,rect.width-16,ypos+6)
      end
    end
    textpos.push([itemname,rect.x,ypos+2,false,self.baseColor,self.shadowColor])
    pbDrawTextPositions(self.contents,textpos)
  end
end

class DecorateItem
  def initialize
    commands=[]
    ret=-1
    for i in 0...BASEBAGPOCKETS.length
      pocket=BASEBAGPOCKETS[i]
      items=$PokemonGlobal.basePocketLength(i)
      commands.push([pocket[0],items,pocket[1]])
    end
    commands.push(["Cancel",-1,-1])
    cmdwindow=Window_PocketsList.new(commands,0,0,Graphics.width/2,SCREEN_HEIGHT)
    cmdwindow.z=99999
    cmdwindow.visible=true
    cmdwindow.index=0
    loop do
      Graphics.update
      Input.update
      cmdwindow.update
      if Input.trigger?(Input::C)
        break if cmdwindow.index==cmdwindow.stock.length-1
        if !cmdwindow.itemsInPocket
          cmdwindow.visible=false
          pbMessage("There are no decorations.")
          cmdwindow.visible=true
        else
          ret=cmdwindow.index 
          break
        end
      elsif Input.trigger?(Input::B)
        ret=-1
        break
      end
    end
    cmdwindow.dispose 
    itemList(ret) if ret!=-1
  end
  
  def pbPrepareWindow(window)
    window.visible=true
    window.letterbyletter=false
  end

  def itemList(pocket)
    ret=-1
    pocket=$PokemonGlobal.getBasePocket(pocket)
    items=[] 
    for i in 0...pocket.length
      items.push(pocket[i])
    end
    items.push("Cancel")
    cmdwindow=Window_ItemListBase.new(items,0,0,Graphics.width/2,SCREEN_HEIGHT)
    cmdwindow.index=0
    cmdwindow.refresh
    oldindex=cmdwindow.index
    desc=cmdwindow.item>0 ? baseItemDesc(cmdwindow.item) : 
    "Go back to the previous menu."
    descwindow=Window_AdvancedTextPokemon.new(desc)
    pbPrepareWindow(descwindow)
    descwindow.visible=true
    descwindow.x=Graphics.width/2
    descwindow.y=SCREEN_HEIGHT-128
    descwindow.width=Graphics.width/2
    descwindow.height=128
    descwindow.baseColor=Color.new(88,88,80)
    descwindow.shadowColor=Color.new(168,184,184)

    loop do
      Graphics.update
      Input.update
      cmdwindow.update
      if oldindex!=cmdwindow.index
        desc=cmdwindow.item>0 ? baseItemDesc(cmdwindow.item) : 
        "Go back to the previous menu."        
        descwindow.text=desc
        oldindex=cmdwindow.index
      end
      
      if Input.trigger?(Input::C)
        if cmdwindow.index==cmdwindow.itemCount-1
          ret=-1
          break
        else
          if pocket[cmdwindow.index][1]
            descwindow.visible=false
            cmdwindow.visible=false
            pbMessage("This is in use already.")
            descwindow.visible=true
            cmdwindow.visible=true
          else
            ret=cmdwindow.index
            break
          end
        end
      elsif Input.trigger?(Input::B)
        ret=-1
        break
      end
    end
    cmdwindow.dispose
    descwindow.dispose
    if ret!=-1
      startDecoration(pocket[ret],ret)
    else
      initialize
    end
  end

  def startDecoration(item,itemnum)
    scene=PokemonDecoration.new
    scene.pbStartScene
    scene.pbCreatePlaceItem(item)
    placed=scene.pbPlaceItem(item)
    
    if placed
      item[1]=true
    end
    initialize 
  end
end

class TossItem
  def initialize
    commands=[]
    ret=-1
    for i in 0...BASEBAGPOCKETS.length
      pocket=BASEBAGPOCKETS[i]
      items=$PokemonGlobal.basePocketLength(i)
      commands.push([pocket[0],items,pocket[1]])
    end
    commands.push(["Cancel",-1,-1])
    cmdwindow=Window_PocketsList.new(commands,0,0,Graphics.width/2,SCREEN_HEIGHT)
    cmdwindow.z=99999
    cmdwindow.visible=true
    cmdwindow.index=0
    loop do
      Graphics.update
      Input.update
      cmdwindow.update
      if Input.trigger?(Input::C)
        break if cmdwindow.index==cmdwindow.stock.length-1
        if !cmdwindow.itemsInPocket
          cmdwindow.visible=false
          pbMessage("There are no decorations.")
          cmdwindow.visible=true
        else
          ret=cmdwindow.index 
          break
        end
      elsif Input.trigger?(Input::B)
        ret=-1
        break
      end
    end
    cmdwindow.dispose 
    itemList(ret) if ret!=-1
  end
  
  def pbPrepareWindow(window)
    window.visible=true
    window.letterbyletter=false
  end

  def itemList(pocketr)
    ret=-1
    pocket=$PokemonGlobal.getBasePocket(pocketr)
    items=[] 
    for i in 0...pocket.length
      items.push(pocket[i])
    end
    items.push("Cancel")
    cmdwindow=Window_ItemListBase.new(items,0,0,Graphics.width/2,SCREEN_HEIGHT)
    cmdwindow.index=0
    cmdwindow.refresh
    oldindex=cmdwindow.index
    desc=cmdwindow.item>0 ? baseItemDesc(cmdwindow.item) : 
    "Go back to the previous menu."
    descwindow=Window_AdvancedTextPokemon.new(desc)
    pbPrepareWindow(descwindow)
    descwindow.visible=true
    descwindow.x=Graphics.width/2
    descwindow.y=SCREEN_HEIGHT-128
    descwindow.width=Graphics.width/2
    descwindow.height=128
    descwindow.baseColor=Color.new(88,88,80)
    descwindow.shadowColor=Color.new(168,184,184)

    loop do
      Graphics.update
      Input.update
      cmdwindow.update
      if oldindex!=cmdwindow.index
        desc=cmdwindow.item>0 ? baseItemDesc(cmdwindow.item) : 
        "Go back to the previous menu."        
        descwindow.text=desc
        oldindex=cmdwindow.index
      end
      
      if Input.trigger?(Input::C)
        if cmdwindow.index==cmdwindow.itemCount-1
          ret=-1
          break
        else
          if pocket[cmdwindow.index][1]
            descwindow.visible=false
            cmdwindow.visible=false
            pbMessage("This decoration is in use.\nIt can't be thrown away.")
            descwindow.visible=true
            cmdwindow.visible=true
          else
            ret=cmdwindow.index
            break
          end
        end
      elsif Input.trigger?(Input::B)
        ret=-1
        break
      end
    end
    
     cmdwindow.dispose
     descwindow.dispose

    if ret!=-1 # Item selected
      n=$PokemonGlobal.getBasePocket(pocketr)
      itemname=baseItemName(n[ret][0])
      if pbConfirmMessage(_INTL("This {1} will be discarded\nIs that okay?",itemname))
        n.delete_at(ret)
        pbMessage("The decoration item was thrown away.")
        itemList(pocketr)
      else
      initialize # Back 
      end
    else # Back
      initialize
    end
    
  end

end

class DecorationPC
  def shouldShow?
    return true
  end

  def access
    loop do
      command=pbShowCommandsWithHelp(nil,
         [_INTL("Decorate"),
         _INTL("Put away"),
         _INTL("Toss"),
         _INTL("Cancel")],
         [_INTL("Put out the selected decoration item."),
         _INTL("Store the chosen decoration in the PC."),
         _INTL("Throw away unwanted decorations."),
         _INTL("Go back to the previous menu.")],-1
      )
      if command==0
         scene=DecorateItem.new     
      elsif command==1
         scene=PokemonDecoration.new
         scene.pbStartScene
         scene.pbCreatePutAway
         scene.pbPutAway
      elsif command==2
         scebe=TossItem.new
      else
        break
      end
    end
  end
end

class PackUpPC
  def shouldShow?
    return true
  end

  def packup(eventid)
    #$scene.disposeSpritesets
    # Reload the original map data
    $game_map.backToOriginal
    
    # Back all items to pc
    for p in 0...BASEBAGPOCKETS.length
      pocket=$PokemonGlobal.getBasePocket(p)
      for i in 0...pocket.length
        pocket[i][1]=false
      end
    end
    #$scene.createSpritesets
    
    $PokemonGlobal.installed=false
    $PokemonGlobal.mybaseid=-1
    $PokemonGlobal.mybaselocation=-1
    $PokemonGlobal.mybasetype=""
    $game_map.need_refresh=true
    pbFadeOutIn(99999){
      $game_temp.player_transferring   = true
      $game_temp.transition_processing = true
      $game_temp.player_new_map_id    = $PokemonGlobal.outdoordata[0]
      $game_temp.player_new_x         = $PokemonGlobal.outdoordata[1]
      $game_temp.player_new_y         = $PokemonGlobal.outdoordata[2]
      $game_temp.player_new_direction = 2
      $scene.transfer_player
    }
  end
  
  def access
    pbMessage(_INTL("All decorations and furniture in your home will be returned to your PC.\1"))
    if !pbConfirmMessage(
      _INTL("Is that okay?"))
      return false
    end
    return true
  end
end

def pbSecretBasePC
  copyMapData
  pbMessage(_INTL("\\se[accesspc]{1} booted up the PC.",$Trainer.name))
  loop do
    commands=[_INTL("Decoration"),_INTL("Pack up"),_INTL("Exit")]
    command=pbMessage(_INTL("What would you like to do?"),
       commands,commands.length)
    if command==0
      scene=DecorationPC.new
      scene.access
    elsif command==1
      scene=PackUpPC.new
      if scene.access
        scene.packup(get_character(0).id)
        break
      end
    else
      pbSEPlay("computerclose")
      break
    end
  end
  copyMapData
end

#===============================================================================
# Mart system
#===============================================================================

class Window_BaseMart < Window_DrawableCommand
  def initialize(stock,x,y,width,height,viewport=nil)
    @stock=stock
    super(x,y,width,height,viewport)
    @baseColor=Color.new(88,88,80)
    @shadowColor=Color.new(168,184,184)
    self.windowskin=nil
  end

  def itemCount
    return @stock.length+1
  end

  def item
    return self.index>=@stock.length ? 0 : @stock[self.index]
  end

  def getDisplayPrice(id)
    price=baseItemCost(id)
    return _ISPRINTF("${1:d}",price)
  end
  
  def drawItem(index,count,rect)
    textpos=[]
    rect=drawCursor(index,rect)
    ypos=rect.y
    if index==count-1
      textpos.push([_INTL("CANCEL"),rect.x,ypos+2,false,
         self.baseColor,self.shadowColor])
    else
      item=@stock[index]
      itemname=baseItemName(item)
      qty=getDisplayPrice(item)
      sizeQty=self.contents.text_size(qty).width
      xQty=rect.x+rect.width-sizeQty-2-16
      textpos.push([itemname,rect.x,ypos+2,false,self.baseColor,self.shadowColor])
      textpos.push([qty,xQty,ypos+2,false,self.baseColor,self.shadowColor])
    end
    pbDrawTextPositions(self.contents,textpos)
  end
end

def pbBottomLeftLinesScreen(window,lines,width=nil)
  window.x=0
  window.width=width ? width : Graphics.width
  window.height=(window.borderY rescue 32)+lines*32
  window.y=SCREEN_HEIGHT-window.height
end


class SecretBaseMartScene
  
  def update
    pbUpdateSpriteHash(@sprites)
  end
  
  def pbPrepareWindow(window)
    window.visible=true
    window.letterbyletter=false
  end
  
  def initialize(stock)
    pbScrollMap(6,3,5)
    @adapter=$PokemonBag ? PokemonMartAdapter.new : RpgxpMartAdapter.new
    @viewport=Viewport.new(0,0,Graphics.width,SCREEN_HEIGHT)
    @viewport.z=99999
    @sprites={}
    @sprites["background"]=IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/SecretBases/secretMartScreen")
    @sprites["itemwindow"]=Window_BaseMart.new(stock,
    Graphics.width-266,12,278,SCREEN_HEIGHT-32)
    @sprites["itemwindow"].viewport=@viewport
    @sprites["itemwindow"].index=0
    @sprites["itemwindow"].refresh
    
    @sprites["itemtextwindow"]=Window_UnformattedTextPokemon.new("")
    pbPrepareWindow(@sprites["itemtextwindow"])
    @sprites["itemtextwindow"].y=SCREEN_HEIGHT-112
    @sprites["itemtextwindow"].width=Graphics.width/2
    @sprites["itemtextwindow"].height=128
    @sprites["itemtextwindow"].baseColor=Color.new(248,248,248)
    @sprites["itemtextwindow"].shadowColor=Color.new(0,0,0)
    @sprites["itemtextwindow"].visible=true
    @sprites["itemtextwindow"].viewport=@viewport
    @sprites["itemtextwindow"].windowskin=nil

    @sprites["helpwindow"]=Window_AdvancedTextPokemon.new("")
    pbPrepareWindow(@sprites["helpwindow"])
    @sprites["helpwindow"].visible=false
    @sprites["helpwindow"].viewport=@viewport
    pbBottomLeftLinesScreen(@sprites["helpwindow"],1)

    @sprites["moneywindow"]=Window_AdvancedTextPokemon.new("")
    pbPrepareWindow(@sprites["moneywindow"])
    @sprites["moneywindow"].setSkin("Graphics/Windowskins/goldskin")
    @sprites["moneywindow"].visible=true
    @sprites["moneywindow"].viewport=@viewport
    @sprites["moneywindow"].x=0
    @sprites["moneywindow"].y=0
    @sprites["moneywindow"].width=190
    @sprites["moneywindow"].height=96
    @sprites["moneywindow"].baseColor=Color.new(88,88,80)
    @sprites["moneywindow"].shadowColor=Color.new(168,184,184)
    pbDeactivateWindows(@sprites)
    pbUpdate
  end

  def pbUpdate
    @sprites["itemicon"].dispose if @sprites["itemicon"]
    iconbitmap=(@sprites["itemwindow"].item==0) ? BitmapCache.load_bitmap("Graphics/Icons/itemBack") :
      getBaseItemBitmap(@sprites["itemwindow"].item)
    @sprites["itemicon"]=PictureWindow.new(iconbitmap)
    @sprites["itemicon"].viewport=@viewport
    @sprites["itemicon"].x=4
    @sprites["itemicon"].y=278-@sprites["itemicon"].height
    @sprites["moneywindow"].text=_INTL("Money:\n<r>${1}",@adapter.getMoney())
    
    @sprites["itemtextwindow"].text=(@sprites["itemwindow"].item==0) ? _INTL("Quit shopping.") :
      baseItemDesc(@sprites["itemwindow"].item)
  end
  
  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    pbScrollMap(4,3,5)
    pbWait(1)
  end
  
  def pbDisplayPaused(msg)
    cw=@sprites["helpwindow"]
    cw.letterbyletter=true
    cw.text=msg
    pbBottomLeftLinesScreen(cw,2)
    cw.visible=true
    i=0
    pbPlayDecisionSE()
    loop do
      Graphics.update
      Input.update
      wasbusy=cw.busy?
      self.update
      if !cw.busy? && wasbusy
        pbUpdate
      end
      if Input.trigger?(Input::C) && cw.resume && !cw.busy?
        @sprites["helpwindow"].visible=false
        return
      end
    end
  end

  def pbChooseBuyItem
    oldindex=@sprites["itemwindow"].index
    pbActivateWindow(@sprites,"itemwindow"){
    loop do
      if oldindex!=@sprites["itemwindow"].index
        pbUpdate
        oldindex=@sprites["itemwindow"].index
      end
      Graphics.update
      Input.update
      self.update
      if Input.trigger?(Input::C)
        return @sprites["itemwindow"].item
      elsif Input.trigger?(Input::B)
        return 0
      end
    end
    }
  end
     
end

class SecretBaseMartScreen
  def initialize(scene)
    @scene=scene
    @adapter=$PokemonBag ? PokemonMartAdapter.new : RpgxpMartAdapter.new
  end

  def pbDisplayPaused(msg)
    return @scene.pbDisplayPaused(msg)
  end
  
  def pbBuyScreen
    loop do
      @item=@scene.pbChooseBuyItem
      if @item>0
      itemname=baseItemName(@item)
      price=baseItemCost(@item)
        if @adapter.getMoney()<price
          pbDisplayPaused(_INTL("You don't have enough money."))
          next
        else
          itempocket=baseItemPocket(@item)
          if $PokemonGlobal.basePocketLength(itempocket)<getMaxSecretBagPocket(itempocket)
            @adapter.setMoney(@adapter.getMoney()-price)
            pbDisplayPaused(_INTL("Here you are!\r\nThank you!"))
            pbGetBaseItem(@item)
            next
          else
            pbDisplayPaused(_INTL("The space for {1} is full.",itemname))
            next
          end
        end
      else
        break
      end
    end
    @scene.pbEndScene
  end
end

def pbSecretBaseMart(stock,speech=nil)
  for i in 0...stock.length
    if stock[i].is_a?(String)
      stock[i]=getBaseItemByName(stock[i])
    end
  end
  stock.compact!
  commands=[]
  cmdBuy=-1
  cmdSell=-1
  cmdQuit=-1
  commands[cmdBuy=commands.length]=_INTL("Buy")
  commands[cmdQuit=commands.length]=_INTL("Cancel")
  cmd=pbMessage(
     speech ? speech : _INTL("Welcome!\r\nHow may I serve you?"),
     commands,cmdQuit+1)
  loop do
    if cmdBuy>=0 && cmd==cmdBuy
    sscene=SecretBaseMartScene.new(stock)
    sscreen=SecretBaseMartScreen.new(sscene)
    sscreen.pbBuyScreen
    else
      pbMessage(_INTL("Please come again!"))
      break
    end
    cmd=pbMessage(
       _INTL("Is there anything else I can help you with?"),commands,cmdQuit+1)
  end
end

#===============================================================================
# Creating secret bases
#===============================================================================

def pbTeletransport(id,x,y)
  pbCancelVehicles
  $game_temp.player_new_map_id=id
  $game_temp.player_new_x=x
  $game_temp.player_new_y=y
  $game_temp.player_new_direction=8
  $scene.transfer_player
  $game_map.autoplay
  $game_map.refresh
end

def pbPackup(id)
  for p in 0...BASEBAGPOCKETS.length
    pocket=$PokemonGlobal.getBasePocket(p)
    for i in 0...pocket.length
      pocket[i][1]=false
    end
  end
  $PokemonGlobal.installed=false
  $PokemonGlobal.mybaseid=-1
  $PokemonGlobal.mybaselocation=-1
  $PokemonGlobal.mybasetype=""

  if $PokemonGlobal.baseinfo && $PokemonGlobal.baseinfo[id]
    $PokemonGlobal.baseinfo[id].clear
    $PokemonGlobal.baseinfo[id]=nil
  end
end

def pbNewSecretBase(event)
  event.name[/SecretBase\((\d+),(\w+)\)/]
  newBaseId=$~[1].to_i
  newBaseType=$~[2].to_s
  pbMessage(SECRETBASEMESSAGES[SECRETBASETEMPLATES[newBaseType][2]]+"\1")
  if $PokemonBag.pbHasItem?(:HOMEKEY) && $PokemonGlobal.getBaseId>=0
    pbMessage(_INTL("You may only own one home.\1"))
    mapname=pbGetMapNameFromId($PokemonGlobal.getBaseLocation)
    movename=PBMoves.getName(getID(PBMoves,BASEMOVENEEDED))
    if pbConfirmMessage(_INTL("Would you like to move from your home near {1}?",mapname))
      pbMessage(_INTL("All decorations and furniture in your home will be returned to your PC.\1"))
      if pbConfirmMessage(_INTL("Is that okay?"))
      pbPackup(SECRETBASEMAP)
      $PokemonGlobal.mybaseid=-1
      $PokemonGlobal.mybaselocation=-1
      $PokemonGlobal.mybasetype=""
      pbFlash(Color.new(0,0,0),16)
      $game_map.need_refresh=true
      pbWait(18)
      pbMessage(_INTL("Moving complete.\1"))
        if pbConfirmMessage(_INTL("Would you like to make this your home?"))
          $PokemonGlobal.mybaseid=newBaseId
          $PokemonGlobal.mybaselocation=$game_map.map_id
          $PokemonGlobal.mybasetype=newBaseType
          $PokemonGlobal.outdoordata=[$game_map.map_id,$game_player.x,$game_player.y]
          $game_map.need_refresh=true
          mapdata=SECRETBASETEMPLATES[$PokemonGlobal.mybasetype]
          dx,dy=getDoorPos(mapdata[0])
          pbFadeOutIn(99999){
            $game_temp.player_transferring   = true
            $game_temp.transition_processing = true
            $game_temp.player_new_map_id    = SECRETBASEMAP
            $game_temp.player_new_x         = dx
            $game_temp.player_new_y         = dy-1
            $game_temp.player_new_direction = 8
            $scene.transfer_player
          }
          pbMoveRoute($game_player,[PBMoveRoute::Up]*mapdata[1])
          pbWait(30)
          if pbInstallingBase
            pbFadeOutIn(99999){
              $game_temp.player_transferring   = true
              $game_temp.transition_processing = true
              $game_temp.player_new_map_id    = SECRETBASEMAP
              $game_temp.player_new_x         = dx
              $game_temp.player_new_y         = dy-1
              $game_temp.player_new_direction = 8
              $scene.transfer_player
            }
          else
            pbFadeOutIn(99999){
              $game_temp.player_transferring   = true
              $game_temp.transition_processing = true
              $game_temp.player_new_map_id    = $PokemonGlobal.outdoordata[0]
              $game_temp.player_new_x         = $PokemonGlobal.outdoordata[1]
              $game_temp.player_new_y         = $PokemonGlobal.outdoordata[2]
              $game_temp.player_new_direction = 2
              $scene.transfer_player
            }
          end
        end
      end
    end
  elsif $PokemonBag.pbHasItem?(:HOMEKEY)
    if pbConfirmMessage(_INTL("Would you like to make this your home?"))
      $PokemonGlobal.mybaseid=newBaseId
      $PokemonGlobal.mybaselocation=$game_map.map_id
      $PokemonGlobal.mybasetype=newBaseType
      $PokemonGlobal.outdoordata=[$game_map.map_id,$game_player.x,$game_player.y]
      $game_map.need_refresh=true
      mapdata=SECRETBASETEMPLATES[$PokemonGlobal.mybasetype]
      dx,dy=getDoorPos(mapdata[0])
      pbFadeOutIn(99999){
        $game_temp.player_transferring   = true
        $game_temp.transition_processing = true
        $game_temp.player_new_map_id    = SECRETBASEMAP
        $game_temp.player_new_x         = dx
        $game_temp.player_new_y         = dy-1
        $game_temp.player_new_direction = 8
        $scene.transfer_player
      }
      pbMoveRoute($game_player,[PBMoveRoute::Up]*mapdata[1])
      pbWait(30)
      if pbInstallingBase
        pbFadeOutIn(99999){
          $game_temp.player_transferring   = true
          $game_temp.transition_processing = true
          $game_temp.player_new_map_id    = SECRETBASEMAP
          $game_temp.player_new_x         = dx
          $game_temp.player_new_y         = dy-1
          $game_temp.player_new_direction = 8
          $scene.transfer_player
        }
      else
        pbFadeOutIn(99999){
          $game_temp.player_transferring   = true
          $game_temp.transition_processing = true
          $game_temp.player_new_map_id    = $PokemonGlobal.outdoordata[0]
          $game_temp.player_new_x         = $PokemonGlobal.outdoordata[1]
          $game_temp.player_new_y         = $PokemonGlobal.outdoordata[2]
          $game_temp.player_new_direction = 2
          $scene.transfer_player
        }
      end
    end
  end
end

def getDoorPos(map)
  map=load_data(sprintf("Data/Map%03d.%s", map,$RPGVX ? "rvdata" : "rxdata"))
  map.events.each do |i, event|
    return [event.x, event.y] if event.name=="DOOR"
  end
  return [0,0]
end

def pbInstallingBase
  if pbConfirmMessage(_INTL("Want to make your home here?"))
    $PokemonGlobal.installed=true
    $game_map.need_refresh=true
    return true
  else
    $PokemonGlobal.installed=false 
    $PokemonGlobal.mybaseid=-1
    $PokemonGlobal.mybaselocation=-1
    $PokemonGlobal.mybasetype=""
    return false
  end
end
def pbIsMyBase?
  event_name=(self.is_a?(Game_Event)? self.name : get_character(0).name)
  if event_name[/SecretBase\((\d+),(\w+)\)/]
    baseid=$~[1].to_i
    return true if $PokemonGlobal.mybaseid==baseid
  end
  return true if $game_map.map_id==SECRETBASEMAP && $PokemonGlobal.installed==true
  return false
end

def pbSecretBase(id,type,event)
  if $PokemonGlobal.mybaseid==id # your base
    dx,dy=getDoorPos(SECRETBASETEMPLATES[$PokemonGlobal.mybasetype][0])
    pbSEPlay("Door enter")
    pbFadeOutIn(99999){
      pbWait(6)
      $game_temp.player_transferring   = true
      $game_temp.transition_processing = true
      $game_temp.player_new_map_id    = SECRETBASEMAP
      $game_temp.player_new_x         = dx
      $game_temp.player_new_y         = dy
      $game_temp.player_new_direction = 8
      $scene.transfer_player
    }
  else # not your base
    pbNewSecretBase(event)
  end
end
def pbExitBase
  pbSEPlay("Door exit")
  pbFadeOutIn(99999){
    $game_temp.player_transferring   = true
    $game_temp.transition_processing = true
    $game_temp.player_new_map_id    = $PokemonGlobal.outdoordata[0]
    $game_temp.player_new_x         = $PokemonGlobal.outdoordata[1]
    $game_temp.player_new_y         = $PokemonGlobal.outdoordata[2]
    $game_temp.player_new_direction = 2
    $scene.transfer_player
  }
end

Events.onAction+=proc{|sender,e|
   next if $game_player.direction!=8
   facingEvent = $game_player.pbFacingEvent
   if facingEvent && facingEvent.name[/SecretBase\((\d+),(\w+)\)/]
     pbSecretBase($~[1].to_i,$~[2].to_s,facingEvent)
   end
}

class SecretBaseSprite
  def initialize(event,map,viewport)
    @event=event
    @map=map
    @disposed=false
    @reflect = IconSprite.new(0,0,viewport)
    @reflect.visible=false
    @reflect.oy=32
    @event.name[/SecretBase\((\d+),(\w+)\)/]
    @id=$~[1].to_i
    @type=$~[2].to_s
    updateGraphic
  end

  def dispose
    @event=nil
    @map=nil
    @reflect.dispose
    @disposed=true
  end

  def disposed?
    @disposed
  end

  def update
    updateGraphic
    @reflect.update
    if (Object.const_defined?(:ScreenPosHelper) rescue false)
      @reflect.x = ScreenPosHelper.pbScreenX(@event)
      @reflect.y = ScreenPosHelper.pbScreenY(@event)
      @reflect.zoom_x = ScreenPosHelper.pbScreenZoomX(@event)
    else
      @reflect.x = @event.screen_x
      @reflect.y = @event.screen_y
      @reflect.zoom_x = 1.0
    end
    @reflect.zoom_y = @reflect.zoom_x
    pbDayNightTint(@reflect)
  end
  
  def updateGraphic
    char_name=SECRETBASETEMPLATES[@type][2]
    if $PokemonGlobal.mybaseid==@id
      @reflect.setBitmap("Graphics/Pictures/SecretBases/tile#{char_name}")
      @reflect.ox=@reflect.bitmap.width/2
      @reflect.visible=true
    else
      filename="Graphics/Pictures/SecretBases/closed#{char_name}"
      if pbResolveBitmap(filename)
        @reflect.setBitmap(filename)
        @reflect.ox=@reflect.bitmap.width/2
        @reflect.visible=true
      else
        @reflect.setBitmap("")
        @reflect.visible=false
      end
    end
  end
end

Events.onSpritesetCreate+=proc{|sender,e|
   spriteset=e[0]
   viewport=e[1]
   map=spriteset.map
   for i in map.events.keys
     if map.events[i].name[/SecretBase\((\d+),(\w+)\)/]
       spriteset.addUserSprite(SecretBaseSprite.new(map.events[i],map,viewport))
     end
   end
}

#===============================================================================
# ■ Functions for users
#===============================================================================
# - pbMakeNumericTileset(TILESETNAME)
# This will save in your project's folder the tileset you've selected
# with a numeric patron.
#===============================================================================

def pbGetBaseItem(itemid)
  item=itemid
  if itemid.is_a?(String)
    item=getBaseItemByName(itemid)
  end
  itempocket=baseItemPocket(item)
  if $PokemonGlobal.basePocketLength(itempocket)<getMaxSecretBagPocket(itempocket)
    $PokemonGlobal.baseItemBag[itempocket].push([item,false])
    return true
  end
  return false
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
  pbMessage(_INTL("Saved in game's folder: {1}_numeric",name))
end

