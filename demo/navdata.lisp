;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Package: CLIM-DEMO; Base: 10; Lowercase: Yes -*-

;; $Header: /repo/cvs.copy/clim2/demo/navdata.lisp,v 1.7.22.1 1998/05/19 01:04:50 layer Exp $

(in-package :clim-demo)

(defparameter *default-nav-data* '(
( 5 "0B6"   a    122.8  "Chatham, CT          " 41 41.3   69 59.3  15.0 w   72 )
( 6 "22B"   a    122.8  "Burlington,CT Jnycak " 41 46.4   73  0.7  13.0 w 1020 )
( 7 "3B9"   a    122.8  "Chester, CT          " 41 23.0   72 30.3  13.0 w  416 )
( 8 "42B"   a    122.8  "E Hadden, CT Gdspeed " 41 26.7   72 27.4  13.0 w    9 )
( 9 "4B8"   a    122.8  "Plainville,CT Rbrtsn " 41 41.4   72 51.9  13.0 w  200 )
(12 "5B3"   a    123.0  "Danielson, CT        " 41 49.2   71 54.1  14.0 w  239 )
(15 "7B8"   a    122.9  "Waterford, CT        " 41 22.0   71  9.0  14.0 w   64 )
(16 "7B9"   a    123.0  "Ellington, CT        " 41 55.5   72 27.5  14.0 w  253 )
(17 "BDL"   a    120.3  "Windsor Locks, CT    " 41 56.3   72 41.0  14.0 w  174 )
(18 "BDR"   v    108.8  "BRIDGEPORT,CT VORTAC " 41  9.6   73  7.5  14.0 w   10 )
(20 "HFD"   v    114.9  "HARTFORD,CT VORTAC   " 41 38.5   72 32.9  13.0 w  850 )
(21 "HVN"   v    109.8  "NEW HAVEN,CT VORTAC  " 41 15.7   72 53.2  13.0 w   10 )
(23 "MMK"   an   238    "Meridan-markham,CT   " 41 30.6   72 49.8  13.0 w  102 )
(24 "N04"   a    122.8  "Madison,CT GRiswold  " 41 16.3   72 33.0  13.0 w   15 )
(25 "ORW"   v    110.0  "NORWICH,CT VORTAC    " 41 33.4   71 59.0  14.0 w  310 )
(26 "OXC"   a    nil    "Waterbury-Oxford,CT  " 41 28.8   73  8.1  13.0 w  727 )
(27 "PUT"   v    117.4  "PUTNAM,CT VORTAC     " 41 57.3   71 50.7  14.0 w  650 )
(28 "TMU"   v    111.8  "GROTON,CT VORTAC     " 41 19.8   72  3.2  14.0 w   10 )

(85 "0B5"   a    123.0  "Montague,MA Turners  " 42 35.5   72 31.4  14.0 w  356 )
(86 "1B6"   a    122.8  "Hopedale, MA Draper  " 42  6.4   71 30.7  14.0 w  269 )
(87 "1B9"   an   220    "Mansfield, MA        " 42  0.3   71 12.0  15.0 w  124 )
(88 "2B2"   a    123.0  "Newburyport,MA Plum  " 42 47.8   70 50.5  15.0 w   11 )
(89 "2B6"   a    122.8  "N Adams,MA Harriman  " 42 41.8   73 10.3  14.0 w  654 )
(91 "3B2"   an   368    "Marshfield, MA       " 42  5.9   70 40.3  15.0 w    9 )
(92 "3B3"   a    122.9  "Sterling, MA         " 42 25.5   71 47.5  14.0 w  459 )
(93 "5B6"   a    122.8  "Falmouth, MA         " 41 35.1   70 32.5  15.0 w   43 )
(94 "6B6"   a    122.8  "Stow, MA Minit Man   " 42 27.8   71 31.0  15.0 w  268 )
(95 "7B2"   a    122.7  "Northampton,MA       " 42 19.7   72 36.7  14.0 w  123 )
(00 "ACK"   a    118.3  "Nantucket, MA Arpt   " 41 15.1   70  3.6  15.0 w   48 )
(02 "B09"   a    122.8  "Tewksbury, MA        " 42 35.8   71 12.3  15.0 w   92 )
(03 "BAF"   av   113.0  "Westfield, MA Barnes " 42 16.9   72 43.0  14.0 w  270 )
(04 "BAF"   a    118.9  "Westfield, MA Arpt.  " 42  9.4   72 42.9  14.0 w  271 )
(05 "BED"   a    118.5  "Bedford, MA Hanscom  " 42 28.2   71 17.4  15.0 w  133 )
(06 "BOS"   a    119.1  "Boston, MA Logan Apt " 42 21.8   71  0.3  15.0 w   20 )
(07 "BOS"   av   112.7  "Boston, MA Logan     " 42 21.9   71  0.4  15.0 w   20 )
(08 "BUZCP" c    nil    "Buzzards Bay CP, MA  " 41 36.0   70 49.0  15.5 w   50 )
(09 "BVY"   a    125.2  "Beverly, MA          " 42 35.1   70 55.1  15.0 w  108 )
(10 "CEF"   av   114.0  "Chcopee,MA Wstvr AFB " 42 11.9   72 31.8  14.0 w  245 )
(11 "CTR"   v    115.1  "Chester, MA VOR      " 42 17.5   72 57.0  13.0 w 1600 )
(12 "EWB"   a    118.1  "New Bedford, MA      " 41 40.6   70 57.5  14.0 w   80 )
(13 "FALCP" c    nil    "Fall River CP, MA    " 41 49.0   71  4.0  15.0 w  361 )
(14 "FIT"   a    122.7  "Fitchburg, MA        " 42 33.1   71 45.4  14.0 w  350 )
(15 "FLR"   an   201    "Fall River, MA       " 41 45.3   71  6.7  14.0 w  193 )
(16 "GBR"   an   395    "Great Barrinton, MA  " 42 11.0   73 24.2  13.0 w  739 )
(17 "GDM"   av   110.6  "Gardner, MA          " 42 32.8   72  3.5  14.0 w  350 )
(18 "HTM"   v    114.5  "Whitman, MA VOR      " 42  3.8   70 59.0  15.0 w  120 )
(20 "HYA"   a    119.5  "Hyannis MUN., MA     " 41 40.1   70 16.8  15.0 w   52 )
(21 "LWM"   av   112.5  "Lawrence, MA         " 42 43.0   71  7.4  15.0 w  149 )
(22 "MA02"  a   122.975 "Hanson, MA Cranland  " 42  1.5   70 50.3  13.0 w   71 )
(25 "MA08"  a    122.9  "Oxford, MA           " 42  9.1   71 50.1  14.0 w  763 )
(26 "MANCP" c    nil    "Mansfield CP, MA     " 42  5.0   71 20.0  15.0 w  640 )
(28 "MVY"   a    121.4  "Martha's Vineyard,MA " 41 23.5   70 36.9  15.0 w   68 )
(29 "ORE"   an   365    "Orange, MA           " 42 34.1   72 17.5  14.0 w  555 )
(30 "ORH"   a    120.5  "Worcester, MA        " 42 16.0   71 52.6  14.0 w 1008 )
(31 "OWD"   a    126.0  "Norwood, MA          " 42 11.5   71 10.4  15.0 w   50 )
(32 "PMX"   an   212    "Palmer, MA Metro     " 42 13.4   72 18.7  14.0 w  418 )
(33 "PRVCP" c    nil    "Provincetown/V431,MA " 42  3.0   70 21.0  16.0 w    0 )
(34 "PSF"   a    122.7  "Pittsfield, MA       " 42 25.6   73 17.6  13.0 w 1194 )
(35 "PVC"   an   232    "Provincetown, MA     " 42  4.3   70 13.3  15.0 w    8 )
(36 "PYM"   a    123.0  "Plymouth, MA Arpt    " 41 54.7   70 43.7  15.0 w  149 )
(38 "RKPCP" c    nil    "Rockport, MA.        " 42 39.0   70 37.0  16.0 w  500 )
(39 "TAN"   an   227    "Taunton, MA          " 41 52.8   71  1.3  14.0 w   42 )
(62 "1B0"   a    122.9  "Dexter, ME           " 45  0.5   69 14.4  19.0 w  533 )
(63 "43B"   a    122.9  "Deblois, ME          " 44 43.5   67 59.5  19.0 w  217 )
(64 "47B"   a    122.8  "Eastport, ME         " 44 54.7   67  0.8  20.0 w   67 )
(65 "65B"   a    122.8  "Lubec, ME (turf)     " 44 50.3   67  2.0  19.0 w   85 )
(66 "7B4"   an   251    "Machias Valley,ME    " 44 42.2   67 28.7  19.0 w  107 )
(67 "98B"   an   278    "Belfast, ME          " 44 24.6   69  0.8  19.0 w  195 )
(68 "AUG"   a    123.6  "Augusta St, ME Arpt. " 44 19.1   69 47.8  18.0 w  353 )
(69 "AUG"   av   111.4  "Augusta, ME VOR      " 44 19.2   69 47.8  18.0 w  353 )
(70 "B19"   a    123.0  "Biddeford, ME        " 43 27.9   70 28.4  17.0 w  162 )
(71 "B21"   a    122.8  "Carrabassett,ME S'1f " 45  5.2   70 13.0  18.0 w  885 )
(72 "BGR"   av   114.8  "Bangor, ME VOR       " 44 50.5   68 52.5  19.0 w  192 )
(73 "BGR"   a    120.7  "Bangor Intl., ME     " 44 48.4   68 49.3  19.0 w  192 )
(74 "BHB"   a    123.0  "Bar Harbor,ME Hncock " 44 27.0   68 21.7  19.0 w   84 )
(75 "CAR"   a    122.8  "Caribou, ME          " 46 52.3   68  1.3  21.0 w  623 )
(76 "ENE"   v    117.1  "Kennebunkport, ME    " 43 25.5   70 36.8  17.0 w  190 )
(77 "HUL"   v    116.1  "Houlton, ME VOR      " 46  2.4   67 50.1  21.0 w  860 )
(78 "LEW"   a    122.8  "Auburn-Lewiston, ME  " 44  2.9   70 17.0  18.0 w  288 )
(79 "MLT"   v    117.9  "Millinocket, ME VOR  " 45 35.2   68 30.0  20.0 w  550 )
(80 "NHZ"   v    115.2  "Brunswick, ME VOR    " 43 54.1   69 56.7  18.0 w   80 )
(81 "OLD"   a    122.8  "Old Town, ME         " 44 57.3   68 40.5  19.0 w  126 )
(82 "PNN"   v    114.3  "Princton, ME VOR     " 45 19.7   67 42.3  21.0 w  400 )
(83 "PQI"   v    116.4  "Presque Isle, ME VOR " 46 46.4   68  5.7  21.0 w  590 )
(84 "PWM"   a    120.9  "Portland, ME         " 43 38.8   70 18.5  17.0 w   74 )
(85 "RKD"   a    122.8  "Rockland,ME Knox Co. " 44  3.6   69  6.0  18.0 w   55 )

(23 "BLO"   n    328    "Belkap, NH NDB       " 43 32.2   71 32.3  16.0 w  500 )
(24 "BML"   v    110.4  "Berlin, NH VOR       " 44 38.1   71 11.2  17.0 w 1685 )
(25 "CON"   av   112.9  "Concord, NH          " 43 12.2   71 30.2  15.0 w  346 )
(26 "EEN"   av   109.4  "Keene, NH            " 42 53.9   72 16.3  14.0 w  487 )
(27 "IVV"   n    379    "White River, NH NDB  " 43 33.6   72 28.0  15.0 w 1500 )
(28 "LEB"   av   113.7  "Lebanon, NH          " 43 37.7   72 18.3  15.0 w  581 )
(29 "MHT"   a    121.3  "Manchester, NH       " 42 56.0   71 26.3  15.0 w  234 )
(30 "MHT"   v    114.4  "Manchester,NH VOR    " 42 52.1   71 22.2  15.0 w  470 )
(31 "PSM"   v    116.5  "Pease, NH VOR        " 43  5.1   70 49.0  16.0 w  100 )

(62 "01G"   a    nil    "Perry-Warsaw, NY     " 42 44.5   78  3.0   9.0 w 1557 )
(63 "06N"   a    nil    "Middletown,NY Rndall " 41 25.9   74 23.8  11.0 w  524 )
(64 "0B8"   a    nil    "Fishers Is,NY Elzbth " 41 15.3   72  2.0  14.0 w    9 )
(65 "0G0"   a    nil    "Lockport, NY         " 43  6.2   78 42.2   9.0 w  587 )
(66 "0G7"   a    nil    "Seneca Falls, NY     " 42 52.8   76 46.9  10.0 w  491 )
(67 "10N"   a    nil    "Walkill, NY          " 41 37.7   74  8.1  12.0 w  420 )
(69 "1B8"   a    nil    "Canastota, NY        " 43  4.3   75 46.3  11.0 w  545 )
(73 "3G7"   a    nil    "Williamson-Sodus, NY " 43 14.1   77  7.3   9.0 w  425 )
(77 "4B2"   a    nil    "Utica,NY Riverside   " 43  8.0   75 16.1  12.0 w  410 )
(80 "4G2"   a    nil    "Hamburg, NY Airdrome " 42 42.1   78 54.9   8.0 w  751 )
(81 "4G6"   a    nil    "Hornell, NY Muni     " 42 22.8   77 40.9   9.0 w 1193 )
(84 "6B4"   a    nil    "Frankfurt/Utica,NY   " 43  1.3   75 10.3  10.0 w 1325 )
(85 "6B9"   a    nil    "Skaneateles, NY      " 42 54.9   76 26.4  11.0 w 1038 )
(86 "7G0"   a    nil    "Brockport, NY        " 43 10.9   77 54.8   9.0 w  665 )
(87 "9G0"   a    nil    "Buffalo, NY Airpark  " 42 51.7   78 43.0   8.0 w  670 )
(88 "9G3"   a    nil    "Akron, NY            " 43  1.3   78 29.1   8.0 w  840 )
(89 "9G5"   a    nil    "Gasport, NY Royalton " 43 10.9   78 33.5   9.0 w  628 )
(90 "9G6"   a    nil    "Pine Hill, NY        " 43 10.4   78 16.5   8.0 w  663 )
(93 "ART"   av   109.8  "WATERTOWN,NY VOR     " 43 57.1   76  3.9  12.0 w  370 )
(94 "B01"   a    nil    "Granville, NY        " 43 25.5   73 15.8  14.0 w  420 )
(95 "B24"   a    nil    "Hamilton,NY AMA Exec " 42 50.6   75 33.7  11.0 w 1134 )
(00 "CAM"   v    115.0  "CAMBRIDGE,NY VORTAC  " 42 59.7   73 20.7  14.0 w 1490 )
(04 "D22"   a    nil    "Angola, NY           " 42 39.4   78 59.5   7.0 w  709 )
(05 "D77"   a    nil    "Lancaster, NY        " 42 55.3   78 36.8   9.0 w  750 )
(06 "DKK"   v    116.2  "DUNKIRK,NY VOR       " 42 29.4   79 16.5   7.0 w  680 )
(07 "DNY"   v    112.1  "DE LANCEY,NY VOR     " 42 10.7   74 57.4  11.0 w 2560 )
(09 "DSV"   a    nil    "Dansville, NY        " 42 34.3   77 42.8   9.0 w  662 )
(10 "ELM"   v    109.65 "ELMIRA,NY  VOR       " 42  5.7   77  1.5   9.0 w 1620 )
(11 "ELM"   a    121.1  "ELMIRA REG,NY ARPT   " 42  9.5   76 53.5   9.0 w  955 )
(12 "ELZ"   av   111.4  "WELLSVILLE,NY VOR    " 42  5.4   77 59.0   9.0 w 2300 )
(16 "GEE"   v    108.2  "GENESEO,NY VOR       " 42 50.1   77 43.0   9.0 w  990 )
(17 "GFL"   v    110.2  "GLENS FALLS,NY VOR   " 43 20.5   73 36.7  14.0 w  320 )
(18 "GGT"   v    115.2  "GEORGETOWN,NY VOR    " 42 47.3   75 49.6  11.0 w 2040 )
(19 "HNK"   v    116.8  "HANCOCK,NY VOR       " 42  3.8   75 19.0  11.0 w 2070 )
(20 "HPN"   a    nil    "White Plains, NY     " 41  4.0   73 42.5  12.0 w  439 )
(23 "HUO"   v    116.1  "HUGUENOT,NY VOR      " 41 24.6   74 35.5  11.0 w 1300 )
(29 "JHW"   a    nil    "Jamestown, NY        " 42  9.2   79 15.5   7.0 w 1724 )
(30 "JHW"   v    114.7  "JAMESTOWN,NY VOR     " 42 11.3   79  7.3   7.0 w 1790 )
(33 "MAL"   a    nil    "Malone-Dufort, NY    " 44 51.2   74 19.7  14.0 w  791 )
(34 "MGJ"   a    nil    "Mntgmry,NY Orange Co " 41 30.7   74 15.9  11.0 w  365 )
(35 "MSS"   a    nil    "Massena, NY Richards " 44 56.2   74 50.8  14.0 w  214 )
(36 "MSS"   v    114.1  "MASSENA,NY VORTAC    " 44 54.9   74 43.4  14.0 w  200 )
(37 "MSV"   a    nil    "Monticello,NY Sullvn " 41 42.1   74 47.7  11.0 w 1403 )
(39 "N00"   a    nil    "Fulton, NY Oswego    " 43 21.0   76 23.3  11.0 w  469 )
(40 "N03"   a    nil    "Cortland, NY         " 42 35.6   76 12.9  11.0 w 1197 )
(41 "N17"   a    nil    "Endicott, NY         " 42  4.7   76  5.8  10.0 w  833 )
(42 "N22"   a    nil    "Penn Yan, NY         " 42 38.6   77  3.3  10.0 w  903 )
(43 "N23"   a    nil    "Sidney, NY Muni      " 42 18.2   75 25.0  11.0 w 1027 )
(45 "N37"   a    nil    "Monticello, NY       " 41 37.2   74 42.2  11.0 w 1545 )
(46 "N66"   a    nil    "Oneonta,NY Muni      " 42 31.4   75  4.0  11.0 w 1764 )
(48 "N82"   a    nil    "Wurtsboro, NY        " 41 35.9   74 27.5  12.0 w  560 )
(49 "N89"   a    nil    "Ellenville, NY       " 41 43.7   74 22.7  12.0 w  292 )
(50 "NK03"  a    nil    "Durhamville, NY      " 43  8.1   75 38.9  12.0 w  443 )
(51 "NY08"  a    nil    "Brewerton, NY (Syr)  " 43 16.0   76 10.7  11.0 w  400 )
(52 "NY43"  a    nil    "Piseco, NY           " 43 27.2   74 31.1  12.0 w 1704 )
(53 "OGS"   a    nil    "Ogdensburg, NY Intl  " 44 40.9   75 28.0  14.0 w  297 )
(54 "OIC"   a    nil    "Norwich, NY Eaton    " 42 34.0   75 31.5  11.0 w 1019 )
(55 "OLE"   a    nil    "Olean, NY Muni       " 42 14.4   78 22.3   9.0 w 2135 )
(56 "PLB"   v    116.9  "PLATTSBURGH,NY VOR   " 44 41.1   73 31.4  15.0 w  344 )
(57 "PLB"   a    nil    "Plattsburgh,NY Clntn " 44 41.2   73 31.4  15.0 w  371 )
(59 "PTD"   a    nil    "Potsdam, NY Damon    " 44 40.0   74 57.0  14.0 w  474 )
(61 "RKA"   v    112.6  "ROCKDALE,NY VORTAC   " 42 27.0   75 14.4  11.0 w 2030 )
(62 "ROC"   av   110.0  "ROCHESTER,NY VORTAC  " 43  7.3   77 40.4   9.0 w  550 )
(63 "RYK"   v    108.4  "Romulus,NY VOR       " 42 42.8   76 53.0  10.0 w  635 )
(65 "SLK"   av   111.2  "SARANAC LAKE,NY VOR  " 44 23.1   74 12.3  14.0 w 1650 )
(67 "SYR"   v    117.0  "SYRACUSE,NY VORTAC   " 43  9.6   76 12.3  11.0 w  420 )
(68 "SYR"   a    nil    "Syracuse,NY Hancock  " 43  6.7   76  6.5  11.0 w  421 )
(69 "UCA"   v    108.6  "UTICA,NY VORTAC      " 43  1.6   75  9.9  12.0 w 1420 )
(70 "UCA"   a    nil    "Utica, NY Oneida     " 43  8.7   75 23.1  12.0 w  743 )

))
