"WEST for WISHBRINGER: (C)1985 Infocom, Inc. All rights reserved."

"*** EDGE OF LAKE ***"

<OBJECT ISLE
	(IN LOCAL-GLOBALS)
	(DESC "island")
	(SYNONYM ISLAND ISLE MIST FOG)
        (ADJECTIVE MISTY)
	(FLAGS NDESCBIT)
	(ACTION ISLE-F)>

<ROUTINE ISLE-F ("AUX" (AT-ISLE? <>))
	 <THIS-IS-IT ,ISLE>
	 <SET AT-ISLE? <EQUAL? ,HERE ,ISLAND ,THRONE-ROOM>>
	 <COND (<VERB? EXAMINE LOOK-ON>
		<COND (.AT-ISLE?
		       <V-LOOK>)
		      (T
		       <TELL D ,ISLAND 
" has been shrouded in fog for as long as you can remember. Strange legends and mysterious rumors abound; but nobody you know has ever been there." CR>)>
		<RTRUE>)
	       (<OR <EQUAL? ,PRSA ,V?WALK-TO ,V?FOLLOW ,V?THROUGH>
		    <EQUAL? ,PRSA ,V?ENTER ,V?FIND ,V?SWIM>>
		<COND (.AT-ISLE?
		       <ALREADY-ON ,ISLE>)
		      (T
		       <PROBABLY-DROWN>)>
		<RTRUE>)
	       (<VERB? STAND-ON SIT LIE-DOWN WEAR>
		<COND (.AT-ISLE?
		       <ALREADY-ON ,ISLE>)
		      (T
		       <YOUD-HAVE-TO "get to" ,ISLE>)>
		<RTRUE>)
	       (<VERB? WALK-AROUND CROSS SEARCH>
		<COND (.AT-ISLE?
		       <V-WALK-AROUND>)
		      (T
		       <YOUD-HAVE-TO "get to" ,ISLE>)>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,ISLE>
		<RFATAL>)>>

<OBJECT EDGE-OF-LAKE
	(IN ROOMS)
	(DESC "Lake Edge")
	(FLAGS ONBIT RLANDBIT WETBIT)
	(GLOBAL LAKE NORTH-GATE ISLE CEMETERY)
	(NORTH TO RIVER-OUTLET)
	(EAST TO ROTARY-WEST)
	(SOUTH PER ARE-YOU-SURE?)
	(WEST PER PROBABLY-DROWN)
	(IN PER ENTER-PIT?)
	(DOWN PER ENTER-PIT?)
	(ACTION EDGE-OF-LAKE-F)
	(PSEUDO "SHORE" HERE-F)>

<ROUTINE EDGE ()
	 <TELL " the edge of the lake">>

<ROUTINE EDGE-OF-LAKE-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL
"You're on the sandy shore of the lake. A road heads east towards the " 
D ,FESTERON ", and another runs north along">
		<EDGE>
		<TELL ". Looking south, you can see a">
		<OPEN-CLOSED ,NORTH-GATE T>
		<TELL D ,NORTH-GATE 
" leading into the">
		<WHICH-TOWN "Cemetery">
		<TELL "." CR CR D ,ISLAND
", its outline shrouded in fog, is visible far across the water." CR CR>
		<TELL ,YOU-SEE "a ">
		<COND (<FSET? ,PIT ,OPENBIT>
		       <TELL "narrow pit">
		       <COND (,PIT-FULL?
			      <TELL " full of rainwater">)>)
	              (T
		       <TELL "circular " D ,LEAVES>)>
		<TELL " near">
		<EDGE>
		<TELL ". ">
		<COND (<IN? ,BRANCH ,PIT>
		       <TELL "A " D ,BRANCH " is sticking out of the pit. ">)>
		
		<COND (<NOT <FSET? ,LAKE-SAND ,RMUNGBIT>>
		       <COND (<FSET? ,PLATYPUS ,RMUNGBIT>
		              <TELL "An \"X\" has been drawn">)
		             (T
		              <COND (,SKEWED?
			             <TELL "Animal tracks are visible">)
			            (T
			             <TELL 
"Somebody has scrawled a message">)>)>
		       <TELL " in the sand next to the ">
		       <COND (<FSET? ,PIT ,OPENBIT>
		              <TELL D ,PIT>)
		             (T
		              <TELL D ,LEAVES>)>
		       <TELL ".">)>
		<CRLF>)>>

<ROUTINE ENTER-PIT? ()
	 <COND (<FSET? ,PIT ,OPENBIT>
		<PIT-NOT-WIDE>)
	       (T
		<CANT-GO>
		<RFALSE>)>
	 <RFALSE>>

<ROUTINE PIT-NOT-WIDE ()
	 <TELL ,CANT " fit into the pit. It's too narrow." CR>>

<OBJECT LAKE-SAND
	(IN EDGE-OF-LAKE)
	(DESC "sand")
	(SYNONYM SAND MESSAGE TRACKS X)
	(ADJECTIVE SCRAWL ANIMAL)
	(FLAGS TRYTAKEBIT NDESCBIT READBIT)
	(ACTION LAKE-SAND-F)>

; "TOOLBIT = pile of leaves disturbed"

<ROUTINE LAKE-SAND-F ()
	 <COND (<VERB? DIG SEARCH LOOK-UNDER LOOK-INSIDE>
		<COND (<AND ,SKEWED?
			    <FSET? ,PLATYPUS ,RMUNGBIT>
			    <NOT <FSET? ,LAKE-SAND ,RMUNGBIT>>>
		       <MOVE ,WHISTLE ,EDGE-OF-LAKE>
	               <THIS-IS-IT ,WHISTLE>
		       <TELL 
"You discovered a " D ,WHISTLE " in the sand under the \"X\"!" CR>)
		      (T
		       <NOTHING-INTERESTING>)>
		<FSET ,LAKE-SAND ,RMUNGBIT>
		<FCLEAR ,LEAVES ,RMUNGBIT>
		<RTRUE>)
	       (<VERB? EXAMINE READ LOOK-ON FOLLOW>
		<COND (<FSET? ,LAKE-SAND ,RMUNGBIT>
		       <YOU-ERASED-SAND>
		       <RTRUE>)
		      (<FSET? ,PLATYPUS ,RMUNGBIT>
		       <TELL ,YOU-SEE "an \"X\" drawn in the sand." CR>)
		      (T
		       <COND (,SKEWED?
			      <TELL 
"The animal tracks emerge from the lake and lead to the edge of the pit, where they ">
			      <COND (<FSET? ,LAKE-SAND ,TOOLBIT>
				     <TELL 
"turn and head back into the water">)
				    (T
				     <TELL "disappear abruptly">)>
			      <TELL "." CR>)
			     (T
			      <FCLEAR ,LEAVES ,RMUNGBIT>
			      <SAY-THE ,SCRAWL>
			      <TELL 
" in the sand reads, \"Do Not Disturb!\"" CR>)>)>
		<RTRUE>)
	       (<AND <VERB? THROUGH ENTER>
		     <NOT <FSET? ,LAKE-SAND ,RMUNGBIT>>>
		<WASTE-SAND>
		<RTRUE>)
	       (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,LAKE-SAND>>
		<PERFORM ,V?TAKE ,SAND>
		<RTRUE>)
	       (<AND <VERB? PUT PUT-ON THROW>
		     <EQUAL? ,PRSI ,LAKE-SAND>>
		<PERFORM ,V?DROP ,PRSO>
		<RTRUE>)
	       (<AND <OR <HURT? ,LAKE-SAND>
			 <VERB? RUB>>
		     <NOT <FSET? ,LAKE-SAND ,RMUNGBIT>>>
		<WASTE-SAND>
		<RTRUE>)
	       
	       (T
		<RFALSE>)>>

<ROUTINE WASTE-SAND ()
	 <FSET ,LAKE-SAND ,RMUNGBIT>
	 <FCLEAR ,LEAVES ,RMUNGBIT>
	 <YOU-ERASED-SAND>>

<ROUTINE YOU-ERASED-SAND ()
	 <TELL "You rubbed out all the markings in the sand." CR>>

<OBJECT PIT
	(IN EDGE-OF-LAKE)
	(DESC "pit")
	(SYNONYM PIT HOLE TRAP SNARE)
	(ADJECTIVE DEEP NARROW)
	(FLAGS CONTBIT NDESCBIT)
	(CAPACITY 25)
	(ACTION PIT-F)
	(CONTFCN IN-PIT)>

<GLOBAL PIT-FULL? <>>

<ROUTINE IN-PIT (CONTEXT)
	 <COND (<AND <EQUAL? .CONTEXT ,M-CONT>
		     <VERB? TAKE>
		     <NOT <EQUAL? ,PRSO ,BRANCH>>>
		<TELL ,CANT " reach ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO ". ">
		<SAY-THE ,PIT>
		<TELL " is ">
		<COND (,PIT-FULL?
		       <TELL "full of rainwater">)
		      (T
		       <TELL "a little too deep">)>
		<TELL "." CR>
		<RFATAL>)
	       (T
		<RFALSE>)>>

<ROUTINE PIT-F ()
	 <COND (<NOT <FSET? ,PIT ,OPENBIT>>
		<CANT-SEE-ANY ,PIT>
		<RFATAL>)>
	 <THIS-IS-IT ,PIT>
	 <COND (<VERB? EXAMINE LOOK-INSIDE LOOK-DOWN>
		<SAY-THE ,PIT>
		<TELL " is ">
		<COND (,PIT-FULL?
		       <FILLED-PIT>)
		      (T
		       <TELL "more than five feet deep.">)>
		<COND (<FIRST? ,PIT>
		       <TELL " " ,YOU-SEE>
		       <PRINT-CONTENTS ,PIT>
		       <TELL " in it.">)>
		<CRLF>
		<RTRUE>)
	       (<VERB? CLOSE HIDE>
		<TELL ,CANT ". The leaves that used to cover the pit have all blown away." CR>
		<RTRUE>)
	       (<GETTING-INTO?>
		<PIT-NOT-WIDE>
		<RTRUE>)
	       (<AND <VERB? PUT THROW>
		     <EQUAL? ,PRSI ,PIT>>
		<COND ; (<EQUAL? ,PRSO ,KITTY>
		         <NOT-LIKELY ,KITTY "would cooperate">
		         <RTRUE>)
		      (<PUTTING-OPEN-UMBRELLA?>
		       <RTRUE>)
		      (<EQUAL? ,PRSO ,BRANCH>
		       <MOVE ,BRANCH ,PIT>
		       <TELL ,OKAY "the " D ,BRANCH
			     " is now standing up inside the">
		       <COND (,PIT-FULL?
		              <TELL " watery">)>
		       <TELL " pit." CR>
		       <COND (<IN? ,PLATYPUS ,PIT>
		              <FSET ,PLATYPUS ,TOOLBIT>
		              <CRLF>
			      <SAY-THE ,PLATYPUS>
			      <TELL
" grabs onto the bottom of the " D ,BRANCH " with its forepaws." CR>)>
		       <RTRUE>)
		      (,PIT-FULL?
		       <REMOVE ,PRSO>
		       <TELL "You watch as ">
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO " sinks into the watery pit." CR>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)		       
	       (<VERB? OPEN>
		<ALREADY-OPEN>
		<RTRUE>)
	       (<VERB? REACH-IN EMPTY>
		<TELL ,CANT ". ">
		<SAY-THE ,PIT>
		<TELL " is ">
		<COND (,PIT-FULL?
		       <FILLED-PIT>)
		      (T
		       <TELL "too deep.">)>
		<CRLF>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE FILLED-PIT ()
	 <TELL "filled with rainwater.">>

<OBJECT LEAVES
	(IN EDGE-OF-LAKE)
	(DESC "pile of leaves")
	(SYNONYM LEAVES)
	(ADJECTIVE PATCH PILE CIRCUL ROUND)
	(FLAGS NDESCBIT TAKEBIT RMUNGBIT)
	(ACTION LEAVES-F)
	(VALUE 0)
	(SIZE 5)>

; "RMUNGBIT = warning not read yet"

<ROUTINE LEAVES-F ()
	 <COND (<FSET? ,PIT ,OPENBIT>
		<SAY-THE ,LEAVES>
		<TELL " blew away when you disturbed it." CR>
		<RFATAL>)
               (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,LEAVES>>
		<TELL "The leaves slip through your fingers." CR>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<SAY-THE ,LEAVES>
		<TELL " is crisscrossed with twigs to keep it from blowing away. There seems to be something underneath." CR>
		<RTRUE>) 
	       (<AND <VERB? LOOK-UNDER MOVE PULL PUSH SEARCH KICK RAISE RUB>
		     <EQUAL? ,PRSO ,LEAVES>>
		<COND (<DISTURB-LEAVES?>
		       <RTRUE>)
		      (<WANT-TO-MUNG?>
		       <TELL "Moving the " D ,LEAVES " reveals">
		       <DESCRIBE-PIT>)>		       
		<RTRUE>)
	       (<VERB? ENTER THROUGH WALK-TO CROSS>
		<COND (<DISTURB-LEAVES?>
		       <RTRUE>)
		      (<WANT-TO-MUNG?>
		       <SAY-THE ,LEAVES>
		       <TELL " caves in under your feet, revealing">
		       <DESCRIBE-PIT>)>
		<RTRUE>)
	       (<VERB? COUNT>
		<COUNT-LEAVES>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE COUNT-LEAVES ()
	 <TELL "A quick count turns up exactly 69,105 leaves." CR>>

<ROUTINE DISTURB-LEAVES? ()
	 <COND (<FSET? ,LEAVES ,RMUNGBIT>
		<TELL
"(You'd better read the message in the sand before you disturb the " D ,LEAVES
".)" CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE WANT-TO-MUNG? ()
	 <SAY-SURE>
	 <TELL "disturb that " D ,LEAVES 
"? There's an old saying about curiosity...">
	 <COND (<YES?>
		<RTRUE>)
	       (T
		<TELL ,OKAY "the leaves are still intact." CR>
		<RFALSE>)>>

<ROUTINE DESCRIBE-PIT ()
	 <FSET ,PIT ,OPENBIT>
	 <TELL " a deep, narrow pit in the sand. It appears to be a trap of some kind.|
|
The leaves blow away in the breeze." CR CR>
	 <UPDATE-SCORE -10>>

<OBJECT PLATYPUS
	(DESC "platypus")
	(SYNONYM PLATYPUS TASMANIA)
	(ADJECTIVE PRINCESS)
	(FLAGS ACTORBIT TRYTAKEBIT NDESCBIT)
	(ACTION PLATYPUS-F)
	(VALUE 0)
	(SIZE 10)>

; "PLATYPUS STATE FLAGS: TOOLBIT = HOLDING ON, RMUNGBIT = GONE"

<ROUTINE PLATYPUS-F ("OPTIONAL" (CONTEXT <>)) 
	 <COND (<VERB? EXAMINE>
		<SAY-THE ,PLATYPUS>
		<TELL " is ">
		<COND (<FSET? ,PLATYPUS ,TOOLBIT>
		       <TELL 
"clutching the end of the " D ,BRANCH " and looking up at you expectantly">)
		      (T
		       <TELL 
"obviously unhappy about being trapped in the pit">)>
		<TELL "." CR>
		<RTRUE>)
	       (<TALKING-TO? ,PLATYPUS>
		<SAY-THE ,PLATYPUS>
		<TELL " stares back at you impatiently." CR>
		<RFATAL>)
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,PLATYPUS>>
		<SAY-THE ,PLATYPUS>
		<TELL " doesn't seem interested." CR>
		<RTRUE>)
	       (<VERB? RESCUE RELEASE>
		<TELL "Very thoughtful of you. ">
		<HOW?>
		<RTRUE>)
	       (<TOUCHING? ,PLATYPUS>
		<TELL ,CANT " reach the " D ,PLATYPUS 
		      " while it's in the pit." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE DRAW-X ()
	 <START-BUZZ 4>
	 <REMOVE ,PLATYPUS>
	 <FCLEAR ,PLATYPUS ,TOOLBIT>
	 <FSET ,PLATYPUS ,RMUNGBIT>
	 <FCLEAR ,LAKE-SAND ,RMUNGBIT>
	 <TELL "The little creature draws an \"X\" in the ">
	 <COND (,PIT-FULL?
		<TELL "wet ">)>
	 <TELL "sand with its tail. Then it gives you an oddly dignified nod of thanks, waddles to">
	 <EDGE>
	 <TELL " and disappears into the dark water." CR>>

"*** RIVER OUTLET ***"

<OBJECT RIVER-OUTLET
	(IN ROOMS)
	(DESC "River Outlet")
	(FLAGS ONBIT RLANDBIT WETBIT)
	(GLOBAL LAKE RIVER HILL TRAIL)
	(NORTH PER PROBABLY-DROWN-IN-RIVER)
	(EAST TO SOUTH-OF-BRIDGE)
	(SOUTH TO EDGE-OF-LAKE)
	(WEST PER PROBABLY-DROWN)
	(UP TO LOOKOUT-HILL)
	(ACTION RIVER-OUTLET-F)>

<ROUTINE RIVER-OUTLET-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL
"This is where the lake empties into the">
		<WHICH-TOWN "River">
		<TELL ". A road leads south along">
		<EDGE>
		<TELL ", and bends east to follow the river bank. A narrow "
D ,TRAIL " leads upward to the top of ">
		<PRINTD ,LOOKOUT-HILL>
		<TELL "." CR>)>>

"*** LOOKOUT HILL ***"

<OBJECT TRAIL
	(IN LOCAL-GLOBALS)
	(DESC "trail")
	(SYNONYM TRAIL)
	(ADJECTIVE STEEP NARROW SHIMMERING)
	(FLAGS NDESCBIT)
	(ACTION TRAIL-F)>

<ROUTINE TRAIL-F ()
	 <COND (<AND <EQUAL? ,HERE ,CLIFF-BOTTOM>
		     ,SKEWED?>
		<TRAIL-MISPLACED>
		<RFATAL>)
	       (<AND <EQUAL? ,HERE ,ROCKY-PATH>
		     <OR <NOT ,SKEWED?>
			 ,HOUSE-VISITED?>>
		<CANT-SEE-ANY ,TRAIL>
		<RFATAL>)
	       (<VERB? WALK-TO ENTER THROUGH EXIT USE CLIMB-ON>
		<COND (<EQUAL? ,HERE ,LOOKOUT-HILL ,CLIFF-EDGE>
		       <DO-WALK ,P?DOWN>)
		      (<EQUAL? ,HERE ,RIVER-OUTLET ,CLIFF-BOTTOM>
		       <DO-WALK ,P?UP>)
		      (<EQUAL? ,HERE ,ROCKY-PATH>
		       <DO-WALK ,P?SOUTH>)
		      (<EQUAL? ,HERE ,WEST-OF-HOUSE>
		       <DO-WALK ,P?NORTH>)
		      (T
		       <V-WALK-AROUND>)>
		<RTRUE>)
	       (<VERB? CLIMB-DOWN>
		<COND (<OR <EQUAL? ,HERE ,STEEP-TRAIL ,FOG ,CLIFF-EDGE>
			   <EQUAL? ,HERE ,LOOKOUT-HILL>>
		       <DO-WALK ,P?DOWN>)
		      (<EQUAL? ,HERE ,ROCKY-PATH>
		       <DO-WALK ,P?SOUTH>)
		      (<EQUAL? ,HERE ,WEST-OF-HOUSE>
		       <DO-WALK ,P?NORTH>)
		      (T
		       <ALREADY-AT ,TRAIL>)>
		<RTRUE>)
	       (<VERB? CLIMB-UP>
		<COND (<OR <EQUAL? ,HERE ,RIVER-OUTLET ,CLIFF-BOTTOM ,FOG>
			   <EQUAL? ,HERE ,STEEP-TRAIL>>
		       <DO-WALK ,P?UP>)
		      (<EQUAL? ,HERE ,ROCKY-PATH>
		       <DO-WALK ,P?SOUTH>)
		      (<EQUAL? ,HERE ,WEST-OF-HOUSE>
		       <DO-WALK ,P?NORTH>)
		      (T
		       <ALREADY-AT ,TRAIL T>)>
		<RTRUE>)
	       (<VERB? EXAMINE LOOK-DOWN LOOK-UP>
		<V-LOOK>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED ,TRAIL>
		<RFATAL>)>>

<OBJECT LOOKOUT-HILL
	(IN ROOMS)
	(DESC "Lookout Hill")
	(FLAGS ONBIT RLANDBIT)
	(GLOBAL TRAIL HILL ; TREE HOLE STUMP)
	(NORTH PER NORTH-DOWN-HILL)
	(EAST PER TUMBLE)
	(SOUTH PER TUMBLE)
	(WEST PER TUMBLE)
	(DOWN PER DOWN-THE-HILL)
	(IN TO UNDER-HILL IF STUMP IS OPEN)
	(ACTION LOOKOUT-HILL-F)>

<ROUTINE NORTH-DOWN-HILL ()
	 <GET-OFF-STUMP?>
	 <RETURN ,RIVER-OUTLET>>

<ROUTINE DOWN-THE-HILL ()
	 <COND (<FSET? ,STUMP ,OPENBIT>
		<TELL "(Do you want to go down the north side of the hill, or down into the open stump? Please type NORTH or IN.)" CR>
		<SETG CLOCK-WAIT T>
		<RFALSE>)
	       (T
	      ; <COND (<NOT <VERB? CLIMB-DOWN>>
		       <TELL ,I-ASSUME " north, down the hill.)" CR>)>
		<GET-OFF-STUMP?>
		<RETURN ,RIVER-OUTLET>)>>

<ROUTINE LOOKOUT-HILL-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<STANDING>
		<TELL 
"at the summit of a high, barren hill. Looking east, you can see">
		<WHICH-TOWN "Village">
		<TELL " nestled among the trees. A narrow " D ,TRAIL " winds down the north side of the hill, towards the river.|
|
Crowning the hill is the " D ,STUMP " of what must have been a very large and majestic oak tree.">
		<COND (<FSET? ,STUMP ,OPENBIT>
		       <TELL
" An opening in the " D ,STUMP " leads down into " D ,DARKNESS ".">)>
		<CRLF>)>>

<OBJECT STUMP
	(IN LOCAL-GLOBALS)
	(DESC "stump")
	(SYNONYM STUMP UNDERSIDE)
      ; (ADJECTIVE HOLE OPENING)
	(FLAGS NDESCBIT TRYTAKEBIT DOORBIT RMUNGBIT)
	(ACTION STUMP-F)>

; "RMUNGBIT = stump not yet opened or examined"

<GLOBAL ON-STUMP? <>>

<ROUTINE STUMP-F ()
	 <COND (<VERB? EXAMINE LOOK-ON>
		<SAY-THE ,STUMP>
		<COND (<FSET? ,STUMP ,OPENBIT>
		       <TELL " is open, revealing a round hole that leads ">
		       <COND (<EQUAL? ,HERE ,LOOKOUT-HILL>
			      <TELL "downward into " D ,DARKNESS>)
			     (T
			      <TELL "upward into moonlight">)>)
		      (T
		       <TELL " is huge, easily four feet across">
		       <COND (,SKEWED?
		              <FCLEAR ,STUMP ,RMUNGBIT>
			      <TELL
". Looking closely, you notice that the edge of the " D ,STUMP 
" is hinged">)>)>
		<TELL "." CR>
		<RTRUE>)
	       
	       (<VERB? OPEN RAISE>
		<COND (<FSET? ,STUMP ,OPENBIT>
		       <ALREADY-OPEN>)>
		<GET-OFF-STUMP?>
		<COND (,SKEWED?
	               <FSET ,UNDER-HILL ,ONBIT>
		       <SETG LIT T>
		       <FSET ,STUMP ,OPENBIT>
		       <FCLEAR ,STUMP ,RMUNGBIT>
	               <TELL "Lifting the hinged top of the " D ,STUMP 
" reveals a round hole leading ">
		       <COND (<EQUAL? ,HERE ,LOOKOUT-HILL>
			      <TELL "downward into " D ,DARKNESS>)
			     (T
			      <TELL "upward into moonlight">)>)
		      (T
		       <TELL ,CANT>
		       <DO-TO>
		       <TELL "an ordinary stump">)>
		<TELL "." CR>
		<RTRUE>)
	       
	       (<VERB? CLOSE LOWER>
		<COND (<FSET? ,STUMP ,OPENBIT>
		       <FCLEAR ,STUMP ,OPENBIT>
		       <FCLEAR ,UNDER-HILL ,ONBIT>
		       <SETG LIT <LIT? ,HERE>>
		       <SAY-THE ,STUMP>
		       <TELL " closes with a hollow bang">)
	              (T
		       <BUT-THE ,STUMP>
		       <TELL "isn't open">)>
		<TELL "." CR>
		<RTRUE>)
	       
	       (<AND <VERB? MOVE PULL PUSH>
		     <EQUAL? ,PRSO ,STUMP>>
		<COND (<NOT ,SKEWED?>
		       <TOO-LARGE ,STUMP>)
		      (<FSET? ,STUMP ,OPENBIT>
		       <PERFORM ,V?CLOSE ,STUMP>)
		      (T
		       <PERFORM ,V?OPEN ,STUMP>)>
		<RTRUE>)
	       
	       (<VERB? SIT STAND-ON CLIMB-ON>
		<COND (<EQUAL? ,HERE ,UNDER-HILL>
		       <ALREADY-ON ,STUMP T>)
		      (,ON-STUMP?
		       <ALREADY-ON ,STUMP>)
		      (<FSET? ,STUMP ,OPENBIT>
		       <UNFORTUNATELY>
		       <TELL
"you forgot to close the " D ,STUMP " first. Crash!">
		       <CARRIAGE-RETURNS>
		       <FCLEAR ,UNDER-HILL ,TOUCHBIT>
		       <DO-WALK ,P?IN>
		       <RFATAL>)
		      (T
		       <SETG ON-STUMP? T>
		       <EXCELLENT-VIEW ,STUMP>)>
		<RTRUE>)
	       
	       (<VERB? CLIMB-UP>
		<COND (<EQUAL? ,HERE ,UNDER-HILL>
		       <DO-WALK ,P?UP>)
		      (T
		       <PERFORM ,V?SIT ,STUMP>)>
		<RTRUE>)
	       (<VERB? CLIMB-DOWN TAKE-OFF LEAP>
		<COND (,ON-STUMP?
		       <SETG ON-STUMP? <>>
		       <TELL ,OKAY "you're no longer">)
		      (<AND <FSET? ,STUMP ,OPENBIT>
			    <EQUAL? ,HERE ,LOOKOUT-HILL>>
		       <DO-WALK ,P?IN>
		       <RTRUE>)
		      (T
		       <TELL "But you're not">)>
		<TELL " on the " D ,STUMP "." CR>
		<RTRUE>)
	       
	       (<VERB? WALK-TO THROUGH ENTER>
		<COND (<FSET? ,STUMP ,OPENBIT>
		       <COND (<EQUAL? ,HERE ,LOOKOUT-HILL>
			      <DO-WALK ,P?IN>)
			     (T
			      <DO-WALK ,P?UP>)>)
		      (T
		       <STUMP-NOT-OPEN>)>
		<RTRUE>)
	       
	       (<VERB? LOOK-INSIDE>
		<COND (<FSET? ,STUMP ,OPENBIT>
		       <CANT-MAKE-OUT-ANYTHING>)
		      (T
		       <STUMP-NOT-OPEN>)>
		<RTRUE>)
	       	       
	       (<AND <VERB? PUT THROW>
		     <EQUAL? ,PRSI ,STUMP>>
		<COND (<NOT ,SKEWED?>
		       <WASTE-OF-TIME>
		       <RTRUE>)
		      (<NOT <FSET? ,STUMP ,OPENBIT>>
		       <ITS-CLOSED ,STUMP>
		       <RTRUE>)
		      (<EQUAL? ,PRSO ,HANDS>
		       <NOTHING-EXCITING>
		       <RTRUE>)
		    ; (<NOT <THROUGH-HOLE?>>
		       <RFATAL>)
		      (<PUTTING-OPEN-UMBRELLA?>
		       <RTRUE>)
		      (<G? <GETP ,PRSO ,P?SIZE> 10>
		       <TOO-LARGE ,PRSO>
		       <RTRUE>)
		      (<EQUAL? ,HERE ,LOOKOUT-HILL>
		       <MOVE ,PRSO ,UNDER-HILL>)
		      (T
		       <MOVE ,PRSO ,LOOKOUT-HILL>)>
		<TELL ,OKAY>
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO " disappears into the " D ,STUMP "." CR>
		<RTRUE>)
	       (T 
	        <RFALSE>)>>

<ROUTINE GET-OFF-STUMP? ()
	 <COND (,ON-STUMP?
		<SETG ON-STUMP? <>>
		<TELL "(climbing off the " D ,STUMP " first)" CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE STUMP-NOT-OPEN ()
	 <COND (<FSET? ,STUMP ,RMUNGBIT>
		<SAY-THE ,STUMP>
	        <TELL " has no visible openings." CR>)
	       (T
		<ITS-CLOSED ,STUMP>)>>
	 
<OBJECT SHOE
	(IN LOOKOUT-HILL)
	(DESC "horseshoe")
	(FDESC "A horseshoe is lying in the grass near the stump.")
	(SYNONYM HORSESHOE SHOE)
	;(ADJECTIVE HORSE)
	(FLAGS TAKEBIT WEARBIT)
	(SIZE 5)
	(VALUE 0)
	(ACTION SHOE-F)>

<ROUTINE SHOE-F ()
	 <COND (<AND <VERB? EXAMINE>
		     <FSET? ,SHOE ,ONBIT>>
		<SAY-THE ,SHOE>
		<TELL " is twinkling with lucky Magick." CR>
		<RTRUE>)
	       (<VERB? WEAR>
		<TELL "You don't have any shoeing nails." CR>
		<RTRUE>)
	       (<AND <VERB? THROW PLAY>
		     <NOT ,PRSI>>
		<TELL "This is no time for lawn games." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>
		
<OBJECT LAKE
	(IN LOCAL-GLOBALS)
	(DESC "lake")
	(SYNONYM LAKE POND WATER)
	(FLAGS NDESCBIT TRYTAKEBIT CONTBIT OPENBIT)
	(ACTION LAKE-F)>

<ROUTINE LAKE-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "The surface of the lake is ">
		<COND (,SKEWED?
		       <TELL "black and sinister">)
		      (T
		       <TELL "bright with ripples">)>
		<TELL "." CR>
		<RTRUE>)
	       (<HANDLE-WATER?>
		<RTRUE>)
	       (T
		<RFALSE>)>>

