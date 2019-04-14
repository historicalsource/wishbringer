"GLOBALS for WISHBRINGER: (C)1985 Infocom, Inc. All Rights Reserved."

<DIRECTIONS NORTH NE EAST SE SOUTH SW WEST NW UP DOWN IN OUT>

<GLOBAL HERE 0>

<GLOBAL LIT T>

<GLOBAL MOVES 0>
<GLOBAL SCORE 0>

<OBJECT GLOBAL-OBJECTS
	(FLAGS RMUNGBIT INVISIBLE TOUCHBIT SURFACEBIT
	       TRYTAKEBIT OPENBIT SEARCHBIT TRANSBIT
	       WEARBIT VOWELBIT ONBIT RLANDBIT
	       ACTORBIT TAKEBIT NDESCBIT NARTICLEBIT
	       TOOLBIT LOCKEDBIT WISHBIT
	       INDOORSBIT FLAMEBIT WORNBIT THROWNBIT
	       WETBIT VEHBIT)>

<OBJECT LOCAL-GLOBALS
	(IN GLOBAL-OBJECTS)
	(SYNONYM ZZZP)
	(DESCFCN 0)
        (GLOBAL GLOBAL-OBJECTS)
	(ADVFCN 0)
	(FDESC "F")
	(LDESC "L")
	(PSEUDO "FOOBAR" V-WALK)
	(CONTFCN 0)
	(SIZE 0)
	;(TEXT "")
	(CAPACITY 0)>

<OBJECT ROOMS
	(IN TO ROOMS)>

<OBJECT INTNUM
	(IN GLOBAL-OBJECTS)
	(SYNONYM INTNUM)
	(DESC "number")>

<OBJECT PSEUDO-OBJECT
	(DESC "pseudo")
	(ACTION ME-F)>

<OBJECT IT
	(IN GLOBAL-OBJECTS)
	(SYNONYM IT THAT)
	(DESC "it")
	(FLAGS VOWELBIT NARTICLEBIT NDESCBIT TOUCHBIT)>

<ROUTINE BE-SPECIFIC ()
	 <TELL "(Be specific: what do you want to ">>

<ROUTINE TO-DO-THING-USE (STR1 STR2)
	 <TELL "(To " .STR1 " something, use the command: " 
	       .STR2 " THING.)" CR>>

<ROUTINE CANT-USE (PTR "AUX" BUF) 
	<SETG QUOTE-FLAG <>>
	<SETG P-OFLAG <>>
	<TELL "(This story can't understand the word \"">
	<WORD-PRINT <GETB <REST ,P-LEXV <SET BUF <* .PTR 2>>> 2>
	<GETB <REST ,P-LEXV .BUF> 3>>
	<TELL "\" when you use it that way.)" CR>>

<ROUTINE DONT-UNDERSTAND ()
	<TELL "(That sentence didn't make sense. Please reword it or try something else.)" CR>>

<ROUTINE NOT-IN-SENTENCE (STR)
	 <TELL "(There aren't " .STR " in that sentence!)" CR>>

<OBJECT DUST
	(IN GLOBAL-OBJECTS)
	(DESC "dust")
	(SYNONYM DUST DIRT GRIME FILTH)>

<OBJECT GROUND
	(IN GLOBAL-OBJECTS)
	(DESC "ground")
	(SYNONYM FLOOR GROUND LAWN GRASS)
	(FLAGS NDESCBIT SURFACEBIT)
	(CAPACITY 30000)
	(ACTION GROUND-F)>

<ROUTINE GROUND-F ()
	 <COND (<VERB? EXAMINE LOOK-ON SEARCH>
		<COND (<AND <EQUAL? ,HERE ,INSIDE-THEATER>
			    <FSET? ,GLASSES ,RMUNGBIT>>
		       <PERFORM ,V?LOOK-UNDER ,SEAT>)
		      (T
		       <TELL ,YOU-SEE "nothing " <PICK-ONE ,YAWNS>
		             " about the ">
		       <GROUND-OR-FLOOR>
		       <TELL "." CR>)>
		<RTRUE>)		 
	       (<VERB? SIT LIE-DOWN>
		<V-LIE-DOWN>)
	       (<VERB? CROSS WALK-TO THROUGH ENTER>
		<V-WALK-AROUND>)
	       (<VERB? LOOK-UNDER PUT-UNDER>
		<HOW?>)
	       (<AND <VERB? PUT PUT-ON>
		     <EQUAL? ,PRSI ,GROUND ,AISLE>>
		<PERFORM ,V?DROP ,PRSO>)
	       (<AND <VERB? TAKE>
		     <EQUAL? ,PRSI ,GROUND ,AISLE>>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (<EQUAL? ,AISLE ,PRSO ,PRSI>
		<RFALSE>)
	       (T
		<YOU-DONT-NEED ,GROUND>
		<RFATAL>)>
	 <RTRUE>>

<ROUTINE GROUND-OR-FLOOR ()
	 <COND (<FSET? ,HERE ,INDOORSBIT>
		<TELL "floor">)
	       (T
		<PRINTD ,GROUND>)>>

<OBJECT ROAD 
	(IN GLOBAL-OBJECTS)
	(DESC "road")
	(SYNONYM ROAD STREET PATH)
	(ACTION HERE-F)>

<ROUTINE HERE-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE LOOK-DOWN>
		<V-LOOK>)
	       (<VERB? FIND>
		<TELL "It's right here!" CR>)
	       (<VERB? FOLLOW WALK-TO WALK LEAVE CROSS CLIMB-ON CLIMB-UP
		       CLIMB-DOWN ENTER THROUGH>
		<V-WALK-AROUND>
		<RFATAL>)
	       (<VERB? SIT LIE-DOWN DIG>
		<WASTE-OF-TIME>)
	       (<AND <VERB? PUT PUT-ON THROW>
		     <EQUAL? ,PRSI ,PSEUDO-OBJECT>>
		<PERFORM ,V?DROP ,PRSO>)
	       (<OR <TALKING-TO? ,ROAD>
		    <VERB? YELL>>
		<NOTHING-EXCITING>
		<RFATAL>)
	       (T
		<YOU-DONT-NEED "area" T>)>
	 <RTRUE>>

<OBJECT WALLS
	(IN GLOBAL-OBJECTS)
	(FLAGS NDESCBIT TOUCHBIT)
	(DESC "wall")
	(SYNONYM WALL WALLS)
	(ACTION WALLS-F)>
	 
<ROUTINE WALLS-F ()
	 <COND (<AND <NOT <FSET? ,HERE ,INDOORSBIT>>
		     <NOT <EQUAL? ,HERE ,INSIDE-GRAVE>>>
		<CANT-SEE-ANY ,WALLS>
		<RFATAL>)
	       (<OR <GETTING-INTO?>
		    <VERB? LOOK-BEHIND>>
		<TELL <PICK-ONE ,YUKS> CR>)
	       (<VERB? LOOK-UNDER>
		<TELL "There's a floor there." CR>)
	       (<OR <HURT? ,WALLS>
		    <MOVING? ,WALLS>>
		<SAY-THE ,WALLS>
		<TELL " is not affected." CR>)
	       (<OR <TALKING-TO? ,WALLS>
		    <VERB? YELL>>
		<TELL "Talking to walls">
		<SIGN-OF-COLLAPSE>
		<RFATAL>)
	       (T
		<YOU-DONT-NEED ,WALLS>
		<RFATAL>)>
	 <RTRUE>>
		
<OBJECT CEILING
	(IN GLOBAL-OBJECTS)
	(FLAGS NDESCBIT TOUCHBIT)
	(DESC "ceiling")
	(SYNONYM CEILING)
	(ACTION CEILING-F)>

<ROUTINE CEILING-F ()
	 <COND (<NOT <FSET? ,HERE ,INDOORSBIT>>
		<CANT-SEE-ANY ,CEILING>
		<RFATAL>)
	       (<VERB? LOOK-UNDER>
		<V-LOOK>
		<RTRUE>)
	       (<VERB? EXAMINE LOOK-ON>
		<COND (<EQUAL? ,HERE ,UNDER-CELL>
		       <PERFORM ,V?EXAMINE ,HIDDEN-HATCH>)
		      (<EQUAL? ,HERE ,ON-BRIDGE>
		       <TELL "The bridge is covered by a roof." CR>)
		      (T
		       <RFALSE>)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT HANDS
	(IN GLOBAL-OBJECTS)
	(DESC "your hand")
	(SYNONYM HAND HANDS)
	(ADJECTIVE MY BARE)
	(FLAGS NDESCBIT TOOLBIT TOUCHBIT NARTICLEBIT)>

<OBJECT PROTAGONIST
	(IN HILLTOP)
	(SYNONYM PROTAG)
	(DESC "yourself")
	(FLAGS NDESCBIT NARTICLEBIT INVISIBLE)
	(ACTION 0)
	(SIZE 0)>

; <OBJECT POCKET
	(IN PROTAGONIST)
	(DESC "your pocket")
	(SYNONYM POCKET)
	(ADJECTIVE MY)
	(FLAGS WORNBIT NDESCBIT OPENBIT NARTICLEBIT CONTBIT)
	(CAPACITY 10)
	(ACTION POCKET-F)>

; <ROUTINE POCKET-F ("AUX" OBJ NXT)
	 <COND (<VERB? LOOK-INSIDE SEARCH LOOK-DOWN EXAMINE>
		<COND (<FIRST? ,POCKET>
		       <TELL "There's ">
		       <PRINT-CONTENTS ,POCKET>
		       <TELL " in " D ,POCKET>)
		      (T
		       <TELL "Y">
		       <POCKET-EMPTY>)>
		<TELL "." CR>
		<RTRUE>)
	       (<AND <VERB? PUT THROW>
		     <EQUAL? ,PRSI ,POCKET>>
		<COND (<AND <EQUAL? ,PRSO ,CANDLE>
			    <FSET? ,CANDLE ,ONBIT>>
		       <TELL "Putting a lighted " D ,CANDLE
			     " in " D ,POCKET " isn't a good idea." CR>
		       <RTRUE>)
		      (<EQUAL? ,PRSO ,HANDS>
		       <TELL "No wonder " D ,CRISP " says you're lazy!" CR>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<VERB? OPEN CLOSE>
		<TELL "You don't need to do that." CR>
		<RTRUE>)
	       (<VERB? TAKE-OFF>
		<TELL <PICK-ONE ,YUKS> CR>
		<RTRUE>)
	       (<HURT? ,POCKET>
		<WASTE-OF-TIME>
		<RTRUE>)
	       (T
		<RFALSE>)>>
		
<OBJECT ME
	(IN GLOBAL-OBJECTS)
	(SYNONYM I ME MYSELF)
	(DESC "yourself")
	(FLAGS ACTORBIT TOUCHBIT NARTICLEBIT)
	(ACTION ME-F)>

<ROUTINE ME-F ("OPTIONAL" (CONTEXT <>) "AUX" OLIT) 
	 <COND (<VERB? ALARM>
		<TELL "You're already wide awake." CR>
		<RTRUE>)
	       (<OR <TALKING-TO? ,ME>
		    <VERB? YELL>>
		<TALK-TO-SELF>
		<RFATAL>)
	       (<VERB? LISTEN>
		<TELL ,CANT " help doing that." CR>
		<RTRUE>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,ME>>
		<COND (<HELD? ,PRSO>
		       <TELL "You already have it." CR>)
		      (T
		       <PERFORM ,V?TAKE ,PRSO>)>
		<RTRUE>)
	       (<VERB? KILL>
		<TELL "Desperate? Call the Samaritans." CR>
		<RTRUE>)
	       (<VERB? FIND>
		<TELL "You're right here!" CR>
		<RTRUE>)
	       (<HURT? ,ME>
		<TELL "Punishing yourself that way won't help matters." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE TALK-TO-SELF ()
	 <TELL "Talking to yourself">
	 <SIGN-OF-COLLAPSE>
	 <PCLEAR>>

<ROUTINE SIGN-OF-COLLAPSE ()
	 <TELL " is said to be a sign of impending mental collapse." CR>>

<OBJECT GLOBAL-ROOM
	(IN GLOBAL-OBJECTS)
	(DESC "room")
	(SYNONYM ROOM AREA PLACE)
	(ACTION GLOBAL-ROOM-F)>

<ROUTINE GLOBAL-ROOM-F ()
	 <COND (<VERB? LOOK EXAMINE LOOK-INSIDE>
		<V-LOOK>
		<RTRUE>)
	       (<VERB? ENTER THROUGH DROP EXIT>
		<V-WALK-AROUND>
		<RFATAL>)
	       (<VERB? WALK-AROUND>
		<TELL
"Walking around the area reveals nothing new.|
|
(If you want to go somewhere, just type a direction.)" CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>
	       
<ROUTINE ALREADY-IN (PLACE "OPTIONAL" (NOT? <>))
	 <TELL "But you're ">
	 <COND (.NOT?
		<TELL "not">)
	       (T
		<TELL "already">)>
	 <TELL " in ">
	 <ARTICLE .PLACE T>
	 <TELL D .PLACE "!" CR>>

<ROUTINE UPDATE-SCORE (POINTS)
	 <SETG GSCORE <+ ,GSCORE .POINTS>>
	 <TELL "(Your score just went ">
	 <COND (<G? .POINTS -1>
		<TELL "up">)
	       (T
		<TELL "DOWN">)>
	 <TELL " by " N <ABS .POINTS> " point">
	 <COND (<NOT <EQUAL? .POINTS 1 -1>>
		<TELL "s">)>
	 <TELL "! Your total score is " N ,GSCORE " out of 100.)" CR>>
	      
<ROUTINE GO-INSIDE ()
	 <TELL "Why not go inside and look around?" CR>>

<ROUTINE CANT-MAKE-OUT-ANYTHING ()
	 <TELL ,CANT " make out anything inside." CR>>

<ROUTINE OBJECT-IS-LOCKED ()
	 <TELL ,CANT " do that. It's locked." CR>>

<ROUTINE CANT-SEE-ANY ("OPTIONAL" (THING <>) (STRING? <>))
	 <YOU-CANT-SEE>
	 <COND (.STRING?
		<TELL .THING>)
	       (.THING
		<COND (<NOT <FSET? .THING ,NARTICLEBIT>>
		       <TELL "any ">)>
		<TELL D .THING>)
	       (T
		<TELL "that">)>
	 <TELL " here!" CR>>

<ROUTINE YOU-CANT-SEE ()
	 <SETG CLOCK-WAIT T>
	 <PCLEAR>
	 <TELL ,CANT " see ">>

<ROUTINE HOW-WOULD-YOU-LIKE-IT (OBJ)
	 <TELL
"How would you like it if somebody did that to YOUR " D .OBJ "?" CR>>

<OBJECT SIGN
	(IN LOCAL-GLOBALS)
	(DESC "sign")
	(SYNONYM SIGN SIGNPOST POST MESSAGE)
	(ADJECTIVE PAINT PAINTED HANDPAINTED NEON)
	(FLAGS NDESCBIT READBIT TRYTAKEBIT)
	(ACTION SIGN-F)>

<ROUTINE SIGN-F ()
	 <COND (<VERB? READ EXAMINE>
		
		<COND (<EQUAL? ,HERE ,HILLTOP>
	               <TELL
"There are two arrows on the signpost. The arrow pointing west says \"To Cemetery.\" The east arrow is marked \"To">
		       <WHICH-TOWN>
		       <TELL ".\"" CR>)
	              
		      (<EQUAL? ,HERE ,ROTARY-WEST>
		       <SAY-THE ,SIGN>
		       <TELL " over the " D ,ENTRANCE " says, \"">
		       <COND (,SKEWED?
			      <TELL "Witchville">)
			     (T
			      <TELL "Festeron">)>
		       <TELL " Police Headquarters.\"" CR>) 
		      
	       	      (<EQUAL? ,HERE ,NORTH-OF-BRIDGE>
		       <COND (,SKEWED?
			      <TELL  
"The childlike scrawl is hard to decipher. With a little imagination, you can make out the phrase \"Toll Bridge, One Gold Coin.\"" CR>)
			     (T
			      <CANT-SEE-ANY ,SIGN>)>)
		      
		      (<EQUAL? ,HERE ,CLIFF-EDGE>
		       <DESCRIBE-SIGN>)
		      
		      (<EQUAL? ,HERE ,PLEASURE-WHARF>
		       <TELL "The neon sign says, \"VIDEO GAMES.\"" CR>)
		      
		      (<EQUAL? ,HERE ,EDGE-OF-LAKE>
		       <PERFORM ,V?READ ,SAND>)
		      
		      (<EQUAL? ,HERE ,GRUE-NEST>
		       <PERFORM ,V?EXAMINE ,REFRIGERATOR>)

		      (<EQUAL? ,HERE ,VIDEO-ARCADE>
		       <ARCADE-SIGN>)
		      
		      (<EQUAL? ,HERE ,CIRCULATION-DESK>
		       <SAY-THE ,SIGN>
		       <TELL 
" over the hall says, \"To " D ,MUSEUM ".\"" CR>)
		      
		      (<EQUAL? ,HERE ,MUSEUM>
		       <SAY-DCASE-SIGN>)
		      
		      (T
		       <RFALSE>)>
		<RTRUE>)
	       
	       (<OR <HURT? ,SIGN>
		    <VERB? TAKE RUB PUT PUSH MOVE>>
		<WASTE-OF-TIME>
		<RTRUE>)
	       
	       (T
		<YOU-DONT-NEED ,SIGN>
		<RFATAL>)>>

<ROUTINE CANT-FIT-INTO? (PLACE)
	 <COND (<IN? ,BRANCH ,PROTAGONIST>
		<NEVER-GET-IN .PLACE "that branch">
		<RTRUE>)
	       (<AND <IN? ,UMBRELLA ,PROTAGONIST>
		     <FSET? ,UMBRELLA ,OPENBIT>>
		<NEVER-GET-IN .PLACE "that open umbrella">
		<RTRUE>)
	       (<G? <WEIGHT ,PROTAGONIST> 18>
		<NEVER-GET-IN .PLACE "all that stuff">
		<RTRUE>)
	       (T
	        <RFALSE>)>>

<ROUTINE NEVER-GET-IN (PLACE THING)
	 <TELL
"You'll never get into the " .PLACE " holding " .THING "!" CR>>

<ROUTINE GET-INTO (PLACE)
	 <TELL "With great effort, you manage to squeeze yourself into the "
.PLACE "." CR CR>>

<ROUTINE NOT-LIQUID ()
	 <ITS-NOT-A "liquid">>

<ROUTINE NOT-SOLID ()
	 <ITS-NOT-A "solid">>

<ROUTINE ITS-NOT-A (STR)
	 <TELL "It's not a " .STR "." CR>>

<ROUTINE COME-TO-SENSES ()
	 <CARRIAGE-RETURNS>
	 <SETG BROOM-SIT? <>>
	 <TELL 
"You come to your senses empty-handed and aching all over." CR CR>
	 <V-LOOK>
	 <I-LUCK>
	 <I-GLOW>>

<ROUTINE PROBABLY-DROWN-IN-RIVER ()
	 <PROBABLY-DROWN T>
	 <RFALSE>>

<ROUTINE PROBABLY-DROWN ("OPTIONAL" (RIVER? <>))
	 <TELL "You'd probably drown in the ">
	 <COND (.RIVER?
		<PRINTD ,RIVER>)
	       (<EQUAL? ,HERE ,WHARF ,TIDAL-POOL ,FESTERON-POINT>
		<PRINTD ,BAY>)
	       (<EQUAL? ,HERE ,EDGE-OF-LAKE ,RIVER-OUTLET ,ISLAND>
		<PRINTD ,LAKE>)
	       (<EQUAL? ,HERE ,PARK>
		<PRINTD ,FOUNTAIN>)
	       (<AND <EQUAL? ,HERE ,HILLTOP>
		     ,SKEWED?>
		<PRINTD ,MOAT>)
	       (T
		<PRINTD ,RIVER>)>
	 <WENT-THAT-WAY>
	 <RFALSE>>

<ROUTINE WENT-THAT-WAY ()
	 <TELL " if you went that way." CR>>

<ROUTINE WATER-DIRTY ()
	 <TELL "Better not. The water might be dirty." CR>>

<ROUTINE HANDLE-WATER? ()
	 <COND (<GETTING-INTO?>
	        <PROBABLY-DROWN>)
	       (<VERB? DRINK TASTE>
		<WATER-DIRTY>)
	       (<VERB? EAT BITE>
		<NOT-SOLID>)
	       (<AND <VERB? PUT PUT-ON PUT-UNDER THROW>
		     <OR <EQUAL? ,PRSI ,BAY ,RIVER ,LAKE>
			 <EQUAL? ,PRSI ,MOAT>>>
	        <REMOVE ,PRSO>
		<TELL "Splash!" CR CR>
		<COND (<EQUAL? ,PRSO ,HORSE ,DHORSE>
		       <COND (<ENABLED? ,I-HORSE-DEATH>
			      <DISABLE <INT I-HORSE-DEATH>>)>
		       <SAY-THE ,PRSO>
		       <TELL 
" floats without moving for a few anxious moments. Then it ">
		       <COND (<EQUAL? ,PRSO ,DHORSE>
		              <TELL
"sinks slowly into the dark water">)
		             (T 
		              <SETG HORSE-SAVED? T>
		              <TELL "springs suddenly to life, circling and splashing joyfully in the waves. Before it swims away it looks up at you with an unmistakable expression of gratitude">)>
		       <TELL "." CR>)
		      
		      (<AND <EQUAL? ,PRSO ,CANDLE>
			    <FSET? ,CANDLE ,ONBIT>>
		       <TELL "Weird! ">
		       <SAY-THE ,CANDLE>
		       <TELL " remains lit even as it">
		       <SINKS-INTO-WATER>)
		      
		      (T
		       <TELL "Silently, ">
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO>
		       <SINKS-INTO-WATER>)>)
	       (<AND <VERB? PUSH-TO>
		     <OR <EQUAL? ,PRSI ,BAY ,RIVER ,LAKE>
			 <EQUAL? ,PRSI ,MOAT>>>
		<COND (<HELD? ,PRSO>
		       <PRESUMABLY-YOU-WANT-TO "PUT it in" ,PRSI>
		       <PERFORM ,V?PUT ,PRSO ,PRSI>
		       <RTRUE>)
		      (<AND <IN? ,PRSO ,HERE>
			    <FSET? ,PRSO ,TAKEBIT>>
		       <MOVE ,PRSO ,PROTAGONIST>
		       <TELL "(with your foot)" CR>
		       <PERFORM ,V?PUT ,PRSO ,PRSI>
		       <RTRUE>)
		      (T
		       <V-PUSH-TO>)>)
	       (<SEE-VERB?>
		<TELL "The water is too deep to see much of anything." CR>)
	       (T
		<YOU-DONT-NEED "water" T>
		<RFATAL>)>
	 <RTRUE>>

<ROUTINE SINKS-INTO-WATER ()
	 <TELL " disappears beneath the surface of ">
	 <ARTICLE ,PRSI T>
	 <TELL D ,PRSI "." CR>>
			    
<ROUTINE YOU-ARE-HOLDING (THING "OPTIONAL" (AGAIN <>))
	 <THIS-IS-IT .THING>
	 <TELL CR CR "(You are ">
	 <COND (.AGAIN
		<TELL "again">)
	       (T
		<TELL "now">)>
	 <TELL " holding ">
	 <ARTICLE .THING .AGAIN>
	 <TELL D .THING ".)">>

<ROUTINE NOTHING-EXCITING ()
	 <TELL "Nothing exciting happens." CR>>

<ROUTINE THAT-WAS-CLOSE ()
	 <TELL "Whew! That was close." CR>>

<ROUTINE GOOD-PLACE-TO-SAVE ()
	 <TELL CR 
"(This might be a good time to SAVE your story position.)" CR>>

<ROUTINE HOW? ()
	 <TELL "How do you intend to do that?" CR>>

<OBJECT CORNER
	(IN LOCAL-GLOBALS)
	(DESC "corner")
	(SYNONYM CORNER)
	(FLAGS NDESCBIT)
	(ACTION CORNER-F)>

<ROUTINE CORNER-F ()
	 <COND (<VERB? EXAMINE LOOK-ON LOOK-INSIDE>
	        <V-LOOK>
	        <RTRUE>)
	       (<GETTING-INTO?>
	        <TELL 
"You're close enough to the " D ,CORNER " already." CR>
	        <RTRUE>)
	       (T
	        <YOU-DONT-NEED ,CORNER>
		<RFATAL>)>>

<ROUTINE TOO-FAR-AWAY (OBJ)
	 <UNFORTUNATELY>
	 <ARTICLE .OBJ T>
	 <TELL D .OBJ " is too far away for you to do that." CR>>

<ROUTINE UNFORTUNATELY ()
	 <TELL "Unfortunately, ">>

<ROUTINE EXCELLENT-VIEW (OBJ)
	 <SAY-THE .OBJ>
	 <TELL " affords an excellent view of the surrounding area." CR>>

<ROUTINE ALREADY-AT (OBJ "OPTIONAL" (TOP? <>))
	 <TELL "You're already at the ">
	 <COND (.TOP?
		<TELL "top">)
	       (T
		<TELL "bottom">)>
	 <TELL " of the " D .OBJ "!" CR>>

<ROUTINE LOITERING-ON (OBJ)
	 <TELL "There's no reason to loiter around the " D .OBJ "." CR>>

<ROUTINE PRESUMABLY-YOU-WANT-TO (STR "OPTIONAL" (THING <>))
	 <TELL ,I-ASSUME " " .STR " ">
	 <COND (.THING
		<ARTICLE .THING T>
	        <TELL D .THING>)
	       (T
		<TELL "it">)>
	 <TELL ".)" CR>>

<ROUTINE MAKE-IT-SNAPPY ()
	 <TELL
" If you want to make a wish, you'd better make it snappy!)">>

<ROUTINE HOLD-YOUR-PEACE ()
	 <TELL
" Wish now, or forever hold your peace!)">>

<ROUTINE IT-IGNORES-YOU (WHO)
	 <SAY-THE .WHO>
	 <TELL " " <PICK-ONE ,IGNORANCE> "." CR>>

<GLOBAL IGNORANCE
	<LTABLE 0
	 "studiously ignores you"
	 "pretends not to understand you"
	 "pays no attention to you"
	 "makes a rude little noise">>
	 
<OBJECT SOUND
	(IN GLOBAL-OBJECTS)
	(DESC "sound")
	(SYNONYM SOUND VOICE VOICES MUSIC)
	(ADJECTIVE NOISE NOISES)
	(FLAGS NDESCBIT NARTICLEBIT)
	(ACTION SOUND-F)>

<ROUTINE SOUND-F ()
	 <COND (<VERB? LISTEN>
		<COND (<EQUAL? ,HERE ,INSIDE-THEATER>
		       <COND (<OR <EQUAL? ,MOVIE-SCRIPT 6>
				  ,ECLIPSE?>
			      <BLANK-SCREEN>)
			     (T
			      <TELL 
"The soundtrack is an artless mix of Witchville slogans and John Philip Sousa marches, played at earsplitting volume." CR>)>
		       <RTRUE>)
		      
		      (<AND <EQUAL? ,HERE ,LOBBY>
		            <L? ,MOVIE-SCRIPT 6>
			    <NOT ,ECLIPSE?>>
		       <TELL ,YOU-HEAR  
"a blare of noise coming from inside the " D ,MOVIE-THEATER>)
		      
		      (<AND <EQUAL? ,HERE ,HILLTOP>
			    <NOT <FSET? ,ENVELOPE ,RMUNGBIT>>> ; "Not given?"
		       <TELL
"Uh-oh! The calling voice belongs to">
		       <BOSS>
		       <TELL "!" CR>
		       <RTRUE>)

		      (<AND <EQUAL? ,HERE ,MUSEUM>
			    <ENABLED? ,I-PLEA>>
		       <TELL "The voice sounds just like the " 
D ,OLD-WOMAN " you met at the " D ,MAGICK-SHOPPE>)
		      
		      (<AND <EQUAL? ,HERE ,INSIDE-SHOPPE>
			    <FSET? ,CLOCK ,RMUNGBIT>>
		       <PERFORM ,V?LISTEN ,CLOCK>
		       <RTRUE>)
		      
		      (<EQUAL? ,HERE ,JAIL-CELL>
		       <COND (<L? ,JAIL-SCRIPT 9>
			      <TELL "The ">
			      <EVIL-VOICES>
			      <TELL " don't sound very friendly." CR>)
			     (T
			      <HEAR-WAILS>)>
		       <RTRUE>)
		      
		      (T
		       <TELL 
"At the moment, you hear nothing " <PICK-ONE ,YAWNS>>)>
		<TELL "." CR>
		<RTRUE>)
	       (<VERB? FOLLOW WALK-TO>
		<V-WALK-AROUND>)
	       (<VERB? WAIT-FOR>
		<V-WAIT>)
	       (<AND <VERB? REPLY>
		     <EQUAL? ,HERE ,HILLTOP>
		     <NOT <FSET? ,ENVELOPE ,RMUNGBIT>>> ; "Not given?"
	        <TELL "You'll have to go inside to do that." CR>)
	       (<OR <TALKING-TO? ,SOUND>
		    <VERB? YELL>>
		<TELL "Try addressing the source of the sound." CR>
		<RFATAL>)
	       (T
		<TELL ,CANT>
		<DO-TO>
		<TELL "a " D ,SOUND "!" CR>)>
	 <RTRUE>>

<ROUTINE TOO-LARGE (THING "OPTIONAL" (SMALL? <>))
	 <BUT-THE .THING>
	 <TELL "is much too ">
	 <COND (.SMALL?
		<TELL "small">)
	       (T
		<TELL "large">)>
	 <TELL "!" CR>>
			      
<ROUTINE FROBOZZ (STR)
	 <TELL "Frobozz Magic " .STR " Company">>

<ROUTINE NOT-LIKELY (THING STR)
	 <TELL "It" <PICK-ONE ,LIKELIES> " that ">
	 <ARTICLE .THING T>
	 <TELL D .THING " " .STR "." CR>>

<GLOBAL LIKELIES 
	<LTABLE 0
	 " isn't likely"
	 " seems doubtful"
	 " seems unlikely"
	 "'s unlikely"
	 "'s not likely"
	 "'s doubtful">>

<ROUTINE YOUD-HAVE-TO (STR THING)
	 <TELL "You'd have to " .STR " ">
	 <ARTICLE .THING T>
	 <TELL D .THING " to do that." CR>>

<ROUTINE CLOSED-AND-LOCKED ()
	 <TELL " closed and locked." CR>>

; <ROUTINE OPENED ()
	 <TELL "Opened.">>

<ROUTINE STANDING ()
	 <TELL "You're standing ">>

<ROUTINE DO-TO ()
	 <TELL " do that to ">>

<ROUTINE INTRO ()
	 <TELL "\"Behind you!\" cries the Princess. \"It's a trap!\"|
|
Too late. The " D ,DRAWBRIDGE " crashes shut against the " D ,TOWER " wall. You turn to face your enemy, and find yourself staring into the open maw of">>

<ROUTINE FIRED ("OPTIONAL" (TIMEOUT? <>))
	 <TELL CR "\"There you are, " <PICK-ONE ,INSULTS> "!\"|
|
You wince as " D ,CRISP " strides into view and grabs you by the front of your uniform.|
|
\"You good-for-nothing " <PICK-ONE ,INSULTS> "!\" he bellows in your face. \"I wanted you to ">
	 <COND (.TIMEOUT?
		<TELL "deliver that envelope BEFORE five o'clock! Now the " 
D ,MAGICK-SHOPPE " is closed... and y">)
	       (T
		<TELL "get back to the " D ,POST-OFFICE
		      " as soon as you were done with that envelope! Y">)>
	 <TELL "ou're FIRED!\"">
         <BAD-ENDING>>

<ROUTINE SAY-HURRY ()
	 <TELL CR "(It's ">
	 <TELL-TIME>
	 <TELL ". Better hurry! ">>

<ROUTINE BETTER-HURRY ("OPTIONAL" (HALF? <>))
	 <SAY-HURRY>
	 <SAY-THE ,MAGICK-SHOPPE>
	 <TELL " closes in less than ">
	 <COND (.HALF?
		<TELL "half ">)>
	 <TELL "an hour!)" CR>>

; <ROUTINE PLACE-HOLDER (STR)
	 <TELL CR "[TESTER: " .STR ". Film at eleven. -BM]" CR>>

; <ROUTINE VPRINT ("AUX" TMP)
	 <SET TMP <GET ,P-OTBL ,P-VERBN>>
	 <COND (<EQUAL? .TMP 0> <TELL "tell">)
	       (<ZERO? <GETB ,P-VTBL 2>>
		<PRINTB <GET .TMP 0>>)
	       (T
		<WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>)>>

; <ROUTINE NOT-HERE (OBJ)
	 <SETG CLOCK-WAIT T>
	 <TELL ,CANT " see ">
	 <COND (<NOT <FSET? .OBJ ,NARTICLEBIT>> <TELL "any ">)>
	 <TELL D .OBJ " here." CR>>

<OBJECT HER
	(IN GLOBAL-OBJECTS)
	(SYNONYM SHE HER ; WOMAN ; GIRL ; LADY)
	(DESC "her")
	(FLAGS NARTICLEBIT)>

<OBJECT HIM
	(IN GLOBAL-OBJECTS)
	(SYNONYM HE HIM ; MAN ;BOY)
	(DESC "him")
	(FLAGS NARTICLEBIT)>

<OBJECT THEM
	(IN GLOBAL-OBJECTS)
	(SYNONYM THEY THEM)
	(DESC "them")
	(FLAGS NARTICLEBIT)>

<GLOBAL GAME "Wishbringer">
<GLOBAL I-ASSUME "(Presumably, you mean">
<GLOBAL CANT "You can't">

<SYNONYM EAST RIGHT>
<SYNONYM WEST LEFT>

<OBJECT INTDIR
	(IN GLOBAL-OBJECTS)
	(DESC "direction")
	(SYNONYM DIRECTION)
	(ADJECTIVE NORTH EAST SOUTH WEST ; "UP DOWN" ; "NE NW SE SW")
    ;  "(NE 0)
	(SE 0)
	(SW 0)
	(NW 0)" >





