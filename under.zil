"UNDER for WISHBRINGER: (C)1985 Infocom, Inc. All rights reserved."

<OBJECT TUNNEL-FORK
	(IN ROOMS)
	(DESC "Underground")
	(FLAGS RLANDBIT INDOORSBIT)
	(GLOBAL HOLE)
	(NORTH TO UNDER-HILL)
	(EAST TO UNDER-CELL)
	(SOUTH PER INTO-GRAVE)
	(IN "Which way do you want to go in?")
	(OUT "Which way do you want to go out?")
	(PSEUDO "TUNNEL" HERE-F)
	(ACTION TUNNEL-FORK-F)>

<ROUTINE TUNNEL-FORK-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<SAY-CHAMBER>
		<TELL <TO-N> 
" and east, and there's a dark hole in the south wall." CR>)>>

<ROUTINE SAY-CHAMBER ()
	 <TELL "You're in a " <PICK-ONE ,CRAMPS> 
	       " under" D ,GROUND " chamber. ">
	 <COND (<PROB 50>
		<TELL "Long">)
	       (T
		<TELL "Cold">)>
	 <COND (<PROB 50>
	        <TELL ", " <PICK-ONE ,CRAMPS>>)>
	 <TELL " tunnels wander away ">>

<GLOBAL CRAMPS <LTABLE 0 "damp" "dark" "smelly" "dirty">>

<ROUTINE INTO-GRAVE ()
	 <COND (<CANT-FIT-INTO? "hole">
		<RFALSE>)
	       (T
		<MOVE-ALL ,OPEN-GRAVE ,INSIDE-GRAVE>
	        <RETURN ,INSIDE-GRAVE>)>>

<OBJECT TUNNEL-CORNER
	(IN ROOMS)
	(DESC "Underground")
	(FLAGS RLANDBIT INDOORSBIT)
	(EAST PER ENTER-GRUE-NEST)
	(SOUTH TO UNDER-CELL)
	(WEST TO UNDER-HILL)
	(OUT "Which way do you want to go out?")
	(PSEUDO "TUNNEL" HERE-F)
	(ACTION TUNNEL-CORNER-F)>

<ROUTINE TUNNEL-CORNER-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<SAY-CHAMBER>
		<TELL <TO-S> ", east and west." CR>)>>

<ROUTINE ENTER-GRUE-NEST ()
	 <COND (<AND <NOT ,GRUE-COVERED?>
		     <NOT <ENABLED? I-GRUE-SLEEP>>>
		<SETG SLEEP-SCRIPT 0>
	        <ENABLE <QUEUE I-GRUE-SLEEP -1>>)>
	 <RETURN ,GRUE-NEST>>

<OBJECT UNDER-HILL
	(IN ROOMS)
	(DESC "Underground")
	(FLAGS RLANDBIT INDOORSBIT)
	(GLOBAL STUMP)
	(EAST TO TUNNEL-CORNER)
	(SOUTH TO TUNNEL-FORK)
	(UP TO LOOKOUT-HILL IF STUMP IS OPEN)
	(OUT "Which way do you want to go out?")
	(PSEUDO "TUNNEL" HERE-F)
	(ACTION UNDER-HILL-F)>

<ROUTINE UNDER-HILL-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<SAY-CHAMBER>
		<TELL <TO-S> " and east.|
|
The surrounding walls are almost obscured by the roots of a mighty tree. ">
		<COND (<FSET? ,STUMP ,OPENBIT>
		       <TELL 
"Feeble light streams in from an opening overhead">)
		      (T
		       <TELL
"Overhead you can see the underside of a large " D ,STUMP ". It appears to be hinged">)>
		<TELL "." CR>)>>

"*** GRUE'S NEST ***"

<OBJECT GRUE-NEST
	(IN ROOMS)
	(DESC "Grue's Nest")
	(FLAGS RLANDBIT INDOORSBIT)
	(GLOBAL SIGN CORNER)
	(WEST PER EXIT-NEST)
	(OUT PER EXIT-NEST)
	(PSEUDO "TUNNEL" HERE-F "NEST" HERE-F)
	(ACTION GRUE-NEST-F)>

<ROUTINE EXIT-NEST ()
	 <SETG SLEEP-SCRIPT <- ,SLEEP-SCRIPT 1>>
	 <RETURN ,TUNNEL-CORNER>>

<ROUTINE GRUE-NEST-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL
"You have stumbled into the nesting place of a family of grues. Congratulations. Few indeed are the adventurers who have entered a grue's nest and lived as long as you have.|
|
Everything is littered with rusty swords of elvish workmanship, piles of bones and other debris. A">
		<OPEN-CLOSED ,REFRIGERATOR T>
	        <TELL D ,REFRIGERATOR 
" stands in one " D ,CORNER " of the nest, and something">
		<COND (<IN? ,BLANKET ,BABY>
		       <TELL " is curled up under a " D ,BLANKET>)
		      (T
		       <TELL
"... a small, dangerous-looking " D ,BABY "... is curled up">)>
		<TELL " in the other " D ,CORNER ".|
|
The only exit is to the west. Hope you survive long enough to use it."
CR>)>>

<OBJECT BABY
	(IN GRUE-NEST)
	(DESC "little beast")
	(SYNONYM BEAST ANIMAL GRUE GRUB)
	(ADJECTIVE LITTLE BABY SLEEPING SMALL)
	(FLAGS NDESCBIT ACTORBIT SURFACEBIT)
	(CAPACITY 10)
	(SIZE 10)
	(ACTION BABY-F)>

<GLOBAL GRUE-COVERED? <>>

<ROUTINE BABY-F ("OPTIONAL" (CONTEXT <>)) 
     	 <COND (<VERB? EXAMINE>
		<SAY-THE ,BABY>
		<TELL " is ">
		<COND (<IN? ,BLANKET ,BABY>
		       <TELL "covered with a " D ,BLANKET>)
		      (T
		       <TELL 
"dressed in swaddling clothes with a pink baby bonnet, has long, slavering fangs and appears to be sleeping">)>
		<TELL "." CR>
		<RTRUE>) 
	       
	       (<AND <VERB? TELL HELLO REPLY ALARM YELL
			    ASK-ABOUT ASK-FOR QUESTION>
		     <EQUAL? ,PRSO ,BABY>>
		<WAKE-BABY "The sound of your voice">
		<RFATAL>)
	       	       
	       (<AND <VERB? PUT PUT-ON THROW THROW-OFF>
		     <EQUAL? ,PRSI ,BABY>>
		<COND (<EQUAL? ,PRSO ,BLANKET>
		       <COVER-GRUE>)
		      (T
		       <WAKE-BABY>)>
		<RTRUE>)
	       (<AND <VERB? HIDE>
		     <EQUAL? ,PRSO ,BABY>
		     ,PRSI>
		<COND (<EQUAL? ,PRSI ,BLANKET>
		       <COVER-GRUE>)
		      (T
		       <PERFORM ,V?PUT-ON ,PRSI ,BABY>)>
		<RTRUE>)
	       (<VERB? KISS> 
		<SAY-THE ,BABY>
		<TELL " smiles in its sleep." CR>
		<RTRUE>)
	       (<VERB? FEED GIVE>
		<YOUD-HAVE-TO "wake" ,BABY>
		<RTRUE>)
	       (<TOUCHING? ,BABY>
		<WAKE-BABY>
		<RFATAL>)
	       (<VERB? LISTEN>
		<SAY-THE ,BABY>
		<TELL " snores gently." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE WAKE-BABY ("OPTIONAL" REASON)
	 <TELL "Oh, no! ">
	 <COND (.REASON
		<TELL .REASON>)
	       (T
		<TELL "Your reckless fumbling">)>
	 <TELL " woke up the " D ,BABY "!|
|
The little creature ">
	 <COND (,LIT
		<TELL "blinks helplessly in the glow of">
	        <CANDLE-OR-STONE>)
	       (T
		<TELL "gurgles angrily in the " D ,DARKNESS>)>
	 <TELL ".">
	 <MOTHER-COMES>>

<ROUTINE MOTHER-COMES ()
	 <TELL " It opens its slavering jaws and">
	 <SUBWAY>
	 <CRLF>
	 <CRLF>
	 <COND (,LIT
		<TELL "A very large creature, equipped with slavering fangs and wearing a calico apron,">)
	       (T
		<TELL "Something very large">)>
	 <TELL " lurks into the nest">
	 <COND (,LIT
		<TELL ". Its mother-instinct overcomes its overwhelming fear of light long enough to devour">)
	       (T
		<TELL " and devours">)>
	 <TELL " you.">
	 <BAD-ENDING>>

<ROUTINE SUBWAY ()
	 <TELL " emits a hideous, plaintive wail that reminds you of a subway screeching to a halt.">>

<ROUTINE COVER-GRUE ()
	 <SETG GRUE-COVERED? T>
	 <DISABLE <INT I-GRUE-SLEEP>>
	 <MOVE ,BLANKET ,BABY>
	 <TELL ,OKAY "the " D ,BABY " is now covered with the " D ,BLANKET ".|
|
The creature stirs restlessly for an anxious moment. Then it settles into the comfortable " D ,DARKNESS " of the " D ,BLANKET 
", sighs gently and lies still." CR CR>
	 <UPDATE-SCORE 3>>

<ROUTINE CANDLE-OR-STONE ("AUX" OBJ)
	 <COND (<OR <IN? ,CANDLE ,PROTAGONIST>
		    <IN? ,CANDLE ,HERE>>
		<SET OBJ ,CANDLE>)
	       (T
		<SET OBJ ,WISHBRINGER>)>
	 <TELL " ">
	 <ARTICLE .OBJ T>
	 <TELL D .OBJ>>

<GLOBAL SLEEP-SCRIPT 0>

<ROUTINE I-GRUE-SLEEP ()
	 <COND (<OR ,FUZZY? ,ECLIPSE?>
		<RTRUE>)
	       (<EQUAL? ,HERE ,GRUE-NEST>
		<COND (<NOT ,LIT>
		       <SETG SLEEP-SCRIPT 0>
		       <RTRUE>)
		      (T
		       <SETG SLEEP-SCRIPT <+ ,SLEEP-SCRIPT 1>>
		       <CRLF>
		       <COND (<EQUAL? ,SLEEP-SCRIPT 1>
			      <TELL "Snoring fitfully, the " D ,BABY
" turns away from the light of">
			      <CANDLE-OR-STONE>
			      <TELL " and faces the wall." CR>)
			     (<EQUAL? ,SLEEP-SCRIPT 2>
			      <SAY-THE ,BABY>
			      <TELL
" is stirring restlessly. It looks as if it's about to wake up!" CR>)
			     (T
			      <TELL
"With a toothy yawn, the " D ,BABY " opens its big red eyes and blinks at you with surprise and fear.">
			      <MOTHER-COMES>)>)>)>>  

<OBJECT REFRIGERATOR
	(IN GRUE-NEST)
	(DESC "refrigerator")
	(SYNONYM REFRIGERATOR FRIGE FRIDGE)
	(ADJECTIVE GRUE)
	(FLAGS CONTBIT NDESCBIT TRYTAKEBIT READBIT)
	(CAPACITY 10)
	(ACTION REFRIGERATOR-F)>

<ROUTINE REFRIGERATOR-F ()
	 <COND (<VERB? EXAMINE LOOK-ON READ> 
		<TELL "A label on the " D ,REFRIGERATOR " reads, \"">
		<FROBOZZ "Grue Refrigerator">
		<TELL ".\"" CR>
		<RTRUE>)
	       (<AND <VERB? OPEN>
		     <NOT <FSET? ,REFRIGERATOR ,OPENBIT>>>
		<HANDLE-FRIDGE " goes out as you open">
		<RFALSE>)
	       (<AND <VERB? CLOSE>
		     <FSET? ,REFRIGERATOR ,OPENBIT>>
		<HANDLE-FRIDGE " comes on as you close">
		<RFALSE>)
	       (<AND <VERB? PUT-ON>
		     <EQUAL? ,PRSI ,REFRIGERATOR>>
		<NO-ROOM>
		<TELL "It's covered with debris." CR>
		<RTRUE>)
	       (<MOVING? ,REFRIGERATOR>
		<TOO-LARGE ,REFRIGERATOR>
		<RTRUE>)
	       (<HURT? ,REFRIGERATOR>
		<TELL "The owners">
		<MIGHT-NOT-LIKE>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE HANDLE-FRIDGE (STR)
	 <TELL "A light inside the " D ,REFRIGERATOR .STR " it." CR CR>>

<OBJECT BOTTLE
	(IN REFRIGERATOR)
	(DESC "bottle")
	(SYNONYM BOTTLE)
	(ADJECTIVE MILK)
	(FLAGS CONTBIT TAKEBIT TRANSBIT READBIT)
	(VALUE 0)
	(CAPACITY 1)
	(SIZE 5)
	(ACTION BOTTLE-F)>

<ROUTINE BOTTLE-F ("AUX" (FULL? <>))
	 <THIS-IS-IT ,BOTTLE>
	 <SET FULL? <IN? ,MILK ,BOTTLE>>
	 <COND (<VERB? EXAMINE LOOK-ON READ>
		<TELL "The words \"">
		<FROBOZZ "Unbreakable Milk Bottle">
		<TELL "\" are etched on the">
		<OPEN-CLOSED ,BOTTLE>
		<TELL D ,BOTTLE "." CR>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE LOOK-DOWN SEARCH>
		<COND (<NOT <EQUAL? <LOC ,BOTTLE> ,HERE ,PROTAGONIST>>
		       <YOUD-HAVE-TO "take out" ,BOTTLE>
		       <RTRUE>)>
		<TELL "There's ">
		<COND (.FULL?
		       <TELL "a bit of " D ,MILK>)
		      (T
		       <PRINT-CONTENTS ,BOTTLE>)>
		<TELL " in the " D ,BOTTLE "." CR>
		<RTRUE>)
	       (<VERB? DRINK DRINK-FROM>
		<COND (.FULL?
		       <PERFORM ,V?DRINK ,MILK>)
		      (T
		       <BOTTLE-EMPTY>)>
		<RTRUE>)
	       (<VERB? POUR EMPTY>
		<COND (.FULL?
		       <PERFORM ,V?POUR ,MILK>)
		      (T
		       <BOTTLE-EMPTY>)>
		<RTRUE>)
	       (<VERB? SHAKE>
		<COND (.FULL?
		       <COND (<FSET? ,BOTTLE ,OPENBIT>
			      <PERFORM ,V?POUR ,MILK>)
			     (T
			      <SAY-THE ,MILK>
			      <TELL " doesn't look any better." CR>)>)
		      (T
		       <BOTTLE-EMPTY>)>
		<RTRUE>)
	       (<AND <VERB? PUT>
		     <EQUAL? ,PRSI ,BOTTLE>>
		<TELL "The mouth of the " D ,BOTTLE
		      " is too narrow." CR>
		<RTRUE>)
	       (<AND <VERB? OPEN CLOSE>
		     <DONT-HAVE? ,BOTTLE>>
		<RTRUE>)
	       (<HURT? ,BOTTLE>
		<TELL 
"Maybe you should read the " D ,BOTTLE " first." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE BOTTLE-EMPTY ()
	 <SAY-THE ,BOTTLE>
	 <TELL " is empty." CR>>

<OBJECT MILK
	(IN BOTTLE)
	(DESC "grue milk")
	(SYNONYM MILK LIQUID)
	(ADJECTIVE GRUE LITTLE ICKY)
	(FLAGS NDESCBIT NARTICLEBIT TAKEBIT)
	(ACTION MILK-F)
	(SIZE 0)>

<ROUTINE ACCESS-MILK? ()
	 <COND (<NOT <IN? ,MILK ,BOTTLE>>
		<BOTTLE-EMPTY>
		<RFALSE>)
	       (<FSET? ,BOTTLE ,OPENBIT>
		<RTRUE>)
	       (T
		<YOUD-HAVE-TO "open" ,BOTTLE>
		<RFALSE>)>>

<ROUTINE MILK-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE>
		<SAY-THE ,MILK>
		<TELL 
" is dark brown, with little icky things lurking in it." CR>
		<RTRUE>)
	       (<NOT <IN? ,BOTTLE ,PROTAGONIST>>
		<YOUD-HAVE-TO "be holding" ,BOTTLE>
		<RTRUE>)
	       (<VERB? DRINK DRINK-FROM TASTE>
		<COND (<ACCESS-MILK?>
		       <REMOVE ,MILK>
		       <SETG MILK-SCRIPT 4>
		       <ENABLE <QUEUE I-DRINK -1>>
		       <TELL "Slurp! All gone." CR>)>
		<RTRUE>)
	       (<AND <VERB? POUR EMPTY TAKE PUT PUT-ON THROW DROP>
		     <EQUAL? ,PRSO ,MILK>>
		<COND (<ACCESS-MILK?>
		       <REMOVE ,MILK>
		       <SAY-THE ,MILK>
		       <TELL " splashes all over the place." CR>
		       <COND (<AND <ACCESSIBLE? ,KITTY>
				   <NOT <FSET? ,KITTY ,RMUNGBIT>>>
			      <CRLF>
			      <GIVE-MILK-TO-CAT ,KITTY>)
			     (<ACCESSIBLE? ,CHAOS>
			      <CRLF>
			      <GIVE-MILK-TO-CAT ,CHAOS>)>)>
		<RTRUE>)
	       (<AND <VERB? FEED GIVE>
		     <EQUAL? ,PRSO ,MILK>
		     <FSET? ,PRSI ,ACTORBIT>>
		<PERFORM ,V?POUR ,MILK>
		<RTRUE>)
	       (<VERB? SMELL>
		<COND (<ACCESS-MILK?>
		       <TELL "The fumes make you queasy." CR>)>
		<RTRUE>)
	       (<VERB? SHAKE>
		<MEAN-BOTTLE>
		<PERFORM ,V?SHAKE ,BOTTLE>
		<RTRUE>)
	       (<VERB? EAT BITE>
		<NOT-SOLID>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE MEAN-BOTTLE ()
	 <TELL ,I-ASSUME " the " D ,BOTTLE ".)" CR CR>>

<GLOBAL MILK-SCRIPT 0>

<ROUTINE I-DRINK ()
	 <SETG MILK-SCRIPT <- ,MILK-SCRIPT 1>>
	 <CRLF>
	 <COND (<EQUAL? ,MILK-SCRIPT 3>
		<TELL
"You can feel little icky things sliding down your throat.">)
	       (<EQUAL? ,MILK-SCRIPT 2>
		<TELL 
"(The " D ,MILK " is lurking in your stomach.">
		<MAKE-IT-SNAPPY>)
	       (<EQUAL? ,MILK-SCRIPT 1>
		<TELL
"(The taste of the " D ,MILK " is starting to wear off.">
		<HOLD-YOUR-PEACE>)
	       (T
		<SETG MILK-SCRIPT 0>
		<DISABLE <INT I-DRINK>>
		<TELL
"(Thankfully, the icky taste of " D ,MILK " is gone.)">)>
	 <CRLF>>

<OBJECT WORM
	(IN REFRIGERATOR)
	(DESC "earthworm")
	(SYNONYM WORM EARTHWORM)
	(ADJECTIVE EARTH WORMS)
	(FLAGS VOWELBIT TAKEBIT)
	(VALUE 3)
	(SIZE 1)
	(ACTION WORM-F)>

<ROUTINE WORM-F ()
	 <COND (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,WORM>>
		<COND (<V-TAKE>
		       <CRLF>
		       <SAY-THE ,WORM>
	               <TELL " squirms with annoyance at your touch." CR>)>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<SAY-THE ,WORM>
		<TELL " is covered with nasty little bits of dirt and slime. It wriggles nervously">
		<COND (<IN? ,WORM ,PROTAGONIST>
		       <TELL " in " D ,HANDS>)>
		<TELL " as you look at it." CR>
		<RTRUE>)
	       (<TALKING-TO? ,WORM>
		<IT-IGNORES-YOU ,WORM>
		<RFATAL>)
	       (<AND <VERB? EAT TASTE KISS>
		     <EQUAL? ,PRSO ,WORM>>
		<TELL "Yuck! You've got to be kidding." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>> 
	       
<OBJECT DEBRIS
	(IN GRUE-NEST)
	(DESC "debris")
	(SYNONYM DEBRIS BONE SWORDS BONES)
	(ADJECTIVE SWORD ELVISH)
	(FLAGS NDESCBIT)
	(ACTION DEBRIS-F)>

<ROUTINE DEBRIS-F ()
	 <COND (<NOT <EQUAL? ,HERE ,GRUE-NEST>>
		<CANT-SEE-ANY>
		<RFATAL>)
	       (<SEE-VERB?>
		<TELL "Aside from the ominous implications, you see nothing "
<PICK-ONE ,YAWNS> " about the " D ,DEBRIS "." CR>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,DEBRIS>
		<RFATAL>)>>

; <OBJECT GENERIC-GRUE
	(IN GLOBAL-OBJECTS)
	(DESC "grue")
	(SYNONYM GRUE GRUES)
	(ADJECTIVE LURKING SINISTER)
	(ACTION GENERIC-GRUE-F)>

; <ROUTINE GENERIC-GRUE-F ()
          <COND (<AND <EQUAL? ,HERE ,GRUE-NEST>
		      <BABY-F>>
		 <RTRUE>)
      		(<VERB? EXAMINE>
		 <TELL
"No one has ever seen a grue... except, perhaps, from the inside." CR>
		 <RTRUE>)
	        (<VERB? WHAT>
	         <TELL
"The grue is a sinister, lurking presence in the dark places of the earth. Its favorite diet is adventurers, but its insatiable appetite is tempered by its fear of light. No grue has ever been seen by the light of day, and few have survived its fearsome jaws to tell the tale." CR>
		<RTRUE>)
	       (<VERB? FIND WHERE>
	        <TELL "There aren't any grues here">
	        <COND (<FSET? ,HERE ,ONBIT>
		       <TELL "! There's too much light.">
		       <CRLF>)
		      (T
		       <TELL ", but there's probably one">
		       <LURKING-NEARBY>)>
		<RTRUE>)
	       (<VERB? LISTEN>
	        <TELL "They make no sound, but are always">
		<LURKING-NEARBY>
		<RTRUE>)
	       (T
		<RFALSE>)>>

; <ROUTINE LURKING-NEARBY ()
	 <TELL " lurking in the " D ,DARKNESS " nearby." CR>>

"*** UNDER CELL ***"

<OBJECT UNDER-CELL
	(IN ROOMS)
	(DESC "Underground")
	(FLAGS RLANDBIT INDOORSBIT)
	(GLOBAL CELL HIDDEN-HATCH)
	(NORTH TO TUNNEL-CORNER)
	(WEST TO TUNNEL-FORK)
	(UP PER THROUGH-HATCH?)
	(OUT "Which way do you want to go out?")
	(PSEUDO "TUNNEL" HERE-F)
	(ACTION UNDER-CELL-F)>

<ROUTINE UNDER-CELL-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<SAY-CHAMBER>
		<TELL <TO-N> " and west." CR CR>
		<COND (<FSET? ,HIDDEN-HATCH ,RMUNGBIT>
		       <TELL "A patch of freshly-dried concrete is visible">)
		      (T
		       <COND (<FSET? ,UNDER-CELL ,ONBIT>
			      <TELL 
"Faint light is streaming in from a narrow hole">)
			     (T
			      <TELL "A dark, narrow hole is visible">)>)>
		<TELL " overhead." CR>)>>
		
