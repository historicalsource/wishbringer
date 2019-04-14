"TOWER for WISHBRINGER: (C)1985 Infocom, Inc. All rights reserved."

<OBJECT TOWER
	(IN LOCAL-GLOBALS)
	(DESC "tower")
	(SYNONYM TOWER)
	(FLAGS NDESCBIT)
	(ACTION TOWER-F)>

<ROUTINE TOWER-F ()
	 <COND (<OR <NOT ,SKEWED?>
		    ,SUCCESS?>
		<CANT-SEE-ANY ,TOWER>
		<RFATAL>)
	       (<OR <ENTER-FROM? ,HILLTOP>
		    <ENTER-FROM? ,VESTIBULE ,ROUND-CHAMBER ,TOWER>>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<COND (<IN-TOWER?>
		       <V-LOOK>)
		      (T
		       <TELL "Its lonely outline fills you with dread." CR>)>
		<RTRUE>)
		       
	       (<VERB? LOOK-INSIDE>
		<COND (<IN-TOWER?>
		       <V-LOOK>
		       <RTRUE>)>
		<COND (<EQUAL? ,HERE ,HILLTOP>
		       <COND (<FSET? ,DRAWBRIDGE ,OPENBIT>
			      <GO-INSIDE>)
			     (T
			      <ITS-CLOSED ,DRAWBRIDGE>)>)
		      (T
		       <TELL ,CANT ". ">
		       <TOO-FAR-AWAY ,TOWER>)>
		<RTRUE>)
		       
	       (<VERB? LOOK-UNDER LOOK-BEHIND LOOK-UNDER LOOK-DOWN>
		<HOW?>
		<RTRUE>)
	       
	       (<VERB? CLIMB-ON CLIMB-UP>
		<COND (<IN-TOWER?>				   
		       <DO-WALK ,P?UP>)
		      (T
		       <HOW?>)>
		<RTRUE>)
	       
	       (<VERB? EXIT>
		<COND (<IN-TOWER?>
		       <DO-WALK ,P?OUT>)
		      (T
		       <GET-IN-FIRST>)>
		<RTRUE>)
	       
	       (<VERB? CLIMB-DOWN>
		<COND (<IN-TOWER?>
		       <DO-WALK ,P?DOWN>)
		      (T
		       <HOW?>)>
		<RTRUE>)
	       
	       (<AND <VERB? THROW>
		     <EQUAL? ,PRSI ,TOWER>>
		<PERFORM ,V?PUT ,PRSO ,MOAT>
		<RTRUE>)
	       
	       (<AND <TOUCHING? ,TOWER>
		     <NOT <IN-TOWER?>>>
		<TOO-FAR-AWAY ,TOWER>
		<RTRUE>)
	       
	       (T
		<RFALSE>)>>

<ROUTINE IN-TOWER? ()
	 <COND (<OR <EQUAL? ,HERE
			    ,ROUND-CHAMBER
			    ,TORTURE-CHAMBER
			    ,VESTIBULE>
		    <EQUAL? ,HERE ,LABORATORY>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE GET-IN-FIRST ()
	 <TELL "(You'll have to get inside the " D ,TOWER " first.)" CR>>

<OBJECT DRAWBRIDGE
	(IN LOCAL-GLOBALS)
	(DESC "drawbridge")
	(SYNONYM DRAWBRIDGE BRIDGE WALKWAY)
	(FLAGS NDESCBIT DOORBIT)
	(ACTION DRAWBRIDGE-F)>

; "RMUNGBIT = magic spell used"

<ROUTINE DRAWBRIDGE-F ("AUX" (BOPEN? <>))
	 <COND (<NOT ,SKEWED?>
		<CANT-SEE-ANY ,DRAWBRIDGE>
		<RFATAL>)
	       (<FSET? ,DRAWBRIDGE ,OPENBIT>
		<SET BOPEN? T>)>
	 <THIS-IS-IT ,DRAWBRIDGE>
	 <COND (<VERB? EXAMINE>
		<SAY-THE ,DRAWBRIDGE>
		<TELL " is ">
		<COND (.BOPEN?
		       <TELL 
"open, providing a walkway across the moat and into">)
		      (T
		       <TELL "closed against the wall of">)>
		<TELL " the " D ,TOWER "." CR>
		<RTRUE>)
	       (<VERB? OPEN LOWER>
		<COND (.BOPEN?
		       <ITS-ALREADY "lowered">)
		      (T
		       <HIDDEN-MECH>)>
		<RTRUE>)
	       (<VERB? CLOSE RAISE>
		<COND (.BOPEN?
		       <HIDDEN-MECH>)
		      (T
		       <ITS-ALREADY "raised">)>
		<RTRUE>)
	       (<VERB? WALK-TO CROSS WALK-AROUND ENTER THROUGH
		       EXIT CLIMB-ON>
		<COND (<EQUAL? ,HERE ,HILLTOP>
		       <DO-WALK ,P?IN>)
		      (T
		       <DO-WALK ,P?OUT>)>
		<RTRUE>)
	       (<VERB? SIT STAND-ON LIE-DOWN>
		<COND (.BOPEN?
		       <WASTE-OF-TIME>)
		      (T
		       <ITS-CLOSED ,DRAWBRIDGE>)>
		<RTRUE>) 
	     ; (<VERB? PUSH MOVE>
		<HIDDEN-MECH>
		<RTRUE>)
	       (<AND <TOUCHING? ,DRAWBRIDGE>
		     <EQUAL? ,HERE ,HILLTOP>
		     <NOT .BOPEN?>>
		<TOO-FAR-AWAY ,DRAWBRIDGE>
		<RTRUE>)
	       (<AND <VERB? LOOK-UNDER>
		     <EQUAL? ,HERE ,HILLTOP>>
		<PERFORM ,V?EXAMINE ,MOAT>
		<RTRUE>)
	       (<AND <VERB? THROW>
		     <EQUAL? ,PRSI ,DRAWBRIDGE>>
		<PERFORM ,V?PUT ,PRSO ,MOAT>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE HIDDEN-MECH ()
	 <TELL ,CANT ". The mechanism that controls the "
	       D ,DRAWBRIDGE " is">
	 <COND (<IN? ,CRANK ,ROUND-CHAMBER>
		<TELL "n't here">)
	       (T
		<TELL " hidden">)>
	 <TELL "." CR>>

<OBJECT MOAT
	(DESC "moat")
	(SYNONYM MOAT WATER)
	(ADJECTIVE DEEP)
	(FLAGS NDESCBIT CONTBIT OPENBIT TRANSBIT)
	(CAPACITY 200)
	(ACTION MOAT-F)>

<ROUTINE MOAT-F ()
	 <COND (<VERB? EXAMINE>
		<SAY-THE ,MOAT>
		<TELL 
" is 20 feet wide and filled with black, oily water." CR>
		<RTRUE>)
	       (<VERB? CROSS>
		<PERFORM ,V?CROSS ,DRAWBRIDGE>
		<RTRUE>)
	       (<HANDLE-WATER?>
		<RTRUE>)
	       (T
		<RFALSE>)>>
		
"*** ROUND CHAMBER ***"

<OBJECT STAIRWAY
	(IN LOCAL-GLOBALS)
	(DESC "stairway")
	(SYNONYM STAIRWAY STAIRS STAIR STEPS)
	(ADJECTIVE DAMP)
	(FLAGS NDESCBIT SURFACEBIT)
	(CAPACITY 100)
	(ACTION STAIRWAY-F)>

<ROUTINE STAIRWAY-F ()
	 <COND (<VERB? CLIMB-ON CLIMB-UP>
		<COND (<EQUAL? ,HERE ,ROUND-CHAMBER>
		       <DO-WALK ,P?UP>)
		      (T
		       <ALREADY-AT ,STAIRWAY T>)>
		<RTRUE>)
	       (<VERB? CLIMB-DOWN>
		<COND (<EQUAL? ,HERE ,LABORATORY>
		       <DO-WALK ,P?DOWN>)
		      (T
		       <ALREADY-AT ,STAIRWAY>)>
		<RTRUE>)
	       (<AND <VERB? PUT PUT-ON THROW>
		     <EQUAL? ,PRSI ,STAIRWAY>>
		<TELL "Don't leave ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO 
" on the " D ,STAIRWAY "! Somebody might trip on it and get hurt." CR>
		<RTRUE>)
	       
	       (<VERB? OPEN CLOSE>
		<TELL <PICK-ONE ,YUKS> CR>
		<RTRUE>)
	       (<VERB? SIT STAND-ON LIE-DOWN>
		<LOITERING-ON ,STAIRWAY>
		<RTRUE>)
	       (<VERB? EXAMINE LOOK-DOWN>
		<TELL "The damp, narrow " D ,STAIRWAY " circles ">
		<COND (<EQUAL? ,HERE ,ROUND-CHAMBER>
		       <TELL "up">)
		      (T
		       <TELL "down">)>
		<TELL "ward into the " D ,TOWER "." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT ROUND-CHAMBER
	(IN ROOMS)
	(DESC "Round Chamber")
	(GLOBAL TOWER CORRIDOR STAIRWAY HATCH LADDER)
	(FLAGS ONBIT RLANDBIT INDOORSBIT NARTICLEBIT)
	(NORTH TO VESTIBULE)
	(UP PER ENTER-LAB)
	(DOWN PER DOWN-LADDER?)
        (OUT TO VESTIBULE)
	(ACTION ROUND-CHAMBER-F)
	(PSEUDO "CHAMBER" HERE-F)>

<ROUTINE ROUND-CHAMBER-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL 
"You're in a round chamber at the very heart of the " D ,TOWER ". The clammy stone walls are hung with a " D ,ART ", all the same size and identically framed. Years of neglect have blackened the art almost beyond recognition.">
		<COND (<IN? ,CRANK ,ROUND-CHAMBER>
		       <MENTION-CRANK>)>
		<TELL CR CR "In the " D ,CORNER " is a">
		<OPEN-CLOSED ,HATCH T>
		<TELL D ,HATCH ".">
		<COND (<FSET? ,HATCH ,OPENBIT>
		       <TELL 
" Peering downward, you see a " D ,LADDER " descending into gloom.">)>
		<TELL CR CR
"A " D ,CORRIDOR " disappears " <TO-N> ", and a damp " D ,STAIRWAY " winds upward into the " D ,TOWER "." CR>)>>

<ROUTINE ENTER-LAB ()
	 <SETG FUZZY-FROM ,LABORATORY>
	 <SETG FUZZY? T>
	 <RETURN ,FUZZY>>

<ROUTINE DOWN-LADDER? ()
	 <COND (<NOT <FSET? ,HATCH ,OPENBIT>>
		<ITS-CLOSED ,HATCH>
		<RFALSE>)
	       (T
		<COND (,CLAMPED?
		       <FCLEAR ,TORTURE-CHAMBER ,TOUCHBIT>
		       <TELL 
"\"Saved at last!\" mews a familiar voice as you descend." CR CR>)>
		<RETURN ,TORTURE-CHAMBER>)>>

<OBJECT ART
	(IN ROUND-CHAMBER)
	(DESC "series of paintings")
	(SYNONYM PAINTING PICTUR SERIES SEQUENCE)
	(ADJECTIVE ART PRINCESS QUEEN)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION ART-F)>

<ROUTINE ART-F ()
	 <COND (<VERB? EXAMINE>
		<COUNT-ART>
		<TELL " It seems to be a tragic sequence involving a beautiful princess and a wicked queen.">
		<COND (<IN? ,CRANK ,ROUND-CHAMBER>
		       <MENTION-CRANK>)>
		<CRLF>
		<RTRUE>)
	       (<VERB? LOOK-BEHIND LOOK-UNDER>
		<COND (<IN? ,CRANK ,ROUND-CHAMBER>
		       <THIS-IS-IT ,CRANK>
		       <TELL "Aside from the " D ,CRANK
			     ", you see nothing " <PICK-ONE ,YAWNS> "." CR>)
		      (T
		       <SHOW-CRANK>)>
		<RTRUE>)
	       (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,ART>>
		<TELL ,CANT " take the " D ,ART "." CR>
		<RTRUE>)
	       (<MOVING? ,ART>
		<COND (<IN? ,CRANK ,ROUND-CHAMBER>
		       <HACK-HACK "Further meddling with">)
		      (T
		       <SHOW-CRANK>)>
		<RTRUE>)
	       (<HURT? ,ART>
		<SAY-THE ,ART>
		<TELL " is already in pretty bad shape." CR>
		<RTRUE>)
	       (<VERB? COUNT>
		<COUNT-ART>
		<CRLF>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE COUNT-ART ()
	 <TELL "There are 13 paintings in the series.">>

<ROUTINE SHOW-CRANK ()
	 <MOVE ,CRANK ,ROUND-CHAMBER>
	 <THIS-IS-IT ,CRANK>
	 <TELL "Moving aside one of the paintings reveals">
	 <SAY-CRANK>
	 <CRLF>>

<ROUTINE MENTION-CRANK ()
	 <TELL " One of the paintings has been moved to reveal">
	 <SAY-CRANK>>

<ROUTINE SAY-CRANK ()
	 <TELL " a " D ,CRANK " attached to the wall.">>

<OBJECT CRANK
	(DESC "metal crank")
	(SYNONYM CRANK)
	(ADJECTIVE METAL)
	(FLAGS TRYTAKEBIT NDESCBIT RMUNGBIT)
	(ACTION CRANK-F)>

; "RMUNGBIT = crank not yet turned"

<ROUTINE CRANK-F ()
	 <COND (<AND <VERB? TURN SPIN USE>
		     <EQUAL? ,PRSO ,CRANK>>
		<TELL "As you turn the " D ,CRANK " you ">
		<HEAR-BRIDGE>
		<COND (<FSET? ,CRANK ,RMUNGBIT>
		       <FCLEAR ,CRANK ,RMUNGBIT>
		       <CRLF>
		       <UPDATE-SCORE 1>)>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<FIRMLY-ATTACHED>
		<RTRUE>)
	       (<OR <HURT? ,CRANK>
		    <VERB? PULL PUSH>>
		<FIRMLY-ATTACHED T>
		<RTRUE>)
	       (T
		<RFALSE>)>>
		      
<ROUTINE FIRMLY-ATTACHED ("OPTIONAL" (STILL? <>))
	 <SAY-THE ,CRANK>
	 <TELL " is">
	 <COND (.STILL?
		<TELL " still">)>
	 <TELL " firmly attached to the wall." CR>>

<ROUTINE HEAR-BRIDGE ()
	 <FCLEAR ,VESTIBULE ,TOUCHBIT>
	 <TELL "hear the distant rattle of the " D ,DRAWBRIDGE>
	 <COND (<FSET? ,DRAWBRIDGE ,OPENBIT>
		<FCLEAR ,DRAWBRIDGE ,OPENBIT>
		<TELL " closing">)
	       (T
		<FSET ,DRAWBRIDGE ,OPENBIT>
		<TELL " opening">)>
	 <TELL "." CR>>

"*** VESTIBULE ***"

<OBJECT CORRIDOR
	(IN LOCAL-GLOBALS)
	(DESC "corridor")
	(SYNONYM HALL HALLWAY CORRIDOR ENTRANCE)
	(ADJECTIVE SHORT DARK)
	(FLAGS NDESCBIT)
	(ACTION CORRIDOR-F)>

<ROUTINE CORRIDOR-F ()
	 <COND (<VERB? FOLLOW WALK-TO ENTER THROUGH USE EXIT>
		<COND (<EQUAL? ,HERE ,LOBBY ,VESTIBULE>
		       <DO-WALK ,P?IN>)
		      (T
		       <DO-WALK ,P?OUT>)>)
	       (<VERB? EXAMINE LOOK-INSIDE LOOK-DOWN>
		<SAY-THE ,CORRIDOR>
		<TELL " leads ">
		<COND (<EQUAL? ,HERE ,LOBBY ,VESTIBULE>
		       <TELL "in">)
		      (T
		       <TELL "out">)>
		<TELL "side." CR>)
	       (<VERB? LISTEN>
		<PERFORM ,V?LISTEN ,SOUND>)
	       (T
		<YOU-DONT-NEED ,CORRIDOR>
		<RFATAL>)>
	 <RTRUE>>

<OBJECT VESTIBULE
	(IN ROOMS)
	(DESC "Vestibule")
	(GLOBAL TOWER DRAWBRIDGE CORRIDOR)
	(NORTH PER EXIT-TOWER?)
	(SOUTH PER INTO-ROUND-CHAMBER)
	(IN PER INTO-ROUND-CHAMBER)
	(OUT PER EXIT-TOWER?)
	(FLAGS ONBIT RLANDBIT INDOORSBIT WETBIT)
	(ACTION VESTIBULE-F)
	(PSEUDO "VESTIBULE" HERE-F)>

<ROUTINE EXIT-TOWER? ()
	 <COND (<ESCAPING-CRISP?>
		<RFALSE>)
	       (<FSET? ,DRAWBRIDGE ,OPENBIT>
		<ENABLE <QUEUE I-SLAM-BRIDGE -1>>
		<RETURN ,HILLTOP>)
	       (T
		<ITS-CLOSED ,DRAWBRIDGE>
		<RFALSE>)>>

<ROUTINE I-SLAM-BRIDGE ()
	 <DISABLE <INT I-SLAM-BRIDGE>>
	 <FCLEAR ,DRAWBRIDGE ,OPENBIT>
	 <START-BUZZ 6>
       ; <MOVE ,SCOPE ,HILLTOP>
	 <TELL CR "The moment you take your foot off the " D ,DRAWBRIDGE
" it swings up over the " D ,MOAT " and closes with a mighty thud." CR>>

<ROUTINE ESCAPING-CRISP? ()
	 <COND (<ENABLED? ,I-CRISP-CAPTURE>
		<TELL "Uh-oh! Somebody's closing the " D ,DRAWBRIDGE "!" CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE INTO-ROUND-CHAMBER ()
	 <COND (<ESCAPING-CRISP?>
		<RFALSE>)
	       (T
		<RETURN ,ROUND-CHAMBER>)>>

<ROUTINE VESTIBULE-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<STANDING>
		<TELL  
"in a dimly-lit vestibule just inside the " D ,TOWER "'s " D ,ENTRANCE ". ">
		<SAY-THE ,DRAWBRIDGE>
		<TELL " is ">
		<COND (<FSET? ,DRAWBRIDGE ,OPENBIT>
		       <TELL "opened across the moat " <TO-N> >)
		      (T
		       <TELL "closed against the north wall">)>
		<TELL 
". A short " D ,CORRIDOR " leads south, into the " D ,TOWER "." CR>)>>
		       
"*** TORTURE CHAMBER ***"

<ROUTINE CHAIN-PROOF? (OBJ)
	 <COND (<OR <NOT ,CHAINED?>
		    <TALKING-TO? .OBJ>
		    <VERB? EXAMINE LOOK-UNDER LOOK-THRU LOOK-INSIDE LOOK-ON
			   LOOK-DOWN LOOK-BEHIND LISTEN READ YELL>>
		<RFALSE>)
	       (T
	   	<TELL ,CANT " reach ">
		<ARTICLE .OBJ T>
		<PRINTD .OBJ>
		<WHILE-CHAINED>
		<RTRUE>)>>

<ROUTINE WHILE-CHAINED ()
	 <TELL " while you're chained up." CR>>

<OBJECT HATCH
	(IN LOCAL-GLOBALS)
	(DESC "hatch")
	(SYNONYM HATCH HATCHWAY DOOR)
	(ADJECTIVE MASSIVE OAK)
	(FLAGS NDESCBIT DOORBIT OPENBIT)
	(ACTION HATCH-F)>

<ROUTINE HATCH-F ("AUX" OPEN?)
	 <THIS-IS-IT ,HATCH>
	 <SET OPEN? <FSET? ,HATCH ,OPENBIT>>
	 <COND (<CHAIN-PROOF? ,HATCH>
		<RTRUE>)
	       (<VERB? EXAMINE LOOK-INSIDE>
		<COND (.OPEN?
		       <SAY-THE ,HATCH>
		       <TELL " leads ">
		       <COND (<EQUAL? ,HERE ,ROUND-CHAMBER>
			      <TELL "downward into gloom">)
			     (T
			      <TELL "up into the " D ,TOWER>)>
		       <TELL "." CR>)
		      (T
		       <ITS-CLOSED ,HATCH>)>
		<RTRUE>)
	       (<VERB? OPEN RAISE>
		<COND (.OPEN?
		       <ALREADY-OPEN>)
		      (T
		       <FSET ,HATCH ,OPENBIT>
		       <TELL "The heavy " D ,HATCH " opens reluctantly." CR>)>
		<RTRUE>)
	       (<VERB? CLOSE LOWER>
		<COND (.OPEN?
		       <FCLEAR ,HATCH ,OPENBIT>
		       <SAY-THE ,HATCH>
		       <TELL " closes with a heavy thud." CR>)
		      (T
		       <ALREADY-CLOSED>)>
		<RTRUE>)
	       (<VERB? PUSH>
		<COND (<EQUAL? ,HERE ,ROUND-CHAMBER>
		       <PERFORM ,V?CLOSE ,HATCH>)
		      (T
		       <PERFORM ,V?OPEN ,HATCH>)>
		<RTRUE>)
	       (<VERB? MOVE PULL>
		<COND (<EQUAL? ,HERE ,TORTURE-CHAMBER>
		       <PERFORM ,V?CLOSE ,HATCH>)
		      (T
		       <PERFORM ,V?OPEN ,HATCH>)>
		<RTRUE>)
	       (<VERB? ENTER THROUGH WALK-TO>
		<COND (<EQUAL? ,HERE ,ROUND-CHAMBER>
		       <DO-WALK ,P?DOWN>)
		      (T
		       <DO-WALK ,P?UP>)>
		<RTRUE>)
	       (<VERB? CLIMB-DOWN>
		<DO-WALK ,P?DOWN>
		<RTRUE>)
	       (<VERB? CLIMB-UP>
		<DO-WALK ,P?UP>
		<RTRUE>)
	       (T
		<RFALSE>)>>
		
<OBJECT LADDER
	(IN LOCAL-GLOBALS)
	(DESC "ladder")
	(SYNONYM LADDER)
	(ADJECTIVE WOOD WOODEN)
	(FLAGS NDESCBIT)
	(ACTION LADDER-F)>

<ROUTINE LADDER-F ()
	 <COND (<AND <NOT <FSET? ,HATCH ,OPENBIT>>
		     <EQUAL? ,HERE ,ROUND-CHAMBER>>
		<CANT-SEE-ANY ,LADDER>
		<RFATAL>)
	       (<VERB? CLIMB-ON USE>
		<COND (<FSET? ,HATCH ,OPENBIT>
		       <COND (<EQUAL? ,HERE ,TORTURE-CHAMBER>
			      <DO-WALK ,P?UP>)
			     (T
			      <DO-WALK ,P?DOWN>)>)
		      (T
		       <ITS-CLOSED ,HATCH>)>
		<RTRUE>)
	       (<VERB? CLIMB-DOWN>
		<COND (<EQUAL? ,HERE ,ROUND-CHAMBER>
		       <DO-WALK ,P?DOWN>)
		      (T
		       <ALREADY-AT ,LADDER>)>
		<RTRUE>)
	       (<VERB? CLIMB-UP>
		<COND (<EQUAL? ,HERE ,TORTURE-CHAMBER>
		       <PERFORM ,V?CLIMB-ON ,LADDER>)
		      (T
		       <ALREADY-AT ,LADDER T>)>
		<RTRUE>)
	       (<VERB? SIT STAND-ON LIE-DOWN>
		<LOITERING-ON ,LADDER>
		<RTRUE>)
	       (<VERB? THROUGH>
		<COND (<NOT <EQUAL? ,HERE ,TORTURE-CHAMBER>>
		       <TELL ,CANT " do that here." CR>)
		      (,CHAINED?
		       <NOT-GOING-ANYWHERE>)
		      (T
		       <TELL ,OKAY 
			     "you just walked under the " D ,LADDER "." CR>
		       <BAD-LUCK "walk under a ladder">)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT TORTURE-CHAMBER
	(IN ROOMS)
	(DESC "Torture Chamber")
	(FLAGS ONBIT RLANDBIT INDOORSBIT)
	(GLOBAL TOWER HATCH LADDER)
	(UP PER EXIT-TORTURE?)
	(OUT PER EXIT-TORTURE?)
	(PSEUDO "CHAMBER" HERE-F)
	(ACTION TORTURE-CHAMBER-F)>

<ROUTINE EXIT-TORTURE? ()
	 <COND (,CHAINED?
		<NOT-GOING-ANYWHERE>
		<RFALSE>)
	       (<FSET? ,HATCH ,OPENBIT>
		<COND (,CLAMPED?
		       <TELL
"\"Don't leave me here to die!\" mews " D ,PRINCESS "." CR CR>)>
		<RETURN ,ROUND-CHAMBER>)
	       (T
		<ITS-CLOSED ,HATCH>
		<RFALSE>)>>

<ROUTINE NOT-GOING-ANYWHERE ()
	 <TELL "You're not going anywhere">
	 <WHILE-CHAINED>>

<ROUTINE TORTURE-CHAMBER-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're ">
		<COND (,CHAINED?
		       <TELL "chained up in the " D ,CORNER " of">)
		      (T
		       <TELL "in">)>
		<TELL 
" a dim, stuffy chamber, deep within the bowels of the " D ,TOWER ". The walls gleam with obscure " D ,INSTRUMENTS "s, and a diabolical " D ,TMACHINE " occupies most of the opposite " D ,CORNER "." CR CR>
		<COND (<IN? ,PRINCESS ,TORTURE-CHAMBER>
		       <TELL D ,PRINCESS " is ">
		       <COND (,CLAMPED?
			      <TELL "clamped into the " D ,TMACHINE "!">)
			     (T
			      <TELL "waddling around the chamber.">)>
		       <TELL CR CR>)>
		<TELL "A " D ,LADDER " rises to meet a">
		<OPEN-CLOSED ,HATCH T>
		<TELL D ,HATCH " in the middle of the ceiling." CR>
		<COND (<IN? ,CRISP ,TORTURE-CHAMBER>
		       <TELL CR D ,CRISP " is " <PICK-ONE ,STROLLS>
			     "." CR>)>)>>

<GLOBAL STROLLS
	<LTABLE 0
	 "strolling around dusting off the instruments"
	 "fondling the instruments, one by one"
	 "gently polishing the diabolical machine">>
 
<OBJECT INSTRUMENTS
	(IN TORTURE-CHAMBER)
	(DESC "medical instrument")
	(SYNONYM INSTRUMENTS)
	(ADJECTIVE OBSCURE MEDICAL TORTURE)
	(FLAGS NDESCBIT TRYTAKEBIT READBIT)
	(ACTION INSTRUMENTS-F)>

<ROUTINE INSTRUMENTS-F ()
	 <COND (<CHAIN-PROOF? ,INSTRUMENTS>
		<RTRUE>)
	       (<VERB? EXAMINE LOOK-ON READ>
		<TELL "One of the " D ,INSTRUMENTS "s is labeled, \"">
		<FROBOZZ "Truth Extractor">
		<TELL ".\" Gulp!" CR>
		<RTRUE>)
	       (T
		<TELL "Better keep away from the " D ,INSTRUMENTS 
"s. You might hurt somebody." CR>
		<RFATAL>)>>
	 
<OBJECT CHAINS
	(IN VESTIBULE)
	(DESC "chain")
	(SYNONYM CHAIN CHAINS SHACKLES BONDS)
	(ADJECTIVE HEAVY)
	(FLAGS NDESCBIT TRYTAKEBIT DOORBIT LOCKEDBIT)
	(ACTION CHAINS-F)>

<GLOBAL CHAINED? <>>

<ROUTINE CHAINS-F ()
	 <THIS-IS-IT ,CHAINS>
	 <COND (<EQUAL? ,HERE ,VESTIBULE>
		<TAKE-MIND-OFF ,CHAINS>
		<RTRUE>)
	       (<AND <VERB? CLOSE LOCK>
		     <EQUAL? ,PRSO ,CHAINS>
		     <NOT ,CHAINED?>>
		<WASTE-OF-TIME>
		<RTRUE>)
	       
	       (<AND <VERB? OPEN UNLOCK RELEASE>
		     <EQUAL? ,PRSO ,CHAINS>>
		<COND (<NOT ,CHAINED?>
		       <ALREADY-OPEN>)
		      (<NOT ,PRSI>
		       <TELL "(with " D ,HANDS ")" CR>
		       <THING-WONT-LOCK ,HANDS ,PRSO T>)
		      (<NOT <EQUAL? ,PRSI ,KEY>>
		       <THING-WONT-LOCK ,PRSI ,PRSO T>)
		      (<NOT <IN? ,KEY ,PROTAGONIST>>
		       <YOUD-HAVE-TO "be holding" ,KEY>)
		      (T
		       <OPEN-TORTURE-CHAINS>
		       <SAY-CHAIN-OPEN>
		       <CRLF>
		       <UPDATE-SCORE 1>)>
		<RTRUE>)
	       (<OR <HURT? ,CHAINS>
		    <MOVING? ,CHAINS>
		    <VERB? PICK EXAMINE LOOK-ON>>
		<TELL "The">
		<OPEN-CLOSED ,CHAINS>
		<TELL D ,CHAINS " is securely bolted into the floor." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>
	       
<ROUTINE OPEN-TORTURE-CHAINS ("AUX" OBJ)
	 <SETG CHAINED? <>>
	 <FSET ,CHAINS ,OPENBIT>
	 <FCLEAR ,CHAINS ,LOCKEDBIT>
	 <SET OBJ <FIRST? ,TORTURE-CHAMBER>>
	 <REPEAT ()
		 <COND (.OBJ
		        <FCLEAR .OBJ ,THROWNBIT>
		        <SET OBJ <NEXT? .OBJ>>)
		       (T
		        <RETURN>)>>>

<ROUTINE SAY-CHAIN-OPEN ()
	 <TELL ,OKAY "the " D ,CHAINS " is now unlocked and open." CR>>

<GLOBAL COAT-WORN? T>

<OBJECT COAT
	(IN TORTURE-CHAMBER)
	(DESC "white lab coat")
	(SYNONYM COAT JACKET SMOCK)
	(ADJECTIVE WHITE POCKET LAB LABORA DIRTY COLLAR)
	(FLAGS NDESCBIT TAKEBIT WEARBIT CONTBIT OPENBIT)
	(VALUE 0)
	(SIZE 5)
	(CAPACITY 2)
	(ACTION COAT-F)
	(CONTFCN IN-COAT)>

<ROUTINE IN-COAT (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-CONT>
		<COND (<AND <VERB? ASK-FOR ASK-ABOUT>
		            ,COAT-WORN?>
		       <NOT-LIKELY ,CRISP "would respond">
		       <RFATAL>)
		      (<SEE-VERB?>
		       <YOU-CANT-SEE>
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO "." CR>
		       <RTRUE>)
		      (,COAT-WORN?
		       <CRISP-WEARING>
		       <RTRUE>)
		      (<NOT <IN? ,COAT ,PROTAGONIST>>
		       <YOUD-HAVE-TO "pick up" ,COAT>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)>>

<ROUTINE COAT-F ("AUX" OBJ NXT)
	 <THIS-IS-IT ,COAT>
	 <COND (<VERB? EXAMINE>
		<SAY-THE ,COAT>
		<TELL " isn't as clean as the one your doctor wears." CR>
		<RTRUE>)
	       (,COAT-WORN?
		<CRISP-WEARING>
		<RTRUE>)
	       (<AND <VERB? LOOK-INSIDE SEARCH LOOK-DOWN>
		     <NOT <IN? ,COAT ,PROTAGONIST>>>
		<YOUD-HAVE-TO "be holding" ,COAT>
		<RTRUE>)
	       (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,COAT>
		     ,CHAINED?
		     <NOT <FSET? ,COAT ,TOUCHBIT>>>
		<COND (<ITAKE>
		       <SAY-THE ,CHAINS>
		       <TELL 
"s cut painfully into your wrist as you strain to grasp the " D ,COAT ". Your fingertips brush against the collar... There! You got it!" CR>)>
		<RTRUE>)
	       (<VERB? OPEN CLOSE>
		<TELL "You don't need to do that." CR>
		<RTRUE>)
	       (<AND <VERB? STAND-ON SIT LIE-DOWN CROSS>
		     <EQUAL? ,PRSO ,COAT>>
		<WASTE-OF-TIME>
		<RTRUE>)
	       (<AND <VERB? COVER PUT-ON PUT-UNDER>
		     <EQUAL? ,PRSI ,COAT>>
		<WASTE-OF-TIME>
		<RTRUE>) 
	       (T
		<RFALSE>)>>

<ROUTINE CRISP-WEARING ()
	 <TELL ,CANT " do that while " D ,CRISP
	       " is wearing the coat!" CR>>
		      
<OBJECT KEY
	(IN COAT)
	(DESC "rusty key")
	(SYNONYM KEY)
	(ADJECTIVE RUSTY RUSTED)
	(FLAGS NDESCBIT TAKEBIT TOOLBIT)
	(VALUE 3)
	(SIZE 1)
	(ACTION KEY-F)>

<ROUTINE KEY-F ()
	 <COND (<AND <VERB? EXAMINE>
		     <EQUAL? ,HERE ,TORTURE-CHAMBER ,LABORATORY>>
		<SAY-THE ,KEY>
		<TELL 
" looks as if it would fit into the " D ,CHAINS "." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>> 

<OBJECT TMACHINE
	(IN TORTURE-CHAMBER)
	(DESC "torture machine")
	(SYNONYM MACHINE MECHANISM CLAMP CLAMPS)
	(ADJECTIVE TORTURE DIABOLICAL)
	(FLAGS TRYTAKEBIT NDESCBIT CONTBIT OPENBIT)
	(CAPACITY 20)
	(ACTION TMACHINE-F)>

<ROUTINE TMACHINE-F ()
	 <COND (<VERB? EXAMINE LOOK-ON LOOK-INSIDE>
		<SAY-THE ,TMACHINE>
		<TELL " has a " D ,LEVER " that">
		<DESCRIBE-LEVER>
		<TELL " ">
		<COND (,CLAMPED?
		       <TELL D ,PRINCESS " is clamped">)
		      (T
		       <TELL ,YOU-SEE>
		       <PRINT-CONTENTS ,TMACHINE>)>
		<TELL " inside." CR>
		<RTRUE>)
	       (<AND <VERB? PUT PUT-ON>
		     <EQUAL? ,PRSI ,TMACHINE>
		     <EQUAL? ,PRSO ,KITTY>
		     ,CLAMPED?>
		<TELL D ,PRINCESS " stops you. \"I don't like animals!\"" CR>
		<RTRUE>)
	       (<MOVING? ,TMACHINE>
		<TOO-LARGE ,TMACHINE>
		<RTRUE>)
	       (<VERB? CLOSE>
		<HOW?>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT LEVER
	(IN TORTURE-CHAMBER)
	(DESC "lever")
	(SYNONYM LEVER)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION LEVER-F)>

<ROUTINE LEVER-F ()
	 <COND (<CHAIN-PROOF? ,LEVER>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<SAY-THE ,LEVER>
		<TELL
" is attached to the " D ,TMACHINE " in which " D ,PRINCESS " ">
		<COND (,CLAMPED?
		       <TELL "i">)
		      (T
		       <TELL "wa">)>
		<TELL "s clamped. It">
		<DESCRIBE-LEVER>
		<CRLF>
		<RTRUE>)
	       (<VERB? PUSH RAISE>
		<COND (,CLAMPED?
		       <TELL "\"No!\" screams " D ,PRINCESS "." CR CR>)>
		<SAY-THE ,TMACHINE>
		<TELL 
" emits a dreadful grinding noise and goes through a series of complicated gyrations. ">
		<COND (,CLAMPED?
		       <PRINCESS-POOF>
		       <TORTURE ,PRINCESS>)
		      (<IN? ,KITTY ,TMACHINE>
		       <DISABLE <INT ,I-FRISKY>>
		       <TORTURE ,KITTY>)
		      (<FIRST? ,TMACHINE>
		       <MOVE-ALL ,TMACHINE ,STEEP-TRAIL>
		       <TELL 
"When the grinding stops, the mechanism is empty.">)
		      (T
		       <TELL 
"Good thing " D ,PRINCESS " wasn't clamped into that awful thing!">)>
		<CRLF>
		<RTRUE>)
	       (<VERB? PULL LOWER>
		<TELL "The clamps on the " D ,TMACHINE " retract">
		<COND (,CLAMPED?
		       <PRINCESS-POOF>
		       <TELL 
", and " D ,PRINCESS " leaps off. She's free!|
|
\"Again you spare my unworthy life" ,ADVENTURER ".\" The " D ,PLATYPUS 
" humbly licks your shoe, to your considerable embarrassment. \"My father, " 
D ,KING ", does not forget such kindness.\"|
|
The little creature produces a " D ,WHISTLE " from her gown and blows into it gently. ">
		       <WHISTLE-SOUND>
		       <TELL CR
"\"Your journey is not yet ended,\" she warns as a whirlpool of colored light envelops her. \"But even if you fail, your deeds shall live forever in our legends. Have faith!\"|
|
When the colors fade, " D ,PRINCESS " is gone">)>
		<TELL "." CR>
		<RTRUE>)
	       (<VERB? USE MOVE>
		<SAY-THE ,LEVER>
		<DESCRIBE-LEVER>
		<CRLF>
		<RTRUE>)
	       (<AND <VERB? TAKE MUNG>
		     <EQUAL? ,PRSO ,LEVER>>
		<SAY-THE ,LEVER>
		<TELL " is firmly attached to the " D ,TMACHINE "." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE DESCRIBE-LEVER ()
	 <TELL " can be pushed up or pulled down.">>

<ROUTINE PRINCESS-POOF ()
	 <SETG CLAMPED? <>>
	 <MOVE ,PRINCESS ,THRONE-ROOM>
	 <DISABLE <INT I-PRINCESS-CALLS>>>

<ROUTINE TORTURE (THING)
	 <MOVE-ALL ,TMACHINE ,STEEP-TRAIL>
	 <TELL "Mewling piteously, ">
	 <ARTICLE .THING T>
	 <TELL D .THING 
" disappears into the whirling mass of gears. There's not a bone to be seen when the machine stops." CR CR>
	 <UPDATE-SCORE -10>
	 <TELL CR 
"(You ought to be ashamed of yourself!)">>

"*** FUZZY ***"

<OBJECT FUZZY
	(IN ROOMS)
	(DESC "Fuzziness")
	(FLAGS ONBIT RLANDBIT)
	(NORTH PER TOO-FUZZY)
	(SOUTH PER TOO-FUZZY)
	(EAST PER TOO-FUZZY)
	(WEST PER TOO-FUZZY)
	(UP PER TOO-FUZZY)
	(DOWN PER TOO-FUZZY)
	(IN PER TOO-FUZZY)
	(OUT PER TOO-FUZZY)
	(ACTION FUZZY-F)> 

<GLOBAL FUZZY-FROM LOBBY>
<GLOBAL FUZZY? <>>

<ROUTINE FUZZY-F (CONTEXT "AUX" F S)
	 <COND (<EQUAL? .CONTEXT ,M-BEG>
		<COND (<SEE-VERB?>
		       <TELL ,CANT ". ">
		       <ALL-FUZZY>
		       <RFATAL>)
		      (T
		       <RFALSE>)>)
	       (<EQUAL? .CONTEXT ,M-LOOK>
		<SET F <PICK-ONE ,BLURS>>
		<REPEAT ()
			<SET S <PICK-ONE ,BLURS>>
			<COND (<NOT <EQUAL? .S .F>>
			       <RETURN>)>>
                <TELL "Everything around you appears " .F " and " .S "." CR>
		<FCLEAR ,FUZZY ,TOUCHBIT>)>>

<ROUTINE TOO-FUZZY ()
	 <TELL "It's too " <PICK-ONE ,BLURS> " in that direction." CR>
	 <RFALSE>>

<GLOBAL BLURS <LTABLE 0 "blurred" "fuzzy" "blurry">>

<ROUTINE ALL-FUZZY ()
	 <TELL "Everything is too " <PICK-ONE ,BLURS> "!" CR>>

<OBJECT LABORATORY
	(IN ROOMS)
	(DESC "Laboratory")
	(FLAGS ONBIT RLANDBIT INDOORSBIT)
	(GLOBAL TOWER STAIRWAY WINDOW FESTERON)
	(NORTH "The only north exit is through the window.")
	(OUT PER EXIT-LAB)
	(DOWN PER EXIT-LAB)
	(ACTION LABORATORY-F)
	(PSEUDO "LABORA" HERE-F "LAB" HERE-F)>

<ROUTINE LABORATORY-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "The highest room in the " D ,TOWER 
" is a laboratory, complete with bubbling " D ,CHEMICALS 
" and foul odors. An " D ,SCOPE " is mounted near an open " D ,WINDOW " " 
<TO-N> ", and a " D ,PANEL " occupies most of the south wall.|
|
The only exit is a damp " D ,STAIRWAY " leading downward." CR>)>>

<ROUTINE EXIT-LAB ()
	 <SETG FUZZY? T>
	 <SETG FUZZY-FROM ,ROUND-CHAMBER>
	 <FCLEAR ,FUZZY ,TOUCHBIT>
	 <RETURN ,FUZZY>>

<OBJECT SCOPE
	(IN LABORATORY)
	(DESC "antique telescope")
	(SYNONYM TELESCOPE SCOPE)
	(ADJECTIVE ANTIQUE)
	(FLAGS NDESCBIT TRYTAKEBIT VOWELBIT)
	(ACTION SCOPE-F)>

<ROUTINE SCOPE-F ()
	 <COND (<VERB? EXAMINE>
		<SAY-THE ,SCOPE>
		<TELL " is pointing out the " D ,WINDOW "." CR>
		<RTRUE>)
	     ; (<EQUAL? ,HERE ,HILLTOP>
		<TOO-FAR-AWAY ,SCOPE>
		<RTRUE>)
	       (<IMAGE? ,SCOPE>
		<RFATAL>)
	       (<VERB? LOOK-INSIDE LOOK-THRU USE LOOK-DOWN>
		<TELL 
"Peering through the " D ,SCOPE " makes everything appear much closer." CR>
		<RTRUE>)
	       (<MOVING? ,SCOPE>
		<SAY-THE ,SCOPE>
		<TELL " is bolted securely in place." CR>
		<RTRUE>)
	       (<HURT? ,SCOPE>
		<RUIN ,SCOPE>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,SCOPE>
		<RFATAL>)>>

<ROUTINE IMAGE? (THING)
	 <COND (<EQUAL? ,HERE ,INSIDE-THEATER>
		<COND (<AND <VERB? THROW>
			    <EQUAL? ,PRSI .THING>>
		       <PERFORM ,V?THROW ,PRSO ,SCREEN>)
		      (T
		       <TELL ,CANT>
		       <DO-TO>
		       <TELL "a movie image!" CR>)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT WINDOW
	(IN LOCAL-GLOBALS)
	(DESC "window")
	(SYNONYM WINDOW)
	(ADJECTIVE DARK)
	(FLAGS NDESCBIT)
	(ACTION WINDOW-F)>

<ROUTINE WINDOW-F ()
	 <COND (<EQUAL? ,HERE ,ROTARY-NORTH ,INSIDE-CHURCH>
		<COND (<CHURCH-WINDOWS-F>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<NOT ,SKEWED?>
		<CANT-SEE-ANY ,WINDOW>
		<RFATAL>)
	       (<VERB? EXAMINE>
		<TELL "It's wide open, ">
		<COND (<EQUAL? ,HERE ,HILLTOP>
		       <TELL 
"and located a hundred feet above the moat">)
		      (T
		       <TELL
"affording a fine view of the " D ,FESTERON>)>
		<TELL "." CR>
		<RTRUE>)
	       (<EQUAL? ,HERE ,HILLTOP>
		<TOO-FAR-AWAY ,WINDOW>
		<RTRUE>)
	       (<VERB? EXIT LEAP ENTER THROUGH>
		<PERFORM ,V?KILL ,ME>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE LOOK-BEHIND USE LOOK-THRU>
		<EXCELLENT-VIEW ,WINDOW>
		<RTRUE>)
	       (<VERB? OPEN>
		<ALREADY-OPEN>
		<RTRUE>)
	       (<VERB? CLOSE>
		<TELL "It's not that kind of " D ,WINDOW "." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>
		       
<OBJECT KITTY
	(IN LABORATORY)
	(DESC "black cat")
	(SYNONYM CAT KITTY KITTEN)
	(ADJECTIVE BLACK SLEEPING)
	(FLAGS ACTORBIT TAKEBIT RMUNGBIT)
	(VALUE 0)
	(SIZE 10)
	(ACTION KITTY-F)
	(DESCFCN DESCRIBE-KITTY)>

; "RMUNGBIT = CAT SLEEPING"

<ROUTINE DESCRIBE-KITTY (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL "A " D ,KITTY " is ">
		<COND (<FSET? ,KITTY ,RMUNGBIT>
		       <TELL "sound asleep in the " D ,CORNER>)
		      (T
		       <TELL "playing around your feet">)>
		<TELL ".">)>>

<ROUTINE KITTY-F ("OPTIONAL" (CONTEXT <>))
	 <THIS-IS-IT ,KITTY>
	 <COND (<VERB? EXAMINE>
		<DESCRIBE-CHAOS>
		<TELL ", and ">
		<COND (<FSET? ,KITTY ,RMUNGBIT>
		       <TELL "sound asleep">)
		      (<IN? ,KITTY ,PROTAGONIST>
		       <TELL "squirming in your arms">)
		      (T
		       <TELL "playing around your feet">)>
		<TELL "." CR>
		<RTRUE>)
	       (<IMAGE? ,KITTY>
		<RFATAL>)
	       (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,KITTY>>
		<COND (<V-TAKE>
		       <CRLF>
		       <TOUCH-WAKE>)>
		<RTRUE>)
	       (<OR <TALKING-TO? ,KITTY>
		    <VERB? YELL>>
		<SAY-THE ,KITTY>
		<COND (<FSET? ,KITTY ,RMUNGBIT>
		       <WAKE-KITTY>
		       <TELL " wakes">)
		      (T
		       <TELL " perks up its ears">)>
		<TELL " at the sound of your voice." CR>
		<RFATAL>)
	       (<VERB? RUB KISS SQUEEZE PLAY>
		<TOUCH-WAKE>
		<RTRUE>)
	       (<HURT? ,KITTY>
		<V-RAPE>
		<RTRUE>)
	       (<VERB? LISTEN>
		<TELL "\"Purrrrr...\"" CR>
		<RTRUE>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,KITTY>>
		<COND (<EQUAL? ,PRSO ,KITTY>
		       <TELL <PICK-ONE ,YUKS> CR>)
		      (<FSET? ,KITTY ,RMUNGBIT>
		       <BUT-THE ,KITTY>
		       <TELL "is asleep!" CR>)
		      (<AND <EQUAL? ,PRSO ,MILK>
			    <NOT ,FUZZY?>
			    <NOT ,ECLIPSE?>>
		       <READY-MILK>
		       <GIVE-MILK-TO-CAT ,KITTY>)
		      (T
		       <NOT-LIKELY ,KITTY "would be interested">)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE TOUCH-WAKE ()
	 <SAY-THE ,KITTY>
	 <TELL " ">
	 <COND (<FSET? ,KITTY ,RMUNGBIT>
		<WAKE-KITTY>
		<TELL "awakens at your touch and ">)>
	 <TELL <PICK-ONE ,NICES> "." CR>>

<ROUTINE WAKE-KITTY ()
	 <FCLEAR ,KITTY ,RMUNGBIT>
	 <SETG HORSE-SCRIPT 5>
	 <ENABLE <QUEUE I-FRISKY -1>>>

<ROUTINE READY-MILK ()
	 <REMOVE ,MILK>
	 <TELL "(">
	 <COND (<NOT <FSET? ,BOTTLE ,OPENBIT>>
		<FSET ,BOTTLE ,OPENBIT>
	        <TELL "opening the " D ,BOTTLE " and ">)>
	 <TELL "pouring out the " D ,MILK " first)" CR CR>>
	 
<ROUTINE GIVE-MILK-TO-CAT (CAT)
	 <SAY-THE ,KITTY>
	 <COND (<IN? .CAT ,PROTAGONIST>
		<TELL " leaps from your arms and">)>
	 <TELL " eagerly laps the milk off the ">
	 <GROUND-OR-FLOOR>
         <TELL ". Its eyes turn red. Jets of brown steam issue from its ears, and it">
	 <SUBWAY>
	 <TELL " Then it runs away, yowling with anguish." CR>
	 <REMOVE .CAT>
	 <COND (<EQUAL? .CAT ,CHAOS>
		<CRLF>
		<UPDATE-SCORE -10>)
	       (T
		<DISABLE <INT I-FRISKY>>)>>

<ROUTINE I-FRISKY ()
	 <COND (<VISIBLE? ,KITTY>
		<SETG HORSE-SCRIPT <- ,HORSE-SCRIPT 1>>)
	       (T
		<RTRUE>)>
	 <COND (<AND <EQUAL? ,HERE ,OUTSIDE-COTTAGE>
		     <IN? ,KITTY ,PROTAGONIST>>
		<CRLF>
		<SAY-THE ,KITTY>
		<TELL " scrambles out of your arms and scoots away at the sight of the enormous " D ,HELLHOUND ".">
		<GONE-WITHOUT-A-TRACE>)
	       (<ZERO? ,HORSE-SCRIPT>
	      ; <COND (<AND <EQUAL? ,HERE ,JAIL-CELL>
			    <FSET? ,HIDDEN-HATCH ,RMUNGBIT>
			    <NOT <IN? ,KITTY ,PROTAGONIST>>>
		       <SETG HORSE-SCRIPT 3>
		       <RTRUE>)>
		<CRLF>
		<SAY-THE ,KITTY>
		<COND (<IN? ,KITTY ,PROTAGONIST>
		       <SETG HORSE-SCRIPT 3>
		       <TELL " squirms out of your arms">
		       <AND-DROPS-OUT ,KITTY>)
		      (T
		       <COND (<IN? ,KITTY ,TMACHINE>
			      <TELL " jumps out of the " D ,TMACHINE " and">)>
		       <TELL " scampers away behind your back.">
		       <GONE-WITHOUT-A-TRACE>)>)
	       (<EQUAL? ,HORSE-SCRIPT 2>
		<CRLF>
		<COND (<IN? ,KITTY ,PROTAGONIST>
		       <TELL "It's hard to hold the squirming cat!">)
		      (T
		       <SAY-THE ,KITTY>
		       <COND (<IN? ,KITTY ,TMACHINE>
			      <TELL " eagerly explores the " D ,TMACHINE>)
			     (T
			      <TELL " scampers restlessly around">)>
		       <TELL ".">)>
		<CRLF>)>> 

<ROUTINE GONE-WITHOUT-A-TRACE ()
	 <TELL " You turn to catch it, but it's gone">
	 <NO-TRACE>
	 <DISABLE <INT I-FRISKY>>
         <MOVE ,KITTY ,STEEP-TRAIL>>

<ROUTINE NO-TRACE ()
	 <TELL " without a trace!" CR>>

<GLOBAL NICES
	<LTABLE 0
	 "rubs itself lovingly against you"
	 "purrs agreeably"
	 "mews affectionately">>

<OBJECT CHEMICALS
	(IN LABORATORY)
	(DESC "chemicals")
	(SYNONYM CHEMICALS ICE WATER)
	(ADJECTIVE BUBBLING FLOATING DRY WARM)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION CHEMICALS-F)>

<ROUTINE CHEMICALS-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE LOOK-DOWN>
		<SAY-THE ,CHEMICALS>
		<TELL " look dangerous.">
		<COND (<EQUAL? ,HERE ,LABORATORY>
		       <LEAVE-THEM-ALONE>)>
		<CRLF>)
	       (<IMAGE? ,CHEMICALS>
		<RFATAL>)
	       (<MOVING? ,CHEMICALS>
		<CHEM-WARN "Fooling around with">)
	       (<HURT? ,CHEMICALS>
		<PERFORM ,V?TAKE ,CHEMICALS>
		<RTRUE>)
	       (<VERB? DRINK TASTE KISS>
		<CHEM-WARN "Tasting">)
	       (<VERB? SMELL>
		<TELL "The odor is like old socks and burning rubber." CR>)
	       (<VERB? EAT>
		<NOT-SOLID>)
	       (T
		<YOU-DONT-NEED ,CHEMICALS>
		<RFATAL>)>
	 <RTRUE>>    

<ROUTINE CHEM-WARN (STR)
	 <TELL .STR " strange " D ,CHEMICALS " is asking for trouble.">
	 <LEAVE-THEM-ALONE>
	 <CRLF>>

<OBJECT PANEL
	(IN LABORATORY)
	(DESC "control panel")
	(SYNONYM PANEL)
	(ADJECTIVE CONTROL)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION PANEL-F)>

<ROUTINE PANEL-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE LOOK-ON>
		<SAY-THE ,PANEL>
		<TELL " is equipped with two large power switches." CR>
		<RTRUE>)
	       (<IMAGE? ,PANEL>
		<RFATAL>)
	       (<AND <VERB? TAKE MUNG KICK>
		     <EQUAL? ,PRSO ,PANEL>>
		<SAY-THE ,PANEL>
		<TELL " is firmly attached to the wall." CR>) 
	       (T
		<YOU-DONT-NEED ,PANEL>
		<RFATAL>)>
	 <RTRUE>>
 
<OBJECT SW2
	(IN LABORATORY)
	(DESC "second switch")
	(SYNONYM SWITCH)
	(ADJECTIVE SECOND LARGE SECURITY)
	(FLAGS NDESCBIT TRYTAKEBIT READBIT RMUNGBIT)
	(ACTION SW2-F)>

; "RMUNGBIT = Switch not yet opened"

<ROUTINE SW2-F ()
	 <COND (<EXAM-SWITCH? ,SW2 "Security">
		<RTRUE>)
	       (<IMAGE? ,SW2>
		<RFATAL>)
	       (<VERB? LAMP-OFF OPEN>
		<COND (<OFF-SWITCH? ,SW2>
		       <SAY-SWITCH ,SW2>
		       <COND (<FSET? ,SW2 ,RMUNGBIT>
		              <FCLEAR ,SW2 ,RMUNGBIT>
		              <CRLF>
		              <UPDATE-SCORE 3>)>)>
		<RTRUE>)
	       (<VERB? LAMP-ON CLOSE>
		<COND (<ON-SWITCH? ,SW2>
		       <SAY-SWITCH ,SW2>)>
		<RTRUE>)
	       (<GENERIC-SWITCH? ,SW2>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT SW1
	(IN LABORATORY)
	(DESC "first switch")
	(SYNONYM SWITCH)
	(ADJECTIVE FIRST LARGE PALACE THEATER)
	(FLAGS NDESCBIT TRYTAKEBIT READBIT)
	(ACTION SW1-F)>

<ROUTINE SW1-F ()
	 <COND (<EXAM-SWITCH? ,SW1 "Palace Theater">
		<RTRUE>)
	       (<IMAGE? ,SW1>
		<RFATAL>)
	       (<VERB? LAMP-OFF OPEN>
		<COND (<OFF-SWITCH? ,SW1>
		       <SAY-SWITCH ,SW1>)>
		<RTRUE>)
	       (<VERB? LAMP-ON CLOSE>
		<COND (<ON-SWITCH? ,SW1>
		       <SAY-SWITCH ,SW1>)>
		<RTRUE>)
	       (<GENERIC-SWITCH? ,SW1>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE EXAM-SWITCH? (SW STR)
	 <COND (<VERB? EXAMINE LOOK-INSIDE LOOK-ON READ>
		<SAY-THE .SW>
	        <TELL " is labeled, \"" .STR ",\" and">
		<ON-OR-OFF .SW>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE SAY-SWITCH (SW)
	 <TELL ,OKAY "the " D .SW>
	 <ON-OR-OFF .SW>>
	 
<ROUTINE ON-OR-OFF (SW)
	 <TELL " is turned ">
	 <COND (<FSET? .SW ,OPENBIT>
		<TELL "off">)
	       (T
		<TELL "on">)>
	 <TELL "." CR>>

<ROUTINE OFF-SWITCH? (SW)
	 <COND (<FSET? .SW ,OPENBIT>
		<BUT-THE .SW>
		<TELL "is already off!" CR>
		<RFALSE>)
	       (T
	        <FSET .SW ,OPENBIT>
		<RTRUE>)>>

<ROUTINE ON-SWITCH? (SW)
	 <COND (<FSET? .SW ,OPENBIT>
		<FCLEAR .SW ,OPENBIT>
	        <RTRUE>)
	       (T
		<BUT-THE .SW>
		<TELL "is already on!" CR>
		<RFALSE>)>>

<ROUTINE GENERIC-SWITCH? (SW)
	 <COND (<OR <HURT? .SW>
		    <VERB? TAKE>>
		<TELL "The switches are firmly attached to the "
		      D ,PANEL "." CR>
		<RTRUE>)
	       (<AND <VERB? TURN MOVE PULL PUSH>
		     <EQUAL? ,PRSO .SW>>
		<COND (<FSET? .SW ,OPENBIT>
		       <PERFORM ,V?CLOSE .SW>)
		      (T
		       <PERFORM ,V?OPEN .SW>)>
		<RTRUE>)
	       (<VERB? COUNT>
		<PERFORM ,V?EXAMINE ,PANEL>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT BROOM
	(IN LABORATORY)
	(DESC "broom")
	(SYNONYM BROOM BROOMSTICK)
	(FLAGS TAKEBIT)
	(VALUE 0)
	(SIZE 20)
	(CAPACITY 10)
	(ACTION BROOM-F)>

<GLOBAL BROOM-SIT? <>>

<ROUTINE BROOM-F ()
	 <COND (<VERB? SIT CLIMB-ON ENTER RIDE>
		<COND (,BROOM-SIT?
		       <TELL "But you're already">)
		      (<NOT <IN? ,BROOM ,PROTAGONIST>>
		       <YOUD-HAVE-TO "be holding" ,BROOM>
		       <RTRUE>)
		      (T
		       <SETG BROOM-SIT? T>
		       <TELL ,OKAY "you're now">)>
		<SITTING-ON-BROOM>
		<RTRUE>)
	       (<VERB? TAKE-OFF EXIT CLIMB-DOWN>
		<COND (,BROOM-SIT?
		       <SETG BROOM-SIT? <>>
		       <TELL ,OKAY "you're no longer">)
		      (T
		       <TELL "But you're not">)>
		<SITTING-ON-BROOM>
		<RTRUE>)
	       (<HURT? ,BROOM>
		<WASTE-OF-TIME>
		<RTRUE>)
	       (<AND <VERB? PUT PUT-ON>
		     <EQUAL? ,PRSI ,BROOM>>
		<COND (<EQUAL? ,PRSO ,BROOM>
		       <TELL <PICK-ONE ,YUKS> CR>)
		      (T
		       <SAY-THE ,PRSO>
		       <TELL " topples off the narrow broomstick">
		       <AND-DROPS-OUT ,PRSO>)>
		<RTRUE>)
	       (<AND <VERB? EXAMINE LOOK-ON>
		     ,BROOM-SIT?>
		<TELL "You're">
		<SITTING-ON-BROOM>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE SITTING-ON-BROOM ()
	 <TELL " sitting on the " D ,BROOM "." CR>>

