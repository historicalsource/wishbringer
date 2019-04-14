"MAGICK for WISHBRINGER:
 Copyright (C)1985 Infocom, Inc. All rights reserved.
 Reconstructed from .ZAP files 5/23/88 by Prof."

<OBJECT WISHBRINGER
	(DESC "small stone")
	(FLAGS TOOLBIT RMUNGBIT TAKEBIT)
	(SYNONYM STONE ROCK LIGHT WISHBRINGER)
	(ADJECTIVE SMALL MAGIC MAGICK GLOWING VIOLET)
	(SIZE 1)
	(VALUE 5)
	(ACTION WISHBRINGER-F)>

<ROUTINE WISHBRINGER-F ()
	<COND (<VERB? EXAMINE>
	       <SAY-THE ,WISHBRINGER>
	       <COND (<FSET? ,WISHBRINGER ,ONBIT>
		      <TELL " glows">
		      <SAY-GLOW>
		      <RTRUE>)>
	       <TELL " is dark and cold." CR>
	       <RTRUE>)
	      (T
	       <RFALSE>)>>

<ROUTINE SAY-GLOW ()
	 <TELL " with an eerie violet-white radiance." CR>
	 <RTRUE>>

<ROUTINE NOT-SATISFIED ("OPT" (CONDITIONS? <>))
	 <REFER-TO-MANUAL>
	 <TELL " for a summary of what you must ">
	 <COND (.CONDITIONS?
		<TELL "do ">)
	       (T
		<TELL "be holding ">)>
	 <TELL "to make that Wish come true.)" CR>
	 <RTRUE>>

<ROUTINE BEFORE-YOU-WISH (STR OBJ)
	 <THIS-IS-IT .OBJ>
	 <TELL "(You probably ought to " .STR " the " D .OBJ
	       " before you make that Wish!)" CR>
	 <RTRUE>>

<ROUTINE STONE-IGNORES (STR)
	 <TELL "The Stone, sensing that " .STR 
	       ", decides to ignore your Wish." CR>
	 <RTRUE>>

<ROUTINE NOT-WISHING? (OBJ)
	 <COND (<VERB? WISH>
		<TELL "How can you do that ">
		<COND (<EQUAL? .OBJ ,PRSO>
		       <TELL "to">)
		      (T
		       <TELL "with">)>
		<TELL " an abstract concept like \"" D .OBJ "\"?" CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT FLIGHT
	(LOC GLOBAL-OBJECTS)
	(DESC "Flight")
	(FLAGS WISHBIT NARTICLEBIT)
	(SYNONYM FLIGHT)
	(ACTION FLIGHT-F)>

<ROUTINE FLIGHT-F ()
	 <COND (<NOT-WISHING? ,FLIGHT>
		<RFATAL>)
	       (<NOT <IN? ,BROOM ,PROTAGONIST>>
		<NOT-SATISFIED>
		<RFATAL>)
	       (<ZERO? ,BROOM-SIT?>
		<BEFORE-YOU-WISH "sit on" ,BROOM>
		<RFATAL>)
	       (<AND <FSET? ,HERE ,INDOORSBIT>
		     <NOT <EQUAL? ,HERE ,LABORATORY>>>
		<STONE-IGNORES "you're not outdoors">
		<RFATAL>)>
	 <FSET ,FLIGHT ,TOUCHBIT>
	 <FSET ,VULTURE ,RMUNGBIT>
	 <INC SPELLS>
	 <TELL 
"The Stone begins to pulse with violet Magick. Translucent planes of energy coax the broomstick ">
	 <COND (<EQUAL? ,HERE ,LABORATORY>
		<TELL "out the window and ">)>
	 <TELL "high into the moonlit sky.|
|
You feel a cool wind whip your face as you streak northward, guided by the steady glow of " ,GAME ".">
	 <TO-FINISH>
	 <MOVE ,BROOM ,CLIFF-EDGE>
	 <SETG BROOM-SIT? <>>
	 <CLATTERS ,BROOM>
	 <CRLF>
	 <V-LOOK>
	 <RTRUE>>

<OBJECT FREEDOM
	(LOC GLOBAL-OBJECTS)
	(DESC "Freedom")
	(FLAGS WISHBIT NARTICLEBIT)
	(SYNONYM FREEDOM)
	(ACTION FREEDOM-F)>

<ROUTINE FREEDOM-F ("AUX" RM)
	 <COND (<NOT-WISHING? ,FREEDOM>
		<RFATAL>)
	       (<HELD? ,CHOCOLATE> ;"NOT removed - GTB"
		<BEFORE-YOU-WISH "eat" ,CHOCOLATE>
		<RFATAL>)
	       (<ZERO? ,CHOCOLATE-SCRIPT>
		<NOT-SATISFIED T>
		<RFATAL>)
	       (<AND ,CHAINED?
		     <EQUAL? ,HERE ,TORTURE-CHAMBER>>
		<SETG CHOCOLATE-SCRIPT 1>
		<FSET ,FREEDOM ,TOUCHBIT>
		<INC SPELLS>
		<COND (<IN? ,CRISP ,TORTURE-CHAMBER>
		       <FSET ,WISHBRINGER ,NDESCBIT>
		       <MOVE ,WISHBRINGER ,COAT>
		       <TELL D ,CRISP " watches with surprise as a">
		       <FINGER-OF-LIGHT>
		       <TELL CR "\"Good trick,\" " D ,CRISP
" remarks as he relocks your chains, snatches " ,GAME
" away from you and drops it into his coat pocket. \"You'll have to tell " 
,EONE " how you did it.\"" CR>
		       <RFATAL>)>
		<OPEN-TORTURE-CHAINS>
		<TELL "A">
		<FINGER-OF-LIGHT>
		<RFATAL>)
	       (<AND <EQUAL? ,HERE ,JAIL-CELL>
		     <FSET? ,HIDDEN-HATCH ,RMUNGBIT>>
		<SET RM ,LOOKOUT-HILL>
		<COND (<EQUAL? <LOC ,BOOTS> ,LOOKOUT-HILL ,RIVER-OUTLET>
		       <SET RM ,ROTARY-WEST>)>
		<FREE-TO .RM>
		<RFATAL>)
	       (T
		<SETG CHOCOLATE-SCRIPT 2>
		<STONE-IGNORES "you're not really confined">
		<RFATAL>)>>		     
		
<ROUTINE FINGER-OF-LIGHT ()
	 <TELL 
" wraithlike finger of light jumps out of the Magick Stone! It twists itself into the shape of a " D ,KEY ", unlocks your chains and fades away." CR>
	 <RTRUE>>
	       
<ROUTINE FREE-TO (PLACE)
	 <FSET ,FREEDOM ,TOUCHBIT>
	 <FSET ,VULTURE ,RMUNGBIT>
	 <INC SPELLS>
	 <SETG CHOCOLATE-SCRIPT 1>
	 <MOVE ,PROTAGONIST .PLACE>
	 <SETG HERE .PLACE>
	 <FCLEAR .PLACE ,TOUCHBIT>
	 <TELL
"The Magick Stone shines brightly as you speak the Wish. You feel a momentary dizziness, then a breath of fresh air...">
	 <CARRIAGE-RETURNS>
	 <V-LOOK>
	 <RTRUE>>
		
<OBJECT RAIN
	(LOC GLOBAL-OBJECTS)
	(DESC "rain")
	(FLAGS WISHBIT NARTICLEBIT)
	(SYNONYM RAIN RAINWATER)
	(ACTION RAIN-F)>

<GLOBAL RAIN-ROOM <>>

<ROUTINE RAIN-F ("AUX" OBJ NXT)
	 <COND (<VERB? WISH>
		<COND (<NOT <IN? ,UMBRELLA ,PROTAGONIST>>
		       <NOT-SATISFIED>
		       <RFATAL>)
		      (<NOT <FSET? ,UMBRELLA ,OPENBIT>>
		       <BEFORE-YOU-WISH "open" ,UMBRELLA>
		       <RFATAL>)
		      (<FSET? ,HERE ,INDOORSBIT>
		       <STONE-IGNORES "you're not outdoors">
		       <RFATAL>)>
		<FSET ,RAIN ,TOUCHBIT>
		<FSET ,VULTURE ,RMUNGBIT>
		<INC SPELLS>
		<SETG RAIN-ROOM ,HERE>
		<TELL
"A searing bolt of lightning shatters the night! It strikes the glowing Stone of Dreams, and fractures the sky into a billion raindrops.|
|
Everything around you is soaked in a brief but savage downpour.">
		<COND (<EQUAL? ,HERE ,FOG>
		       <SETG HERE ,CLIFF-BOTTOM>
		       <MOVE ,PROTAGONIST ,CLIFF-BOTTOM>
		       <SETG TLOC <>>
		       <START-BUZZ 2>
		       <TELL 
" Your vision clears as the thick fog sinks away.||">
		       <V-LOOK>
		       <RTRUE>)
		      (<EQUAL? ,HERE ,EDGE-OF-LAKE>
		       <SETG PIT-FULL? T>
		       <TELL
" A flood of rainwater cascades down Lookout Hill, quickly filling the narrow pit." CR>
		       <COND (<IN? ,PLATYPUS ,PIT>
			      <THIS-IS-IT ,PLATYPUS>
			      <TELL CR 
"The platypus swims gracefully out and shakes herself off.||">
			      <DRAW-X>)>
		       <COND (<SET OBJ <FIRST? ,PIT>>
			      <REPEAT ()
				 <COND (<ZERO? .OBJ>
					<RETURN>)>
				 <SET NXT <NEXT? .OBJ>>
				 <COND (<NOT <EQUAL? .OBJ ,BRANCH>>
					<REMOVE .OBJ>)>
				 <SET OBJ .NXT>>)>
		       <RTRUE>)>
		<CRLF>
		<SET OBJ <REACTOR?>>
		<COND (<ZERO? .OBJ>
		       <RTRUE>)>
		<TELL CR "It's obvious that ">
		<ARTICLE .OBJ T>
		<TELL " did not enjoy the sudden bath." CR>
		<RTRUE>)
	       (<OR <NOT <FSET? ,RAIN ,TOUCHBIT>>
		    <NOT <EQUAL? ,HERE ,RAIN-ROOM>>>
		<TELL "No rain is expected">
		<COND (<FSET? ,HERE ,INDOORSBIT>
		       <TELL ", especially indoors." CR>
		       <RFATAL>)>
		<TELL " here." CR>
		<RFATAL>)
	       (<AND ,PIT-FULL?
		     <EQUAL? ,HERE ,EDGE-OF-LAKE>>
		<TELL "The only rain here is in the pit." CR>
		<RFATAL>)
	       (T
		<TELL "Alas. The rain is all gone." CR>
		<RFATAL>)>>
		
<OBJECT FORESIGHT
	(LOC GLOBAL-OBJECTS)
	(DESC "Foresight")
	(FLAGS WISHBIT NARTICLEBIT)
	(SYNONYM FORESIGHT)
	(ACTION FORESIGHT-F)>

<ROUTINE FORESIGHT-F ("AUX" FROM)
	 <COND (<NOT-WISHING? ,FORESIGHT>
		<RFATAL>)
	       (<NOT <IN? ,GLASSES ,PROTAGONIST>>
		<NOT-SATISFIED>
		<RFATAL>)
	       (<NOT <FSET? ,GLASSES ,WORNBIT>>
		<BEFORE-YOU-WISH "wear" ,GLASSES>
		<RFATAL>)>
	 <FSET ,FORESIGHT ,TOUCHBIT>
	 <FSET ,VULTURE ,RMUNGBIT>
	 <INC SPELLS>
	 <TELL "The ">
	 <COND (,FUZZY?
	        <TELL <PICK-ONE ,BLURS> " ">)>
	 <COND (<FSET? ,HERE ,INDOORSBIT>
		<TELL "room around you">)
	       (T
		<TELL "moonlight">)>
	 <TELL " fades as you speak the Wish.">
	 <SET FROM ,HERE>
	 <SETG HERE ,MUSEUM>
	 <CARRIAGE-RETURNS>
	 <USL>
	 <TELL
"A pinprick of brilliance pierces the gloom. It creeps closer, growing more powerful and unearthly as it approaches.|
|
The light is shining from the forehead of a " D ,KITTY
"! It leaps into your arms and curls comfortably around your neck, purring like an old companion.|
|
Suddenly a pair of gnarled hands closes around the " D ,KITTY
" and tears it away from you. The glowing spot on the cat's forehead drops into your open palm as the thief disappears with a cackle into the " D ,DARKNESS
".|
|
An aged voice in your mind chuckles, ">
	 <LIAR>
	 <TELL ".\"">
	 <CARRIAGE-RETURNS>
	 <SETG HERE .FROM>
	 <COND (<ZERO? ,FUZZY>
		<SET FROM <ANYONE-HERE?>>
		<COND (<NOT <EQUAL? .FROM <> ,KITTY ,BABY>>
		     ; <TELL " ">
		       <COND (<FSET? .FROM ,NARTICLEBIT>
			      <TELL "The ">)>
		       <STRANGE-LOOK .FROM>
		       <CRLF>)>)>
	 <RFATAL>>
	       
<ROUTINE LIAR ()
	 <TELL "\"Now you know me for the old liar I am">
	 <RTRUE>>

<ROUTINE STRANGE-LOOK (WHO)
	 <TELL D .WHO " gives you a strange look." CR>
	 <RTRUE>>

<OBJECT LUCK
	(LOC GLOBAL-OBJECTS)
	(DESC "Luck")
	(FLAGS WISHBIT NARTICLEBIT)
	(SYNONYM LUCK)
	(ACTION LUCK-F)>

<GLOBAL LUCKY? <>>

<ROUTINE LUCK-F ()
	 <COND (<NOT-WISHING? ,LUCK>
		<RFATAL>)
	       (<NOT <IN? ,SHOE ,PROTAGONIST>>
		<NOT-SATISFIED>
		<RFATAL>)>
	 <FSET ,LUCK ,TOUCHBIT>
	 <FSET ,VULTURE ,RMUNGBIT>
	 <INC SPELLS>
	 <SETG LUCKY? T>
	 <FSET ,SHOE ,ONBIT>
	 <ENABLE <QUEUE I-LUCK -1>>
	 <THIS-IS-IT ,SHOE>
	 <TELL
"The Stone of Dreams brightens as you speak the Wish, and the edges of the "
D ,SHOE " begin to twinkle with Luck." CR>
	 <COND (<EQUAL? ,HERE ,FOG>
		<SETG TLOC <>>
		<SETG HERE ,CLIFF-BOTTOM>
		<MOVE ,PROTAGONIST ,CLIFF-BOTTOM>
		<WALK-OUT-OF-FOG>
		<V-LOOK>)>
	 <RFATAL>>
	       
<ROUTINE BAD-LUCK (STR)
	 <TELL CR "(It's bad luck to " .STR ".">
	 <COND (<ENABLED? ,I-LUCK>
		<DISABLE <INT I-LUCK>>
		<TELL " You've neutralized the Luck Wish!)" CR>
		<I-LUCK T>
		<RTRUE>)>
	 <TELL ")" CR>
	 <RTRUE>>

<OBJECT ADVICE
	(LOC GLOBAL-OBJECTS)
	(DESC "Advice")
	(FLAGS WISHBIT NARTICLEBIT)
	(SYNONYM ADVICE)
	(ACTION ADVICE-F)>

<ROUTINE ADVICE-F ()
	 <COND (<NOT-WISHING? ,ADVICE>
		<RFATAL>)
	       (<NOT <IN? ,CONCH-SHELL, PROTAGONIST>>
		<NOT-SATISFIED>
		<RFATAL>)>
	 <FSET ,ADVICE ,TOUCHBIT>
	 <FSET ,VULTURE ,RMUNGBIT>
	 <INC SPELLS>
	 <ENABLE <QUEUE I-SHELL-TALK -1>>
	 <TELL ,GAME " emits a violet flash of Magick." CR>
	 <RFATAL>>

<OBJECT DARKNESS
	(LOC GLOBAL-OBJECTS)
	(DESC "darkness")
	(FLAGS WISHBIT NARTICLEBIT)
	(SYNONYM DARKNESS DARK)
	(ACTION DARKNESS-F)>

<GLOBAL DARK-PLACE <>>
<GLOBAL ECLIPSE? <>>

<ROUTINE DARKNESS-F ("AUX" (INDOORS? <>) WHO)
	 <COND (<VERB? WISH>
		<COND (<AND <IN? ,BOTTLE ,PROTAGONIST>
			    <IN? ,MILK ,BOTTLE>>
		       <BEFORE-YOU-WISH "drink" ,MILK>
		       <RFATAL>)
		      (<ZERO? ,MILK-SCRIPT>
		       <NOT-SATISFIED T>
		       <RFATAL>)
		      (<NOT <FSET? ,HERE ,ONBIT>>
		       <STONE-IGNORES "dim enough in here already">
		       <RFATAL>)>
		<FSET ,DARKNESS ,TOUCHBIT>
		<FSET ,VULTURE ,RMUNGBIT>
		<INC SPELLS>
		<SETG DARK-PLACE ,HERE>
		<SETG MILK-SCRIPT 1>
		<ENABLE <QUEUE I-ECLIPSE 2>>
		<FCLEAR ,WISHBRINGER ,ONBIT>
		<FCLEAR ,SHOE ,ONBIT>
		<SETG ECLIPSE? T>
		<SETG MOVIE-STATUS ,NO-MOVIE?>
		<SETG NO-MOVIE? T>
		<COND (<FSET? ,HERE ,INDOORSBIT>
		       <SET INDOORS? T>)>
		<SET WHO <REACTOR?>>
		<TELL "The ">
		<COND (.INDOORS?
		       <TELL "air">)
		      (T
		       <TELL "night">)>
		<TELL " becomes very still as you speak the Wish. ">
		<COND (<EQUAL? .WHO ,HELLHOUND ,PELICAN>
		       <SAY-THE .WHO>
		       <COND (<EQUAL? .WHO ,HELLHOUND>
			      <TELL " stops ">
			      <COND (,HELLHOUND-HAPPY?
				     <TELL "thumping its tail,">)
				    (T
				     <TELL "in mid-roar,">)>)>
		       <TELL " cocks its head and sniffs the air nervously.">)
		      (<EQUAL? .WHO ,TROLL ,GRAVEDIGGER>
		       <SAY-THE .WHO>
		       <FROWNS>)
		      (<EQUAL? .WHO ,MACGUFFIN ,CRISP ,KING>
		       <TELL D .WHO>
		       <FROWNS>)
		      (<EQUAL? .WHO ,MISS-VOSS ,PRINCESS ,EVIL-ONE>
		       <TELL D .WHO>
		       <FROWNS T>)
		      (.WHO
		       <TELL "You notice ">
		       <ARTICLE .WHO T>
		       <TELL " looking">
		       <NERVOUSLY>)>
		<TELL
"||All at once a terrifying shadow sweeps across the ">
		<COND (.INDOORS?
		       <TELL "surface of " ,GAME>)
		      (T
		       <TELL "face of the full moon">)>
		<COND (<FSET? ,CANDLE ,ONBIT>
		       <FCLEAR ,CANDLE ,ONBIT>
		       <COND (<VISIBLE? ,CANDLE>
			      <TELL ". The candle flame withers and dies">)>)>
		<TELL ", plunging the ">
		<COND (.INDOORS?
		       <TELL "room">)
		      (T
		       <TELL "landscape">)>
		<TELL " into total darkness.">
		<COND (<EQUAL? .WHO ,HELLHOUND>
		       <TELL CR CR>
		       <SAY-THE ,HELLHOUND>
		       <TELL 
"'s eyes grow wide with terror. It flops itself down on the ground, covers its eyes with its forepaws and moans pitifully">
		       <IN-GLOOM>)
		      (<EQUAL? .WHO ,TROLL>
		       <CRLF>
		       <FRIGHTEN-TROLL>)
		      (<EQUAL? .WHO ,GRAVEDIGGER>
		       <TELL "|
|
\"Who turned out the lights?!\" cries the " D ,GRAVEDIGGER
", stumbling around the pitch-black lobby in terror." CR>)
		      (.WHO
		       <TELL CR CR ,YOU-HEAR>
		       <ARTICLE .WHO T>
		       <TELL "making fearful noises">
		       <IN-GLOOM>)
		      (T
		       <CRLF>)>
		<SETG LIT <LIT? ,HERE>>
		<RTRUE>)
	       (<AND <EQUAL? ,PRSO ,DARKNESS>
		     <SEE-VERB?>>
		<YOU-CANT-SEE>
		<TELL "anything in darkness!" CR>
		<RFATAL>)
	       (<OR <EQUAL? ,PRSA ,V?LISTEN ,V?YELL>
		    <TALKING-TO? ,DARKNESS>>
		<TELL "You hear nothing." CR>
		<RFATAL>)
	       (<NOT-WISHING? ,DARKNESS>
		<RFATAL>)
	       (T
		<RFALSE>)>>
		
<ROUTINE IN-GLOOM ()
	 <TELL " in the sudden gloom." CR>
	 <RTRUE>>

<ROUTINE NERVOUSLY ()
	 <TELL " around nervously.">
	 <RTRUE>>

<ROUTINE FROWNS ("OPT" (FEMALE? <>))
	 <TELL " frowns, blinks ">
	 <COND (.FEMALE?
		<TELL "her">)
	       (T
		<TELL "his">)>
	 <TELL " eyes and looks">
	 <NERVOUSLY>
	 <RTRUE>>

<ROUTINE REACTOR? ("AUX" WHO)
	 <COND (<AND <EQUAL? ,HERE ,EDGE-OF-LAKE>
		     <IN? ,PLATYPUS ,PIT>>
		<RETURN ,PLATYPUS>)
	       (<EQUAL? ,HERE ,THRONE-ROOM>
		<RETURN ,CROWD>)>
	 <SET WHO <ANYONE-HERE?>>
	 <COND (<EQUAL? .WHO <> ,BABY>
		<RFALSE>)
	       (<AND <EQUAL? .WHO ,KITTY>
		     <FSET? ,KITTY ,RMUNGBIT>>
		<RFALSE>)>
	 <RETURN .WHO>>
	       
<ROUTINE I-ECLIPSE ("AUX" WHO)
	 <COND (,LUCKY?
		<FSET ,SHOE ,ONBIT>)>
	 <DISABLE <INT I-ECLIPSE>>
	 <SETG ECLIPSE? <>>
	 <SETG NO-MOVIE? ,MOVIE-STATUS>
	 <FSET ,VULTURE ,RMUNGBIT>
	 <FSET ,WISHBRINGER ,ONBIT>
	 <TELL CR "As suddenly as it faded, the light ">
	 <COND (<FSET? ,HERE ,INDOORSBIT>
		<COND (<VISIBLE? ,WISHBRINGER>
		       <TELL "from " ,GAME>)
		      (T
		       <TELL "around you">)>)
	       (T
		<TELL "of the moon">)>
	 <TELL " returns">
	 <COND (<AND <NOT <FSET? ,CANDLE ,RMUNGBIT>>
		     <NOT <FSET? ,CANDLE ,ONBIT>>>
		<FSET ,CANDLE ,ONBIT>
		<COND (<VISIBLE? ,CANDLE>
		       <TELL ", and the candle flares back to life">)>)>
	 <TELL ".">
	 <SET WHO <REACTOR?>>
	 <COND (<EQUAL? .WHO ,HELLHOUND>
		<SETG DOG-SCRIPT 0>
		<TELL CR CR>
		<SAY-THE ,HELLHOUND>
		<TELL
" recovers from its embarrassing fear of darkness, and ">
		<COND (,HELLHOUND-HAPPY?
		       <TELL "thumps its tail">)
		      (T
		       <TELL "snarls at you">)>
		<TELL " with renewed enthusiasm.">)
	       (.WHO
		<TELL "||With a ">
		<COND (<EQUAL? .WHO ,CROWD ,HUMANOIDS>
		       <TELL "collective ">)>
		<TELL "sigh of relief, ">
		<ARTICLE .WHO T>
		<TELL D .WHO " turn">
		<COND (<NOT <EQUAL? .WHO ,HUMANOIDS ,BOOTS>>
		       <TELL "s">)>
		<TELL " to look at you.">)>
	 <CRLF>
	 <SETG LIT <LIT? ,HERE>>
	 <COND (<NOT <EQUAL? ,HERE ,DARK-PLACE>>
		<CRLF>
		<V-LOOK>)>
	 <SETG DARK-PLACE <>>
	 <RTRUE>>

<OBJECT MOON
	(LOC GLOBAL-OBJECTS)
	(DESC "moon")
	(FLAGS NDESCBIT)
	(SYNONYM MOON)
	(ACTION MOON-F)>

<ROUTINE MOON-F ()
	 <COND (<OR <ZERO? ,SKEWED?>
		    <FSET? ,HERE ,INDOORSBIT>>
		<YOU-CANT-SEE>
		<TELL "the moon right now." CR>
		<RFATAL>)
	       (<VERB? LOOK-ON EXAMINE>
		<SAY-THE ,MOON>
		<COND (,ECLIPSE?
		       <TELL " has disappeared!" CR>
		       <RFATAL>)>
		<TELL "'s cold light makes you shiver." CR>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,MOON>
		<RFATAL>)>>

