"SOUTH for WISHBRINGER: (C)1985 Infocom, Inc. All rights reserved."

"*** HILLTOP ***"

<OBJECT HILLTOP
	(IN ROOMS)
	(DESC "Hilltop")
	(GLOBAL POST-OFFICE POST-DOOR HILL SIGN TOWER DRAWBRIDGE WINDOW)
	(FLAGS ONBIT RLANDBIT)
	(NORTH PER TUMBLE)
	(SOUTH PER ENTER-TOWER?)
	(EAST PER ENTER-OUTSIDE-COTTAGE)
	(WEST TO OUTSIDE-CEMETERY)
	(DOWN "(Which way to you want to go down the hill, east or west?)")
	(IN PER ENTER-TOWER?)
	(ACTION HILLTOP-F)>

<ROUTINE HILLTOP-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL
"You're on a hilltop overlooking the seaside " D ,FESTERON " of">
		<WHICH-TOWN>
		<TELL "." CR CR>
		<COND (,SKEWED?
		       <TELL "A " D ,TOWER 
" stands in bleak silhouette against the moonlit sky. It rises a hundred feet above a barren plateau, and is encircled by a deep moat. The only "
D ,ENTRANCE "s are a">
		       <OPEN-CLOSED ,DRAWBRIDGE T>
		       <TELL D ,DRAWBRIDGE 
" and a dark " D ,WINDOW " near the top." CR>)
		      (T 
		       <TELL
"To the south stands the Festeron " D ,POST-OFFICE ". It's a little brick building with a neatly-trimmed lawn. ">
		       <SAY-DOOR ,POST-DOOR>)>
		<TELL CR "Roads run down the hill " <TO-E> " and west. There's a signpost nearby." CR>)
	       (T
		<RFALSE>)>>

<ROUTINE SAY-DOOR (OBJ)
	 <SAY-THE .OBJ>
	 <COND (<FSET? .OBJ ,OPENBIT>
		<TELL " stands invitingly open.">)
	       (T
		<IS-CLOSED>)>
	 <CRLF>>

<ROUTINE I-CRISP-CALLING ()
	 <COND (<EQUAL? ,HERE ,HILLTOP>
		<SOMEBODY-CALLING>)>>

<ROUTINE SOMEBODY-CALLING ("OPTIONAL" (ROTARY? <>))
	 <TELL CR "Somebody ">
	 <COND (.ROTARY?
		<TELL "on the south side of the Rotary">)
	       (T
		<TELL "inside the " D ,POST-OFFICE>)>
         <TELL " is calling you." CR>>

<OBJECT HILL
	(IN LOCAL-GLOBALS)
	(DESC "hill")
	(SYNONYM HILL HILLTOP)
	(ADJECTIVE POST OFFICE LOOKOUT)
	(FLAGS NDESCBIT)
	(ACTION HILL-F)>

<ROUTINE HILL-F ()
	 <COND (<VERB? EXAMINE LOOK-DOWN LOOK-UP LOOK-ON>
		<V-LOOK>
		<RTRUE>)
	       (<EQUAL? ,HERE ,CLIFF-EDGE>
		<TOO-FAR-AWAY ,HILL>
		<RFATAL>)
	       (<VERB? WALK-TO USE ENTER THROUGH CLIMB-ON CLIMB-UP>
		<COND (<EQUAL? ,HERE ,HILLTOP ,LOOKOUT-HILL>
		       <ALREADY-AT ,HILL T>)
		      (T
		       <DO-WALK ,P?UP>)>
		<RTRUE>)
	       (<VERB? EXIT CLIMB-DOWN>
		<COND (<EQUAL? ,HERE ,HILLTOP ,LOOKOUT-HILL>
		       <DO-WALK ,P?DOWN>)
		      (T
		       <ALREADY-AT ,HILL>)>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,HILL>
		<RFATAL>)>>

<ROUTINE ALREADY-ON (THING "OPTIONAL" (NOT? <>))
	 <TELL "But you're ">
	 <COND (.NOT?
		<TELL "not">)
	       (T
		<TELL "already">)>
	 <TELL " on ">
	 <ARTICLE .THING T>
	 <TELL D .THING "!" CR>>

<ROUTINE ENTER-TOWER? ()
	 <COND (,SKEWED?
	        <COND (<FSET? ,DRAWBRIDGE ,OPENBIT>
		       <ENABLE <QUEUE I-CRISP-CAPTURE -1>>
		       <RETURN ,VESTIBULE>)
		      (T
		       <ITS-CLOSED ,DRAWBRIDGE>
		       <RFALSE>)>)
	       (T
	        <COND (<FSET? ,POST-DOOR ,OPENBIT>
		       <COND (<ZERO? ,CRISP-SCRIPT>
			      <ENABLE <QUEUE I-HOORAY -1>>
			      <ENABLE <QUEUE I-GIVE-ENVELOPE -1>>)>
	               <RETURN ,INSIDE-POST-OFFICE>)
		      (T
		       <ITS-CLOSED ,POST-DOOR> 
		       <RFALSE>)>)>>

<ROUTINE I-HOORAY ()
	 <DISABLE <INT I-HOORAY>>
	 <SETG POWER <- <RANDOM 3> 1>>
	 <CRLF>
	 <UPDATE-SCORE 1>>

<OBJECT POST-OFFICE
	(IN LOCAL-GLOBALS)
	(DESC "Post Office")
	(SYNONYM OFFICE BUILDING)
	(ADJECTIVE POST LITTLE BRICK)
	(FLAGS NDESCBIT)
	(ACTION POST-OFFICE-F)>

<ROUTINE POST-OFFICE-F ()
	 <COND (<AND ,SKEWED?
		     <NOT ,SUCCESS?>>
		<CANT-SEE-ANY ,POST-OFFICE>
		<RFATAL>)
	       (<EQUAL? ,HERE ,CLIFF-EDGE>
		<TOO-FAR-AWAY ,POST-OFFICE>
		<RFATAL>)
	       (<ENTER-FROM? ,HILLTOP ,INSIDE-POST-OFFICE ,POST-OFFICE>
		<RTRUE>)
	       (<VERB? EXAMINE LOOK-INSIDE>
		<COND (<EQUAL? ,HERE ,INSIDE-POST-OFFICE>
		       <V-LOOK>)
		      (T
		       <COND (<FSET? ,POST-DOOR ,OPENBIT>
		       <GO-INSIDE>)>)>)
	       (T
		<RFALSE>)>>

<OBJECT POST-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "Post Office door")
	(SYNONYM DOOR ENTRANCE ENTRY LOCK)
	(ADJECTIVE FRONT POST OFFICE)
	(FLAGS DOORBIT OPENBIT NDESCBIT)
	(ACTION POST-DOOR-F)>

<ROUTINE POST-DOOR-F ()
	 <COND (,SKEWED?
		<CANT-SEE-ANY "any doors" T>
		<RFATAL>)>
	 <THIS-IS-IT ,POST-DOOR>
	 <COND (<VERB? KNOCK>
		<COND (<FSET? ,POST-DOOR ,OPENBIT>
		       <ALREADY-OPEN>)
		      (<EQUAL? ,HERE ,INSIDE-POST-OFFICE>
		       <WASTE-OF-TIME>)
		      (<NOT <FSET? ,POST-DOOR ,LOCKEDBIT>>
		       <TELL "A voice inside " <PICK-ONE ,YELL-TYPES>
			     ", \"Come in!\"" CR>)
		      (T
		       <RFALSE>)>
		<RTRUE>)
	       (<USE-DOOR? ,HILLTOP>
		<RTRUE>)
	       (T
		<RFALSE>)>>

"*** INSIDE POST OFFICE ***"

<OBJECT INSIDE-POST-OFFICE
	(IN ROOMS)
	(DESC "Post Office")
	(FLAGS ONBIT RLANDBIT INDOORSBIT)
	(GLOBAL POST-OFFICE POST-DOOR)
	(NORTH PER EXIT-POST-OFFICE)
	(OUT PER EXIT-POST-OFFICE)
	(PSEUDO "POSTCARD" POSTCARD-PSEUDO
		"LOBBY" HERE-F)
	(ACTION INSIDE-POST-OFFICE-F)>

<ROUTINE INSIDE-POST-OFFICE-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL
"This is the " D ,GLOBBY " of the Festeron " D ,POST-OFFICE ". The walls are lined with small, private mailboxes and " D ,POSTER "s. A " D ,COUNTER " runs along the entire length of the room.">
		<COND (<FIRST? ,COUNTER>
		       <TELL " " ,YOU-SEE>
		       <PRINT-CONTENTS ,COUNTER>
		       <TELL " on the " D ,COUNTER ".">)>
		<COND (<IN? ,CRISP ,INSIDE-POST-OFFICE>
		       <TELL CR CR "Your boss, " D ,CRISP ", is ">
		       <COND (<FSET? ,CRISP ,TOUCHBIT>
		              <TELL "watching you impatiently.">)
		             (T
		              <FSET ,CRISP ,TOUCHBIT>
		              <TELL
"behind the " D ,COUNTER " reading other people's postcards.">)>)>
		<CRLF>)>>

<ROUTINE EXIT-POST-OFFICE ()
	 <COND (<FSET? ,POST-DOOR ,OPENBIT>
	        <COND (<AND <FSET? ,ENVELOPE ,RMUNGBIT> ; "Given?"
			    <HELD? ,ENVELOPE>>		       
		       <TELL
"As you leave the " D ,POST-OFFICE ", somebody">
		       <SLAMS-AND-LOCKS>)
	              (T
		       <TELL D ,CRISP " " <PICK-ONE ,YELL-TYPES>
", \"Come back here, " <PICK-ONE ,INSULTS>>
		       <COND (<FSET? ,ENVELOPE ,RMUNGBIT> ; "Given?"
			      <TELL "! You forgot the envelope">)>
		       <TELL "!\"">)>
	        <CRLF>
	        <CRLF>
	        <RETURN ,HILLTOP>)
	       (T
	        <ITS-CLOSED ,POST-DOOR>
		<RFALSE>)>>
	 
<ROUTINE SLAMS-AND-LOCKS ()
	 <TELL " slams and locks the door behind you.">
	 <SETG ANGER 4>
	 <DISABLE <INT I-CRISP-CALLING>>
	 <DISABLE <INT I-GIVE-ENVELOPE>>
	 <FCLEAR ,POST-DOOR ,OPENBIT>
	 <FSET ,POST-DOOR ,LOCKEDBIT>>

<ROUTINE POSTCARD-PSEUDO ()
	 <TELL ,CANT " do that. " D ,CRISP " has hidden them." CR>
	 <RFATAL>>

<OBJECT COUNTER
	(IN INSIDE-POST-OFFICE)
	(DESC "service counter")
	(SYNONYM COUNTER)
	(ADJECTIVE SERVICE)
	(FLAGS SURFACEBIT NDESCBIT)
	(ACTION COUNTER-F)
	(CAPACITY 10)>

<ROUTINE COUNTER-F ()
	 <COND (<VERB? LOOK-BEHIND LOOK-INSIDE LOOK-UNDER>
		<COND (<NOT <FSET? ,ENVELOPE ,RMUNGBIT>> ; "Not given?"
		       <TELL D ,CRISP
" pushes you away before you can get a good look." CR>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<GETTING-INTO?>
		<TELL D ,CRISP " might yell at you">
		<IF-YOU-TRIED>
		<RTRUE>)
	       (T
	        <RFALSE>)>>

<OBJECT POSTER
	(IN INSIDE-POST-OFFICE)
	(DESC "wanted poster")
	(SYNONYM POSTER)
	(ADJECTIVE WANTED)
	(FLAGS NDESCBIT READBIT ; TRYTAKEBIT)
	(ACTION POSTER-F)>

<ROUTINE POSTER-F ()
	 <COND (<VERB? EXAMINE READ>
		<COND (<EQUAL? ,HERE ,INSIDE-POST-OFFICE>
		       <FIXED-FONT-ON>
		       <TELL CR
"          WANTED!|
    For Impersonating A|
        Storyteller|
\"PROFESSOR\" BRIAN MORIARTY" CR>
		       <FIXED-FONT-OFF>)
		      (,SKEWED?
		       <SAY-THE ,POSTER>
		       <HAS-YOUR-NAME>)
		      (T
		       <TELL "It's the same as the one in the "
			     D ,POST-OFFICE "." CR>)>
		<RTRUE>)
	       (<OR <HURT? ,POSTER>
		    <VERB? TAKE>>
		<COND (<EQUAL? ,HERE ,INSIDE-POST-OFFICE>
		       <PRINTD ,CRISP>)
		      (T
		       <PRINTD ,MACGUFFIN>)>
		<MIGHT-NOT-LIKE>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,POSTER>
		<RFATAL>)>>

<ROUTINE HAS-YOUR-NAME ()
	 <TELL " has your name on it!" CR>>

<ROUTINE PRIVATE-BOXES? ()
	 <COND (<VERB? EXAMINE>
		<SAY-THE ,SMALL-BOX>
		<TELL "es are">
		<CLOSED-AND-LOCKED>)
	       (<OR <HURT? ,SMALL-BOX>
		    <VERB? OPEN LOOK-INSIDE LOOK-DOWN UNLOCK REACH-IN>>
		<SAY-THE ,SMALL-BOX>
		<TELL "es are private!">
		<LEAVE-THEM-ALONE>
		<CRLF>)
	       (T
		<YOU-DONT-NEED ,SMALL-BOX>
		<RFATAL>)>
	 <RTRUE>>

<ROUTINE LEAVE-THEM-ALONE ()
	 <TELL " Better leave them alone.">>

"*** OUTSIDE CEMETERY ***"

<OBJECT OUTSIDE-CEMETERY
	(IN ROOMS)
	(DESC "Outside Cemetery")
	(GLOBAL SOUTH-GATE HILL CEMETERY)
	(FLAGS ONBIT RLANDBIT)
	(EAST TO HILLTOP)
	(UP TO HILLTOP)
	(WEST PER ARE-YOU-SURE?)
	(IN PER ARE-YOU-SURE?)
	(ACTION OUTSIDE-CEMETERY-F)>

<ROUTINE OUTSIDE-CEMETERY-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
	        <STANDING>
		<TELL "next to a">
		<OPEN-CLOSED ,SOUTH-GATE T>
		<TELL "iron gate that leads west into the">
		<WHICH-TOWN "Cemetery">
		<TELL 
". A road runs east to the top of " D ,POST-OFFICE " Hill." CR>)>> 

<OBJECT SOUTH-GATE
	(IN LOCAL-GLOBALS)
	(DESC "iron gate")
	(SYNONYM GATE GATES LOCK BARS)
	(ADJECTIVE IRON TALL)
	(FLAGS NDESCBIT VOWELBIT DOORBIT OPENBIT)
	(ACTION SOUTH-GATE-F)>

<ROUTINE SOUTH-GATE-F ()
	 <THIS-IS-IT ,SOUTH-GATE>
	 <COND (<VERB? ENTER THROUGH WALK-TO USE>
		<COND (<EQUAL? ,HERE ,CREEPY-CORNER>
		       <DO-WALK ,P?EAST>)
		      (T
		       <DO-WALK ,P?WEST>)>
		<RTRUE>)
	       (<GENERIC-GATE? ,SOUTH-GATE>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE GENERIC-GATE? (GATE)
	 <COND (<VERB? EXAMINE LOOK-ON>
		<TELL "The bars of the">
		<OPEN-CLOSED .GATE>
		<TELL D .GATE " are 12 feet high, and closely spaced." CR>
		<RTRUE>)
	       (<VERB? LEAP CLIMB-UP CLIMB-ON>
		<TOO-HIGH .GATE>
		<RTRUE>)
	       (<AND <VERB? CLOSE>
		     <FSET? .GATE ,OPENBIT>>
		<SAY-THE .GATE>
		<TELL " is too big to close by yourself." CR>
		<RTRUE>)
               (T
		<RFALSE>)>>

<ROUTINE TOO-HIGH (THING)
	 <TELL "The " D .THING " is much too high." CR>>

"*** OUTSIDE COTTAGE ***"

<GLOBAL WHERE-FROM <>>

<ROUTINE ENTER-OUTSIDE-COTTAGE ()
	 <COND (<EQUAL? ,HERE ,ROTARY-SOUTH>
		<WAIT-CRY T>)>
	 <SETG WHERE-FROM ,HERE>
	 <COND (,SKEWED?
		<SETG DOG-SCRIPT 0>)>
       ; <SETG POODLE-HAPPY? <>>
	 <RETURN ,OUTSIDE-COTTAGE>>

<OBJECT OUTSIDE-COTTAGE
	(IN ROOMS)
	(DESC "Outside Cottage")
	(FLAGS ONBIT RLANDBIT)
	(GLOBAL HILL COTTAGE COTTAGE-DOOR)
	(NORTH PER NORTH-PAST-DOG?)
	(EAST PER ENTER-VOSS?)
	(WEST PER WEST-PAST-DOG?)
	(UP PER WEST-PAST-DOG?)
	(IN PER ENTER-VOSS?)
	(ACTION OUTSIDE-COTTAGE-F)>

<ROUTINE LIBRARIAN ()
	 <THIS-IS-IT ,MISS-VOSS>
	 <PRINTD ,MISS-VOSS>
	 <TELL ", the ">
	 <COND (,SKEWED?
		<TELL "former ">)>
	 <TELL "town librarian">>

<ROUTINE OUTSIDE-COTTAGE-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're outside the " D ,COTTAGE " of ">
		<LIBRARIAN>
		<TELL ". The road turns north toward the " D ,FESTERON ", and bends upward to the summit of " D ,POST-OFFICE " Hill." CR>)>>
		
<ROUTINE TEETH-OR-FANGS ()
	 <COND (,SKEWED?
		<TELL "sharp, bloody fangs">)
	       (T
		<SHARP-TEETH>)>>

<ROUTINE SHARP-TEETH ()
	 <TELL "sharp little teeth">>

<ROUTINE NORTH-PAST-DOG? ()
	 <COND (<DOG-ONLY-ALLOWS? ,ROTARY-SOUTH>
		<COND (<NOT <FSET? ,ROTARY-SOUTH ,TOUCHBIT>>
		       <FSET ,NORTH-GATE ,LOCKEDBIT>
		       <FCLEAR ,NORTH-GATE ,OPENBIT>
		       <MOVE ,POSTER ,INSIDE-POLICE-STATION>)>
		<RETURN <ENTER-ROTARY-SOUTH>>)
	       (T
		<RFALSE>)>>

<ROUTINE WEST-PAST-DOG? ()
	 <COND (<DOG-ONLY-ALLOWS? ,HILLTOP>
		<RETURN ,HILLTOP>)
	       (T
		<RFALSE>)>>

<ROUTINE DOG-ONLY-ALLOWS? (FROM)
	 <COND (,POODLE-HAPPY?
		<REMOVE ,BONE>
		<SETG POODLE-HAPPY? <>>
		<DOG-THREATENS>
		<RTRUE>)
	       (<OR <EQUAL? ,WHERE-FROM .FROM>
		    ,HELLHOUND-HAPPY?
		    ,ECLIPSE?>
		<DOG-THREATENS>
		<RTRUE>)
	       (T
		<SAY-THE ,POOCH>
		<TELL " won't let you go that way." CR>
		<RFALSE>)>>

<ROUTINE DOG-THREATENS ()
         <SAY-THE ,POOCH>
	 <COND (,ECLIPSE?
		<TELL 
" howls mournfully in the " D ,DARKNESS " as you creep past.">)
	       (,HELLHOUND-HAPPY?
		<THUMPS-TAIL>)
	       (T
		<TELL " ">
		<BARK-OR-ROAR>
	        <TELL "s a threat as you back away.">)>
	 <CRLF>
	 <CRLF>>

<ROUTINE THUMPS-TAIL ()
	 <TELL " thumps its big tail happily as you pass.">>

<OBJECT POODLE
	(IN OUTSIDE-COTTAGE)
	(DESC "poodle")
	(SYNONYM POODLE DOG MUTT)
	(ADJECTIVE TINY SMALL LITTLE MEAN)
	(FLAGS ACTORBIT ; NDESCBIT TRYTAKEBIT RMUNGBIT)
	(DESCFCN DESCRIBE-POOCH)
	(ACTION CANINE-F)>

; "RMUNGBIT means poodle has not been fed the bone"

<OBJECT HELLHOUND
	(DESC "hellhound")
	(SYNONYM HELLHOUND HOUND DOG MUTT)
	(ADJECTIVE BIG LARGE HELL)
	(FLAGS ACTORBIT ; NDESCBIT TRYTAKEBIT)
	(DESCFCN DESCRIBE-POOCH)
	(ACTION CANINE-F)>

<ROUTINE DESCRIBE-POOCH (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<COND (<NOT <FSET? ,POOCH ,TOUCHBIT>>
		       <FSET ,POOCH ,TOUCHBIT>
		       <TELL 
"As you approach the " D ,COTTAGE " you are greeted by the ">
		       <COND (,SKEWED?
			      <TELL "bigg">)
			     (T
			      <TELL "tini">)>
		       <TELL "est " D ,POOCH
" you've ever seen in your entire life. It charges across the street, ">
		       <COND (,SKEWED?
			      <TELL "roar">)
			     (T
			      <TELL "yapp">)>
		       <TELL "ing angrily and showing its ">
		       <TEETH-OR-FANGS>
		       <TELL ".">
		       <RTRUE>)
		      (,ECLIPSE?
		       <TELL "A " D ,HELLHOUND
			     " is hiding its eyes under its paws">)
		      (,HELLHOUND-HAPPY?
		       <TELL "A happy " D ,HELLHOUND
			     " is thumping its tail nearby">)
		      (,POODLE-HAPPY?
		       <TELL "A tiny " D ,POODLE
	   		     " is gnawing on a bone and watching you">)
		      (T
		       <TELL "An angry " D ,POOCH
			     " is blocking your path">)>
		<TELL ".">
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT ALEXIS
	(IN OUTSIDE-COTTAGE)
	(DESC "Alexis")
	(SYNONYM ALEXIS)
	(FLAGS ACTORBIT NDESCBIT NARTICLEBIT)
	(ACTION ALEXIS-F)>

<GLOBAL POOCH POODLE>
<GLOBAL POODLE-HAPPY? <>>
<GLOBAL HELLHOUND-HAPPY? <>>

<ROUTINE CANINE-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<VERB? EXAMINE>
		<SAY-THE ,POOCH>
		<TELL " is ">
		<COND (,ECLIPSE?
		       <TELL "watching the dark sky anxiously">)
		      (,HELLHOUND-HAPPY?
		       <TELL "thumping its big tail happily">)
		      (,SKEWED?
		       <TELL 
"big enough to eat you whole, and willing to try">)
		      (,POODLE-HAPPY?
		       <TELL "watching you as it gnaws on the bone">)
		      (T
		       <TELL "tiny, mean and ">
		       <COND (<FSET? ,POODLE ,RMUNGBIT>
			      <TELL "hungry">)
			     (T
			      <TELL "nasty">)>
		       <TELL "-looking">)>
		<TELL "." CR>
		<RTRUE>)
	       (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,POOCH>>
		<SAY-THE ,POOCH>
		<MIGHT-NOT-LIKE>
		<RTRUE>)
	       (<VERB? RUB KISS>
		<SAY-THE ,POOCH>
		<COND (,HELLHOUND-HAPPY?
		       <TELL " seems to enjoy your attention." CR>)
		      (T
		       <TELL " would probably chew you up">
	               <IF-YOU-TRIED>)>
		<RTRUE>)
	       (<AND <VERB? GIVE THROW FEED>
		     <EQUAL? ,PRSI ,POOCH ,ALEXIS>>
		<COND (<EQUAL? ,PRSO ,BROOM>
		       <GET-OFF-BROOM-FIRST>)>
		<SAY-THE ,POOCH>
		<COND (,ECLIPSE?
		       <TELL " is too uneasy to notice it." CR>
		       <RTRUE>)>
		<TELL " tests ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO " with its tongue, ">
		<COND (<EQUAL? ,PRSO ,BONE>
		     ; <AND <EQUAL? ,PRSO ,BONE>
		            <EQUAL? ,PRSI ,POODLE>>
		       <MOVE ,BONE ,OUTSIDE-COTTAGE>
		       <FSET ,BONE ,NDESCBIT>
		       <FCLEAR ,POODLE ,RMUNGBIT>
		       <SETG POODLE-HAPPY? T>
		       <TELL 
"lies down and begins to gnaw on it, keeping a red eye on you." CR CR>
		       <UPDATE-SCORE 3>
		       <RTRUE>)
		      (<EQUAL? ,PRSO ,CHOCOLATE ; ,KITTY ,WORM>
		       <REMOVE ,PRSO>
		       <TELL "gobbles it down greedily">)
		      (T
		       <MOVE ,PRSO ,OUTSIDE-COTTAGE>
		       <TELL "drops it on the road">)>
		<TELL " and turns to ">
	        <BARK-OR-ROAR>
	        <TELL " at you again." CR>
		<RTRUE>)
	       (<OR <TALKING-TO? ,POOCH>
		    <TALKING-TO? ,ALEXIS>
		    <EQUAL? ,PRSA ,V?YELL>>
		<COND (,HELLHOUND-HAPPY?
		       <SOUND-OF-VOICE>
		       <RFATAL>)>
		<SAY-THE ,POOCH>
		<TELL " growls ">
		<COND (,ECLIPSE?
		       <TELL "uneasi">)
		      (T
		       <TELL "dangerous">)>
		<TELL "ly in reply." CR>
		<RFATAL>)
	       (<OR <HURT? ,POOCH>
		    <VERB? CLIMB-ON CLIMB-UP SHAKE SQUEEZE>>
		<COND (,HELLHOUND-HAPPY?
		       <TELL "Why">
		       <DO-TO>
		       <TELL "a friendly, obedient " D ,HELLHOUND "?">)
		      (T
		       <TELL "Are you kidding? This " D ,POOCH " is MEAN!">)>
		<CRLF>
		<RTRUE>)
	       (<VERB? LISTEN>
		<TELL "It ">
		<BARK-OR-ROAR>
		<TELL "s louder." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE ALEXIS-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<NOT <EQUAL? ,HERE ,OUTSIDE-COTTAGE>>
	        <CANT-SEE-ANY ,ALEXIS>
	        <RFATAL>)
	       (<EQUAL? .CONTEXT ,M-WINNER>
		<COND (<VERB? HEEL>
		       <PRINTD ,ALEXIS>
		       <COND (,HELLHOUND-HAPPY?
			      <TELL " is already doing that!" CR>)
			     (T
			      <SETG HELLHOUND-HAPPY? T>
		              <DISABLE <INT I-BARKING>>
	                      <SETG P-HER-OBJECT ,HELLHOUND>
			      <TELL
" pricks up her ears at the sound of her name. She sits obediently at your feet, gently licks " D ,HANDS " and thumps her big tail happily." CR CR>
		              <UPDATE-SCORE 5>)>)
		      (,HELLHOUND-HAPPY?
		       <SOUND-OF-VOICE>)
		      (T
		       <FOOL-POOCH>)>
		<RFATAL>)
	       (<NOT ,NOTE-READ?>
		<SETG P-HER-OBJECT ,HELLHOUND>
		<FOOL-POOCH>
		<RFATAL>)
	       (<AND <VERB? TELL>
		     <EQUAL? ,PRSO ,ALEXIS>>
		<RFALSE>)
	       (<CANINE-F .CONTEXT>
		<RTRUE>)
	       (T
		<RFALSE>)>>
	 	       
<ROUTINE FOOL-POOCH ()
	 <SAY-THE ,POOCH>
	 <TELL " decides that you're only guessing its name, and ">
	 <BARK-OR-ROAR>
	 <TELL "s all the louder." CR>>

<ROUTINE SOUND-OF-VOICE ()
	 <SAY-THE ,POOCH>
	 <TELL " thumps its tail harder at the sound of your voice." CR>>

<GLOBAL POODLE-HINTS
	<LTABLE 0
"Try examining the poodle. You might discover something"
"Look around. You might find something the poodle would like"
"Maybe you can bribe the poodle with something">>

<GLOBAL DOG-SCRIPT 0>
<GLOBAL P-HINT 0>

<ROUTINE BARK-OR-ROAR ()
	 <COND (,ECLIPSE?
		<TELL "whimper">)
	       (,HELLHOUND-HAPPY?
		<TELL "thump">)
	       (,SKEWED?
	        <TELL "roar">)
	       (T
		<TELL "yap">)>>

<ROUTINE I-BARKING ()
	 <COND (<OR ,FUZZY? ,ECLIPSE?>
		<RTRUE>)
	       (<EQUAL? ,HERE ,OUTSIDE-COTTAGE>
		<COND (,POODLE-HAPPY?
		       <RTRUE>)>
		<SETG DOG-SCRIPT <+ ,DOG-SCRIPT 1>>
		<SETG P-HINT <+ ,P-HINT 1>>
		<THIS-IS-IT ,POOCH>
		<CRLF>
		<COND (<AND <NOT ,SKEWED?>
			    <FSET? ,POODLE ,RMUNGBIT>
			    <NOT <IN? ,BONE ,PROTAGONIST>>
			    <G? ,P-HINT 8>>
		       <SETG DOG-SCRIPT 0>
		       <SETG P-HINT 0>
		       <TELL "(" <PICK-ONE ,POODLE-HINTS> ".)" CR>)
		      (<EQUAL? ,DOG-SCRIPT 1>
		       <TELL
"You can smell the " D ,POOCH "'s hot breath as it ">
		       <BARK-OR-ROAR>
		       <TELL "s." CR>)
		      (<EQUAL? ,DOG-SCRIPT 2>
		       <SAY-THE ,POOCH>
		       <TELL
" glares at you through eyes red with hatred." CR>)
		      (<EQUAL? ,DOG-SCRIPT 3>
		       <TELL ,YOU-HEAR "the " D ,POOCH "'s ">
		       <TEETH-OR-FANGS>
		       <TELL " snapping as it nips your heels." CR>)
		      (<EQUAL? ,DOG-SCRIPT 4>
		       <SAY-THE ,POOCH>
		       <TELL 
" circles you warily, snarling and growling with menace.">
		       <COND (<AND ,SKEWED?
				   <NOT ,LUCKY?>>
			      <TELL
" It looks as if it's getting ready to attack!">)
			     (T
			      <SETG DOG-SCRIPT 0>)>
		       <CRLF>)
		      (T
		       <TELL "With a savage leap, the " D ,HELLHOUND 
" lives up to its bloodthirsty reputation.">
		       <BAD-ENDING>)>)>>

<OBJECT BONE
	(IN OPEN-GRAVE)
	(DESC "old bone")
	(SYNONYM BONE)
	(ADJECTIVE OLD)
	(FLAGS TAKEBIT VOWELBIT RMUNGBIT)
	(VALUE 1)
	(SIZE 5)>

; "RMUNGBIT = bone not discovered"

"*** INSIDE VOSS HOUSE ***"

<OBJECT COTTAGE-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "cottage door")
	(SYNONYM DOOR ENTRANCE ENTRY LOCK)
	(ADJECTIVE COTTAGE)
	(FLAGS NDESCBIT DOORBIT)
	(ACTION COTTAGE-DOOR-F)>
	
<ROUTINE COTTAGE-DOOR-F ()
	 <COND (<SEE-VERB?>
		<RFALSE>)
	       (<USE-DOOR? ,OUTSIDE-COTTAGE>
		<RTRUE>)
	       (<NOT ,HELLHOUND-HAPPY?>
		<COND (,ECLIPSE?
		       <TOO-DARK>)
		      (T
		       <WONT-LET-YOU-NEAR>)>
		<RTRUE>)	       	       
	       (T
		<RFALSE>)>>
		     
<ROUTINE ENTER-VOSS? ()
	 <COND (<FSET? ,COTTAGE-DOOR ,OPENBIT>
		<SAY-THE ,POOCH>
		<THUMPS-TAIL>
		<CRLF>
		<CRLF>
		<RETURN ,INSIDE-COTTAGE>)
	       (T
		<COND (<OR ,HELLHOUND-HAPPY? ,ECLIPSE?>
		       <ITS-CLOSED ,COTTAGE-DOOR>)
		      (T
		       <WONT-LET-YOU-NEAR>)>
		<RFALSE>)>>

<ROUTINE WONT-LET-YOU-NEAR ()
	 <SAY-THE ,POOCH>
	 <TELL
" won't let you near the " D ,COTTAGE "." CR>>

<OBJECT COTTAGE
	(IN LOCAL-GLOBALS)
	(DESC "cottage")
	(SYNONYM COTTAGE HOUSE BUILDING HOME)
	(FLAGS NDESCBIT)
        (ACTION COTTAGE-F)>

<ROUTINE COTTAGE-F ()
	 <COND (<ENTER-FROM? ,OUTSIDE-COTTAGE ,INSIDE-COTTAGE ,COTTAGE>
		<RTRUE>)
	       (<VERB? EXAMINE LOOK-INSIDE>
		<COND (<EQUAL? ,HERE ,INSIDE-COTTAGE>
		       <V-LOOK>)
		      (T
		       <TELL "It">
		       <COND (,SKEWED?
		              <TELL 
" looks as if it was deserted a long time ago">)
		             (T
		              <TELL 
"'s a tidy, happy-looking little place">)>
		       <TELL "." CR>)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT INSIDE-COTTAGE
	(IN ROOMS)
	(DESC "Cottage")
	(GLOBAL COTTAGE COTTAGE-DOOR)
	(FLAGS ONBIT RLANDBIT INDOORSBIT)
	(WEST TO OUTSIDE-COTTAGE IF COTTAGE-DOOR IS OPEN)
	(OUT TO OUTSIDE-COTTAGE IF COTTAGE-DOOR IS OPEN)
	(ACTION INSIDE-COTTAGE-F)>

<ROUTINE INSIDE-COTTAGE-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "This is the " D ,COTTAGE " of ">
		<LIBRARIAN>
		<TELL ". The walls are lined with timeworn books and dusty, faded photographs. Looks as if nobody's lived here for a long time." CR>)>>

<OBJECT BOOKCASE
	(IN INSIDE-COTTAGE)
	(DESC "bookcase")
	(SYNONYM BOOKCASE CASE)
	(ADJECTIVE BOOK)
	(FLAGS SURFACEBIT)
	(CAPACITY 10)
	(ACTION BOOKCASE-F)
	(DESCFCN DESCRIBE-BOOKCASE)>

<ROUTINE DESCRIBE-BOOKCASE (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL "There's a dusty " D ,BOOKCASE>
		<COND (<FIRST? ,BOOKCASE>
		       <TELL " with ">
		       <PRINT-CONTENTS ,BOOKCASE>
		       <TELL " on it">)>
		<TELL " near the">
		<OPEN-CLOSED ,COTTAGE-DOOR>
		<TELL D ,HOUSE-DOOR ".">
		<COND (<NOT <FSET? ,SCRAWL ,RMUNGBIT>>
		       <TELL 
" Somebody has scrawled a message in the dust on the " D ,BOOKCASE ".">)>)>>

<ROUTINE BOOKCASE-F ()
	 <COND (<GETTING-INTO?>
		<WASTE-OF-TIME>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<TELL ,YOU-SEE>
		<PRINT-CONTENTS ,BOOKCASE>
		<TELL " on the " D ,BOOKCASE>
		<COND (<NOT <FSET? ,SCRAWL ,RMUNGBIT>>
		       <TELL ", ">
		       <COND (<FIRST? ,BOOKCASE>
			      <TELL "and">)
			     (T
			      <TELL "except for">)>
		       <TELL " a message scrawled on its dusty surface">)>
		<TELL "." CR>
		<RTRUE>)
		      
	       (<HURT? ,BOOKCASE>
		<HOW-WOULD-YOU-LIKE-IT ,BOOKCASE>
		<RTRUE>)
	       (<VERB? OPEN CLOSE>
		<TELL "It's not that kind of " D ,BOOKCASE "." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>
		
<OBJECT LIBRARY-KEY
	(IN BOOKCASE)
	(DESC "steel key")
	(SYNONYM KEY)
	(ADJECTIVE STEEL)
	(FLAGS TAKEBIT READBIT)
	(VALUE 3)
	(SIZE 1)
	(ACTION LIBRARY-KEY-F)>

<ROUTINE LIBRARY-KEY-F ()
	 <COND (<VERB? EXAMINE READ>
		<TELL "The words \"Witchville Public Library\" are etched into the " D ,LIBRARY-KEY "." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT SCRAWL
	(IN INSIDE-COTTAGE)
	(DESC "scrawled message")
	(SYNONYM MESSAGE)
	(ADJECTIVE SCRAWL DUST)
	(FLAGS NDESCBIT READBIT)
	(ACTION SCRAWL-F)>

<ROUTINE SCRAWL-F ()
	 <COND (<VERB? EXAMINE READ>
		<COND (<FSET? ,SCRAWL ,RMUNGBIT>
		       <TELL "You rubbed out the " D ,SCRAWL "." CR>)
		      (T
		       <SAY-THE ,SCRAWL>
		       <TELL 
" is enclosed in a heart-shaped outline. It says," CR>
		       <FIXED-FONT-ON>
		       <TELL CR
"VIOLET + CORKY|
     XXXX" CR>
		       <FIXED-FONT-OFF>)>
		<RTRUE>)
	       (<OR <HURT? ,SCRAWL>
	            <VERB? MOVE PULL PUSH RUB>>
		<FSET ,SCRAWL ,RMUNGBIT>
	        <SAY-THE ,SCRAWL>
		<TELL " is rubbed out." CR>
		<RTRUE>)
	       (<AND <VERB? PUT PUT-ON>
		     <EQUAL? ,PRSI ,SCRAWL>>
		<TELL ,I-ASSUME " the " D ,BOOKCASE ".)" CR>
		<PERFORM ,V?PUT-ON ,PRSO ,BOOKCASE>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT BOOKS
	(IN INSIDE-COTTAGE)
	(DESC "books and photographs")
	(SYNONYM BOOK BOOKS PHOTOS PHOTOGRAPHS)
	(ADJECTIVE TIMEWORN DUSTY FADED)
	(FLAGS NDESCBIT READBIT TRYTAKEBIT)
	(ACTION BOOKS-F)>

<ROUTINE BOOKS-F ()
	 <COND (<AND <VERB? EXAMINE READ TAKE>
		     <EQUAL? ,PRSO ,BOOKS>>
		<UNFORTUNATELY>
		<TELL "you don't have time for browsing." CR>)
	       (<HURT? ,BOOKS>
		<HOW-WOULD-YOU-LIKE-IT ,BOOKS>)
	       (T
		<YOU-DONT-NEED ,BOOKS>
		<RFATAL>)>
	 <RTRUE>>
	 

