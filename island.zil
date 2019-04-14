"ISLAND for WISHBRINGER: (C)1985 Infocom, Inc. All rights reserved."

<OBJECT WHISTLE
	(DESC "silver whistle")
	(SYNONYM WHISTLE)
	(ADJECTIVE SILVER)
	(FLAGS TAKEBIT)
	(ACTION WHISTLE-F)
	(VALUE 3)
	(SIZE 1)>

<GLOBAL BEEN-TO-ISLAND? <>>
<GLOBAL RETURN-FROM-ISLAND? <>>

<ROUTINE WHISTLE-F ()
	 <COND (<VERB? EXAMINE>
		<SAY-THE ,WHISTLE>
		<TELL " is shaped like a " D ,PLATYPUS>
		<COND (<OR <EQUAL? ,HERE ,EDGE-OF-LAKE>
			   <AND <EQUAL? ,HERE ,ISLAND ,THRONE-ROOM>
				,RETURN-FROM-ISLAND?>>
		       <TELL ", and twinkles with gentle Magick">)>
		<TELL "." CR>
		<RTRUE>)
	       (<VERB? BLOW-INTO>
		<COND (<DONT-HAVE? ,WHISTLE>
		       <RTRUE>)>
		<WHISTLE-SOUND>
		<COND (<AND <NOT ,BEEN-TO-ISLAND?>
			    <EQUAL? ,HERE ,EDGE-OF-LAKE>>
		       <SETG BEEN-TO-ISLAND? T>
		       <CRLF>
		       <SAY-THE ,WHISTLE>
		       <TELL
"'s music echoes over the lake, rippling the water with gentle Magick. ">
		       <SUDDEN-GUST>
		       <TELL "blows through your hair. " ,YOU-SEE 
"the soft outline of " D ,ISLAND " drawing closer as you streak across the waves...">
		       <CARRIAGE-RETURNS>
		       <MOVE ,PROTAGONIST ,ISLAND>
		       <SETG HERE ,ISLAND>
		       <V-LOOK>)
		      (<AND ,RETURN-FROM-ISLAND?
			    <EQUAL? ,HERE ,ISLAND ,THRONE-ROOM>>
		       <REMOVE ,WHISTLE>
		       <COND (<NOT <IN? ,BOOTS ,FESTERON-POINT>>
			      <SETG BOOT-LOC 0>
			      <MOVE ,BOOTS ,FESTERON-POINT>)>
		       <MOVE ,PROTAGONIST ,EDGE-OF-LAKE>
		       <SETG HERE ,EDGE-OF-LAKE>
		       <CRLF>
		       <SUDDEN-GUST>
		       <TELL "rises out of nowhere, and " D ,ISLAND>
		       <BENEATH-FEET>
		       <TELL ". You feel the " D ,WHISTLE " slip from "
			     D ,HANDS " as you streak across the lake...">
		       <CARRIAGE-RETURNS> 
		       <V-LOOK>)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE WHISTLE-SOUND ()
	 <TELL
"A clear, sweet note stills the night with its beauty." CR>>

<OBJECT ISLAND
	(IN ROOMS)
	(DESC "Misty Island")
	(FLAGS ONBIT WETBIT RLANDBIT NARTICLEBIT)
	(GLOBAL CASTLE CLIFF LAKE ISLE)
	(NORTH PER BUMP-CLIFF)
	(EAST PER PROBABLY-DROWN)
	(SOUTH PER BUMP-CLIFF)
	(WEST PER ENTER-THRONE-ROOM)
	(IN PER ENTER-THRONE-ROOM)
	(PSEUDO "BEACH" HERE-F)
	(ACTION ISLAND-F)>
	
<ROUTINE ISLAND-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<STANDING>
		<TELL 
"on a fog-shrouded beach. Sheer cliff walls rise " <TO-N> " and south, and the dark waters of the lake stretch eastward.|
|
To the west stands a magnificent " D ,CASTLE ", its parapets rising high into the mist. Golden light streams invitingly through the open " D ,ENTRANCE ". "
,YOU-HEAR "friendly voices and music inside." CR>)>>

<ROUTINE ENTER-THRONE-ROOM ()
	 <COND (<ZERO? ,KING-SCRIPT>
		<SETG ANGER 4>
		<ENABLE <QUEUE I-KING-BLAB -1>>)>
	 <RETURN ,THRONE-ROOM>>

"*** THRONE ROOM ***"

<OBJECT THRONE-ROOM
	(IN ROOMS)
	(DESC "Throne Room")
	(FLAGS ONBIT RLANDBIT INDOORSBIT NARTICLEBIT)
	(GLOBAL CASTLE ISLE)
	(NORTH PER PLATS-BLOCK)
	(EAST PER EXIT-THRONE-ROOM)
	(SOUTH PER PLATS-BLOCK)
	(WEST PER PLATS-BLOCK)
	(OUT PER EXIT-THRONE-ROOM)
	(ACTION THRONE-ROOM-F)>

<ROUTINE PLATS-BLOCK ()
	 <THIS-IS-IT ,CROWD>
	 <SAY-THE ,CROWD>
	 <TELL " blocks your path." CR>
	 <RFALSE>>

<ROUTINE EXIT-THRONE-ROOM ()
	 <COND (<AND <ENABLED? ,I-KING-BLAB>
		     <L? ,KING-SCRIPT 4>>
		<TELL "\"Wait!\" cries the white " D ,PLATYPUS ". \"">
		<COND (<EQUAL? <LOC ,HAT> ,KING ,THRONE-ROOM>
		       <TELL "You forgot the " D ,HAT>)
		      (T
		       <TELL "I wish to speak with you">)>
	       <TELL "!\"" CR CR>)>
	 <RETURN ,ISLAND>>

<ROUTINE THRONE-ROOM-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<THIS-IS-IT ,CROWD>
	        <THIS-IS-IT ,KING>
	        <THIS-IS-IT ,PRINCESS>
		<STANDING>
		<TELL  
"in a long, high-ceilinged chamber. Hundreds of " D ,PLATYPUS "es are ">
		<COND (<G? ,KING-SCRIPT 1>
		       <TELL "watching you respectfully">)
		      (T
		       <TELL "milling about with teacups in their paws">)>
		<TELL
", their faces illuminated by a roaring fireplace.|
|
At the far end of the chamber stands a mighty throne. It's occupied by a snow-white " D ,PLATYPUS " with a gold crown on its head and a jeweled scepter in its paw. On the floor near the throne is another crowned " D ,PLATYPUS 
"... the same one you rescued from the pit." CR>)>>

<GLOBAL ADVENTURER ", brave Adventurer">

<GLOBAL KING-SCRIPT 0>

<ROUTINE I-KING-BLAB ()
	 <COND (<OR ,FUZZY? ,ECLIPSE?>
		<RTRUE>)
	       (<EQUAL? ,HERE ,THRONE-ROOM>
		<CRLF>
		<COND (<IN? ,HAT ,KING>
		       <SETG ANGER <- ,ANGER 1>>
		       <COND (<ZERO? ,ANGER>
			      <KING-ANNOYED>)
			     (T
			      <TELL "\"" <PICK-ONE ,KING-OFFERS>
",\" says " D ,KING ", holding it out to you." CR>)>
		       <RTRUE>)>
		<SETG KING-SCRIPT <+ ,KING-SCRIPT 1>>
		<COND (<EQUAL? ,KING-SCRIPT 1>
		       <SAY-THE ,CROWD>
		       <TELL " falls silent as you enter.|
|
\"Welcome" ,ADVENTURER ",\" says the white " D ,PLATYPUS ", rising from its throne to greet you. \"I am Anatinus, King of " D ,ISLAND ". My court thanks you most humbly for rescuing the life of my daughter, " D ,PRINCESS ". Great would our sorrow have been if not for your cunning.\"|
|
The " D ,CROWD " applauds politely, and " D ,PRINCESS " blushes." CR>)
		      
		      (<EQUAL? ,KING-SCRIPT 2>
		       <THIS-IS-IT ,HAT>
		       <MOVE ,HAT ,KING>
		       <TELL
"\"My messengers have told me of your quest,\" continues " D ,KING ". \"Allow me to repay your kindness with words of advice.\"|
|
The old " D ,PLATYPUS " motions you to his side. \"The Tower of" ,EONE 
" is formidable,\" he begins in a low, serious voice. \"You will never get inside unaided. Legends speak of a Magick Word that can open the gates of the Tower. But what Word it is, none can say.\"|
|
The king reaches beneath his throne and takes out a small " D ,HAT ". \"Take this,\" he says, holding it out to you." CR>) 
		      
		      (<EQUAL? ,KING-SCRIPT 3>
		       <TELL 
"\"Take it to the sea,\" " D ,KING " whispers as you turn the hat in " 
D ,HANDS "s. \"There you will find a creature learned in the lore of Magick. Heed him well! In his wisdom lies your only hope.\"" CR>)
		      
		      (<EQUAL? ,KING-SCRIPT 4>
		       <SETG ANGER 4>
		       <SETG RETURN-FROM-ISLAND? T>
		       <THIS-IS-IT ,WHISTLE>
		       <TELL 
"A fanfare of trumpets breaks the silence, and the " D ,CROWD 
" falls to its knees." CR CR>
		       <REAPPEARS>
		       <TELL "\"Good luck to you" ,ADVENTURER "!\" cries "
D ,KING ", bowing deeply. \"Now blow into the " D ,WHISTLE " one more time, and deliver us from the horror of" ,EONE ".\"|
|
The " D ,PLATYPUS "es look at you expectantly." CR>)
		      (T
		       <REAPPEARS>
		       <SETG ANGER <- ,ANGER 1>>
		       <COND (<ZERO? ,ANGER>
			      <KING-ANNOYED T>)
			     (T
			      <TELL "\"" <PICK-ONE ,SCRAMS>
				    ",\" says " D ,KING "." CR>)>)>)>>

<GLOBAL KING-OFFERS 
	<LTABLE 0
	 "Take this Hat"
	 "This Hat is for you. Take it"
	 "I offer you this Hat">>

<GLOBAL SCRAMS
	<LTABLE 0
	 "Blow into the whistle, and your quest will continue"
	 "You need only blow into the whistle"
	 "The merest blow into the whistle will speed you on your quest">>

<ROUTINE REAPPEARS ("AUX" (THING <>))
	 <COND (<NOT <HELD? ,WHISTLE>>
		<SET THING ,WHISTLE>)
	       (<NOT <HELD? ,HAT>>
		<SET THING ,HAT>)>
	 <COND (.THING
		<MOVE .THING ,PROTAGONIST>
	        <SAY-THE .THING>
	        <TELL " magically reappears in " D ,HANDS "." CR CR>)>>

<ROUTINE KING-ANNOYED ("OPTIONAL" (BLOW? <>))
	 <SAY-THE ,KING>
	 <TELL " glares at you with annoyance.|
|
\"You dare to ignore a royal ">
	 <COND (.BLOW?
		<TELL "command">)
	       (T
		<TELL "gift">)>
	 <TELL "?\" he cries, deeply offended. \"I see. Perhaps a short visit to the granola mines will teach you some respect!\"|
|
The King turns you into a " D ,PLATYPUS " with an angry wave of his scepter, and the guards lead you away to twenty years of backbreaking labor.">
	 <BAD-ENDING>>

<OBJECT HAT
	(DESC "wizard's hat")
	(SYNONYM HAT)
	(ADJECTIVE WIZARD)
	(FLAGS TAKEBIT ; CONTBIT WEARBIT RMUNGBIT READBIT)
	(SIZE 5)
	(CAPACITY 5)
	(VALUE 1)
	(ACTION HAT-F)>

; "RMUNGBIT = player has not yet looked inside hat"

<ROUTINE HAT-F ("AUX" TEMP)
	 <COND (<VERB? EXAMINE LOOK-ON READ>
		<SAY-THE ,HAT>
		<TELL " is decorated with foil stars and cheap glitter." CR>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE LOOK-DOWN>
		<COND (<DONT-HAVE? ,HAT>
		       <RTRUE>)>
		<FCLEAR ,HAT ,RMUNGBIT>
		<TELL "Weird! It's like peering into an endless well." CR>
		<RTRUE>)
	       (<AND <VERB? TAKE>
		     <IN? ,HAT ,PELICAN>>
		<SAY-THE ,PELICAN>
		<TELL " would rather you didn't." CR>
		<RTRUE>)
	       (<VERB? WEAR>
		<TOO-LARGE ,HAT T>
		<RTRUE>)
	       (<AND <VERB? PUT THROW>
		     <EQUAL? ,PRSI ,HAT>>
		<COND (<DONT-HAVE? ,HAT>
		       <RTRUE>)
		      (<EQUAL? ,PRSO ,HAT>
		       <WHAT-A-CONCEPT>
		       <RTRUE>)
		      (<EQUAL? ,PRSO ,HANDS>
		       <TELL "You feel " D ,HANDS " tingling." CR>
		       <RTRUE>)>
		<SET TEMP <GETP ,PRSO ,P?SIZE>>
		<COND (<G? .TEMP 5>
		       <TOO-LARGE ,PRSO>)
		      (<FSET? ,HAT ,RMUNGBIT>
		       <TELL
"Maybe you should look inside the " D ,HAT " first." CR>)
		      (T
		       <SAY-SURE>
		       <TELL "put ">
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO " into the " D ,HAT "?">
		       <COND (<YES?>
			      <SET TEMP <+ .TEMP <GETP ,DCASE ,P?CAPACITY>>>
			      <PUTP ,DCASE ,P?CAPACITY .TEMP>
			      <MOVE ,PRSO ,DCASE>
		              <SAY-THE ,PRSO>
			      <TELL " disappears into the " D ,HAT>
			      <NO-TRACE>)
			      
			     (T
			      <TELL ,OKAY "you're still holding ">
			      <ARTICLE ,PRSO T>
			      <TELL D ,PRSO "." CR>)>)>
		<RTRUE>)
	       (<VERB? REACH-IN>
		<PERFORM ,V?PUT ,HANDS ,HAT>
		<RTRUE>)
	       (T
		<RFALSE>)>>
		         
<OBJECT PRINCESS
	(IN THRONE-ROOM)
	(DESC "Princess Tasmania")
	(SYNONYM TASMANIA PLATYPUS)
	(ADJECTIVE PRINCESS)
	(FLAGS NDESCBIT NARTICLEBIT ACTORBIT TRYTAKEBIT)
	(ACTION PRINCESS-F)>

<GLOBAL CLAMPED? <>>

<ROUTINE PRINCESS-F ("OPTIONAL" (CONTEXT <>))
	 <THIS-IS-IT ,PRINCESS>
	 <COND (<EQUAL? ,HERE ,VESTIBULE>
		<TAKE-MIND-OFF ,PRINCESS>
		<RTRUE>)
	       (<EQUAL? ,HERE ,TORTURE-CHAMBER>
		<COND (<VERB? TAKE PUSH MOVE>
		       <COND (,CLAMPED?
			      <STILL-CLAMPED>)
			     (T
			      <TELL D ,PRINCESS
" probably wouldn't enjoy being manhandled." CR>)>)
		      (<ASKING? ,PRINCESS>
		       <COND (,COAT-WORN?
			      <NO-TALKING>)
			     (T
			      <HAD-TIME "questions">)>
		       <RFATAL>)
		      (<VERB? TELL REPLY HELLO WAVE-AT ; GOODBYE>
		       <COND (,COAT-WORN?
			      <NO-TALKING>)
			     (T
			      <HAD-TIME "conversation">)>
		       <RFATAL>)
		      (<VERB? RESCUE UNLOCK RELEASE>
		       <HOW?>)
		      (<OR <HURT? ,PRINCESS>
			   <VERB? YELL KISS RUB SQUEEZE>>
		       <PRINTD ,PRINCESS>
		       <MIGHT-NOT-LIKE>)
		      (<AND <VERB? GIVE>
			    <EQUAL? ,PRSI ,PRINCESS>>
		       <COND (,COAT-WORN?
			      <NO-TALKING>)
			     (T
			      <TELL D ,PRINCESS
" gracefully declines your offer." CR>)>
		       <RTRUE>)
		      (<PRINCESS-SPECIFIC?>
		       <RTRUE>)
		      (T
		       <RFALSE>)>
		<RTRUE>)
	       (<CROWD-F>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE STILL-CLAMPED ()
	 <BUT-THE ,PRINCESS>
	 <TELL "is still clamped into the " D ,TMACHINE "!" CR>>

<ROUTINE HAD-TIME (STR)
	 <TELL
"\"Would that we had time for " .STR ",\" sighs " D ,PRINCESS "." CR>>

<ROUTINE NO-TALKING ()
	 <TELL "\"No communication between prisoners!\" barks "
	       D ,CRISP "." CR>>

<ROUTINE TAKE-MIND-OFF (OBJ)
	 <TELL "A rumbling noise calls your attention away from ">
	 <ARTICLE .OBJ T>
	 <TELL D .OBJ "." CR>>

<ROUTINE PRINCESS-SPECIFIC? ()
	 <COND (<VERB? EXAMINE>
	        <TELL "Not unexpectedly, ">
		<COND (<AND <EQUAL? ,PRSO ,PRINCESS>
			    ,CLAMPED?>
		       <TELL "the Princess clamped into the " D ,TMACHINE>)
		      (T
		       <ARTICLE ,PRSO T>
		       <PRINTD ,PRSO>)>
		<TELL " is arrayed in high " D ,PLATYPUS
		      " fashion." CR>
	        <RTRUE>)
	       (<VERB? LISTEN BOW>
	        <TELL "Graciously, ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO " acknowledges your respectful attention." CR>
	        <RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT KING
	(IN THRONE-ROOM)
	(DESC "King Anatinus")
	(SYNONYM ANATINUS PLATYPUS)
	(ADJECTIVE KING OLD WHITE)
	(FLAGS NDESCBIT NARTICLEBIT ACTORBIT)
	(ACTION CROWD-F)>

<OBJECT CROWD
	(IN THRONE-ROOM)
	(DESC "crowd")
	(SYNONYM CROWD ; PLATYPUS)
	(FLAGS NDESCBIT ACTORBIT)
	(ACTION CROWD-F)>

<ROUTINE CROWD-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<PRINCESS-SPECIFIC?>
		<RTRUE>)
	       (<TALKING-TO? ,PRSO>
	        <TELL D ,KING " interrupts you gently. \"There's little time for chit-chat.\"" CR>
	        <RFATAL>)
	       (<OR <HURT? ,PRSO>
		    <VERB? YELL KISS>>
	        <NOT-LIKELY ,KING "would approve">
	        <RTRUE>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,PRINCESS ,KING ,CROWD>>
	        <TELL "With reluctant dignity, ">
	        <ARTICLE ,PRSI T>
	        <TELL  D ,PRSI " refuses your offer." CR>
	        <RTRUE>)
	       (T
	        <RFALSE>)>>
		      
<OBJECT CASTLE
	(IN LOCAL-GLOBALS)
	(DESC "castle")
	(SYNONYM CASTLE PALACE BUILDING ENTRANCE)
	(FLAGS NDESCBIT)
	(ACTION CASTLE-F)>

<ROUTINE CASTLE-F ()
	 <COND (<ENTER-FROM? ,ISLAND ,THRONE-ROOM ,CASTLE>
		<RTRUE>)
	       (<VERB? EXAMINE LOOK-INSIDE>
		<COND (<EQUAL? ,HERE ,THRONE-ROOM>
		       <V-LOOK>)
		      (T
		       <GO-INSIDE>)>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,CASTLE>
		<RFATAL>)>>

<OBJECT CASTLE-JUNK
	(IN THRONE-ROOM)
	(DESC "that")
	(SYNONYM THRONE CHEST SCEPTER FIREPLACE)
	(FLAGS NDESCBIT NARTICLEBIT)
	(ACTION CASTLE-JUNK-F)>

<ROUTINE CASTLE-JUNK-F ()
	 <COND (<SEE-VERB?>
		<TELL ,YOU-SEE "nothing " <PICK-ONE ,YAWNS>
		      " about it." CR>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED "things in the castle" T>
	        <RFATAL>)>> 