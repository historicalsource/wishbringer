"CENTER for WISHBRINGER: (C)1985 Infocom, Inc. All rights reserved."

"*** ROTARY EAST (THEATER) ***"

<OBJECT ROTARY-EAST
	(IN ROOMS)
	(DESC "Rotary East")
	(FLAGS ONBIT RLANDBIT)
	(GLOBAL MOVIE-THEATER ENTRANCE CORNER GLOBBY)
	(NORTH TO ROTARY-NORTH)
	(EAST PER ENTER-PLEASURE-WHARF)
	(SOUTH PER ENTER-ROTARY-SOUTH)
	(WEST TO PARK)
	(IN PER ENTER-THEATER?)
	(PSEUDO "ROTARY" HERE-F)
	(ACTION ROTARY-EAST-F)>

<ROUTINE ENTER-THEATER? ()
	 <COND (,SKEWED?
		<COND (<FSET? ,TICKET ,RMUNGBIT>
		       <TELL "\"You won't get far without a " D ,TICKET
                             "!\" cries " D ,MISS-VOSS "." CR CR>)>
		<COND (<DIGGER-PISSED?>
		       <RFALSE>)
		      (T
		       <COND (<NOT <ENABLED? ,I-FILM>>
		              <ENABLE <QUEUE I-FILM -1>>)>
		       <THIS-IS-IT ,TICKET>
		       <RETURN ,LOBBY>)>)
	       (T
		<ITS-CLOSED ,MOVIE-THEATER>
		<RFALSE>)>>
		       
<ROUTINE DIGGER-PISSED? ()
	 <THIS-IS-IT ,GRAVEDIGGER>
	 <COND (<FSET? ,GRAVEDIGGER ,RMUNGBIT>
		<COND (<ENABLED? ,I-FILM>
		       <STOP-FILM>)>
		<SETG NO-MOVIE? T>
		<TELL "As you appear in the " D ,GLOBBY " the " D ,GRAVEDIGGER
		      " promptly throws you ">
		<COND (<EQUAL? ,HERE ,ROTARY-EAST>
		       <TELL "back">)
		      (T
		       <TELL "out">)>
		<TELL " into the street. \"Sneak past me, eh? Scram!\"" CR CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>
	       
<ROUTINE ROTARY-EAST-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're on the eastern side of the">
		<WHICH-TOWN "Rotary">
		<TELL ". A street branches off " <TO-E> ", towards the bay.|
|
On the " D ,CORNER " nearby stands a ">
		<COND (,SKEWED?
		       <TELL "sleazy">)
		      (T
		       <TELL "charming">)>
		<TELL " little " D ,MOVIE-THEATER ". Showtimes and admission prices are listed on a " D ,SCHEDULE " near the">
		<OPEN-CLOSED ,ENTRANCE>
		<TELL D ,ENTRANCE ", and a " D ,MARQUEE 
		      " announces the current feature.">
   		<COND (,SKEWED?
		       <CRLF>
		       <CRLF>
		       <LIBRARIAN>
		       <TELL ", is peering at you suspiciously.">)>
		<CRLF>)>>

<OBJECT MOVIE-THEATER
	(IN LOCAL-GLOBALS)
	(DESC "movie theater")
	(SYNONYM THEATER THEATRE CINEMA BUILDING)
	(ADJECTIVE MOVIE SLEAZY CHARMING PALACE)
	(FLAGS NDESCBIT)
	(ACTION MOVIE-THEATER-F)>

<ROUTINE MOVIE-THEATER-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "It looks like ">
	        <COND (,SKEWED?
		       <TELL "it ought to be condemned">)
		      (T
		       <TELL "the perfect place to enjoy an old movie">)>
		<TELL "." CR>
		<RTRUE>)
	       (<VERB? SEARCH>
		<COND (<EQUAL? ,HERE ,INSIDE-THEATER>
		       <PERFORM ,V?LOOK-UNDER ,SEAT>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<VERB? WALK-TO ENTER THROUGH>
		<COND (<EQUAL? ,HERE ,ROTARY-EAST ,LOBBY>
		       <DO-WALK ,P?IN>)
		      (T
		       <ALREADY-IN ,MOVIE-THEATER>)>
		<RTRUE>)
	       (<VERB? EXIT>
		<COND (<EQUAL? ,HERE ,LOBBY ,INSIDE-THEATER>
		       <DO-WALK ,P?OUT>)
		      (T
		       <ALREADY-IN ,MOVIE-THEATER T>)>
		<RTRUE>)
	       
	       (<VERB? LOOK-INSIDE>
		<COND (<EQUAL? ,HERE ,ROTARY-EAST>
		       <COND (<FSET? ,ENTRANCE ,OPENBIT>
			      <GO-INSIDE>)
			     (T
			      <ITS-CLOSED ,ENTRANCE>)>)
		      (T
		       <V-LOOK>)>
		<RTRUE>)
	       (<AND <EQUAL? ,HERE ,INSIDE-THEATER>
		     ,MOVIE-VISIBLE?>
		<IMAGE? ,MOVIE-THEATER>
		<RFATAL>)
	       (<ENTRANCE-F>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT MARQUEE
	(IN ROTARY-EAST)
	(DESC "marquee")
	(SYNONYM MARQUEE)
	(FLAGS READBIT NDESCBIT)
	(ACTION MARQUEE-F)>

<ROUTINE MARQUEE-F ()
	 <COND (<VERB? EXAMINE READ>
		<COND (,SKEWED?
		       <FIXED-FONT-ON>
		       <TELL CR
"    Now Playing!|
THE ONE IS WATCHING!|
      starring|
    THE EVIL ONE|
         in|
    Amazing 3-D!" CR>
		       <FIXED-FONT-OFF>)
		      (T
		       <SAY-THE ,MARQUEE>
		       <TELL " shows an outline of">
		       <BOSS>
		       <TELL
", triumphantly stepping on the face of a helpless mail clerk. Underneath are the words \"">
		       <COND (<FSET? ,ENVELOPE ,RMUNGBIT> ; "Given?"
			      <TELL 
"Have You Delivered That Envelope Yet?">)
			     (T
			      <TELL 
"You Forgot Something At The " D ,POST-OFFICE "!">)>
		       <TELL "\" in big red letters." CR>)>
		<RTRUE>)
	       (<HURT? ,MARQUEE>
		<MUNG-THEATER>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT ENTRANCE
	(IN LOCAL-GLOBALS)
	(DESC "entrance")
	(SYNONYM ENTRANCE ENTRY DOOR LOCK)
      ; (ADJECTIVE THEATER)
	(FLAGS DOORBIT LOCKEDBIT NDESCBIT)
	(ACTION ENTRANCE-F)>

<ROUTINE ENTRANCE-F ()
         <COND (<VERB? EXAMINE>
		<COND (<FSET? ,ENTRANCE ,OPENBIT>
		       <TELL "It's open." CR>)
		      (T
		       <ITS-CLOSED ,ENTRANCE>)>
		<RTRUE>)
	       (<VERB? OPEN>
		<COND (,SKEWED?
		       <ALREADY-OPEN>)
		      (T
		       <ITS-CLOSED ,ENTRANCE>)>
		<RTRUE>)
       	       (<VERB? CLOSE>
		<COND (,SKEWED?
		       <MUNG-THEATER>)
		      (T
		       <ITS-CLOSED ,ENTRANCE>)>
		<RTRUE>)
	       (<USE-DOOR? ,ROTARY-EAST>
		<RTRUE>)
	       (<HURT? ,ENTRANCE>
		<MUNG-THEATER>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,ENTRANCE>
		<RFATAL>)>>

<ROUTINE MUNG-THEATER ()
	 <TELL "The people who own the " D ,MOVIE-THEATER>
	 <MIGHT-NOT-LIKE>>

<OBJECT TICKET
	(DESC "ticket")
	(SYNONYM TICKET STUB)
	(ADJECTIVE MOVIE)
	(FLAGS NDESCBIT TAKEBIT RMUNGBIT)
	(VALUE 0)
	(SIZE 1)
	(ACTION TICKET-F)>

; "RMUNGBIT = ticket not bought, TOOLBIT = ticket given to gravedigger"

<ROUTINE TICKET-F ()
	 <COND (<AND <VERB? BUY>
		     <EQUAL? ,PRSO ,TICKET>>
		<COND (<OR <NOT ,SKEWED?>
			   <NOT <IN? ,MISS-VOSS ,HERE>>>
		       <TELL "There's nobody here to sell you one." CR>)
		      (,PRSI
		       <COND (<EQUAL? ,PRSI ,COIN>
			      <PERFORM ,V?GIVE ,COIN ,MISS-VOSS>)
			     (T
			      <NOT-LIKELY ,MISS-VOSS "would accept that">)>)
		      (<HELD? ,COIN>
		       <WITH-COIN>
		       <PERFORM ,V?GIVE ,COIN ,MISS-VOSS>)
		      (T
		       <NO-MONEY>)>
		<RTRUE>)
	       (<AND ,SKEWED?
		     <IN? ,TICKET ,MISS-VOSS>>
		<TELL "You'll have to buy one from ">
		<COND (<EQUAL? ,HERE ,ROTARY-EAST>
		       <PRINTD ,MISS-VOSS>)
		      (T
		       <TELL "somebody">)>
		<TELL "." CR>
		<RTRUE>)
	       (<VERB? EXAMINE READ>
		<TELL "It's an ordinary " D ,TICKET ", number 802701." CR>
		<RTRUE>)
	       (<HURT? ,TICKET>
		<RUIN ,TICKET>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT LOBBY
	(IN ROOMS)
	(DESC "Theater Lobby")
	(FLAGS ONBIT RLANDBIT INDOORSBIT)
	(GLOBAL MOVIE-THEATER ENTRANCE CORNER CORRIDOR GLOBBY SCREEN)
	(NORTH PER ENTER-AUDITORIUM?)
	(OUT PER EXIT-LOBBY)
	(IN PER ENTER-AUDITORIUM?)
	(ACTION LOBBY-F)>

<ROUTINE LOBBY-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<STANDING>
		<TELL 
"in the " D ,GLOBBY " of the " D ,MOVIE-THEATER ". A short " D ,CORRIDOR " leads north into ">
		<COND (<L? ,MOVIE-SCRIPT 6>
		       <TELL D ,DARKNESS ". Sound effects and music can be heard drifting down the " D ,CORRIDOR>)
		      (T
		       <TELL "silent " D ,DARKNESS>)>
		<TELL "." CR CR>
		<SAY-THE ,GRAVEDIGGER>
		<TELL " is standing near the " D ,CORRIDOR
", a large cardboard " D ,CARTON " at his feet." CR>)>>

<ROUTINE EXIT-LOBBY ()
	 <COND (,ECLIPSE?
		<SAY-THE ,GRAVEDIGGER>
		<DIGGER-STUMBLES>
		<RFALSE>)
	       (<AND <FSET? ,TICKET ,TOOLBIT>
		     <FSET? ,GLOBBY ,TOUCHBIT>>
		<SAY-SURE>
		<TELL "leave the " D ,MOVIE-THEATER "? The " D ,GRAVEDIGGER
		      " might not let you in again without another "
		      D ,TICKET "!">
		<COND (<YES?>
		       <FCLEAR ,GLOBBY ,TOUCHBIT>
		       <SETG NO-MOVIE? T>
		       <STOP-FILM>
		       <TELL "\"Come again!\" sneers the " D ,GRAVEDIGGER
			     " as you leave." CR CR>)
		      (T
		       <TELL ,OKAY "you're still in the " D ,GLOBBY "." CR>
		       <RFALSE>)>)>
	 <RETURN ,ROTARY-EAST>>
		       
<OBJECT GLOBBY
	(IN LOCAL-GLOBALS)
	(DESC "lobby")
	(SYNONYM LOBBY)
	(FLAGS NDESCBIT TOUCHBIT)
	(ACTION GLOBBY-F)>

; "TOUCHBIT = no lobby warning given"

<ROUTINE GLOBBY-F ()
	 <COND (<VERB? ENTER WALK-TO THROUGH>
		<COND (<EQUAL? ,HERE ,ROTARY-EAST>
		       <DO-WALK ,P?IN>)
		      (<EQUAL? ,HERE ,INSIDE-THEATER>
		       <DO-WALK ,P?OUT>)
		      (T
		       <ALREADY-IN ,GLOBBY>)>
		<RTRUE>)
	       (<VERB? EXIT LEAVE>
		<COND (<EQUAL? ,HERE ,INSIDE-THEATER>
		       <DO-WALK ,P?OUT>)
		      (<EQUAL? ,HERE ,LOBBY>
		       <V-WALK-AROUND>)
		      (T
		       <ALREADY-IN ,GLOBBY T>)>)
	       (<NOT <EQUAL? ,HERE ,LOBBY>>
		<YOUD-HAVE-TO "go into" ,GLOBBY>
		<RFATAL>)
	       (<VERB? EXAMINE LOOK-INSIDE>
		<V-LOOK>
		<RTRUE>)	       
	       (T
		<YOU-DONT-NEED ,GLOBBY>
		<RFATAL>)>>

<GLOBAL NO-MOVIE? T>
<GLOBAL MOVIE-STATUS T>

<ROUTINE ENTER-AUDITORIUM? ()
	 <SAY-THE ,GRAVEDIGGER>
	 <COND (,ECLIPSE?
		<COND (<FSET? ,TICKET ,TOOLBIT>
		       <DIGGER-STUMBLES>
		       <RFALSE>)
		      (T
		       <TELL " cries, \"Don't leave me alone!\"">
		       <FSET ,GRAVEDIGGER ,RMUNGBIT>)>)
	       (T
		<COND (,NO-MOVIE?
		       <TELL " blocks your path. \"" 
			     <PICK-ONE ,NO-ENTERS> ".\"" CR>
		       <RFALSE>)
		      (T
		       <TELL " nods as you pass.">)>)>
	 <CRLF>
	 <CRLF>
         <RETURN ,INSIDE-THEATER>>

<ROUTINE DIGGER-STUMBLES ()
	 <TELL " stumbles into your path. \"Help! It's dark!\"" CR>>

<GLOBAL NO-ENTERS
	<LTABLE 0 
	 "Ticket, please"
	 "Can't get in without a ticket"
	 "No ticket, no movie">>

<OBJECT CARTON
	(IN LOBBY)
	(DESC "carton")
	(SYNONYM CARTON BOX)
	(ADJECTIVE CARDBOARD)
	(FLAGS READBIT TRYTAKEBIT NDESCBIT CONTBIT OPENBIT)
	(CAPACITY 10)
	(ACTION CARTON-F)>

<GLOBAL LOOKED-IN-CARTON? <>>

<ROUTINE CARTON-F ()
	 <COND (<VERB? EXAMINE READ LOOK-ON>
		<TELL 
"The open " D ,CARTON " is marked, \"Free 3D Movie Glasses Here!\"" CR>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE>
		<COND (<FIRST? ,CARTON>
		       <TELL ,YOU-SEE>
		       <PRINT-CONTENTS ,CARTON>
		       <TELL " inside">)
		      (T
		       <TELL "It's empty">)>
		<TELL "." CR>
		<COND (<NOT ,LOOKED-IN-CARTON?>
		       <SETG LOOKED-IN-CARTON? T>
		       <CRLF>
		       <SAY-THE ,GRAVEDIGGER>
		       <TELL 
" sees your disappointment, shrugs and mumbles something unkind about newfangled thingamabobs." CR>)>
		<RTRUE>)
	       (<AND <VERB? PUT THROW>
		     <EQUAL? ,PRSI ,CARTON>>
		<COND (<G? <GETP ,PRSO ,P?SIZE> 10>
		       <TOO-LARGE ,PRSO>)
		      (<EQUAL? ,PRSO ,TICKET>
		       <PERFORM ,V?GIVE ,TICKET ,GRAVEDIGGER>
		       <RTRUE>)
		      (T
		       <SAY-THE ,GRAVEDIGGER>
		       <TELL " pulls ">
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO " out of the " D ,CARTON " and hands it back to you. \"Keep it,\" he mutters." CR>)>
		<RTRUE>)
	       (<OR <HURT? ,CARTON>
		    <AND <VERB? TAKE>
		         <EQUAL? ,PRSO ,CARTON>>>
		<SAY-THE ,GRAVEDIGGER>
		<MIGHT-NOT-LIKE>
		<RTRUE>)
	       (<VERB? CLOSE>
		<TELL "There's no lid." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT SCHEDULE
	(IN ROTARY-EAST)
	(DESC "schedule")
	(SYNONYM SCHEDULE LIST SHOWTIMES PRICES)
	(ADJECTIVE ADMISSION TIMES)
	(FLAGS NDESCBIT READBIT)
	(ACTION SCHEDULE-F)>

<ROUTINE SCHEDULE-F ()
	 <COND (<VERB? READ EXAMINE>
		<SAY-THE ,SCHEDULE>
		<TELL " says:" CR CR>
		<FIXED-FONT-ON>
		<COND (,SKEWED?
		       <TELL "    OPEN ALL NIGHT!">)
		      (T
		       <TELL "   EVENINGS AT 7 & 9">)>
		<TELL CR "ALL SHOWS ONE GOLD COIN" CR>
		<FIXED-FONT-OFF>
		<RTRUE>)
	       (<HURT? ,SCHEDULE>
		<MUNG-THEATER>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT INSIDE-THEATER
	(IN ROOMS)
	(DESC "Inside Theater")
	(FLAGS ONBIT RLANDBIT INDOORSBIT)
	(GLOBAL MOVIE-THEATER CORRIDOR GLOBBY AISLE SCREEN)
	(OUT PER EXIT-AUDITORIUM?)
	(SOUTH PER EXIT-AUDITORIUM?)
	(ACTION INSIDE-THEATER-F)>

<ROUTINE INSIDE-THEATER-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL
"This is a " D ,MOVIE-THEATER " unlike any you've ever seen! The seats are wide, deep and comfortable. The aisles are spotless. The air is clear of smoke, and the screen is dramatically large. A chill goes up your spine as you realize how alien your universe has become." CR CR>
		<COND (<OR <EQUAL? ,MOVIE-SCRIPT 6>
			   ,ECLIPSE?>
		       <SAY-THE ,MOVIE-THEATER>
		       <TELL " screen is dark and silent">)
		      (T
		       <TELL "There's a noisy movie playing on the screen">)>
		<TELL 
". A dark " D ,CORRIDOR " leads out to the " D ,GLOBBY "." CR>)>>

<OBJECT SEAT
	(IN INSIDE-THEATER)
	(DESC "seat")
	(SYNONYM SEAT SEATS CHAIR CHAIRS)
	(FLAGS NDESCBIT SURFACEBIT)
	(CAPACITY 10)
	(ACTION SEAT-F)>

; "TOOLBIT = sitting"

<ROUTINE SEAT-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "They look really comfortable." CR>
		<RTRUE>)
	       
	       (<AND <VERB? LOOK-INSIDE LOOK-ON>
		     <FSET? ,SEAT ,TOOLBIT>>
		<ALREADY-IN ,SEAT>
		<RTRUE>)
		      
	       (<VERB? SIT CLIMB-ON ENTER>
		<COND (<FSET? ,SEAT ,TOOLBIT>
		       <ALREADY-IN ,SEAT>
		       <RTRUE>)
		      (<FIRST? ,SEAT>
		       <TELL "You'll have to clear it off first.">)
		      (T
		       <FSET ,SEAT ,TOOLBIT>
		       <TELL 
"Done. The seat is even more comfortable than it looks.">)>
		<CRLF>
		<RTRUE>)
	       (<VERB? STAND EXIT TAKE-OFF>
		<COND (<FSET? ,SEAT ,TOOLBIT>
		       <FCLEAR ,SEAT ,TOOLBIT>
		       <TELL 
"With a reluctant sigh, you rise from the comfortable seat.">)
		      (T
		       <TELL "But you're already standing!">)>
		<CRLF>
		<RTRUE>)
	       (<VERB? LOOK-UNDER SEARCH>
		<COND (<FSET? ,GLASSES ,RMUNGBIT>
		       <FCLEAR ,GLASSES ,RMUNGBIT>
		       <MOVE ,GLASSES ,INSIDE-THEATER>)>
		<COND (<NOT <FSET? ,GLASSES ,TOUCHBIT>>
		       <TELL "Hmm. This place isn't completely spotless. You just discovered a used " D ,GLASSES " under a seat." CR>)
		      (T
		       <RFALSE>)>)
	       (<OR <HURT? ,SEAT>
		    <VERB? STAND-ON LIE-DOWN>>
		<MUNG-THEATER>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT AISLE
	(IN LOCAL-GLOBALS)
	(DESC "aisle")
	(SYNONYM AISLE AISLES)
	(FLAGS NDESCBIT)
	(ACTION AISLE-F)>

<ROUTINE AISLE-F ()
	 <COND (<GROUND-F>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,AISLE>
		<RFATAL>)>>

<ROUTINE EXIT-AUDITORIUM? ()
	 <COND (<FSET? ,SEAT ,TOOLBIT>
		<YOUD-HAVE-TO "get out of" ,SEAT>
		<RFALSE>)
	       (<AND <IN? ,GLASSES ,PROTAGONIST>
		     <FSET? ,GLASSES ,WORNBIT>>
		<SETG FUZZY-FROM ,LOBBY>
		<SETG FUZZY? T>
		<RETURN ,FUZZY>)
	       (<DIGGER-PISSED?>
		<RETURN ,ROTARY-EAST>)
	       (T
		<RETURN ,LOBBY>)>>

<ROUTINE CHEAP-GLASSES ()
	 <TELL " a cheap pair of sunglasses." CR>>

<OBJECT GLASSES
	(DESC "pair of 3D glasses")
	(SYNONYM GLASSES SPECTACLES SUNGLASSES PAIR)
	(ADJECTIVE 3D CHEAP)
	(FLAGS TAKEBIT WEARBIT RMUNGBIT)
	(VALUE 3)
	(SIZE 3)
	(ACTION GLASSES-F)>

; "RMUNGBIT = glasses not yet found"

<ROUTINE GLASSES-F ()
         <THIS-IS-IT ,GLASSES>
	 <COND (<VERB? EXAMINE>
		<TELL "They resemble">
		<CHEAP-GLASSES>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE>
		<COND (<DONT-HAVE? ,GLASSES>
		       <RTRUE>)>
		<TELL "It's like peering through">
		<CHEAP-GLASSES>
		<RTRUE>)
	       
       	       (<AND <VERB? LOOK-THRU>
		     <EQUAL? ,PRSI ,GLASSES>>
		<COND (<DONT-HAVE? ,GLASSES>
		       <RTRUE>)
		      (<NOT <FSET? ,GLASSES ,WORNBIT>>
		       <YOUD-HAVE-TO "be wearing" ,GLASSES>
		       <RTRUE>)>
		<PERFORM ,V?EXAMINE ,PRSO>
		<RTRUE>)
	       		       
	       (<AND <VERB? FIND>
		     <EQUAL? ,HERE ,LOBBY ,INSIDE-THEATER>
		     <FSET? ,GLASSES ,RMUNGBIT>>
		<TELL 
"You don't see any here. But somebody may have dropped a pair nearby." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE BLANK-SCREEN ()
	 <SAY-THE ,SCREEN>
	 <TELL " is blank and silent." CR>>

<OBJECT SCREEN
	(IN LOCAL-GLOBALS)
	(DESC "movie screen")
	(SYNONYM SCREEN FILM SHOW MOVIE)
	(ADJECTIVE SOUNDTRACK IMAGE PICTUR)
	(FLAGS NDESCBIT)
	(ACTION SCREEN-F)>

<ROUTINE SCREEN-F ()
	 <COND (<VERB? LISTEN>
		<PERFORM ,V?LISTEN ,SOUND>
		<RTRUE>)
	       (<EQUAL? ,HERE ,LOBBY>
		<CANT-SEE-ANY>
		<RFATAL>)
	       (<VERB? EXAMINE LOOK-ON>
		<COND (<NOT <ENABLED? ,I-FILM>>
		       <BLANK-SCREEN>)>
		<SETG NO-CR? T>
		<RTRUE>)
	       (<HURT? ,SCREEN>
		<MUNG-THEATER>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<GLOBAL MOVIE-SCRIPT 0>
<GLOBAL MOVIE-VISIBLE? <>>
<GLOBAL NO-CR? <>>

<ROUTINE I-FILM ()
	 <COND (<EQUAL? ,HERE ,INSIDE-THEATER>
		<COND (<FSET? ,GLASSES ,WORNBIT>
		       <SETG MOVIE-SCRIPT <+ ,MOVIE-SCRIPT 1>>
		       <COND (,NO-CR?
			      <SETG NO-CR? <>>)
			     (T
			      <CRLF>)>
		       <SETG MOVIE-VISIBLE? T>
		       <COND (<EQUAL? ,MOVIE-SCRIPT 1>
			      <MOVE ,SCOPE ,HERE>
			      <FCLEAR ,SCOPE ,TRYTAKEBIT>
			      <MOVE ,CHEMICALS ,HERE>
		              <FCLEAR ,CHEMICALS ,TRYTAKEBIT>
			      <MOVE ,EVIL-ONE ,HERE>
		              <FCLEAR ,EVIL-ONE ,ACTORBIT>
			      <SAY-THE ,SCREEN>
			      <TELL 
" shows an evil woman squinting through an " D ,SCOPE 
". A laboratory full of bubbling 3D " D ,CHEMICALS 
" is visible in the back" D ,GROUND>)
			     (<EQUAL? ,MOVIE-SCRIPT 2>
			      <MOVE ,VULTURE ,INSIDE-THEATER>
			      <FCLEAR ,VULTURE ,ACTORBIT>
			      <FCLEAR ,VULTURE ,TRYTAKEBIT>
			      <TELL 
"A 3D " D ,VULTURE " lands on the woman's shoulder and croaks a secret into her ear. An evil eyebrow rises slowly as she listens">)
			     (<EQUAL? ,MOVIE-SCRIPT 3>
			      <SAY-THE ,OLD-WOMAN>
			      <TELL 
" swings the 3D " D ,SCOPE " around (narrowly missing your nose) and peers into it again. A point-of-view shot reveals what the 'scope is focused on: a small " D ,MOVIE-THEATER ", remarkably similar to the one you're in right now">)
			     (<EQUAL? ,MOVIE-SCRIPT 4>
			      <MOVE ,MISS-VOSS ,INSIDE-THEATER>
			      <FCLEAR ,MISS-VOSS ,ACTORBIT>
			      <SAY-THE ,SCOPE>
			      <TELL " zooms in on the " D ,ENTRANCE " to the " 
D ,MOVIE-THEATER ". A dead ringer for " D ,MISS-VOSS " looks up and waves timidly at the camera">)
			     (<EQUAL? ,MOVIE-SCRIPT 5>
			      <MOVE ,MISS-VOSS ,ROTARY-EAST>
			      <FSET ,MISS-VOSS ,ACTORBIT>
			      <MOVE ,PANEL ,HERE>
			      <FCLEAR ,PANEL ,TRYTAKEBIT>
		              <MOVE ,SW2 ,HERE>
		              <FCLEAR ,SW2 ,TRYTAKEBIT>
			      <MOVE ,SW1 ,HERE>
			      <FCLEAR ,SW1 ,TRYTAKEBIT>
			      <MOVE ,KITTY ,HERE>
		              <FSET ,KITTY ,NDESCBIT>
		              <FCLEAR ,KITTY ,ACTORBIT>
		              <FCLEAR ,KITTY ,TAKEBIT>
			      <PUTP ,KITTY ,P?DESCFCN <>>
			      <SAY-THE ,OLD-WOMAN>
			      <TELL " stalks across the lab to a panel of heavy-duty power switches. As the camera follows, you catch a fleeting 3D glimpse of a " D ,KITTY " sleeping in the " D ,CORNER " of the lab">)
			     (<EQUAL? ,MOVIE-SCRIPT 6>
			      <STOP-FILM>
			      <FSET ,SW1 ,OPENBIT>
		              <SAY-THE ,OLD-WOMAN>			      
			      <TELL
" selects a power switch labeled \"Palace Theater\" and opens it with a diabolical cackle. A 3D arc of electricity leaps from the screen, and a shower of sparks seems to engulf the " 
D ,MOVIE-THEATER "...|
|
Poof! The image on the screen goes black. The soundtrack slowly grinds to a halt">)>
			<TELL "." CR>)
		       (T
			<SETG MOVIE-VISIBLE? <>>
			<TELL CR <PICK-ONE ,FUZZIES> "." CR>)>)>>
 
<GLOBAL FUZZIES
	<LTABLE 0 
"All you can see on the screen is a confusing double-image"
"The picture on the screen is fuzzy and hard to watch"
"The screen image is a meaningless blur of colored light">>

<ROUTINE STOP-FILM ()
	 <FCLEAR ,INSIDE-THEATER ,ONBIT>
	 <DISABLE <INT I-FILM>>
	 <SETG MOVIE-VISIBLE? <>>
	 <COND (<IN? ,VULTURE ,INSIDE-THEATER>
		<FSET ,VULTURE ,ACTORBIT>
		<FSET ,VULTURE ,TRYTAKEBIT>
		<REMOVE ,VULTURE>)>
	 <COND (<IN? ,MISS-VOSS ,INSIDE-THEATER>
		<FSET ,MISS-VOSS ,ACTORBIT>
		<MOVE ,MISS-VOSS ,ROTARY-EAST>)>
	 <COND (<IN? ,KITTY ,INSIDE-THEATER>
		<MOVE ,KITTY ,LABORATORY>
	        <FSET ,KITTY ,ACTORBIT>
		<FSET ,KITTY ,TAKEBIT>
		<FCLEAR ,KITTY ,NDESCBIT>
	        <PUTP ,KITTY ,P?DESCFCN ,DESCRIBE-KITTY>
		<MOVE ,PANEL ,LABORATORY>
	        <FSET ,PANEL ,TRYTAKEBIT>
		<MOVE ,SW2 ,LABORATORY>
		<FSET ,SW2 ,TRYTAKEBIT>
		<MOVE ,SW1 ,LABORATORY>
	        <FSET ,SW1 ,TRYTAKEBIT>)>
	 <MOVE ,CHEMICALS ,LABORATORY>
	 <FSET ,CHEMICALS ,TRYTAKEBIT>
	 <REMOVE ,EVIL-ONE>
	 <FSET ,EVIL-ONE ,ACTORBIT>
	 <MOVE ,SCOPE ,LABORATORY>
	 <FSET ,SCOPE ,TRYTAKEBIT>>

"*** PARK ***"

<OBJECT PARK
	(IN ROOMS)
	(DESC "Park")
	(FLAGS ONBIT RLANDBIT WETBIT)
	(GLOBAL TREE)
	(NORTH TO ROTARY-NORTH)
	(EAST TO ROTARY-EAST)
	(SOUTH PER ENTER-ROTARY-SOUTH)
	(WEST TO ROTARY-WEST)
	(ACTION PARK-F)
	(PSEUDO "WALKS" HERE-F "ROTARY" HERE-F)>

<ROUTINE PARK-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<STANDING>
		<TELL "in a circular park, surrounded by the">
		<WHICH-TOWN "Rotary">
		<TELL ". Walks converge from four directions on a ">
		<COND (,SKEWED?
		       <TELL "neglected">)
		      (T
		       <TELL "shallow">)>
		<TELL " marble " D ,FOUNTAIN ", filled with ">
		<COND (,SKEWED?
		       <TELL "greasy">)
		      (T
		       <TELL "sparkling">)>
		<TELL " water.|
|
A " D ,STATUE " stands in the middle of the " D ,FOUNTAIN "." CR>)
	       (T
		<RFALSE>)>>
      
<OBJECT FOUNTAIN
	(IN PARK)
	(DESC "fountain")
	(SYNONYM FOUNTAIN WATER)
	(ADJECTIVE MARBLE SPARKLING GREASY)
	(FLAGS NDESCBIT CONTBIT OPENBIT)
	(CAPACITY 50)
	(ACTION FOUNTAIN-F)
	(CONTFCN IN-FOUNTAIN)>

<ROUTINE FOUNTAIN-F ()
	 <COND (<GETTING-INTO?>
		<TELL "You'd get soaked">
		<IF-YOU-TRIED>
		<RTRUE>)
	       (<AND <VERB? PUT PUT-ON THROW>
		     <EQUAL? ,PRSI ,FOUNTAIN>>
		<COND (,SKEWED?
		       <PERFORM ,V?GIVE ,PRSO ,PIRANHA>)
		      (T
		       <PERFORM ,V?GIVE ,PRSO ,GOLDFISH>)>
		<RTRUE>)
	       (<VERB? OPEN CLOSE>
		<TELL <PICK-ONE ,YUKS> CR>
		<RTRUE>)
	       (<VERB? DRINK TASTE>
		<WATER-DIRTY>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE IN-FOUNTAIN (CONTEXT)
	 <COND (<AND <EQUAL? .CONTEXT ,M-CONT>
		     ,SKEWED?
		     <NOT <EQUAL? ,PRSO ,PIRANHA>>
		     <OR <VERB? TAKE>
			 <TOUCHING? ,PRSO>>>
		<COND (<FSET? ,PIRANHA ,RMUNGBIT>
		       <SNAPPY>
		       <RTRUE>)
		      (<EQUAL? ,PRSO ,BOTTLE>
		       <SNAPPY>
		       <SETG PIRANHA-SCRIPT 1>
		       <I-PIRANHA-SNACK>)
		      (T
		       <RFALSE>)>)
	       (T
		<RFALSE>)>>
		       
<ROUTINE SNAPPY ()
	 <SAY-THE ,PIRANHA>
	 <TELL " " <PICK-ONE ,NIPS> "." CR>>

<GLOBAL NIPS
	<LTABLE 0
	 "nips savagely at your fingertips"
	 "tries to bite your hand"
	 "snaps at your fingers">>

<OBJECT COIN
	(IN FOUNTAIN)
	(DESC "gold coin")
	(FDESC 0)
	(SYNONYM COIN GOLD MONEY)
	(ADJECTIVE GOLD PROFILE)
	(FLAGS NDESCBIT TAKEBIT)
	(ACTION COIN-F)
	(VALUE 1)
	(SIZE 1)>

<ROUTINE COIN-F ()
         <COND (<IN? ,COIN ,TROLL>
		<TELL ,CANT ". ">
		<SAY-THE ,TROLL>
		<TELL " has it." CR>
		<RFATAL>)
	       (<VERB? EXAMINE>
		<SAY-THE ,COIN>
		<TELL " is etched with a">
		<SAY-PROFILE>
		<TELL "." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE SAY-PROFILE ()
	 <TELL " profile of ">
	 <FATHERS>>

<ROUTINE FATHERS ()
	 <TELL "one of Festeron's founding fathers">>

<OBJECT GOLDFISH
	(IN FOUNTAIN)
	(DESC "goldfish")
	(SYNONYM GOLDFISH FISH)
	(ADJECTIVE GOLD)
	(FLAGS NDESCBIT TRYTAKEBIT ACTORBIT)
	(ACTION GFISH-F)>

<OBJECT PIRANHA
	(DESC "piranha")
	(SYNONYM PIRANHA FISH)
	(FLAGS NDESCBIT TRYTAKEBIT ACTORBIT RMUNGBIT)
	(ACTION GFISH-F)>

; "RMUNGBIT = piranha not eating"

<ROUTINE GFISH-F ()
	 <COND (<VERB? EXAMINE>
		<SAY-THE ,PRSO>
		<COND (,SKEWED?
		       <TELL " stares back at you defiantly">
		       <COND (<NOT ,ECLIPSE?>
			      <TELL ", its ">
			      <SHARP-TEETH>
			      <TELL " gleaming in the moonlight">)>)
		      (T
		       <TELL " swims shyly away as you stare at it">)>
		<TELL "." CR>
		<RTRUE>)
	       
	       (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,GOLDFISH ,PIRANHA>>
		<SAY-THE ,PRSO>
		<COND (,SKEWED?
		       <TELL " would probably bite off one of your fingers">
		       <IF-YOU-TRIED>)
		      (T
		       <TELL " quickly swims out of reach." CR>)>
		<RTRUE>)
	       
	       (<AND <VERB? GIVE THROW FEED SWING>
		     <EQUAL? ,PRSI ,GOLDFISH ,PIRANHA>>
		<COND (<EQUAL? ,PRSO ,BROOM>
		       <GET-OFF-BROOM-FIRST>)>
		<MOVE ,PRSO ,FOUNTAIN>
		<TELL "It lands in the " D ,FOUNTAIN " with a splash">
		<COND (<NOT ,SKEWED?>
		       <TELL ", but the " D ,GOLDFISH
		             " isn't interested">)
		      (<NOT <FSET? ,PIRANHA ,RMUNGBIT>>
		       <TELL ", but the " D ,PIRANHA
			     " is too busy eating to notice">)
		      (<EQUAL? ,PRSO ,WORM>
		       <FCLEAR ,PIRANHA ,RMUNGBIT>
		       <MOVE ,WORM ,STEEP-TRAIL>
		     ; <SETG PIRANHA-SCRIPT 3>
		       <ENABLE <QUEUE I-PIRANHA-SNACK -1>>
		       <TELL "." CR CR>
		       <SAY-THE ,PIRANHA>
		       <TELL 
" snatches away the worm and swims to the far side of the " D ,FOUNTAIN 
" to devour it">)
		      (T
		       <TELL ". ">
		       <UNFORTUNATELY>
		       <TELL "the " D ,PIRANHA " isn't as interested in ">
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO " as it is in biting your fingers">)>
		<TELL "." CR>
		<RTRUE>)
	       
	       (<TOUCHING? ,PRSO>
		<SAY-THE ,PRSO>
		<TELL " won't let you near." CR>
		<RTRUE>)
	       
	       (<OR <TALKING-TO? ,PRSO>
		    <VERB? YELL>>
		<SAY-THE ,PRSO>
		<TELL " gurgles ">
		<COND (,SKEWED?
		       <TELL "threatening">)
		      (T
		       <TELL "shy">)>
		<TELL "ly." CR>
		<RFATAL>)
	       
	       (<VERB? EAT DRINK TASTE>
	        <YOUD-HAVE-TO "catch" ,PRSO>
		<RTRUE>)
	       
	       (T
		<RFALSE>)>>

<GLOBAL PIRANHA-SCRIPT 3>

<ROUTINE I-PIRANHA-SNACK ()
	 <COND (<OR ,FUZZY? ,ECLIPSE?>
		<RTRUE>)>
	 <SETG PIRANHA-SCRIPT <- ,PIRANHA-SCRIPT 1>>
	 <COND (<ZERO? ,PIRANHA-SCRIPT>
		<FSET ,PIRANHA ,RMUNGBIT>
		<COND (<EQUAL? ,HERE ,PARK>
		       <CRLF>
		       <SAY-THE ,PIRANHA>
		       <TELL " in the " D ,FOUNTAIN 
			     " is watching you hungrily." CR>)>
		<DISABLE <INT I-PIRANHA-SNACK>>)>>
		
<OBJECT STATUE
	(IN PARK)
	(DESC "statue")
	(SYNONYM STATUE COMMEMORATION FATHERS WOMAN)
	(ADJECTIVE HEROIC FOUNDING)
	(FLAGS TRYTAKEBIT NDESCBIT)
	(ACTION STATUE-F)>

<ROUTINE STATUE-F ()
	 <COND (<VERB? EXAMINE>
		<SAY-THE ,STATUE>
		<TELL " is a heroic commemoration of ">
		<COND (,SKEWED?
		       <TELL "a very evil-looking " D ,OLD-WOMAN>)
		      (T
		       <FATHERS>
		       <TELL ", dressed in a fancy military uniform">)>
		<TELL "." CR>
		<RTRUE>)
	       (<OR <GETTING-INTO?>
		    <TOUCHING? ,STATUE>>
		<TELL "You'd get soaked in the " D ,FOUNTAIN>
		<IF-YOU-TRIED>
		<RTRUE>)
	       (T
		<RFALSE>)>>
		
<OBJECT FESTERON
	(IN GLOBAL-OBJECTS)
	(DESC "village")
	(SYNONYM TOWN VILLAGE CENTER)
	(ADJECTIVE FESTERON WITCHVILLE)
	(FLAGS NDESCBIT)
	(ACTION FESTERON-F)>

<ROUTINE FESTERON-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE>
		<COND (<IN-VILLAGE?>
		       <RTRUE>)
		      (<EQUAL? ,HERE ,HILLTOP ,LOOKOUT-HILL ,LABORATORY>
		       <TOWN-TOO-FAR>)
		      (<EQUAL? ,HERE ,CLIFF-EDGE>
		       <COND (<OR <NOT ,SKEWED?>
				  ,SUCCESS?>
			      <TOWN-TOO-FAR>)
			     (T
			      <BUT-THE ,FESTERON>
			      <TELL "is covered with fog!" CR>)>)
		      (T
		       <TELL ,CANT " see the " D FESTERON " from here." CR>)>
		<RTRUE>)
	       (<VERB? WALK-TO ENTER THROUGH>
		<COND (<IN-VILLAGE?>
		       <RTRUE>)
		      (T
		       <REFER-TO-MAP>)>
		<RTRUE>)
	       (<VERB? EXIT>
		<V-WALK-AROUND>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE IN-VILLAGE? ()
	 <COND (<OR <EQUAL? ,HERE ,ROTARY-NORTH ,ROTARY-SOUTH ,PARK>
		    <EQUAL? ,HERE ,ROTARY-EAST ,ROTARY-WEST>>
		<ALREADY-IN ,FESTERON>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE TOWN-TOO-FAR ()
	 <SAY-THE ,FESTERON>
	 <TELL " is too far away to make out much detail." CR>>

"*** ROTARY WEST ***"

<OBJECT ROTARY-WEST
	(IN ROOMS)
	(DESC "Rotary West")
	(FLAGS ONBIT RLANDBIT)
	(GLOBAL POLICE-STATION SIGN POLICE-DOOR CORNER)
	(NORTH TO ROTARY-NORTH)
	(EAST TO PARK)
	(SOUTH PER ENTER-ROTARY-SOUTH)
	(WEST TO EDGE-OF-LAKE)
	(IN PER ENTER-POLICE-STATION)
	(PSEUDO "ROTARY" HERE-F)
	(ACTION ROTARY-WEST-F)>

<ROUTINE ROTARY-WEST-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're on the west side of the">
                <WHICH-TOWN "Rotary">
		<TELL ". A street branches west, towards the lake.|
|
The " D ,INSIDE-POLICE-STATION " stands on a nearby " D ,CORNER ". It's a ">
		<COND (,SKEWED?
		       <TELL "grim">)
		      (T 
		       <TELL "modest">)>
		<TELL 
" little building with a sign over the">
		<OPEN-CLOSED ,POLICE-DOOR>
		<TELL D ,ENTRANCE "." CR>)>>

<ROUTINE ENTER-POLICE-STATION ()
	 <COND (<FSET? ,POLICE-DOOR ,OPENBIT>
		<COND (<ZERO? ,MACGUFFIN-SCRIPT>
		       <COND (,SKEWED?
		              <ENABLE <QUEUE I-NASTY-MACGUFFIN -1>>)
		             (T
		              <ENABLE <QUEUE I-DULL-MACGUFFIN -1>>)>)>
	        <RETURN ,INSIDE-POLICE-STATION>)
	       (T
		<ITS-CLOSED ,POLICE-DOOR>
		<RFALSE>)>>
		      
<OBJECT POLICE-STATION
	(IN LOCAL-GLOBALS)
	(DESC "police station")
	(SYNONYM STATIO HEADQU OFFICE BUILDING)
	(ADJECTIVE POLICE FRONT)
	(FLAGS NDESCBIT)
	(ACTION POLICE-STATION-F)>

<ROUTINE POLICE-STATION-F ()
	 <COND (<ENTER-FROM? ,ROTARY-WEST ,INSIDE-POLICE-STATION
			     ,POLICE-STATION>
		<RTRUE>)
	       (<VERB? EXAMINE LOOK-ON>
		<V-LOOK>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE>
		<COND (<EQUAL? ,HERE ,ROTARY-WEST>
		       <GO-INSIDE>)
		      (T
		       <V-LOOK>)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT POLICE-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "police station door")
	(SYNONYM DOOR ENTRANCE ENTRY LOCK)
	(ADJECTIVE POLICE STATIO)
	(FLAGS NDESCBIT OPENBIT DOORBIT READBIT)
	(ACTION POLICE-DOOR-F)>

<ROUTINE POLICE-DOOR-F ()
	 <COND (<AND <VERB? READ LOOK-ON EXAMINE>
		     <EQUAL? ,HERE ,ROTARY-WEST>>
		<PERFORM ,V?EXAMINE ,SIGN>
		<RTRUE>)
	       (<USE-DOOR? ,ROTARY-WEST>
		<RTRUE>)
	       (T
		<RFALSE>)>>

"*** INSIDE POLICE STATION ***"

<OBJECT INSIDE-POLICE-STATION
	(IN ROOMS)
	(DESC "Police Station")
	(FLAGS ONBIT RLANDBIT INDOORSBIT)
	(GLOBAL POLICE-STATION CELL CELL-DOOR POLICE-DOOR CORNER)
	(OUT PER EXIT-STATION?)
	(ACTION INSIDE-POLICE-STATION-F)>

<ROUTINE EXIT-STATION? ()
	 <COND (<FSET? ,POLICE-DOOR ,OPENBIT>
		<COND (,SKEWED?
		       <SETG MACGUFFIN-SCRIPT 1>)>
		<RETURN ,ROTARY-WEST>)
	       (T
		<ITS-CLOSED ,POLICE-DOOR>
		<RFALSE>)>>

<ROUTINE INSIDE-POLICE-STATION-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL 
"You're in the front office of the">
		<WHICH-TOWN>
		<TELL " " D ,INSIDE-POLICE-STATION ". ">
		<COND (,SKEWED?
		       <TELL 
"The room is lined with dimly-lit jail cells. Occasional wails of anguish suggest that many of the cells are occupied">)
		      (T
		       <TELL
"A modest jail cell is visible in a " D ,CORNER " of the room">)>
		<TELL "." CR CR D ,MACGUFFIN>
		<COND (,SKEWED?
		       <TELL ", Witchville's finest, is glaring down at you from behind an intimidatingly high desk">)
		      (T
		       <TELL ", Festeron's finest, is ">
		       <COND (<G? ,MACGUFFIN-SCRIPT 3>
			      <TELL "sound asleep">)
			     (T
			      <TELL "nodding off">)>
		       <TELL " behind a desk">)>
		<TELL ". " ,YOU-SEE>
		<COND (<FIRST? ,DESK>
		       <PRINT-CONTENTS ,DESK>
		       <TELL " on the desk, and ">)>
		<TELL "a " D ,POSTER " taped to the wall." CR>)>>

<OBJECT DESK
	(IN INSIDE-POLICE-STATION)
	(DESC "desk")
	(SYNONYM DESK DRAWER)
	(ADJECTIVE INTIMIDATINGLY TALL)
	(FLAGS NDESCBIT SURFACEBIT)
	(CAPACITY 25)
	(ACTION DESK-F)>

<ROUTINE DESK-F ()
	 <COND (<VERB? EXAMINE>
		<PERFORM ,V?LOOK-ON ,DESK>
		<RTRUE>)
	       (<AND <VERB? PUT>
		     <EQUAL? ,PRSI ,DESK>>
		<ITS-CLOSED ,DESK>
		<RTRUE>)
	       (<VERB? LOOK-BEHIND>
		<PERFORM ,V?EXAMINE ,MACGUFFIN>
		<RTRUE>)
	       (<OR <EQUAL? ,PRSA ,V?LOOK-INSIDE ,V?SEARCH ,V?OPEN>
		    <GETTING-INTO?>>
		<NOT-LIKELY ,MACGUFFIN 
"wants nosey people poking around his desk">
		<RTRUE>)
	       (<VERB? CLOSE>
		<ALREADY-CLOSED>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT RADIO
	(IN INSIDE-POLICE-STATION)
	(DESC "police radio")
	(SYNONYM RADIO)
	(ADJECTIVE POLICE)
	(FLAGS NDESCBIT ; TRYTAKEBIT)
	(ACTION RADIO-F)>

<ROUTINE RADIO-F ()
	 <COND (<OR <HURT? ,RADIO>
		    <VERB? TAKE>>
		<PRINTD ,MACGUFFIN>
		<MIGHT-NOT-LIKE>
		<RTRUE>)
	       (<OR <SEE-VERB?>
		    <TOUCHING? ,RADIO>>
		<SAY-THE ,RADIO>
		<TELL " is hidden behind " D ,MACGUFFIN "'s desk." CR>
		<RTRUE>)
	       (<VERB? LISTEN>
		<TELL "It emits">
		<STATIC>
		<TELL "." CR>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,RADIO>
		<RFATAL>)>>	       

<OBJECT CHOCOLATE
	(IN DESK)
	(DESC "piece of chocolate")
	(SYNONYM CHOCOLATE PIECE CANDY)
	(ADJECTIVE CHOCOLATE CREAMY DELICIOUS)
	(FLAGS NDESCBIT TAKEBIT)
	(VALUE 0)
	(SIZE 1)
	(ACTION CHOCOLATE-F)>

<ROUTINE CHOCOLATE-F ()
	 <COND (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,CHOCOLATE>
		     <IN? ,CHOCOLATE ,DESK>
		     <L? ,MACGUFFIN-SCRIPT 4>>
		<SETG MACGUFFIN-SCRIPT 1>
		<TELL "\"Hands off,\" " D ,MACGUFFIN " growls sleepily." CR>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<FSET ,CHOCOLATE ,TOOLBIT>
		<TELL "You share " D ,MACGUFFIN "'s passion for fine chocolate. Looking at this creamy piece is making your mouth water. Only your iron will is stopping you from eating it right now." CR>
		<RTRUE>)
	       (<VERB? EAT>
		<COND (<EAT-CHOCOLATE?>
		       <TELL "Gulp! ">
		       <COND (<FSET? ,CHOCOLATE ,TOOLBIT>
		              <TELL "So much for your iron will">)
		             (T
		              <TELL "It's gone">)>
		       <TELL "." CR>)>
		<RTRUE>)
	       (<VERB? TASTE BITE>
		<COND (<EAT-CHOCOLATE?>
		       <TELL "The taste makes you hungry for more.">
		       <HISTORY>)>
		<RTRUE>)
	       (<VERB? DRINK>
		<NOT-LIQUID>
		<RTRUE>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,CHOCOLATE ,PRSO>
		     <FSET? ,PRSI ,ACTORBIT>>
		<REMOVE ,CHOCOLATE>
		<TELL "Eagerly, ">
		<ARTICLE ,PRSI T>
		<TELL D ,PRSI " accepts the " D ,CHOCOLATE ".">
		<HISTORY>
		<RTRUE>)
	       (<AND <VERB? PUT-ON>
		     <EQUAL? ,PRSI ,DESK>
		     ,SKEWED?>
		<PERFORM ,V?GIVE ,CHOCOLATE ,MACGUFFIN>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE HISTORY ()
	 <TELL " In a few moments, the candy is history." CR>>

<ROUTINE EAT-CHOCOLATE? ()
	 <COND (<DONT-HAVE? ,CHOCOLATE>
		<RFALSE>)
	       (T
		<REMOVE ,CHOCOLATE>
	        <SETG CHOCOLATE-SCRIPT 3>
	        <ENABLE <QUEUE I-DIGEST-CHOCOLATE -1>>
		<RTRUE>)>>

<GLOBAL CHOCOLATE-SCRIPT 0>

<ROUTINE I-DIGEST-CHOCOLATE ()
	 <SETG CHOCOLATE-SCRIPT <- ,CHOCOLATE-SCRIPT 1>>
	 <TELL CR "(The ">
	 <COND (<EQUAL? ,CHOCOLATE-SCRIPT 2>
		<TELL D ,CHOCOLATE " is melting in your mouth.">
		<COND (,SKEWED?
		       <MAKE-IT-SNAPPY>)
		      (T
		       <TELL ")">)>)
	       (<EQUAL? ,CHOCOLATE-SCRIPT 1>
		<C-TASTE>
		<TELL "almost gone.">
		<COND (,SKEWED?
		       <HOLD-YOUR-PEACE>)
		      (T
		       <TELL ")">)>)
	       (T
		<SETG CHOCOLATE-SCRIPT 0>
		<DISABLE <INT I-DIGEST-CHOCOLATE>>
		<C-TASTE>
		<TELL "gone. Sure was great while it lasted.)">)>
	 <CRLF>>

<ROUTINE C-TASTE ()
	 <TELL "chocolate taste in your mouth is ">>

"*** ROTARY-SOUTH ***"

<OBJECT ROTARY-SOUTH
	(IN ROOMS)
	(DESC "Rotary South")
	(FLAGS ONBIT RLANDBIT)
	(GLOBAL LIBRARY LIBRARY-DOOR)
	(NORTH PER TO-NORTH)
	(EAST PER TO-EAST)
	(SOUTH PER ENTER-OUTSIDE-COTTAGE)
	(WEST PER TO-WEST)
	(IN PER ENTER-LIBRARY?)
	(PSEUDO "ROTARY" HERE-F)
	(ACTION ROTARY-SOUTH-F)>

<ROUTINE TO-NORTH ()
	 <WAIT-CRY>
	 <RETURN ,PARK>>

<ROUTINE TO-EAST ()
	 <WAIT-CRY>
	 <RETURN ,ROTARY-EAST>>

<ROUTINE TO-WEST ()
	 <WAIT-CRY>
	 <RETURN ,ROTARY-WEST>>

<ROUTINE WAIT-CRY ("OPTIONAL" (GOING-SOUTH? <>))
	 <COND (<IN? ,MISS-VOSS ,ROTARY-SOUTH>
		<COND (,NOTE-GIVEN?
		       <VOSS-HURRIES-AWAY>)
		      (T
		       <TELL "\"">
		       <COND (<AND <IN? ,VIOLET-NOTE ,MISS-VOSS>
			           <NOT .GOING-SOUTH?>>
		              <VOSS-LEAVES>
		              <TELL ,OKAY "never mind!\" shrug">)
		             (T
		              <TELL "Wait! I want to talk to you!\" crie">)>
		       <TELL "s " D ,MISS-VOSS " as you walk away.">)>
		<CRLF>
		<CRLF>)>>
		       
<ROUTINE ENTER-LIBRARY? ()
	 <COND (<FSET? ,LIBRARY-DOOR ,OPENBIT>
		<COND (<NOT <ENABLED? ,I-SLAM-DOOR>>
		       <START-BUZZ 7>
		       <SETG CRISP-SCRIPT 2>
		       <ENABLE <QUEUE I-SLAM-DOOR -1>>)>
		<RETURN ,CIRCULATION-DESK>)
	       (T
		<ITS-CLOSED ,LIBRARY-DOOR>
		<VOSS-EXCUSE>
		<RFALSE>)>>

<ROUTINE VOSS-EXCUSE ()
	 <COND (<AND <EQUAL? ,HERE ,ROTARY-SOUTH>
		     <IN? ,MISS-VOSS ,HERE>>
		<TELL CR 
"\"I leave early on Fridays,\" explains " D ,MISS-VOSS "." CR>)>>

<ROUTINE I-SLAM-DOOR ()
	 <COND (<OR ,FUZZY? ,ECLIPSE?>
		<RTRUE>)
	       (<EQUAL? ,HERE ,CIRCULATION-DESK>
		<SETG CRISP-SCRIPT <- ,CRISP-SCRIPT 1>>
		<COND (<NOT <ZERO? ,CRISP-SCRIPT>>
		       <RTRUE>)>
		<DISABLE <INT I-SLAM-DOOR>>
	        <CRLF>
		<COND (<FSET? ,LIBRARY-DOOR ,OPENBIT>
		       <TELL 
"Bang! The " D ,LIBRARY-DOOR " slams shut. ">)>
		<TELL 
"You hear a faint \"click\" as somebody locks ">
		<COND (<FSET? ,LIBRARY-DOOR ,OPENBIT>
		       <FCLEAR ,LIBRARY-DOOR ,OPENBIT>
		       <FCLEAR ,CIRCULATION-DESK ,ONBIT>
		       <TELL "it">)
		      (T
		       <TELL "the " D ,LIBRARY-DOOR>)>
		<TELL " from the outside." CR>
		<FSET ,LIBRARY-DOOR ,LOCKEDBIT>
		<COND (<AND <VISIBLE? ,CANDLE>
			    <FSET? ,CANDLE ,ONBIT>>
		       <FCLEAR ,CANDLE ,ONBIT>
		       <FSET ,CANDLE ,RMUNGBIT>
		       <CRLF>
		       <SAY-THE ,CANDLE>
		       <TELL " flares brightly, and then fizzles out." CR>)>
		<SAY-IF-NOT-LIT>)>> 

<ROUTINE ROTARY-SOUTH-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "This is the south side of the">
		<WHICH-TOWN "Rotary">
		<TELL 
". A road branches south, towards " D ,POST-OFFICE " Hill.|
|
The">
		<WHICH-TOWN "Public Library">
		<TELL ", ">
		<COND (,SKEWED?
		       <TELL "once ">)>
		<TELL 
"famous for its museum of local historic artifacts, stands ">
		<COND (,SKEWED?
		       <TELL "in a pitiful state of disrepair">)
		      (T
		       <TELL "proudly on the nearby " D ,CORNER>)>
		<TELL "." CR>)>>

<ROUTINE ENTER-ROTARY-SOUTH ()
	 <COND (<AND <NOT ,SKEWED?>
		     <NOT ,NOTE-GIVEN?>
		     <ZERO? ,VOSS-SCRIPT>>
		<ENABLE <QUEUE I-VOSS-BABBLE -1>>)>
	 <RETURN ,ROTARY-SOUTH>>

<OBJECT LIBRARY
	(IN LOCAL-GLOBALS)
	(DESC "library")
	(SYNONYM LIBRARY BUILDING)
	(ADJECTIVE FREE PUBLIC)
	(FLAGS NDESCBIT)
	(ACTION LIBRARY-F)>

<ROUTINE LIBRARY-F ()
	 <COND (<ENTER-FROM? ,ROTARY-SOUTH ,CIRCULATION-DESK ,LIBRARY>
	        <RTRUE>)
	       
	       (<VERB? EXAMINE LOOK-INSIDE>
		<COND (<EQUAL? ,HERE ,ROTARY-SOUTH>
		       <COND (<FSET? ,LIBRARY-DOOR ,OPENBIT>
			      <GO-INSIDE>)
			     (T
			      <ITS-CLOSED ,LIBRARY-DOOR>)>)
		      (T
		       <V-LOOK>)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT LIBRARY-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "library door")
	(SYNONYM DOOR ENTRANCE ENTRY LOCK)
	(ADJECTIVE LIBRARY)
	(FLAGS DOORBIT LOCKEDBIT NDESCBIT RMUNGBIT)
	(ACTION LIBRARY-DOOR-F)>

; "RMUNGBIT = Door not yet opened"

<ROUTINE LIBRARY-DOOR-F ()
	 <COND (<AND <VERB? UNLOCK>
		     <EQUAL? ,PRSO ,LIBRARY-DOOR>
		     <FSET? ,LIBRARY-DOOR ,LOCKEDBIT>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <ALREADY-OPEN>)
		      (<NOT <EQUAL? ,HERE ,ROTARY-SOUTH>>
		       <LOCK-IS-OUTSIDE>)
		      (<NOT <EQUAL? ,PRSI ,LIBRARY-KEY>>
		       <THING-WONT-LOCK ,PRSI ,PRSO T>)
		      (T
		       <FCLEAR ,LIBRARY-DOOR ,LOCKEDBIT>
		       <FSET ,CIRCULATION-DESK ,ONBIT>
		       <FSET ,LIBRARY-DOOR ,OPENBIT>
		       <TELL ,OKAY "the " D ,LIBRARY-DOOR
			     " is now unlocked and open." CR>
		       <COND (<FSET? ,LIBRARY-DOOR ,RMUNGBIT>
			      <FCLEAR ,LIBRARY-DOOR ,RMUNGBIT>
			      <CRLF>
			      <UPDATE-SCORE 3>)>
		       <GOOD-PLACE-TO-SAVE>)>
		<RTRUE>)
	       (<AND <VERB? LOCK>
		     <EQUAL? ,PRSO ,LIBRARY-DOOR>
		     <NOT <FSET? ,LIBRARY-DOOR ,OPENBIT>>
		     <NOT <FSET? ,LIBRARY-DOOR ,LOCKEDBIT>>>
		<COND (<EQUAL? ,HERE ,CIRCULATION-DESK>
		       <LOCK-IS-OUTSIDE>)
		      (<NOT <EQUAL? ,PRSI ,LIBRARY-KEY>>
		       <THING-WONT-LOCK ,PRSI ,LIBRARY-DOOR>)
		      (T
		       <FSET ,LIBRARY-DOOR ,LOCKEDBIT>
		       <FCLEAR ,CIRCULATION-DESK ,ONBIT>
		       <FCLEAR ,LIBRARY-DOOR ,OPENBIT>
		       <TELL ,OKAY "the " D ,LIBRARY-DOOR " is">
		       <CLOSED-AND-LOCKED>)>
		<RTRUE>)
	       (<HURT? ,LIBRARY-DOOR>
		<COND (<NOT <FSET? ,LIBRARY-DOOR ,OPENBIT>>
		       <TELL "You won't get through the " D ,LIBRARY-DOOR
		             " that way." CR>)
		      (T
		       <TELL "Why bother? ">
		       <ALREADY-OPEN>)>
		<RTRUE>)
	       (<VERB? OPEN>
		<COND (<FSET? ,LIBRARY-DOOR ,OPENBIT>
		       <ALREADY-OPEN>
		       <RTRUE>)
		      (<FSET? ,LIBRARY-DOOR ,LOCKEDBIT>
		       <OBJECT-IS-LOCKED>
		       <VOSS-EXCUSE>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<USE-DOOR? ,ROTARY-SOUTH>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE LOCK-IS-OUTSIDE ()
	 <UNFORTUNATELY>
	 <TELL "the lock is on the outside." CR>>

<OBJECT VIOLET-NOTE
	(DESC "violet note")
	(SYNONYM NOTE PAPER SLIP)
	(ADJECTIVE VIOLET PURPLE PALE)
	(FLAGS TAKEBIT READBIT RMUNGBIT)
	(VALUE 3)
	(SIZE 1)
	(ACTION VIOLET-NOTE-F)>

; "RMUNGBIT = note sealed"

<GLOBAL NOTE-READ? <>>

<ROUTINE VIOLET-NOTE-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "It's a folded sheet of pale violet paper">
		<COND (<FSET? ,VIOLET-NOTE ,RMUNGBIT>
		       <TELL ", sealed with a dab of library paste">)>
		<TELL ". ">
		<SAY-ADDRESS>
		<RTRUE>)
	       (<VERB? OPEN>
		<COND (<DONT-HAVE? ,VIOLET-NOTE>
		       <RTRUE>)
		      (<FSET? ,VIOLET-NOTE ,RMUNGBIT>
		       <NOT-YOURS ,VIOLET-NOTE>)
		      (T
		       <TELL D ,CRISP " already opened it." CR>)>
		<RTRUE>)
	       (<VERB? READ>
		<COND (<DONT-HAVE? ,VIOLET-NOTE>
		       <RTRUE>)
		      (<FSET? ,VIOLET-NOTE ,RMUNGBIT>
		       <SAY-ADDRESS>)
		      (T
		       <SAY-NOTE>)>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE>
		<COND (<DONT-HAVE? ,VIOLET-NOTE>
		       <RTRUE>)
		      (<FSET? ,VIOLET-NOTE ,RMUNGBIT>
		       <NOT-YOURS ,VIOLET-NOTE>)
		      (T
		       <SAY-NOTE>)>
		<RTRUE>)
	       (<HURT? ,VIOLET-NOTE>
		<HOW-WOULD-YOU-LIKE-IT ,VIOLET-NOTE>
		<RTRUE>)
	       (<VERB? SMELL>
		<TELL "Ugh! Cheap perfume." CR>
		<RTRUE>)
	       (T
	        <RFALSE>)>>

<ROUTINE NOT-YOURS (THING)
	 <BUT-THE .THING>
	 <TELL "isn't addressed to you!" CR>>

<ROUTINE SAY-ADDRESS ()
	 <TELL
"The name \"Corky\" is beautifully handwritten on the outside." CR>>

<ROUTINE SAY-NOTE ()
	 <COND (<NOT ,NOTE-READ?>
		<SETG NOTE-READ? T>
		<UPDATE-SCORE 3>
		<CRLF>)>
	 <TELL "The handwritten note says:|
|
\"Corky-Poo,|
|
I've got a plate of fresh oatmeal cookies waiting for you. Come over around sixish, and I'll show you my collection of Byron first editions, etc...|
|
Violet|
|
PS: If my little " D ,POODLE " yaps at you, just say ALEXIS, HEEL and she'll behave.\"" CR>>

<OBJECT CIRCULATION-DESK
	(IN ROOMS)
	(DESC "Circulation Desk")
	(FLAGS RLANDBIT INDOORSBIT ONBIT)
	(GLOBAL LIBRARY LIBRARY-DOOR GMUSEUM)
	(SOUTH PER ENTER-MUSEUM)
	(IN PER ENTER-MUSEUM)
	(OUT PER EXIT-DESK)
	(ACTION CIRCULATION-DESK-F)>

<ROUTINE EXIT-DESK ()
	 <COND (<SHUT-DOOR?>
		<RFALSE>)
	       (T
		<ITS-CLOSED ,LIBRARY-DOOR>
	        <RFALSE>)>>

<ROUTINE SHUT-DOOR? ()
	 <COND (<FSET? ,LIBRARY-DOOR ,OPENBIT>
		<TELL "A sudden noise stops you in your tracks." CR>
		<I-SLAM-DOOR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE ENTER-MUSEUM ()
	 <COND (<SHUT-DOOR?>
		<RFALSE>)
	       (<EVIL-HERE?>
		<RFALSE>)
	       (T
		<RETURN ,MUSEUM>)>>

<ROUTINE CIRCULATION-DESK-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<STANDING>
		<TELL  
"before a large desk at the " D ,LIBRARY " " D ,ENTRANCE ". The top of the desk is almost hidden under a " D ,CLUTTER ", all grey with dust.">
		<COND (<FIRST? ,CDESK>
		       <TELL " There's also ">
		       <PRINT-CONTENTS ,CDESK>
		       <TELL " on the desk.">)>
		<TELL CR CR "A dark " D ,CORRIDOR " leads south into " 
		      D ,DARKNESS ". ">
		<SAY-DOOR ,LIBRARY-DOOR>
		<SEE-WITCH>)>>

<OBJECT CDESK
	(IN CIRCULATION-DESK)
	(DESC "circulation desk")
	(SYNONYM DESK)
	(ADJECTIVE CIRCUL LARGE)
	(FLAGS NDESCBIT DOORBIT LOCKEDBIT SURFACEBIT)
	(CAPACITY 25)
	(ACTION CDESK-F)>

<ROUTINE CDESK-F ()
	 <COND (<VERB? CLOSE LOCK>
		<SAY-THE ,CDESK>
		<TELL " is already">
		<CLOSED-AND-LOCKED>
		<RTRUE>)
	       (<GETTING-INTO?>
		<WASTE-OF-TIME>
		<RTRUE>)
	       (<VERB? EXAMINE LOOK-ON>
		<TELL "Aside from the " D ,CLUTTER ", you see ">
		<PRINT-CONTENTS ,CDESK>
		<TELL " on the " D ,CDESK "." CR>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE>
		<ITS-CLOSED ,CDESK>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT GMUSEUM
	(IN LOCAL-GLOBALS)
	(DESC "museum")
	(SYNONYM MUSEUM HALL)
	(ADJECTIVE DARK)
	(FLAGS NDESCBIT)
	(ACTION GMUSEUM-F)>

<SYNONYM HALL HALLWAY CORRIDOR>

<ROUTINE GMUSEUM-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE LOOK-DOWN LOOK-THRU>
		<COND (<EQUAL? ,HERE ,MUSEUM>
		       <V-LOOK>)
		      (T
		       <GO-INSIDE>)>
		<RTRUE>)
	       (<VERB? WALK-TO ENTER THROUGH USE>
		<COND (<EQUAL? ,HERE ,MUSEUM>
		       <TELL "It's right here!" CR>)
		      (T
		       <DO-WALK ,P?IN>)>
		<RTRUE>)
	       (<VERB? SIT LIE-DOWN STAND-ON>
		<LOITERING-ON ,GMUSEUM>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT CLUTTER
	(IN CIRCULATION-DESK)
	(DESC "clutter of books")
	(SYNONYM BOOKS BOOK)
	(ADJECTIVE CLUTTER PILE)
	(FLAGS NDESCBIT READBIT TRYTAKEBIT)
	(ACTION CLUTTER-F)>

<ROUTINE CLUTTER-F ()
	 <COND (<VERB? EXAMINE>
		<TELL 
"The titles range from classics of world literature to forgotten hits of years long past. Dust covers them equally, regardless of merit." CR>) 
	       (<VERB? READ>
		<LOITERING-ON ,CLUTTER>)
	       (<VERB? TAKE>
		<TELL ,CANT 
" take any books. You don't have a " D ,LIBRARY " card." CR>)
	       (<VERB? MUNG KICK>
		<TELL
"That's no way to handle " D ,LIBRARY " materials!" CR>)
	       (T
		<YOU-DONT-NEED ,CLUTTER>
		<RFATAL>)>
	 <RTRUE>>

<OBJECT MUSEUM
	(IN ROOMS)
	(DESC "Museum")
	(FLAGS RLANDBIT INDOORSBIT)
	(GLOBAL LIBRARY GMUSEUM SIGN)
	(NORTH PER EXIT-MUSEUM)
	(OUT PER EXIT-MUSEUM)
	(ACTION MUSEUM-F)>

<ROUTINE MUSEUM-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
	    	<TELL
"Formerly a popular tourist attraction, the old Festeron " D ,MUSEUM 
" is in a sorry state. ">
                <SAY-EXHIBITS>
		<COND (<IN? ,FOSSIL ,MUSEUM>
		       <TELL CR "Fortunately, one of your childhood favorites is still intact. It's a pair of enormous fossil mailboxes, their metal bones locked together in a pose of eternal combat." CR>)>
		<TELL CR "There's a ">
		<COND (<FSET? ,DCASE ,OPENBIT>
		       <TELL "broken ">)>
		<TELL "glass " D ,DCASE " in the " D ,CORNER ".">
		<COND (<FIRST? ,DCASE>
		       <TELL " " ,YOU-SEE>
		       <PRINT-CONTENTS ,DCASE>
		       <TELL " in the case.">)>
		<CRLF>
	        <SEE-WITCH>)>>
		 
<ROUTINE SAY-EXHIBITS ()
	 <TELL "Many of the best " D ,EXHIBITS " have been carted away; the few remaining are sorely in need of renovation." CR>>

<ROUTINE SEE-WITCH ()
	 <COND (<IN? ,EVIL-ONE ,HERE>
		<TELL CR "There's an " D ,OLD-WOMAN " standing in the " 
		      D ,CORRIDOR "." CR>)>>

<ROUTINE EXIT-MUSEUM ()
	 <COND (<EVIL-HERE?>
		<RFALSE>)
	       (T
		<RETURN ,CIRCULATION-DESK>)>>

<ROUTINE EVIL-HERE? ()
	 <COND (<IN? ,EVIL-ONE ,HERE>
		<SAY-THE ,OLD-WOMAN>
		<TELL " is blocking your path." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT EXHIBITS
	(IN MUSEUM)
	(DESC "exhibits")
	(SYNONYM EXHIBIT DISPLAY)
	(FLAGS NDESCBIT)
	(ACTION EXHIBITS-F)>

<ROUTINE EXHIBITS-F ()
	 <COND (<SEE-VERB?>
		<SAY-EXHIBITS>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,EXHIBITS>
		<RFATAL>)>>

<OBJECT FOSSIL
	(DESC "fossil exhibit")
	(SYNONYM FOSSIL MAILBOX BOXES EXHIBIT)
	(ADJECTIVE LARGE SMALL RIBS BONES)
	(FLAGS NDESCBIT CONTBIT TRANSBIT OPENBIT TRYTAKEBIT)
	(CAPACITY 100)
	(CONTFCN IN-FOSSIL)
	(ACTION FOSSIL-F)>

<ROUTINE FOSSIL-F ("AUX" OBJ)
	 <COND (<VERB? EXAMINE>
		<TELL "There's something disturbingly familiar about the "
		      D ,FOSSIL ".">
		<SET OBJ <FIRST? ,FOSSIL>>
		<COND (.OBJ
		       <TELL
" Maybe it has something to do with the object">
		       <COND (<NEXT? .OBJ>
			      <TELL "s">)>
		       <TELL 
" you can see lying inside.">)>
		<CRLF>
		<RTRUE>) 
	       (<VERB? LOOK-INSIDE>
		<TELL ,YOU-SEE>
		<PRINT-CONTENTS ,FOSSIL>
		<TELL " among the ribs of the " D ,FOSSIL "." CR>
		<RTRUE>)
	       (<AND <VERB? PUT>
		     <EQUAL? ,PRSI ,FOSSIL>>
		<COND (<G? <GETP ,PRSO ,P?SIZE> 1>
		       <BUT-THE ,PRSO>
		       <TELL "won't fit">)
		      (T
		       <MOVE ,PRSO ,FOSSIL>
		       <TELL ,OKAY>
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO " slips">)>
		<TELL " between the ribs of the " D ,FOSSIL "." CR>
		<RTRUE>)
	       (<OR <HURT? ,FOSSIL>
		    <MOVING? ,FOSSIL>
		    <VERB? REACH-IN OPEN>>
		<HURT-FOSSIL>
		<RTRUE>)
	       (<VERB? CLOSE>
		<TELL <PICK-ONE ,YUKS> CR>
		<RTRUE>)
	       (T
		<RFALSE>)>> 

<ROUTINE HURT-FOSSIL ()
	 <TELL 
"You'd probably damage the priceless " D ,FOSSIL>
	 <IF-YOU-TRIED>>

<ROUTINE IN-FOSSIL (CONTEXT)
	 <COND (<AND <EQUAL? .CONTEXT ,M-CONT>
		     <TOUCHING? ,PRSO>>
		<TELL ,CANT " possibly reach ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO 
". The fossil's ribs are too close together." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>
				       
<OBJECT DCASE
	(IN MUSEUM)
	(DESC "display case")
	(SYNONYM CASE)
	(ADJECTIVE DISPLAY GLASS)
	(FLAGS NDESCBIT CONTBIT LOCKEDBIT TRANSBIT TRYTAKEBIT)
	(CAPACITY 10)
	(ACTION DCASE-F)
	(CONTFCN IN-DCASE)>

<ROUTINE IN-DCASE (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-CONT>
		<COND (<AND <NOT <FSET? ,DCASE ,OPENBIT>>
			    <NOT <SEE-VERB?>>>
		       <TELL ,CANT " reach inside the closed "
			     D ,DCASE "." CR>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (T
		<RFALSE>)>>
		
<ROUTINE DCASE-F ("AUX" OPEN? THING)
	 <SET OPEN? <FSET? ,DCASE ,OPENBIT>>
	 <COND (<VERB? EXAMINE LOOK-INSIDE LOOK-DOWN>
		<TELL "The ">
		<COND (.OPEN?
		       <TELL "broken ">)>
		<PRINTD ,DCASE>
	        <COND (<FIRST? ,DCASE>
		       <TELL " contains ">
		       <PRINT-CONTENTS ,DCASE>)
		      (T
		       <TELL " is empty">)>
		<TELL ". ">
		<SAY-DCASE-SIGN>
		<RTRUE>)
	       (<OR <VERB? LOOK-ON>
		    <AND <VERB? PUT-ON>
		         <EQUAL? ,PRSI ,DCASE>>>
		<TOO-HIGH ,DCASE>
		<RTRUE>)
	       (<VERB? READ>
		<SAY-DCASE-SIGN>
		<RTRUE>)
	       (<AND <VERB? MUNG KILL>
		     <EQUAL? ,PRSO ,DCASE>>
		<COND (.OPEN?
		       <ALREADY-BROKE-IT>)
		      
		      (<NOT ,PRSI>
		       <TELL "(with " D ,HANDS ")" CR>
		       <TRY-BREAK "hand">)
		     		      		      
		      (<OR <EQUAL? ,PRSI ,BROOM ,BRANCH ,CONCH-SHELL>
		       	   <EQUAL? ,PRSI ,BOTTLE ,UMBRELLA ,SHOE>>
		       <COND (<AND <EQUAL? ,PRSI ,BROOM>
				   ,BROOM-SIT?>
			      <GET-OFF-BROOM-FIRST>)>
		       <FCLEAR ,DCASE ,DOORBIT>
		       <FSET ,DCASE ,TRANSBIT>
		       <FSET ,DCASE ,OPENBIT>
		       <FSET ,DCASE ,RMUNGBIT>
		       <TELL "Crash! You broke the " D ,DCASE " open with ">
		       <ARTICLE ,PRSI T>
		       <TELL D ,PRSI "." CR>
		       <COND (<NOT <FSET? ,SW2 ,OPENBIT>>
			      <TELL CR
"The tinkle of broken glass is drowned out by the blare of an electric security alarm! You stand frozen with fear as " D ,MACGUFFIN " strides into the " 
D ,MUSEUM " and drags you to ">
			      <TORTURE-ENDING>
			      <RFATAL>)>)
		      
		      (<OR <EQUAL? <LOC ,PRSI> ,GLOBAL-OBJECTS ,LOCAL-GLOBALS>
			   <EQUAL? ,PRSI ,DCASE>>
		       <WHAT-A-CONCEPT>)
		      (<DONT-HAVE? ,PRSI>
		       <RTRUE>)
		      (<EQUAL? ,PRSI ,WISHBRINGER>
		       <TELL "The stone is too small." CR>)
		      (T
		       <TELL 
"You'd never break the " D ,DCASE " with that!" CR>)>
		<RTRUE>)
	       
	       (<AND <VERB? THROW>
		     <EQUAL? ,PRSI ,DCASE>>
		<SET THING ,PRSO>
		<TELL "Thrown." CR CR>
		<PERFORM ,V?MUNG ,DCASE ,PRSO>
		<MOVE .THING ,HERE>
		<RTRUE>)
	       
	       (<VERB? KICK>
		<COND (.OPEN?
		       <ALREADY-BROKE-IT>)
		      (T
		       <TRY-BREAK "foot">)>
		<RTRUE>)

	       (<GETTING-INTO?>
		<TELL <PICK-ONE ,YUKS> CR>
		<RTRUE>)
	       
	       (<MOVING? ,DCASE>
		<TOO-LARGE ,DCASE>
		<RTRUE>)
	       (<AND <VERB? CLOSE>
		     .OPEN?>
		<ALREADY-BROKE-IT>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE ALREADY-BROKE-IT ()
	 <SAY-THE ,DCASE>
	 <TELL " is broken, remember?" CR>>

<ROUTINE SAY-DCASE-SIGN ()
	 <TELL "A " D ,SIGN " on the " D ,DCASE " reads, \"">
	 <FROBOZZ "Burglar Alarm">
	 <TELL ".\"" CR>>

<ROUTINE TRY-BREAK (STR)
	 <SAY-THE ,DCASE>
	 <TELL " is still intact, but your " .STR " isn't. Ouch!" CR>>

<ROUTINE TORTURE-ENDING ()
	 <TELL 
"the Tower, where you're subjected to months of slow, painful torture at the skilled hands of" ,EONE ".">
	 <BAD-ENDING>>

<OBJECT SCULPTURE
	(IN DCASE)
	(DESC "sculpture")
	(SYNONYM SCULPTURE HOLE CHAOS ; CAT)
	(ADJECTIVE BLACK MARBLE FOREHEAD HEAD)
	(FLAGS NDESCBIT TAKEBIT SURFACEBIT CONTBIT OPENBIT)
	(SIZE 5)
	(CAPACITY 1)
	(VALUE 0)
	(ACTION SCULPTURE-F)>

<ROUTINE SCULPTURE-F ()
	 <COND (<VERB? EXAMINE>
		<TELL 
"The black marble " D ,SCULPTURE " is about 14 inches high. It's exquisitely crafted in the likeness of a cat." CR CR>
		<TELL ,YOU-SEE 
"a round, shallow hole carved into the forehead of the " D ,SCULPTURE "." CR>
		<RTRUE>)
	       
	       (<AND <VERB? PUT PUT-ON>
		     <EQUAL? ,PRSI ,SCULPTURE>>
		<COND ; (<DONT-HAVE? ,SCULPTURE>
		         <RTRUE>)
		      (<EQUAL? ,PRSO ,WISHBRINGER>
		       <REPEAT ()
			       <COND (<DO-END>
			              <TELL CR
"Do you still want to put " ,GAME " into the " D ,SCULPTURE "?">
			              <COND (<NOT <YES?>>
				             <TELL ,OKAY
"you're still holding " ,GAME "." CR>
				             <RETURN>)>)
				     (T
				      <RETURN>)>>
		       <RFATAL>)
		      (<G? <GETP ,PRSO ,P?SIZE> 1>
		       <TOO-LARGE ,PRSO>)
		      (T
		       <SAY-THE ,PRSO>
		       <TELL " falls out of the " D ,SCULPTURE>
		       <AND-DROPS-OUT ,PRSO>)>
		<RTRUE>)
	       (<OR <VERB? THROW>
		    <HURT? ,SCULPTURE>>
		<RUIN ,SCULPTURE>
		<RTRUE>)
	       (T
		<RFALSE>)>>   

<GLOBAL WIN-TRY 3>

<ROUTINE DO-END ("AUX" (GOT? <>))
	 <SETG WIN-TRY <- ,WIN-TRY 1>>
	 <COND (<EQUAL? ,WIN-TRY 2>
		<MOVE ,EVIL-ONE ,HERE>
		<SETG WOMAN-SCRIPT 5>
		<ENABLE <QUEUE I-PLEA -1>>
		<TELL ,GAME " glows brighter as it nears the "
D ,SCULPTURE ". It looks like it will fit perfectly into the black forehead.|
|
\"Wait!\" commands a familiar voice.|
|
You turn, and see the figure of an " D ,OLD-WOMAN " standing ">
		<COND (,FUZZY?
		       <TELL "nearby...">
		       <DARK-BEING>)
		      (T
		       <TELL "in the " D ,DARKNESS 
			     " of the " D ,CORRIDOR ".">)>
		<TELL CR CR "\"Your quest is ended" ,ADVENTURER
		      ",\" says the " D ,OLD-WOMAN ". \"The " D ,SCULPTURE
		      " you ">
		<COND (<IN? ,SCULPTURE ,PROTAGONIST>
		       <TELL "hold">)
		      (T
		       <TELL "see before you">)>
		<TELL " is " D ,CHAOS 
", the Cat Which Was Stolen. Now give " ,GAME 
" to me, and together we shall rejoice in your success.\"" CR>
		<RTRUE>)
	       
	       (<EQUAL? ,WIN-TRY 1>
	        <TELL
"\"Don't!\" barks the " D ,OLD-WOMAN " as " D ,HANDS " moves closer to the " 
D ,SCULPTURE "." CR>
		<RTRUE>)
	       
	       (T
		<SET GOT? <IN? ,SCULPTURE ,PROTAGONIST>>
		<TELL
"\"No!\"|
|
A blast of Magick shakes the building as " ,GAME " touches the forehead of the " D ,SCULPTURE ". Violet sheets of energy, pure and brilliant, erupt from the very heart of the Stone and illuminate the room like daylight.|
|
The woman's disguise evaporates in the glare. It's" ,EONE ", her mouth frozen open in a wail of despair as she fades into oblivion. The memory of that face will haunt your dreams as long as you live.|
|
You ">
		<COND (.GOT?
		       <TELL 
"feel the " D ,SCULPTURE " become soft and warm in " D ,HANDS "s">)
		      (T
		       <TELL 
"watch as the " D ,SCULPTURE " begins to soften in the radiance">)>
		<TELL ". It wriggles like a thing alive, leaps ">
		<COND (.GOT?
		       <TELL "out of your arms">)
		      (T
		       <TELL "across the floor">)>
		<TELL " and disappears into a vortex of color. The " D ,LIBRARY
" folds around you like the closing of a great book...">
		<DISABLE <INT I-PLEA>>
		<REMOVE ,SCULPTURE>
		<MOVE ,CHAOS ,CLIFF-EDGE>
		<SETG GSCORE <+ ,GSCORE 5>>
		<SETG SCORE 6>
		<SETG MOVES 0>
		<TO-FINISH>
		<SETG SUCCESS? T>
	      ; <COND (<G? ,SCORE 5>
		       <SETG SCORE 0>)>
	      ; <SET GOT? <SPIN-DIAL 6 3>>
	      ; <SETG HERE ,CLIFF-EDGE>
		<V-LOOK>
		<RFALSE>)>>

<ROUTINE I-PLEA ("AUX" STONE-LOC)
	 ; <COND (,FUZZY?
		  <RTRUE>)>
	 <THIS-IS-IT ,EVIL-ONE>
	 <THIS-IS-IT ,WISHBRINGER>
	 <COND (,FUZZY?
		<SETG FUZZY? <>>
		<FCLEAR ,GLASSES ,WORNBIT>
	        <REMOVE ,GLASSES>
	        <TELL CR "\"Take off those glasses!\" commands the " 
D ,OLD-WOMAN " sharply. To your astonishment, the " D ,GLASSES " leaps away from your eyes and disappears in a silent flash." CR CR>	        
	        <SETG HERE ,FUZZY-FROM>
	        <MOVE ,PROTAGONIST ,HERE>
	        <COND (<NOT <IN? ,EVIL-ONE ,HERE>>
		       <MOVE ,EVIL-ONE ,HERE>)>
		<V-LOOK>
		<RTRUE>)>
	 <SET STONE-LOC <LOC ,WISHBRINGER>>
	 <SETG WOMAN-SCRIPT <- ,WOMAN-SCRIPT 1>>
	 <CRLF>
	 <COND (<OR <EQUAL? .STONE-LOC ,HERE ,DCASE ,CDESK>
		    <EQUAL? .STONE-LOC ,FOSSIL ,COAT>>
		<SAY-THE ,OLD-WOMAN>
		<TELL " snatches away the Stone,">
		<EVIL-ONE-TAKES-STONE>)
	       (<EQUAL? ,WOMAN-SCRIPT 4>
		<SAY-THE ,OLD-WOMAN>
		<TELL " steps out of the " D ,DARKNESS " and moves towards you. \"Give me the Stone,\" she says. \"I want to make certain you haven't damaged it.\"" CR>)
	       (<EQUAL? ,WOMAN-SCRIPT 3>
		<TELL
"\"Let me touch " ,GAME ",\" says the " D ,OLD-WOMAN ", inching closer. \"I want to hold it again in my hands.\"|
|
You feel your fingers relaxing as she speaks." CR>)
	       
	       (<EQUAL? ,WOMAN-SCRIPT 2>
		<TELL
"\"Quickly!\" snaps the " D ,OLD-WOMAN " impatiently. \"Give me the Magick Stone. You have no use for it now!\"|
|
Your fingers are beginning to lose their grip on " ,GAME "." CR>)
	       (<EQUAL? ,WOMAN-SCRIPT 1>
		<SAY-THE ,OLD-WOMAN>
	        <TELL " stretches out her clawlike hand. \"If you will not give the Stone to me freely,\" she growls, \"I will have no choice but to take it.\"|
|
Your hand is trembling violently. It wants to give her " ,GAME "!" CR>)
	       (T
		<TELL "\"Yield!\" commands the woman sharply.|
|
The " D ,WISHBRINGER " leaps out of " D ,HANDS " and into the " 
D ,OLD-WOMAN "'s bony fingers. She">
	        <EVIL-ONE-TAKES-STONE>)>>
	        
<ROUTINE EVIL-ONE-TAKES-STONE ()
	 <DISABLE <INT I-PLEA>>
	 <TELL " holds it up and gazes into its depths. \"" ,GAME
",\" she whispers, deep in her throat.|
|
The Stone begins to pulse with crimson light. In its sinister glow, the "
D ,OLD-WOMAN "'s disguise melts away. It's" ,EONE "!|
|
\"A fool!\" she cackles wildly, and the " D ,SCULPTURE " shatters to pieces at the sound. \"My sister was a fool to send the likes of you on such a quest! Does she think a mail clerk can save the world from Wickedness? Be gone!\"|
|
With a wave of her warty hand," ,EONE " turns you into a " 
<PICK-ONE ,TURNS> ".">
	 <BAD-ENDING>
	 <RTRUE>>
	 
<GLOBAL TURNS
	<LTABLE 0
	 "furry toilet seat cover"
	 "giant army boot"
	 "newt">>

<GLOBAL EONE " the Evil One">

<OBJECT EVIL-ONE
	(DESC "old woman")
	(SYNONYM ONE WOMAN LADY BEING)
	(ADJECTIVE EVIL OLD WITCH)
	(FLAGS VOWELBIT NDESCBIT ACTORBIT)
	(ACTION EVIL-ONE-F)>

<ROUTINE EVIL-ONE-F ("OPTIONAL" (CONTEXT <>))
	 <THIS-IS-IT ,EVIL-ONE>
	 <COND (<VERB? EXAMINE>
		<COND (<EQUAL? ,HERE ,INSIDE-THEATER>
		       <TELL "She's">
		       <DARK-BEING>)
		      (T
		       <TELL 
"It looks like the " D ,OLD-WOMAN " you met at the " D ,MAGICK-SHOPPE ".|
|
(Hmm. The outline of the woman is " <PICK-ONE ,BLURS> ", like a double image. Must be your eyes getting tired or something.)">)>
		<CRLF>
		<RTRUE>)
	       
	       (<IMAGE? ,EVIL-ONE>
		<RFATAL>)
	       
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,EVIL-ONE>>
		<COND (<EQUAL? ,PRSO ,WISHBRINGER>
		       <SAY-THE ,OLD-WOMAN>
		       <TELL " takes " ,GAME " from you,">
		       <EVIL-ONE-TAKES-STONE>)
		      (T
		       <GESTURE " refuses your offer">)>
		<RTRUE>)

	       (<OR <TALKING-TO? ,EVIL-ONE>
		    <VERB? YELL>>
		<GESTURE " silences you">
		<RFATAL>)
	       
	       (<OR <HURT? ,EVIL-ONE>
		    <VERB? RUB KISS SQUEEZE>>
		<TELL "Don't try it. This " D ,OLD-WOMAN " looks tough!" CR>
		<RTRUE>)
	       
	       (T
		<RFALSE>)>>
	         
<ROUTINE GESTURE (STR)
	 <SAY-THE ,OLD-WOMAN>
	 <TELL .STR " with an impatient gesture." CR>>

<ROUTINE DARK-BEING ()
	 <TELL " a dark, sinister being with terrible eyes!">>

"*** ROTARY NORTH ***"

<OBJECT ROTARY-NORTH
	(IN ROOMS)
	(DESC "Rotary North")
	(FLAGS ONBIT RLANDBIT)
	(GLOBAL CHURCH CHURCH-DOOR WINDOW)
	(NORTH TO SOUTH-OF-BRIDGE)
	(EAST TO ROTARY-EAST)
	(SOUTH TO PARK)
	(WEST TO ROTARY-WEST)
	(IN PER ENTER-CHURCH)
	(ACTION ROTARY-NORTH-F)
	(PSEUDO "ROTARY" HERE-F)>

<ROUTINE ROTARY-NORTH-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "This is the northern side of the">
		<WHICH-TOWN "Rotary">
		<TELL ". A road leads north, towards the river.|
|
On the " D ,CORNER " stands a ">
		<COND (,SKEWED?
		       <TELL "broken-down old " D ,CHURCH 
" that looks as if it hasn't been used for years." CR>)
		      (T
		       <TELL
"quaint " D ,FESTERON " " D ,CHURCH ". Its little white steeple is straight out of a country postcard. ">
		       <SAY-DOOR ,CHURCH-DOOR>)>)>>

<ROUTINE ENTER-CHURCH ()
	 <COND (<FSET? ,CHURCH-DOOR ,OPENBIT>
		<COND (<FSET? ,CHURCH ,RMUNGBIT>
		       <FCLEAR ,CHURCH ,RMUNGBIT>
		       <ENABLE <QUEUE I-RODENT -1>>)>
		<RETURN ,INSIDE-CHURCH>)
	       (T
		<ITS-CLOSED ,CHURCH-DOOR>
		<RFALSE>)>>

<ROUTINE I-RODENT ()
	 <COND (<OR ,FUZZY? ,ECLIPSE?>
		<RTRUE>)
	       (<FSET? ,CHURCH ,TOOLBIT>
		<FCLEAR ,CHURCH ,TOOLBIT>)
	       (<AND <EQUAL? ,HERE ,INSIDE-CHURCH>
		     ,LIT>
		<DISABLE <INT I-RODENT>>
		<FCLEAR ,CHURCH ,TOUCHBIT>
		<TELL CR "As you look around the empty " D ,CHURCH " a ">
		<COND (,SKEWED?
		       <TELL "big brown rat">)
		      (T
		       <TELL "little white mouse">)>
		<TELL " scurries across the ">
		<COND (,SKEWED?
		       <TELL "broken glass">)
		      (T
		       <TELL "floor">)>
	        <TELL " and disappears." CR>)>>

"*** INSIDE CHURCH ***"

<OBJECT INSIDE-CHURCH
	(IN ROOMS)
	(DESC "Church")
	(FLAGS ONBIT RLANDBIT INDOORSBIT)
	(GLOBAL CHURCH CHURCH-DOOR WINDOW AISLE)
	(OUT TO ROTARY-NORTH IF CHURCH-DOOR IS OPEN)
	(ACTION INSIDE-CHURCH-F)>

<ROUTINE INSIDE-CHURCH-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<STANDING>
		<TELL "inside a">
		<COND (,SKEWED?
		       <TELL
"n abandoned old " D ,CHURCH ". The aisles are littered with debris and bits of colored glass; everything is coated with a thick layer of dust">) 
		      (T
		       <TELL
" beautiful old " D ,CHURCH ". The aisles are diffused with rich colored light streaming in through the stained glass " D ,WINDOW "s">)>
		<TELL "." CR>)>>

<OBJECT SPEAKER
	(DESC "speaker")
	(SYNONYM SPEAKER LOUDSPEAKER)
	(FLAGS NDESCBIT)
	(ACTION SPEAKER-F)>

<ROUTINE SPEAKER-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE LOOK-ON LISTEN>
		<TELL "It's burned out." CR>
		<RTRUE>)
	       (<TOUCHING? ,SPEAKER>
		<TOO-HIGH ,SPEAKER>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,SPEAKER>
		<RFATAL>)>>

<GLOBAL CANDLE-TAKEN? <>>

<OBJECT CANDLE
	(IN INSIDE-CHURCH)
	(DESC "candle")
	(FDESC "A lighted candle is visible in a nook near the exit.")
	(SYNONYM CANDLE LIGHT)
	(ADJECTIVE LIGHTED LIT)
	(FLAGS TAKEBIT ONBIT FLAMEBIT)
	(ACTION CANDLE-F)
	(VALUE 0)
	(SIZE 5)>

; "RMUNGBIT = candle blown out in library"

<ROUTINE CANDLE-F ()
	 <COND (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,CANDLE>
		     <NOT ,CANDLE-TAKEN?>>
		<COND (<ITAKE>
		       <TELL "A voice from above ">
		       <COND (,SKEWED?
		              <SETG CANDLE-TAKEN? T>
		              <TELL "begins to proclaim something, but">
			      <STATIC>
			      <TELL " drowns out the solemn words. Looking up, you notice a speaker in the ceiling emitting sparks.|
|
Taken.">)
		             (T
		              <MOVE ,CANDLE ,INSIDE-CHURCH>
		              <TELL 
"solemnly proclaims, \"Thou shalt not steal.\"">)>
		       <CRLF>)>
		<RTRUE>)
	       (<VERB? LAMP-OFF BLOW-INTO>
		<COND (<FSET? ,CANDLE ,ONBIT>
		       <BEST-EFFORTS ,CANDLE 
				     "flame stubbornly refuses to go out">)
		      (T
		       <BUT-THE ,CANDLE>
		       <TELL "isn't lit!" CR>)>
		<RTRUE>)
	       (<AND <VERB? PUT-ON>
		     <EQUAL? ,PRSI ,CANDLE>
		     <FSET? ,CANDLE ,ONBIT>>
		<PERFORM ,V?BURN ,PRSO ,CANDLE>
		<RTRUE>)
	       (T
	        <RFALSE>)>>
		      
<ROUTINE STATIC ()
	 <TELL " a burst of static">>

<ROUTINE BEST-EFFORTS (THING STR)
	 <COND (<PROB 50>
		<TELL "Strange">)
	       (T
		<TELL "That's odd">)>
	 <TELL ". Despite your best efforts, the " D .THING " " .STR "." CR>>

<OBJECT CHURCH-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "church door")
	(SYNONYM DOOR ENTRANCE ENTRY LOCK)
	(ADJECTIVE CHURCH)
	(FLAGS DOORBIT OPENBIT NDESCBIT)>

<OBJECT CHURCH
	(IN LOCAL-GLOBALS)
	(DESC "church")
	(SYNONYM CHURCH BUILDING TEMPLE SYNAGO)
	(ADJECTIVE BROKEN OLD)
	(FLAGS NDESCBIT RMUNGBIT TOUCHBIT TOOLBIT)
	(ACTION CHURCH-F)>

; "RMUNGBIT = rodent not yet activated, 
   TOUCHBIT = rodent not yet seen,
   TOOLBIT = one move not passed before seeing rodent"

<ROUTINE CHURCH-F ()
	 <COND (<ENTER-FROM? ,ROTARY-NORTH ,INSIDE-CHURCH ,CHURCH>
		<RTRUE>)
	       (<VERB? EXAMINE LOOK-ON>
	        <V-LOOK>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE>
		<COND (<EQUAL? ,HERE ,INSIDE-CHURCH>
		       <V-LOOK>)
		      (T
		       <GO-INSIDE>)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE CHURCH-WINDOWS-F ()
	 <COND (<VERB? EXAMINE>
		<SAY-THE ,WINDOW>
		<TELL "s ">
		<COND (,SKEWED?
		       <TELL "are all broken">)
		      (T
		       <TELL "glow with rich colors">)>
		<TELL "." CR>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE>
		<COND (,SKEWED?
		       <COND (<EQUAL? ,HERE ,ROTARY-NORTH>
			      <GO-INSIDE>)
			     (T
			      <NOTHING-INTERESTING T>)>)
		      (T
		       <TELL ,CANT ". ">
		       <SAY-THE ,WINDOW>
		       <TELL "s are too thick." CR>)>
		<RTRUE>)
	       (<HURT? ,WINDOW>
		<COND (,SKEWED?
		       <TELL "They're already broken!" CR>)
		      (T
		       <HOW-WOULD-YOU-LIKE-IT ,WINDOW>)>
		<RTRUE>)
	       (<VERB? OPEN CLOSE PUSH MOVE>
		<SAY-THE ,WINDOW>
		<TELL "s are ">
		<COND (,SKEWED?
		       <TELL "broken!">)
		      (T
		       <TELL "too heavy to move.">)>
		<CRLF>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,WINDOW>
		<RFATAL>)>>

<OBJECT CDEBRIS
	(DESC "debris")
	(SYNONYM DEBRIS GLASS BITS)
	(ADJECTIVE COLORED BROKEN)
	(FLAGS NDESCBIT)
	(ACTION CDEBRIS-F)>

<ROUTINE CDEBRIS-F ()
	 <COND (<VERB? EXAMINE LOOK-ON>
		<NOTHING-INTERESTING T>
		<RTRUE>)
	       (<VERB? SEARCH LOOK-INSIDE LOOK-UNDER>
		<NOTHING-INTERESTING>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,CDEBRIS>
		<RFATAL>)>> 
		       
"*** JAIL CELL ***"

<OBJECT JAIL-CELL
	(IN ROOMS)
	(DESC "Jail Cell")
	(FLAGS ONBIT RLANDBIT INDOORSBIT)
	(GLOBAL POLICE-STATION CELL CELL-DOOR HIDDEN-HATCH)
	(DOWN PER THROUGH-HATCH?)
	(IN PER THROUGH-HATCH?)
	(OUT "You're locked inside!")
	(ACTION JAIL-CELL-F)>

<ROUTINE JAIL-CELL-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL 
"You're locked inside a damp, uncomfortable jail cell. Its thick steel door and stone walls offer little hope for escape.|
|
The only furnishing is a hard bunk ">
		<COND (<FSET? ,BUNK ,RMUNGBIT>
		       <TELL "in the middle of the floor">)
		      (T
		       <TELL "against the wall">)>
		<COND (<FIRST? ,BUNK>
		       <TELL " with ">
		       <PRINT-CONTENTS ,BUNK>
		       <TELL " on it">)>
		<TELL "." CR>
		<COND (<FSET? ,BUNK ,RMUNGBIT>
		       <CRLF>
		       <SEE-HOLE>)>)>>

<OBJECT CELL
	(IN LOCAL-GLOBALS)
	(DESC "cell")
	(SYNONYM CELL CELLS)
	(ADJECTIVE JAIL)
	(FLAGS NDESCBIT)
	(ACTION CELL-F)>

<ROUTINE CELL-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE>
		<COND (<EQUAL? ,HERE ,JAIL-CELL>
		       <V-LOOK>)
		      (T
		       <COND (,SKEWED?
			      <TELL "They don't">)
			     (T
			      <TELL "It doesn't">)>
		       <TELL " look very comfortable." CR>)>
		<RTRUE>)
	       (<AND <VERB? WALK-TO THROUGH ENTER>
		     <EQUAL? ,HERE ,INSIDE-POLICE-STATION>>
		<COND (,SKEWED?
		       <TELL
D ,MACGUFFIN " smirks. \"You'll be in one soon enough.\"" CR>)
		      (T
		       <CELL-DOOR-IS-SECURE>)>
		<RTRUE>)
	       (<CELL-DOOR-F>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE CELL-DOOR-IS-SECURE ()
	 <TELL "The lock on the " D ,CELL-DOOR " is very secure." CR>>

<OBJECT CELL-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "cell door")
	(SYNONYM DOOR BARS LOCK)
	(ADJECTIVE CELL)
	(FLAGS DOORBIT LOCKEDBIT NDESCBIT)
	(ACTION CELL-DOOR-F)>

<ROUTINE CELL-DOOR-F ()
	 <COND (<OR <HURT? ,CELL-DOOR>
		    <VERB? EXAMINE SHAKE PICK>>
		<CELL-DOOR-IS-SECURE>
		<RTRUE>)
	       (<VERB? OPEN UNLOCK>
		<NOT-LIKELY ,MACGUFFIN "would lend you the key">
		<RTRUE>)
	       (<VERB? CLOSE LOCK>
		<ALREADY-CLOSED>
		<RTRUE>)
	       (<USE-DOOR? ,INSIDE-POLICE-STATION>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT BUNK
	(IN JAIL-CELL)
	(DESC "bunk")
	(SYNONYM BUNK BED FURNITURE)
	(ADJECTIVE FLIMSY)
	(FLAGS NDESCBIT TRYTAKEBIT SURFACEBIT)
	(CAPACITY 25)
	(ACTION BUNK-F)>

; "RMUNGBIT = BUNK MOVED AWAY FROM WALL"

<ROUTINE BUNK-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE LOOK-ON SEARCH>
		<NOT-CLEAN ,BUNK>
		<COND (<FIRST? ,BUNK>
		       <TELL " There's ">
		       <PRINT-CONTENTS ,BUNK>
		       <TELL " on it.">)>
		<CRLF>
		<RTRUE>)
	       (<AND <VERB? LOOK-UNDER>
		     <NOT <FSET? ,BUNK ,RMUNGBIT>>>
		<SEE-HOLE>		
		<RTRUE>)
	       (<VERB? LOOK-BEHIND>
		<COND (<FSET? ,BUNK ,RMUNGBIT>
		       <SEE-HOLE>)
		      (T
		       <YOUD-HAVE-TO "move" ,BUNK>)>
		<RTRUE>)
	       (<VERB? PUSH MOVE>
		<TELL ,OKAY "you moved the " D ,BUNK>
		<COND (<FSET? ,BUNK ,RMUNGBIT>
		       <FCLEAR ,BUNK ,RMUNGBIT>
		       <FCLEAR ,UNDER-CELL ,ONBIT>
		       <TELL " back up against the wall." CR>)
		      (T
		       <FSET ,BUNK ,RMUNGBIT>
		       <COND (<NOT <FSET? ,HIDDEN-HATCH ,RMUNGBIT>>
			      <FSET ,UNDER-CELL ,ONBIT>)>
		       <TELL " away from the wall. ">
		       <SEE-HOLE>)>
		<RTRUE>)
	       (<GETTING-INTO?>
		<NOT-CLEAN ,BUNK T>
		<CRLF>
		<RTRUE>)
	       (<VERB? OPEN CLOSE>
		<TELL <PICK-ONE ,YUKS> CR>
		<RTRUE>)
	       (<AND <VERB? PUT-UNDER>
		     <EQUAL? ,PRSI ,BUNK>>
		<WASTE-OF-TIME>
		<RTRUE>)
	       (T
		<RFALSE>)>>
		       
<ROUTINE SEE-HOLE ()
	 <FSET ,HIDDEN-HATCH ,TOUCHBIT>
	 <TELL "There's a ">
	 <COND (<FSET? ,HIDDEN-HATCH ,RMUNGBIT>
		<TELL "patch of new concrete o">)
	       (T
		<TELL "dark, narrow hole i">)>
	 <TELL "n the floor." CR>>

<ROUTINE NOT-CLEAN (THING "OPTIONAL" (WARN? <>))
	 <COND (.WARN?
		<TELL "Better not. ">)>
	 <SAY-THE .THING>
	 <TELL " doesn't look very sanitary.">>

<OBJECT BLANKET
	(IN BUNK)
	(DESC "thick blanket")
	(SYNONYM BLANKET)
	(ADJECTIVE THICK)
	(FLAGS WEARBIT TAKEBIT CONTBIT 
	       TRANSBIT SURFACEBIT OPENBIT)
	(VALUE 3)
	(SIZE 10)
	(CAPACITY 5)
	(ACTION BLANKET-F)>
			     
<ROUTINE BLANKET-F ()
	 <COND (<GETTING-INTO?>
		<NOT-CLEAN ,BLANKET T>
		<CRLF>
		<RTRUE>)
	       (<VERB? TAKE>
		<COND (<IN? ,BLANKET ,BABY>
		       <WAKE-BABY>)
		      (T
		       <RFALSE>)>)
	       (<AND <VERB? PUT PUT-ON>
		     <EQUAL? ,PRSI ,BLANKET>>
		<COND (<EQUAL? ,PRSO ,BLANKET>
		       <TELL <PICK-ONE ,YUKS> CR>)
		      (T
		       <NOT-CLEAN ,BLANKET T>
		       <CRLF>)>
		<RTRUE>)
	       (<VERB? EXAMINE LOOK-INSIDE>
		<NOT-CLEAN ,BLANKET>
		<CRLF>
		<RTRUE>)
	       (<VERB? OPEN CLOSE>
		<WASTE-OF-TIME>
		<RTRUE>)
	       (<VERB? LOOK-UNDER>
		<COND (<IN? ,BLANKET ,PROTAGONIST>
		       <TELL "You're holding it!" CR>
		       <RTRUE>)
		      (<IN? ,BLANKET ,BABY>
		       <TELL "There's a " D ,BABY " there." CR>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (T
		<RFALSE>)>>
			     
<OBJECT HIDDEN-HATCH
	(IN LOCAL-GLOBALS)
	(DESC "hole")
	(SYNONYM HOLE CEMENT CONCRETE OPENING)
	(ADJECTIVE DARK NARROW)
	(FLAGS NDESCBIT)
	(ACTION HIDDEN-HATCH-F)>

; "TOUCHBIT = HOLE FOUND, RMUNGBIT = HOLE CEMENTED OVER"

<ROUTINE HIDDEN-HATCH-F ()
	 <COND (<AND <NOT <FSET? ,HIDDEN-HATCH ,TOUCHBIT>>
		     <NOT <EQUAL? ,HERE ,UNDER-CELL>>>
		<CANT-SEE-ANY ,HIDDEN-HATCH>
		<RFATAL>)
	       (<VERB? WALK-TO ENTER THROUGH>
		<COND (<EQUAL? ,HERE ,JAIL-CELL>
		       <DO-WALK ,P?DOWN>)
		      (T
		       <DO-WALK ,P?UP>)>
		<RTRUE>)
	       (<VERB? EXAMINE LOOK-INSIDE>
		<COND (<FSET? ,HIDDEN-HATCH ,RMUNGBIT>
		       <SAY-THE ,HIDDEN-HATCH>
		       <TELL " is sealed with cement." CR>)
		      (<FSET? ,BUNK ,RMUNGBIT>
		       <CANT-MAKE-OUT-ANYTHING>)
		      (T
		       <TELL "The hole is blocked by ">
		       <COND (<EQUAL? ,HERE ,JAIL-CELL>
		              <TELL "the bunk">)
		             (T
		              <TELL 
"something overhead. It looks like the underside of a bed or bunk">)>
		       <TELL "." CR>)>
		<RTRUE>)
	       (<AND <VERB? PUT THROW>
		     <EQUAL? ,PRSI ,HIDDEN-HATCH>>
		<COND (<OR <FSET? ,HIDDEN-HATCH ,RMUNGBIT>
			   <NOT <FSET? ,BUNK ,RMUNGBIT>>>
		       <PERFORM ,V?EXAMINE ,HIDDEN-HATCH>
		       <RFATAL>)
		      (<EQUAL? ,PRSO ,HANDS>
		       <NOTHING-EXCITING>
		       <RTRUE>)
		      (<PUTTING-OPEN-UMBRELLA?>
		       <RTRUE>)
		      (<G? <GETP ,PRSO ,P?SIZE> 10>
		       <TOO-LARGE ,PRSO>
		       <RTRUE>)
		      (<EQUAL? ,HERE ,JAIL-CELL>
		       <MOVE ,PRSO ,UNDER-CELL>)
		      (T
		       <MOVE ,PRSO ,JAIL-CELL>)>
		<TELL ,OKAY>
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO " disappears into the " D ,HIDDEN-HATCH "." CR>
		<RTRUE>)
	       (<FSET? ,HIDDEN-HATCH ,RMUNGBIT>
		<TELL ,CANT " do anything useful with the cement." CR>
		<RFATAL>)
	       (<VERB? REACH-IN>
		<NOTHING-EXCITING>
		<RTRUE>)
	       (T
		<RFALSE>)>>
		
<ROUTINE THROUGH-HATCH? ()
	 <COND (<FSET? ,HIDDEN-HATCH ,RMUNGBIT>
		<TELL ,CANT " pass through solid cement." CR>
		<RFALSE>)
	       (<AND <NOT <FSET? ,HIDDEN-HATCH ,TOUCHBIT>>
		     <EQUAL? ,HERE ,JAIL-CELL>>
		<TELL ,CANT " see any exit that way." CR>
		<RFALSE>)
	       (<FSET? ,BUNK ,RMUNGBIT>
		<COND (<CANT-FIT-INTO? "hole">
		       <RFALSE>)>
		<GET-INTO "hole">
		<COND (<EQUAL? ,HERE ,JAIL-CELL>
		       <RETURN ,UNDER-CELL>)
		      (T
		       <RETURN ,JAIL-CELL>)>)
	       (T
		<PERFORM ,V?EXAMINE ,HIDDEN-HATCH>
		<RFALSE>)>>

<OBJECT PSEUDO-BUNK 
	(IN UNDER-CELL)
	(DESC "bunk")
	(SYNONYM BUNK BED UNDERSIDE BOTTOM)
	(ADJECTIVE FLIMSY)
	(FLAGS NDESCBIT)
	(ACTION PBUNK-F)>

<ROUTINE PBUNK-F ()
	 <COND (<FSET? ,BUNK ,RMUNGBIT>
		<TELL ,CANT ". You">
		<MOVED-THE-BUNK>
		<RFATAL>)
	       (<VERB? EXAMINE LOOK-ON LOOK-UNDER>
		<SAY-THE ,BUNK>
		<TELL 
" looks flimsy. You could probably move it if you tried." CR>
		<RTRUE>)
	       (<VERB? MOVE PULL PUSH>
		<FSET ,HIDDEN-HATCH ,TOUCHBIT>
		<FSET ,BUNK ,RMUNGBIT>
		<FSET ,UNDER-CELL ,ONBIT>
		<SETG LIT T>
		<TELL ,OKAY "you">
		<MOVED-THE-BUNK>
		<TELL CR "Faint light streams in from overhead." CR>		
		<RTRUE>)
	       (<OR <GETTING-INTO?>
		    <VERB? PUT PUT-ON THROW LOOK-BEHIND PUT-UNDER
			   PUT-BEHIND>>
		<TELL <PICK-ONE ,YUKS> CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>
	       
<ROUTINE MOVED-THE-BUNK ()
	 <TELL " moved the bunk away from the hole." CR>>


