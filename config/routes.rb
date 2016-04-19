require 'sidekiq/web'

Rails.application.routes.draw do

  resources :previews
  resources :activities

  resources :characters do
    get "characters/:page", :action => :index, :on => :collection
    get :autocomplete_character_creator, :on => :collection
    get :autocomplete_character_creator2, :on => :collection
    collection do
      get :all
    end
  end

  resources :collectibles do
    get "collectibles/:page", :action => :index, :on => :collection
    collection do
      get :all
    end
    resource :itemwish, module: :collectibles
    resource :itemown, module: :collectibles
    resource :itemsale, module: :collectibles
  end

  post '/rate' => 'rater#create', :as => 'rate'
  resources :books do
    get "books/:page", :action => :index, :on => :collection
    get :autocomplete_book_title, :on => :collection
    get :autocomplete_book_writer, :on => :collection
    get :autocomplete_book_writer2, :on => :collection
    get :autocomplete_book_artist, :on => :collection
    get :autocomplete_book_artist2, :on => :collection
    get :autocomplete_book_colors, :on => :collection
    get :autocomplete_book_cover, :on => :collection
    get :autocomplete_book_letters, :on => :collection
    get :autocomplete_book_editor, :on => :collection
    get :autocomplete_book_eic, :on => :collection
    get :autocomplete_book_country, :on => :collection
    get :autocomplete_book_publisher, :on => :collection
    resources :comments
    collection do 
      post :import
      get :autocomplete
      get :keys
      get :all
      get "all/table" => "books#alltbl"
      get "all/missing" => "books#allmissing"
      get "all/table/missing" => "books#alltblmissing"
      get :alladmin
      get :ad4001
      get "ad4001/table" => "books#ad4001tbl"
      get "ad4001/missing" => "books#ad4001missing"
      get "ad4001/table/missing" => "books#ad4001tblmissing"
      get :ad4001bloodshot
      get "ad4001bloodshot/table" => "books#ad4001bloodshottbl"
      get "ad4001bloodshot/missing" => "books#ad4001bloodshotmissing"
      get "ad4001bloodshot/table/missing" => "books#ad4001bloodshottblmissing"
      get :ad4001shadowman
      get "ad4001shadowman/table" => "books#ad4001shadowmantbl"
      get "ad4001shadowman/missing" => "books#ad4001shadowmanmissing"
      get "ad4001shadowman/table/missing" => "books#ad4001shadowmantblmissing"
      get :ad4001xomanowar
      get "ad4001xomanowar/table" => "books#ad4001xomanowartbl"
      get "ad4001xomanowar/missing" => "books#ad4001xomanowarmissing"
      get "ad4001xomanowar/table/missing" => "books#ad4001manowartblmissing"
      get :aa
      get "aa/table" => "books#aatbl"
      get "aa/missing" => "books#aamissing"
      get "aa/table/missing" => "books#aatblmissing"
      get :archerarmstrong
      get "archerarmstrong/table" => "books#archerarmstrongtbl"
      get "archerarmstrong/missing" => "books#archerarmstrongmissing"
      get "archerarmstrong/table/missing" => "books#archerarmstrongtblmissing"
      get :armorhunters
      get "armorhunters/table" => "books#armorhunterstbl"
      get "armorhunters/missing" => "books#armorhuntersmissing"
      get "armorhunters/table/missing" => "books#armorhunterstblmissing"
      get :armorhuntersbloodshot
      get "armorhuntersbloodshot/table" => "books#armorhuntersbloodshottbl"
      get "armorhuntersbloodshot/missing" => "books#armorhuntersbloodshotmissing"
      get "armorhuntersbloodshot/table/missing" => "books#armorhuntersbloodshottblmissing"
      get :bloodshot
      get "bloodshot/table" => "books#bloodshottbl"
      get "bloodshot/missing" => "books#bloodshotmissing"
      get "bloodshot/table/missing" => "books#bloodshottblmissing"
      get :bloodshotreborn
      get "bloodshotreborn/missing" => "books#bloodshotrebornmissing"
      get "bloodshotreborn/table" => "books#bloodshotreborntbl"
      get "bloodshotreborn/table/missing" => "books#bloodshotreborntblmissing"
      get :bookofdeath
      get "bookofdeath/table" => "books#bookofdeathtbl"
      get "bookofdeath/missing" => "books#bookofdeathmissing"
      get "bookofdeath/table/missing" => "books#bookofdeathtblmissing"
      get :legendsofthegeomancer
      get "legendsofthegeomancer/table" => "books#legendsofthegeomancertbl"
      get "legendsofthegeomancer/missing" => "books#legendsofthegeomancermissing"
      get "legendsofthegeomancer/table/missing" => "books#legendsofthegeomancertblmissing"
      get :deaddrop
      get "deaddrop/table" => "books#deaddroptbl"
      get "deaddrop/missing" => "books#deaddropmissing"
      get "deaddrop/table/missing" => "books#deaddroptblmissing"
      get :delinquents
      get "delinquents/table" => "books#delinquentstbl"
      get "delinquents/missing" => "books#delinquentsmissing"
      get "delinquents/table/missing" => "books#delinquentstblmissing"
      get :divinity
      get "divinity/table" => "books#divinitytbl"
      get "divinity/missing" => "books#divinitymissing"
      get "divinity/table/missing" => "books#divinitytblmissing"
      get :divinity2
      get "divinity2/table" => "books#divinity2tbl"
      get "divinity2/missing" => "books#divinity2missing"
      get "divinity2/table/missing" => "books#divinity2tblmissing"
      get :drmirage
      get "drmirage/table" => "books#drmiragetbl"
      get "drmirage/missing" => "books#drmiragemissing"
      get "drmirage/table/missing" => "books#drmiragetblmissing"
      get :drmirage2
      get "drmirage2/table" => "books#drmirage2tbl"
      get "drmirage2/missing" => "books#drmirage2missing"
      get "drmirage2/table/missing" => "books#drmirage2tblmissing"
      get :eternalwarrior
      get "eternalwarrior/table" => "books#eternalwarriortbl"
      get "eternalwarrior/missing" => "books#eternalwarriormissing"
      get "eternalwarrior/table/missing" => "books#eternalwarriortblmissing"
      get :eternalwarriordaysofsteel
      get "eternalwarriordaysofsteel/table" => "books#eternalwarriordaysofsteeltbl"
      get "eternalwarriordaysofsteel/missing" => "books#eternalwarriordaysofsteelmissing"
      get "eternalwarriordaysofsteel/table/missing" => "books#eternalwarriordaysofsteelmissing"
      get :faith
      get "faith/table" => "books#faithtbl"
      get "faith/missing" => "books#faithmissing"
      get "faith/table/missing" => "books#faithtblmissing"
      get :harbinger
      get "harbinger/table" => "books#harbingertbl"
      get "harbinger/missing" => "books#harbingermissing"
      get "harbinger/table/missing" => "books#harbingertblmissing"
      get :harbingeromegas
      get "harbingeromegas/table" => "books#harbingeromegastbl"
      get "harbingeromegas/missing" => "books#harbingeromegasmissing"
      get "harbingeromegas/table/missing" => "books#harbingeromegastblmissing"
      get :harbingerwars
      get "harbingerwars/table" => "books#harbingerwarstbl"
      get "harbingerwars/missing" => "books#harbingerwarsmissing"
      get "harbingerwars/table/missing" => "books#harbingerwarstblmissing"
      get :armorhuntersharbinger
      get "armorhuntersharbinger/table" => "books#armorhuntersharbingertbl"
      get "armorhuntersharbinger/missing" => "books#armorhuntersharbingermissing"
      get "armorhuntersharbinger/table/missing" => "books#armorhuntersharbingertblmissing"
      get :fallofharbinger
      get "fallofharbinger/table" => "books#fallofharbingertbl"
      get "fallofharbinger/missing" => "books#fallofharbingermissing"
      get "fallofharbinger/table/missing" => "books#fallofharbingertblmissing"
      get :fallofxomanowar
      get "fallofxomanowar/table" => "books#fallofxomanowartbl"
      get "fallofxomanowar/missing" => "books#fallofxomanowarmissing"
      get "fallofxomanowar/table/missing" => "books#fallofxomanowartblmissing"
      get :fallofbloodshot
      get "fallofbloodshot/table" => "books#fallofbloodshottbl"
      get "fallofbloodshot/missing" => "books#fallofbloodshotmissing"
      get "fallofbloodshot/table/missing" => "books#fallofbloodshottblmissing"
      get :fallofninjak
      get "fallofninjak/table" => "books#fallofninjaktbl"
      get "fallofninjak/missing" => "books#fallofninjakmissing"
      get "fallofninjak/table/missing" => "books#fallofninjaktblmissing"
      get :imperium
      get "imperium/table" => "books#imperiumtbl"
      get "imperium/missing" => "books#imperiummissing"
      get "imperium/table/missing" => "books#imperiumtblmissing"
      get :ivar
      get "ivar/table" => "books#ivartbl"
      get "ivar/missing" => "books#ivarmissing"
      get "ivar/table/missing" => "books#ivartblmissing"
      get :ninjak
      get "ninjak/table" => "books#ninjaktbl"
      get "ninjak/missing" => "books#ninjakmissing"
      get "ninjak/table/missing" => "books#ninjaktblmissing"
      get :punkmambo
      get "punkmambo/table" => "books#punkmambotbl"
      get "punkmambo/missing" => "books#punkmambomissing"
      get "punkmambo/table/missing" => "books#punkmambotblmissing"
      get :previews
      get "previews/table" => "books#previewstbl"
      get "previews/missing" => "books#previewsmissing"
      get "previews/table/missing" => "books#previewstblmissing"
      get :quantumwoody
      get "quantumwoody/table" => "books#quantumwoodytbl"
      get "quantumwoody/missing" => "books#quantumwoodymissing"
      get "quantumwoody/table/missing" => "books#quantumwoodtblmissing"
      get :q2
      get "q2/table" => "books#q2tbl"
      get "q2/missing" => "books#q2missing"
      get "q2/table/missing" => "books#q2tblmissing"
      get :quantumwoodymustdie
      get "quantumwoodymustdie/table" => "books#quantumwoodymustdietbl"
      get "quantumwoodymustdie/missing" => "books#quantumwoodymustdiemissing"
      get "quantumwoodymustdie/table/missing" => "books#quantumwoodymustdietblmissing"
      get :rai
      get "rai/table" => "books#raitbl"
      get "rai/missing" => "books#raimissing"
      get "rai/table/missing" => "books#raitblmissing"
      get :shadowman
      get "shadowman/table" => "books#shadowmantbl"
      get "shadowman/missing" => "books#shadowmanmissing"
      get "shadowman/table/missing" => "books#shadowmantblmissing"
      get :shadowmanendtimes
      get "shadowmanendtimes/table" => "books#shadowmanendtimestbl"
      get "shadowmanendtimes/missing" => "books#shadowmanendtimesmissing"
      get "shadowmanendtimes/table/missing" => "books#shadowmanendtimestblmissing"
      get :sketch
      get "sketch/table" => "books#sketchtbl"
      get :trades
      get "trades/table" => "books#tradestbl"
      get "trades/missing" => "books#tradesmissing"
      get "trades/table/missing" => "books#tradestblmissing"
      get :unity
      get "unity/table" => "books#unitytbl"
      get "unity/missing" => "books#unitymissing"
      get "unity/table/missing" => "books#unitytblmissing"
      get :thevaliant
      get "thevaliant/table" => "books#thevalianttbl"
      get "thevaliant/missing" => "books#thevaliantmissing"
      get "thevaliant/table/missing" => "books#thevalianttblmissing"
      get :wratheternalwarrior
      get "wratheternalwarrior/table" => "books#wratheternalwarriortbl"
      get "wratheternalwarrior/missing" => "books#wrathoftheeternalwarriormissing"
      get "wratheternalwarrior/table/missing" => "books#wrathoftheeternalwarriortblmissing"
      get :xomanowar
      get "xomanowar/table" => "books#xomanowartbl"
      get "xomanowar/missing" => "books#xomanowarmissing"
      get "xomanowar/table/missing" => "books#xomanowartblmissing"
      get :xomanowarspecials
      get "xomanowarspecials/table" => "books#xomanowarspecialstbl"
      get "xomanowarspecials/missing" => "books#xomanowarspecialsmissing"
      get "xomanowarspecials/table/missing" => "books#xomanowarspecialstblmissing"

      # VH1
      get "classic/archerarmstrong" => "books#vh1archerarmstrong"
      get "classic/archerarmstrong/table" => "books#vh1archerarmstrongtbl"
      get "classic/armorines" => "books#vh1armorines"
      get "classic/armorines/table" => "books#vh1armorinestbl"
      get "classic/bloodshot" => "books#vh1bloodshot"
      get "classic/bloodshot/table" => "books#vh1bloodshottbl"
      get "classic/chaoseffect" => "books#vh1chaoseffect"
      get "classic/chaoseffect/table" => "books#vh1chaoseffecttbl"
      get "classic/deathmate" => "books#vh1deathmate"
      get "classic/deathmate/table" => "books#vh1deathmatetbl"
      get "classic/eternalwarrior" => "books#vh1eternalwarrior"
      get "classic/eternalwarrior/table" => "books#vh1eternalwarriortbl"
      get "classic/geomancer" => "books#vh1geomancer"
      get "classic/geomancer/table" => "books#vh1geomancertbl"
      get "classic/harbinger" => "books#vh1harbinger"
      get "classic/harbinger/table" => "books#vh1harbingertbl"
      get "classic/hardcorps" => "books#vh1hardcorps"
      get "classic/hardcorps/table" => "books#vh1hardcorpstbl"
      get "classic/misc" => "books#vh1miscellaneous"
      get "classic/misc/table" => "books#vh1miscellaneoustbl"
      get "classic/magnus" => "books#vh1magnus"
      get "classic/magnus/table" => "books#vh1magnustbl"
      get "classic/mirage" => "books#vh1mirage"
      get "classic/mirage/table" => "books#vh1miragetbl"
      get "classic/ninjak" => "books#vh1ninjak"
      get "classic/ninjak/table" => "books#vh1ninjaktbl"
      get "classic/visitor" => "books#vh1thevisitor"
      get "classic/visitor/table" => "books#vh1thevisitortbl"
      get "classic/psilords" => "books#vh1psilords"
      get "classic/psilords/table" => "books#vh1psilordstbl"
      get "classic/rai" => "books#vh1rai"
      get "classic/rai/table" => "books#vh1raitbl"
      get "classic/secretweapons" => "books#vh1secretweapons"
      get "classic/secretweapons/table" => "books#vh1secretweaponstbl"
      get "classic/shadowman" => "books#vh1shadowman"
      get "classic/shadowman/table" => "books#vh1shadowmantbl"
      get "classic/solar" => "books#vh1solar"
      get "classic/solar/table" => "books#vh1solartbl"
      get "classic/timewalker" => "books#vh1timewalker"
      get "classic/timewalker/table" => "books#vh1timewalkertbl"
      get "classic/trades" => "books#vh1trades"
      get "classic/trades/table" => "books#vh1tradestbl"
      get "classic/turok" => "books#vh1turok"
      get "classic/turok/table" => "books#vh1turoktbl"
      get "classic/unity" => "books#vh1unity"
      get "classic/unity/table" => "books#vh1unitytbl"
      get "classic/valiantvoice" => "books#vh1voice"
      get "classic/valiantvoice/table" => "books#vh1voicetbl"
      get "classic/xomanowar" => "books#vh1xomanowar"
      get "classic/xomanowar/table" => "books#vh1xomanowartbl"
      get "classic/all" => "books#vh1all"
      get "classic/all/table" => "books#vh1alltbl"
      get "classic/keys" => "books#vh1keys"

      get "classic/archerarmstrong/missing" => "books#vh1archerarmstrongmissing"
      get "classic/archerarmstrong/table/missing" => "books#vh1archerarmstrongtblmissing"
      get "classic/armorines/missing" => "books#vh1armorinesmissing"
      get "classic/armorines/table/missing" => "books#vh1armorinestblmissing"
      get "classic/bloodshot/missing" => "books#vh1bloodshotmissing"
      get "classic/bloodshot/table/missing" => "books#vh1bloodshottblmissing"
      get "classic/chaoseffect/missing" => "books#vh1chaoseffectmissing"
      get "classic/chaoseffect/table/missing" => "books#vh1chaoseffecttblmissing"
      get "classic/deathmate/missing" => "books#vh1deathmatemissing"
      get "classic/deathmate/table/missing" => "books#vh1deathmatetblmissing"
      get "classic/eternalwarrior/missing" => "books#vh1eternalwarriormissing"
      get "classic/eternalwarrior/table/missing" => "books#vh1eternalwarriortblmissing"
      get "classic/geomancer/missing" => "books#vh1geomancermissing"
      get "classic/geomancer/table/missing" => "books#vh1geomancertblmissing"
      get "classic/harbinger/missing" => "books#vh1harbingermissing"
      get "classic/harbinger/table/missing" => "books#vh1harbingertblmissing"
      get "classic/hardcorps/missing" => "books#vh1hardcorpsmissing"
      get "classic/hardcorps/table/missing" => "books#vh1hardcorpstblmissing"
      get "classic/misc/missing" => "books#vh1miscellaneousmissing"
      get "classic/misc/table/missing" => "books#vh1miscellaneoustblmissing"
      get "classic/magnus/missing" => "books#vh1magnusmissing"
      get "classic/magnus/table/missing" => "books#vh1magnustblmissing"
      get "classic/mirage/missing" => "books#vh1miragemissing"
      get "classic/mirage/table/missing" => "books#vh1miragetblmissing"
      get "classic/ninjak/missing" => "books#vh1ninjakmissing"
      get "classic/ninjak/table/missing" => "books#vh1ninjaktblmissing"
      get "classic/visitor/missing" => "books#vh1thevisitormissing"
      get "classic/visitor/table/missing" => "books#vh1thevisitortblmissing"
      get "classic/psilords/missing" => "books#vh1psilordsmissing"
      get "classic/psilords/table/missing" => "books#vh1psilordstblmissing"
      get "classic/rai/missing" => "books#vh1raimissing"
      get "classic/rai/table/missing" => "books#vh1raitblmissing"
      get "classic/secretweapons/missing" => "books#vh1secretweaponsmissing"
      get "classic/secretweapons/table/missing" => "books#vh1secretweaponstblmissing"
      get "classic/shadowman/missing" => "books#vh1shadowmanmissing"
      get "classic/shadowman/table/missing" => "books#vh1shadowmantblmissing"
      get "classic/solar/missing" => "books#vh1solarmissing"
      get "classic/solar/table/missing" => "books#vh1solartblmissing"
      get "classic/timewalker/missing" => "books#vh1timewalkermissing"
      get "classic/timewalker/table/missing" => "books#vh1timewalkertblmissing"
      get "classic/trades/missing" => "books#vh1tradesmissing"
      get "classic/trades/table/missing" => "books#vh1tradestblmissing"
      get "classic/turok/missing" => "books#vh1turokmissing"
      get "classic/turok/table/missing" => "books#vh1turoktblmissing"
      get "classic/unity/missing" => "books#vh1unitymissing"
      get "classic/unity/table/missing" => "books#vh1unitytblmissing"
      get "classic/valiantvoice/missing" => "books#vh1voicemissing"
      get "classic/valiantvoice/table/missing" => "books#vh1voicetblmissing"
      get "classic/xomanowar/missing" => "books#vh1xomanowarmissing"
      get "classic/xomanowar/table/missing" => "books#vh1xomanowartblmissing"
      get "classic/all/missing" => "books#vh1allmissing"
      get "classic/all/table/missing" => "books#vh1alltblmissing"

      # VH2
      get "acclaim/adventurezone" => "books#vh2az"
      get "acclaim/adventurezone/table" => "books#vh2aztbl"
      get "acclaim/armorines" => "books#vh2armorines"
      get "acclaim/armorines/table" => "books#vh2armorinestbl"
      get "acclaim/all" => "books#vh2all"
      get "acclaim/all/table" => "books#vh2alltbl"
      get "acclaim/bloodshot" => "books#vh2bs"
      get "acclaim/bloodshot/table" => "books#vh2bstbl"
      get "acclaim/darquepassages" => "books#vh2dp"
      get "acclaim/darquepassages/table" => "books#vh2dptbl"
      get "acclaim/deadside" => "books#vh2ds"
      get "acclaim/deadside/table" => "books#vh2dstbl"
      get "acclaim/doctortomorrow" => "books#vh2drt"
      get "acclaim/doctortomorrow/table" => "books#vh2drttbl"
      get "acclaim/eternalwarriors" => "books#vh2ews"
      get "acclaim/eternalwarriors/table" => "books#vh2ewstbl"
      get "acclaim/magnus" => "books#vh2magnus"
      get "acclaim/magnus/table" => "books#vh2magnustbl"
      get "acclaim/ninjak" => "books#vh2ninjak"
      get "acclaim/ninjak/table" => "books#vh2ninjaktbl"
      get "acclaim/nio" => "books#vh2nio"
      get "acclaim/nio/table" => "books#vh2niotbl"
      get "acclaim/misc" => "books#vh2misc"
      get "acclaim/misc/table" => "books#vh2misctbl"
      get "acclaim/quantumwoody" => "books#vh2qw"
      get "acclaim/quantumwoody/table" => "books#vh2qwtbl"
      get "acclaim/shadowman-vol2" => "books#vh2sha2"
      get "acclaim/shadowman-vol2/table" => "books#vh2sha2tbl"
      get "acclaim/shadowman-vol3" => "books#vh2sha3"
      get "acclaim/shadowman-vol3/table" => "books#vh2sha3tbl"
      get "acclaim/solar" => "books#vh2solar"
      get "acclaim/solar/table" => "books#vh2solartbl"
      get "acclaim/trinityangels" => "books#vh2ta"
      get "acclaim/trinityangels/table" => "books#vh2tatbl"
      get "acclaim/troublemakers" => "books#vh2tm"
      get "acclaim/troublemakers/table" => "books#vh2tmtbl"
      get "acclaim/turok" => "books#vh2turok"
      get "acclaim/turok/table" => "books#vh2turoktbl"
      get "acclaim/unity2000" => "books#vh2unity"
      get "acclaim/unity2000/table" => "books#vh2unitytbl"
      get "acclaim/xomanowar" => "books#vh2xomanowar"
      get "acclaim/xomanowar/table" => "books#vh2xomanowartbl"

      get "acclaim/adventurezone/missing" => "books#vh2azmissing"
      get "acclaim/adventurezone/table/missing" => "books#vh2aztblmissing"
      get "acclaim/armorines/missing" => "books#vh2armorinesmissing"
      get "acclaim/armorines/table/missing" => "books#vh2armorinestblmissing"
      get "acclaim/all/missing" => "books#vh2allmissing"
      get "acclaim/all/table/missing" => "books#vh2alltblmissing"
      get "acclaim/bloodshot/missing" => "books#vh2bsmissing"
      get "acclaim/bloodshot/table/missing" => "books#vh2bstblmissing"
      get "acclaim/darquepassages/missing" => "books#vh2dpmissing"
      get "acclaim/darquepassages/table/missing" => "books#vh2dptblmissing"
      get "acclaim/deadside/missing" => "books#vh2dsmissing"
      get "acclaim/deadside/table/missing" => "books#vh2dstblmissing"
      get "acclaim/doctortomorrow/missing" => "books#vh2drtmissing"
      get "acclaim/doctortomorrow/table/missing" => "books#vh2drttblmissing"
      get "acclaim/eternalwarriors/missing" => "books#vh2ewsmissing"
      get "acclaim/eternalwarriors/table/missing" => "books#vh2ewstblmissing"
      get "acclaim/magnus/missing" => "books#vh2magnusmissing"
      get "acclaim/magnus/table/missing" => "books#vh2magnustblmissing"
      get "acclaim/ninjak/missing" => "books#vh2ninjakmissing"
      get "acclaim/ninjak/table/missing" => "books#vh2ninjaktblmissing"
      get "acclaim/nio/missing" => "books#vh2niomissing"
      get "acclaim/nio/table/missing" => "books#vh2niotblmissing"
      get "acclaim/misc/missing" => "books#vh2miscmissing"
      get "acclaim/misc/table/missing" => "books#vh2misctblmissing"
      get "acclaim/quantumwoody/missing" => "books#vh2qwmissing"
      get "acclaim/quantumwoody/table/missing" => "books#vh2qwtblmissing"
      get "acclaim/shadowman-vol2/missing" => "books#vh2sha2missing"
      get "acclaim/shadowman-vol2/table/missing" => "books#vh2sha2tblmissing"
      get "acclaim/shadowman-vol3/missing" => "books#vh2sha3missing"
      get "acclaim/shadowman-vol3/table/missing" => "books#vh2sha3tblmissing"
      get "acclaim/solar/missing" => "books#vh2solarmissing"
      get "acclaim/solar/table/missing" => "books#vh2solartblmissing"
      get "acclaim/trinityangels/missing" => "books#vh2tamissing"
      get "acclaim/trinityangels/table/missing" => "books#vh2tatblmissing"
      get "acclaim/troublemakers/missing" => "books#vh2tmmissing"
      get "acclaim/troublemakers/table/missing" => "books#vh2tmtblmissing"
      get "acclaim/turok/missing" => "books#vh2turokmissing"
      get "acclaim/turok/table/missing" => "books#vh2turoktblmissing"
      get "acclaim/unity2000/missing" => "books#vh2unitymissing"
      get "acclaim/unity2000/table/missing" => "books#vh2unitytblmissing"
      get "acclaim/xomanowar/missing" => "books#vh2xomanowarmissing"
      get "acclaim/xomanowar/table/missing" => "books#vh2xomanowartblmissing"

      # Other
      get "armada/baywatch" => "books#baywatch"
      get "armada/magic" => "books#magic"
      get "armada/sliders" => "books#sliders"
      get "crime/armeddangerous" => "books#armeddangerous"
      get "crime/grackle" => "books#grackle"
      get "crime/gravediggers" => "books#gravediggers"
      get "nintendo/captainn" => "books#captainn"
      get "nintendo/gameboy" => "books#gameboy"
      get "nintendo/nintendogamesystem" => "books#nintendo"
      get "nintendo/mario" => "books#mario"
      get "nintendo/zelda" => "books#zelda"
      get "windjammer/barsinister" => "books#barsinister"
      get "windjammer/knighthawk" => "books#knighthawk"
      get "windjammer/samuree" => "books#samuree"
      get "windjammer/starslayer" => "books#starslayer"
      get "wwf/wwf" => "books#wwf"

      # International
      get "brazil/all" => "books#brazil"
      get "brazil/table" => "books#braziltbl"
      get "brazil/missing" => "books#brazilmissing"
      get "brazil/table/missing" => "books#braziltblmissing"
      get "canada/all" => "books#canada"
      get "canada/table" => "books#canadatbl"
      get "canada/missing" => "books#canadamissing"
      get "canada/table/missing" => "books#canadatblmissing"
      get "china/all" => "books#china"
      get "china/table" => "books#chinatbl"
      get "china/missing" => "books#chinamissing"
      get "china/table/missing" => "books#chinatblmissing"
      get "france/all" => "books#france"
      get "france/table" => "books#francetbl"
      get "france/missing" => "books#francemissing"
      get "france/table/missing" => "books#francetblmissing"
      get "italy/all" => "books#italy"
      get "italy/table" => "books#italytbl"
      get "italy/missing" => "books#italymissing"
      get "italy/table/missing" => "books#italytblmissing"
      get "japan/all" => "books#japan"
      get "japan/table" => "books#japantbl"
      get "japan/missing" => "books#japanmissing"
      get "japan/table/missing" => "books#japantblmissing"
      get "mexico/all" => "books#mexico"
      get "mexico/table" => "books#mexicotbl"
      get "mexico/missing" => "books#mexicomissing"
      get "mexico/table/missing" => "books#mexicotblmissing"
      get "russia/all" => "books#russia"
      get "russia/table" => "books#russiatbl"
      get "russia/missing" => "books#russiamissing"
      get "russia/table/missing" => "books#russiatblmissing"
      get "turkey/all" => "books#turkey"
      get "turkey/table" => "books#turkeytbl"
      get "turkey/missing" => "books#turkeymissing"
      get "turkey/table/missing" => "books#turkeytblmissing"

      # Events
      get "events/4001ad" => "books#event4001ad"
      get "events/harbingerwars" => "books#eventshw"
      get "events/armorhunters" => "books#eventsah"
      get "events/bookofdeath" => "books#eventsbod"
      get "events/unity" => "books#eventsunity"
      get "events/chaoseffect" => "books#eventschaoseffect"
      get :manage
    end
    resource :wish, module: :books
    resource :own, module: :books
    resource :sale, module: :books
  end

  devise_for :users, :controllers => { :registrations => 'registrations', :omniauth_callbacks => 'omniauth_callbacks' }, :path => "", :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" }
  match '/users/:id' => 'users#destroy', :via => [:delete], :as => :admin_destroy_user
  match '/users/:id/profile' => "users#show", via: [:get], :as => 'profile'
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  match '/users/all' => 'users#all', via: [:get]
  match '/users/backers' => 'users#backers', via: [:get]
  match '/users/top25' => 'users#top25', via: [:get]
  match '/users/:id/followers' => "users#followers", via: [:get], :as => 'followers'
  match '/users/:id/following' => "users#following", via: [:get], :as => 'following'
  get 'users/:id/notes' => 'books#mynotes', :as => 'notes'
  get 'users/:id/collection' => 'books#mybooks', :as => 'collection'
  get 'users/:id/collection/table' => 'books#mybookstbl', :as => 'collection_table'
  get 'users/:id/current-collection' => 'books#mybooksvei', :as => 'collectionvei'
  get 'users/:id/classic-collection' => 'books#mybooksvh1', :as => 'collectionvh1'
  get 'users/:id/acclaim-collection' => 'books#mybooksvh2', :as => 'collectionvh2'
  get 'users/:id/wishlist' => 'books#mywishlist', :as => 'wishlist'
  get 'users/:id/wishlist/table' => 'books#mywishlisttbl', :as => 'wishlist_table'
  get 'users/:id/current-wishlist' => 'books#mywishlistvei', :as => 'wishlistvei'
  get 'users/:id/classic-wishlist' => 'books#mywishlistvh1', :as => 'wishlistvh1'
  get 'users/:id/acclaim-wishlist' => 'books#mywishlistvh2', :as => 'wishlistvh2'
  get 'users/:id/forsale' => 'books#forsale', :as => 'forsale'
  get 'users/:id/forsale/table' => 'books#forsaletbl', :as => 'forsale_table'
  get 'users/emails' => 'users#emails', via: [:get]
  match 'follow' => 'users#follow', via: [:get]
  match 'unfollow' => 'users#unfollow', via: [:get]
  get 'switch_user' => 'switch_user#set_current_user'

  # Releases
  get 'nextweek' => 'books#thisweek'
  get 'releases/thisweek' => 'books#thisweek'
  get 'releases/currentweek' => 'books#currentweek'
  get 'releases/nextweek' => 'books#nextweek'
  get 'releases/lastmonth' => 'books#lastmonth'
  get 'releases/thismonth' => 'books#thismonth'
  get 'releases/nextmonth' => 'books#nextmonth'
  get 'releases/twomonths' => 'books#monthafter'
  get 'releases/latestsolicitations' => 'books#latestsolicits'
  get 'releases/veibydate' => 'books#releasedate'
  get 'releases/veibydate/table' => 'books#releasedatetbl'
  get 'releases/veitimeline' => 'books#pubvei'
  get 'releases/vh1bydate' => 'books#vh1releasedate'
  get 'releases/vh1bydate/table' => 'books#vh1releasedatetbl'
  get 'releases/vh2bydate' => 'books#vh2releasedate'
  get 'releases/vh2bydate/table' => 'books#vh2releasedatetbl'
  get 'timelines/vh1' => 'books#timelinevh1'
  get 'changelog' => 'pages#changelog'
  get 'supportus' => 'pages#supportus'

  # Sales
  get 'sales/vei' => 'books#salesvei'
  get 'sales/veibytitle' => 'books#salestitle'
  get 'sales/statistics' => 'books#salesstats'
  get 'sales/titlestatistics' => 'books#salesstatstitle'
  get 'sales/topselling' => 'books#topselling'
  get 'values/topvalues' => 'books#topvalues'
  get 'values/rankings' => 'books#values'
  get 'values/missing' => 'books#valuesmissing'
  get 'feed' => 'books#feed'
  
  get 'userguide' => 'pages#userguide'
  resources "contacts", only: [:new, :create]
  get 'privacy' => 'pages#privacy'
  get 'terms' => 'pages#terms'
  get 'search' => 'pages#search'

  match 'sitemap', :to => 'sitemap#index', :via => [:get]

  # Mailbox routes
  get "mailbox/inbox" => "mailbox#inbox", as: :mailbox_inbox
  get "mailbox/sent" => "mailbox#sent", as: :mailbox_sent
  get "mailbox/trash" => "mailbox#trash", as: :mailbox_trash

  resources :conversations do
    member do
      post :reply
      post :trash
      post :untrash
    end
  end

  root :to => 'pages#home'

  # Require authentication to access Sidekiq dashboard
  authenticate :user, lambda { |u| u.admin? } do
    if Rails.env.production?
      mount Sidekiq::Web, at: '/sidekiq'
      mount PgHero::Engine, at: 'pghero'
    end 
    get 'stats' => 'users#admin', :as => 'admin'
  end

  # ERROR HANDLING
  match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all 
  #match '*path', to: 'errors#file_not_found', via: :all
  get 'errors/file_not_found' => "errors#file_not_found"
  get 'errors/unprocessable' => "errors#unprocessable"
  get 'errors/internal_server_error' => "errors#internal_server_error"
end
