"VERBS for WISHBRINGER: (C)1985 Infocom, Inc. All Rights Reserved."

<ROUTINE V-BAD-DIRECTION ()
	 <TELL "(That direction isn't used in this story.)" CR>>

<GLOBAL VERBOSE <>>

<ROUTINE V-VERBOSE ()
	 <SETG VERBOSE T>
	 <SETG SUPER-BRIEF <>>
	 <TELL "(Maximum verbosity.)" CR CR>
	 <V-LOOK>>

<ROUTINE V-BRIEF ()
	 <SETG VERBOSE <>>
	 <SETG SUPER-BRIEF <>>
	 <TELL "(Brief descriptions.)" CR>>

<GLOBAL SUPER-BRIEF <>>

<ROUTINE V-SUPER-BRIEF ()
	 <SETG SUPER-BRIEF T>
	 <TELL "(Super-brief descriptions.)" CR>>

; <ROUTINE V-DIAGNOSE ()
	 <TELL "You're in good health">
	 <COND (,SKEWED?
		<TELL "... at the moment">)>
	 <TELL "." CR>>

<ROUTINE V-INVENTORY ()
	 <TELL "You're ">
	 <COND (<FIRST? ,PROTAGONIST>
		<TELL "holding ">
		<PRINT-CONTENTS ,PROTAGONIST>)
	       (T
		<TELL "not holding anything">)>
	 <TELL "." CR>>

; <ROUTINE V-INVENTORY ("AUX" OBJ (ANY? <>))
	 <SET OBJ <FIRST? ,PROTAGONIST>>
	 <REPEAT ()
		 <COND (.OBJ
			<COND (<NOT <EQUAL? .OBJ ,POCKET>>
			       <SET ANY? T>
			       <RETURN>)>
			<SET OBJ <NEXT? .OBJ>>)
		       (T
			<RETURN>)>>
	 <SET OBJ <FIRST? ,POCKET>>
	 <TELL "You're ">
	 <COND (.ANY?
		<TELL "holding ">
	        <PRINT-CONTENTS ,PROTAGONIST>
		<TELL ". Y">
		<COND (.OBJ
		       <TELL "ou also have ">)
		      (T
		       <POCKET-EMPTY>)>)
	       (T
		<TELL "not holding anything">
		<COND (.OBJ
		       <TELL ". But there's ">)
		      (T
		       <TELL ", and y">
		       <POCKET-EMPTY>)>)>
	 <COND (.OBJ
		<PRINT-CONTENTS ,POCKET>
		<TELL " in " D ,POCKET>)>
	 <TELL "." CR>>

; <ROUTINE POCKET-EMPTY ()
	 <TELL "our pocket is empty">>

<ROUTINE SAY-SURE ()
	 <TELL "Are you sure you want to ">>

<ROUTINE V-QUIT ("OPTIONAL" (ASK? T) "AUX" SCOR)
	 <V-SCORE>
	 <COND (.ASK?
		<SAY-SURE>
		<TELL "leave the story now?">
		<COND (<YES?>
		       <QUIT>)
		      (T
		       <TELL ,OKAY "continuing." CR>)>)
	       (T
		<QUIT>)>>
		      
<ROUTINE V-RESTART ()
	 <V-SCORE>
	 <SAY-SURE>
	 <TELL "restart the story?">
	 <COND (<YES?>
		<RESTART>
		<FAILED>)>>

<ROUTINE BAD-ENDING ()
	 <MOVE ,PROTAGONIST ,END-ROOM>
	 <SETG HERE ,END-ROOM>
	 <CARRIAGE-RETURNS>
	 <TELL
"Looks like the story's over. But don't despair! Interactive fiction lets you learn from your mistakes." CR>
	 <FINISH>>

<ROUTINE FINISH ("OPTIONAL" (REPEATING <>) "AUX" WORD)
	 <CRLF>
	 <COND (<NOT .REPEATING>
		<V-SCORE>
		<CRLF>)>
	 <TELL
"Do you want to restart the story, restore a saved position, or quit?|
|
(Type RESTART, RESTORE or QUIT.) >">
	 <READ ,P-INBUF ,P-LEXV>
	 <SET WORD <GET ,P-LEXV 1>>
	 <COND (<EQUAL? .WORD ,W?RESTART>
	        <RESTART>
		<FAILED>
		<FINISH T>)
	       (<EQUAL? .WORD ,W?RESTORE>
		<COND (<RESTORE>
		       <SAY-OKAY>)
		      (T
		       <FAILED>
		       <FINISH T>)>)
	       (T
		<QUIT>)>>

; <ROUTINE V-NO ()
	 <V-YES T>>

; <ROUTINE V-YES ("OPTIONAL" (NO? <>))
	 <RTRUE>>

<GLOBAL YES-INBUF <ITABLE BYTE 12>>
<GLOBAL YES-LEXV  <ITABLE BYTE 10>>

<ROUTINE YES? ("AUX" WORD)
	 <CRLF>
	 <REPEAT ()
		 <TELL CR "(Please type YES or NO.) >">
	         <PUTB ,YES-LEXV 0 4>
		 <READ ,YES-INBUF ,YES-LEXV>
	         <SET WORD <GET ,YES-LEXV ,P-LEXSTART>>
	         <COND (<ZERO? <GETB ,YES-LEXV ,P-LEXWORDS>>
		        T)
	               (<NOT <ZERO? .WORD>>
			<COND (<OR <EQUAL? .WORD ,W?YES ,W?Y ,W?YUP>
				   <EQUAL? .WORD ,W?OKAY ,W?OK ,W?AYE>
				   <EQUAL? .WORD ,W?SURE ,W?AFFIRM ,W?POSITI>>
		               <RTRUE>)
	                      (<OR <EQUAL? .WORD ,W?NO ,W?N ,W?NOPE>
				   <EQUAL? .WORD ,W?NAY ,W?NAW ,W?NEGATIVE>>
		               <RFALSE>)>)>>>

<GLOBAL OKAY "Okay, ">

<ROUTINE SAY-OKAY ()
	 <TELL ,OKAY "done." CR>>

<ROUTINE FAILED ()
	 <TELL "Failed." CR>>

<ROUTINE V-RESTORE ()
	 <COND (<RESTORE>
		<SAY-OKAY>)
	       (T
		<FAILED>)>>

<ROUTINE V-SAVE ()
	 <SETG P-CONT <>>
	 <COND (<SAVE>
	        <SAY-OKAY>)
	       (T
		<FAILED>)>>

<GLOBAL GSCORE 0>
<GLOBAL GMOVES 0>
<GLOBAL SPELLS 0>

<ROUTINE V-SCORE ()
	 <TELL "Your score is " N ,GSCORE " point">
	 <COND (<NOT <1? ,GSCORE>>
	        <TELL "s">)>
	 <TELL " out of 100, in " N ,GMOVES " move">
	 <COND (<NOT <1? ,GMOVES>>
	        <TELL "s">)>
	 <TELL ".">
	 <COND (<NOT <ZERO? ,SPELLS>>
		<TELL " You've used " N ,SPELLS " of the Stone's 7 Wishes.">)>
	 <CRLF>>

<ROUTINE V-TIME ("AUX" H M)
	 <TELL "(It's ">
	 <TELL-TIME>
	 <COND (<AND <FSET? ,ENVELOPE ,TOUCHBIT>
		     <NOT <EQUAL? ,HERE ,INSIDE-SHOPPE>>
		     <NOT ,ENDING?>>
		<TELL ". You have ">		
		<COND (,SKEWED?
		       <COND (<G? ,SCORE 17>
			      <SET H <+ <- 24 ,SCORE> 5>>)
			     (T
			      <SET H <- 5 ,SCORE>>)>)
		      (T
		       <SET H <- 16 ,SCORE>>)>
		<COND (<ZERO? ,MOVES>
		       <SET M 0>
		       <SET H <+ .H 1>>)
		      (T
		       <SET M <- 60 ,MOVES>>)>
		<COND (<ZERO? .H>
		       <TELL "only ">)
		      (T
		       <TELL N .H " hour">
		       <COND (<NOT <1? .H>>
			      <TELL "s">)>
		       <TELL " ">
		       <COND (<NOT <ZERO? .M>>
			      <TELL "and ">)>)>
		<COND (<NOT <ZERO? .M>>
		       <TELL N .M " minute">
		       <COND (<NOT <1? .M>>
			      <TELL "s">)>
		       <TELL " ">)>
		<TELL "to complete your ">
		<COND (,SKEWED?
		       <TELL "quest">)
		      (T
		       <TELL "delivery">)>)>
	 <TELL ".)" CR>>

<ROUTINE TELL-TIME ("AUX" H (PM? <>))
	 <COND (<G? ,SCORE 11>
		<SET PM? T>)>
	 <COND (<G? ,SCORE 12>
		<SET H <- ,SCORE 12>>)
	       (<ZERO? ,SCORE>
		<SET H 12>)
	       (T
		<SET H ,SCORE>)>
	 <TELL N .H ":">
	 <COND (<L? ,MOVES 10>
		<TELL "0">)>
	 <TELL N ,MOVES>
	 <COND (.PM?
		<TELL " pm">)
	       (T
		<TELL " am">)>>
	        
<ROUTINE V-SCRIPT ()
	<PUT 0 8 <BOR <GET 0 8> 1>>
	<TRANSCRIPT "begin">
	<RTRUE>>

<ROUTINE V-UNSCRIPT ()
	<TRANSCRIPT "end">
	<PUT 0 8 <BAND <GET 0 8> -2>>
	<RTRUE>>

<ROUTINE TRANSCRIPT (STR)
	 <TELL "Here " .STR "s a transcript of interaction with" CR>
	 <V-VERSION>>

<ROUTINE V-VERSION ("AUX" (CNT 17))
	 <TELL CR
"WISHBRINGER|
The Magick Stone of Dreams|
Copyright (C)1985 Infocom, Inc. All rights reserved." CR>
	 <TELL ,GAME " is a registered trademark of Infocom, Inc.|
Release ">
	 <PRINTN <BAND <GET 0 1> *3777*>>
	 <TELL " / Serial Number ">
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> 23>
			<RETURN>)
		       (T
			<PRINTC <GETB 0 .CNT>>)>>
	 <CRLF>>

<ROUTINE V-USE ()
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<BUT-THE ,PRSO>
		<TELL "might resent that." CR>
		<RTRUE>)
	       (T
		<HOW?>)>>

<ROUTINE V-$VERIFY ()
         <COND (,PRSO
	        <COND (<AND <EQUAL? ,PRSO ,INTNUM>
		            <EQUAL? ,P-NUMBER 93>>
	               <TELL N ,SERIAL CR>)
	              (T 
		       <DONT-UNDERSTAND>)>)
               (T
	        <TELL "Verifying disk." CR>
	        <COND (<VERIFY> 
		       <TELL "Correct." CR>)
	              (T 
		       <FAILED>)>)>>

; <GLOBAL DEBUG <>>

; <ROUTINE V-$DEBUG ()
	 <COND (,DEBUG
		<SETG DEBUG <>>
		<TELL "Debug off." CR>)
	       (T
		<SETG DEBUG T>
		<TELL "Debug on." CR>)>>
			    
<ROUTINE V-AGAIN ("AUX" OBJ)
	 <COND (<NOT ,L-PRSA>
	 	<SETG L-PRSA ,V?HELP>
		<SETG PRSA ,V?HELP>
		<TELL "(" ,CANT " use AGAIN that way.)" CR>)
	     ; (<AND <NOT <EQUAL? ,HERE ,L-HERE>>
		     <EQUAL? ,PSEUDO-OBJECT ,L-PRSO ,L-PRSI>>
		<SETG L-PRSA <>>
		<ANYMORE>)
	       (<EQUAL? ,L-PRSA ,V?WALK>
		<DO-WALK ,L-PRSO>)
	       (T
	        <SET OBJ
		     <COND (<AND ,L-PRSO
				 <EQUAL? <LOC ,L-PRSO> ,ROOMS>>
			    ,L-PRSO)
			   (<AND ,L-PRSI
				 <EQUAL? <LOC ,L-PRSI> ,ROOMS>>
			    ,L-PRSI)>>
		<COND (<AND .OBJ 
			    <NOT <EQUAL? .OBJ ,PSEUDO-OBJECT ,ROOMS>>>
		       <YOU-CANT-SEE>
		       <ARTICLE .OBJ T>
		       <TELL D .OBJ " anymore." CR>
		       <RFATAL>)
		      (T
		       <PERFORM ,L-PRSA ,L-PRSO ,L-PRSI>)>)>>

; <GLOBAL LAST-HERE <>>

; <ROUTINE I-AGAIN-LOC ()
	 <SETG L-HERE ,LAST-HERE>
	 <SETG LAST-HERE ,HERE>
	 <RFALSE>>

<ROUTINE V-ALARM ()
	 <COND (<EQUAL? ,PRSO ,ME ,ROOMS>
		<TELL "But you're ">)
	       (<FSET? ,PRSO ,ACTORBIT>
		<BUT-THE ,PRSO>
	        <TELL "is ">)
	       (T
		<WHAT-A-CONCEPT>
		<RTRUE>)>
	 <TELL "already wide awake!" CR>>

; <ROUTINE V-ANSWER ()
	 <TELL "Nobody seems to be awaiting your answer." CR>
	 <PCLEAR>
	 <RFATAL>>

; <ROUTINE V-ASK-ABOUT ()
	 <COND (<EQUAL? ,PRSO ,ME>
		<PERFORM ,V?TELL ,ME>
		<RTRUE>)
	     ; (<FSET? ,PRSO ,ACTORBIT>
	        <TELL "After a moment's thought, ">
	        <ARTICLE ,PRSO T>
	        <TELL D ,PRSO " denies any knowledge of ">
	        <ARTICLE ,PRSI T>
	        <TELL D ,PRSI ".">
	        <COND (<EQUAL? ,PRSO ,PRSI>
		       <TELL " (Rather disingenuous, eh?)">)>
	        <CRLF>)
	       (T
		<V-TELL>
		<RTRUE>)>>

<ROUTINE V-ASK-ABOUT ()
	 <V-ASK-FOR>>

<ROUTINE V-QUESTION ()
	 <V-ASK-FOR>>

; <ROUTINE V-WAVE-AT ()
	 <NOT-LIKELY ,PRSO "will respond to your friendly gesture">>

<ROUTINE V-WAVE-AT ()
	 <V-ASK-FOR>>

<ROUTINE V-ASK-FOR ()
	 <COND (<EQUAL? ,PRSO ,ME ,ROOMS>
		<PERFORM ,V?TELL ,ME>)
	       (T
		<NOT-LIKELY ,PRSO "would respond">)>
	 <PCLEAR>
	 <RFATAL>>

; <ROUTINE V-QUESTION ()
	 <COND (<EQUAL? ,PRSO ,ME>
		<PERFORM ,V?TELL ,ME>
		<RTRUE>)
	       (<FSET? ,PRSO ,ACTORBIT>
		<NOT-LIKELY ,PRSO "is interested">)
	       (T
		<NOT-LIKELY ,PRSO "would reply">)>>

; <ROUTINE V-BACK ()
	 <V-WALK-AROUND>>

<ROUTINE V-BITE ()
	 <HACK-HACK "Biting">>

<ROUTINE V-BLOW-INTO ()
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<PERFORM ,V?USE ,PRSO>
		<RTRUE>)
	       (T
		<HACK-HACK "Blowing">)>>
		
; <ROUTINE PRE-BOARD ("AUX" AV)
	 <SET AV <LOC ,PROTAGONIST>>
	 <COND (<FSET? ,PRSO ,VEHBIT>
		<COND (<FSET? .AV ,VEHBIT>
		       <TELL "You're already in ">
		       <ARTICLE ,PRSO T>
		       <TELL D .AV "!" CR>)
		      (T
		       <RFALSE>)>)
	       (T
		<TELL ,CANT " get into ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO "!" CR>)>
	 <RFATAL>>

<ROUTINE V-BURN ()
	 <COND (<EQUAL? ,PRSI ,CANDLE>
		<COND (<FSET? ,CANDLE ,ONBIT>
		       <TELL "Some people just can't be trusted with fire.">)
		      (T
		       <BUT-THE ,CANDLE>
		       <TELL "isn't lit!">)>)
	       (T
		<TELL "With ">
		<ARTICLE ,PRSI>
		<TELL D ,PRSI "? " <PICK-ONE ,YUKS>>)>
	 <CRLF>>

<ROUTINE V-BUY ()
	 <COND (<NOT <VISIBLE? ,PRSO>>
		<CANT-SEE-ANY ,PRSO>
		<RTRUE>)
	       (<AND <NOT <FSET? ,PRSO ,TAKEBIT>>
		     <NOT <FSET? ,PRSO ,TRYTAKEBIT>>>
		<TELL ,CANT " buy that!" CR>)
	       (<HELD? ,PRSO>
		<TELL "You already have one." CR>)
	       (,PRSI
		<COND (<EQUAL? ,PRSI ,COIN>
		       <TELL "You couldn't buy ">
	               <ARTICLE ,PRSO T>
		       <TELL D ,PRSO " with only one " D ,COIN "." CR>)
		      (T
		       <NOT-LIKELY ,PRSI "would buy that">)>)
	       (<HELD? ,COIN>
		<WITH-COIN>
		<NOT-LIKELY ,COIN "would buy that">)
	       (T
		<NO-MONEY>)>>
		
<ROUTINE WITH-COIN ()
	 <TELL "(with the " D ,COIN ")" CR>>

<ROUTINE NO-MONEY ()
	 <TELL "You don't have any money." CR>>

; <ROUTINE V-CHASTISE ()
	 <TELL
"Use prepositions to indicate precisely what you want to do. For example, LOOK AT the object, LOOK INSIDE it, LOOK UNDER it, etc." CR>>

<ROUTINE V-CLEAN ()
	 <NOT-A "janitor">>

; <ROUTINE V-CLEAN ()
	 <COND (<EQUAL? ,PRSO ,DUST ,ART>
		<TELL "You'd be here all day!" CR>)
	       (<AND ,PRSI
		     <NOT <EQUAL? ,PRSI ,BROOM ,BLANKET>>>
		<HARD-TIME-WITH ,PRSI>)
	       (T
		<NOT-A "janitor">)>>

<ROUTINE V-CLIMB-DOWN ()
	 <COND (<EQUAL? ,PRSO ,ROOMS>
		<DO-WALK ,P?DOWN>)
	       (T
		<WHAT-A-CONCEPT>)>>

; <ROUTINE V-CLIMB-FOO ()
	 <COND (<OR <NOT ,PRSO>
		    <EQUAL? ,PRSO ,ROOMS>>
		<DO-WALK ,P?UP>)
	       (T
		<WHAT-A-CONCEPT>)>>

<ROUTINE V-CLIMB-ON ()
	 <TELL ,CANT " climb onto that." CR>>

<ROUTINE V-CLIMB-OVER ()
	 <COND (<EQUAL? ,PRSO ,ROOMS>
		<V-WALK-AROUND>)
	       (T
		<TELL ,CANT " climb over that." CR>)>>

<ROUTINE V-CLIMB-UP ()
	 <COND (<EQUAL? ,PRSO ,ROOMS>
		<DO-WALK ,P?UP>)
	       (T
		<WHAT-A-CONCEPT>)>>

<ROUTINE V-CLOSE ()
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<NOT-A "surgeon">)
	       (<FSET? ,PRSO ,SURFACEBIT>
		<CANT-CLOSE-THAT>)
	       (<AND <NOT <FSET? ,PRSO ,CONTBIT>>
		     <NOT <FSET? ,PRSO ,DOORBIT>>>
		<PERFORM ,V?OPEN ,PRSO>
		<RTRUE>)
	       (<AND <NOT <FSET? ,PRSO ,SURFACEBIT>>
		     <NOT <EQUAL? <GETP ,PRSO ,P?CAPACITY> 0>>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		     ; <FCLEAR ,PRSO ,OPENBIT>
		     ; <TELL "Closed." CR>
		       <NOW-CLOSED-OR-OPEN ,PRSO>
		       <SAY-IF-NOT-LIT>)
		      (T
		       <ALREADY-CLOSED>)>)
	       (<FSET? ,PRSO ,DOORBIT>
		<COND (<FSET? ,PRSO ,OPENBIT>
		     ; <FCLEAR ,PRSO ,OPENBIT>
		       <NOW-CLOSED-OR-OPEN ,PRSO>
		       <COND (<EQUAL? ,PRSO ,LIBRARY-DOOR>
			      <FCLEAR ,CIRCULATION-DESK ,ONBIT>
			      <SAY-IF-NOT-LIT>)>)
		      (T
		       <ALREADY-CLOSED>)>)
	       (T
		<CANT-CLOSE-THAT>)>>

<ROUTINE CANT-CLOSE-THAT ()
	 <TELL ,CANT " close that!" CR>>

<ROUTINE NOW-CLOSED-OR-OPEN (THING "OPTIONAL" (OPEN? <>))
	 <THIS-IS-IT .THING>
	 <TELL ,OKAY>
	 <ARTICLE ,PRSO T>
	 <TELL D ,PRSO " is now ">
	 <COND (.OPEN?
		<FSET .THING ,OPENBIT>
		<TELL "open">)
	       (T
		<FCLEAR .THING ,OPENBIT>
		<TELL "closed">)>
	 <TELL "." CR>>

; <ROUTINE V-COMPARE ()
	 <WASTE-OF-TIME>>

<ROUTINE V-COUNT ()
	 <WASTE-OF-TIME>>

<ROUTINE V-COVER ()
	 <PERFORM ,V?PUT-ON ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-CROSS ()
	 <TELL ,CANT " cross that!" CR>>

; <ROUTINE V-CURSE ()
	 <TELL "Such language!" CR>>

<ROUTINE V-CUT ()
	 <NOT-LIKELY ,PRSI "could cut anything">>

; <ROUTINE V-DEFLATE ()
	 <WHAT-A-CONCEPT>>

<ROUTINE V-DIG ()
	 <WASTE-OF-TIME>>

; <ROUTINE V-DISEMBARK ()
	 <COND (<NOT <EQUAL? <LOC ,WINNER> ,PRSO>>
		<LOOK-AROUND>
		<RFATAL>)
	       (T
		<TELL "You are now on your feet." CR>
		<MOVE ,WINNER ,HERE>)>>

<ROUTINE V-DRINK ()
	 <TELL ,CANT " drink that!" CR>>

<ROUTINE V-DRINK-FROM ()
	 <WHAT-A-CONCEPT>>

; <ROUTINE PRE-DROP ()
	 <COND (<EQUAL? ,PRSO <LOC ,WINNER>>
		<PERFORM ,V?DISEMBARK ,PRSO>
		<RTRUE>)>>

<ROUTINE V-DROP ()
	 <COND (<EQUAL? ,HERE ,OUTSIDE-COTTAGE>
		<PERFORM ,V?GIVE ,PRSO ,POOCH>
		<RTRUE>)
	       (<IDROP>
		<TELL "Dropped." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE IDROP ()
	 <COND ; (<EQUAL? ,PRSO ,POCKET>
		  <TELL <PICK-ONE ,YUKS> CR>
		  <RFALSE>)
	       ; (<IN? ,PRSO ,POCKET>
		  <YOUD-HAVE-TO "take it out of" ,POCKET>
		  <RFALSE>)
	       (<DONT-HAVE? ,PRSO>
		<RFALSE>)
	       (<AND <NOT <IN? ,PRSO ,WINNER>>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TELL ,CANT " do that while ">
		<ARTICLE ,PRSO T>
		<PRINTD ,PRSO>
		<IS-CLOSED>
		<CRLF>
		<RFALSE>)
	       (<FSET? ,PRSO ,WORNBIT>
		<TAKE-OFF-PRSO-FIRST>)
	       (<EQUAL? ,PRSO ,KITTY>
		<SETG HORSE-SCRIPT 3>)
	       (<AND <EQUAL? ,PRSO ,BROOM>
		     ,BROOM-SIT?>
		<GET-OFF-BROOM-FIRST>)>
	 <COND (<OR <EQUAL? ,HERE ,FOG ,STEEP-TRAIL ,FUZZY>
		    <EQUAL? ,HERE ,OUTSIDE-COTTAGE>>
		<SAY-THE ,PRSO>
		<TELL " drops out of " D ,HANDS "s">
		<AND-DROPS-OUT ,PRSO>
		<RFALSE>)
	       (T
		<MOVE ,PRSO <LOC ,WINNER>>
		<RTRUE>)>>

<ROUTINE V-EAT ()
	 <NOT-LIKELY ,PRSO "would agree with you">>

<ROUTINE V-ENTER ("AUX" VEHICLE)
	 <COND (<EQUAL? ,PRSO ,ROOMS>
		<DO-WALK ,P?IN>)
	       (<FSET? ,PRSO ,WEARBIT>
		<PRESUMABLY-YOU-WANT-TO "WEAR" ,PRSO>
		<PERFORM ,V?WEAR ,PRSO>
		<RTRUE>)
	     ; (<SET VEHICLE <FIND-IN ,HERE ,VEHBIT>>
		<PERFORM ,V?ENTER .VEHICLE>
		<RTRUE>)
	       (T
		<TELL <PICK-ONE ,YUKS> CR>)>
	 <RTRUE>>

<ROUTINE PRE-DUMB-EXAMINE ()
	 <COND (<NOT ,LIT>
		<TOO-DARK>)
	       (T
		<TELL ,I-ASSUME " LOOK AT ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO 
", not LOOK INSIDE or LOOK ON or LOOK UNDER or LOOK BEHIND ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO ".)" CR>
		<PERFORM ,V?EXAMINE ,PRSO>)>
	 <RTRUE>>

<ROUTINE V-DUMB-EXAMINE ()
	 <V-EXAMINE>>

<ROUTINE PRE-EXAMINE ()
	 <COND (<NOT ,LIT>
		<TOO-DARK>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE V-EXAMINE ()
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<TELL "It looks like ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO " is ">
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL "open">)
	              (T
		       <TELL "closed">)>
	        <TELL "." CR>
	        <RTRUE>)
	       (<FSET? ,PRSO ,SURFACEBIT>
		<V-LOOK-ON>)
	       (<FSET? ,PRSO ,CONTBIT>
		<COND (<OR <FSET? ,PRSO ,OPENBIT>
			   <FSET? ,PRSO ,TRANSBIT>>
		       <V-LOOK-INSIDE>)
		      (T
		       <ITS-CLOSED ,PRSO>)>)
	       (T
		<TELL "You see nothing " <PICK-ONE ,YAWNS> " about ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO "." CR>)>>

<ROUTINE V-EXIT ()
	 <DO-WALK ,P?OUT>>

; <ROUTINE V-EXIT ()
	 <COND (<IN? ,PRSO ,POCKET>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (T
		<DO-WALK ,P?OUT>)>>

; <ROUTINE V-EXIT ()
	 <COND (<AND ,PRSO <FSET? ,PRSO ,VEHBIT>>
		<PERFORM ,V?DISEMBARK ,PRSO>
		<RTRUE>)
	       (T
		<DO-WALK ,P?OUT>)>>

<ROUTINE V-FILL ()
	 <COND (<NOT ,PRSI>
		<TELL "There's nothing to fill it with." CR>)
	       (T 
		<HOW?>)>>

<ROUTINE V-FIND ("AUX" L)
	 <SET L <LOC ,PRSO>>
	 <COND (<EQUAL? ,PRSO ,ME ,HANDS>
		<TELL "You're right here">)
	       (<IN? ,PRSO ,PROTAGONIST>
		<TELL "You're holding it">)
	       (<OR <IN? ,PRSO ,HERE>
		    <EQUAL? ,PRSO ,PSEUDO-OBJECT>>
		<BUT-THE ,PRSO>
		<TELL "is right in front of you">)
	       (<IN? ,PRSO ,LOCAL-GLOBALS>
		<HOW?>
		<RTRUE>)
	       (<AND <FSET? .L ,ACTORBIT>
		     <VISIBLE? .L>>
		<TELL "It looks like ">
		<ARTICLE .L T>
		<TELL D .L " has it">)
	       (<AND <SEE-INSIDE? .L>
		     <VISIBLE? .L>>
		<TELL "It's ">
		<COND (<FSET? .L ,SURFACEBIT>
		       <TELL "on ">)
		      (T
		       <TELL "in ">)>
		<ARTICLE .L T>
		<PRINTD .L>)
	       (T
		<TELL "You'll have to do that yourself">)>
	 <TELL "." CR>>

<ROUTINE V-FIRST-LOOK ()
	 <COND (<DESCRIBE-ROOM>
		<COND (<NOT ,SUPER-BRIEF>
		       <DESCRIBE-OBJECTS>)>)>>

<ROUTINE V-FLY ()
	 <TELL ,CANT " do that without Magick." CR>>

<ROUTINE V-FOLLOW ("AUX" WHERE)
	 <SET WHERE <LOC ,PRSO>>
	 <BUT-THE ,PRSO>
	 <TELL "is ">
	 <COND (<OR <EQUAL? .WHERE ,HERE>
		    <GLOBAL-IN? ,PRSO ,HERE>>
		<TELL "right here in front of you">)
	       (<EQUAL? .WHERE ,PROTAGONIST>
		<TELL "in " D ,HANDS "s">)
	       (<IN? .WHERE ,PROTAGONIST>
		<TELL "in ">
		<ARTICLE .WHERE T>
		<TELL D .WHERE>)
	       (T
		<TELL "nowhere to be seen">)>
	 <TELL "!" CR>>

<ROUTINE PRE-FEED ()
	 <COND (<PRE-GIVE T>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE V-FEED ()
	 <V-GIVE T>>

<ROUTINE V-SFEED ()
	 <PERFORM ,V?FEED ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE PRE-GIVE ("OPTIONAL" (FEED? <>))
	 <COND (<OR <NOT ,PRSO>
		    <NOT ,PRSI>>
		<REFERRING>
		<RTRUE>)
	     ; (<AND <FSET? ,PRSO ,ACTORBIT>
		     <HELD? ,PRSI>>
		<PERFORM ,V?GIVE ,PRSI ,PRSO>
		<RTRUE>)
	     ; (<AND <FSET? ,PRSI ,ACTORBIT>
		     <DONT-HAVE? ,PRSO>>
		<RTRUE>)
	       (<OR <IN? ,PRSO ,LOCAL-GLOBALS>
		    <IN? ,PRSO ,PSEUDO-OBJECT>>
		<NOT-HOLDING>
		<RTRUE>)
	       (<DONT-HAVE? ,PRSO>
		<RTRUE>)
	       (<AND <NOT <FSET? ,PRSI ,ACTORBIT>>
		     <NOT <EQUAL? ,PRSI ,MAILBOX>>>
		<TELL ,CANT>
		<COND (.FEED?
		       <TELL " feed">)
		      (T
		       <TELL " give">)>
		<TELL " anything to that!" CR>
		<RTRUE>)
	       (<FSET? ,PRSO ,WORNBIT>
		<TAKE-OFF-PRSO-FIRST>
		<RFALSE>)
	       (<AND <EQUAL? ,PRSO ,BROOM>
		     ,BROOM-SIT?>
		<GET-OFF-BROOM-FIRST>
		<RFALSE>)
	       (T
		<RFALSE>)>>

<ROUTINE V-SGIVE ()
	 <PERFORM ,V?GIVE ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-GIVE ("OPTIONAL" (FEED? <>))
	 <COND (<FSET? ,PRSI ,ACTORBIT>
		<TELL "Politely, ">
		<ARTICLE ,PRSI T>
		<TELL D ,PRSI " refuses your offer." CR>)
	       (T
		<TELL ,CANT>
		<COND (.FEED?
		       <TELL " feed ">)
		      (T
		       <TELL " give ">)>
		<ARTICLE ,PRSO>
		<TELL D ,PRSO " to ">
		<ARTICLE ,PRSI>
		<TELL D ,PRSI "!" CR>)>>

<ROUTINE V-HEEL ()
	 <COND (,WINNER
		<NOT-LIKELY ,WINNER "would heed your silly request">)
	       (T
		<WHAT-A-CONCEPT>)>> 

<ROUTINE V-HELLO ("AUX" WHO)
       <COND (,PRSO
	      <SET WHO ,PRSO>)
	     (T
	      <SET WHO <ANYONE-HERE?>>
	      <COND (.WHO
		     <SPOKEN-TO .WHO>
		     <PERFORM ,V?HELLO .WHO>
		     <RTRUE>)>)>
       <COND (.WHO
	      <COND (<FSET? .WHO ,ACTORBIT>
		     <TELL "It's apparent that ">
		     <ARTICLE .WHO T>
		     <TELL D .WHO " didn't expect you to say that." CR>)
	            (T
		     <NOT-LIKELY .WHO "would respond">)>)
	     (T
	      <TALK-TO-SELF>)>>

<ROUTINE V-HELP ()
	 <TELL
"(If you're really stuck, maps and InvisiClues (TM) Hint Booklets
are available using the order form that came">
	 <IN-YOUR-PACKAGE>
	 <TELL ".)" CR>>

<ROUTINE FIND-IN-PACKAGE (STRING)
	 <TELL "(You'll find the " .STRING>
	 <IN-YOUR-PACKAGE>
	 <TELL ".)" CR>>

<ROUTINE REFER-TO-MAP ()
	 <TELL "(Look at the map">
	 <IN-YOUR-PACKAGE>
	 <TELL " for directions.)" CR>>

<ROUTINE CONSULT-PACKAGE ()
	 <REFER-TO-MANUAL>
	 <TELL " for the correct way to make a Wish.)" CR>>

<ROUTINE REFER-TO-MANUAL ()
	 <TELL "(Refer to the manual">
	 <IN-YOUR-PACKAGE>>

<ROUTINE IN-YOUR-PACKAGE ()
	 <TELL " inside your " ,GAME " package">>

<ROUTINE V-HIDE ()
	 <TELL "There aren't any good hiding places here." CR>>

; <ROUTINE V-HIDE ()
	 <COND (<OR <FSET? ,PRSO ,ACTORBIT>
		    <FSET? ,PRSI ,ACTORBIT>>
		<TELL "It's clear that ">
	        <ARTICLE ,PRSO T>
	        <TELL D ,PRSO " wants no part in your paranoid scheme">)
	       (T
		<TELL "There aren't any good hiding places here">)>
	 <TELL "." CR>>

; <ROUTINE V-INFLATE ()
	 <TELL "How can you inflate that?" CR>>

<ROUTINE V-KICK ()
	 <HACK-HACK "Kicking">>

<ROUTINE V-KILL ()
	 <COND (<NOT <FSET? ,PRSO ,ACTORBIT>>
		<TELL ,CANT " attack ">
		<ARTICLE ,PRSO>
		<TELL D ,PRSO "!">)
	       (T
		<TELL "Attacking ">
		<ARTICLE ,PRSO T>
		<PRINTD ,PRSO>
		<COND (,PRSI
		       <TELL " with ">
		       <ARTICLE ,PRSI>
		       <PRINTD ,PRSI>)>
		<TELL " isn't likely to help matters.">)>
	 <CRLF>> 

; <ROUTINE V-KILL ()
	 <COND (<NOT <FSET? ,PRSO ,ACTORBIT>>
		<TELL "How can you attack ">
		<ARTICLE ,PRSO>
		<TELL D ,PRSO "?" CR>)
	       (<OR <NOT ,PRSI>
		    <EQUAL? ,PRSI ,HANDS>>
		<TELL "Attacking ">
		<ARTICLE ,PRSO>
		<TELL D ,PRSO " with your bare hands is suicidal." CR>)
	       (<NOT <FSET? ,PRSI ,WEAPONBIT>>
		<TELL "Attacking ">
		<ARTICLE ,PRSO>
		<TELL D ,PRSO " with ">
		<ARTICLE ,PRSI>
		<TELL D ,PRSI " is suicidal." CR>)
	       (T
	        <TELL "Agilely, ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO " dodges your blow." CR>)>>

<ROUTINE V-KNOCK ()
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<NO-ANSWER>)
	       (<FSET? ,PRSO ,ACTORBIT>
		<PERFORM ,V?USE ,PRSO>
		<RTRUE>)
	       (T
		<WASTE-OF-TIME>)>>

<ROUTINE V-KISS ()
	 <TELL "Smack!" CR>>

; <ROUTINE V-LAMP-OFF ()
	 <COND (<EQUAL? ,PRSO ,LANTERN>
		<COND (<NOT <FSET? ,PRSO ,ONBIT>>
		       <ITS-ALREADY "off">)
	              (T
		       <FCLEAR ,PRSO ,ONBIT>
		     ; <COND (,LIT
		              <SETG LIT <LIT? ,HERE>>)>
		       <TELL ,OKAY>
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO " is off." CR>
		       <SAY-IF-NOT-LIT>)>)
	       (T
		<TELL ,CANT " turn that off." CR>)>
	 <RTRUE>>

<ROUTINE V-LAMP-OFF ()
	 <V-LAMP-ON T>>

<ROUTINE V-LAMP-ON ("OPTIONAL" (OFF? <>))
	 <TELL ,CANT " turn that ">
	 <COND (.OFF?
		<TELL "off">)
	       (T
		<TELL "on">)>
	 <TELL "." CR>>

; <ROUTINE V-LAMP-ON ()
	 <COND (<EQUAL? ,PRSO ,LANTERN>
		<COND (<FSET? ,PRSO ,ONBIT>
		       <ITS-ALREADY "on">)
		      (T
		       <FSET ,PRSO ,ONBIT>
		       <TELL ,OKAY>
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO " is now on." CR>
		       <COND (<NOT ,LIT>
			      <SETG LIT <LIT? ,HERE>>
			      <CRLF>
			      <V-LOOK>)>)>)
	       (T
		<TELL ,CANT " turn that on." CR>)>
	 <RTRUE>>

; <ROUTINE V-LAUNCH ()
	 <COND (<FSET? ,PRSO ,VEHBIT>
		<TELL ,CANT " launch that by saying \"launch\"!" CR>)
	       (T
		<TELL "Huh?" CR>)>>

<ROUTINE V-LEAP ()
	 <COND (<NOT <EQUAL? ,PRSO ,ROOMS>>
		<TELL "That'd be a cute trick." CR>)
	       (<FSET? ,HERE ,WETBIT>
		<YOU-MEAN-WATER>)
	       (T
		<WASTE-OF-TIME>)>>

<ROUTINE YOU-MEAN-WATER ()
	 <TELL ,I-ASSUME " in the water.)" CR>
	 <PROBABLY-DROWN>>

; <ROUTINE V-LEAP ()
	 <COND (,PRSO
		<DO-WALK ,P?OUT>)
	       (T
		<V-SKIP>)>>

<ROUTINE V-LEAVE ()
	 <COND (<OR <EQUAL? ,PRSO ,ROOMS>
		    <NOT <FSET? ,PRSO ,TAKEBIT>>>
		<DO-WALK ,P?OUT>)
	       (<NOT <DONT-HAVE? ,PRSO>>
		<PERFORM ,V?DROP ,PRSO>)>
	 <RTRUE>>

<ROUTINE V-LIE-DOWN ()
	 <TELL "This is no time for resting." CR>
	 <RTRUE>>

; <ROUTINE PRE-DUMB-LISTEN ()
	 <PRESUMABLY-YOU-WANT-TO "LISTEN TO" ,PRSO>
	 <RFALSE>>

; <ROUTINE V-DUMB-LISTEN ()
	 <PERFORM ,V?LISTEN ,PRSO>
	 <RTRUE>>

<ROUTINE V-LISTEN ()
	 <COND (<EQUAL? ,PRSO ,ROOMS>
		<PERFORM ,V?LISTEN ,SOUND>
		<RTRUE>)
	       (T
		<TELL "At the moment, ">
	        <ARTICLE ,PRSO T>
	        <TELL D ,PRSO " makes no sound." CR>)>>

<ROUTINE V-LOCK ()
	 <COND (<OR <FSET? ,PRSO ,DOORBIT>
		    <FSET? ,PRSO ,CONTBIT>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <YOUD-HAVE-TO "close" ,PRSO>)
		      (<FSET? ,PRSO ,LOCKEDBIT>
		       <BUT-THE ,PRSO>
		       <TELL "is already locked." CR>)
	       	      (T
		       <THING-WONT-LOCK ,PRSI ,PRSO>)>)
	       (T
		<CANT-LOCK>)>>

<ROUTINE V-UNLOCK ()
	 <COND (<OR <FSET? ,PRSO ,DOORBIT>
		    <FSET? ,PRSO ,CONTBIT>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <ALREADY-OPEN>)
		      (<NOT <FSET? ,PRSO ,LOCKEDBIT>>
		       <BUT-THE ,PRSO>
		       <TELL "isn't locked." CR>)
	       	      (T
		       <THING-WONT-LOCK ,PRSI ,PRSO T>)>)
	       (T
		<CANT-LOCK T>)>>

<ROUTINE CANT-LOCK ("OPTIONAL" (UN? <>))
	 <TELL ,CANT " ">
	 <COND (.UN?
		<TELL "un">)>
	 <TELL "lock ">
	 <ARTICLE ,PRSO>
	 <TELL D ,PRSO "!" CR>>

<ROUTINE THING-WONT-LOCK (THING CLOSED-THING "OPTIONAL" (UN? <>))
	 <TELL "A quick test shows that ">
	 <ARTICLE .THING T>
	 <TELL D .THING " won't ">
	 <COND (.UN?
		<TELL "un">)>
	 <TELL "lock ">
	 <ARTICLE .CLOSED-THING T>
	 <TELL D .CLOSED-THING "." CR>>

<ROUTINE V-LOOK ()
	 <COND (<DESCRIBE-ROOM T>
		<DESCRIBE-OBJECTS>)>>

<ROUTINE V-LOOK-BEHIND ()
	 <COND (<NOT ,LIT>
		<TOO-DARK>)
	       (T
		<TELL "There's nothing behind ">
	        <ARTICLE ,PRSO T>
	        <TELL D ,PRSO "." CR>)>>

<ROUTINE V-LOOK-DOWN ()
	 <COND (<NOT ,LIT>
		<TOO-DARK>)
	       (<EQUAL? ,PRSO ,ROOMS>
		<PERFORM ,V?EXAMINE ,GROUND>)
	       (T
		<PERFORM ,V?LOOK-INSIDE ,PRSO>)>
	 <RTRUE>>

<ROUTINE V-LOOK-UP ()
	 <COND (<NOT ,LIT>
		<TOO-DARK>)
	       (<EQUAL? ,PRSO ,ROOMS>
		<COND (<EQUAL? ,HERE ,UNDER-HILL>
		       <PERFORM ,V?EXAMINE ,STUMP>)
		      (<FSET? ,HERE ,INDOORSBIT>
		       <PERFORM ,V?EXAMINE ,CEILING>)
		      (<IN? ,VULTURE ,HERE>
		       <SEE-VULTURE>)
		      (<OR <NOT ,SKEWED?>
			   ,SUCCESS?
			   <EQUAL? ,HERE ,FOG>>
		       <STIFF-NECK>)
		      (T
		       <PERFORM ,V?EXAMINE ,MOON>)>
		<RTRUE>)
	       (T
		<STIFF-NECK>)>>

<ROUTINE STIFF-NECK ()
	 <TELL "You begin to get a stiff neck." CR>>

<ROUTINE V-LOOK-INSIDE ()
	 <COND (<NOT ,LIT>
		<TOO-DARK>)
	       (<FSET? ,PRSO ,ACTORBIT>
		<NOT-A "surgeon">)
	       (<FSET? ,PRSO ,DOORBIT>
		<PERFORM ,V?EXAMINE ,PRSO>
		<RTRUE>)
	       (<FSET? ,PRSO ,CONTBIT>
		<COND (<EQUAL? ,PRSO <LOC ,WINNER>>
		       <V-LOOK>)
		      (<AND <NOT <FSET? ,PRSO ,OPENBIT>>
			    <NOT <FSET? ,PRSO ,TRANSBIT>>>
		       <ITS-CLOSED ,PRSO>)
		      (T
		       <TELL ,YOU-SEE>
		       <PRINT-CONTENTS ,PRSO>
		       <TELL " in ">
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO "." CR>)>)
	       (T
		<TELL ,CANT " look inside ">
		<ARTICLE ,PRSO>
		<TELL D ,PRSO "." CR>)>>

<ROUTINE NOT-A (STR)
	 <TELL "You're a mail clerk, not a " .STR "!" CR>>

<ROUTINE V-LOOK-ON ()
	 <COND (<NOT ,LIT>
		<TOO-DARK>
		<RTRUE>)>
	 <TELL ,YOU-SEE>
	 <COND (<FSET? ,PRSO ,SURFACEBIT>
		<PRINT-CONTENTS ,PRSO>)
	       (T
		<TELL "nothing " <PICK-ONE ,YAWNS>>)>
	 <TELL " on ">
	 <ARTICLE ,PRSO T>
	 <TELL D ,PRSO "." CR>>

<ROUTINE V-LOOK-THRU ()
	 <COND (<NOT ,LIT>
		<TOO-DARK>)
	       (<AND ,PRSI
		     <NOT <FSET? ,PRSI ,TRANSBIT>>>
		<TELL ,CANT " look through that!" CR>)
	       (T
		<NOTHING-INTERESTING T>)>>

<ROUTINE V-LOOK-UNDER ()
	 <COND (<NOT ,LIT>
		<TOO-DARK>)
	       (<IN? ,PRSO ,PROTAGONIST>
		<TELL "You're already ">
		<COND (<FSET? ,PRSO ,WORNBIT>
		       <TELL "wear">)
		      (T
		       <TELL "hold">)>
		<TELL "ing that!" CR>)
	       (T
		<NOTHING-INTERESTING T>)>>

<ROUTINE V-LOWER ()
	 <V-RAISE>>

; <ROUTINE V-MELT ()
	 <TELL ,CANT " melt that!" CR>>

<ROUTINE V-MOVE ()
	 <COND ; (<HELD? ,PRSO>
		  <TELL "Why juggle objects?" CR>)
	       (<EQUAL? ,PRSO ,ROOMS>
		<V-WALK-AROUND>)
	       (<FSET? ,PRSO ,TAKEBIT>
		<TELL "Moving ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO " reveals nothing " <PICK-ONE ,YAWNS> "." CR>)
	       (T
		<TELL ,CANT " move ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO "." CR>)>>

<ROUTINE V-MUNG ()
	 <HACK-HACK "Trying to destroy">>

<ROUTINE V-OPEN ("AUX" F STR)
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<NOT-A "surgeon">)
	       
	       (<AND <NOT <FSET? ,PRSO ,CONTBIT>>
		     <NOT <FSET? ,PRSO ,DOORBIT>>>
		<TELL "How can you">
		<DO-TO>
		<ARTICLE ,PRSO>
		<TELL D ,PRSO "?" CR>)
	       
	       (<FSET? ,PRSO ,OPENBIT>
		<ALREADY-OPEN>)
	       
	       ;(<AND ,PRSI
		     <NOT <FSET? ,PRSI ,TOOLBIT>>>
		<TELL "With ">
		<ARTICLE ,PRSI>
		<TELL D ,PRSI "?!" CR>)

	       (<FSET? ,PRSO ,LOCKEDBIT>
		<OBJECT-IS-LOCKED>)
               
	       (<FSET? ,PRSO ,CONTBIT>  ; "Container"
		<FSET ,PRSO ,OPENBIT>
		<FSET ,PRSO ,TOUCHBIT>
		<COND (<OR <NOT <FIRST? ,PRSO>>
			   <FSET? ,PRSO ,TRANSBIT>>
		     ; <OPENED>
		     ; <CRLF>
		       <NOW-CLOSED-OR-OPEN ,PRSO T>)
		    ; (<AND <SET F <FIRST? ,PRSO>>
			    <NOT <NEXT? .F>>
			    <SET STR <GETP .F ,P?FDESC>>>
		       <TELL ,OKAY>
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO " is now open." CR CR .STR CR>)
		      (T
		       <TELL "Opening ">
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO " reveals ">
		       <PRINT-CONTENTS ,PRSO>
		       <TELL "." CR>)>)
	       
	       (T                                 ; "Door"
	      ; <FSET ,PRSO ,OPENBIT>
	      ; <THIS-IS-IT ,PRSO>
	      ; <TELL ,OKAY>
	      ; <ARTICLE ,PRSO T>
	      ; <TELL D ,PRSO " is now open." CR>
		<NOW-CLOSED-OR-OPEN ,PRSO T>
		<COND (<EQUAL? ,PRSO ,LIBRARY-DOOR>
		       <FSET ,CIRCULATION-DESK ,ONBIT>
		       <SETG LIT <LIT? ,HERE>>)>)>>

<ROUTINE V-PAY ()
	 <PERFORM ,V?GIVE ,PRSI ,PRSO>
	 <RTRUE>>
	       
<ROUTINE V-PLAY ()
	 <COND (<EQUAL? ,PRSO ,ROOMS>
		<WASTE-OF-TIME>)
	       (T
		<HACK-HACK "Playing with">)>>

<ROUTINE V-PICK ()
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<NOT-A "locksmith">)
	       (T
		<WHAT-A-CONCEPT>)>>

; <ROUTINE V-PLUG ()
	 <TELL "This has no effect." CR>>

; <ROUTINE PRE-POCKET ()
	 <PERFORM ,V?PUT ,PRSO ,POCKET>
	 <RTRUE>>

; <ROUTINE V-POCKET ()
	 <WASTE-OF-TIME>>

<ROUTINE V-POINT ()
	 <TELL "It's not polite to point." CR>>

<ROUTINE V-POUR ()
	 <TELL ,CANT " pour that!" CR>>

<ROUTINE V-EMPTY ("AUX" OBJ NXT)
	 <COND (<FSET? ,PRSO ,CONTBIT>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <SET OBJ <FIRST? ,PRSO>>
		       <COND (.OBJ
			      <REPEAT ()
				      <COND (.OBJ
					     <SET NXT <NEXT? .OBJ>>
					     <COND (<NOT <FSET? .OBJ
							  ,NARTICLEBIT>>
						    <TELL "The ">)>
					     <TELL D .OBJ ": ">
					     <PERFORM ,V?TAKE .OBJ ,PRSO>
					     <SET OBJ .NXT>)
					    (T
					     <RETURN>)>>)
			     (T
			      <BUT-THE ,PRSO>
			      <TELL "is already empty!" CR>)>)
		      (T
		       <ITS-CLOSED ,PRSO>)>)
	       (T
		<TELL ,CANT " empty that!" CR>)>
	 <RTRUE>>
		
<ROUTINE V-PULL ()
	 <HACK-HACK "Pulling on">>

<ROUTINE V-PUSH ()
	 <HACK-HACK "Pushing around">>

<ROUTINE V-PUSH-TO ()
	 <TELL ,CANT " push things to that." CR>>

<ROUTINE PRE-PUT ()
	 <COND (<OR <IN? ,PRSO ,GLOBAL-OBJECTS>
		    <NOT <FSET? ,PRSO ,TAKEBIT>>>
		<TELL <PICK-ONE ,YUKS> CR>
		<RTRUE>)
	       (<DONT-HAVE? ,PRSO>
		<RTRUE>)	     
	       (<NOT <ACCESSIBLE? ,PRSI>>
		<CANT-SEE-ANY ,PRSI>
		<RTRUE>)
	       (<FSET? ,PRSO ,WORNBIT>
		<TAKE-OFF-PRSO-FIRST>
		<RFALSE>)
	       (<AND <EQUAL? ,PRSO ,BROOM>
		     ,BROOM-SIT?>
		<GET-OFF-BROOM-FIRST>
		<RFALSE>)
	       (T
		<RFALSE>)>>

<ROUTINE TAKE-OFF-PRSO-FIRST ()
	 <TELL "(taking off ">
	 <ARTICLE ,PRSO T>
	 <TELL D ,PRSO " first)" CR>
	 <PERFORM ,V?TAKE-OFF ,PRSO>
	 <CRLF>
	 <RTRUE>>

<ROUTINE GET-OFF-BROOM-FIRST ()
	 <SETG BROOM-SIT? <>>
	 <TELL "(getting off the " D ,BROOM " first)" CR>>

<ROUTINE V-PUT ()
	 <COND (<AND ,PRSI
		     <NOT <FSET? ,PRSI ,OPENBIT>>
		     <NOT <FSET? ,PRSI ,DOORBIT>>
		     <NOT <FSET? ,PRSI ,CONTBIT>>
		     <NOT <FSET? ,PRSI ,SURFACEBIT>>
		     ;<NOT <FSET? ,PRSI ,VEHBIT>>>
		<TELL ,CANT " possibly do that!" CR>
		<RTRUE>)
	       (<AND <NOT <FSET? ,PRSI ,OPENBIT>>
		     <NOT <FSET? ,PRSI ,SURFACEBIT>>>
		<BUT-THE ,PRSI>
		<TELL "isn't open!" CR>
		<THIS-IS-IT ,PRSI>)
	       (<EQUAL? ,PRSI ,PRSO>
		<WHAT-A-CONCEPT>)
	       (<IN? ,PRSO ,PRSI>
		<BUT-THE ,PRSO>
		<TELL "is already ">
		<COND (<FSET? ,PRSI ,SURFACEBIT>
		       <TELL "on ">)
		      (T
		       <TELL "in ">)>
		<ARTICLE ,PRSI T>
		<TELL D ,PRSI "!" CR>)
	       (<G? <- <+ <WEIGHT ,PRSI> <WEIGHT ,PRSO>>
		       <GETP ,PRSI ,P?SIZE>>
		    <GETP ,PRSI ,P?CAPACITY>>
		<NO-ROOM>
		<CRLF>)
	       (<AND <NOT <IN? ,PRSO ,PROTAGONIST>>
		     <EQUAL? <ITAKE> <> ,M-FATAL>>
		<RTRUE>)
	       (T
	        <COND (<EQUAL? ,PRSO ,KITTY>
		       <SETG HORSE-SCRIPT 3>)>
	      	<MOVE ,PRSO ,PRSI>
		<FSET ,PRSO ,TOUCHBIT>
		<TELL "Done." CR>)>>
	
<ROUTINE NO-ROOM ()
	 <TELL "There's no room. ">>

<ROUTINE SAY-IF-NOT-LIT ()
	 <SETG LIT <LIT? ,HERE>>
	 <COND (<NOT ,LIT>
		<CRLF>
		<NOW-BLACK>
		<CRLF>)>>

<ROUTINE V-PUT-BEHIND ()
	 <TELL "That hiding place is too obvious." CR>>

<ROUTINE PRE-PUT-ON ()
	 <COND (<PRE-PUT>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE V-PUT-ON ()
	 <COND (<EQUAL? ,PRSI ,ME>
		<PERFORM ,V?WEAR ,PRSO>
		<RTRUE>)
	       (<FSET? ,PRSI ,SURFACEBIT>
		<V-PUT>)
	       (T
		<TELL "There's no good surface on ">
		<COND (,PRSI
		       <ARTICLE ,PRSI T>
		       <PRINTD ,PRSI>)
		      (T
		       <TELL "that">)>
		<TELL "." CR>)>>

<ROUTINE V-PUT-UNDER ()
         <TELL ,CANT " put anything under that." CR>>

<ROUTINE V-RAPE ()
	 <TELL "What a wholesome idea." CR>>

<ROUTINE V-RAISE ("AUX" THING)
	 <COND (<EQUAL? ,PRSO ,ROOMS>
		<COND (<AND <EQUAL? ,HERE ,INSIDE-THEATER>
		            <FSET? ,SEAT ,TOOLBIT>>
		       <SET THING ,SEAT>)
	              (<AND <EQUAL? ,HERE ,LOOKOUT-HILL>
		             ,ON-STUMP?>
		       <SET THING ,STUMP>)
	              (,BROOM-SIT?
		       <SET THING ,BROOM>)
	              (T
		       <PERFORM ,V?ALARM ,ME>
		       <RTRUE>)>
	        <TELL ,I-ASSUME " off the " D .THING ")" CR>
	        <PERFORM ,V?TAKE-OFF .THING>
	        <RTRUE>)
	       (<IN? ,PRSO ,PROTAGONIST>
		<HACK-HACK "Toying in this way with">
		<RTRUE>)
	       (<FSET? ,PRSO ,TAKEBIT>
		<NOT-HOLDING ,PRSO>
		<RTRUE>)
	       (T
		<TELL ,CANT>
		<DO-TO>)>
	 <ARTICLE ,PRSO T>
	 <TELL D ,PRSO "!" CR>>

<ROUTINE V-REACH-IN ("AUX" OBJ)
	 <SET OBJ <FIRST? ,PRSO>>
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<NOT-A "surgeon">)
	       (<NOT <FSET? ,PRSO ,CONTBIT>>
		<TELL <PICK-ONE ,YUKS> CR>)
	       (<NOT <FSET? ,PRSO ,OPENBIT>>
		<TELL "It's not open." CR>)
	       (<OR <NOT .OBJ>
		    <FSET? .OBJ ,INVISIBLE>
		    <NOT <FSET? .OBJ ,TAKEBIT>>>
		<TELL "It's empty." CR>)
	       (T
		<TELL "You reach into ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO " and feel something." CR>
		<RTRUE>)>>

<ROUTINE V-READ ()
	 <COND (<NOT ,LIT>
		<TOO-DARK>)
	       (<NOT <FSET? ,PRSO ,READBIT>>
		<HOW-READ>
		<TELL "?" CR>)
	       (T
		<TELL "It's undecipherable." CR>)>>

<ROUTINE V-READ-TO ()
	 <COND (<NOT ,LIT>
		<TOO-DARK>)
	       (<NOT <FSET? ,PRSO ,READBIT>>
		<HOW-READ>
		<TELL " to ">
		<ARTICLE ,PRSI>
		<TELL D ,PRSI "?" CR>)
	       (T
		<NOT-LIKELY ,PRSI "would appreciate your reading">)>>

<ROUTINE HOW-READ ()
	 <TELL "How can you read ">
	 <ARTICLE ,PRSO>
	 <PRINTD ,PRSO>>

<ROUTINE V-RELEASE ()
	 <COND (<EQUAL? ,PRSO ,ME>
		<COND (<OR ,CHAINED?
			 ; <AND <EQUAL? ,HERE ,TROLL-CAVE>
				<NOT <IN? ,CREVICE ,HERE>>>
			   <EQUAL? ,HERE ,JAIL-CELL>>
		       <HOW?>
		       <RTRUE>)
		      (T
		       <TELL "But you are">)>)
	       (T
		<BUT-THE ,PRSO>
	        <TELL "is">)>
	 <TELL "n't confined by anything!" CR>>
		
<ROUTINE V-REPLACE ()
	 <COND (<EQUAL? ,PRSO ,ME>
		<TELL "That's easy">)
	       (T
		<BUT-THE ,PRSO>
	        <TELL "doesn't need replacement">)>
	 <TELL "." CR>>

<ROUTINE V-REPLY ()
	 <NOT-LIKELY ,PRSO "is interested">
	 <PCLEAR>
	 <RFATAL>>

<ROUTINE V-RESCUE ()
	 <COND (<EQUAL? ,PRSO ,ME>
		<V-HELP>)
	       (T
		<BUT-THE ,PRSO>
	        <TELL "doesn't need any help." CR>)>>

<ROUTINE V-RIDE ()
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<NOT-LIKELY ,PRSO "wants to play piggyback">)
	       (T
		<TELL ,CANT " ride that!" CR>)>
	 <CRLF>>

<ROUTINE V-RUB ()
	 <HACK-HACK "Fiddling with">>

<ROUTINE V-BOW ()
	 <HACK-HACK "Paying respect to">>

<ROUTINE V-YELL ()
	 <COND (<EQUAL? ,HERE ,GRUE-NEST>
		<PERFORM ,V?HELLO ,BABY>
		<RTRUE>)
	       (<MAGIC-TALK?>
		<RTRUE>)
	       (<ANYONE-HERE?>
		<WAY-TO-TALK>
		<PCLEAR>
		<RFATAL>)
	       (T
		<PCLEAR>
		<TELL "You begin to get a sore throat." CR>)>>

<GLOBAL SAYING? <>>

<ROUTINE V-SAY ()
	 <COND (<MAGIC-TALK?>
		<RTRUE>)
	       (<ANYONE-HERE?>
		<WAY-TO-TALK>
		<PCLEAR>
		<RFATAL>)
	       (T
		<TALK-TO-SELF>)>>

<ROUTINE MAGIC-TALK? ()
	 <COND (<EQUAL? <GET ,P-LEXV ,P-CONT> ,W?KALUZE ,W?FRATTO ,W?SORKIN>
		<SETG QUOTE-FLAG <>>
		<SETG CLOCK-WAIT T>
		<SETG SAYING? T>
		<RTRUE>)
	       (T
		<RFALSE>)>>

; <ROUTINE V-SAY ()
	 <TELL "(To say something out loud, simply type the word or phrase at the prompt.)" CR>
	 <PCLEAR>
	 <RFATAL>>

; <ROUTINE V-SAY ("AUX" WHO)
	 <SETG SAYING? T>
	 <COND (<EQUAL? ,PRSO ,ROOMS>
		<SETG QUOTE-FLAG <>>
		<SET WHO <ANYONE-HERE?>>)
	       (T
		<SET WHO ,PRSO>)>
	 <COND (.WHO
		<COND (,P-CONT
		       <SETG CLOCK-WAIT T>)
		      (T
		       <PERFORM ,V?HELLO .WHO>)>
		<RTRUE>)
	       (,P-CONT
		<SETG CLOCK-WAIT T>
		<RTRUE>)
	       (T
		<TALK-TO-SELF>)>>

<ROUTINE V-SEARCH ()
	 <COND (<EQUAL? ,PRSO ,ME>
		<V-HELP>)
	       (<FSET? ,PRSO ,CONTBIT>
		<COND (<AND <NOT <FSET? ,PRSO ,OPENBIT>>
			    <NOT <FSET? ,PRSO ,TRANSBIT>>>
		       <YOUD-HAVE-TO "open" ,PRSO>)
		      (T
		       <TELL ,YOU-SEE>
		       <PRINT-CONTENTS ,PRSO>
		       <TELL " inside ">
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO "." CR>)>)
	       (<FSET? ,PRSO ,SURFACEBIT>
		<TELL ,YOU-SEE>
		<PRINT-CONTENTS ,PRSO>
		<TELL " on ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO "." CR>)
	       (<FSET? ,PRSO ,ACTORBIT>
		<PERFORM ,V?USE ,PRSO>
	        <RTRUE>) 
	       (T
		<NOTHING-INTERESTING>)>>

<ROUTINE NOTHING-INTERESTING ("OPTIONAL" (SEE? <>))
	 <TELL "You ">
	 <COND (.SEE?
		<TELL "see">)
	       (T
		<TELL "find">)>
	 <TELL " nothing " <PICK-ONE ,YAWNS> "." CR>>

<GLOBAL YAWNS <LTABLE 0 "unusual" "interesting" "extraordinary" "special">>

; <ROUTINE V-SEND ()
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<TELL "Why would you send for ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO "?" CR>)
	       (T
		<TELL <PICK-ONE ,YUKS> CR>)>>

<ROUTINE V-SHAKE ("AUX" X)
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<PERFORM ,V?ALARM ,PRSO>
		<RTRUE>)
	       (<AND <NOT <FSET? ,PRSO ,TAKEBIT>>
		     <NOT <FSET? ,PRSO ,TRYTAKEBIT>>>
		<HACK-HACK "Shaking">)
	       (T
		<WASTE-OF-TIME>)>>

; <ROUTINE V-SHARPEN ()
	 <TELL "You'll never sharpen anything with that!" CR>>

<ROUTINE V-SHOOT ()
	 <TELL "You don't have any weapons." CR>>

; <ROUTINE V-SHOW ()
	 <TELL "It isn't likely that ">
	 <ARTICLE ,PRSI T>
	 <TELL D ,PRSI " is interested." CR>>

<ROUTINE V-SIT ()
	 <COND (<EQUAL? ,HERE ,INSIDE-THEATER>
		<PERFORM ,V?SIT ,SEAT>)
	       (<EQUAL? ,HERE ,LOOKOUT-HILL>
		<PERFORM ,V?SIT ,STUMP>)
	       (T
		<WASTE-OF-TIME>)>
	 <RTRUE>>

; <ROUTINE V-SKIP ()
	 <TELL "Wheeee! Wasn't that fun?" CR>>

<ROUTINE V-SLEEP ()
	 <TELL "You're not tired." CR>>

<ROUTINE V-SMELL ()
	 <COND (<EQUAL? ,PRSO ,ROOMS>
		<TELL "You smell nothing " <PICK-ONE ,YAWNS>>)
	       (T
		<TELL "It smells just like ">
	        <ARTICLE ,PRSO>
	        <PRINTD ,PRSO>)>
	 <TELL "." CR>>

<ROUTINE V-SPIN ()
	 <TELL ,CANT " spin that!" CR>>

<ROUTINE V-SQUEEZE ()
	 <WASTE-OF-TIME>>

; <ROUTINE PRE-SSHOW ()
	 <PERFORM ,V?SHOW ,PRSI ,PRSO>
	 <RTRUE>>

; <ROUTINE V-SSHOW ()
	 <V-SGIVE>>

<ROUTINE V-STAND ()
	 <COND (<EQUAL? ,HERE ,INSIDE-THEATER>
		<PERFORM ,V?EXIT ,SEAT>
		<RTRUE>)
	       ; (<FSET? <LOC ,WINNER> ,VEHBIT>
		  <PERFORM ,V?DISEMBARK <LOC ,WINNER>>
		  <RTRUE>)
	       (<AND ,ON-STUMP?
		     <EQUAL? ,HERE ,LOOKOUT-HILL>>
		<PERFORM ,V?TAKE-OFF ,STUMP>
		<RTRUE>)
	       (T
		<TELL "You're already standing." CR>)>>

<ROUTINE V-STAND-ON ()
	 <WASTE-OF-TIME>>

<ROUTINE V-STAND-UNDER ()
	 <TELL <PICK-ONE ,YUKS> CR>>

;<ROUTINE V-STRIKE ()
	 <PERFORM ,V?KILL ,PRSO>
	 <RTRUE>>

<ROUTINE V-SWING ()
	 <COND (<NOT ,PRSI>
		<TELL "Whoosh!" CR>)
	       (T
		<PERFORM ,V?KILL ,PRSI ,PRSO>
		<RTRUE>)>>

<ROUTINE V-SWIM ()
	 <COND (<AND <EQUAL? ,PRSO ,ROOMS>
		     <FSET? ,HERE ,WETBIT>>
		<COND (<EQUAL? ,HERE ,PARK>
		       <PERFORM ,V?SWIM ,FOUNTAIN>
		       <RTRUE>)
		      (T
		       <YOU-MEAN-WATER>)>)
	       (T
		<TELL ,CANT " swim here!" CR>)>>

<ROUTINE V-TAKE-OFF ("AUX" WHERE)
	 <COND (<FSET? ,PRSO ,TAKEBIT>
		<COND (<AND <IN? ,PRSO ,PROTAGONIST>
		            <FSET? ,PRSO ,WORNBIT>>
		       <FCLEAR ,PRSO ,WORNBIT>
		       <TELL ,OKAY "you're no longer wearing ">
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO "." CR>
		       <COND (<AND <EQUAL? ,PRSO ,GLASSES>
			           <NOT ,ENDING?>>
		              <SET WHERE ,HERE>
			      <COND (<EQUAL? ,HERE ,LABORATORY>
		                     <SETG FUZZY? T>
		                     <SETG FUZZY-FROM ,LABORATORY>
		                     <MOVE ,PROTAGONIST ,FUZZY>
		                     <SETG HERE ,FUZZY>)
	                            (<AND <EQUAL? ,FUZZY-FROM ,LOBBY>
		                          <DIGGER-PISSED?>>
		                     <SETG FUZZY? <>>
		                     <SETG FUZZY-FROM ,ROTARY-EAST>
				     <SETG HERE ,ROTARY-EAST>
		                     <MOVE ,PROTAGONIST ,ROTARY-EAST>)
	                            (<NOT <EQUAL? ,HERE ,INSIDE-THEATER>>
		                     <SETG FUZZY? <>>
		                     <SETG HERE ,FUZZY-FROM>
		                     <MOVE ,PROTAGONIST ,FUZZY-FROM>)>
	                      <COND (<NOT <EQUAL? .WHERE ,HERE>>
				     <SETG LIT <LIT? ,HERE>>
			             <CRLF>
		                     <V-LOOK>)>)>)
		      (T
		       <TELL "You aren't wearing that!" CR>)>)
	       (T
		<DO-WALK ,P?OUT>)>>

<ROUTINE V-TASTE ()
	 <PERFORM ,V?EAT ,PRSO>
	 <RTRUE>>

<ROUTINE V-TELL ()
	 <COND (<EQUAL? ,PRSO ,ME ,ROOMS>
		<TALK-TO-SELF>)
	       (<FSET? ,PRSO ,ACTORBIT>
		<COND (<NOT <ZERO? ,P-CONT>>
		       <SETG WINNER ,PRSO>
		       <SETG HERE <LOC ,WINNER>>)
		      (T
		       <NO-ANSWER>)>)
	       (T
		<TELL ,CANT " talk to ">
		<ARTICLE ,PRSO>
		<TELL D ,PRSO "!" CR>
		<PCLEAR>
		<RFATAL>)>>

<ROUTINE NO-ANSWER ()
	 <TELL "There's no answer." CR>>

<ROUTINE V-THANK ()
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<TELL "You do so, but ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO 
" seems less than overjoyed by your gratitude." CR>)
	       (T
		<TELL "You're loony." CR>)>>

<ROUTINE V-THROUGH ()
	 <COND (<EQUAL? ,PRSO ,ROOMS>
		<DO-WALK ,P?IN>)
	       (<FSET? ,PRSO ,DOORBIT>
	        <DO-WALK <OTHER-SIDE ,PRSO>>
	        <RTRUE>)
	     ; (<FSET? ,PRSO ,VEHBIT>
	        <PERFORM ,V?ENTER ; ,V?BOARD ,PRSO>
	        <RTRUE>)
	       (<IN? ,PRSO ,WINNER>
	        <TELL "That would involve quite a contortion!" CR>)
	       (<FSET? ,PRSO ,ACTORBIT>
		<V-RAPE>)
	     ; (<NOT <FSET? ,PRSO ,TAKEBIT>>
	        <TELL "You hit your head against ">
	        <ARTICLE ,PRSO T>
	        <TELL D ,PRSO " as you attempt this feat." CR>)
	       (T
		<TELL <PICK-ONE ,YUKS> CR>)>>

<ROUTINE PRE-THROW ()
	 <COND (<PRE-PUT>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE V-THROW ()
	 <COND (<EQUAL? ,HERE ,OUTSIDE-COTTAGE>
		<PERFORM ,V?GIVE ,PRSO ,POOCH>)
	       (<IDROP>
		<TELL "Thrown." CR>)>
	 <RTRUE>>

<ROUTINE V-THROW-OFF ()
	 <WASTE-OF-TIME>>

<ROUTINE V-TIE ()
	 <TELL ,CANT " tie ">
	 <ARTICLE ,PRSO T>
	 <TELL D ,PRSO " to that." CR>>

<ROUTINE V-TIE-UP ()
	 <TELL  ,CANT " tie anything with that!" CR>>

<ROUTINE V-TURN ()
	 <COND (<AND <NOT <FSET? ,PRSO ,TAKEBIT>>
		     <NOT <FSET? ,PRSO ,TRYTAKEBIT>>>
		<TELL <PICK-ONE ,YUKS> CR>)
	       (T
		<HACK-HACK "Turning">)>>

<ROUTINE DO-WALK (DIR)
	 <SETG P-WALK-DIR .DIR>
	 <PERFORM ,V?WALK .DIR>
	 <RTRUE>>

<ROUTINE V-WALK ("AUX" PT PTS STR OBJ RM)
	<COND (<NOT ,P-WALK-DIR>
		<COND (,PRSO
		       <PRESUMABLY-YOU-WANT-TO  "WALK TO" ,PRSO>
		       <PERFORM ,V?WALK-TO ,PRSO>)
		      (T
		       <V-WALK-AROUND>)>
		<RTRUE>)
	       (<SET PT <GETPT ,HERE ,PRSO>>
		<COND (<EQUAL? <SET PTS <PTSIZE .PT>> ,UEXIT>
		       <GOTO <GETB .PT ,REXIT>>)
		      (<EQUAL? .PTS ,NEXIT>
		       <TELL <GET .PT ,NEXITSTR> CR>
		       <RFATAL>)
		      (<EQUAL? .PTS ,FEXIT>
		       <COND (<SET RM <APPLY <GET .PT ,FEXITFCN>>>
			      <GOTO .RM>)
			     (T
			      <RFATAL>)>)
		      (<EQUAL? .PTS ,CEXIT>
		       <COND (<VALUE <GETB .PT ,CEXITFLAG>>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<SET STR <GET .PT ,CEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <CANT-GO>
			      <RFATAL>)>)
		      (<EQUAL? .PTS ,DEXIT>
		       <COND (<FSET? <SET OBJ <GETB .PT ,DEXITOBJ>> ,OPENBIT>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<SET STR <GET .PT ,DEXITSTR>>
			      <TELL .STR CR>
			      <THIS-IS-IT .OBJ>
			      <RFATAL>)
			     (T
			      <ITS-CLOSED .OBJ>
			      <RFATAL>)>)>)
	       (T
		<CANT-GO>
		<RFATAL>)>>

<ROUTINE V-WALK-AROUND ()
	 <TELL "(Do you have any particular direction in mind?)" CR>
	 <RFALSE>>

<ROUTINE V-WALK-TO ()
	 <COND (,PRSO
		<COND (<EQUAL? ,PRSO ,INTDIR>
		       <DO-WALK ,P-DIRECTION>
		       <RTRUE>)
		      (T
		       <V-FOLLOW>)>)
	       (T
		<V-WALK-AROUND>)>>

; <ROUTINE V-WALK-TO ()
	 <COND (<AND ,PRSO <OR <IN? ,PRSO ,HERE>
		               <GLOBAL-IN? ,PRSO ,HERE>>>
		<TELL "It's right here in front of you!" CR>)
	       (T
		<V-WALK-AROUND>)>>

<ROUTINE V-WAIT ("OPTIONAL" (NUM 3))
	 <TELL "Time passes." CR>
	 <REPEAT ()
		 <COND (<L? <SET NUM <- .NUM 1>> 0>
			<RETURN>)
		       (<CLOCKER>
			<RETURN>)>>
	 <SETG CLOCK-WAIT T>>

<ROUTINE V-WAIT-FOR ()
	 <COND (<EQUAL? <LOC ,PRSO> ,HERE ,WINNER>
		<BUT-THE ,PRSO>
		<TELL "is already here!">)
	       (T
		<TELL "You may be waiting quite a while.">)>
	 <CRLF>>

; <ROUTINE V-WAVE ()
	 <HACK-HACK "Waving">>

<ROUTINE V-WEAR ()
	 <COND (<AND <IN? ,PRSO ,PROTAGONIST>
		     <FSET? ,PRSO ,WORNBIT>>
		<TELL "You're already wearing ">)
	       (<NOT <FSET? ,PRSO ,WEARBIT>>
		<TELL ,CANT " wear ">)
	       (<DONT-HAVE? ,PRSO>
		<RTRUE>)
	       (<AND <EQUAL? ,PRSO ,COAT>
		     ,CHAINED?>
		<TELL ,CANT " do that">
		<WHILE-CHAINED>
		<RTRUE>)
	       (<EQUAL? ,PRSO ,GLASSES>
		<COND (<AND <NOT <EQUAL? ,HERE ,CIRCULATION-DESK ,MUSEUM>>
		            <OR ,ECLIPSE?
			        <NOT <FSET? ,HERE ,ONBIT>>>>
		       <TELL "It's dim enough here already without the " 
		             D ,GLASSES "!" CR>
		       <RTRUE>)>
	        <FSET ,GLASSES ,WORNBIT>
	        <SETG FUZZY-FROM ,HERE>
	        <COND (,ENDING?
		       <NOTHING-EXCITING>)
		      (<EQUAL? ,HERE ,INSIDE-THEATER>
		       <COND (<AND <NOT ,ECLIPSE?>
			           <ENABLED? ,I-FILM>>
		              <SETG MOVIE-VISIBLE? T>
		              <WOW "picture on the screen">)
		             (T
		              <NOTHING-EXCITING>)>)
	              (<EQUAL? ,HERE ,FUZZY>
		       <SETG FUZZY? <>>
		       <MOVE ,PROTAGONIST ,LABORATORY>
		       <SETG HERE ,LABORATORY>
		       <WOW "room">
		       <CRLF>
		       <V-LOOK>)
	              (T
		       <SETG FUZZY? T>
		       <SETG HERE ,FUZZY>
		       <MOVE ,PROTAGONIST ,FUZZY>
		       <TELL ,OKAY "you're now wearing the " 
			     D ,GLASSES "." CR CR>
		       <V-LOOK>
		       <COND (<IN? ,EVIL-ONE ,FUZZY-FROM>
		              <THIS-IS-IT ,EVIL-ONE>
		              <TELL CR  
"The only solid thing you can see is the " D ,OLD-WOMAN "...">
		              <DARK-BEING>
		              <CRLF>)>)>
		<RTRUE>)
	       (T
		<FSET ,PRSO ,WORNBIT>
		<TELL ,OKAY "you're now wearing ">)>
	 <ARTICLE ,PRSO T>
	 <TELL D, PRSO "." CR>>

<ROUTINE WOW (STR)
	 <TELL "Wow! As you put on the glasses the " .STR
	       " fuses into a solid, 3-dimensional image." CR>>

<ROUTINE PRE-WISH ()
	 <COND (,PRSI
		<COND (<FSET? ,PRSI ,WISHBIT>
		       <CONSULT-PACKAGE>
		       <RTRUE>)
		      (<NOT <EQUAL? ,PRSI ,WISHBRINGER>>
		       <NOT-LIKELY ,PRSI "would make your dreams come true">
		       <RTRUE>)>)
	       
	       (<NOT <FSET? ,PRSO ,WISHBIT>>
		<CONSULT-PACKAGE>
		<RTRUE>)
		
	       (<NOT <IN? ,WISHBRINGER ,PROTAGONIST>>
		<TELL "You must be holding " ,GAME 
		      " in " D ,HANDS " to make a Wish." CR>
		<RTRUE>)

               (<NOT <FSET? ,WISHBRINGER ,ONBIT>>
		<TELL "It seems that " ,GAME 
		      " isn't glowing anymore." CR>
		<RTRUE>)

	       (<FSET? ,PRSO ,TOUCHBIT>
	        <TELL "You've already used that Wish." CR>
		<RTRUE>)
	       
	       (<AND ,FUZZY?
		     <NOT <EQUAL? ,PRSO ,FORESIGHT>>>
		<TELL "You'd better get out of this " <PICK-ONE ,BLURS>
		      " place first!" CR>
		<RTRUE>)
	       
	       (,ECLIPSE?
		<DARK-IS-POWERFUL>
		<RTRUE>)
	       
	     ; (<FSET? ,DRAWBRIDGE ,OPENBIT>
		<FCLEAR ,DRAWBRIDGE ,OPENBIT>
	        <COND (<EQUAL? ,HERE ,HILLTOP ,VESTIBULE>
		       <SAY-THE ,DRAWBRIDGE>
		       <TELL " closes as you speak your Wish." CR CR>)>
		<RFALSE>)
	       
	       (T
		<RFALSE>)>>

<ROUTINE DARK-IS-POWERFUL ()
	 <TELL D ,DARKNESS " is a powerful Wish. You'll have to wait for it to wear off before you can use more Magick." CR>>

<ROUTINE V-WISH ()
	 <HOW?>>

; <ROUTINE V-WHAT ("AUX" ACTOR)
	 <COND (<SPEAKING-TO-SOMEONE-ABOUT? ,PRSO>
		<RTRUE>)
	       (T
		<Q-CHASTISE>)>>


; <ROUTINE V-WHAT-ABOUT ("AUX" ACTOR)
	 <COND (<SPEAKING-TO-SOMEONE-ABOUT? ,PRSO>
		<RTRUE>)
	       (T
		<TELL "(Well, what about it?)" CR>)>>

; <ROUTINE V-WHERE ()
	 <V-FIND T>>

; <ROUTINE V-WHO ()
	 <COND (<NOT <FSET? ,PRSO ,ACTORBIT>>
		<TELL ,I-ASSUME " WHAT is ">
		<ARTICLE ,PRSO T>
		<TELL D ,PRSO ".)" CR>)>
	 <PERFORM ,V?WHAT ,PRSO>
	 <RTRUE>>

; <ROUTINE V-WHY ("AUX" ACTOR)
	 <COND (<SPEAKING-TO-SOMEONE-ABOUT? ,PRSO>
		<RTRUE>)>
	 <TELL "(">
	 <COND (<PROB 50>
		<TELL "Why not?">)
	       (T
		<TELL "Because.">)>
	 <TELL ")">
	 <CRLF>>

; <ROUTINE SPEAKING-TO-SOMEONE-ABOUT? (OBJ "AUX" ACTOR)
	 <COND (<SET ACTOR <ANYONE-HERE?>>
		<TELL "(spoken to ">
		<ARTICLE .ACTOR T>
		<TELL D .ACTOR ")" CR>
		<PERFORM ,V?ASK-ABOUT .ACTOR .OBJ>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE PRE-TAKE ("OPTIONAL" CONTAINER)
	 <SET CONTAINER <LOC ,PRSO>>
	 <COND (<IN? ,PRSO ,WINNER>
		<TELL "You're already ">
		<COND (<FSET? ,PRSO ,WORNBIT>
		       <TELL "wear">)
		      (T
		       <TELL "hold">)>
		<TELL "ing it." CR>
		<RTRUE>)
	       (<AND .CONTAINER
		     <FSET? .CONTAINER ,CONTBIT>
		     <NOT <FSET? .CONTAINER ,OPENBIT>>>
		<TELL ,CANT " reach into ">
		<ARTICLE .CONTAINER T>
		<TELL D .CONTAINER ". It's closed." CR>
		<RTRUE>)
	       (,PRSI
		<COND (<EQUAL? ,PRSO ,ME>
		       <PERFORM ,V?DROP ,PRSI>
		       <RTRUE>)
		      (<EQUAL? ,PRSI ,GRAVE>
		       <PERFORM ,V?TAKE ,PRSO>
		       <RTRUE>)
		      (<NOT <IN? ,PRSO ,PRSI>>
		       <COND (<FSET? ,PRSI ,ACTORBIT>
			      <BUT-THE ,PRSI>
			      <TELL "doesn't have ">
			      <ARTICLE ,PRSO>
			      <PRINTD ,PRSO>)
			     (T
			      <BUT-THE ,PRSO>
			      <TELL "isn't in ">
			      <ARTICLE ,PRSI T>
			      <PRINTD ,PRSI>)>
		       <TELL "." CR>
		       <RTRUE>)
		      (T
		     ; <SETG PRSI <>>
		       <RFALSE>)>
		<RTRUE>)
	       (<EQUAL? ,PRSO <LOC ,WINNER>>
		<TELL "You're in it!" CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE V-TAKE ("AUX" CNT)
	 <COND (<ITAKE>
		<TELL "Taken." CR>
		<SET CNT <GETP ,PRSO ,P?VALUE>> 
		<COND (<G? .CNT 0>
		       <CRLF>
		       <UPDATE-SCORE .CNT>
		       <PUTP ,PRSO ,P?VALUE 0>)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE ITAKE ("OPTIONAL" (VB T) "AUX" CNT OBJ)
	 <THIS-IS-IT ,PRSO>
	 <COND (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<COND (.VB
		       <TELL <PICK-ONE ,YUKS> CR>)>
		<RFALSE>)
	       (<FSET? ,PRSO ,THROWNBIT>
		<COND (.VB
		       <TELL ,CANT 
". " D ,CRISP " dropped it out of your reach." CR>)>
		<RFALSE>)
	       
	       (<AND <EQUAL? ,HERE ,OUTSIDE-COTTAGE>
		     <NOT ,HELLHOUND-HAPPY?>
		     <OR <IN? ,PRSO ,HERE>
			 <IN? <LOC ,PRSO> ,HERE>>>
		<SAY-THE ,POOCH>
		<TELL " won't let you pick it up!" CR>
		<RFALSE>)
	       (<TOO-MUCH-JUNK? .VB>
		<RFALSE>)
	       (T
	      	<MOVE ,PRSO ,WINNER>
		<FSET ,PRSO ,TOUCHBIT>
		<FCLEAR ,PRSO ,NDESCBIT>
		<RTRUE>)>>

<CONSTANT FUMBLE-NUMBER 8>
<CONSTANT LOAD-ALLOWED 35>

<ROUTINE TOO-MUCH-JUNK? ("OPTIONAL" (VB T))
         <COND (<AND <NOT <IN? <LOC ,PRSO> ,WINNER>>
		     <G? <+ <WEIGHT ,PRSO> <WEIGHT ,WINNER>> ,LOAD-ALLOWED>>
	        <COND (.VB
		       <COND (<FIRST? ,PROTAGONIST>
			      <TELL "Your load is">)
			     (T
			      <TELL "It's a little">)>
		       <TELL " too heavy." CR>)>
		<RTRUE>)
	       (<G? <CCOUNT ,WINNER> ,FUMBLE-NUMBER>
		<COND (.VB
		       <TELL "You're holding too many things already!" CR>)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

; "Count # objects being carried by THING"

<ROUTINE CCOUNT (THING "AUX" OBJ (CNT 0))
	 <SET OBJ <FIRST? .THING>>
	 <REPEAT ()
		 <COND (.OBJ
			<COND (<NOT <FSET? .OBJ ,WORNBIT>>
			       <SET CNT <+ .CNT 1>>)>
			<SET OBJ <NEXT? .OBJ>>)
		       (T
			<RETURN>)>>
	 <RETURN .CNT>>

; "Return total weight of objects in THING"

<ROUTINE WEIGHT (THING "AUX" OBJ (WT 0))
	 <SET OBJ <FIRST? .THING>>
	 <REPEAT ()
		 <COND (.OBJ
			<COND (<AND <EQUAL? .THING ,PROTAGONIST>
				    <FSET? .OBJ ,WORNBIT>>
			       <SET WT <+ .WT 1>>)
			      (T
			       <SET WT <+ .WT <WEIGHT .OBJ>>>)>
			<SET OBJ <NEXT? .OBJ>>)
		       (T
			<RETURN>)>>
	 <SET WT <+ .WT <GETP .THING ,P?SIZE>>>
	 <RETURN .WT>>

<GLOBAL FIRST-WARNING? T>

<ROUTINE DESCRIBE-ROOM ("OPTIONAL" (LOOK? <>) "AUX" V? STR)
	 <SET V? <OR .LOOK? ,VERBOSE>>
	 <COND (,LIT
		<SETG FIRST-WARNING? T>)
	       (T
		<NOW-BLACK>
		<COND (<AND <NOT ,ECLIPSE?>
			    <OR ,FIRST-WARNING?
			        <PROB 50>>>
		       <TELL " You are likely to be eaten by a grue.">
		       <SETG FIRST-WARNING? <>>)>
		<CRLF>
		<RFALSE>)>
	 <COND (<NOT <FSET? ,HERE ,TOUCHBIT>>
		<FSET ,HERE ,TOUCHBIT>
		<SET V? T>)>
	 <COND (<IN? ,HERE ,ROOMS>
		<TELL D ,HERE CR>)>
	 <COND (<OR .LOOK?
		    <NOT ,SUPER-BRIEF>>
		<COND (<AND .V?
			    <APPLY <GETP ,HERE ,P?ACTION> ,M-LOOK>>
		       <RTRUE>)
		      (<AND .V?
			    <SET STR <GETP ,HERE ,P?LDESC>>>
		       <TELL .STR CR>)
		      (T
		       <APPLY <GETP ,HERE ,P?ACTION> ,M-FLASH>)>)>
	 T>

<CONSTANT REXIT 0>
<CONSTANT UEXIT 1>
<CONSTANT NEXIT 2>
<CONSTANT FEXIT 3>
<CONSTANT CEXIT 4>
<CONSTANT DEXIT 5>
<CONSTANT NEXITSTR 0>
<CONSTANT FEXITFCN 0>
<CONSTANT CEXITFLAG 1>
<CONSTANT CEXITSTR 1>
<CONSTANT DEXITOBJ 1>
<CONSTANT DEXITSTR 1>

<ROUTINE GOTO (RM "OPTIONAL" (V? T) "AUX" OLIT OHERE)
	 <SET OHERE ,HERE>
	 <SET OLIT ,LIT>
	 <MOVE ,WINNER .RM>
	 <SETG HERE .RM>
	 <SETG LIT <LIT? ,HERE>>
	 <COND (<AND <NOT .OLIT>
		     <NOT ,LIT>
		     <NOT ,LUCKY?>
		     <NOT ,FIRST-WARNING?>
		     <NOT ,ECLIPSE?>
		     <PROB 50>>
		<TELL
"Oh, no! Something lurked out of the " D ,DARKNESS " and devoured you!">
		<BAD-ENDING>)>
	 <APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER>
	 <COND (<NOT <EQUAL? ,HERE .RM>>
		<RTRUE>)
	       (.V?
		<V-FIRST-LOOK>)>
	 <RTRUE>>

<ROUTINE OTHER-SIDE (DOBJ "AUX" (P 0) T) 
	 <REPEAT ()
		 <COND (<L? <SET P <NEXTP ,HERE .P>> ,LOW-DIRECTION>
			<RETURN <>>)
		       (T
			<SET T <GETPT ,HERE .P>>
			<COND (<AND <EQUAL? <PTSIZE .T> ,DEXIT>
				    <EQUAL? <GETB .T ,DEXITOBJ> .DOBJ>>
			       <RETURN .P>)>)>>>

<ROUTINE HACK-HACK (STR)
	 <TELL .STR " ">
	 <ARTICLE ,PRSO T>
	 <TELL D ,PRSO " " <PICK-ONE ,HO-HUM> "." CR>>

<GLOBAL HO-HUM
	<LTABLE 0 
	 "doesn't do anything"
	 "accomplishes nothing"
	 "has no effect">>		 

<GLOBAL YUKS
	<LTABLE 0 
	 "That's impossible."
	 "You can't be serious."
	 "Don't be silly.">>

<ROUTINE TOO-DARK ()
	 <TELL "It's too dark to see!" CR>>

<ROUTINE CANT-GO ()
	 <COND (<FSET? ,HERE ,INDOORSBIT>
		<TELL "There's no exit">)
	       (T
		<TELL ,CANT " go">)>
	 <TELL " that way." CR>>

<ROUTINE NOW-BLACK ()
	 <TELL "It is pitch black.">>

<ROUTINE ALREADY-OPEN ()
	 <ITS-ALREADY "open">>

<ROUTINE ALREADY-CLOSED ()
	 <ITS-ALREADY "closed">>

<ROUTINE ITS-ALREADY (STR)
	 <TELL "It's already " .STR "." CR>>

<ROUTINE REFERRING ()
	 <TELL "(Please be more specific.)" CR>>

<ROUTINE WASTE-OF-TIME ()
	 <TELL "That would be a " <PICK-ONE ,USELESSNESS> "." CR>>

<GLOBAL USELESSNESS
	<LTABLE 0
	 "waste of time"
	 "useless effort"
	 "pointless thing to do">>


