"BRIDGE for WISHBRINGER: (C)1985 Infocom, Inc. All rights reserved."

"*** ON BRIDGE ***"

<OBJECT ON-BRIDGE
	(IN ROOMS)
	(DESC "Bridge")
	(FLAGS ONBIT RLANDBIT INDOORSBIT WETBIT)
	(GLOBAL RIVER BRIDGE)
	(NORTH PER OFF-BRIDGE)
	(EAST PER PROBABLY-DROWN)
	(SOUTH TO SOUTH-OF-BRIDGE)
	(WEST PER PROBABLY-DROWN)
	(DOWN PER PROBABLY-DROWN)
	(ACTION ON-BRIDGE-F)>

<ROUTINE ON-BRIDGE-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL
"You're on a " D ,BRIDGE " that spans the">
		<WHICH-TOWN "River">
		<TELL ". A sign hangs on an arch overhead." CR>)>>

<ROUTINE OFF-BRIDGE ()
	 <COND (<AND ,SKEWED?
		     <IN? ,TROLL ,NORTH-OF-BRIDGE>>
	      ; <START-BUZZ 2>
		<FCLEAR ,TOLL-GATE ,OPENBIT>
		<ENABLE <QUEUE I-SHUT-GATE -1>>)>
	 <RETURN ,NORTH-OF-BRIDGE>>

<ROUTINE I-SHUT-GATE ()
	 <DISABLE <INT I-SHUT-GATE>>
	 <CRLF>
	 <SAY-THE ,TROLL>
	 <TELL " lowers the " D ,TOLL-GATE " after you pass." CR>>
		
<OBJECT BRIDGE
	(IN LOCAL-GLOBALS)
	(DESC "covered bridge")
	(SYNONYM BRIDGE)
	(ADJECTIVE COVERED)
	(FLAGS NDESCBIT)
	(ACTION BRIDGE-F)>

<ROUTINE BRIDGE-F ()
	 <COND (<VERB? CROSS WALK-TO THROUGH ENTER>
		<COND (<EQUAL? ,HERE ,SOUTH-OF-BRIDGE>
		       <DO-WALK ,P?NORTH>)
		      (<EQUAL? ,HERE ,NORTH-OF-BRIDGE>
		       <DO-WALK ,P?SOUTH>)
		      (<EQUAL? ,HERE ,ON-BRIDGE>
		       <V-WALK-AROUND>)
		      (T
		       <RFALSE>)>
		<RTRUE>)
	       (<VERB? LEAP>
		<COND (<EQUAL? ,HERE ,ON-BRIDGE>
		       <PERFORM ,V?KILL ,ME>)
		      (T
		       <ALREADY-ON ,BRIDGE T>)>
		<RTRUE>)
	       (<VERB? LOOK-UNDER>
		<PERFORM ,V?EXAMINE ,RIVER>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT BRIDGE-SIGN
	(IN ON-BRIDGE)
	(DESC "sign")
	(SYNONYM SIGN ARCH)
	(ADJECTIVE BIG)
	(FLAGS NDESCBIT READBIT)
	(ACTION BRIDGE-SIGN-F)>

<ROUTINE BRIDGE-SIGN-F ()
	 <COND (<VERB? READ EXAMINE>
		<CRLF>
		<FIXED-FONT-ON>
		<TELL "   ">
		<COND (<EQUAL? ,WHERE-FROM ,SOUTH-OF-BRIDGE>
		       <TELL "LEAV">)
		      (T
		       <TELL "ENTER">)>
		<TELL "ING ">
		<COND (,SKEWED?
		       <TELL "WITCHVILLE">)
		      (T
		       <TELL "FESTERON">)>
		<TELL CR CR>
		<COND (,SKEWED?
		       <TELL 
"  Curfew Begins At 6 PM|
   Boot Patrol On Duty|
Violators Will Be Jailed!">)
		      (T
		       <COND (<EQUAL? ,WHERE-FROM ,SOUTH-OF-BRIDGE>
			      <TELL "Next Time You're In Town" CR>)>
		       <TELL 
"  Visit Our Fun-Filled" CR "     " D ,PLEASURE-WHARF>)>
		<CRLF>
		<FIXED-FONT-OFF>
		<RTRUE>)
	       (T
		<RFALSE>)>>

"*** NORTH OF BRIDGE ***"

<OBJECT NORTH-OF-BRIDGE
	(IN ROOMS)
	(DESC "North of Bridge")
	(FLAGS ONBIT RLANDBIT WETBIT)
	(GLOBAL BRIDGE RIVER CLIFF SIGN)
	(NORTH PER BUMP-CLIFF)
	(EAST TO CLIFF-BOTTOM)
	(SOUTH PER ENTER-BRIDGE?)
	(WEST PER BUMP-CLIFF)
	(UP "The cliff is much too steep to climb.")
	(IN PER ENTER-BRIDGE?)
	(ACTION NORTH-OF-BRIDGE-F)
	(PSEUDO "SHORE" HERE-F)>

<ROUTINE NORTH-OF-BRIDGE-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "This is the north side of the">
		<WHICH-TOWN "Bridge">
		<TELL ". Sheer cliff walls rise abruptly " <TO-N> " and west. A path wanders east along the shore of the river.">
		<COND (,SKEWED?
		       <TELL CR CR
"A rickety " D ,TOLL-GATE " has been thrown up across the " D ,ENTRANCE 
" to the " D ,BRIDGE ". A handpainted sign is nailed to the middle of the">
		       <OPEN-CLOSED ,TOLL-GATE>
		       <TELL "gate.">
		       <COND (<IN? ,TROLL ,NORTH-OF-BRIDGE>
			      <THIS-IS-IT ,TROLL>
			      <TELL CR CR
"Standing near the " D ,TOLL-GATE " is an ugly, gnomelike creature. A less original story would probably refer to it as a troll.">)>)>
		<CRLF>)>>

<ROUTINE ENTER-BRIDGE? ()
	 <SETG WHERE-FROM ,NORTH-OF-BRIDGE>
	 <COND (<NOT ,SKEWED?>
		<RETURN ,ON-BRIDGE>)
	       (<FSET? ,TOLL-GATE ,OPENBIT>
		<COND (<L? ,WISDOM 3>
		       <COND (<FSET? ,LAKE-SAND ,TOOLBIT>
			      <START-BUZZ 4>)
			     (T
			      <START-BUZZ 3>)>)>
		<FSET ,TROLL ,RMUNGBIT>
		<RETURN ,ON-BRIDGE>)
	       (T
		<COND (<IN? ,TROLL ,NORTH-OF-BRIDGE>
		       <THIS-IS-IT ,TROLL>
		       <TELL 
"\"" <PICK-ONE ,TOLL-DEMANDS> "\" croaks the troll, palm outstretched." CR>)
		      (T
		       <ITS-CLOSED ,TOLL-GATE>)>
		<RFALSE>)>>

<GLOBAL TOLL-DEMANDS
	<LTABLE 0
  	 "The sign says 'One Gold Coin,'"
	 "Show me first a gold coin,"
	 "Ask not for whom the troll tolls,">>

<OBJECT TROLL
	(DESC "troll")
	(SYNONYM TROLL CREATURE)
	(ADJECTIVE UGLY GNOMELIKE)
	(FLAGS ACTORBIT NDESCBIT RMUNGBIT TOOLBIT)
	(ACTION TROLL-F)>

; "RMUNGBIT = troll has not accepted the coin,
   TOOLBIT = troll has not been given the can"

<ROUTINE TROLL-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<VERB? EXAMINE>
		<SAY-THE ,TROLL>
		<TELL " is staring ">
		<COND (,ECLIPSE?
		       <TELL "fearfully upward">)
		      (T
		       <TELL "back at you stupidly">)>
		<TELL "." CR>
		<RTRUE>)
	       
	       (<AND <VERB? GIVE>
		     <EQUAL? ,PRSI ,TROLL>>
		<COND (,ECLIPSE?
		       <TROLL-NOT-INTERESTED>
		       <RTRUE>)
		      (<EQUAL? ,PRSO ,COIN>
		       <COND (,COIN-OFFERED?
		              <REMOVE ,COIN>
		              <SAY-THE ,TROLL>
			      <TELL 
" angrily tosses your " D ,COIN " into the river and mutters something indelicate about counterfeiters." CR>
		              <RTRUE>)>
		       
		       <SETG COIN-OFFERED? T>
		       <SAY-THE ,TROLL>
		       <TELL
" snatches away your " D ,COIN " with a grunt">
		
		       <COND (,LUCKY?
		              <MOVE ,COIN ,TROLL>
			      <FSET ,TOLL-GATE ,OPENBIT>
		              <FCLEAR ,TROLL ,RMUNGBIT>
		              <THIS-IS-IT ,BRIDGE>
		              <START-BUZZ 3>
			      <TELL
". Luckily, he hides it away without looking at it and opens the "
D ,TOLL-GATE ". \"Pass.\"" CR>
			      <RTRUE>)
		             
			     (T
		              <MOVE ,COIN ,NORTH-OF-BRIDGE>
		              <THIS-IS-IT ,COIN>
		              <TELL " and squints at it suspiciously. \"Ugh!\" he cries, holding it up to the moonlight. \"This is a fake!\" He points accusingly at the familiar">
		              <SAY-PROFILE>
		              <TELL ", throws your coin to the " D ,GROUND 
" and pulls out another. \"This is what an OFFICIAL " D ,COIN " looks like!\"|
|
The " D ,TROLL " proudly exhibits his coin. It shows the profile of an evil-looking " D ,OLD-WOMAN>)>
		       <TELL "." CR>
		       <RFATAL>)
		       
		      (<AND <EQUAL? ,PRSO ,SNAKE-CAN>
		            <NOT <FSET? ,SNAKE-CAN ,OPENBIT>>>
		       <SAY-THE ,SNAKE-CAN>
		       <TELL 
" rattles as you hand it to the " D ,TROLL ". ">
		       <COND (<FSET? ,TROLL ,TOOLBIT>
			      <FCLEAR ,TROLL ,TOOLBIT>
			      <FSET ,SNAKE-CAN ,OPENBIT>
			      <TELL "\"Mmm, yummy!\" he exclaims, peering at the label and then greedily opening the lid..." CR CR>)>
		       <COND (,SNAKE-GONE?
			      <MOVE ,SNAKE-CAN ,HERE>
			      <TELL
"\"Hurumph!\" he growls, pitching the can to the " D ,GROUND ". \"Not funny!\""
CR>)
			     (T
			      <TELL "Yow! As he opens">
	                      <SNAKE-LEAPS-OUT-AT "the troll">
	                      <CAN-FALLS>
		              <FRIGHTEN-TROLL>
			      <CRLF>
			      <UPDATE-SCORE 3>)>
		       <RFATAL>)
		      
		      (T
		       <MOVE ,PRSO ,NORTH-OF-BRIDGE>
	               <SAY-THE ,TROLL>
		       <TELL " studies ">
	               <ARTICLE ,PRSO T>
	               <TELL D ,PRSO 
" closely to see if it resembles a " D ,COIN ", and pitches it to the " 
D ,GROUND " when he decides that it doesn't." CR>
		       <RTRUE>)>)
	       
	       (<ASKING? ,TROLL>
		<COND (,ECLIPSE?
		       <TROLL-NOT-INTERESTED>)
		      (T
		       <TELL
"\"No time for questions,\" " <PICK-ONE ,YELL-TYPES> " the idle troll." CR>)>
		<RFATAL>)
	       
	       (<VERB? FEED TELL YELL REPLY HELLO WAVE-AT ; GOODBYE>
		<COND (,ECLIPSE?
		       <TROLL-NOT-INTERESTED>)
		      (T
		       <SAY-THE ,TROLL>
		       <TELL " " <PICK-ONE ,YELL-TYPES> 
" something awful and ignores you." CR>)>
		<RFATAL>)
	       
	       (<AND <VERB? FOLLOW>
		     ,TROLL-SCARED?
		     <EQUAL? ,HERE ,NORTH-OF-BRIDGE ,ON-BRIDGE>>
		<DO-WALK ,P?SOUTH>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE TROLL-NOT-INTERESTED ()
	 <SAY-THE ,TROLL>
	 <TELL " is too busy watching the sky to notice." CR>>

<GLOBAL COIN-OFFERED? <>>

<OBJECT TOLL-GATE
	(DESC "toll gate")
	(SYNONYM GATE)
	(ADJECTIVE TOLL)
	(FLAGS NDESCBIT DOORBIT)
	(ACTION TOLL-GATE-F)>

<ROUTINE TOLL-GATE-F ()
	 <COND (<NOT ,SKEWED?>
		<CANT-SEE-ANY ,TOLL-GATE>
		<RFATAL>)
	       (<VERB? OPEN RAISE>
		<COND (<FSET? ,TOLL-GATE ,OPENBIT>
		       <ALREADY-OPEN>)
		      (T
		       <NOW-CLOSED-OR-OPEN ,TOLL-GATE T>
		       <COND (<AND <IN? ,TROLL ,NORTH-OF-BRIDGE>
			           <FSET? ,TROLL ,RMUNGBIT>>
		              <FCLEAR ,TOLL-GATE ,OPENBIT>
			      <CRLF>
		              <SAY-THE ,TROLL>
		              <TELL " slams the " D ,TOLL-GATE " shut. \"" 
			            <PICK-ONE ,TOLL-DEMANDS>
			            "\" he " <PICK-ONE ,YELL-TYPES> "." CR>)>)>
		<RTRUE>)
	       (<VERB? WALK-TO ENTER EXIT THROUGH>
		<COND (<FSET? ,TOLL-GATE ,OPENBIT>
		       <DO-WALK ,P?SOUTH>)
		      (T
		       <ITS-CLOSED ,TOLL-GATE>)>
		<RTRUE>)
	       (<VERB? LEAP CROSS CLIMB-ON CLIMB-UP>
		<TOO-HIGH ,TOLL-GATE>
		<RTRUE>)
	       (<AND <HURT? ,TOLL-GATE>
		     <IN? ,TROLL ,NORTH-OF-BRIDGE>>
		<SAY-THE ,TROLL>
		<MIGHT-NOT-LIKE>
		<RTRUE>)
	       (<VERB? CLOSE LOWER>
		<COND (<NOT <FSET? ,TOLL-GATE ,OPENBIT>>
		       <ALREADY-CLOSED>)
		      (<IN? ,TROLL ,NORTH-OF-BRIDGE>
		       <TELL "\"That's MY job,\" snaps the " D ,TROLL "." CR>)
		      (T
		     ; <FCLEAR ,TOLL-GATE ,OPENBIT>
		     ; <TELL "Closed." CR>
		       <NOW-CLOSED-OR-OPEN ,TOLL-GATE>)>
		<RTRUE>)
	       (<VERB? EXAMINE READ LOOK-ON>
		<PERFORM ,V?EXAMINE ,SIGN>
		<RTRUE>)
	       (T
		<RFALSE>)>>

"*** CLIFF BOTTOM ***"

<OBJECT CLIFF-BOTTOM
	(IN ROOMS)
	(DESC "Cliff Bottom")
	(FLAGS ONBIT RLANDBIT WETBIT)
	(GLOBAL RIVER SAND CLIFF TRAIL)
	(NORTH PER BUMP-CLIFF)
	(EAST PER BUMP-CLIFF)
	(SOUTH PER PROBABLY-DROWN)
	(WEST PER LIFT-VULTURE)
	(UP PER ENTER-TRAIL?)
	(IN PER BUMP-CLIFF)
	(ACTION CLIFF-BOTTOM-F)>

<ROUTINE CLIFF-BOTTOM-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're at the bottom of a cliff that rises up from the north bank of the river.">
		<COND (<NOT ,SKEWED?>
		       <TELL " ">
		       <TRAIL-WINDS-UP>)>		
		<CRLF>)>>

<ROUTINE ENTER-TRAIL? ()
	 <COND (,SKEWED?
		<TRAIL-MISPLACED>
		<RFALSE>)
	       (T
		<COND (<FSET? ,STEEP-TRAIL ,RMUNGBIT>
		       <FCLEAR ,STEEP-TRAIL ,RMUNGBIT>
		       <TELL "(The " D ,TRAIL " you're climbing is narrow and twisty. It's a good idea to draw a map as you go up.)" CR CR>)>
		<SETG TLOC 1>
		<RETURN ,STEEP-TRAIL>)>>

<ROUTINE TRAIL-MISPLACED ()
	 <TELL 
"The steep " D ,TRAIL " seems to have disappeared with the fog." CR>>

<ROUTINE TRAIL-WINDS-UP ()
	 <TELL "A steep " D ,TRAIL " winds upward.">>

<ROUTINE FEATURELESS-WALL ()
	 <TELL "It's a sheer, featureless wall, a hundred feet high." CR>>

<OBJECT CLIFF
	(IN LOCAL-GLOBALS)
	(DESC "cliff")
	(SYNONYM CLIFF WALL FACE)
	(ADJECTIVE SHEER ROCK ROCKY STEEP FEATURELESS)
	(FLAGS NDESCBIT)
	(ACTION CLIFF-F)>

<ROUTINE CLIFF-F ()
	 <COND (<VERB? EXAMINE LOOK-UP>
		<COND (<AND <EQUAL? ,HERE ,CLIFF-BOTTOM>
			    <NOT ,SKEWED?>>
		       <TRAIL-WINDS-UP>
		       <CRLF>)
		      (T
		       <FEATURELESS-WALL>)>
		<RTRUE>)
	       (<VERB? LEAP>
		<COND (<EQUAL? ,HERE ,CLIFF-EDGE ,STEEP-TRAIL ,FOG>
		       <PERFORM ,V?KILL ,ME>)
		      (T
		       <ALREADY-ON ,CLIFF T>)>
		<RTRUE>)
	       (T
		<RFALSE>)>> 

<OBJECT BRANCH
	(IN GNARLED-TREE)
	(DESC "dead branch")
	(SYNONYM BRANCH)
	(ADJECTIVE LONE HORIZONTAL DEAD)
	(FLAGS BURNBIT TAKEBIT)
	(ACTION BRANCH-F)
	(DESCFCN DESCRIBE-BRANCH)
	(VALUE 0)
	(SIZE 23)>

<ROUTINE DESCRIBE-BRANCH (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL "A " D ,BRANCH " is ">
		<COND (<IN? ,BRANCH ,PIT>
		       <STICKUP>)
		      (T
		       <TELL "lying on the " D ,GROUND>)>
		<TELL ".">)>>

<ROUTINE STICKUP ()
	 <TELL "sticking up out of the pit">>

<ROUTINE BRANCH-F ()
	 <COND (<VERB? EXAMINE>
		<SAY-THE ,BRANCH>
		<TELL " is ">
	        <COND (<IN? ,BRANCH ,PIT>
		       <STICKUP>
		       <COND (<FSET? ,PLATYPUS ,TOOLBIT>
			      <TELL ". A " D ,PLATYPUS 
" is holding on to the bottom end, and looking up at you expectantly">)>)
		      (T
		       <TELL "about six feet long">)>
		<TELL "." CR>
		<RTRUE>)
	       
	       (<AND <VERB? TAKE MOVE PULL RAISE>
		     <EQUAL? ,PRSO ,BRANCH>>
		<COND (<NOT <FSET? ,GNARLED-TREE ,RMUNGBIT>>
		       <BRANCH-BREAKS>)
		      (<AND <IN? ,BRANCH ,PIT>
			    <FSET? ,PLATYPUS ,TOOLBIT>>
		       <COND (<V-TAKE>
		              <CRLF>
			      <UPDATE-SCORE 5>
		              <CRLF>
			      <SAY-THE ,PLATYPUS>
			      <TELL " hangs on to the " D ,BRANCH " as you pull it out of the pit. It lets go when the branch clears the edge and waddles joyfully around on the ">
			      <COND (,PIT-FULL?
				     <TELL "wet ">)>
			      <TELL "sand." CR CR>
		              <DRAW-X>)>
		       <RTRUE>)
		       
		      (T
		       <RFALSE>)>
		<RTRUE>)
		       
	       (<AND <VERB? CLIMB-UP CLIMB-ON SIT MUNG>
		     <EQUAL? ,PRSO ,BRANCH>
		     <NOT <FSET? ,GNARLED-TREE ,RMUNGBIT>>>
		<BRANCH-BREAKS>
		<RTRUE>)
	       (T
		<RFALSE>)>>

"*** VULTURE ***"

<OBJECT VULTURE
	(DESC "vulture")
	(SYNONYM VULTURE BIRD)
	(FLAGS ACTORBIT TRYTAKEBIT NDESCBIT)
	(ACTION VULTURE-F)>

; "RMUNGBIT = force vulture sighting"

<ROUTINE VULTURE-F ("OPTIONAL" (CONTEXT <>))
	 <COND (<VERB? EXAMINE LOOK-UP>
		<TELL "Its steady gaze makes you uneasy." CR>
		<RTRUE>)
	       (<IMAGE? ,VULTURE>
		<RFATAL>)
	       (<OR <TALKING-TO? ,VULTURE>
		    <VERB? YELL>>
		<SAY-THE ,VULTURE>
		<TELL " " <PICK-ONE ,IGNORANCE> "." CR>
		<RFATAL>)
	       (<AND <VERB? THROW>
		     <EQUAL? ,PRSI ,VULTURE>>
		<SAY-THE ,VULTURE>
		<COND (<EQUAL? ,PRSO ,WISHBRINGER>
		       <COND (<ENABLED? ,I-VULTURE>
			      <DISABLE <INT I-VULTURE>>)>
		       <REMOVE ,VULTURE>
		       <REMOVE ,WISHBRINGER>
		       <TELL " eagerly snatches up the " D ,WISHBRINGER
			     " in its beak,">
		       <SOARS-AWAY-OVER>
		       <TELL "your head with a croak of delight." CR CR>
		       <UPDATE-SCORE -10>)
		      (T
		       <TELL " ignores you." CR>)>
		<RTRUE>)
	       (<IN? ,VULTURE ,HERE>
		<TOO-HIGH ,VULTURE>
		<RTRUE>)
	       (<AND <VERB? FEED GIVE>
		     <EQUAL? ,PRSI ,VULTURE>>
		<PERFORM ,V?THROW ,PRSO ,VULTURE>
		<RTRUE>)
	       (<OR <HURT? ,VULTURE>
		    <VERB? KISS EAT PLAY SQUEEZE RUB>>
		<REMOVE ,VULTURE>
		<SAY-THE ,VULTURE>
		<TELL
" sees your thought. Before you can do anything, it makes a haughty little croak and flies serenely away." CR>
		<RFATAL>)
	       (T
		<RFALSE>)>>

<ROUTINE LIFT-VULTURE ()
	 <COND (<IN? ,VULTURE ,GNARLED-TREE>
		<FCLEAR ,VULTURE ,RMUNGBIT>
		<REMOVE ,VULTURE>
		<ENABLE <QUEUE I-VULTURE -1>>
	      	<SAY-THE ,VULTURE>
		<SOARS-AWAY-OVER>
		<TELL "your head." CR CR>)>
	 <RETURN ,NORTH-OF-BRIDGE>>

<ROUTINE SOARS-AWAY-OVER ()
	 <TELL " spreads its wings and soars away over ">>

<ROUTINE SEE-VULTURE ()
	 <SAY-THE ,VULTURE>
	 <TELL " " <PICK-ONE ,SIGHTINGS> " high overhead." CR>>

<GLOBAL SIGHTINGS
	<LTABLE 0
         "appears" "is circling" "begins to hover" "can be seen circling"
	 "is watching you from" "hovers in the sky" "hovers" 
	 "eyes you suspiciously from">>

<OBJECT GNARLED-TREE
	(IN CLIFF-BOTTOM)
	(DESC "gnarled tree trunk")
	(SYNONYM TRUNK TREE)
	(ADJECTIVE GNARLED OLD DEAD)
	(FLAGS ; NDESCBIT SURFACEBIT ; BURNBIT)
	(DESCFCN DESCRIBE-TREE)
	(ACTION GNARLED-TREE-F)>

<ROUTINE DESCRIBE-TREE (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-OBJDESC>
		<TELL "A " D ,GNARLED-TREE>
		<COND (<IN? ,BRANCH ,GNARLED-TREE>
		       <TELL 
" stands nearby, a lone branch its only adornment.">)
		      (T
		       <TELL 
", stripped of all its branches, stands nearby.">)>
		<COND (<IN? ,VULTURE ,GNARLED-TREE>
		       <TELL " A " D ,VULTURE " perched on top is watching every move you make.">)>)>>

<ROUTINE GNARLED-TREE-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE>
		<SAY-THE ,GNARLED-TREE>
		<TELL " is rotten to the core." CR>
		<RTRUE>)
	       (<VERB? CLIMB-ON CLIMB-UP SIT>
		<COND (<FSET? ,GNARLED-TREE ,RMUNGBIT>
		       <NO-FOOTHOLDS>)
		      (T
		       <TELL
"Done. You're sitting on the rotten, creaking branch..." CR CR>
		       <BRANCH-BREAKS>
		       <TELL CR 
"You're now sitting on the " D ,GROUND ". Painfully." CR>)>
		<RTRUE>)
	       (<AND <VERB? PUT PUT-ON THROW>
		     <EQUAL? ,PRSI ,GNARLED-TREE>>
		<WASTE-OF-TIME>
		<RTRUE>)
	       (T
		<RFALSE>)>>
		       
<ROUTINE BRANCH-BREAKS ()
	 <FCLEAR ,BRANCH ,NDESCBIT>
	 <FSET ,GNARLED-TREE ,RMUNGBIT>
	 <MOVE ,BRANCH ,CLIFF-BOTTOM>
	 <TELL "Crack! ">
	 <SAY-THE ,BRANCH>
	 <TELL " snaps off the " D ,GNARLED-TREE " and falls to the "
	       D ,GROUND " with a thud. ">
	 <VULTURE-IN-TREE>
	 <CRLF>>
		       
<ROUTINE VULTURE-IN-TREE ()
	 <COND (<IN? ,VULTURE ,GNARLED-TREE>
		<FCLEAR ,VULTURE ,RMUNGBIT>
		<REMOVE ,VULTURE>
		<ENABLE <QUEUE I-VULTURE -1>>
		<TELL "Visibly annoyed, the " D ,VULTURE>
		<SOARS-AWAY-OVER>
		<TELL "the river.">)>>

<ROUTINE CAN-FALLS ()
	 <MOVE ,SNAKE-CAN ,NORTH-OF-BRIDGE>
	 <CLATTERS ,SNAKE-CAN>>

<ROUTINE CLATTERS (THING)
	 <CRLF>
	 <SAY-THE .THING>
	 <TELL " clatters to the " D ,GROUND "." CR>>

<GLOBAL SNAKE-GONE? <>>

<ROUTINE SNAKE-LEAPS-OUT-AT (STR)
	 <SETG SNAKE-GONE? T>
	 <TELL " the can a ">
	 <COND (,SKEWED?
		<THIS-IS-IT ,SNAKE-CAN>
		<FSET ,SNAKE-CAN ,OPENBIT>
		<TELL 
"real, live rattlesnake leaps out! It squirms about angrily for a few moments, turns to hiss at " .STR " and slithers out of sight">)
	       (T
		<TELL 
"three-foot plastic snake springs out! It hits you in the nose and lands harmlessly at your feet.|
|
\"Oldest trick in the book,\" remarks the " D ,OLD-WOMAN ", chuckling despite herself. \"Try it next time you want to get rid of somebody.\" She stuffs the snake back into the " D ,SNAKE-CAN ", closes the lid and hands it back to you">)>
	 <TELL "." CR>>

<GLOBAL TROLL-SCARED? <>>

<ROUTINE FRIGHTEN-TROLL ()
	 <SETG TROLL-SCARED? T>
	 <COND (<EQUAL? ,WISDOM 2>
		<START-BUZZ 3>)>
	 <MOVE ,TROLL ,STEEP-TRAIL>
	 <COND (<AND <IN? ,COIN ,TROLL>
		     ,LUCKY?>
		<FCLEAR ,COIN ,TOUCHBIT>
		<FCLEAR ,ON-BRIDGE ,TOUCHBIT>
		<MOVE ,COIN ,ON-BRIDGE>
		<PUTP ,COIN ,P?FDESC "Lucky you! Your gold coin is lying here on the bridge. The troll must have dropped it when he ran away.">)>
	 <TELL CR
"A scream of terror echoes off the cliffs as the " D ,TROLL
" runs away across the " D ,BRIDGE "." CR>>

<ROUTINE INTO-NIGHT ()
	 <TELL " into the night.">>





		       
		
