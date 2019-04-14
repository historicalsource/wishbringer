"CEMETERY for WISHBRINGER: (C)1985 Infocom, Inc. All rights reserved."

<OBJECT CREEPY-CORNER
	(IN ROOMS)
	(DESC "Creepy Corner")
	(FLAGS ONBIT RLANDBIT)
	(GLOBAL MONUMENTS TREE VAPORS SOUTH-GATE CORNER CEMETERY)
	(NORTH PER ENTER-SPOOKY-COPSE)
	(EAST PER EXIT-TO-OUTSIDE)
	(SOUTH PER TOMBS-BLOCK)
	(WEST PER TOMBS-BLOCK)
	(OUT PER EXIT-TO-OUTSIDE)
	(PSEUDO "LANE" HERE-F)
	(ACTION CREEPY-CORNER-F)>

<ROUTINE TOMBS-BLOCK ()
	 <THIS-IS-IT ,MONUMENTS>
	 <SAY-THE ,MONUMENTS>
	 <TELL "s block your path." CR>
	 <RFALSE>>

<ROUTINE CREEPY-CORNER-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're in a creepy " D ,CORNER " of the">
		<WHICH-TOWN "Cemetery">
		<TELL ", surrounded by silent " D ,MONUMENTS "s. A">
		<COND (<FSET? ,SOUTH-GATE ,OPENBIT>
		       <TELL "n iron gate opens">)
		      (T
		       <TELL " closed iron gate stands">)>
		<TELL 
" " <TO-E> ", and a narrow lane wanders north." CR>)>>

<ROUTINE EXIT-TO-OUTSIDE ()
	 <COND (<FSET? ,SOUTH-GATE ,OPENBIT>
		<COND (,SKEWED?
		       <SLAM-THE-GATE>
		       <RFALSE>)
		      (T
		       <SURE-IS-SPOOKY>
		       <RETURN ,OUTSIDE-CEMETERY>)>)
	       (T
		<ITS-CLOSED ,SOUTH-GATE>
		<RFALSE>)>>

<ROUTINE SURE-IS-SPOOKY ()
	 <TELL "Whew! That " D ,CEMETERY " sure is spooky." CR CR>>

<OBJECT SPOOKY-COPSE
	(IN ROOMS)
	(DESC "Spooky Copse")
	(FLAGS ONBIT RLANDBIT)
	(GLOBAL MONUMENTS VAPORS CEMETERY)
	(NORTH PER TOMBS-BLOCK)
	(EAST PER TOMBS-BLOCK)
	(SOUTH PER COPSE-TO-CORNER)
	(WEST PER COPSE-TO-GLEN)
	(DOWN PER ENTER-GRAVE)
	(IN PER ENTER-GRAVE)
	(PSEUDO "LANE" HERE-F)
	(ACTION SPOOKY-COPSE-F)>

<ROUTINE SPOOKY-COPSE-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL 
"A copse of " D ,WILLOWS "s makes this part of the " D ,CEMETERY " look really spooky. Narrow lanes wander south and west.|
|
There's an " D ,OPEN-GRAVE " nearby, freshly dug, with a " D ,MONUMENTS " erected next to it.">
		<COND (<IN? ,GRAVEDIGGER ,SPOOKY-COPSE>
		       <TELL CR CR
"An old " D ,GRAVEDIGGER " is resting under a " D ,WILLOWS ".">)>
		<CRLF>)>>

<OBJECT TWILIGHT-GLEN
	(IN ROOMS)
	(DESC "Twilight Glen")
	(FLAGS ONBIT RLANDBIT)
	(GLOBAL MONUMENTS TREE VAPORS NORTH-GATE CEMETERY)
	(NORTH PER EXIT-TO-LAKE)
	(EAST PER RETURN-TO-COPSE)
	(SOUTH PER TOMBS-BLOCK)
	(WEST PER TOMBS-BLOCK)
	(OUT PER EXIT-TO-LAKE)
	(PSEUDO "LANE" HERE-F)
	(ACTION TWILIGHT-GLEN-F)>

<ROUTINE EXIT-TO-LAKE ()
	 <COND (<FSET? ,NORTH-GATE ,OPENBIT>
		<COND (,SKEWED?
		       <ESCAPE-VAPORS>)
		      (T
		       <SURE-IS-SPOOKY>)>
		<RETURN ,EDGE-OF-LAKE>)
	       (T
		<ITS-CLOSED ,NORTH-GATE>
		<RFALSE>)>>

<ROUTINE RETURN-TO-COPSE ()
	 <COND (<IN? ,GRAVEDIGGER ,EDGE-OF-LAKE>
		<REMOVE ,GRAVEDIGGER>)>
	 <RETURN ,SPOOKY-COPSE>>

<ROUTINE TWILIGHT-GLEN-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL 
"The trees here are so thick, it's almost too dark to see! You can make out a">
		<OPEN-CLOSED ,NORTH-GATE T>
		<TELL D ,NORTH-GATE " " <TO-N> ", and a narrow lane between the " D ,MONUMENTS "s winds off " <TO-E> "." CR>)>>

<OBJECT NORTH-GATE
	(IN LOCAL-GLOBALS)
	(DESC "iron gate")
	(SYNONYM GATE GATES LOCK BARS)
	(ADJECTIVE IRON TALL)
	(FLAGS NDESCBIT VOWELBIT DOORBIT LOCKEDBIT OPENBIT RMUNGBIT)
	(ACTION NORTH-GATE-F)>

; "RMUNGBIT = skewed gate not opened"

<ROUTINE NORTH-GATE-F ()
	 <THIS-IS-IT ,NORTH-GATE>
	 <COND (<VERB? ENTER THROUGH WALK-TO USE>
		<COND (<EQUAL? ,HERE ,TWILIGHT-GLEN>
		       <DO-WALK ,P?NORTH>)
		      (T
		       <DO-WALK ,P?SOUTH>)>
		<RTRUE>)
	       (<GENERIC-GATE? ,NORTH-GATE>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT INSIDE-GRAVE
	(IN ROOMS)
	(DESC "Open Grave")
	(FLAGS ONBIT RLANDBIT)
	(GLOBAL HOLE VAPORS)
	(NORTH PER ENTER-HOLE?)
	(EAST PER WALL-OF-DIRT)
	(SOUTH PER WALL-OF-DIRT)
	(WEST PER WALL-OF-DIRT)
	(UP PER GRAVE-TO-COPSE)
	(IN PER ENTER-HOLE?)
	(OUT PER GRAVE-TO-COPSE)
	(DOWN PER ENTER-HOLE?)
	(ACTION INSIDE-GRAVE-F)
	(PSEUDO "DIRT" WALLS-F)>

<ROUTINE WALL-OF-DIRT ()
	 <TELL "You just walked into a wall of dirt." CR>
	 <RFALSE>>

<ROUTINE ENTER-HOLE? ()
	 <COND (<NOT ,SKEWED?>
	        <CANT-GO>
	        <RFALSE>)
	       (<CANT-FIT-INTO? "hole">
		<RFALSE>)
	       (T
	        <MOVE-ALL ,INSIDE-GRAVE ,OPEN-GRAVE>
		<MOVE ,GRAVE ,INSIDE-GRAVE>
		<RETURN ,TUNNEL-FORK>)>>

<ROUTINE ENTER-GRAVE ()
	 <COND (<CANT-FIT-INTO? "grave">
		<RFALSE>)
	       (,SKEWED?
		<ESCAPE-VAPORS>)
	       (<IN? ,GRAVEDIGGER ,SPOOKY-COPSE>
		<SAY-THE ,GRAVEDIGGER>
		<TELL 
" reaches into the " D ,OPEN-GRAVE " and pulls you out. \"Don't go in there!\" he cries. \"You might get buried alive!\"" CR>
		<RFALSE>)>
	 <MOVE-ALL ,OPEN-GRAVE ,INSIDE-GRAVE>
	 <RETURN ,INSIDE-GRAVE>>
		
<ROUTINE ESCAPE-VAPORS ()
	 <DISABLE <INT I-VAPORS>>
	 <FCLEAR ,VAPORS ,RMUNGBIT>
	 <COND (<AND <EQUAL? ,DIGGER-SCRIPT 1 0>
		     <NOT <EQUAL? ,HERE ,SPOOKY-COPSE>>>
		<SURE-IS-SPOOKY>)
	       (T
		<SAY-THE ,VAPORS>
	        <TELL "s " <PICK-ONE ,VAPOR-YELLS>
" as you escape their misty clutches." CR CR>)>>

<GLOBAL VAPOR-YELLS
	<LTABLE 0 
	 "moan with disappointment"
	 "howl with anguish"
	 "wail with dismay">>

<ROUTINE GRAVE-TO-COPSE ()
	 <COND (<IN? ,BRANCH ,PROTAGONIST>
		<NEVER-GET-OUT-WITH "that branch">
		<RFALSE>)
	       (<AND <IN? ,UMBRELLA ,PROTAGONIST>
		     <FSET? ,UMBRELLA ,OPENBIT>>
		<NEVER-GET-OUT-WITH "that open umbrella">
		<RFALSE>)
	       (<G? <WEIGHT ,PROTAGONIST> 18>
		<NEVER-GET-OUT-WITH "all those things">
		<RFALSE>)
	       (T
		<TELL
"With great difficulty, you manage to climb out of the " 
D ,OPEN-GRAVE "." CR CR>
		<COND (,SKEWED?
		       <SETG DIGGER-SCRIPT 0>
		       <ENABLE <QUEUE I-VAPORS -1>>)>
		<MOVE-ALL ,INSIDE-GRAVE ,OPEN-GRAVE>
		<MOVE ,GRAVE ,INSIDE-GRAVE>
		<RETURN ,SPOOKY-COPSE>)>>

<ROUTINE NEVER-GET-OUT-WITH (STR)
	 <TELL
"You'll never climb out of the " D ,OPEN-GRAVE " holding " .STR "!" CR>>

<ROUTINE ARE-YOU-SURE? ()
	 <COND (<EQUAL? ,HERE ,OUTSIDE-CEMETERY>
		<COND (<FSET? ,SOUTH-GATE ,OPENBIT>
		       <COND (<BE-SURE>
		              <COND (,SKEWED?
			             <SLAM-THE-GATE>
			             <RFALSE>)
			            (T
			             <RETURN ,CREEPY-CORNER>)>)
			     (T
		              <RFALSE>)>)
		      (T
		       <ITS-CLOSED ,SOUTH-GATE>
		       <RFALSE>)>)
	       (<EQUAL? ,HERE ,EDGE-OF-LAKE>
		<COND (<FSET? ,NORTH-GATE ,OPENBIT>
		       <COND (<BE-SURE>
		              <RETURN ,TWILIGHT-GLEN>)
		             (T
		              <RFALSE>)>)
		      (T
		       <ITS-CLOSED ,NORTH-GATE>
		       <RFALSE>)>)>>

<ROUTINE BE-SURE ()
	 <SAY-THE ,CEMETERY>
	 <TELL " is a " <PICK-ONE ,FRIGHTS> " place">
	 <COND (,SKEWED?
		<TELL ", especially at night">)>
	 <TELL ". ">
	 <SAY-SURE>
	 <TELL "go in there?">
	 <COND (<YES?>
	        <COND (,SKEWED?
                       <SETG DIGGER-SCRIPT 0>
                       <ENABLE <QUEUE I-VAPORS -1>>)>
	        <TELL CR "You have been warned." CR CR>
	        <RTRUE>)
	       (T
	        <THAT-WAS-CLOSE>
	        <RFALSE>)>>

<GLOBAL FRIGHTS
	<LTABLE 0 "spooky" "fearful" "creepy">>

<ROUTINE SLAM-THE-GATE ()
	 <FCLEAR ,SOUTH-GATE ,OPENBIT>
	 <FSET ,SOUTH-GATE ,LOCKEDBIT>
	 <TELL "Clang! ">
	 <SUDDEN-GUST>
	 <TELL "blows the " D ,SOUTH-GATE " shut in your face."
	       CR CR ,YOU-HEAR "misty voices giggling ">
	 <COND (<EQUAL? ,HERE ,OUTSIDE-CEMETERY>
		<TELL "on the other side">)
	       (T
		<TELL "all around you">)>
	 <TELL ", and a loud \"click\" as the gate locks." CR>>

<OBJECT CEMETERY
	(IN LOCAL-GLOBALS)
	(DESC "cemetery")
	(SYNONYM CEMETERY GRAVEYARD)
	(ADJECTIVE FESTERON)
	(FLAGS NDESCBIT)
	(ACTION CEMETERY-F)>

<ROUTINE CEMETERY-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE FIND>
		<COND (<IN-CEMETERY?>
		       <RTRUE>)
		      (<EQUAL? ,HERE ,OUTSIDE-CEMETERY>
		       <SEE-IT "west">)
		      (<EQUAL? ,HERE ,EDGE-OF-LAKE>
		       <SEE-IT "south">)
		      (T
		       <REFER-TO-MAP>)>
		<RTRUE>)
	       (<VERB? WALK-TO THROUGH ENTER>
		<COND (<IN-CEMETERY?>
		       <RTRUE>)
		      (<EQUAL? ,HERE ,OUTSIDE-CEMETERY>
		       <DO-WALK ,P?WEST>)
		      (<EQUAL? ,HERE ,EDGE-OF-LAKE>
		       <DO-WALK ,P?SOUTH>)
		      (T
		       <REFER-TO-MAP>)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE IN-CEMETERY? ()
	 <COND (<EQUAL? ,HERE ,CREEPY-CORNER ,SPOOKY-COPSE ,TWILIGHT-GLEN>
	        <TELL "It's all around you!" CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE SEE-IT (STR)
	 <TELL ,YOU-SEE "it to the " .STR "." CR>>

<OBJECT MONUMENTS
	(IN LOCAL-GLOBALS)
	(DESC "tombstone")
	(SYNONYM STONES STONE TOMBSTONES MONUMENTS)
	(ADJECTIVE TOMB TOMBS)
	(FLAGS READBIT)
	(ACTION MONUMENTS-F)>

<ROUTINE MONUMENTS-F ()
	 <COND (<VERB? READ EXAMINE>
		<COND (<EQUAL? ,HERE ,SPOOKY-COPSE>
		       <SAY-THE ,MONUMENTS>
		       <TELL " next to the " D ,OPEN-GRAVE>
		       <COND (,SKEWED?
			      <HAS-YOUR-NAME>)
			     (T
			      <TELL " is blank." CR>)>)
		      (T
		       <TELL "The lettering">
		       <TOO-FADED>)>
		<RTRUE>)
	       (<MOVING? ,MONUMENTS>
		<TOO-LARGE ,MONUMENTS>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE TOO-FADED ()
	 <TELL " is too faded to read clearly." CR>>

<OBJECT OPEN-GRAVE
        (IN SPOOKY-COPSE)
	(DESC "open grave")
	(SYNONYM GRAVE HOLE)
	(ADJECTIVE OPEN)
	(FLAGS NDESCBIT VOWELBIT CONTBIT OPENBIT TRANSBIT)
	(CAPACITY 50)
	(CONTFCN IN-OPEN-GRAVE)
	(ACTION OPEN-GRAVE-F)>

<ROUTINE IN-OPEN-GRAVE (CONTEXT)
	 <COND (<AND <EQUAL? .CONTEXT ,M-CONT>
		     <TOUCHING? ,PRSO>>
		<TELL ,CANT " reach ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO " from here. The " D ,OPEN-GRAVE
		      " is too deep." CR>
		<RFATAL>)
	       (T
		<RFALSE>)>>

<ROUTINE OPEN-GRAVE-F ()
	 <COND (<VERB? WALK-TO ENTER THROUGH CLIMB-DOWN CLIMB-ON>
		<DO-WALK ,P?DOWN>
		<RTRUE>)
	       (<VERB? EXIT CLIMB-UP>
		<ALREADY-IN ,OPEN-GRAVE T>
		<RTRUE>)
	       (<VERB? EXAMINE SEARCH LOOK-DOWN LOOK-INSIDE>
		<TELL "It's six feet deep and freshly dug.">
	        <COND (<FIRST? ,OPEN-GRAVE>
		       <TELL " " ,YOU-SEE>
		       <PRINT-CONTENTS ,OPEN-GRAVE>
		       <TELL " inside.">)>
		<CRLF>
		<RTRUE>)
	       (<AND <VERB? PUT THROW>
		     <EQUAL? ,PRSI ,OPEN-GRAVE>>
		<COND (<EQUAL? ,PRSO ,HANDS>
		       <NOTHING-EXCITING>
		       <RTRUE>)
		    ; (<G? <GETP ,PRSO ,P?SIZE> 10>
		       <TOO-LARGE ,PRSO>
		       <RTRUE>)
		      (<AND <EQUAL? ,PRSO ,UMBRELLA>
			    <FSET? ,UMBRELLA ,OPENBIT>>
		       <YOUD-HAVE-TO "close" ,UMBRELLA>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<GENERIC-GRAVE?>
		<RTRUE>)
	       (T
	        <RFALSE>)>>

<ROUTINE GENERIC-GRAVE? ()
	 <COND (<VERB? DIG>
		<TELL "It's deep enough already." CR>
		<RTRUE>)
	       (<VERB? CLOSE>
		<HOW?>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT GRAVE
	(IN INSIDE-GRAVE)
	(DESC "open grave")
	(SYNONYM GRAVE HOLE)
	(ADJECTIVE OPEN)
	(FLAGS NDESCBIT VOWELBIT CONTBIT OPENBIT TRANSBIT)
	(CAPACITY 50)
	(ACTION GRAVE-F)>

<ROUTINE GRAVE-F ()
	 <COND (<VERB? ENTER WALK-TO THROUGH CLIMB-DOWN>
		<COND (,SKEWED?
		       <DO-WALK ,P?NORTH>)
		      (T
		       <ALREADY-AT ,GRAVE>)>
		<RTRUE>)
	       (<VERB? EXIT CLIMB-UP CLIMB-ON>
		<DO-WALK ,P?OUT>
		<RTRUE>)
	       (<VERB? LOOK-DOWN EXAMINE SEARCH LOOK-INSIDE>
		<V-LOOK>
		<RTRUE>)
	       (<AND <VERB? TAKE>
		     <EQUAL? ,PRSI ,GRAVE>>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (<AND <VERB? PUT THROW>
		     <EQUAL? ,PRSI ,GRAVE>>
		<PERFORM ,V?DROP ,PRSO>
		<RTRUE>)
	       (<GENERIC-GRAVE?>
		<RTRUE>)
	       (T
	        <RFALSE>)>>

<ROUTINE ENTER-SPOOKY-COPSE ()
	 <COND (<AND <NOT ,SKEWED?>
		     <ZERO? ,DIGGER-SCRIPT>>
		<ENABLE <QUEUE I-DIGGER-TALK -1>>)>
	 <RETURN ,SPOOKY-COPSE>>

<ROUTINE COPSE-TO-GLEN ()
	 <COND (<IN? ,GRAVEDIGGER ,TWILIGHT-GLEN>
		<ENABLE <QUEUE I-BYE-DIGGER -1>>)
	       (<IN? ,GRAVEDIGGER ,SPOOKY-COPSE>
		<DISABLE <INT I-DIGGER-TALK>>
		<ENABLE <QUEUE I-DIGGER-FOLLOWS -1>>)>
	 <RETURN ,TWILIGHT-GLEN>>

<ROUTINE I-BYE-DIGGER ()
	 <DISABLE <INT I-BYE-DIGGER>>
	 <CRLF>
	 <SAY-THE ,GRAVEDIGGER>
	 <TELL " is locking the " D ,NORTH-GATE 
	       " from the outside as you approach.">
	 <OUT-OF-TROUBLE>> 

<ROUTINE OUT-OF-TROUBLE ()
	 <THIS-IS-IT ,GRAVEDIGGER>
	 <THIS-IS-IT ,NORTH-GATE>
	 <MOVE ,GRAVEDIGGER ,EDGE-OF-LAKE>
	 <FCLEAR ,NORTH-GATE ,OPENBIT>
         <FSET ,NORTH-GATE ,LOCKEDBIT>
	 <TELL " \"Keep out of the " D ,CEMETERY 
	       " after Dark,\" he tells you with a sly wink." 
	       CR CR ,YOU-HEAR "him chuckling as he disappears " 
	       <TO-N> "." CR>>

<ROUTINE I-DIGGER-FOLLOWS ()
	 <DISABLE <INT I-DIGGER-FOLLOWS>>
	 <CRLF>
	 <SAY-THE ,GRAVEDIGGER>
	 <TELL " follows behind you. ">
	 <COND (<OR <IN? ,ENVELOPE ,GRAVEDIGGER>
		    <IN? ,ENVELOPE ,SPOOKY-COPSE>>
		<MOVE ,ENVELOPE ,PROTAGONIST>
		<FORGOT>
		<TELL " he says, handing it back to you.">
		<YOU-ARE-HOLDING ,ENVELOPE T>)
	       (T
		<TELL 
"\"What's your hurry?\" he complains.">)>
	 <TELL CR CR 
"Throwing a shovel over his shoulder, the " D ,GRAVEDIGGER
" ambles through the " D ,NORTH-GATE " and locks it.">
	 <OUT-OF-TROUBLE>>

<ROUTINE FORGOT ()
	 <TELL "\"Hey! You forgot your envelope!\"">>

<ROUTINE COPSE-TO-CORNER ()
	 <COND (<AND <IN? ,GRAVEDIGGER ,SPOOKY-COPSE>
		     <OR <IN? ,ENVELOPE ,GRAVEDIGGER>
			 <IN? ,ENVELOPE ,SPOOKY-COPSE>>>
		<SAY-THE ,GRAVEDIGGER>
		<TELL " yells, ">
		<FORGOT>
		<CRLF>
		<CRLF>)>
	 <RETURN ,CREEPY-CORNER>>

<OBJECT WILLOWS
	(IN SPOOKY-COPSE)
	(DESC "willow tree")
	(SYNONYM TREE TREES BOUGH BOUGHS)
	(ADJECTIVE WILLOW)
	(FLAGS NDESCBIT)
	(ACTION WILLOWS-F)>

<ROUTINE WILLOWS-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "The droopy boughs sway eerily in the breeze." CR>
		<RTRUE>)
	       (<GETTING-INTO?>
		<NO-FOOTHOLDS>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE NO-FOOTHOLDS ()
	 <TELL ,CANT ". There aren't any good footholds." CR>>

<OBJECT VAPORS
	(IN LOCAL-GLOBALS)
	(DESC "eldritch vapor")
	(SYNONYM VAPOR VAPORS MIST MISTS)
	(ADJECTIVE ELDRITCH RIBBON GHOSTLY)
	(FLAGS VOWELBIT NDESCBIT NARTICLEBIT)
	(ACTION VAPORS-F)>

; "RMUNGBIT = Vapors have stolen a possession"

<ROUTINE VAPORS-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<NOT ,SKEWED?>
		<CANT-SEE-ANY ,VAPORS>
		<RFATAL>)
	       (<VERB? EXAMINE>
		<SAY-THE ,VAPORS>
		<TELL 
"s stare back at you with translucent curiosity." CR>
		<RTRUE>)
	       (<TOUCHING? ,VAPORS>
		<TELL ,CANT " touch an " D ,VAPORS "!" CR>
		<RTRUE>) 
	       (<TALKING-TO? ,VAPORS>
		<SAY-THE ,VAPORS>
		<TELL "s pay no heed." CR>
		<RTRUE>)
	       (<VERB? LISTEN>
		<SAY-THE ,VAPORS>
		<TELL "s' voices are hard to hear, but sinister." CR>
		<RTRUE>)
	       (<AND <VERB? GIVE FEED THROW>
		     <EQUAL? ,PRSI ,VAPORS>>
		<REMOVE ,PRSO>
		<TELL "Silently, ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO " disappears into the ghostly mist." CR>
		<COND (<EQUAL? ,PRSO ,WISHBRINGER ,SHOE>
		       <I-LUCK>)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE I-VAPORS ("AUX" OBJ NXT (DO-LUCK? <>))
	 <COND (<OR ,FUZZY? ,ECLIPSE?>
		<RTRUE>)
	       (<EQUAL? ,HERE ,TWILIGHT-GLEN ,SPOOKY-COPSE ,CREEPY-CORNER>
		<SETG DIGGER-SCRIPT <+ ,DIGGER-SCRIPT 1>>
		<CRLF>
		<COND (<EQUAL? ,DIGGER-SCRIPT 1>
		       <TELL
"As you glance around you notice luminous ribbons of mist darting among the "
D ,MONUMENTS "s. The air is filled with sinister voices." CR>)
		      
		      (<EQUAL? ,DIGGER-SCRIPT 2>
		       <COND (<FSET? ,VAPORS ,RMUNGBIT>
			      <SET OBJ <FIRST? ,PROTAGONIST>>
			      <SAY-THE ,VAPORS>
			      <COND (.OBJ
				     <TELL "s are eyeing ">
				     <ARTICLE .OBJ T>
				     <TELL D .OBJ>
				     <COND (<FSET? .OBJ ,WORNBIT>
					    <TELL " you're wearing">)
					   (T
					    <TELL " in " D ,HANDS "s">)>)
				    (T
				     <TELL "s are hovering around you">)>
			      <TELL " fiendishly">)
			     (T
			      <COND (,LUCKY?
				     <FSET ,VAPORS ,RMUNGBIT>
				     <SETG DIGGER-SCRIPT 1>)>
			      <TELL "The luminous mists suddenly condense into a cloud of " D ,VAPORS "s! Circling like " D ,SHARKS ", they stroke your face with ghostly fingers and whisper dreadful secrets into your ears">)>
		       <TELL "." CR>)
		      
		      (T
		       <SET OBJ <FIRST? ,PROTAGONIST>>
		       <TELL
"Giggling with mischievous Glee, the " D ,VAPORS "s ">
		       <COND (<OR <NOT ,LUCKY?>
				  <NOT .OBJ>>
			      <FCLEAR ,VAPORS ,RMUNGBIT>
			      <DISABLE <INT I-VAPORS>>
		              <TELL 
"clutch your legs and cover your eyes with their luminous hands. ">
			      <SAY-THE ,GROUND>
			      <BENEATH-FEET>
			      <TELL  
" as the foggy fiends lift you high above the treetops">
		              <COND (.OBJ
			             <TELL ", scatter your possessions">)>
		              <TELL " and carry you screaming">
			      <INTO-NIGHT>
		       		       
		            ; "Move player somewhere else"
		
		              <SETG HERE <PICK-ONE ,DROP-OFFS>>
		              <MOVE ,PROTAGONIST ,HERE>
		              		       
		            ; "Scatter player's possessions"
			      		              
		              <REPEAT ()
			              <COND (.OBJ
				             <SET NXT <NEXT? .OBJ>>
				             <FCLEAR .OBJ ,WORNBIT>
					     <MOVE .OBJ <PICK-ONE ,DROP-OFFS>>
				             <COND (<EQUAL? .OBJ ,WISHBRINGER
							    ,SHOE>
						    <SET DO-LUCK? T>)>
					     <SET OBJ .NXT>)
				            (T
				             <RETURN>)>>
		        
		              <COME-TO-SENSES>
			      <COND (.DO-LUCK?
				     <I-LUCK>
				     <I-GLOW>)>)
			     
			   ; "Steal one of player's possessions"

			     (T
			      <SETG DIGGER-SCRIPT 1>
			      <FCLEAR .OBJ ,WORNBIT>
			      <MOVE .OBJ <PICK-ONE ,DROP-OFFS>>
			      <FSET ,VAPORS ,RMUNGBIT>
			      <TELL "snatch ">
			      <ARTICLE .OBJ T>
			      <TELL D .OBJ
" out of " D ,HANDS "s and carry it away">
			      <INTO-NIGHT>
			      <CRLF>
			      <COND (<EQUAL? .OBJ ,BROOM>
				     <SETG BROOM-SIT? <>>)
				    (<EQUAL? .OBJ ,WISHBRINGER ,SHOE>
				     <I-LUCK>
				     <I-GLOW>)>)>)>)>>

<GLOBAL DROP-OFFS
	<LTABLE 0
	 LOOKOUT-HILL PARK FESTERON-POINT
	 SOUTH-OF-BRIDGE EDGE-OF-LAKE ROCKY-PATH WHARF
	 CLIFF-BOTTOM RIVER-OUTLET>>

<ROUTINE INSIDE-GRAVE-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're at the bottom of an " D ,OPEN-GRAVE 
", surrounded by six-foot walls of dirt.">
		<COND (,SKEWED?
		       <COND (<ZERO? ,DIGGER-SCRIPT>
			      <TELL " A">)
			     (T
			      <TELL
" Luminous ribbons of mist are swarming overhead, and a">)>
		       <TELL " dark hole is visible in the north wall.">)>
		<CRLF>)>>

<OBJECT HOLE
	(IN LOCAL-GLOBALS)
	(DESC "hole")
	(SYNONYM HOLE OPENING)
	(ADJECTIVE DARK)
	(ACTION HOLE-F)>

<ROUTINE HOLE-F ()
	 <COND (<OR <NOT ,SKEWED?>
		    <AND <EQUAL? ,HERE ,LOOKOUT-HILL ,UNDER-HILL>
		         <NOT <FSET? ,STUMP ,OPENBIT>>>>
		<CANT-SEE-ANY ,HOLE>
		<RFATAL>)
	       (<VERB? WALK-TO ENTER THROUGH>
		<COND (<EQUAL? ,HERE ,INSIDE-GRAVE ,LOOKOUT-HILL>
		       <DO-WALK ,P?IN>)
		      (<EQUAL? ,HERE ,TUNNEL-FORK>
		       <DO-WALK ,P?SOUTH>)
		      (T
		       <DO-WALK ,P?OUT>)>
		<RTRUE>)
	       (<VERB? EXAMINE LOOK-INSIDE>
	        <CANT-MAKE-OUT-ANYTHING>
	        <RTRUE>)
	       (T 
	        <YOU-DONT-NEED ,HOLE>
		<RFATAL>)>>

<OBJECT UMBRELLA
	(IN TWILIGHT-GLEN)
	(DESC "umbrella")
	(FDESC "There must have been a burial here recently. Somebody left their umbrella leaning up against a tombstone.")
	(SYNONYM UMBRELLA HANDLE HEAD)
        (ADJECTIVE PARROT)
	(FLAGS VOWELBIT CONTBIT TAKEBIT)
	(SIZE 10)
	(CAPACITY 10)
	(VALUE 0)
	(ACTION UMBRELLA-F)>

<ROUTINE UMBRELLA-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "The handle of the">
		<OPEN-CLOSED ,UMBRELLA>
		<TELL D ,UMBRELLA " is carved like a parrot's head." CR>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE LOOK-ON LOOK-DOWN>
		<COND (<FSET? ,UMBRELLA ,OPENBIT>
		       <NOTHING-INTERESTING T>)
		      (T
		       <ITS-CLOSED ,UMBRELLA>)>
		<RTRUE>)
	       (<AND <VERB? OPEN RAISE>
		     <EQUAL? ,PRSO ,UMBRELLA>>
		<COND (<FSET? ,UMBRELLA ,OPENBIT>
		       <ALREADY-OPEN>
		       <RTRUE>)
		      (<NOT <IN? ,UMBRELLA ,PROTAGONIST>>
		       <YOUD-HAVE-TO "be holding" ,UMBRELLA>
		       <RTRUE>)
		      (<EQUAL? ,HERE ,INSIDE-GRAVE>
		       <TELL "There's no room here!" CR>
		       <RTRUE>)>
		<PUTP ,UMBRELLA ,P?SIZE 20>
		<FSET ,UMBRELLA ,SURFACEBIT>
	        <NOW-CLOSED-OR-OPEN ,UMBRELLA T>
		<COND (<FSET? ,HERE ,INDOORSBIT>
		       <BAD-LUCK "open an umbrella indoors">)>
		<RTRUE>)
	       (<AND <VERB? CLOSE LOWER>
		     <FSET? ,UMBRELLA ,OPENBIT>>
	        <COND (<NOT <IN? ,UMBRELLA ,PROTAGONIST>>
		       <YOUD-HAVE-TO "be holding" ,UMBRELLA>
		       <RTRUE>)>
		<PUTP ,UMBRELLA ,P?SIZE 10>
		<FCLEAR ,UMBRELLA ,SURFACEBIT>
		<RFALSE>)
	       (<AND <VERB? PUT PUT-ON>
		     <EQUAL? ,PRSI ,UMBRELLA>>
		<COND (<EQUAL? ,PRSO ,UMBRELLA>
		       <TELL <PICK-ONE ,YUKS> CR>
		       <RTRUE>)
		      (<NOT <IN? ,UMBRELLA ,PROTAGONIST>>
		       <YOUD-HAVE-TO "be holding" ,UMBRELLA>)
		      (<EQUAL? ,PRSO ,HAT ,COAT ,SNAKE-CAN>
		       <TELL "That would look silly." CR>)
		      (<AND <EQUAL? ,PRSA ,V?PUT>
			    <NOT <FSET? ,UMBRELLA ,OPENBIT>>>
		       <ITS-CLOSED ,UMBRELLA>)
		      (<G? <GETP ,PRSO ,P?SIZE> 5>
		       <TOO-LARGE ,PRSO>)
		      (T
		       <TELL "It immediately slides ">
		       <COND (<EQUAL? ,PRSA ,V?PUT-ON>
			      <TELL "off">)
			     (T
			      <TELL "out">)>
		       <AND-DROPS-OUT ,PRSO>)>
		<RTRUE>)
	       (<VERB? STAND-UNDER RAISE>
		<COND (<DONT-HAVE? ,UMBRELLA>
		       <RTRUE>)
		      (<NOT <FSET? ,UMBRELLA ,OPENBIT>>
		       <YOUD-HAVE-TO "open" ,UMBRELLA>)
		      (T
		       <TELL ,OKAY "you look very cosmopolitan." CR>)>
		<RTRUE>)
	       (<AND <VERB? SIT STAND-ON LIE-DOWN MUNG BURN>
		     <EQUAL? ,PRSO ,UMBRELLA>>
		<RUIN ,UMBRELLA>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE PUTTING-OPEN-UMBRELLA? ()
	 <COND (<AND <EQUAL? ,PRSO ,UMBRELLA>
	             <FSET? ,UMBRELLA ,OPENBIT>>
	        <YOUD-HAVE-TO "close" ,UMBRELLA>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT TREE
	(IN LOCAL-GLOBALS)
	(DESC "tree")
	(SYNONYM TREE TREES)
	(FLAGS NDESCBIT)
	(ACTION TREE-F)>

<ROUTINE TREE-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "This is no time for botanizing." CR>
		<RTRUE>)
	       (<GETTING-INTO?>
		<NO-FOOTHOLDS>
		<RTRUE>)
	       (T
		<RFALSE>)>>

