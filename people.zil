
"PEOPLE for WISHBRINGER: (C)1985 Infocom, Inc. All rights reserved."

"*** CRISP ***"

<GLOBAL CRISP-SCRIPT 0>

<OBJECT CRISP
	(IN INSIDE-POST-OFFICE)
	(DESC "Mr. Crisp")
	(SYNONYM CRISP BOSS POSTMASTER MAN)
	(ADJECTIVE MEAN OLD MR MISTER)
	(FLAGS ACTORBIT NDESCBIT NARTICLEBIT)
	(ACTION CRISP-F)>

<ROUTINE BOSS ()
	 <TELL " your mean old boss, " D ,CRISP>>

<ROUTINE CRISP-F ("OPTIONAL" (CONTEXT <>))
	 <THIS-IS-IT ,CRISP>
	 <COND (<VERB? EXAMINE>
		<TELL "He's wearing a ">
		<COND (,SKEWED? 
		       <TELL D ,COAT>)
		      (T
		       <TELL "regulation " D ,POST-OFFICE " uniform">)>
		<TELL ", which does little to hide his ugly face." CR>
		<RTRUE>)
	       (<ASKING? ,CRISP>
	        <TELL D ,CRISP " " <PICK-ONE ,YELL-TYPES>
                      ", \"You're here to ">
		<COND (,SKEWED?
		       <TELL "answer questions, not to ask them">)
		      (T
		       <TELL "take orders, not to ask questions">)>
		<TELL "!\"" CR>
		<RFATAL>)
	       (<VERB? TELL YELL REPLY HELLO REPLY THANK ; GOODBYE>
		<TELL
"\"Don't talk back to me!\" " D ,CRISP " " <PICK-ONE ,YELL-TYPES> "." CR>
	        <RFATAL>)
	       (<HURT? ,CRISP>
		<TELL D ,CRISP " might ">
		<COND (,SKEWED?
		       <TELL "torture">)
		      (T
		       <TELL "fire">)>
		<TELL " you">
		<IF-YOU-TRIED>
		<RTRUE>)
	       (<VERB? FOLLOW WALK-TO>
		<COND (,CHAINED?
		       <NOT-GOING-ANYWHERE>
		       <RTRUE>)
		    ; (<IN? ,CRISP ,HERE>
		       <TELL "He's right here!" CR>
		       <RTRUE>)
		      (<EQUAL? ,HERE ,TORTURE-CHAMBER>
		       <DO-WALK ,P?UP>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,CRISP>>
		<COND (<EQUAL? ,PRSO ,ENVELOPE>
		       <IVE-ALREADY-SEEN-IT>
		       <RTRUE>)>
		<TELL D ,CRISP " takes ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO " and stares at it">
		<COND (<EQUAL? ,PRSO ,VIOLET-NOTE>
		       <TELL ". ">
		       <CRISP-SEES-NOTE>)
		      (<EQUAL? ,PRSO ,WISHBRINGER>
		       <TELL ". ">
		       <CRISP-SEES-STONE>)
		      (<EQUAL? ,PRSO ,CHOCOLATE>
		       <TELL " hungrily.">
		       <HISTORY>
		       <REMOVE ,CHOCOLATE>)
		      (<EQUAL? ,PRSO ,CONCH-SHELL>
		       <TELL " admiringly. \"This">
		       <TV-SET T>
		       <TELL ",\" he mutters, setting it aside." CR>
		       <MOVE ,CONCH-SHELL ,HERE>
		       <FSET ,CONCH-SHELL ,THROWNBIT>)
		      (T
		       <TELL 
" stupidly. \"Trying to butter me up with presents, eh?\" he " 
<PICK-ONE ,YELL-TYPES> ", tossing it ">
		       <COND (,SKEWED?
			      <FSET ,PRSO ,THROWNBIT>
			      <MOVE ,PRSO ,HERE>
			      <TELL "angrily to the floor.">)
			     (T
			      <TELL "back at you.">
			      <YOU-ARE-HOLDING ,PRSO T>)>
		       <CRLF>)>
		<RTRUE>)
	       (<VERB? KISS SQUEEZE RUB>
		<TELL D ,CRISP " blushes. \"I didn't know you cared.\"" CR>
		<RTRUE>)
	       (T
	        <RFALSE>)>>

<GLOBAL ANGER 5>

<ROUTINE I-GIVE-ENVELOPE ()
	 <COND (<EQUAL? ,HERE ,INSIDE-POST-OFFICE>
		<THIS-IS-IT ,CRISP>
		<SETG CRISP-SCRIPT <+ ,CRISP-SCRIPT 1>>
		<TELL CR D ,CRISP " ">
		<COND (<EQUAL? ,CRISP-SCRIPT 3>
		       <TELL "drums his fingers on the " D ,COUNTER
			     " impatiently. \"" <PICK-ONE ,GET-GOINGS>>
		       <PLACE-CLOSES>)
		      
		      (<IN? ,ENVELOPE ,PROTAGONIST>
		       <SETG ANGER <- ,ANGER 1>>
		       <COND (<ZERO? ,ANGER>
			      <CRISP-THROWS-YOU-OUT>)
			     (T
			      <TELL
<PICK-ONE ,YELL-TYPES> ", \"" <PICK-ONE ,GET-GOINGS> "!\"">)>)
		      
		      (<EQUAL? ,CRISP-SCRIPT 1>
		       <TELL 
"hides the postcards away as you enter. \"Where have you been?\" he barks angrily. \"Daydreaming again, eh? I've been looking everywhere for you!\"">)
		      
		      (<EQUAL? ,CRISP-SCRIPT 2>
		       <MOVE ,ENVELOPE ,COUNTER>
	 	       <THIS-IS-IT ,ENVELOPE>
		       <FSET ,ENVELOPE ,RMUNGBIT> ; "Given!"
		       <TELL "reaches under the " D ,COUNTER
" and pulls out a " D ,ENVELOPE ". \"We just got this Special Delivery,\" he snarls, tossing it onto the " D ,COUNTER ". \"I want you to drop it off right away. That means NOW!\"">)
		      
		      (T
		       <THIS-IS-IT ,ENVELOPE>
		       <SETG ANGER <- ,ANGER 1>>
		       <COND (<ZERO? ,ANGER>
			      <PUTP ,ENVELOPE ,P?VALUE 0>
			      <FSET ,ENVELOPE ,TOUCHBIT>
			      <MOVE ,ENVELOPE ,PROTAGONIST>
			      <TELL "picks up the " D ,ENVELOPE
" and stuffs it into " D ,HANDS "s with a curse. Then he ">
			      <CRISP-THROWS-YOU-OUT>)
			     (T
			      <TELL "points to the " D ,ENVELOPE " on the ">
		              <COND (<IN? ,ENVELOPE ,COUNTER>
			             <PRINTD ,COUNTER>)
			            (T
			             <TELL "floor">)>
		              <TELL " impatiently. \"Take the ">
			      <COND (<PROB 50>
				     <TELL "stupid ">)>
			      <TELL "envelope and scram">
		              <PLACE-CLOSES>)>)>
		<CRLF>)>>

<ROUTINE CRISP-THROWS-YOU-OUT ()
	 <COND (<NOT <FSET? ,POST-DOOR ,OPENBIT>>
		<TELL "opens the " D ,HOUSE-DOOR ", ">)>
	 <TELL "picks you up and throws you out of the " D ,POST-OFFICE ". \""
<PICK-ONE ,GET-GOINGS> "!\" he " <PICK-ONE ,YELL-TYPES> " as he">
	 <SLAMS-AND-LOCKS>
	 <MOVE ,PROTAGONIST ,HILLTOP>
	 <SETG HERE ,HILLTOP>>

<ROUTINE PLACE-CLOSES ()
	 <COND (<PROB 50>
		<TELL ", " <PICK-ONE ,INSULTS>>)>
	 <TELL "! The " D ,MAGICK-SHOPPE " closes at five o'clock!\"">>

<GLOBAL YELL-TYPES 
	<LTABLE 0  
	 "hollers" "growls" "yells" "rumbles" "screams" "wails">>

<GLOBAL GET-GOINGS  
	<LTABLE 0 "Get going" "Quit stalling" "Get moving"
		  "Deliver that envelope" "Scram" "Don't just stand there">>

<GLOBAL INSULTS 
	<LTABLE 0
         "dummy" "knucklehead" "idiot" "chowderbrain" "numbskull">>

<ROUTINE I-CRISP-CAPTURE ("AUX" OBJ)
	 <COND (<OR ,FUZZY? ,ECLIPSE?>
		<RTRUE>)
	       (<EQUAL? ,HERE ,VESTIBULE ,TORTURE-CHAMBER>
		<SETG CRISP-SCRIPT <+ ,CRISP-SCRIPT 1>>
	        <CRLF>
	        <COND (<EQUAL? ,CRISP-SCRIPT 1>
		       <MOVE ,PRINCESS ,VESTIBULE>
		       <TELL "\"Turn back" ,ADVENTURER "!\"|
|
You stare in horror at the " D ,PLATYPUS " chained to the floor. It's " 
D ,PRINCESS "!" CR>)
		      
		      (<EQUAL? ,CRISP-SCRIPT 2>
		       <COND (<L? ,WISDOM 6>
			      <START-BUZZ 6>)>
		       <FCLEAR ,DRAWBRIDGE ,OPENBIT>
		       <FCLEAR ,VESTIBULE ,TOUCHBIT>
		     ; <MOVE ,SCOPE ,LABORATORY>
		       <DEPOSIT-BRANCH>
		       <MOVE ,PROTAGONIST ,TORTURE-CHAMBER>
		       <MOVE ,PRINCESS ,TORTURE-CHAMBER>
		       <MOVE ,CRISP ,TORTURE-CHAMBER>
		       <MOVE ,CHAINS ,TORTURE-CHAMBER>
		       <SETG CHAINED? T>
		       <SETG CLAMPED? T>
		     ; <FSET ,SW1 ,OPENBIT>
		       <SETG HERE ,TORTURE-CHAMBER>
		       <INTRO>
		       <TELL "... " D ,CRISP "!|
|
\"Nice of you to drop by,\" he sneers as a gigantic Boot pins you to the "
D ,GROUND ". \"Saves me the bother of tracking you down.\"">
		       <CARRIAGE-RETURNS>
		       <V-LOOK>)

		      (<EQUAL? ,CRISP-SCRIPT 3>
		       <TELL D ,CRISP
" dangles a " D ,KEY " in front of your face. \"This is the key to your " 
D ,CHAINS ",\" he announces. \"Say goodbye to it.\" He drops the key into his coat pocket and laughs like a madman.|
|
\"Your laughter is like one gone mad!\" notes " D ,PRINCESS " observantly.|
|
\"Silence!\" He grips a control lever on the " D ,TMACHINE 
". \"One more peep, your Highness, and I'll push this lever up and reward your insolence with Pain!\"" CR>)
		      
		       (<EQUAL? ,CRISP-SCRIPT 4>
			<TELL D ,CRISP
" snaps on a pair of rubber gloves and smiles wickedly.|
|
\"Are you carrying anything interesting?\" he asks, looking you up and down. \"I'd hate to start my experiments without giving you a chance to bribe me.\"" CR>
			<COND (<IN? ,VIOLET-NOTE ,TORTURE-CHAMBER>
			       <CRLF>
			       <CRISP-LIFTS ,VIOLET-NOTE>
	                       <CRISP-SEES-NOTE>)
			      (<IN? ,WISHBRINGER ,TORTURE-CHAMBER>
			       <CRLF>
			       <CRISP-LIFTS ,WISHBRINGER>
			       <CRISP-SEES-STONE>)
			      (<NOT <FIRST? ,PROTAGONIST>>
			       <CRLF>
			       <NO-BRIBE>)>
			<RTRUE>)
		       
		      (T
		       <SET OBJ <FIRST? ,PROTAGONIST>>
		       <COND (<IN? ,VIOLET-NOTE ,TORTURE-CHAMBER>
			      <CRISP-LIFTS ,VIOLET-NOTE>
	                      <CRISP-SEES-NOTE>)
			     (<IN? ,WISHBRINGER ,TORTURE-CHAMBER>
			      <CRISP-LIFTS ,WISHBRINGER>
			      <CRISP-SEES-STONE>)
			     (<OR <EQUAL? .OBJ ,VIOLET-NOTE ,WISHBRINGER
					       ,CHOCOLATE>
				  <EQUAL? .OBJ ,CONCH-SHELL>>
			      <PERFORM ,V?GIVE .OBJ ,CRISP>
			      <COND (<EQUAL? .OBJ ,WISHBRINGER>
				     <I-LUCK>)>
			      <RTRUE>)
			     (.OBJ
			      <FCLEAR .OBJ ,WORNBIT>
			      <FSET .OBJ ,THROWNBIT>
			      <MOVE .OBJ ,TORTURE-CHAMBER>
			      <TELL D ,CRISP " " <PICK-ONE ,SWIPES> " ">
			      <ARTICLE .OBJ T>
			      <TELL D .OBJ " away from you"
				    <PICK-ONE ,CONSIDERATIONS> ". "
				    <PICK-ONE ,BORINGS> " to the floor." CR>
			      <COND (<EQUAL? .OBJ ,SHOE>
				     <I-LUCK>)>)
			     (T
			      <NO-BRIBE>)>
		       <RTRUE>)>)>>
  
<ROUTINE CRISP-LIFTS (OBJ)
	<MOVE .OBJ ,CRISP>
	<TELL D ,CRISP " notices ">
	<ARTICLE .OBJ T>
	<TELL D .OBJ " lying on the floor and picks it up. ">>

<GLOBAL SWIPES
	<LTABLE 0
	 "snatches" "swipes" "pulls" "grabs" "yanks">>

<GLOBAL CONSIDERATIONS
	<LTABLE 0
	 " and looks it over casually"
	 " with a contemptuous shrug"
	 ", sniffing with disinterest"
	 " and barely suppresses a yawn"
	 ", turns it over in his hands and snorts">>

<GLOBAL BORINGS
	<LTABLE 0
"\"Is this the best you've got?\" he growls, tossing it"
"\"Fascinating,\" he mutters, throwing it"
"It's thrown without comment"
"It strikes the opposite wall and falls"
"\"How extraordinarily useful,\" he notes, pitching it">>

<ROUTINE CRISP-SEES-NOTE ()
	 <DISABLE <INT I-CRISP-CAPTURE>>
	 <SETG CRISP-SCRIPT 0>
	 <ENABLE <QUEUE I-PRINCESS-CALLS -1>>
	 <MOVE ,VIOLET-NOTE ,TORTURE-CHAMBER>
	 <FSET ,VIOLET-NOTE ,THROWNBIT>
	 <FCLEAR ,VIOLET-NOTE ,RMUNGBIT>
	 <SETG COAT-WORN? <>>
	 <FCLEAR ,COAT ,NDESCBIT>
	 <FCLEAR ,HATCH ,OPENBIT>
	 <MOVE ,CRISP ,INSIDE-POST-OFFICE>
	 <TELL
"His face turns pale. \"Where did this come from?\" he whispers, opening it.|
|
An unbearably sweet expression spreads over his face as he reads. The "
D ,VIOLET-NOTE " falls from his hands.|
|
\"I've got to run,\" " D ,CRISP " cries, tossing his " D ,COAT " into a "
D ,CORNER " and stuffing his shirttails into his pants. \"Violet scolds me when I'm late!\" He struggles into a hideous velvet blazer, pushes a comb through his hair and scampers up the " D ,LADDER " like a little boy.|
|
The " D ,HATCH " closes with a hollow thud." CR>>

<ROUTINE CRISP-SEES-STONE ()
	 <MOVE ,WISHBRINGER ,COAT>
	 <FCLEAR ,WISHBRINGER ,ONBIT>
	 <FSET ,WISHBRINGER ,RMUNGBIT>
	 <TELL 
"\"Humph!\" he snorts, peering at it. \"I wonder if" ,EONE " has one of these.\" He plunks the " D ,WISHBRINGER " into his coat pocket." CR>>

<ROUTINE NO-BRIBE ()
	 <DISABLE <INT I-CRISP-CAPTURE>>
	 <TELL D ,CRISP
" searches you carefully, but finds you empty-handed. \"Too bad,\" he sighs. \"I was hoping you'd try to bribe me, then start begging for mercy, maybe even grovel a little.\" He walks to the " D ,LADDER " and calls upward, \"Next!\"|
|
A Boot escorts the " D ,GRAVEDIGGER " down the " D ,LADDER " as " D ,CRISP " touches a hidden switch. The floor">
	 <BENEATH-FEET>
	 <TELL ", and you slide screaming down an endless chute...">
	 <BAD-ENDING>>  

<ROUTINE BENEATH-FEET ()
	 <TELL " falls away beneath your feet">>

<ROUTINE I-PRINCESS-CALLS ()
	 <COND (,FUZZY?
		<RTRUE>)
	       (<EQUAL? ,HERE ,TORTURE-CHAMBER>
		<SETG CRISP-SCRIPT <+ ,CRISP-SCRIPT 1>>
		<COND (<EQUAL? ,CRISP-SCRIPT 1>
		       <RTRUE>)>
		<COND (<EQUAL? ,CRISP-SCRIPT 2>
		       <TELL CR "You ">
		       <HEAR-BRIDGE>
		       <TELL CR D ,PRINCESS " breathes a sigh of relief." CR>)
		      (<EQUAL? ,CRISP-SCRIPT 3>
		       <TELL CR "You ">
		       <HEAR-BRIDGE>
		       <TELL CR D ,PRINCESS
" strains against her clamps. \"Release me from this " D ,TMACHINE
,ADVENTURER "! " <PICK-ONE ,BEGS> ".\"" CR>)
		      (<PROB 50>
		       <THIS-IS-IT ,LEVER>
		       <TELL CR "\"" <PICK-ONE ,BEGS> ",\" cries "
			     D ,PRINCESS "." CR>)>)>>

<GLOBAL BEGS
	<LTABLE 0
"Only pull down this lever, and I shall be freed"
"The merest pull of the lever will gain my freedom"
"Please! Pull down this lever and set me free">>

"*** GRAVEDIGGER ***"

<GLOBAL DIGGER-SCRIPT 0>

<GLOBAL ENVELOPE-PEERED-AT? <>>

<OBJECT GRAVEDIGGER
	(IN SPOOKY-COPSE)
	(DESC "gravedigger")
	(SYNONYM GRAVEDIGGER DIGGER MAN)
	(ADJECTIVE OLD GRAVE)
	(FLAGS ACTORBIT NDESCBIT)
	(ACTION GRAVEDIGGER-F)>

; "RMUNGBIT = Gravedigger fooled with Darkness"

<ROUTINE GRAVEDIGGER-F ("OPTIONAL" (CONTEXT <>))
	 <THIS-IS-IT ,GRAVEDIGGER>
	 <COND (<VERB? EXAMINE>
		<COND (,SKEWED?
		       <TELL "No doubt about it. ">)>
		<TELL "He's the town " D ,GRAVEDIGGER ", ">
		<COND (,SKEWED?
		       <TELL 
"looking stiff and uncomfortable in his new usher's uniform">)
		      (T
		       <TELL 
"a " D ,FESTERON " fixture since before you were born">)>
		<TELL "." CR>
		<RTRUE>)
	       (<VERB? WAVE-AT>
		<SAY-THE ,GRAVEDIGGER>
		<COND (,SKEWED?
		       <TELL " sneers">)
		      (T
		       <TELL " winks at you slyly">)>
		<TELL "." CR>
		<RTRUE>)
	       (<HURT? ,GRAVEDIGGER>
		<SAY-THE ,GRAVEDIGGER>
		<MIGHT-NOT-LIKE>
		<RTRUE>)
	       (<TALKING-TO? ,GRAVEDIGGER>
		<SAY-THE ,GRAVEDIGGER>
		<TELL 
" doesn't respond. He seems to be a bit hard of hearing." CR>
		<RFATAL>)
	       (<VERB? YELL>
		<TELL "No reply. ">
		<SAY-THE ,GRAVEDIGGER>
		<TELL " is apparently stone deaf." CR>
		<RFATAL>)
	       (<AND <VERB? FOLLOW>
		     <NOT ,SKEWED?>>
		<COND (<AND <EQUAL? ,HERE ,SPOOKY-COPSE>
			    <NOT <ENABLED? ,I-DIGGER-TALK>>>
		       <DO-WALK ,P?WEST>
		       <RTRUE>)
		      (<AND <EQUAL? ,HERE ,TWILIGHT-GLEN>
			    <NOT <FSET? ,NORTH-GATE ,OPENBIT>>>
		       <DO-WALK ,P?NORTH>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,GRAVEDIGGER>>
		<COND (<EQUAL? ,PRSO ,ENVELOPE>
		       <COND (,ENVELOPE-PEERED-AT?
			      <IVE-ALREADY-SEEN-IT>
			      <RTRUE>)
			     (T
			      <SETG ENVELOPE-PEERED-AT? T>
			      <SAY-THE ,GRAVEDIGGER>
			      <TELL " peers at the address on the "
D ,ENVELOPE ". \"Hmm,\" he mutters, handing it back to you. \"Could've sworn I buried that " D ,OLD-WOMAN " years ago.\"">
			      <YOU-ARE-HOLDING ,ENVELOPE T>
			      <CRLF>
			      <RFATAL>)>)
		      
		      (<EQUAL? ,PRSO ,TICKET>
		       <MOVE ,TICKET ,STEEP-TRAIL>
		       <FSET ,TICKET ,TOOLBIT>
		       <SETG NO-MOVIE? <>>
		       <THIS-IS-IT ,CARTON>
		       <SAY-THE ,GRAVEDIGGER>
		       <TELL " takes the " D ,TICKET
			     ", gestures absently to the empty " D ,CARTON 
			     " and leans back to daydream." CR>
		       <RFATAL>)
		      (T
		       <TELL "\"No, thanks,\" he says, shaking his head. \"Got enough junk already.\"" CR>
		       <RTRUE>)>)
	       
	       (T
		<RFALSE>)>>

<ROUTINE I-DIGGER-TALK ()
	 <COND (<EQUAL? ,HERE ,SPOOKY-COPSE>
		<THIS-IS-IT ,GRAVEDIGGER>
		<SETG DIGGER-SCRIPT <+ ,DIGGER-SCRIPT 1>>
	 	<CRLF>
		<COND (<EQUAL? ,DIGGER-SCRIPT 1>
		       <SAY-THE ,GRAVEDIGGER>
		       <TELL " nods a greeting as you approach." CR>)
		      
		      (<IN? ,ENVELOPE ,HERE>
		       <SETG DIGGER-SCRIPT <- ,DIGGER-SCRIPT 1>>
		       <MOVE ,ENVELOPE ,PROTAGONIST>
		       <SAY-THE ,GRAVEDIGGER>
		       <TELL " notices the " D ,ENVELOPE 
" on the " D ,GROUND " and picks it up. \"You dropped this">
		       <COND (,ENVELOPE-PEERED-AT? 
			      <TELL ",\" he says, handing it back to you.">
			      <YOU-ARE-HOLDING ,ENVELOPE T>
			      <CRLF>)
			     (T
			      <MIND-IF-I-LOOK>
			      <CRLF>
			      <PERFORM ,V?GIVE ,ENVELOPE ,GRAVEDIGGER>
			      <RTRUE>)>)
		      
		      (<EQUAL? ,DIGGER-SCRIPT 2>
		       <COND (<AND <NOT ,ENVELOPE-PEERED-AT?>
				   <IN? ,ENVELOPE ,PROTAGONIST>>
			      <SAY-THE ,GRAVEDIGGER>
			      <TELL " notices the " D ,ENVELOPE " you're holding. \"That's a mighty mysterious-lookin' envelope you got there">
			      <MIND-IF-I-LOOK>)
			     (T
			      <TELL "\"Nice grave-diggin' weather we're havin' lately,\" the " D ,GRAVEDIGGER " notes drily." CR>)>)
		      
		      (<EQUAL? ,DIGGER-SCRIPT 3>
		       <TELL "\"">
		       <COND (<AND <NOT ,ENVELOPE-PEERED-AT?>
				   <IN? ,ENVELOPE ,PROTAGONIST>>
			      <THIS-IS-IT ,ENVELOPE>
			      <TELL
"Sure would like to get a closer look at that " D ,ENVELOPE>)
			     (T
			      <TELL
"Couldn't ask for a nicer day for diggin' graves">)>
		       <TELL ".\"" CR>)
		      
		      (T
		       <MOVE ,GRAVEDIGGER ,TWILIGHT-GLEN>
		       <DISABLE <INT I-DIGGER-TALK>>
		       <TELL "\"Got to go,\" says the " D ,GRAVEDIGGER
", picking up his shovel. \"See you soon.\"|
|
The old man ambles away " <GET ,DIR-NAMES 3> "." CR>)>)>>

<ROUTINE MIND-IF-I-LOOK ()
	 <THIS-IS-IT ,ENVELOPE>
	 <TELL ",\" he says. \"Let's have a look at it.\"" CR>>

"*** MACGUFFIN ***"

<GLOBAL MACGUFFIN-SCRIPT 0>

<OBJECT MACGUFFIN
	(IN INSIDE-POLICE-STATION)
	(DESC "Sgt. MacGuffin")
	(SYNONYM MACGUFFIN MAN)
	(ADJECTIVE SGT SERGEANT SARGE)
	(FLAGS NDESCBIT ACTORBIT NARTICLEBIT)
	(ACTION MACGUFFIN-F)>

<ROUTINE MACGUFFIN-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<OR <TALKING-TO? ,MACGUFFIN>
		    <VERB? YELL>>
		<COND (,SKEWED?
		       <TELL
"\"I'll do the talking around here!\" snaps " D ,MACGUFFIN>)
		      (T
		       <TELL D ,MACGUFFIN " ">
		       <COND (<G? ,MACGUFFIN-SCRIPT 3>
		              <TELL "snores">)
		             (T
			      <TELL "mutters something vague">)>
		       <TELL " in reply">)>
		<TELL "." CR>
		<RFATAL>)
	       (<VERB? EXAMINE>
		<PRINTD ,MACGUFFIN>
		<COND (,SKEWED?
		       <TELL " isn't in a good mood">)
		      (T
		       <TELL "'s ">
		       <COND (<G? ,MACGUFFIN-SCRIPT 3>
			      <TELL "sleeping like a baby">)
			     (T
			      <TELL "about to fall asleep">)>)>
		<TELL "." CR>
		<RTRUE>)
	       (<HURT? ,MACGUFFIN>
		<TELL D ,MACGUFFIN " would probably have you ">
		<COND (,SKEWED?
		       <TELL "tortured">)
		      (T
		       <TELL "arrested">)>
		<IF-YOU-TRIED>
		<RTRUE>)
	       (<VERB? KISS SQUEEZE RUB>
		<TELL D ,MACGUFFIN " ">
		<COND (,SKEWED?
		       <TELL "slaps you across the face">)
		      (T
		       <TELL "smiles dreamily">)>
		<TELL "." CR>
		<RTRUE>)
	       (<AND <VERB? GIVE FEED>
		     <EQUAL? ,PRSI ,MACGUFFIN>
		     <NOT ,SKEWED?>
		     <G? ,MACGUFFIN-SCRIPT 3>>
		<BUT-THE ,MACGUFFIN>
		<TELL "is sound asleep!" CR>
		<RTRUE>)
	       (T
	        <RFALSE>)>>

<ROUTINE I-DULL-MACGUFFIN ()
	 <COND (<EQUAL? ,HERE ,INSIDE-POLICE-STATION>
	     	<SETG MACGUFFIN-SCRIPT <+ ,MACGUFFIN-SCRIPT 1>>
		<CRLF>
		<COND (<EQUAL? ,MACGUFFIN-SCRIPT 1>
		       <TELL
D ,MACGUFFIN " opens one eye as you enter">)
		      (<EQUAL? ,MACGUFFIN-SCRIPT 2>
		       <TELL
"\"Just drop my mail on the desk,\" " D ,MACGUFFIN " murmurs sleepily">)
		      (<EQUAL? ,MACGUFFIN-SCRIPT 3>
		       <TELL
"A voice crackles on the " D ,RADIO ". \"Ten-four,\" "
D ,MACGUFFIN " yawns">)
		      (<EQUAL? ,MACGUFFIN-SCRIPT 4>
		       <TELL D ,MACGUFFIN " begins to snore softly">)
		      (T
		       <DISABLE <INT I-DULL-MACGUFFIN>>
		       <TELL "The voice of">
		       <BOSS>
		       <TELL
", crackles to life on the " D ,RADIO ". \"">
		       <COND (<FSET? ,ENVELOPE ,RMUNGBIT> ; "Given?"
			      <TELL 
"Stop dawdling and deliver that">)
			     (T
			      <TELL 
"You " <PICK-ONE ,INSULTS> "! You forgot the">)>
		       <TELL " envelope!\" he " <PICK-ONE ,YELL-TYPES>>)>
		<TELL "." CR>)>>

<ROUTINE I-NASTY-MACGUFFIN ()
	 <COND (<OR ,FUZZY? ,ECLIPSE?>
		<RTRUE>)
	       (<EQUAL? ,HERE ,INSIDE-POLICE-STATION>
		<SETG MACGUFFIN-SCRIPT <+ ,MACGUFFIN-SCRIPT 1>>
		<CRLF>
		<COND (<EQUAL? ,MACGUFFIN-SCRIPT 1>
		       
		       <COND (<ZERO? ,JAIL-VISITS> ; "First visit"
		              <TELL
"\"It's past curfew,\" " D ,MACGUFFIN " growls as you enter. \"I hope you've got a very good reason for coming in here at this hour.\"" CR>)
			     
			     (T ; "Subsequent visits"
			      <SETG MACGUFFIN-SCRIPT 0>
			      <DISABLE <INT I-NASTY-MACGUFFIN>>
			      <COND (<IN? ,BRANCH ,PROTAGONIST>
				     <MOVE ,BRANCH ,ROTARY-WEST>)>
			      <TELL "\"You again!\" cries " D ,MACGUFFIN 
" as you enter. Moments later you're pinned to the floor by a dozen gigantic Boots. An especially tall Boot strides into the " D ,GLOBBY ", curls its leather tongue and leaves an ugly toeprint on your nice, clean clothes." CR CR D ,MACGUFFIN " shows you his ">
			      <SHARP-TEETH>
			      <TELL ". ">
			      
			      <COND (<EQUAL? ,JAIL-VISITS 1> ; "2nd visit"
			             <JAIL-AGAIN>
				     <TO-JAIL>)
				    (T                       ; "Last visit"
				     <TELL
"\"We don't want to trouble the Tower">
				     <SHARK-SNACK>
				     <THROWN-OVER-SHOULDER>
				     <INTO-BAY>)>)>)
		      
		      (<EQUAL? ,MACGUFFIN-SCRIPT 2>
		       <TELL
"\"You've got exactly one second to tell me why I shouldn't throw you in jail,\" notes " D ,MACGUFFIN " through clenched teeth." CR>)
		      
		      (T
		       <SETG MACGUFFIN-SCRIPT 0>
		       <DISABLE <INT I-NASTY-MACGUFFIN>>
		       <COND (<IN? ,BRANCH ,PROTAGONIST>
			      <MOVE ,BRANCH ,ROTARY-WEST>)>
		       <TELL "\"Your second's up.\"">
		       <TO-JAIL>)>)>>
			      
"*** MISS VOSS ***"

<GLOBAL VOSS-SCRIPT 0>

<OBJECT MISS-VOSS
	(IN ROTARY-SOUTH)
	(DESC "Miss Voss")
	(SYNONYM VOSS WOMAN LADY)
	(ADJECTIVE MISS MS)
	(FLAGS NDESCBIT ACTORBIT NARTICLEBIT)
	(ACTION VOSS-F)
	(CONTFCN IN-VOSS)>

<ROUTINE VOSS-F ("OPTIONAL" (CONTEXT <>) "AUX" RESPONSE)
	 <COND (<VERB? EXAMINE>
	        <COND (,SKEWED?
		       <TELL
"Her once kindly features have grown hard with cynicism">)
		      (T
		       <TELL
"She's holding a purse and an armful of books">)>
		<TELL "." CR>
		<RTRUE>)
	       (<IMAGE? ,MISS-VOSS>
		<RFATAL>)
	       (<TALKING-TO? ,MISS-VOSS>
		<COND (,SKEWED?
		       <SET RESPONSE ,BAD-VOSS-RESPONSES>)
		      (T
		       <SET RESPONSE ,GOOD-VOSS-RESPONSES>)>
		<TELL "\"" <PICK-ONE .RESPONSE> ",\" she replies." CR>
		<RFATAL>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,MISS-VOSS>>
		<PRINTD ,MISS-VOSS>
		<COND (<AND <EQUAL? ,PRSO ,COIN>
			    <HELD? ,COIN>
			    ,SKEWED?>
		       <MOVE ,COIN ,MISS-VOSS>
		       <SETG VOSS-SCRIPT -1>
		       <ENABLE <QUEUE I-VOSS-SUSPICIOUS -1>>
		       <FCLEAR ,TICKET ,RMUNGBIT>
		       <FCLEAR ,TICKET ,NDESCBIT>
		       <MOVE ,TICKET ,PROTAGONIST>
		       <TELL " snatches away your " D ,COIN
" with her bony fingers and hands you a " D ,TICKET ".">
		       <YOU-ARE-HOLDING ,TICKET>
		       <CRLF>
		       <CRLF>
		       <UPDATE-SCORE 3>)
		      (T
		       <TELL " shakes her head. \"I haven't any use for ">
		       <ARTICLE ,PRSO>
		       <TELL D ,PRSO "!\" she ">
		       <COND (,SKEWED?
			      <TELL "snarl">)
			     (T
			      <TELL "laugh">)>
		       <TELL "s." CR>)>
		<RTRUE>)
	       
	       (<AND <VERB? FOLLOW>
		     <NOT ,SKEWED?>
		     <EQUAL? ,HERE ,ROTARY-SOUTH>
		     <IN? ,MISS-VOSS ,THRONE-ROOM>>
		<MOVE ,MISS-VOSS ,ISLAND>
		<DO-WALK ,P?SOUTH>
		<RTRUE>)
	       (<AND <VERB? LISTEN>
		     <ENABLED? ,I-VOSS-SUSPICIOUS>>
		<TELL "\"M-Y-O-B!\" snaps " D ,MISS-VOSS "." CR>)
	       (T
	        <RFALSE>)>>

<ROUTINE IN-VOSS ("OPTIONAL" (CONTEXT <>))
	 <COND (<AND <EQUAL? .CONTEXT ,M-CONT>
		     <EQUAL? ,PRSA ,V?TAKE>
		     <NOT <EQUAL? ,PRSO ,VIOLET-NOTE>>>
		<NOT-LIKELY ,MISS-VOSS "would let you do that">
		<RTRUE>)
	       (T
		<RFALSE>)>>

<GLOBAL GOOD-VOSS-RESPONSES
        <LTABLE 0 
	 "I'm in a hurry. Let's talk later"
	 "I don't have time right now"
	 "Can we talk later? I'm in a hurry">>

<GLOBAL BAD-VOSS-RESPONSES
	<LTABLE 0 
	 "I don't have time for idle chatter"
	 "I'm here to sell tickets, not to chatter"
	 "I'm not paid to chatter with you">>

<OBJECT VOSS-THINGS
	(IN MISS-VOSS)
	(DESC "Miss Voss's things")
	(SYNONYM BOOKS BOOK PURSE THINGS)
	(FLAGS NDESCBIT TRYTAKEBIT NARTICLEBIT READBIT)
	(ACTION VOSS-THINGS-F)>

<ROUTINE VOSS-THINGS-F ()
	 <COND (<OR <TOUCHING? ,VOSS-THINGS>
		    <VERB? LOOK-INSIDE SEARCH>>
		<PRINTD ,MISS-VOSS>
		<MIGHT-NOT-LIKE>
		<RTRUE>)
	       (T
		<RFALSE>)>>  

<ROUTINE I-VOSS-CALLING ()
	 <COND (<AND <NOT ,SKEWED?>
		     <NOT ,NOTE-GIVEN?>
		     <EQUAL? ,HERE ,ROTARY-WEST ,PARK ,ROTARY-EAST>>
		<SOMEBODY-CALLING T>)>>

<GLOBAL NOTE-GIVEN? <>>

<ROUTINE I-VOSS-BABBLE ()
	 <COND (<EQUAL? ,HERE ,ROTARY-SOUTH>
		<THIS-IS-IT ,MISS-VOSS>
		<CRLF>
		<COND (<IN? ,VIOLET-NOTE ,MISS-VOSS>
		       <SETG ANGER <- ,ANGER 1>>
		       <COND (<ZERO? ,ANGER>
			      <VOSS-LEAVES>
			      <REMOVE ,VIOLET-NOTE>
			      <TELL D ,MISS-VOSS
" puts the " D ,VIOLET-NOTE " back in her purse. \"Very well,\" she says. \"If you won't take this note to " D ,CRISP 
" for me, I'll just have to do it myself.\"|
|
She closes her purse with an indignant snap and">
			      <VOSS-HURRIES>
			      <CRLF>
			      <CRLF>
			      <UPDATE-SCORE -10>)
			     (T
			      <THIS-IS-IT ,VIOLET-NOTE>
		              <TELL "\"" <PICK-ONE ,VOSS-OFFERS>
			            ",\" says " D ,MISS-VOSS
			            ", holding it out to you." CR>)>
		       <RTRUE>)>
		<SETG VOSS-SCRIPT <+ ,VOSS-SCRIPT 1>>
		<COND (<EQUAL? ,VOSS-SCRIPT 1>
		       <LIBRARIAN>
		       <TELL
", is locking the " D ,LIBRARY-DOOR " as you approach. \"Just the person I was looking for!\" she exclaims, smiling brightly.">)
		      (<EQUAL? ,VOSS-SCRIPT 2>
		       <MOVE ,VIOLET-NOTE ,MISS-VOSS>
		       <THIS-IS-IT ,VIOLET-NOTE>
		       <TELL D ,MISS-VOSS
" retrieves a violet slip of paper from the depths of her purse. \"Be a sweetie and give this note to your dear boss, " D ,CRISP ",\" she coos, holding the note out to you. \"I'd be ever so much obliged.\"">)
		      (T
		       <SETG NOTE-GIVEN? T>
		       <VOSS-HURRIES-AWAY>)>
		<CRLF>)>>

<ROUTINE VOSS-HURRIES-AWAY ()
	 <VOSS-LEAVES>
	 <PRINTD ,MISS-VOSS>
	 <VOSS-HURRIES>
	 <TELL " \"Thanks! Toody-loo!\"">>

<ROUTINE VOSS-LEAVES ()
	 <SETG ANGER 4>
	 <REMOVE ,VOSS-THINGS>
	 <MOVE ,MISS-VOSS ,THRONE-ROOM>
	 <DISABLE <INT I-VOSS-CALLING>>
	 <DISABLE <INT I-VOSS-BABBLE>>>

<ROUTINE VOSS-HURRIES ()
	 <TELL " hurries away down the street.">>

<GLOBAL VOSS-OFFERS
	<LTABLE 0
	 "Here's the note"
	 "This is the note I want you to take"
	 "Take this note">>

<ROUTINE I-VOSS-SUSPICIOUS ()
	 <COND (<OR ,FUZZY? ,ECLIPSE?>
		<RTRUE>)
	       (<EQUAL? ,HERE ,ROTARY-EAST>
		<SETG VOSS-SCRIPT <+ ,VOSS-SCRIPT 1>>
	        <COND (<ZERO? ,VOSS-SCRIPT>
		       <RFALSE>)>
		<CRLF>
		<COND (<EQUAL? ,VOSS-SCRIPT 1>
		       <TELL
"Out of the " D ,CORNER " of your eye, you notice " D ,MISS-VOSS
" squinting carefully at the " D ,COIN " you gave her. She looks at you suspiciously, picks up a telephone and begins to dial rapidly." CR>)
		      (<EQUAL? ,VOSS-SCRIPT 2>
		       <TELL D ,MISS-VOSS
" is talking urgently with someone on the phone. She doesn't take her eyes off you for a moment." CR>)
		      (<EQUAL? ,VOSS-SCRIPT 3>
      		       <TELL D ,MISS-VOSS 
" hangs up the phone and looks at you with triumph in her eyes." CR>)
		      (T
		       <DISABLE <INT I-VOSS-SUSPICIOUS>>
		       <SEE-VULTURE>)>)>>  

"*** SEAHORSE ***"

<OBJECT HORSE
	(IN WHARF)
	(DESC "seahorse")
	(SYNONYM SEAHORSE HORSE)
	(ADJECTIVE SEA LITTLE DYING)
	(FLAGS TAKEBIT)
	(ACTION HORSE-F)
	(DESCFCN DESCRIBE-HORSE)
	(VALUE 0)
	(SIZE 5)>

<GLOBAL HORSE-SAVED? <>>

<ROUTINE DESCRIBE-HORSE (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<COND (<FSET? ,HORSE ,TOUCHBIT>
		       <TELL "There's a dying " D ,HORSE " here">)
		      (T
		       <FSET ,HORSE ,TOUCHBIT>
		       <TELL "Apparently a careless fisherman has just left the wharf, for lying on the planks is a little " D ,HORSE ", its gills moving in and out with its dying gasps">)>
		<TELL ".">)>>

<ROUTINE HORSE-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "Poor thing. It's at the edge of death." CR>
		<RTRUE>)
	       (<TALKING-TO? ,HORSE>
		<SAY-THE ,HORSE>
		<TELL " is too busy dying to respond." CR>
		<RFATAL>)
	       (<VERB? RESCUE>
		<TELL "A noble idea. ">
		<HOW?>
		<RTRUE>)
	       (<HURT? ,HORSE>
		<TELL "Let the " D ,HORSE " die in peace, will you?" CR>
		<RTRUE>)
	       (T
	        <RFALSE>)>>

<GLOBAL HORSE-SCRIPT 4>

<ROUTINE I-HORSE-DEATH ()
	 <COND (<VISIBLE? ,HORSE>
		<SETG HORSE-SCRIPT <- ,HORSE-SCRIPT 1>>
		<CRLF>
		<COND (<EQUAL? ,HORSE-SCRIPT 3>
		       <SAY-THE ,HORSE>
		       <TELL
" looks at you with moist, frightened eyes">)
		      (<EQUAL? ,HORSE-SCRIPT 2>
		       <SAY-THE ,HORSE>
		       <TELL
" opens and closes its little mouth pathetically">)
		      (<EQUAL? ,HORSE-SCRIPT 1>
		       <SAY-THE ,HORSE>
		       <TELL
"'s gills are barely moving. It's practically dead">)
		      (T
		       <TELL
"With a barely perceptible sigh, the little " D ,HORSE " gives up its ghost">
		       <MOVE ,DHORSE <LOC ,HORSE>>
		       <REMOVE ,HORSE>
		       <DISABLE <INT I-HORSE-DEATH>>)>
		<TELL "." CR>)>>

<OBJECT DHORSE
	(DESC "dead seahorse")
	(SYNONYM SEAHORSE HORSE)
	(ADJECTIVE SEA DEAD LITTLE)
	(FLAGS TAKEBIT)
	(SIZE 1)
	(VALUE 0)
	(ACTION DHORSE-F)>

<ROUTINE DHORSE-F ()
	 <COND (<VERB? EXAMINE>
		<SAY-THE ,HORSE>
		<TELL " is dead." CR>
		<RTRUE>)
	       (<TALKING-TO? ,DHORSE>
		<NOT-LIKELY ,DHORSE "will respond">
		<RFATAL>)
	       (<OR <HURT? ,DHORSE>
		    <VERB? RESCUE>>
		<TELL "Too late. ">
		<PERFORM ,V?EXAMINE ,DHORSE>
		<RTRUE>)
	       (T
	        <RFALSE>)>>

"*** PELICAN ***"

<OBJECT PELICAN
	(IN FESTERON-POINT)
	(DESC "pelican")
	(SYNONYM PELICAN BIRD)
	(ADJECTIVE SLEEPY FAT)
	(FLAGS NDESCBIT ACTORBIT TRYTAKEBIT RMUNGBIT)
	(ACTION PELICAN-F)>

; "RMUNGBIT = Pelican has not recited magic word yet"

<ROUTINE PELICAN-F ("OPTIONAL" (CONTEXT <>))
	 <THIS-IS-IT ,PELICAN>
	 <COND (<OR <TALKING-TO? ,PELICAN>
		    <VERB? YELL>>
		<IT-IGNORES-YOU ,PELICAN>
		<RFATAL>)
	       (<VERB? EXAMINE>
		<TELL
"It's a fat old bird with a droopy beak">
		<COND (<IN? ,HAT ,PELICAN>
		       <TELL ", half-closed eyes and ">
		       <A-WIZARDS-HAT>)
		      (T
		       <TELL " and half-closed eyes." CR>)>
		<RTRUE>)
	       (<AND <VERB? LOOK-ON>
		     <IN? ,HAT ,PELICAN>>
		<TELL "It's wearing a " D ,HAT "." CR>
		<RTRUE>)
	       (<AND <VERB? GIVE FEED PUT-ON>
		     <EQUAL? ,PRSI ,PELICAN>>
		<COND (<EQUAL? ,PRSO ,BROOM>
		       <GET-OFF-BROOM-FIRST>)>
		<SAY-THE ,PELICAN>
		<TELL " sniffs ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO " suspiciously">
		<COND (<EQUAL? ,PRSO ,DHORSE ,CHOCOLATE ,WORM>
		       <REMOVE ,PRSO>
		       <TELL 
", then swallows it without a word of thanks.">)
		      (<EQUAL? ,PRSO ,MILK>
		       <TELL ", but refuses to take it.">)
		      (<EQUAL? ,PRSO ,WISHBRINGER>
		       <REMOVE ,WISHBRINGER>
		       <REMOVE ,PELICAN>
		       <EYES-OPEN>
		       <TELL " disappears with the " D ,PELICAN 
			     " as it flies off across the bay." CR>
		       <UPDATE-SCORE -10>
		       <RFATAL>)
 		      (<EQUAL? ,PRSO ,HAT>
		       <REMOVE ,HAT>
		       <REMOVE ,PELICAN>
		       <START-BUZZ 5>
		       <FCLEAR ,PELICAN ,RMUNGBIT>
		       <EYES-OPEN>
		       <TELL " quickly finds a place on the " D ,PELICAN
"'s head. Then the old bird gives you a sly, knowledgeable wink.|
|
All at once the " D ,LIGHTHOUSE " blazes to life! Its shining beacon whirls like a gyroscope, and a pencil-thin beam of light pierces the sky and traces a word on a passing cloud: " <GET ,POWER-WORDS ,POWER> ".|
|
The " D ,PELICAN>
		       <SOARS-AWAY-OVER>
		       <TELL "the bay. As the beam of the " D ,LIGHTHOUSE 
" fades, a voice in your head whispers, \"Good luck" ,ADVENTURER "!\"" CR CR>
		       <UPDATE-SCORE 5>
		       <RFATAL>)
		      (T
		       <MOVE ,PRSO ,FESTERON-POINT>
		       <TELL " and carelessly drops it at your feet.">)>
		<CRLF>
		<RTRUE>) 
	       (<HURT? ,PELICAN>
		<TELL "Imagine doing that to a defenseless " D ,PELICAN "!" CR>
		<RTRUE>)
	       (<AND <VERB? TAKE RUB KISS PLAY>
		     <EQUAL? ,PRSO ,PELICAN>>
		<SAY-THE ,PELICAN>
		<TELL " nips you with its beak. Ouch!" CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE EYES-OPEN ()
	 <TELL ". Its eyes open wide with interest, and the " D ,PRSO>> 

<GLOBAL POWER-WORDS <PTABLE "KALUZE" "FRATTO" "SORKIN">>

"*** OLD WOMAN ***"

<OBJECT OLD-WOMAN
	(DESC "old woman")
	(SYNONYM WOMAN LADY Y\'GAEL GAIL)
	(ADJECTIVE OLD)
	(FLAGS NDESCBIT ACTORBIT VOWELBIT)
	(ACTION OLD-WOMAN-F)>

<ROUTINE OLD-WOMAN-F ("OPTIONAL" (CONTEXT <>))
	 <THIS-IS-IT ,OLD-WOMAN>
	 <COND (<VERB? HELLO WAVE-AT>
		<SAY-THE ,OLD-WOMAN>
		<TELL " smiles kindly." CR>
                <RFATAL>)
	       
	     ; (<VERB? THANK REPLY>
		<SAY-THE ,OLD-WOMAN>
		<TELL " nods her acknowledgement." CR>
		<RFATAL>)
	       
	       (<AND <VERB? TELL THANK REPLY>
		     <EQUAL? ,PRSO ,OLD-WOMAN>>
		<COND (<PROB 50>
		       <SAY-THE ,OLD-WOMAN>)
		      (T
		       <TELL "She">)>
		<TELL " " <PICK-ONE ,LADY-REACTIONS> "." CR>
		<RFATAL>) 
	       
	       (<AND <VERB? ASK-ABOUT QUESTION>
		     <EQUAL? ,PRSO ,OLD-WOMAN>>
		<TELL "\"" <PICK-ONE ,Q-SIGHS> ",\" sighs the " 
		      D ,OLD-WOMAN " wistfully.">
		<COND (<PROB 50>
		       <TELL " \"" <PICK-ONE ,Q-EXCUSES> ".\"">)>
		<CRLF>
		<RFATAL>)
	       	       
	       (<AND <VERB? ASK-FOR>
		     <EQUAL? ,PRSO ,OLD-WOMAN>>
		<COND (<IN? ,PRSI ,OLD-WOMAN>
		       <PERFORM ,V?TAKE ,PRSI>)
		      (T
		       <SAY-THE ,OLD-WOMAN>
		       <TELL " tactfully ignores your request." CR>)>
		<RTRUE>)
	       
	       (<OR <HURT? ,OLD-WOMAN>
		    <VERB? KISS ALARM>>
		<SAY-THE ,OLD-WOMAN>
		<MIGHT-NOT-LIKE>
		<RTRUE>)
	       (<AND <VERB? READ>
		     <EQUAL? ,PRSI ,OLD-WOMAN>
		     <FSET? ,PRSO ,READBIT>>
		<COND (<EQUAL? ,PRSO ,RANSOM-LETTER>
		       <READ-LETTER-TO-WOMAN>)
		      (T
		       <PERFORM ,V?THANK ,OLD-WOMAN>)>
		<RTRUE>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,OLD-WOMAN>>
		<THIS-IS-IT ,PRSO>
		<COND (<EQUAL? ,PRSO ,ENVELOPE ,OPEN-ENVELOPE>
		       <COND (,WOMAN-SEEN-ENVELOPE?
			      <READ-BEG>
			      <RFATAL>)
		             (T
		              <SETG WOMAN-SEEN-ENVELOPE? 1>
		              <DISABLE <INT I-WOMAN-SCRIPT>>
		              <SETG ANGER 4>
			      <ENABLE <QUEUE I-READ-PROMPT -1>>
		              <UPDATE-SCORE 5>
			      <CRLF>
			      <SAY-THE ,OLD-WOMAN>
			      <TELL 
" turns pale as she takes the " D ,ENVELOPE 
" from you. \"It's been a long, long time since I last saw this handwriting,\" she murmurs, turning it over in her hands. \"Hoped I never would again.\"|
|
She starts to open the " D ,ENVELOPE ", thinks better of it and hands it back to you. \"Will you open it up and read it to me?\" she pleads. \"I'll never find my glasses in this mess.\"">
		              <YOU-ARE-HOLDING ,ENVELOPE T>)>)
		      
		      (<EQUAL? ,PRSO ,RANSOM-LETTER>
		       <READ-BEG>
		       <RFATAL>)

		      (T
		       <SAY-THE ,OLD-WOMAN>
		       <TELL " glances at ">
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO " and hands it back. \"You keep it, dear. I've got enough junk already.\"">)>
		<CRLF>
		<RTRUE>)

	       (T
		<RFALSE>)>>

<GLOBAL Q-SIGHS
	<LTABLE 0
	 "Ahhh"
	 "That's a long story"
	 "Not now">>

<GLOBAL Q-EXCUSES
	<LTABLE 0
	 "Some other time, perhaps"
	 "You're better off not knowing too much about it"
	 "Maybe later">>

<GLOBAL LADY-REACTIONS 
	<LTABLE 0
	 "nods vaguely"
	 "gives you a distracted smile"
	 "purses her lips"
	 "wrinkles her brow thoughtfully"
	 "rubs her chin">>

<GLOBAL WOMAN-SCRIPT 0>

<ROUTINE I-WOMAN-SCRIPT ()
	 <THIS-IS-IT ,OLD-WOMAN>
	 <COND (<EQUAL? ,HERE ,INSIDE-SHOPPE>
		<SETG WOMAN-SCRIPT <+ ,WOMAN-SCRIPT 1>>
		<CRLF>
		<COND (<EQUAL? ,WOMAN-SCRIPT 1>
		       <COND (<FSET? ,SHOPPE-DOOR ,OPENBIT>
			      <FCLEAR ,SHOPPE-DOOR ,OPENBIT>
			      <THIS-IS-IT ,SHOPPE-DOOR>
			    ; <SETG CLOSED-IN-SHOPPE? T>
			      <SUDDEN-GUST>
			      <TELL "slams the " D ,SHOPPE-DOOR " closed. ">
			      <BELL-TINKLES>
			      <CRLF>)>
		       <TELL
"\"Just a moment!\" cries a voice behind the " D ,CURTAIN ".">)

		      (<EQUAL? ,WOMAN-SCRIPT 2>
		       <THIS-IS-IT ,CLOCK>
		       <TELL 
"The noisy tick of the " D ,CLOCK " is making you uneasy.">)

		      (<EQUAL? ,WOMAN-SCRIPT 3>
		       <FCLEAR ,CLOCK ,RMUNGBIT>
		       <MOVE ,OLD-WOMAN ,INSIDE-SHOPPE>
		       <THIS-IS-IT ,OLD-WOMAN>
		       <SAY-THE ,CURTAIN>
		       <TELL
" opens so quickly it makes you jump.|
|
The woman standing before you is older than your oldest aunt. Her thin, pale face and bony hands make her look fragile, like a fading signature in an antique book. But her eyes remember everything they have ever seen.|
|
You appraise one another for a long moment before she breaks the ice. \"Welcome in, welcome!\" she chortles. \"Don't get many visitors this late in the day.\"|
|
The room seems oddly quiet all of a sudden.">)

		      (<EQUAL? ,WOMAN-SCRIPT 4>
		       <SETG ANGER 4>
		       <TELL 
"\"Hope you have some mail for me,\" the " D ,OLD-WOMAN " says eagerly.">)

		      (T
		       <SETG ANGER <- ,ANGER 1>>
		       <COND (<ZERO? ,ANGER>
			      <TELL "\"No mail, huh?\" says the woman with disappointment in her voice. \"Oh, well.\"">
			      <THROWN-OUT-OF-SHOPPE>)
			     (T
			      <TELL "\"" <PICK-ONE ,WOMAN-WAITS> ".\"">)>)>
		<CRLF>)>>

<GLOBAL WOMAN-WAITS
	<LTABLE 0  
	 "I hoped you might have some mail to give me"
	 "It's fun to get a surprise letter"
	 "I don't get much mail nowadays">>

<ROUTINE I-READ-PROMPT ()
	 <THIS-IS-IT ,OLD-WOMAN>
	 <COND (<EQUAL? ,WOMAN-SEEN-ENVELOPE? 1>
		<SETG WOMAN-SEEN-ENVELOPE? 2>
		<RTRUE>)>
	 <SETG ANGER <- ,ANGER 1>>
	 <CRLF>
	 <COND (<ZERO? ,ANGER>
		<TELL 
"\"Never mind, then,\" says the woman, taking the envelope">
		<COND (<FSET? ,OPEN-ENVELOPE ,TOUCHBIT>
		       <TELL " and letter">)>
		<TELL ". \"I'll read it myself later.\"">
		<THROWN-OUT-OF-SHOPPE>)
	       (T
		<READ-BEG>)>>

<ROUTINE READ-BEG ()
	 <TELL "\"">
	 <COND (<PROB 50>
		<TELL "Go ahead, dear. ">)>
	 <COND (<PROB 50>
		<TELL "Don't be bashful. ">)>
	 <COND (<FSET? ,OPEN-ENVELOPE ,TOUCHBIT>
		<THIS-IS-IT ,RANSOM-LETTER>
		<TELL "R">)
	       (T
		<THIS-IS-IT ,ENVELOPE>
		<TELL "Open the envelope and r">)>
	 <TELL "ead the letter to me">
	 <COND (<PROB 50>
		<TELL ", please">)>
	 <COND (<PROB 50>
		<TELL ". I'm waiting">)>
	 <TELL ".\"" CR>>

<GLOBAL LETTER-READ-TO-WOMAN? <>>

<ROUTINE READ-LETTER-TO-WOMAN ()
	 <COND (,LETTER-READ-TO-WOMAN?
		<TELL "\"Once was more than enough.\"" CR>)
	       (T
		<SETG LETTER-READ-TO-WOMAN? T>
		<DISABLE <INT I-READ-PROMPT>>
		<SETG WOMAN-SCRIPT -1>
		<SETG ANGER 4>
		<ENABLE <QUEUE I-RECRUIT -1>>
		<REMOVE ,RANSOM-LETTER>
		<REMOVE ,OPEN-ENVELOPE>
		<UPDATE-SCORE 1>
		<CRLF>
		<SAY-THE ,OLD-WOMAN>
		<TELL " is motionless as you read. Glancing up, you see tears of anger forming; but she turns away as your eyes meet.|
|
\"Kidnapped,\" she whispers after a long silence. She paces aimlessly around the room, deep in thought.|
|
\"Many seek to gain the Stone of Dreams,\" she mutters, mostly to herself. \"Yet few can imagine the price. For years I have fought to conceal it from" ,EONE " and others like her. My youth, my home and family, all were forfeited for its protection. And now,\" her voice breaking with emotion, \"now it claims my only companion.\"|
|
Impulsively, the woman snatches away the letter and envelope and crumples them in her trembling hands. \"No one is strong enough to guard " ,GAME " alone.\"" CR>)>>

<ROUTINE THROWN-OUT-OF-SHOPPE ()
	 <CRLF>
	 <CRLF>
	 <SAY-THE ,OLD-WOMAN>
	 <COND (<NOT <FSET? ,SHOPPE-DOOR ,OPENBIT>>
		<TELL " opens the " D ,HOUSE-DOOR " and">)>
	 <TELL " leads you gently but firmly out of the " D ,MAGICK-SHOPPE 
". \"Thanks for the visit. Good night!\"|
|
She slams the door shut in your face. ">
	 <BELL-TINKLES>
	 <FIRED>>

<GLOBAL IMMOBILIZED? <>>

<ROUTINE I-RECRUIT ()
	 <THIS-IS-IT ,OLD-WOMAN>
	 <COND (<IN? ,SNAKE-CAN ,OLD-WOMAN>
		<SETG ANGER <- ,ANGER 1>>
		<CRLF>
		<COND (<ZERO? ,ANGER>
		       <TELL 
"\"Oh, well. Never mind,\" shrugs the woman as she puts the " 
D ,SNAKE-CAN " away.">
		       <THROWN-OUT-OF-SHOPPE>)
		      (T
		       <THIS-IS-IT ,SNAKE-CAN>
		       <TELL "\"" <PICK-ONE ,CROW-OFFERS>
",\" says the " D ,OLD-WOMAN ", holding a " D ,SNAKE-CAN " out to you." CR>)>
		<RTRUE>)>
	 <SETG WOMAN-SCRIPT <+ ,WOMAN-SCRIPT 1>>
	 <COND (<ZERO? ,WOMAN-SCRIPT>
		<RFALSE>)>
	 <CRLF>
	 <COND (<EQUAL? ,WOMAN-SCRIPT 1>
		<THIS-IS-IT ,SNAKE-CAN>
		<MOVE ,SNAKE-CAN ,OLD-WOMAN>
		<SAY-THE ,OLD-WOMAN>
		<TELL
" makes an effort to compose herself.|
|
\"Thank you for coming all this way for me,\" she says, reaching up to a shelf full of cheap gags. \"I know I'm not supposed to tip you, but take this little trinket anyway.\"|
|
The woman holds out a small " D ,SNAKE-CAN " for you to take." CR>)

	       (<EQUAL? ,WOMAN-SCRIPT 2>
		<TELL 
"\"It's getting Dark outside,\" the " D ,OLD-WOMAN " remarks, and you can almost hear the capital D. \"Maybe you should be getting back to town.\"" CR>)

	       (<EQUAL? ,WOMAN-SCRIPT 3>
		<FSET ,SHOPPE-DOOR ,OPENBIT>
		<SETG IMMOBILIZED? T>
		<SAY-THE ,OLD-WOMAN>
		<TELL
" hobbles over to the " D ,SHOPPE-DOOR " and opens it. ">
		<BELL-TINKLES>
		<TELL CR 
"\"Keep a sharp eye out for my cat, won't you?\" She speaks the words slowly and distinctly. \"Bring her to me if you find her. ">
		<DESCRIBE-CHAOS T>
		<TELL "... right HERE.\"" CR CR>
		<SAY-THE ,OLD-WOMAN>
		<TELL
" touches the middle of your forehead with her finger. The light outside dims suddenly, like a cloud passing over the sun." CR>)

	       (<EQUAL? ,WOMAN-SCRIPT 4>
		<SETG IMMOBILIZED? <>>
		<SAY-THE ,OLD-WOMAN>
		<TELL
" takes away her finger. Your forehead is tingling.|
|
\"The Stone of Dreams can help you in your search. I cannot reveal the place where I have hidden it, for" ,EONE " would see your thoughts and take the treasure for herself. You must discover it alone, and rely on legends to instruct you in its mysteries.\"|
|
As she speaks, the " D ,OLD-WOMAN " gently leads you through the door of the "
D ,MAGICK-SHOPPE ". She pauses before closing the door.|
|
\"Return the cat to me, and " ,GAME " shall be yours.|
|
\"Her name is " D ,CHAOS ".\"" CR CR>
		<BELL-TINKLES>
		<DISABLE <INT I-RECRUIT>>
		<MOVE ,PROTAGONIST ,CLIFF-EDGE>
		<SKEW>
		<COND (<L? ,SCORE 18>
		       <SETG SCORE 18>
		       <SETG MOVES 0>)>
		<SETG HERE ,CLIFF-EDGE>
		<CARRIAGE-RETURNS>
	        <V-LOOK>
	        <ENABLE <QUEUE I-BEFORE-MOONSET -1>>
	        <SETG WOMAN-SCRIPT -1>
		<ENABLE <QUEUE I-FOG-RISING -1>>)>>

<GLOBAL CROW-OFFERS
	<LTABLE 0
	 "Take this. It's a gift"
	 "Take this gift"
	 "This gift is for you. Take it">>

<GLOBAL SKEWED? <>>

<ROUTINE SKEW ("AUX" OBJ NXT)
	 	 
       ; "Clear TOUCHBITs of all rooms."

	<SET OBJ <FIRST? ,ROOMS>>
	<REPEAT ()
		<COND (.OBJ
		       <FCLEAR .OBJ ,TOUCHBIT>
		       <SET OBJ <NEXT? .OBJ>>)
		      (T
		       <RETURN>)>>

       ; "BRIDGE and SHOPPE"

	 <FCLEAR ,MAGICK-SHOPPE ,TOUCHBIT>
	 <FCLEAR ,SHOPPE-DOOR ,OPENBIT>
	 <FSET ,SHOPPE-DOOR ,LOCKEDBIT>
	 <FCLEAR ,SNAKE-CAN ,OPENBIT>
	 <SETG SNAKE-GONE? <>>

	 <MOVE ,VULTURE ,GNARLED-TREE>
	 <MOVE ,TROLL ,NORTH-OF-BRIDGE>
	 <MOVE ,TOLL-GATE ,NORTH-OF-BRIDGE>

       ; "NORTH"

	 <FCLEAR ,SMALL-BOX ,NDESCBIT>
	 <MOVE ,SMALL-BOX ,WEST-OF-HOUSE>
	 
       ; "WEST"

	 <FCLEAR ,LAKE-SAND ,RMUNGBIT>
	 <COND (<FSET? ,PIT ,OPENBIT>
		<FSET ,LAKE-SAND ,TOOLBIT>)
	       (T
		<REMOVE ,LEAVES>
		<FSET ,PIT ,OPENBIT>
		<MOVE ,PLATYPUS ,PIT>)>
	 
       ; "CENTER"

	 <MOVE-ALL ,FOUNTAIN ,STEEP-TRAIL>
	 <MOVE ,PIRANHA ,FOUNTAIN>
	 <MOVE ,TOKEN ,FOUNTAIN>
	 
	 <MOVE ,BOOTS ,FESTERON-POINT>
	 <ENABLE <QUEUE I-BOOT-PATROL -1>>
	 
	 <COND (<ENABLED? ,I-DULL-MACGUFFIN>
		<DISABLE <INT I-DULL-MACGUFFIN>>)>
	 <SETG MACGUFFIN-SCRIPT 0>
	 <COND (<IN? ,CHOCOLATE ,DESK>
		<REMOVE ,CHOCOLATE>)
	       (T
		<FCLEAR ,CHOCOLATE ,NDESCBIT>)>
	 <ENABLE <QUEUE I-BREAK-IN -1>>
	      
	 <COND (<NOT ,NOTE-GIVEN?>
		<DISABLE <INT I-VOSS-CALLING>>
		<DISABLE <INT I-VOSS-BABBLE>>
		<REMOVE ,VIOLET-NOTE>
		<REMOVE ,VOSS-THINGS>)>
	 
	 <MOVE ,MISS-VOSS ,ROTARY-EAST>
	 <MOVE ,TICKET ,MISS-VOSS>
	 <MOVE ,GRAVEDIGGER ,LOBBY>
	 <FSET ,ENTRANCE ,OPENBIT>
	 <FCLEAR ,ENTRANCE ,LOCKEDBIT>
	 <SETG VOSS-SCRIPT 0>
	
	 <MOVE ,CDEBRIS ,INSIDE-CHURCH>
	 <COND (<ENABLED? ,I-RODENT>
		<DISABLE <INT I-RODENT>>)>
	 <FSET ,CHURCH ,RMUNGBIT>
	 <FSET ,CHURCH ,TOUCHBIT>
	 <FSET ,CHURCH ,TOOLBIT>
	 <MOVE ,SPEAKER ,INSIDE-CHURCH>
	
       ; "SOUTH"

	 <SETG POODLE-HAPPY? <>>	 
	 <REMOVE ,POODLE>
	 
	 <SETG POOCH ,HELLHOUND>
	 <MOVE ,HELLHOUND ,OUTSIDE-COTTAGE>
	 
       ; <MOVE ,SCOPE ,HILLTOP>
	 <FSET ,HILLTOP ,WETBIT>
	 <MOVE ,MOAT ,HILLTOP>
	 <SETG CRISP-SCRIPT 0>
	 <FCLEAR ,CRISP ,TOUCHBIT>

       ; "CEMETERY"

	 <COND (<ENABLED? ,I-DIGGER-TALK>
		<DISABLE <INT I-DIGGER-TALK>>)>
	 <SETG DIGGER-SCRIPT 0>
         <FSET ,SOUTH-GATE ,OPENBIT>
       	 <FCLEAR ,SOUTH-GATE ,LOCKEDBIT>
       ; <FSET ,NORTH-GATE ,LOCKEDBIT>
       ; <FCLEAR ,NORTH-GATE ,OPENBIT>
	 <ENABLE <QUEUE I-CREAK -1>>
	 <FSET ,VAPORS ,ACTORBIT>
	 	 
       ; "EAST"

	 <COND (<NOT <ACCESSIBLE? ,HORSE>>
		<REMOVE ,HORSE>)>
	 <MOVE ,HUMANOIDS ,VIDEO-ARCADE>
	 <MOVE ,SHARKS ,WHARF>

	 <MOVE-ALL ,MAILBOX ,FOSSIL>
	 
	 <SETG SKEWED? T>>