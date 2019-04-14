"EAST for WISHBRINGER: (C)1985 Infocom, Inc. All rights reserved."

"*** PLEASURE WHARF ***"

<ROUTINE ENTER-PLEASURE-WHARF ()
	 <COND (<AND ,SKEWED?
		     <NOT ,BOX-SEEN?>>
		<SETG BOX-SEEN? T>
		<ENABLE <QUEUE I-WAKE-BOX -1>>)>
	 <RETURN ,PLEASURE-WHARF>>

<OBJECT PLEASURE-WHARF
	(IN ROOMS)
	(DESC "Pleasure Wharf")
	(FLAGS ONBIT RLANDBIT WETBIT)
	(GLOBAL BAY ARCADE SIGN SAND)
	(NORTH PER ENTER-POOL?)
	(EAST PER ENTER-WHARF)
	(SOUTH TO VIDEO-ARCADE)
	(WEST TO ROTARY-EAST)
	(IN TO VIDEO-ARCADE)
	(ACTION PLEASURE-WHARF-F)
	(PSEUDO "WHARF" HERE-F)>

<ROUTINE PLEASURE-WHARF-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<STANDING>
		<TELL "near the ">
		<COND (,SKEWED?
		       <TELL "remains of">)
		      (T
		       <TELL D ,ENTRANCE " to">)>
		<TELL " the " D ,PLEASURE-WHARF>
		<COND (<NOT ,SKEWED?>
		       <TELL ", the town's most popular tourist attraction">)>
		<TELL ". The Wharf extends eastward into">
		<WHICH-TOWN "Bay">
		<COND (<NOT ,SKEWED?>
		       <TELL 
", and a tidal beach curves north along the shore">)>
		<TELL ".|
|
To the south stands a ramshackle old building. Colorful lights, curious electronic sounds and a neon sign beckon you through the open " D ,ENTRANCE "." CR>)>>

<ROUTINE ENTER-POOL? ()
	 <COND (<NOT ,SKEWED?>
		<RETURN ,TIDAL-POOL>)
	       (T
		<TELL ,CANT " go that way now. The tide is in." CR>
		<RFALSE>)>>
 
"*** WHARF ***"

<OBJECT WHARF
	(IN ROOMS)
	(DESC "Wharf's End")
	(FLAGS ONBIT RLANDBIT WETBIT)
	(GLOBAL BAY)
	(NORTH PER FALL-OFF-WHARF)
	(EAST PER FALL-OFF-WHARF)
	(SOUTH PER FALL-OFF-WHARF)
	(WEST PER ENTER-PLEASURE-WHARF)
	(ACTION WHARF-F)
	(PSEUDO "PLANKS" HERE-F "WHARF" HERE-F)>

<ROUTINE WHARF-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "The sea-worn planks of the">
		<WHICH-TOWN>
		<TELL " " D ,PLEASURE-WHARF
" end abruptly a few feet " <TO-E> ". You're surrounded by the ">
		<COND (,SKEWED?
		       <TELL "dark, shark-infested">)
		      (T
		       <TELL "blue, sparkling">)>
		<TELL " waters of">
		<WHICH-TOWN "Bay">
		<TELL "." CR>)>>

<ROUTINE ENTER-WHARF ()
	 <COND (<AND <NOT ,SKEWED?>
		     <NOT <FSET? ,HORSE ,TOUCHBIT>>>
		<ENABLE <QUEUE I-HORSE-DEATH -1>>)>
	 <RETURN ,WHARF>>

<ROUTINE FALL-OFF-WHARF ()
	 <COND (,SKEWED?
	        <SAY-THE ,SHARKS>
		<TELL " would gobble you up">
		<IF-YOU-TRIED>)
	       (T
	        <PROBABLY-DROWN>)>
	 <RFALSE>>

<OBJECT SHARKS
	(DESC "sharks")
	(SYNONYM SHARK SHARKS FIN FINS)
	(ADJECTIVE BLACK)
	(FLAGS NDESCBIT)
	(ACTION SHARKS-F)>

<ROUTINE SHARKS-F ()
	 <COND (<VERB? EXAMINE LOOK-ON>
		<TELL ,YOU-SEE 
"their black fins circling in the water nearby." CR>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,SHARKS>
		<RFATAL>)>>

<OBJECT BAY
	(IN LOCAL-GLOBALS)
	(DESC "bay")
	(SYNONYM BAY SEA OCEAN WATER)
	(ADJECTIVE FESTERON)
	(FLAGS NDESCBIT TRYTAKEBIT CONTBIT OPENBIT)
	(ACTION BAY-F)>

<ROUTINE BAY-F ()
	<COND (<VERB? EXAMINE>
	       <TELL "The waters of the bay ">
	       <COND (,SKEWED?
		      <TELL "swell ominously in the moon">)
		     (T
		      <TELL "twinkle merrily in the sun">)>
	       <TELL "light." CR>
	       <RTRUE>)
	      (<HANDLE-WATER?>
	       <RTRUE>)
	      (T
	       <RFALSE>)>>

"*** VIDEO ARCADE ***"

<OBJECT VIDEO-ARCADE
	(IN ROOMS)
	(DESC "Video Arcade")
	(FLAGS ONBIT RLANDBIT INDOORSBIT)
	(GLOBAL ARCADE SIGN CORNER)
	(NORTH PER EXIT-ARCADE)
	(OUT PER EXIT-ARCADE)
	(ACTION VIDEO-ARCADE-F)>

<ROUTINE EXIT-ARCADE ()
	 <COND (<FSET? ,MACHINE ,TOOLBIT>
		<ENABLE <QUEUE I-SMOKE -1>>
		<FCLEAR ,MACHINE ,TOOLBIT>
		<TELL "One of the " D ,HUMANOIDS " eagerly takes over your "
		      D ,MACHINE " as you walk away." CR CR>)>
	 <RETURN ,PLEASURE-WHARF>>

<ROUTINE VIDEO-ARCADE-F (CONTEXT)
	<COND (<EQUAL? .CONTEXT ,M-LOOK>
	       <TELL "This old building is the home of a sleazy " D ,ARCADE
", lined with coin-op video games. The machines are ">
	       <COND (,SKEWED?
		      <THIS-IS-IT ,HUMANOIDS>
		      <TELL
"crowded with half-crazed, " D ,HUMANOIDS ", who pay no attention to you as they satisfy their thirst for electric violence.|
|
One machine in the " D ,CORNER " appears to be deserted">)
		     (T
		      <THIS-IS-IT ,MACHINE>
		      <TELL "all deserted and quiet">
		      <COND (<NOT <FSET? ,MACHINE ,RMUNGBIT>>
			     <TELL ", except for one in the " D ,CORNER 
" that emits a feeble \"wokka-wokka\" sound">)>)>
	       <TELL "." CR CR>
	       <ARCADE-SIGN>)>>

<ROUTINE ARCADE-SIGN ()
	 <TELL
"A sign on the wall says, \"All Games One Token.\"" CR>>

<OBJECT ARCADE
	(IN LOCAL-GLOBALS)
	(DESC "arcade")
	(SYNONYM ARCADE BUILDING ENTRANCE ENTRY)
	(ADJECTIVE VIDEO OLD RAMSHACKLE)
	(ACTION ARCADE-F)>

<ROUTINE ARCADE-F ()
	 <COND (<ENTER-FROM? ,PLEASURE-WHARF ,VIDEO-ARCADE ,ARCADE>
		<RTRUE>)
	       (<VERB? LOOK-ON EXAMINE LOOK-INSIDE>
		<COND (<EQUAL? ,HERE ,PLEASURE-WHARF>
		       <GO-INSIDE>)
		      (T
		       <V-LOOK>)>
		<RTRUE>)
	       (<VERB? OPEN>
		<ALREADY-OPEN>
		<RTRUE>)
	       (<VERB? CLOSE>
		<TELL ,CANT " close the " D ,ARCADE
		      " (though many have tried)." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT HUMANOIDS
	(DESC "stunted humanoids")
	(SYNONYM HUMANOIDS)
	(ADJECTIVE STUNTED)
	(FLAGS NDESCBIT NARTICLEBIT ACTORBIT)
	(ACTION HUMANOIDS-F)>

<ROUTINE HUMANOIDS-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<VERB? EXAMINE>
		<TELL 
"They have extraordinarily supple wrists, fast reflexes and tiny brains." CR>
		<RTRUE>)
	       (<OR <TALKING-TO? ,HUMANOIDS>
		    <VERB? GIVE FEED YELL>>
		<SAY-THE ,HUMANOIDS>
		<TELL " pay no attention." CR>
		<RFATAL>)
	       (<HURT? ,HUMANOIDS>
		<TELL "Why bother? The " D ,HUMANOIDS 
		      " will soon be extinct anyway." CR>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,HUMANOIDS>
		<RFATAL>)>>
		
<OBJECT MACHINE
	(IN VIDEO-ARCADE)
	(DESC "game machine")
	(SYNONYM MACHINE UNIT GAME LOGO)
	(ADJECTIVE GAME ARCADE VIDEO SIDES BROKEN)
	(FLAGS NDESCBIT CONTBIT OPENBIT READBIT)
	(CAPACITY 1)
	(ACTION MACHINE-F)>

; "TOOLBIT = MACHINE ON, RMUNGBIT = MACHINE BROKEN"

<ROUTINE MACHINE-F () 
	 <COND (<VERB? EXAMINE READ LOOK-ON>
		<SAY-THE ,MACHINE>
		<TELL " is equipped with a video screen, a joystick, a big red button and a narrow slot for tokens. A lurid logo (\"">
		<COND (,SKEWED?
		       <TELL "TRANSMATTER">)
		      (T
		       <TELL "LEATHER GODDESSES OF PHOBOS">)>
		<TELL "!\") is painted on the side." CR>
		<RTRUE>)
	       (<VERB? LISTEN KICK>
		<COND (<FSET? ,MACHINE ,RMUNGBIT>
		       <NOTHING-EXCITING>
		       <RTRUE>)
		      (,SKEWED?
		       <SAY-THE ,MACHINE>
		       <TELL " emits a familiar electronic dirge.">)
		      (T
		       <TELL "\"Wokka.\"">)>
		<CRLF>
		<RTRUE>)
	       (<PUT-THING-IN-SLOT?>
		<RTRUE>)
	       (<VERB? OPEN CLOSE LOOK-INSIDE>
		<TELL "Only an authorized service representative of the ">
		<FROBOZZ "Arcade Game">
		<TELL " could do that." CR>
		<RTRUE>)
	       (<BREAK-MACHINE?>
		<RTRUE>)
	       (<VERB? PLAY>
		<HOW?>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT VIDEO-SCREEN 
	(IN VIDEO-ARCADE)
	(DESC "video screen")
	(SYNONYM SCREEN GRID MAP MESSAGE)
	(ADJECTIVE VIDEO FLASHING DIAMOND)
	(FLAGS NDESCBIT READBIT)
	(ACTION VIDEO-SCREEN-F)>

<ROUTINE VIDEO-SCREEN-F ()
	 <COND (<VERB? EXAMINE READ>
		<SAY-THE ,VIDEO-SCREEN>
		<COND (<OR <NOT ,SKEWED?>
			   <FSET? ,MACHINE ,RMUNGBIT>>
		       <TELL " is dark.">)
		      (T
		       <TELL " displays a map of">
		       <WHICH-TOWN "Village">
		       <TELL ". A grid divides the map into 13 squares">
		       <COND (<FSET? ,MACHINE ,TOOLBIT>
			      <TELL
", and a " D ,STAR " is centered over one of the squares">)
		             (T
			      <TELL ". The words \"Insert Token To Play\" are scrolling across the top of the screen">)>
		       <TELL "." CR CR>
		       <FIND-IN-PACKAGE "map">
		       <RTRUE>)>
		<CRLF>
		<RTRUE>)
	       (<BREAK-MACHINE?>
		<RTRUE>)
	       (T
		<RFALSE>)>> 

<ROUTINE BREAK-MACHINE? ()
	 <COND (<NOT <FSET? ,MACHINE ,RMUNGBIT>>
		<COND (<AND <VERB? PUSH MOVE SHAKE>
			    <FSET? ,MACHINE ,TOOLBIT>>
		       <TELL "An electric alarm shrieks, \"Tilt!\"" CR>
		       <GAME-OVER>
		       <RTRUE>)
		      (<AND <VERB? THROW>
			    <EQUAL? ,PRSI ,MACHINE>>
		       <MOVE ,PRSO ,HERE>
		       <MUNG-MACHINE>
		       <RTRUE>)
		      (<HURT? ,MACHINE>
		       <MUNG-MACHINE>
	               <RTRUE>)
	              (T
		       <RFALSE>)>)
	       (T
		<RFALSE>)>>

<ROUTINE MUNG-MACHINE ()
	 <FCLEAR ,MACHINE ,TOOLBIT>
	 <FSET ,MACHINE ,RMUNGBIT>
	 <TELL "A shower of sparks erupts from the back of the " D ,MACHINE 
", and the " D ,VIDEO-SCREEN " goes black." CR>>

<OBJECT STAR
	(IN VIDEO-ARCADE)
	(DESC "blinking star")
	(SYNONYM STAR CURSOR)
	(ADJECTIVE BLINKING)
	(FLAGS NDESCBIT READBIT)
	(ACTION STAR-F)>

<ROUTINE STAR-F ()
	 <COND (<NOT <FSET? ,MACHINE ,TOOLBIT>>
		<CANT-SEE-ANY>
		<RFATAL>)
	       (<VERB? EXAMINE READ>
	        <SAY-THE ,STAR>
		<TELL " is now centered over square "
		      <GET ,H-NAMES ,HORZ> "-" N ,VERT " on the map." CR>
		<RTRUE>)
	       (<VERB? MOVE PULL PUSH>
		<HOW?>
		<RTRUE>)
	       (<VERB? PUSH-TO>
		<TELL "(with the " D ,JOYSTICK ")" CR>
		<PERFORM ,V?PUSH-TO ,JOYSTICK ,PRSI>
		<RTRUE>)
	       (T
		<RFALSE>)>>
		
<GLOBAL H-NAMES <PLTABLE "A" "B" "C" "D" "E">>

<OBJECT SLOT
	(IN VIDEO-ARCADE)
	(DESC "slot")
	(SYNONYM SLOT)
	(ADJECTIVE NARROW)
	(FLAGS NDESCBIT CONTBIT OPENBIT READBIT)
	(CAPACITY 1)
	(ACTION SLOT-F)>

<ROUTINE SLOT-F ()
	 <COND (<VERB? EXAMINE READ LOOK-ON>
		<TELL "The narrow slot is marked \"Tokens Only!\"" CR>
		<RTRUE>)
	       (<OR <PUT-THING-IN-SLOT?>
		    <BREAK-MACHINE?>>
		<RTRUE>)
	       (<VERB? OPEN CLOSE>
		<TELL <PICK-ONE ,YUKS> CR>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE LOOK-BEHIND>
		<TOO-DARK>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE PUT-THING-IN-SLOT? ()
	 <COND (<OR <VERB? REACH-IN>
		    <AND <VERB? PUT>
		         <NOT <EQUAL? ,PRSO ,TOKEN>>>>
		<SAY-THE ,SLOT>
		<TELL " is too narrow." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT JOYSTICK
	(IN VIDEO-ARCADE)
	(DESC "joystick")
	(SYNONYM JOYSTICK STICK)
	(ADJECTIVE JOY CONTROL)
	(FLAGS NDESCBIT ; TRYTAKEBIT)
	(ACTION JOYSTICK-F)>

<GLOBAL VERT 3>
<GLOBAL HORZ 5>

<ROUTINE JOYSTICK-F ()
	 <COND (<AND <VERB? PUSH-TO>
		     <EQUAL? ,PRSI ,INTDIR>>
		
		<COND (<NOT <FSET? ,MACHINE ,TOOLBIT>>
		       <NOTHING-EXCITING>)
		      
		      (<EQUAL? ,P-DIRECTION ,P?NORTH ,P?UP>
		       <COND (<OR <EQUAL? ,HORZ 1 5>
				  <EQUAL? ,VERT 1>
				  <AND <EQUAL? ,HORZ 2 4>
				       <EQUAL? ,VERT 2>>>
			      <JOYBUZZ>)
			     (T
			      <SETG VERT <- ,VERT 1>>
			      <MOVE-STAR "upward">)>)
		      
		      (<EQUAL? ,P-DIRECTION ,P?SOUTH ,P?DOWN>
		       <COND (<OR <EQUAL? ,HORZ 1 5>
				  <EQUAL? ,VERT 5>
				  <AND <EQUAL? ,HORZ 2 4>
				       <EQUAL? ,VERT 4>>>
			      <JOYBUZZ>)
			     (T
			      <SETG VERT <+ ,VERT 1>>
			      <MOVE-STAR "downward">)>)
		      
		      (<EQUAL? ,P-DIRECTION ,P?EAST>
		       <COND (<OR <EQUAL? ,VERT 1 5>
				  <EQUAL? ,HORZ 5>
				  <AND <EQUAL? ,VERT 2 4>
				       <EQUAL? ,HORZ 4>>>
			      <JOYBUZZ>)
			     (T
			      <SETG HORZ <+ ,HORZ 1>>
			      <MOVE-STAR "to the right">)>)
		      		       
		      (<EQUAL? ,P-DIRECTION ,P?WEST>
		       <COND (<OR <EQUAL? ,VERT 1 5>
				  <EQUAL? ,HORZ 1>
				  <AND <EQUAL? ,VERT 2 4>
				       <EQUAL? ,HORZ 2>>>
			      <JOYBUZZ>)
			     (T
			      <SETG HORZ <- ,HORZ 1>>
			      <MOVE-STAR "to the left">)>)
		      (T
		       <RFALSE>)>
		<RTRUE>)
	       
	       (<VERB? EXAMINE>
		<SAY-THE ,JOYSTICK>
		<TELL 
" can be moved north, south, east or west." CR>
		<RTRUE>)
	       
	       (<VERB? PUSH MOVE PULL USE PLAY>
		<TELL "(To use the " D ,JOYSTICK ", you must indicate a compass direction as well as an action. For example, try MOVE THE JOYSTICK TO THE WEST or PUSH STICK NORTH.)" CR>
		<RFATAL>)
	       
	       (<BREAK-MACHINE?>
		<RTRUE>)
	       
	       (T
		<RFALSE>)>>

<ROUTINE JOYBUZZ ()
	 <TELL "Buzz! A synthetic voice growls, \"Keep the " D ,STAR
	       " inside the grid!\"" CR>>

<ROUTINE MOVE-STAR (STR)
	 <TELL "Bing! You moved the " D ,STAR " one square " .STR "." CR>>

<OBJECT BUTTON
	(IN VIDEO-ARCADE)
	(DESC "big red button")
	(SYNONYM BUTTON SWITCH)
	(ADJECTIVE BIG RED LARGE CRIMSON)
	(FLAGS NDESCBIT)
	(ACTION BUTTON-F)>

<ROUTINE BUTTON-F ()
	 <COND (<VERB? PUSH>
		<COND (<NOT <EQUAL? ,HERE ,VIDEO-ARCADE>>
		       <CANT-SEE-ANY ,BUTTON>
		       <RTRUE>)>
		<SAY-SURE>
		<TELL "push the " D ,BUTTON "?">
		<COND (<YES?>
		       <CRLF>
		       <COND (,SKEWED?
			      <SAY-THE ,HUMANOIDS>
			      <TELL " in the " D ,ARCADE " "
				    <PICK-ONE ,POSSIBILITIES>
                                    " as " D ,HANDS " touches the ">
			      <COND (<FSET? ,MACHINE ,TOOLBIT>
				     <TELL "flashing ">)>
			      <TELL "button. This might be a trap">)
			     (T
			      <TELL "You don't know what this "
				    D ,MACHINE " might do">)>
		       <TELL "! You don't really want to press that "
			     D ,BUTTON ", do you?">
		       <COND (<YES?>
			      <PRESS-BUTTON>
			      <RTRUE>)>)>
		<THAT-WAS-CLOSE>
	        <RTRUE>)
	       (<AND <VERB? EXAMINE>
		     <FSET? ,MACHINE ,TOOLBIT>>
		<TELL "It's flashing on and off rapidly." CR>
		<RTRUE>)
	       (<BREAK-MACHINE?>
		<RTRUE>)
	       (T
		<RFALSE>)>>
				    
<GLOBAL POSSIBILITIES
	<LTABLE 0
         "snicker behind your back"
         "watch you carefully"
         "hold their breath">>

<ROUTINE PRESS-BUTTON ("AUX" WHERE)
	 <TELL CR "(">
	 <COND (<FSET? ,MACHINE ,TOOLBIT>
		<SET WHERE <GET <GET ,DESTINATIONS ,HORZ> ,VERT>>
	        <ENABLE <QUEUE I-SMOKE -1>>
		<TELL "Hope you saved your story position.)|
|
A sudden power drain makes all the other games in the " D ,ARCADE " go dim. Blue sheets of energy leap from the " D ,MACHINE ", surrounding you in an incandescent aura.">
		<COND (<NOT <EQUAL? .WHERE ,VIDEO-ARCADE>>
		       <COND (<EQUAL? .WHERE ,INSIDE-GRAVE>
		              <MOVE-ALL ,OPEN-GRAVE ,INSIDE-GRAVE>)>
		       <MOVE ,PROTAGONIST .WHERE>
		       <SETG HERE .WHERE>
		       <TELL " You can feel your molecules being taken apart one at a time, analyzed, modulated and broadcast through space. It is not a pleasant sensation.">
	               <CARRIAGE-RETURNS>
	               <V-LOOK>)
		      (T           ; "Handle the dummy corner"
		       <CRLF>
		       <CRLF>
		       <MUNG-MACHINE>)>
	        <GAME-OVER>
		<COND (<EQUAL? .WHERE ,HILLTOP>
		       <CRLF>
		       <UPDATE-SCORE 5>)>)
	       (T
		<TELL ,OKAY "just testing you.)" CR CR>
		<NOTHING-EXCITING>)>>

<ROUTINE GAME-OVER ()
	 <FCLEAR ,MACHINE ,TOOLBIT>
	 <TELL CR
"A synthetic voice says, \"Game Over. Insert Token To Play Again.\"" CR>>

<OBJECT TOKEN
	(DESC "brass token")
	(SYNONYM TOKEN)
	(ADJECTIVE BRASS)
	(FLAGS NDESCBIT TAKEBIT READBIT)
	(VALUE 3)
	(SIZE 1)
	(ACTION TOKEN-F)>

<ROUTINE TOKEN-F ()
	 <COND (<VERB? EXAMINE READ>
		<TELL 
"The words \"Good For One Play\" are etched into the " D ,TOKEN "." CR>
		<RTRUE>)
	       (<AND <VERB? PUT>
		     <EQUAL? ,PRSI ,MACHINE ,SLOT>>
		<REMOVE ,TOKEN>
		<SAY-THE ,TOKEN>
		<TELL " disappears into the slot">
		<COND (<FSET? ,MACHINE ,RMUNGBIT>
		       <TELL ", but the broken " D ,MACHINE
			     " doesn't respond." CR>)
		      (T
		       <FSET ,MACHINE ,TOOLBIT>
		       <TELL ".|
|
Ding! You hear a pleasant electric chime, and a " D ,STAR 
" appears on the " D ,VIDEO-SCREEN "." CR CR>
		       <UPDATE-SCORE 1>
		       <GOOD-PLACE-TO-SAVE>)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

"*** TIDAL POOL ***"

<OBJECT TIDAL-POOL
	(IN ROOMS)
	(DESC "Tidal Pool")
	(FLAGS ONBIT RLANDBIT WETBIT)
	(GLOBAL BAY SAND)
	(NORTH TO FESTERON-POINT)
	(EAST PER PROBABLY-DROWN)
	(SOUTH TO PLEASURE-WHARF)
	(WEST "There's nothing but sand that way.")
	(DOWN "There's nothing but sand that way.")
        (ACTION TIDAL-POOL-F)>

<ROUTINE TIDAL-POOL-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're on a damp stretch of sand that extends north towards Festeron Point, and south to the " D ,PLEASURE-WHARF "." CR>)>>

<OBJECT CONCH-SHELL
	(IN TIDAL-POOL)
	(DESC "conch shell")
	(FDESC "A large conch shell is lying in the sand at your feet.")
	(SYNONYM SHELL)
	(ADJECTIVE CONCH ADVICE)
	(FLAGS TAKEBIT CONTBIT OPENBIT RMUNGBIT)
	(ACTION CONCH-SHELL-F)
	(CAPACITY 1)
	(SIZE 5)
	(VALUE 0)>

<ROUTINE CONCH-SHELL-F ()
	 <COND (<VERB? LISTEN>
		<COND (<DONT-HAVE? ,CONCH-SHELL>
		       <RTRUE>)>
		<COND (<AND <NOT ,WOMAN-SEEN-ENVELOPE?>
			    <FSET? ,CONCH-SHELL ,RMUNGBIT>>
		       <FCLEAR ,CONCH-SHELL ,RMUNGBIT>
		       <TINY-VOICE>
		       <TELL " that sounds just like">
		       <BOSS>
		       <TELL ", " <PICK-ONE ,YELL-TYPES> ", \"">
		       <COND (<HELD? ,ENVELOPE>
			      <TELL "Don't just stand there! DELIVER">)
			     (T
			      <TELL "You " <PICK-ONE ,INSULTS>>)>
		       <TELL "!\"">)
		      (<AND <ENABLED? ,I-SHELL-TALK>
			    <L? ,SHELL-SCRIPT 5>>
		       <FCLEAR ,CONCH-SHELL ,RMUNGBIT>
		       <SETG SHELL-SCRIPT 1>
		       <TINY-VOICE>
		       <TELL " says, \"" <GET ,WISE-SAYINGS ,WISDOM> ".\"">)
		      (T
		       <TELL ,YOU-HEAR "the rush of ocean surf.">)>
		<CRLF>
		<RTRUE>)
	       (<VERB? BLOW-INTO>
		<COND (<DONT-HAVE? ,CONCH-SHELL>
		       <RTRUE>)>
		<SAY-THE ,CONCH-SHELL>
		<TELL " makes an embarrassing sound." CR>
		<RTRUE>)
	       (<VERB? SHAKE LOOK-INSIDE>
		<COND (<DONT-HAVE? ,CONCH-SHELL>
		       <RTRUE>)>
		<TELL "A few grains of sand fall out." CR>
		<RTRUE>)
	       (<AND <VERB? PUT>
		     <EQUAL? ,PRSI ,CONCH-SHELL>>
		<COND (<G? <GETP ,PRSO ,P?SIZE> 1>
		       <TOO-LARGE ,PRSO>)
		      (T
		       <TELL "It immediately drops out">
		       <AND-DROPS-OUT ,PRSO>)>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<SAY-THE ,CONCH-SHELL>
		<TELL " is smooth and shiny. It">
		<TV-SET>
		<TELL "." CR>
		<RTRUE>)
	       (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,CONCH-SHELL>>
		<COND (<AND <V-TAKE>
			    <IN? ,WISHBRINGER ,PROTAGONIST>
			    <FSET? ,ADVICE ,TOUCHBIT>>
		       <START-BUZZ>)>
		<RTRUE>)
	       (<VERB? CLOSE OPEN>
		<TELL <PICK-ONE ,YUKS> CR>
		<RTRUE>)
	       (<HURT? ,CONCH-SHELL>
		<RUIN ,CONCH-SHELL>
		<RTRUE>)
	       (T
	        <RFALSE>)>>

<ROUTINE TV-SET ("OPTIONAL" (MY? <>))
	 <TELL "'ll look great on ">
	 <COND (.MY?
		<TELL "my">)
	       (T
		<TELL "your">)>
	 <TELL " TV set back home">>

<ROUTINE TINY-VOICE ()
	  <TELL "A tiny voice in the " D ,CONCH-SHELL>>

<GLOBAL WISDOM 1>

<GLOBAL WISE-SAYINGS
	<PTABLE 0 
; (0) ; "Get thee to yonder Tower, for therein lies thy Fate"
; (1) "If ye hath not kept a Map, only patience or Magick can help thee"
; (2) "Magick may help thee cross the Bridge"
; (3) "Release a prisoner, and be Rewarded"
; (4) "Learn the Word of Power, else never gain the Tower"
; (5) "One path Magick, one path Science; both lead to thy Goal"
; (6) "Many wonders await thee in the Halls of Knowledge"
; (7) "Fit the pieces together, and the Puzzle is complete">>

<ROUTINE START-BUZZ ("OPTIONAL" (SAYING <>))
	 <COND (.SAYING
		<SETG WISDOM .SAYING>)>
	 <COND (<AND <FSET? ,ADVICE ,TOUCHBIT>
		     <IN? ,CONCH-SHELL ,PROTAGONIST>
		     <IN? ,WISHBRINGER ,PROTAGONIST>
		     <NOT <ENABLED? ,I-SHELL-TALK>>>
		<SETG SHELL-SCRIPT 7>
		<ENABLE <QUEUE I-SHELL-TALK -1>>)>>

<OBJECT SAND
	(IN LOCAL-GLOBALS)
	(DESC "sand")
	(SYNONYM SAND BEACH BANK)
	(FLAGS TRYTAKEBIT NDESCBIT)
	(ACTION SAND-F)
	(VALUE 0)>

<ROUTINE SAND-F ()
	 <COND (<VERB? SEARCH EXAMINE DIG LOOK-UNDER LOOK-INSIDE LOOK-ON>
		<NOTHING-INTERESTING>
		<RTRUE>)
	       (<VERB? TAKE>
		<SAY-THE ,SAND>
		<TELL " slips away between your fingers." CR>
		<RTRUE>)
	       (<VERB? FOLLOW WALK-TO CROSS THROUGH ENTER EXIT>
		<COND (<EQUAL? ,HERE ,PLEASURE-WHARF>
		       <DO-WALK ,P?NORTH>)
		      (<EQUAL? ,HERE ,FESTERON-POINT>
		       <DO-WALK ,P?SOUTH>)
		      (T
		       <V-WALK-AROUND>)>
		<RTRUE>)
	       (<AND <VERB? PUT PUT-ON THROW>
		     <EQUAL? ,PRSI ,SAND>>
		<PERFORM ,V?DROP ,PRSO>
		<RTRUE>)
	       (<VERB? KICK>
		<RFALSE>)
	       (T
		<YOU-DONT-NEED ,SAND>
		<RFATAL>)>>

"*** OUTSIDE LIGHTHOUSE ***"

<OBJECT FESTERON-POINT
	(IN ROOMS)
	(DESC "Lighthouse")
	(FLAGS ONBIT RLANDBIT WETBIT)
	(GLOBAL BAY RIVER SAND)
	(NORTH PER PROBABLY-DROWN-IN-RIVER)
	(EAST PER PROBABLY-DROWN)
	(SOUTH PER ENTER-POOL?)
	(WEST TO ROCKY-PATH)
	(ACTION FESTERON-POINT-F)>

<ROUTINE FESTERON-POINT-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "This is where the river empties into">
		<WHICH-TOWN "Bay">
		<TELL ". A">
		<COND (<NOT ,SKEWED?>
		       <TELL 
" beach follows the shore of the bay " <TO-S> ", and a">)>
		<TELL " path leads west along the riverbank.|
|
A ">
		<COND (,SKEWED?
		       <TELL "broken-down old ">)
		      (T
		       <TELL "miniature ">)>
		<TELL D ,LIGHTHOUSE 
", barely ten feet high, stands ">
		<COND (<NOT ,SKEWED?>
		       <TELL "blinking ">)>
		<TELL "on the shore nearby." CR>
		<COND (<IN? ,PELICAN ,FESTERON-POINT>
		       <CRLF>
		       <NOTE-PELICAN>)>)>>

<ROUTINE NOTE-PELICAN ()
	 <TELL "Perched on top of the " D ,LIGHTHOUSE 
	       " is a " D ,PELICAN ", ">
	 <COND (<IN? ,HAT ,PELICAN>
		<A-WIZARDS-HAT>)
	       (T
		<TELL "watching you through half-closed eyelids.">)>
	 <CRLF>>

<ROUTINE A-WIZARDS-HAT ()
	 <TELL "a " D ,HAT " balanced on its head." CR>>

<OBJECT LIGHTHOUSE
	(IN FESTERON-POINT)
	(DESC "lighthouse")
	(SYNONYM LIGHTHOUSE HOUSE BEACON)
	(ADJECTIVE MINIATURE MINI AUTOMATIC AUTO BROKEN)
	(FLAGS SURFACEBIT NDESCBIT)
	(ACTION LIGHTHOUSE-F)
	(CAPACITY 10)>

<ROUTINE LIGHTHOUSE-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE>
		<TELL "It's really just an automated beacon, erected by the town to impress tourists. ">
		<NO-ENTRIES>
		<COND (<IN? ,PELICAN ,FESTERON-POINT>
		       <CRLF>
		       <NOTE-PELICAN>)>
		<RTRUE>)
	       (<AND <VERB? LOOK-ON>
		     <IN? ,PELICAN ,FESTERON-POINT>>
		<NOTE-PELICAN>
		<RTRUE>)
	       (<AND <VERB? PUT PUT-ON>
		     <EQUAL? ,PRSI ,LIGHTHOUSE>>
		<COND (<NOT <IN? ,PELICAN ,FESTERON-POINT>>
		       <MOVE ,PRSO ,FESTERON-POINT>
		       <TELL "It slides off the " D ,LIGHTHOUSE
			     " and lands at your feet." CR>)
		      (<OR <EQUAL? ,PRSO ,DHORSE ,WORM ,HAT>
			   <EQUAL? ,PRSO ,WISHBRINGER ,CHOCOLATE ,MILK>>
		       <PERFORM ,V?GIVE ,PRSO ,PELICAN>)
		      (T
		       <MOVE ,PRSO ,FESTERON-POINT>
		       <SAY-THE ,PELICAN>
		       <TELL " pushes ">
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO " off the " D ,LIGHTHOUSE 
" with its beak and glares at you." CR>)>
		<RTRUE>)
	       (<AND <VERB? WALK-TO ENTER THROUGH PUT>
		     <EQUAL? ,PRSO ,LIGHTHOUSE>>
		<NO-ENTRIES>
		<RTRUE>)
	       (<VERB? SIT LIE-DOWN STAND-ON CLIMB-ON CLIMB-UP>
	        <COND (<IN? ,PELICAN ,FESTERON-POINT>
		       <THIS-IS-IT ,PELICAN>
		       <SAY-THE ,PELICAN>
		       <TELL " rudely nudges you off with its foot">)
		      (T
		       <TELL "There isn't enough room">)>
		<TELL "." CR>
		<RTRUE>)
	       (<VERB? OPEN CLOSE>
		<TELL <PICK-ONE ,YUKS> CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE NO-ENTRIES ()
	 <TELL "There aren't any " D ,ENTRANCE "s or openings." CR>>



