"BOXES for WISHBRINGER: (C)1985 Infocom, Inc. All rights reserved."

"*** BAD MAILBOX ***"

<GLOBAL BOX-SEEN? <>>
<GLOBAL BOX-DANGEROUS? <>>

<OBJECT MAILBOX
	(IN PLEASURE-WHARF)
	(DESC "big mailbox")
	(SYNONYM MAILBOX BOX LID)
	(ADJECTIVE MAIL BIG LARGE)
	(FLAGS CONTBIT)
	(ACTION MAILBOX-F)
	(DESCFCN DESCRIBE-MAILBOX)
	(CAPACITY 15)
	(CONTFCN IN-MAILBOX)>

<ROUTINE IN-MAILBOX (CONTEXT)
	 <COND (<AND <EQUAL? .CONTEXT ,M-CONT>
		     <TOUCHING? ,PRSO>>
		<TELL ,CANT " reach into the " D ,MAILBOX "." CR>
		<RFATAL>)
	       (T
		<RFALSE>)>>

<ROUTINE DESCRIBE-MAILBOX (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL "A big">
		<COND (,BOX-DANGEROUS?
		       <TELL ", hungry">)>
		<TELL " mailbox is ">
		<COND (,BOX-DANGEROUS?
		       <TELL "threatening you ">)>
		<TELL "nearby.">)>>

<ROUTINE BY-ITSELF ()
	 <SAY-THE ,MAILBOX>
	 <TELL " is opening and closing all by itself!" CR>>

<ROUTINE MAILBOX-F ()
	 <THIS-IS-IT ,MAILBOX>
	 <COND (<VERB? EXAMINE>
		<COND (,BOX-DANGEROUS?
 		       <BY-ITSELF>)
		      (T
                       <SAY-THE ,MAILBOX>
		       <TELL " seems ordinary enough.">
		       <COND (,SKEWED?
			      <TELL " Or does it?">)>
		       <CRLF>)>
		<RTRUE>)
	       (<VERB? OPEN>
		<COND (,BOX-DANGEROUS?
		       <BY-ITSELF>)
		      (<FSET? ,MAILBOX ,OPENBIT>
		       <ALREADY-OPEN>)
		      (,SKEWED?
		       <TELL "It immediately snaps shut. Bang!" CR>
		       <RFATAL>)
		      (T
		       <ENABLE <QUEUE I-BOX-LID 2>>
		     ; <FSET ,MAILBOX ,OPENBIT>
		     ; <OPENED>
		     ; <CRLF>
		       <NOW-CLOSED-OR-OPEN ,MAILBOX T>)>
		<RTRUE>)
	       (<VERB? CLOSE>
		<COND (,BOX-DANGEROUS?
		       <BY-ITSELF>)
		      (<NOT <FSET? ,MAILBOX ,OPENBIT>>
		       <ALREADY-CLOSED>)
		      (T
		       <DISABLE <INT I-BOX-LID>>
		     ; <FCLEAR ,MAILBOX ,OPENBIT>
		     ; <TELL "Closed." CR>
		       <NOW-CLOSED-OR-OPEN ,MAILBOX>)>
		<RTRUE>)
	       (<HURT? ,MAILBOX>
		<COND (,BOX-DANGEROUS?
		       <BOX-MOOD>)
		      (T
		       <TELL "You shouldn't">
		       <DO-TO>
		       <TELL "government property." CR>)>
	        <RTRUE>)
	       (<AND <VERB? LOOK-INSIDE LOOK-DOWN REACH-IN>
		      ,BOX-DANGEROUS?>
		<BOX-MOOD>
		<RTRUE>)
	       (<AND <VERB? GIVE PUT FEED THROW>
		     <EQUAL? ,PRSI ,MAILBOX>>
		<COND (<EQUAL? ,PRSO ,LEAFLET>
		       <COND (<ENABLED? ,I-WAKE-BOX>
			      <DISABLE <INT I-WAKE-BOX>>)
			     (T
			      <DISABLE <INT I-BAD-BOX>>)>
		       <MOVE ,LEAFLET ,MAILBOX>		       
		       <TELL "Done." CR>
		       <COND (,BOX-DANGEROUS?
			      <SETG BOX-DANGEROUS? <>>
			      <MOVE ,MAILBOX ,STEEP-TRAIL>      
			      <CRLF>
			      <SAY-THE ,MAILBOX>
			      <TELL " gobbles the " D ,LEAFLET 
" down, smacks its lid and belches. \"Mmmm! Good!\"|
|
The satisfied box scrapes slowly out of sight." CR>)>
		       <RTRUE>)
		      (<NOT ,BOX-DANGEROUS?>
		       <RFALSE>)
		      (<EQUAL? ,PRSO ,VIOLET-NOTE>
		       <BOX-SPITS "STAMPED">
		       <RTRUE>)
		      (T
		       <BOX-SPITS "MAIL">
		       <RTRUE>)>) 
	       (T
		<RFALSE>)>>

<ROUTINE BOX-MOOD ()
	 <TELL "Better not. ">
	 <SAY-THE ,MAILBOX>
	 <TELL " isn't in a very good mood." CR>>

<ROUTINE BOX-SPITS (STR)
	 <MOVE ,PRSO ,HERE>
	 <SAY-THE ,MAILBOX>
	 <TELL " spits out ">
	 <ARTICLE ,PRSO T>
	 <TELL D ,PRSO " on the " D ,GROUND ". \"Not " .STR "!\"" CR>>

<ROUTINE I-BOX-LID ()
	 <COND (<IN? ,MAILBOX ,HERE>
		<TELL CR "The ">
		<BIG-LID>
		<TELL "squeaks and">
		<BANGS>)>
       ; <DISABLE <INT I-BOX-LID>>
	 <FCLEAR ,MAILBOX ,OPENBIT>>

<ROUTINE BIG-LID ()
	 <TELL "lid of the " D ,MAILBOX " ">>

<ROUTINE BANGS ()
	 <TELL " snaps shut with a clang." CR>>

<GLOBAL BOX-YELLS
	<LTABLE 0  
	 "Feed me"
	 "I'm hungry"
	 "I want MAIL"
	 "Feed me. I'm HUNGRY"
	 "Mail"
	 "Hungry"
	 "Eat">>

<ROUTINE HUNGRY ()
	 <TELL "\"" <PICK-ONE ,BOX-YELLS> "!\"">>

<GLOBAL BOX-SCRIPT 0>
		       
<ROUTINE I-WAKE-BOX ()
	 <COND (<OR ,FUZZY? ,ECLIPSE?>
		<RTRUE>)
	       (<EQUAL? ,HERE ,PLEASURE-WHARF>
	        <SETG BOX-SCRIPT <+ ,BOX-SCRIPT 1>>
		<THIS-IS-IT ,MAILBOX>
		<CRLF>
		<COND (<EQUAL? ,BOX-SCRIPT 1>
		       <TELL "A voice behind you growls, ">
		       <HUNGRY>
		       <TELL 
" You turn to face the sound, but there's nobody here except you." CR>)
		      
		      (<EQUAL? ,BOX-SCRIPT 2>
		       <TELL "You watch with astonishment as the ">
		       <BIG-LID>
		       <TELL
"slowly opens by itself, then">
		       <BANGS>)
		      
		      (<EQUAL? ,BOX-SCRIPT 3>
		       <SETG BOX-DANGEROUS? T>
		       <TELL "The ">
		       <BIG-LID>
		       <TELL "opens again. ">
		       <HUNGRY>
		       <CRLF>)
		      
		      (<EQUAL? ,BOX-SCRIPT 4>
		       <DISABLE <INT I-WAKE-BOX>>
		       <ENABLE <QUEUE I-BAD-BOX -1>>
		       <SAY-THE ,MAILBOX>
		       <TELL
" begins to clatter like a rusty machine. Your astonishment turns to horror as the mindless thing begins to MOVE! Slowly at first, but with increasing confidence, it scrapes across the planks of the "
D ,PLEASURE-WHARF ", heading straight in your direction!" CR CR "The ">
		       <BIG-LID>
		       <TELL "snaps open with a menacing clang. ">
		       <HUNGRY>
		       <CRLF>)>)>>

<GLOBAL BOX-COMING 0>
<GLOBAL EAT-SCRIPT 0>
<GLOBAL PREVIOUS-LOC <>>

<ROUTINE NO-MAILBOX-ALLOWED? ()
	 <COND (<OR <EQUAL? ,HERE ,WHARF ,PLEASURE-WHARF ,FESTERON-POINT>
		    <EQUAL? ,HERE ,ROTARY-NORTH ,ROTARY-SOUTH ,ROTARY-EAST>
		    <EQUAL? ,HERE ,ROTARY-WEST ,EDGE-OF-LAKE ,RIVER-OUTLET>
		    <EQUAL? ,HERE ,PARK ,LOOKOUT-HILL ,SOUTH-OF-BRIDGE>
		    <EQUAL? ,HERE ,WEST-OF-HOUSE ,ROCKY-PATH>>
		<RFALSE>)
	       (T
		<RTRUE>)>>

; <ROUTINE NO-MAILBOX-ALLOWED? ("AUX" TEMP)
	 <SET TEMP <GET ,BOXES-ALLOWED 0>>
	 <REPEAT ()
		 <COND (<EQUAL? ,HERE <GET ,BOXES-ALLOWED .TEMP>>
			<RFALSE>)
		       (<ZERO? .TEMP>
			<RTRUE>)
		       (T
			<SET TEMP <- .TEMP 1>>)>>>

; <GLOBAL BOXES-ALLOWED
	<PLTABLE
	 WHARF PLEASURE-WHARF PARK ROTARY-NORTH ROTARY-SOUTH ROTARY-EAST
	 ROTARY-WEST EDGE-OF-LAKE RIVER-OUTLET LOOKOUT-HILL SOUTH-OF-BRIDGE
	 WEST-OF-HOUSE FESTERON-POINT>>

<ROUTINE I-BAD-BOX ("AUX" TEMP)
	 <COND (<OR ,FUZZY? ,ECLIPSE?>
		<RTRUE>)
	       (<IN? ,MAILBOX ,HERE>
		<SETG BOX-COMING 0>
		<SETG EAT-SCRIPT <+ ,EAT-SCRIPT 1>>
		<COND (<FIGHT? ,SMALL-BOX>
		       <RTRUE>)
		      (<EQUAL? ,EAT-SCRIPT 1>
		       <SAY-BOX-CLOSER ,BOX-CLOSERS>)
		      (<EQUAL? ,EAT-SCRIPT 2>
		       <SAY-BOX-CLOSER ,BOX-EVEN-CLOSERS>)
		      (T
		       <SETG EAT-SCRIPT 0>
		       <SET TEMP <FIRST? ,PROTAGONIST>>
		       <COND (.TEMP
			      <FCLEAR .TEMP ,WORNBIT>
			      <MOVE .TEMP ,FOSSIL>
			      <CRLF>
			      <SAY-THE ,MAILBOX>
			      <TELL " " <PICK-ONE ,SWIPES> " ">
			      <ARTICLE .TEMP T>
			      <TELL D .TEMP " away from you and swallows it! ">
			      <COND (<PROB 50>
			             <HUNGRY>)>
			      <CRLF>
			      <COND (<EQUAL? .TEMP ,WISHBRINGER ,SHOE>
				     <I-LUCK>
				     <I-GLOW>)>)
			     (T
			      <HUNGRY> <CRLF> <CRLF>
			      <TELL
"With a triumphant roar, the " D ,MAILBOX " trips your feet and sends you sprawling to the " D ,GROUND ". Its snapping lid closes in, and you are Sent.">
			      <BAD-ENDING>)>)>)
	       (T
		<SETG EAT-SCRIPT 0>
		<COND (<EQUAL? ,HERE ,WEST-OF-HOUSE>
		       <RTRUE>)
		      (<NO-MAILBOX-ALLOWED?>
		       <RTRUE>)>
		<COND (<NOT <EQUAL? ,HERE ,PREVIOUS-LOC>>
		       <SETG PREVIOUS-LOC ,HERE>
		       <SETG BOX-COMING 0>)>
		<SETG BOX-COMING <+ ,BOX-COMING 1>>
		<COND ; (<EQUAL? ,BOX-COMING 1>
		         <RTRUE>)
		      (<EQUAL? ,BOX-COMING 2>
		       <TELL CR <PICK-ONE ,BAD-BOX-COMINGS> CR>)
		      (T
		       <MOVE ,MAILBOX ,HERE>
		       <SAY-BOX-CLOSER ,BAD-BOX-ARRIVALS T>
		       <FIGHT? ,SMALL-BOX>)>)>>

<ROUTINE SAY-BOX-CLOSER (LIST "OPTIONAL" (HUNGRY? <>))
	 <CRLF>
	 <SAY-THE ,MAILBOX>
	 <TELL <PICK-ONE .LIST> ".">
	 <COND (<OR .HUNGRY?
		    <PROB 50>>
		<TELL " ">
		<HUNGRY>)>
	 <CRLF>>

<GLOBAL BOX-CLOSERS
	<LTABLE 0
	 " is getting closer"
	 " shouts \"MAIL!\" as it edges closer"
	 "'s lid snaps open and shut with hunger">>

<GLOBAL BOX-EVEN-CLOSERS
	<LTABLE 0
	 " cries, \"Feed me MAIL!\" It's getting very close"
	 " is almost close enough to touch you"
	 " scrapes even closer and snaps its lid">>

<GLOBAL BAD-BOX-COMINGS
	<LTABLE 0 
"You hear a scraping noise nearby. It's getting closer!"
"Something is scraping across the ground nearby. It's coming this way!"
"A distant scraping noise is getting louder.">>

<GLOBAL BAD-BOX-ARRIVALS
	<LTABLE 0 
         " has found you again"
         " scrapes into view"
         " appears nearby">>  

"*** SMALL MAILBOX ***"

<OBJECT SMALL-BOX
	(IN INSIDE-POST-OFFICE)
	(DESC "little mailbox")
	(SYNONYM MAILBOX BOX BOXES LID)
	(ADJECTIVE MAIL SMALL LITTLE PRIVATE)
	(FLAGS CONTBIT NDESCBIT)
	(CAPACITY 10)
	(ACTION SMALL-BOX-F)>

<ROUTINE SMALL-BOX-F ()
	 <THIS-IS-IT ,SMALL-BOX>
	 <COND (<EQUAL? ,HERE ,INSIDE-POST-OFFICE>
		<COND (<PRIVATE-BOXES?>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<AND <VERB? OPEN>
		     <NOT ,HOUSE-VISITED?>>
		<SETG HOUSE-VISITED? T>
		<ENABLE <QUEUE I-WAKE-SMALL-BOX -1>>
		<RFALSE>)
	       (<VERB? EXAMINE>
		<COND (<OR ,BOX-ALIVE?
			   <ENABLED? ,I-WAKE-SMALL-BOX>>
		       <TELL "It's the strangest " D ,SMALL-BOX
		             " you've ever seen." CR>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<AND <VERB? RUB>
		     ,BOX-ALIVE?>
		<SAY-THE ,SMALL-BOX>
		<COOS-AT "your touch">
		<RTRUE>)
	       (<AND <TALKING-TO? ,SMALL-BOX>
		     ,BOX-ALIVE?>
		<SAY-THE ,SMALL-BOX>
		<TELL " doesn't reply, but">
		<COOS-AT "the sound of your voice">
		<RFATAL>)
	       (T
		<RFALSE>)>>
	 
<ROUTINE COOS-AT (STR)
	 <TELL " coos with pleasure at " .STR "." CR>>

<GLOBAL SMALL-SCRIPT 0>
<GLOBAL BOX-ALIVE? <>>

<ROUTINE I-WAKE-SMALL-BOX ()
	 <COND (<OR ,FUZZY? ,ECLIPSE?>
		<RTRUE>)
	       (<EQUAL? ,HERE ,WEST-OF-HOUSE>
		<SETG SMALL-SCRIPT <+ ,SMALL-SCRIPT 1>>
		<CRLF>
		<COND (<EQUAL? ,SMALL-SCRIPT 1>
		       <TELL 
"The edges of the " D ,SMALL-BOX " are beginning to twinkle.">)
		      (<EQUAL? ,SMALL-SCRIPT 2>
		       <SAY-THE ,SMALL-BOX>
		       <TELL
" is engulfed in a sparkling aurora! Tremors of anticipation run up and down its length, and the air sings with Magick.">)
		      (<EQUAL? ,SMALL-SCRIPT 3>
		       <SETG BOX-ALIVE? T>
		       <TELL
"With a gentle pop, the " D ,SMALL-BOX " pulls itself out of the " D ,GROUND
" and cavorts about the grass like a happy rabbit!">)
		      (T
		       <DISABLE <INT I-WAKE-SMALL-BOX>>
		       <ENABLE <QUEUE I-FRIENDLY-BOX -1>>
	               <SAY-THE ,SMALL-BOX>
		       <TELL
" notices you and snaps its tiny lid with joy. It makes a silly">
		       <CLUMP>
		       <TELL "as it">
		       <HOPS-TO-SIDE>)>
		<CRLF>)
	     ; (T
		<DISABLE <INT I-WAKE-SMALL-BOX>>
		<ENABLE <QUEUE I-FRIENDLY-BOX -1>>)>>

<ROUTINE CLUMP ()
	 <TELL " \"clump-clump, clump-clump\" sound ">>

<ROUTINE HOPS-TO-SIDE ()
	 <TELL " hops to your side and rubs lovingly against your sleeve.">>

<GLOBAL SMALL-BOX-COMING 0>
<GLOBAL PREVIOUS-SMALL-LOC <>>

<ROUTINE I-FRIENDLY-BOX ("AUX" TEMP)
	 <COND (<OR ,FUZZY? ,ECLIPSE?>
		<RTRUE>)
	       (<IN? ,SMALL-BOX ,HERE>
		<SETG SMALL-BOX-COMING 0>
		<COND (<FIGHT? ,MAILBOX>
		       <RTRUE>)
		      (<PROB 50>
		       <CRLF>
		       <SAY-THE ,SMALL-BOX>
		       <TELL " " <PICK-ONE ,CUDDLES> "." CR>)>)
	       (T
		<COND (<NO-MAILBOX-ALLOWED?>
		       <RTRUE>)>
		<COND (<NOT <EQUAL? ,HERE ,PREVIOUS-SMALL-LOC>>
		       <SETG PREVIOUS-SMALL-LOC ,HERE>
		       <SETG SMALL-BOX-COMING 0>)>
		<SETG SMALL-BOX-COMING <+ ,SMALL-BOX-COMING 1>>
		<COND (<EQUAL? ,SMALL-BOX-COMING 1>
		       <RTRUE>)
		      (<EQUAL? ,SMALL-BOX-COMING 2>
		       <MOVE ,SMALL-BOX ,HERE>
		       <CRLF>
		       <SAY-THE ,SMALL-BOX>
		       <TELL " \"clump-clumps\" " 
			     <PICK-ONE ,SMALL-BOX-ARRIVALS> "." CR>
		       <FIGHT? ,MAILBOX>)>)>>

<GLOBAL CUDDLES
	<LTABLE 0 
	 "cuddles up around your feet"
	 "rubs your leg"
	 "is watching you eagerly"
	 "nuzzles you lovingly"
	 "hops around with excitement"
	 "snaps playfully at your heels"
	 "is \"clump-clumping\" about happily">>

<GLOBAL SMALL-BOX-ARRIVALS
	<LTABLE 0 
        "into view and snaps a greeting"
        "to your side with a joyful snap"
        "happily into view">>

<ROUTINE FIGHT? (ENEMY)
	 <COND (<AND <IN? .ENEMY ,HERE>
		     <G? ,BOX-SCRIPT 2>>
		<REMOVE ,SMALL-BOX>
		<REMOVE ,MAILBOX>
		<REMOVE ,EXHIBITS>
	        <MOVE ,FOSSIL ,MUSEUM>
		<MOVE-ALL ,SMALL-BOX ,FOSSIL>
		<DISABLE <INT I-FRIENDLY-BOX>>
		<COND (<ENABLED? ,I-WAKE-BOX>
		       <DISABLE <INT I-WAKE-BOX>>)>
		<COND (<ENABLED? ,I-BAD-BOX>
		       <DISABLE <INT I-BAD-BOX>>)>
	        <SETG BOX-ALIVE? <>>
		<TELL CR
"The two mailboxes freeze at the sight of one another.|
|
The " D ,SMALL-BOX " snarls and stands protectively by your side. The "
D ,MAILBOX " emits a frightful growl and throws its lid wide open, displaying rows of ">
		<SHARP-TEETH>
		<TELL 
". A crowd of postal meters and stamp dispensers gathers as the metal warriors circle each other with tense, snapping lids.|
|
With a sudden rush, the " D ,SMALL-BOX " throws itself at the " D ,MAILBOX
" and clamps onto its forefoot. The " D ,MAILBOX 
" roars with anger, bites the " D ,SMALL-BOX " viciously and tries in vain to shake it off. You stare in wonder as the fighting boxes swell to twice their normal size, then four times larger, eight times!|
|
The " D ,MAILBOX " frees itself with a savage twist and bends to finish its foe. The " D ,SMALL-BOX " dodges, grips the descending lid and holds on for dear life. Locked in mortal combat, the giant boxes roll over and over, shaking the earth with the thunder of battle.|
|
The scene disappears under a cloud of dust. You hear a terrible scream of agony, then an even more terrible silence. When the air clears, the boxes and spectators are gone." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

"*** BOOTS ***"

<OBJECT BOOTS
	(DESC "boots")
	(SYNONYM BOOTS PATROL)
	(ADJECTIVE BOOT TALL)
	(FLAGS NARTICLEBIT ACTORBIT NDESCBIT)>

<ROUTINE DEPOSIT-BRANCH ()
	 <COND (<IN? ,BRANCH ,PROTAGONIST>
		<MOVE ,BRANCH ,HERE>)
	       (<IN? ,BROOM ,PROTAGONIST>
		<SETG BROOM-SIT? <>>
		<MOVE ,BROOM ,HERE>)>>

<ROUTINE TRAMP ()
	 <TELL " tramp of marching " D ,BOOTS " ">>

<ROUTINE COMING-THIS-WAY ()
	 <TELL " It sounds as if they're coming this way!">>

<GLOBAL JAIL-VISITS 0>  ; "# times jail visited"

<ROUTINE TO-JAIL ()
	 <SETG ON-STUMP? <>>
	 <COND (<ZERO? ,JAIL-VISITS>
		<SETG JAIL-SCRIPT 24>
		<DISABLE <INT I-BREAK-IN>>
		<ENABLE <QUEUE I-JAIL -1>>)    ; "In case you snuck in"
	       (T
		<SETG JAIL-SCRIPT 16>)>        ; "fewer turns for 2nd visit"
	 <SETG JAIL-VISITS <+ ,JAIL-VISITS 1>> ; "New visit!"
	 <MOVE ,PROTAGONIST ,JAIL-CELL>
	 <SETG HERE ,JAIL-CELL>
	 <MOVE-ALL ,PROTAGONIST ,JAIL-CELL>
	 <COND (<G? ,JAIL-VISITS 1>
		<FCLEAR ,BUNK ,RMUNGBIT>
		<FCLEAR ,UNDER-CELL ,ONBIT>
		<FCLEAR ,UNDER-CELL ,TOUCHBIT>)>
       	 <CRLF>
	 <CRLF>
	 <V-LOOK>
	 <I-LUCK>
	 <I-GLOW>>

<ROUTINE EVIL-VOICES ()
	 <TELL "evil voices down the " D ,CORRIDOR>>

<ROUTINE HEAR-WAILS ()
	 <TELL ,YOU-HEAR <PICK-ONE ,JAIL-SOUNDS> " from ">
	 <COND (<PROB 50>
		<TELL "an adjacent cell">)
	       (T
		<TELL "the " D ,CORRIDOR " outside">)>
	 <TELL "." CR>>

<GLOBAL JAIL-SOUNDS
	<LTABLE 0
	 "wails of anguish"
	 "somebody howling with pain"
	 "sounds of violence" 
	 "an agonized cry">>

<ROUTINE SHARK-SNACK ()
	 <TELL 
" with this jailbreaker any more tonight, do we?\" The surrounding "
D ,BOOTS " grunt in sympathy. \"No, of course not. Let's ">
	 <COND (<NOT <EQUAL? ,HERE ,WHARF ,PLEASURE-WHARF>>
		<TELL "pay a visit to the " D ,PLEASURE-WHARF ", and ">)>
	 <TELL "give the " D ,SHARKS " a little bedtime snack!\"">>

<ROUTINE THROWN-OVER-SHOULDER ()
	 <TELL CR CR
"You're thrown into an especially smelly Boot and carried, kicking and screaming, to ">>
	 
<ROUTINE INTO-BAY ()
	 <TELL 
"the edge of the " D ,PLEASURE-WHARF ". With a mighty swing, you're thrown high into the air and fall with a splash into the churning waters of">
	 <WHICH-TOWN "Bay">
	 <TELL ".|
|
The " D ,BOOTS " on the wharf stomp and hoot as a black fin rises above the waves. It circles slowly, getting closer. You shut your eyes and pray that the end will be quick and not too painful...">
	 <COND (,HORSE-SAVED?
		<SAVED-BY-HORSES>)
	       (T
		<BAD-ENDING>)>>

<ROUTINE SAVED-BY-HORSES ()
	 <REMOVE ,BOOTS>
	 <DISABLE <INT I-JAIL>>
	 <DISABLE <INT I-BOOT-PATROL>>
	 <TELL CR CR
"\"Hop on!\"|
|
The tiny voice is somewhere near your left ear. \"Don't just thrash about with your eyes shut. Hop on!\"|
|
The " D ,BOOTS " on the " D ,PLEASURE-WHARF " have stopped hooting and started screaming. Timidly, you open one eye.|
|
The bay is boiling with thousands of " D ,HORSE "s! They leap from the waves like wet little rockets, splashing the " D ,PLEASURE-WHARF " with black, oily water. Many of the " D ,BOOTS " have already slipped and fallen into the sea; and a black fin is gliding confidently in their direction.|
|
\"What are you waiting for? Halloween?\"|
|
The familiar " D ,HORSE " at your ear urges you to a nearby buoy. You grasp it with your last ounce of strength and feel yourself speeding across the bay, propelled by dozens of " D ,HORSE "s reined to the buoy with seaweed.|
|
\"I don't mind returning a favor,\" remarks the " D ,HORSE " as your brain sinks into oblivion, \"but can't you pick a better night to go swimming?\"">
	 <FCLEAR ,POLICE-DOOR ,OPENBIT>
	 <FSET ,POLICE-DOOR ,LOCKEDBIT>
	 <MOVE ,PROTAGONIST ,FESTERON-POINT>
	 <SETG HERE ,FESTERON-POINT>
	 <MOVE-ALL ,PROTAGONIST ,FESTERON-POINT>
	 <COME-TO-SENSES>>

<ROUTINE JAIL-AGAIN ()
	 <FSET ,HIDDEN-HATCH ,RMUNGBIT>
	 <REMOVE ,PSEUDO-BUNK>
	 <FCLEAR ,HIDDEN-HATCH ,TOUCHBIT>
	 <TELL "\"Well, well. If it isn't the disappearing mail clerk.\" You open your mouth to reply, but a vicious little kick changes your mind. \"The Tower wants a chat with this troublemaker.\"|
|
\"The " D ,SHARKS " are getting restless,\" remarks the Tall Boot hopefully." 
CR CR D ,MACGUFFIN " smirks. \"So is" ,EONE ".\"">>

; "Table for BUTTON-F"

<GLOBAL DESTINATIONS
	<PLTABLE
	 <PLTABLE <> <> EDGE-OF-LAKE <> <>>
	 <PLTABLE <> LOOKOUT-HILL ROTARY-WEST INSIDE-GRAVE <>>
	 <PLTABLE SOUTH-OF-BRIDGE ROTARY-NORTH PARK ROTARY-SOUTH HILLTOP>
	 <PLTABLE <> WEST-OF-HOUSE ROTARY-EAST VIDEO-ARCADE <>>
	 <PLTABLE <> <> PLEASURE-WHARF <> <>>>>


