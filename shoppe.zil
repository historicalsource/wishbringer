"SHOPPE for WISHBRINGER: (C)1985 Infocom, Inc. All rights reserved."

"*** CLIFF EDGE ***"

<OBJECT CLIFF-EDGE 
	(IN ROOMS)
	(DESC "Cliff Edge")
	(FLAGS ONBIT RLANDBIT RMUNGBIT)
	(GLOBAL CLIFF MAGICK-SHOPPE SHOPPE-DOOR TOWER SIGN POST-OFFICE
	 	TRAIL HILL)
	(NORTH PER BUMP-CLIFF)
	(EAST PER TUMBLE)
	(SOUTH PER TUMBLE)
	(WEST PER ENTER-SHOPPE)
	(DOWN PER ENTER-FOG?)
	(IN PER ENTER-SHOPPE)
	(ACTION CLIFF-EDGE-F)
	(PSEUDO "FOG" CLIFF-FOG-PSEUDO)>

; "RMUNGBIT = Cliff Edge not yet visited"

<ROUTINE CLIFF-EDGE-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<STANDING>
		<TELL "high on a rocky cliff, at the top of a steep " D ,TRAIL
" leading downward.">
		<COND (,SUCCESS?
		       <TELL
" Looking southeast, you see a friendly orange sun rising from a bank of morning clouds." CR CR D ,POST-OFFICE " Hill is visible " <TO-S> ", topped as usual by the Festeron " D ,POST-OFFICE ".">)>
		<COND (<FSET? ,MAGICK-SHOPPE ,TOUCHBIT>
		       <SHOPPE-IS-NEARBY>)
		      (T
		       <FSET ,MAGICK-SHOPPE ,TOUCHBIT>
		       <COND (,ENDING?
			      <RTRUE>)
			     (,SKEWED?
			      <TELL CR CR
"The surrounding landscape has disappeared under a " D ,BLANKET " of evening fog. All the familiar buildings and landmarks are completely hidden; only the summit of " D ,POST-OFFICE " Hill is high enough to pierce the cloud, rising like a lonely " D ,ISLE " in a sea of mist...|
|
... an " D ,ISLE " with a " D ,TOWER " on it.|
|
There's a TOWER where the " D ,POST-OFFICE " used to be! The massive outline is hard to make out against the twilight sky. But the longer you stare, the clearer and more frightening it becomes.">
			      <SHOPPE-IS-NEARBY>)
			     (T
		       	      <TELL
" Looking southwest, you can see the shadow of " D ,POST-OFFICE " Hill creeping across the " D ,FESTERON " as the sun sinks into a bank of clouds.|
|
The peaceful scenery is disturbed by a tiny figure emerging from the distant "
D ,POST-OFFICE ". It stares in your direction for a few moments, checks its wrist and shakes a threatening little fist at you.|
|
A little old-fashioned store stands nearby. Its brightly painted shutters and thatched roof remind you of something out of a fairy tale. ">
		       <DESCRIBE-SIGN>)>)>)>>

<ROUTINE SHOPPE-IS-NEARBY ()
	 <CRLF>
	 <CRLF>
	 <SAY-THE ,MAGICK-SHOPPE>
	 <TELL " stands nearby." CR>>

<ROUTINE DESCRIBE-SIGN ()
	 <TELL 
"A curiously painted sign over the " D ,HOUSE-DOOR " reads, \"Ye Olde "
D ,MAGICK-SHOPPE ".\"" CR>>

<ROUTINE CLIFF-FOG-PSEUDO ()
	 <COND (<OR <NOT ,SKEWED?>
		    ,SUCCESS?>
		<CANT-SEE-ANY>
		<RFATAL>)
	       (<VERB? EXAMINE LOOK-INSIDE LOOK-ON>
		<V-LOOK>
		<RTRUE>)
	       (<VERB? WALK-TO THROUGH ENTER>
		<DO-WALK ,P?DOWN>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED "fog" T>
		<RFATAL>)>>

<OBJECT MAGICK-SHOPPE
	(IN LOCAL-GLOBALS)
	(DESC "Magick Shoppe")
	(SYNONYM SHOPPE SHOP STORE BUILDING)
	(ADJECTIVE MAGICK MAGIC)
	(ACTION MAGICK-SHOPPE-F)>

<ROUTINE MAGICK-SHOPPE-F ()
	 <COND (<ENTER-FROM? ,CLIFF-EDGE ,INSIDE-SHOPPE ,MAGICK-SHOPPE>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<COND (<EQUAL? ,HERE ,INSIDE-SHOPPE>
		       <V-LOOK>)
		      (T
		       <DESCRIBE-SIGN>)>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE LOOK-THRU>
		<COND (<FSET? ,SHOPPE-DOOR ,OPENBIT>
		       <GO-INSIDE>
		       <RTRUE>)
		      (T
		       <ITS-CLOSED ,SHOPPE-DOOR>
		       <RFATAL>)>)
	       (T
		<RFALSE>)>>

<OBJECT SHOPPE-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "Magick Shoppe door")
	(SYNONYM DOOR ENTRANCE ENTRY LOCK)
	(ADJECTIVE FRONT SHOPPE SHOP MAGICK MAGIC)
	(FLAGS DOORBIT NDESCBIT)
	(ACTION SHOPPE-DOOR-F)>

; <GLOBAL CLOSED-IN-SHOPPE? <>>

<ROUTINE SHOPPE-DOOR-F ()
	 <COND (<AND <VERB? OPEN MOVE PULL PUSH>
		     <EQUAL? ,PRSO ,SHOPPE-DOOR>
		     <NOT <FSET? ,SHOPPE-DOOR ,OPENBIT>>>
		<COND (<OR <EQUAL? ,HERE ,INSIDE-SHOPPE>
			   ,SKEWED?>
		       <BEST-EFFORTS ,HOUSE-DOOR "refuses to budge">
		       <COND (<IN? ,OLD-WOMAN ,HERE>
			      <TELL CR
"\"That door always sticks this time of year,\" notes the "
D ,OLD-WOMAN " drily." CR>)>
		       <RTRUE>)
		      (T
		       <BELL-TINKLES>
		       <CRLF>
		       <RFALSE>)>)
	       (<AND <VERB? CLOSE>
		     <FSET? ,SHOPPE-DOOR ,OPENBIT>>
	      ; <COND (<EQUAL? ,HERE ,INSIDE-SHOPPE>
		       <SETG CLOSED-IN-SHOPPE? T>)>
		<BELL-TINKLES>
		<RFALSE>)
	       (<VERB? KNOCK>
		<COND (<FSET? ,SHOPPE-DOOR ,OPENBIT>
		       <ALREADY-OPEN>)
		      (<EQUAL? ,HERE ,INSIDE-SHOPPE>
		       <WASTE-OF-TIME>)
		      (,ENDING?
		       <SETG WOMAN-SCRIPT 5>)
		      (,SKEWED?
		       <RFALSE>)
		      (T
		       <TELL "A voice cries, \"Come in!\"" CR>)>
		<RTRUE>)
	       (<USE-DOOR? ,CLIFF-EDGE>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE BELL-TINKLES ()
	 <TELL "A concealed bell tinkles merrily." CR>>

"*** INSIDE SHOPPE ***"

<ROUTINE ENTER-SHOPPE ()
	 <COND (<FSET? ,SHOPPE-DOOR ,OPENBIT>
		<COND (<HELD? ,ENVELOPE>
		       <ENABLE <QUEUE I-WOMAN-SCRIPT -1>>
		       <DISABLE <INT I-BEFORE-FIVE>>
		       <RETURN ,INSIDE-SHOPPE>)
	              (T
		       <FCLEAR ,SHOPPE-DOOR ,OPENBIT>
		       <SAY-THE ,SHOPPE-DOOR>
		       <TELL ", sensing that you have no mail to deliver, slams itself shut in your face. ">
		       <BELL-TINKLES>
		       <RFALSE>)>)
	       (T
		<ITS-CLOSED ,SHOPPE-DOOR>
		<RFALSE>)>>

<ROUTINE MOBILE? ()
	 <COND (,IMMOBILIZED?
		<UNWILLING-TO-MOVE>
		<RFALSE>)
	     ; (<FSET? ,SHOPPE-DOOR ,OPENBIT>
		<SETG CLOSED-IN-SHOPPE? T>
	 	<TELL "Bang! ">
		<SUDDEN-GUST>
		<TELL "slams the ">
		<PRINTD ,SHOPPE-DOOR>
		<TELL " shut. ">
		<BELL-TINKLES>
		<FCLEAR ,SHOPPE-DOOR ,OPENBIT>
		<RFALSE>)
	       (T
		<ITS-CLOSED ,SHOPPE-DOOR>
		<RFALSE>)>>

<ROUTINE UNWILLING-TO-MOVE ()
	 <TELL <PICK-ONE ,FROZENS> "." CR>
	 <RFALSE>>
	       
<GLOBAL FROZENS 
	<LTABLE 0
"Your feet seem unwilling to move in that direction"
"A subtle pressure against your body prevents you from moving that way">>

<ROUTINE APPROACH-CURTAIN ()
	 <COND (,IMMOBILIZED?
		<UNWILLING-TO-MOVE>)
	       (T
		<TELL
"As you approach the " D ,CURTAIN "ed exit, the " D ,MAGICK-SHOPPE " subtly rearranges itself until you find yourself facing the other way.">
		<COND (<IN? ,OLD-WOMAN ,INSIDE-SHOPPE>
		       <TELL " The " D ,OLD-WOMAN 
			     " watches with wry amusement.">)>
		<CRLF>)>
	 <RFALSE>>

<OBJECT INSIDE-SHOPPE
	(IN ROOMS)
	(DESC "Magick Shoppe")
	(FLAGS ONBIT RLANDBIT INDOORSBIT)
	(GLOBAL MAGICK-SHOPPE SHOPPE-DOOR CORNER)
	(EAST PER MOBILE?)
	(WEST PER APPROACH-CURTAIN)
	(IN PER APPROACH-CURTAIN)
	(OUT PER MOBILE?)
	(ACTION INSIDE-SHOPPE-F)>

<ROUTINE INSIDE-SHOPPE-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL
"You're in the front showroom of the " D ,MAGICK-SHOPPE ".|
|
Every inch of wall space is crowded with magic tricks, puzzles and mystical paraphernalia. A glass case offers a selection of obscene jokes and naughty birthday cards.|
|
In the " D ,CORNER " stands an ancient " D ,CLOCK 
", its dial ornamented with a " <PICK-ONE ,FACES> "ing crescent moon and other celestial symbols.|
|
The " D ,HOUSE-DOOR " of the " D ,MAGICK-SHOPPE " is ">
		<COND (<FSET? ,SHOPPE-DOOR ,OPENBIT>
		       <TELL "wide open">)
		      (T
		       <TELL "closed">)>
		<TELL ". At the west end of the room, you can see another exit concealed by a " D ,CURTAIN "." CR>)>>

<OBJECT CLOCK
	(IN INSIDE-SHOPPE)
	(DESC "grandfather clock")
	(SYNONYM CLOCK MOON TIME DIAL)
	(ADJECTIVE GRANDFATHER)
	(FLAGS NDESCBIT TRYTAKEBIT CONTBIT TRANSBIT
	       LOCKEDBIT READBIT RMUNGBIT)
	(ACTION CLOCK-F)>

; "RMUNGBIT = clock running"

<GLOBAL FACES <LTABLE 0 "frown" "smil" "sneer" "grinn" "star">>

<ROUTINE CLOCK-F ()
	 <COND (<VERB? EXAMINE READ>
		<TELL "The " <PICK-ONE ,FACES> "ing " D ,CLOCK " ">
		<COND (<FSET? ,CLOCK ,RMUNGBIT>
		       <TELL "says it's ">)
		      (T
		       <TELL "is stopped at ">)>
		<TELL-TIME>
		<TELL "." CR>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE>
		<TELL "Inside the " D ,CLOCK
		      " you see an intricate brass mechanism." CR>
		<RTRUE>)
	       (<AND <VERB? LISTEN>
		     <FSET? ,CLOCK ,RMUNGBIT>>
		<SAY-THE ,CLOCK>
		<TELL " is ticking noisily." CR>
		<RTRUE>)
	       (<MOVING? ,CLOCK>
		<TOO-LARGE ,CLOCK>
		<RTRUE>)
	       (<OR <HURT? ,CLOCK>
		    <VERB? OPEN>>
		<RUIN ,CLOCK>
		<RTRUE>)
	       (T
		<RFALSE>)>>
		       
<ROUTINE RUIN (THING)
	 <TELL "You'd probably ruin the " D .THING>
	 <IF-YOU-TRIED>>

<OBJECT STOCK
	(IN INSIDE-SHOPPE)
	(DESC "magic tricks")
	(SYNONYM TRICK TRICKS PUZZLE PARAPH)
	(ADJECTIVE MAGIC MYSTIC)
	(FLAGS NDESCBIT NARTICLEBIT)
	(ACTION STOCK-F)>

<ROUTINE STOCK-F ()
	 <COND (<VERB? EXAMINE LOOK-ON LOOK-INSIDE READ>
		<TELL "They look like fun." CR>
		<RTRUE>)
	       (<TRY-HANDLING-STOCK>
		<RTRUE>)
	       (<VERB? BUY>
		<RFALSE>)
	       (T
		<YOU-DONT-NEED ,STOCK>
		<RFATAL>)>>

<OBJECT NAUGHTY-STOCK
	(IN GLASS-CASE)
	(DESC "naughty jokes")
	(SYNONYM JOKE JOKES CARD CARDS)
	(ADJECTIVE OBSCENE PRACTICAL NAUGHTY BIRTHDAY)
	(FLAGS READBIT NDESCBIT NARTICLEBIT)
	(ACTION NAUGHTY-STOCK-F)>

<ROUTINE NAUGHTY-STOCK-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE READ LOOK-ON>
		<TELL <PICK-ONE ,NAUGHTY-BITS> CR>
		<RTRUE>)
	       (<TRY-HANDLING-STOCK>
		<RTRUE>)
	       (<VERB? BUY>
		<RFALSE>)
	       (T
		<YOU-DONT-NEED ,NAUGHTY-STOCK>
		<RFATAL>)>>

<ROUTINE TRY-HANDLING-STOCK ()
	 <COND (<VERB? TAKE>
		<TELL D ,MACGUFFIN
" takes a dim view of shoplifters." CR>
		<RTRUE>)
	       (<OR <HURT? ,PRSO>
		    <VERB? STAND-ON POUR EMPTY>>
		<TELL 
"The proprietor of the " D ,MAGICK-SHOPPE>
		<MIGHT-NOT-LIKE>
	        <RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE MIGHT-NOT-LIKE ()
	 <TELL " might not like it">
	 <IF-YOU-TRIED>>

<OBJECT GLASS-CASE
	(IN INSIDE-SHOPPE)
	(DESC "glass case")
	(SYNONYM CASE)
	(ADJECTIVE GLASS)
	(FLAGS NDESCBIT CONTBIT DOORBIT TRANSBIT LOCKEDBIT)
	(CAPACITY 25)
	(ACTION GLASS-CASE-F)>

<ROUTINE GLASS-CASE-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "The naughty " D ,GLASS-CASE " is">
		<CLOSED-AND-LOCKED> 
		<RTRUE>)
	       (<VERB? LOOK-INSIDE LOOK-DOWN>
		<TELL <PICK-ONE ,NAUGHTY-BITS> CR>
		<RTRUE>)
	       (<TRY-HANDLING-STOCK>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT CURTAIN
	(IN INSIDE-SHOPPE)
	(DESC "curtain")
	(SYNONYM CURTAIN)
	(ADJECTIVE DARK)
	(FLAGS NDESCBIT)
	(ACTION CURTAIN-F)>

<ROUTINE CURTAIN-F ()
	 <COND (<VERB? THROUGH ENTER WALK-TO LOOK-INSIDE LOOK-BEHIND
		       OPEN CLOSE PUSH MOVE>
		<DO-WALK ,P?IN>
		<RTRUE>)
	       (<TRY-HANDLING-STOCK>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<GLOBAL NAUGHTY-BITS
        <LTABLE 0 
         "Can't keep your mind off that stuff, eh?"
	 "Tsk, tsk, tsk!"
	 "Intriguing, aren't they?">>
		       
<OBJECT ENVELOPE
	(DESC "mysterious envelope")
	(SYNONYM ENVELOPE MAIL LETTER)
	(ADJECTIVE MYSTERIOUS)
	(ACTION ENVELOPE-F)
	(FLAGS TAKEBIT READBIT CONTBIT)
	(VALUE 5)
	(SIZE 3)
	(CAPACITY 1)>

; "RMUNGBIT = envelope given by Crisp"

<GLOBAL WOMAN-SEEN-ENVELOPE? <>>

<ROUTINE ENVELOPE-F ()
	 <COND (<VERB? EXAMINE READ>
		<FIND-IN-PACKAGE "envelope">
		<RTRUE>)
	       (<HURT? ,ENVELOPE>
		<HOW-WOULD-YOU-LIKE-IT ,ENVELOPE>
		<RTRUE>)
	       (<VERB? OPEN>
		<COND (<DONT-HAVE? ,ENVELOPE>
		       <RTRUE>)
		      (,WOMAN-SEEN-ENVELOPE?
		       <SETG ANGER 4>
		       <MOVE ,ENVELOPE ,STEEP-TRAIL>
		       <MOVE ,OPEN-ENVELOPE ,PROTAGONIST>
		       <FSET ,OPEN-ENVELOPE ,TOUCHBIT>
		       <MOVE ,RANSOM-LETTER ,PROTAGONIST>
		       <SETG L-PRSO ,OPEN-ENVELOPE>
		       <SETG PRSO ,OPEN-ENVELOPE>
		       <THIS-IS-IT ,RANSOM-LETTER>
		       <TELL "(You should now open the " D ,ENVELOPE 
" in your " ,GAME " package.)|
|
Opening the " D ,ENVELOPE " reveals a letter.">)
		      (T
		       <TELL "(You're not supposed to open the " D ,ENVELOPE 
" until the story tells you to do so.)">)>
		<CRLF>
		<RTRUE>)
	       (<AND <VERB? TAKE>
		     <NOT <FSET? ,ENVELOPE ,TOUCHBIT>>>
		<SETG ANGER 4>
		<RFALSE>)
	       (T
		<RFALSE>)>>

<ROUTINE IVE-ALREADY-SEEN-IT ()
	 <TELL "\"I've already seen it.\"" CR>>

<OBJECT OPEN-ENVELOPE
	(DESC "mysterious envelope")
	(SYNONYM ENVELOPE)
	(ADJECTIVE MYSTERIOUS)
	(FLAGS TAKEBIT READBIT CONTBIT OPENBIT)
	(VALUE 0)
	(CAPACITY 1)
	(SIZE 5)
	(ACTION OPEN-ENVELOPE-F)>

<ROUTINE OPEN-ENVELOPE-F ()
	 <COND (<VERB? EXAMINE READ>
		<FIND-IN-PACKAGE "envelope">
		<RTRUE>)
	       (<HURT? ,OPEN-ENVELOPE>
		<HOW-WOULD-YOU-LIKE-IT ,ENVELOPE>
		<RTRUE>)
	       (<OR <AND <VERB? CLOSE>
		         <FSET? ,OPEN-ENVELOPE ,OPENBIT>>
		    <AND <VERB? PUT THROW>
			 <EQUAL? ,PRSI ,OPEN-ENVELOPE>>>
		<UNFORTUNATELY>
		<TELL "you ripped the " D ,ENVELOPE " when you opened it." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT RANSOM-LETTER
	; (IN OPEN-ENVELOPE)
	(DESC "letter")
	(SYNONYM LETTER MAIL)
	(ADJECTIVE RANSOM)
	(FLAGS TAKEBIT READBIT)
	(ACTION RANSOM-LETTER-F)
	(SIZE 1)
	(VALUE 0)>

<ROUTINE RANSOM-LETTER-F ()
	 <COND (<VERB? READ>
		; <COND (<AND <IN? ,RANSOM-LETTER ,OPEN-ENVELOPE>
		            <IN? ,OPEN-ENVELOPE ,PROTAGONIST>>
		       <MOVE ,RANSOM-LETTER ,PROTAGONIST>
		       <TELL "(taking the " D ,RANSOM-LETTER
			     " out of the " D ,OPEN-ENVELOPE " first)" CR>)>
		<COND (<DONT-HAVE? ,RANSOM-LETTER>
		       <RTRUE>)
		      (<IN? ,OLD-WOMAN ,HERE>
		       <TELL "(to the " D ,OLD-WOMAN ")" CR>
		       <READ-LETTER-TO-WOMAN>)
		      (T
		       <FIND-IN-PACKAGE "letter">)>
		<RFATAL>)
	       (<VERB? READ-TO>
		<COND (<EQUAL? ,PRSI ,OLD-WOMAN>
		       <READ-LETTER-TO-WOMAN>
		       <RFATAL>)
		      (<EQUAL? ,PRSI ,ME>
		       <FIND-IN-PACKAGE "letter">
		       <RFATAL>)
		      (T
		       <RFALSE>)>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,OLD-WOMAN>>
		<COND (,LETTER-READ-TO-WOMAN?
		       <READ-LETTER-TO-WOMAN>)
		      (T
		       <TELL "She politely refuses your offer." CR>)>
		<RFATAL>)
	       (<VERB? EXAMINE>
		<FIND-IN-PACKAGE "letter">
		<RFATAL>)
	       (<HURT? ,RANSOM-LETTER>
		<HOW-WOULD-YOU-LIKE-IT ,RANSOM-LETTER>
		<RFATAL>)
	       (T
		<RFALSE>)>>

<OBJECT SNAKE-CAN
        (DESC "metal can")
	(SYNONYM CAN NUTS LID)
	(ADJECTIVE METAL SMALL LITTLE TRINKET GIFT)
	(FLAGS TAKEBIT CONTBIT READBIT)
	(CAPACITY 1)
	(VALUE 3)
	(SIZE 3)
	(CONTFCN IN-CAN)
	(ACTION SNAKE-CAN-F)>

<ROUTINE IN-CAN (CONTEXT)
	 <COND (<AND <EQUAL? .CONTEXT ,M-CONT>
		     <NOT <IN? ,SNAKE-CAN ,PROTAGONIST>>
		     <NOT <SEE-VERB?>>
		     <NOT <EQUAL? ,PRSO ,CAN-BOTTOM>>>
		<YOUD-HAVE-TO "pick up" ,SNAKE-CAN>
		<RTRUE>)
	       (T
		<RFALSE>)>>
		
<SYNONYM NUTS NUT MIXED>

<OBJECT SQUASHED-CAN
	(DESC "squashed can")
	(SYNONYM CAN NUTS LID)
	(ADJECTIVE METAL SMALL FLAT SQUASH)
	(FLAGS TOUCHBIT TAKEBIT CONTBIT OPENBIT READBIT)
	(ACTION SQUASHED-CAN-F)
	(CAPACITY 1)
	(VALUE 0)
	(SIZE 3)>

<ROUTINE SNAKE-CAN-F ()
	 <COND (<AND ,BOTTOM?
		     <CAN-BOTTOM-F>>
		<RTRUE>)
	            
	       (<VERB? EXAMINE LOOK-ON READ>
		<TELL "It's a round " D ,SNAKE-CAN " with a">
		<OPEN-CLOSED ,SNAKE-CAN T>
	        <TELL 
"lid, illustrated with a tasty-looking assortment of mixed nuts."  CR>
		<RTRUE>)
	       
	       (<AND <VERB? OPEN TAKE-OFF>
		     <NOT <FSET? ,SNAKE-CAN ,OPENBIT>>>
		<COND (<DONT-HAVE? ,SNAKE-CAN>
		       <RTRUE>)
		      
		      (,SNAKE-GONE?
		       <NOW-CLOSED-OR-OPEN ,SNAKE-CAN T>)
		      
		      (T
		       <TELL "Yow! When you open">
		       <SNAKE-LEAPS-OUT-AT "you">
		       <COND (<AND ,SKEWED?
				   <EQUAL? ,HERE ,NORTH-OF-BRIDGE>
	                           <IN? ,TROLL ,NORTH-OF-BRIDGE>>
                              <CAN-FALLS>
			      <FRIGHTEN-TROLL>
			      <CRLF>
			      <UPDATE-SCORE 3>)>)>
		<RTRUE>)
	       
	       (<VERB? LISTEN SHAKE SPIN>
		<COND (<DONT-HAVE? ,SNAKE-CAN>
		       <RTRUE>)>
		<SAY-THE ,GCAN>
		<TELL
" rattles again. It sounds like there are nuts inside">
		<COND (<FSET? ,SNAKE-CAN ,OPENBIT>
		       <TELL ", although it seems to be empty">)>
		<TELL "." CR>
		<RTRUE>)
	       
	       (<VERB? READ>
		<READ-CAN>
		<RTRUE>)
	       
	       (<VERB? LOOK-INSIDE SEARCH LOOK-DOWN>
		<LOOK-IN-CAN>
		<RTRUE>)

	       (<AND <VERB? DROP>
		     <EQUAL? ,PRSO ,SNAKE-CAN>>
		<TELL "It hits the ">
		<GROUND-OR-FLOOR>
		<TELL " with a rattle">
		<AND-DROPS-OUT ,SNAKE-CAN>
		<COND (<EQUAL? ,HERE ,INSIDE-SHOPPE>
		       <MOVE ,SNAKE-CAN ,PROTAGONIST>
		       <CRLF>
		       <SAY-THE ,OLD-WOMAN>
		       <TELL " picks up the " D ,SNAKE-CAN " and hands it back to you. \"I think you dropped this.\"" CR>)>
		<RTRUE>)

	       (<VERB? SQUEEZE>
		<PERFORM ,V?SQUEEZE ,CAN-BOTTOM>
		<RTRUE>)
	       (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,SNAKE-CAN>
		     <IN? ,SNAKE-CAN ,OLD-WOMAN>>
		<COND (<V-TAKE>
		       <ENABLE <QUEUE I-RATTLE -1>>)>
		<RTRUE>)
		       
	       (T
		<RFALSE>)>>

<ROUTINE LOOK-IN-CAN ()
	 <COND (<NOT <IN? ,SNAKE-CAN ,PROTAGONIST>>
		<YOUD-HAVE-TO "be holding" ,SNAKE-CAN>)
	       (<FSET? ,SNAKE-CAN ,OPENBIT>
		<SAY-THE ,SNAKE-CAN>
		<TELL 
" appears to have a " D ,CAN-BOTTOM 
". You could probably get it out by squeezing the can." CR>)
	       (T
	        <ITS-CLOSED ,SNAKE-CAN>)>>

<ROUTINE SQUASHED-CAN-F ()
	 <COND (<AND <VERB? OPEN CLOSE EXAMINE LOOK-INSIDE
		            LOOK-DOWN SQUEEZE MUNG>
		     <EQUAL? ,PRSO ,SQUASHED-CAN>>
		<SAY-BOTTOM>
		<RTRUE>)
	       (<AND <VERB? PUT>
		     <EQUAL? ,PRSI ,GCAN>>
		<NO-ROOM>
		<SAY-BOTTOM>
		<RTRUE>)
	       (<VERB? READ>
		<READ-CAN>
		<RTRUE>)
	       (<VERB? LISTEN SHAKE SPIN>
		<COND (<DONT-HAVE? ,GCAN>
		       <RTRUE>)>
	        <SAY-THE ,GCAN>
		<TELL " makes no sound." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>
 
<ROUTINE READ-CAN ()
	 <SAY-THE ,GCAN>
	 <TELL " says, 'Mixed Nuts.'" CR>>

<GLOBAL GCAN SNAKE-CAN>

<OBJECT CAN-BOTTOM
	(IN SNAKE-CAN)
	(DESC "false bottom")
	(SYNONYM BOTTOM)
	(ADJECTIVE FALSE)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION CAN-BOTTOM-F)>

<ROUTINE CAN-BOTTOM-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE>
		<LOOK-IN-CAN>
		<RTRUE>)
	       (<AND <VERB? OPEN SQUEEZE MOVE PULL PUSH TAKE-OFF>
		     <EQUAL? ,PRSO ,CAN-BOTTOM ,GCAN>>
		<COND (<DONT-HAVE? ,GCAN>
		       <RTRUE>)
		      (<NOT <FSET? ,SNAKE-CAN ,OPENBIT>>
		       <YOUD-HAVE-TO "open" ,SNAKE-CAN>
		       <RTRUE>)
		      (<NOT <IN? ,CAN-BOTTOM ,SQUASHED-CAN>>
		       <MOVE ,SQUASHED-CAN ,PROTAGONIST>
		       <REMOVE ,SNAKE-CAN>
		       <SETG GCAN ,SQUASHED-CAN>
		       <DISABLE <INT I-RATTLE>>
		       <ENABLE <QUEUE I-GLOW -1>>
		       <MOVE ,WISHBRINGER ,PROTAGONIST>
		       <THIS-IS-IT ,WISHBRINGER>
		       <SAY-THE ,CAN-BOTTOM>
		       <TELL
" is wedged tightly into the " D ,SNAKE-CAN ". You might be able to loosen it by squeezing harder... harder!...|
|
Pop! A " D ,WISHBRINGER " drops out of the " D ,SQUASHED-CAN>
		       <AND-DROPS-OUT ,WISHBRINGER>)
		      (T
		       <SAY-BOTTOM>)>
		<RTRUE>)
	       (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,CAN-BOTTOM ,GCAN>
		     ,PRSI>
		<COND (<DONT-HAVE? ,GCAN>
		       <RTRUE>)>
		<HOW?>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE SAY-BOTTOM ()
	 <TELL "You squashed the " D ,SNAKE-CAN " flat when you removed the "
	       D ,CAN-BOTTOM "." CR>>

<ROUTINE I-RATTLE ()
	 <COND (<AND <IN? ,SNAKE-CAN ,PROTAGONIST>
		     <PROB 5>>
		<TELL CR <PICK-ONE ,GIVE-AWAYS> "." CR>)>>
		
<GLOBAL GIVE-AWAYS
	<LTABLE 0
	 "The can rattles in your hand"
	 "Something rattles in the can"
	 "You hear a rattling noise in the can">>

<GLOBAL ENDING? <>>

<ROUTINE TO-FINISH ()
	 <SETG ENDING? T>
         <SETG FUZZY? <>>
	 <SETG FUZZY-FROM ,CLIFF-EDGE>
	 <DISABLE <INT I-GLOW>>
	 <FCLEAR ,WISHBRINGER ,ONBIT>
	 <COND (<ENABLED? ,I-DRINK>
		<SETG MILK-SCRIPT 1>)>
	 <COND (<ENABLED? ,I-DIGEST-CHOCOLATE>
		<SETG CHOCOLATE-SCRIPT 1>)>
	 <DISABLE <INT I-VULTURE>>
	 <SETG WOMAN-SCRIPT 0>
	 <ENABLE <QUEUE I-FINALE -1>>
	 <FSET ,MAGICK-SHOPPE ,TOUCHBIT>
	 <DISABLE <INT I-BEFORE-MOONSET>>
	 <SETG HERE ,CLIFF-EDGE>
	 <MOVE ,PROTAGONIST ,CLIFF-EDGE>
	 <CARRIAGE-RETURNS>>

<OBJECT CHAOS
	(DESC "Chaos")
	(SYNONYM CHAOS CAT KITTY PUSSY)
	(ADJECTIVE BLACK)
	(FLAGS NDESCBIT ACTORBIT NARTICLEBIT TAKEBIT)
	(SIZE 10)
	(VALUE 0)
	(ACTION CHAOS-F)>

<ROUTINE CHAOS-F ("OPTIONAL" (CONTEXT <>))
	 <THIS-IS-IT ,CHAOS>
	 <COND (<VERB? EXAMINE>
		<DESCRIBE-CHAOS T>
		<TELL " right in the middle of her forehead." CR>
		<RTRUE>)
	       (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,CHAOS>>
		<COND (<V-TAKE>
		       <CRLF>
		       <PERFORM ,V?LISTEN ,CHAOS>)>
		<RTRUE>)
	       (<VERB? LISTEN RUB KISS>
		<NICE-KITTY>
		<RTRUE>)
	       (<TALKING-TO? ,CHAOS>
		<NICE-KITTY>
		<RFATAL>)
	       (<HURT? ,CHAOS>
		<V-RAPE>
		<RTRUE>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,CHAOS>>
		<COND (<EQUAL? ,PRSO ,CHAOS>
		       <TELL <PICK-ONE ,YUKS> CR>)
		      (<EQUAL? ,PRSO ,MILK>
		       <READY-MILK>
		       <GIVE-MILK-TO-CAT ,CHAOS>)
		      (T
		       <NOT-LIKELY ,KITTY "is interested">)>
		<RTRUE>)
	       (T
		<RFALSE>)>>
		
<ROUTINE NICE-KITTY ()
	 <SAY-THE ,KITTY>
	 <TELL " " <PICK-ONE ,NICES> "." CR>>

<ROUTINE DESCRIBE-CHAOS ("OPTIONAL" (SPOT? <>))
	 <TELL "She's black as night from head to tail">
	 <COND (.SPOT?
		<TELL ", except for one little white spot">)>>

<GLOBAL SUCCESS? <>>

<ROUTINE I-FINALE ()
	 <COND (<EQUAL? ,HERE ,CLIFF-EDGE>
		<SETG WOMAN-SCRIPT <+ ,WOMAN-SCRIPT 1>>
		
		<COND (<EQUAL? ,WOMAN-SCRIPT 1>
		       <COND (,SUCCESS?
			      <THIS-IS-IT ,CHAOS>
			      <TELL CR "A " D ,KITTY
" is rubbing against your leg." CR>)
			     (T
			      <SETG WOMAN-SCRIPT 5>)>
		       <RTRUE>)>
		
		<COND (<AND ,SUCCESS?
			    <EQUAL? ,WOMAN-SCRIPT 3>
			    <ACCESSIBLE? ,CHAOS>>
		       <THIS-IS-IT ,CHAOS>
		       <CRLF>
		       <SAY-THE ,KITTY>
		       <COND (<IN? ,CHAOS ,PROTAGONIST>
			      <MOVE ,CHAOS ,CLIFF-EDGE>
			      <TELL " leaps from your arms and">)>
		       <TELL " begins scratching urgently on the " 
                             D ,SHOPPE-DOOR "." CR>)
		      
	       	      (<EQUAL? ,WOMAN-SCRIPT 6>
		       <THIS-IS-IT ,OLD-WOMAN>
		       <FSET ,SHOPPE-DOOR ,OPENBIT>
		       <TELL CR "The door of the " D ,MAGICK-SHOPPE " creaks open, and the " D ,OLD-WOMAN ", dressed in a nightgown, ">
		       
		       <COND (,SUCCESS?
			      <TELL "stands blinking in the morning sun.">)
			     (T
			      <TELL "peers sleepily">
			      <INTO-NIGHT>)>
		       <TELL " \"Who's there?\"" CR CR>
		       
		       <COND (<AND ,SUCCESS?
				   <ACCESSIBLE? ,CHAOS>>
			      <SAY-THE ,KITTY>
			      <COND (<IN? ,CHAOS ,PROTAGONIST>
				     <TELL " squirms away from you and">)>
			      <TELL
" leaps into the woman's arms. \"" D ,CHAOS "!\" she cries, laughing and sobbing all at once as the cat licks tears of joy from her face.|
|
At last the " D ,OLD-WOMAN " lowers " D ,CHAOS " to the " D ,GROUND " and walks over to where you're standing, red with embarrassment." CR CR>
			      <LIAR>
			      <TELL ",\" she chuckles, clasping " D ,HANDS 
"s gratefully in her own. \"I promised to give you " ,GAME ", knowing full well that, if you succeeded, its virtue would be lost.|
|
\"In truth, the Stone would make a poor reward,\" she continues, stooping to tickle the cat's white forehead. \"As you can see, it brings more joy in the shape of a companion than in any other. This is " ,GAME "'s finest Magick. A pity that my sister," ,EONE ", did not know of it.\"" CR CR>
			      <COND (,HOUSE-VISITED?
				     <TELL ,YOU-HEAR "a familiar">
				     <CLUMP>
				     <TELL "behind you. It's the "
D ,SMALL-BOX ", hopping bravely up the steep " D ,TRAIL "! The woman looks on with puzzled amusement as the faithful box">
				     <HOPS-TO-SIDE>
				     <CRLF>
				     <CRLF>)>
			      <SAY-THE ,OLD-WOMAN>
			      <COND (<IN? ,VIOLET-NOTE ,PROTAGONIST>
				     <TELL " touches the " D ,VIOLET-NOTE
					   " in " D ,HANDS>)
				    (T
				     <COND (<IN? ,VIOLET-NOTE ,HERE>
					    <TELL " picks up the "
						  D ,VIOLET-NOTE>)
					   (T
					    <TELL " pulls " D ,MISS-VOSS "'s " 
D ,VIOLET-NOTE " from an obscure pocket">)>
				     <TELL " and hands it to you">)>
			      <TELL ". \"Make sure you give this to " D ,CRISP
" when you see him,\" she says with a sly wink. \"And tell him I said hello.\"|
|
Cradling " D ,CHAOS " in her arms like a child, the " D ,OLD-WOMAN 
" ambles back into the " D ,MAGICK-SHOPPE ". \"Farewell!\" she calls from the closing door, and the sunlight makes her face look young. \"Now you are a true Adventurer.\"" CR CR>
			      <BELL-TINKLES>
			      <MOVE ,PROTAGONIST ,END-ROOM>
			      <SETG HERE ,END-ROOM>
			      <CARRIAGE-RETURNS>
			      <TELL
"Congratulations! You've finished the story of " ,GAME "!" CR CR>
			      <V-SCORE>
			      <COND (<NOT <ZERO? ,SPELLS>>
				     <TELL CR
"Did you know that it's possible to complete the story without using any of the 7 Wishes? It's fun to go back and see if you can solve all of the problems without Wishing." CR>)>
			      <FINISH T>)
			     
			     ; "Unsuccessful endings"

			     (T
			      <COND (<VISIBLE? ,KITTY>
				     <TELL "A look of joy spreads over the " 
D ,OLD-WOMAN "'s face when she sees the " D ,KITTY>
				     <COND (<IN? ,KITTY ,PROTAGONIST>
					    <TELL " in your arms">)
					   (T
					    <TELL " playing at your feet">)>
				     <TELL
". \"Here, " D ,CHAOS "! Come to mama!\"|
|
But the cat pays no attention. Frowning, the woman walks over and peers at it closely. \"This isn't " D ,CHAOS ",\" she says, her voice now heavy with sadness. \"You did not heed me when I described her to you. See? There's no white spot on her forehead, as I said there would be. You should have examined her before you returned here!\"">)
				    
				    (T  ; "Return with no KITTY"
				     <TELL
"A hopeful look brightens the " D ,OLD-WOMAN "'s face as she sees you. \"Did you find my cat, " D ,CHAOS "?\" she cries hopefully. But the guilty look in your eyes turns her brief joy to sadness.|
|
\"You have failed, then,\" she sighs. \"">
				     <THANKS-ANYWAY>)>
			      
			      <BAD-ENDING>)>)>)>>
			      
<ROUTINE THANKS-ANYWAY ()
	 <TELL "Too bad. I should not have placed my hopes upon a simpleton. But thank you for your useless effort.\"">>
 
<OBJECT END-ROOM
	(IN ROOMS)
	(DESC "End of Story")
	(FLAGS ONBIT RLANDBIT)>

