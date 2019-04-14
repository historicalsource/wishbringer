"PARSER for WISHBRINGER: (C)1985 Infocom, Inc. All rights reserved."

<SETG SIBREAKS ".,\"!?">

<GLOBAL PRSA 0>
<GLOBAL PRSI 0>
<GLOBAL PRSO 0>
<GLOBAL P-TABLE 0>  
<GLOBAL P-ONEOBJ 0> 
<GLOBAL P-SYNTAX 0> 
<GLOBAL P-LEN 0>    
<GLOBAL P-DIR 0>    
<GLOBAL LAST-PLAYER-LOC 0>
<GLOBAL WINNER 0>   
<GLOBAL P-LEXV <ITABLE BYTE 120>>

<GLOBAL LAST-PSEUDO-LOC <>>
<GLOBAL ITAKE-LOC <>>

"INBUF - Input buffer for READ"

<GLOBAL P-INBUF <ITABLE BYTE 100>>

"Parse-cont variable"

<GLOBAL P-CONT <>>  

<GLOBAL P-IT-OBJECT <>>
<GLOBAL P-HER-OBJECT <>>
<GLOBAL P-HIM-OBJECT <>>
<GLOBAL P-THEM-OBJECT <>>

"Orphan flag"

<GLOBAL P-OFLAG <>> 

<GLOBAL P-MERGED <>>
<GLOBAL P-ACLAUSE <>>    
<GLOBAL P-ANAM <>>  
<GLOBAL P-AADJ <>>

"Parser variables and temporaries"

;<CONSTANT P-PHRLEN 3>
;<CONSTANT P-ORPHLEN 7>
;<CONSTANT P-RTLEN 3>

"Byte offset to # of entries in LEXV"

<CONSTANT P-LEXWORDS 1>

"Word offset to start of LEXV entries"

<CONSTANT P-LEXSTART 1>

"Number of words per LEXV entry"

<CONSTANT P-LEXELEN 2>   
<CONSTANT P-WORDLEN 4>

"Offset to parts of speech byte"

<CONSTANT P-PSOFF 4>

"Offset to first part of speech"

<CONSTANT P-P1OFF 5>

"First part of speech bit mask in PSOFF byte"

<CONSTANT P-P1BITS 3>    
<CONSTANT P-ITBLLEN 9>   

<GLOBAL P-ITBL <TABLE 0 0 0 0 0 0 0 0 0 0>>  
<GLOBAL P-OTBL <TABLE 0 0 0 0 0 0 0 0 0 0>>  
<GLOBAL P-VTBL <TABLE 0 0 0 0>>
<GLOBAL P-OVTBL <TABLE 0 0 0 0>>
<GLOBAL P-NCN 0>    

<CONSTANT P-VERB 0> 
<CONSTANT P-VERBN 1>
<CONSTANT P-PREP1 2>
<CONSTANT P-PREP1N 3>    
<CONSTANT P-PREP2 4>

;<CONSTANT P-PREP2N 5>    

<CONSTANT P-NC1 6>  
<CONSTANT P-NC1L 7> 
<CONSTANT P-NC2 8>  
<CONSTANT P-NC2L 9> 

<GLOBAL QUOTE-FLAG <>>
<GLOBAL P-ADVERB <>>

;<GLOBAL P-WHAT-IGNORED <>>

<GLOBAL P-WON <>>
<CONSTANT M-FATAL 2>

;<CONSTANT M-HANDLED 1>   
;<CONSTANT M-NOT-HANDLED <>>   

<CONSTANT M-BEG 1>  
<CONSTANT M-ENTER 2>
<CONSTANT M-LOOK 3> 
<CONSTANT M-FLASH 4>
<CONSTANT M-OBJDESC 5>
<CONSTANT M-END 6> 
<CONSTANT M-CONT 7> 
<CONSTANT M-WINNER 8>

<GLOBAL L-PRSA <>>
<GLOBAL L-PRSO <>>
<GLOBAL L-PRSI <>>

;<GLOBAL L-PRSO-NOT-HERE <>>
;<GLOBAL L-PRSI-NOT-HERE <>>

<GLOBAL L-WINNER <>>
<GLOBAL BOTTOM? <>>
<GLOBAL P-WALK-DIR <>>

" Grovel down the input finding the verb, prepositions, and noun clauses.
   If the input is <direction> or <walk> <direction>, fall out immediately
   setting PRSA to ,V?WALK and PRSO to <direction>.  Otherwise, perform
   all required orphaning, syntax checking, and noun clause lookup."

<ROUTINE PARSER ("AUX" (PTR ,P-LEXSTART) WRD (VAL 0) (VERB <>) (BOTTOM <>)
		       LEN (DIR <>) (NW 0) (LW 0) NUM SCNT (CNT -1) OWINNER
		       (OF-FLAG <>)) 
	<REPEAT ()
		<COND (<G? <SET CNT <+ .CNT 1>> ,P-ITBLLEN> <RETURN>)
		      (T <PUT ,P-ITBL .CNT 0>)>>
	<SETG P-NUMBER -1>
	<SETG P-NAM <>>
	<SETG P-ADJ <>>
	<SETG P-ADVERB <>>
	<SETG P-MERGED <>>
	;<SETG P-WHAT-IGNORED <>>
	<PUT ,P-PRSO ,P-MATCHLEN 0>
	<PUT ,P-PRSI ,P-MATCHLEN 0>
	<PUT ,P-BUTS ,P-MATCHLEN 0>
	<SET OWINNER ,WINNER>
	<COND (<AND <NOT ,QUOTE-FLAG>
		    <NOT <EQUAL? ,WINNER ,PROTAGONIST>>>
	       <SETG L-WINNER ,WINNER>
	       <SETG WINNER ,PROTAGONIST>
	       <SETG LAST-PLAYER-LOC ,HERE>
	       <SETG HERE <LOC ,WINNER>>
	       <SETG LIT <LIT? ,HERE>>)>
	<COND (<NOT <ZERO? ,P-CONT>>
	       <SET PTR ,P-CONT>
	       <SETG P-CONT <>>
	       <COND (,SAYING?
		      <SETG SAYING? <>>)
		     (<AND <NOT ,SUPER-BRIEF>
			   <EQUAL? ,PROTAGONIST ,WINNER>>
		      <CRLF>)>
	     ; <COND (<NOT <VERB? ASK TELL SAY>>
		      <CRLF>)>)
	      (T
	       <SETG SAYING? <>>
	       <SETG L-WINNER ,WINNER>
	       <SETG WINNER ,PROTAGONIST>
	       <SETG QUOTE-FLAG <>>
	       <SETG LAST-PLAYER-LOC ,HERE>
	       <SETG HERE <LOC ,WINNER>>
	       <SETG LIT <LIT? ,HERE>>
	       <COND (<NOT ,SUPER-BRIEF>
		      <CRLF>)>
	       <COND (<AND ,P-PROMPT
			   <NOT ,P-OFLAG>>
		      <COND (<EQUAL? ,P-PROMPT 2>
			     <TELL ,OKAY "what do you want to do now?">)
			    (T
			     <TELL "What next?">)>
		      <CRLF>)>
	       <PUTB ,P-LEXV 0 59>
	       <TELL ">">
	       <READ ,P-INBUF ,P-LEXV>)>
	<SETG P-LEN <GETB ,P-LEXV ,P-LEXWORDS>>
	<COND (<EQUAL? <GET ,P-LEXV .PTR> ,W?QUOTE> ; "Quote 1st token?"
	       <SET PTR <+ .PTR ,P-LEXELEN>>	;"If so, ignore it."
	       <SETG P-LEN <- ,P-LEN 1>>)>
	<COND (<EQUAL? ,W?THEN <GET ,P-LEXV .PTR>>	;"Is THEN first input word?"
	       <SET PTR <+ .PTR ,P-LEXELEN>>	;"If so, ignore it."
	       <SETG P-LEN <- ,P-LEN 1>>)>
	<COND (<AND <L? 1 ,P-LEN>
		    <EQUAL? ,W?GO <GET ,P-LEXV .PTR>> ;"Is GO first input word?"
		    <SET NW <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>>
		    <WT? .NW ,PS?VERB ,P1?VERB>	;" followed by verb?">
	       <SET PTR <+ .PTR ,P-LEXELEN>>	;"If so, ignore it."
	       <SETG P-LEN <- ,P-LEN 1>>)>
	<COND (<ZERO? ,P-LEN>
	       <TELL "Beg pardon?" CR>
	       <RFALSE>)>
	<SET LEN ,P-LEN>
	<SETG P-DIR <>>
	<SETG P-NCN 0>
	<SETG P-GETFLAGS 0>
	<SET BOTTOM <>>
	;"3/25/83: Next statement added."
	<PUT ,P-ITBL ,P-VERBN 0>
	<REPEAT ()
		<COND (<L? <SETG P-LEN <- ,P-LEN 1>> 0>
		       <SETG QUOTE-FLAG <>>
		       <RETURN>)
		      (<BUZZER-WORD? <SET WRD <GET ,P-LEXV .PTR>>>
		       <RFALSE>)
		      (<OR .WRD
			   <SET WRD <NUMBER? .PTR>>
			   ;<SET WRD <NAME? .PTR>>>
		       <COND (<AND <EQUAL? .WRD ,W?TO>
				   <EQUAL? .VERB ,ACT?TELL ,ACT?ASK>>
			      <SET VERB ,ACT?TELL>
			      <SET WRD ,W?QUOTE>)
			     (<AND <EQUAL? .WRD ,W?THEN>
				   <NOT .VERB>
				   <NOT ,QUOTE-FLAG> ;"Last NOT added 7/3">
			      <PUT ,P-ITBL ,P-VERB ,ACT?TELL>
			      <PUT ,P-ITBL ,P-VERBN 0>
			      <SET WRD ,W?QUOTE>)>
		       <COND (<AND <EQUAL? .WRD ,W?PERIOD>
				   <EQUAL? .LW  ,W?MR ,W?MS ,W?SGT>>
			      <SET LW 0>)
			     (<EQUAL? .WRD ,W?THEN ,W?PERIOD ,W?QUOTE> 
			      <COND (<EQUAL? .WRD ,W?QUOTE>
				     <COND (,QUOTE-FLAG
					    <SETG QUOTE-FLAG <>>)
					   (T
					    <SETG QUOTE-FLAG T>)>)>
			      <OR <ZERO? ,P-LEN>
				  <SETG P-CONT <+ .PTR ,P-LEXELEN>>>
			      <PUTB ,P-LEXV ,P-LEXWORDS ,P-LEN>
			      <RETURN>)
			     (<AND <SET VAL
					<WT? .WRD
					     ,PS?DIRECTION
					     ,P1?DIRECTION>>
				   <EQUAL? .VERB <> ,ACT?WALK>
				   <OR <EQUAL? .LEN 1>
				       <AND <EQUAL? .LEN 2>
					   <EQUAL? .VERB ,ACT?WALK>>
				       <AND <EQUAL? <SET NW
						     <GET ,P-LEXV
							 <+ .PTR ,P-LEXELEN>>>
					            ,W?THEN
					            ,W?PERIOD
						    ,W?QUOTE>
					    <G? .LEN 1 ;2>>
				     ; <AND <EQUAL? .NW ,W?PERIOD>
					    <G? .LEN 1>>
				       <AND ,QUOTE-FLAG
					    <EQUAL? .LEN 2>
					    <EQUAL? .NW ,W?QUOTE>>
				       <AND <G? .LEN 2>
					    <EQUAL? .NW ,W?COMMA ,W?AND>>>>
			      <SET DIR .VAL>
			      <COND (<EQUAL? .NW ,W?COMMA ,W?AND>
				     <PUT ,P-LEXV
					  <+ .PTR ,P-LEXELEN>
					  ,W?THEN>)>
			      <COND (<NOT <G? .LEN 2>>
				     <SETG QUOTE-FLAG <>>
				     <RETURN>)>)
			     (<AND <SET VAL <WT? .WRD ,PS?VERB ,P1?VERB>>
				   <NOT .VERB>
				   ;<OR <NOT .VERB>
				       <EQUAL? .VERB ,ACT?WHAT>>>
			    ; <COND (<EQUAL? .VERB ,ACT?WHAT>
				     <SETG P-WHAT-IGNORED T>)>
			      <SET VERB .VAL>
			      <PUT ,P-ITBL ,P-VERB .VAL>
			      <PUT ,P-ITBL ,P-VERBN ,P-VTBL>
			      <PUT ,P-VTBL 0 .WRD>
			      <PUTB ,P-VTBL 2 <GETB ,P-LEXV
						    <SET NUM
							 <+ <* .PTR 2> 2>>>>
			      <PUTB ,P-VTBL 3 <GETB ,P-LEXV <+ .NUM 1>>>)
			     (<OR <SET VAL <WT? .WRD ,PS?PREPOSITION 0>>
				  <AND <OR <EQUAL? .WRD ; ,W?ONE ,W?A>
					   <EQUAL? .WRD ,W?BOTH ,W?ALL
						        ,W?EVERYTHING>
					   <WT? .WRD ,PS?ADJECTIVE>
					   <WT? .WRD ,PS?OBJECT>>
				       <SET VAL 0>>>
			      <COND (<AND <G? ,P-LEN 1> ; "1 IN RETROFIX #34"
					  <EQUAL? <GET ,P-LEXV
						    <+ .PTR ,P-LEXELEN>>
					       ,W?OF>
					  <NOT <EQUAL? .VERB
						       ;,ACT?MAKE ,ACT?TAKE>>
					  <ZERO? .VAL>
					  <NOT <EQUAL? .WRD ; ,W?ONE ,W?A>>
					  <NOT <EQUAL? .WRD ,W?ALL ,W?BOTH
						            ,W?EVERYTHING>>>
				     <COND (<EQUAL? .WRD ,W?BOTTOM>
					    <SET BOTTOM T>)>
				     <SET OF-FLAG T>)
				    (<AND <NOT <ZERO? .VAL>>
				          <OR <ZERO? ,P-LEN>
					      <EQUAL? <GET ,P-LEXV <+ .PTR 2>>
						      ,W?THEN ,W?PERIOD>>>
				     <COND (<L? ,P-NCN 2>
					    <PUT ,P-ITBL ,P-PREP1 .VAL>
					    <PUT ,P-ITBL ,P-PREP1N .WRD>)>)
				    (<EQUAL? ,P-NCN 2>
				     <TELL
"(There are too many nouns in that sentence!)" CR>
				     <RFALSE>)
				    (T
				     <SETG P-NCN <+ ,P-NCN 1>>
				     <OR <SET PTR <CLAUSE .PTR .VAL .WRD>>
					 <RFALSE>>
				     <COND (<L? .PTR 0>
					    <SETG QUOTE-FLAG <>>
					    <RETURN>)>)>)
			     ;(<EQUAL? .WRD ,W?CLOSELY>
			      <SETG P-ADVERB ,W?CAREFULLY>)
			     ;(<OR <EQUAL? .WRD
					 ,W?CAREFULLY ,W?QUIETLY ,W?PRIVATELY>
				  <EQUAL? .WRD
					  ,W?SLOWLY ,W?QUICKLY ,W?BRIEFLY>>
			      <SETG P-ADVERB .WRD>)
			     (<EQUAL? .WRD ,W?OF> ; "RETROFIX #34"
			      <COND (<OR <NOT .OF-FLAG>
					 <EQUAL?
			     		  <GET ,P-LEXV <+ .PTR ,P-LEXELEN>> 
			     		  ,W?PERIOD ,W?THEN>>
				     <CANT-USE .PTR>
				     <RFALSE>)
				    (T
				     <SET OF-FLAG <>>)>)
			     (<WT? .WRD ,PS?BUZZ-WORD>)
			     (<AND <EQUAL? .VERB ,ACT?TELL>
				   <WT? .WRD ,PS?VERB ,P1?VERB>>
			      <WAY-TO-TALK>
			      <RFALSE>)
			     (T
			      <CANT-USE .PTR>
			      <RFALSE>)>)
		      (T
		       <UNKNOWN-WORD .PTR>
		       <RFALSE>)>
		<SET LW .WRD>
		<SET PTR <+ .PTR ,P-LEXELEN>>>
	<COND (.DIR
	       <SETG PRSA ,V?WALK>
	       <SETG P-WALK-DIR .DIR>
	       <SETG PRSO .DIR>
	       <SETG P-OFLAG <>>
	       <RTRUE>)>
	<SETG P-WALK-DIR <>>
	<COND (<AND ,P-OFLAG
		    <ORPHAN-MERGE>>
	       <SETG WINNER .OWINNER>)
	      (T
	       <SETG BOTTOM? .BOTTOM>)>
	;<COND (<EQUAL? <GET ,P-ITBL ,P-VERB> 0>
	       <PUT ,P-ITBL ,P-VERB ,ACT?$CALL>)>
	<COND (<AND <SYNTAX-CHECK>
		    <SNARF-OBJECTS>
		    <MANY-CHECK>
		    <TAKE-CHECK>>
	       T)>>

<ROUTINE WAY-TO-TALK ()
	 <REFER-TO-MANUAL>
	 <TELL
" for the correct way to talk to characters.)" CR>>

"Check whether word pointed at by PTR is the correct part of speech.
   The second argument is the part of speech (,PS?<part of speech>).  The
   3rd argument (,P1?<part of speech>), if given, causes the value
   for that part of speech to be returned."
 
<ROUTINE WT? (PTR BIT "OPTIONAL" (B1 5) "AUX" (OFFS ,P-P1OFF) TYP) 
	<COND (<BTST <SET TYP <GETB .PTR ,P-PSOFF>> .BIT>
	       <COND (<G? .B1 4> <RTRUE>)
		     (T
		      <SET TYP <BAND .TYP ,P-P1BITS>>
		      <COND (<NOT <EQUAL? .TYP .B1>> <SET OFFS <+ .OFFS 1>>)>
		      <GETB .PTR .OFFS>)>)>>

"Scan through a noun phrase, leaving a pointer to its starting location:"

<ROUTINE CLAUSE (PTR VAL WRD "AUX" OFF NUM (ANDFLG <>) (FIRST?? T) NW (LW 0))
	<SET OFF <* <- ,P-NCN 1> 2>>
	<COND (<NOT <EQUAL? .VAL 0>>
	       <PUT ,P-ITBL <SET NUM <+ ,P-PREP1 .OFF>> .VAL>
	       <PUT ,P-ITBL <+ .NUM 1> .WRD>
	       <SET PTR <+ .PTR ,P-LEXELEN>>)
	      (T <SETG P-LEN <+ ,P-LEN 1>>)>
	<COND (<ZERO? ,P-LEN> <SETG P-NCN <- ,P-NCN 1>> <RETURN -1>)>
	<PUT ,P-ITBL <SET NUM <+ ,P-NC1 .OFF>> <REST ,P-LEXV <* .PTR 2>>>
	<COND (<EQUAL? <GET ,P-LEXV .PTR> ,W?THE ,W?A ,W?AN>
	       <PUT ,P-ITBL .NUM <REST <GET ,P-ITBL .NUM> 4>>)>
	<REPEAT ()
		<COND (<L? <SETG P-LEN <- ,P-LEN 1>> 0>
		       <PUT ,P-ITBL <+ .NUM 1> <REST ,P-LEXV <* .PTR 2>>>
		       <RETURN -1>)>
		<COND (<BUZZER-WORD? <SET WRD <GET ,P-LEXV .PTR>>>
		       <RFALSE>)
		      (<OR .WRD
			   <SET WRD <NUMBER? .PTR>>
			   ;<SET WRD <NAME? .PTR>>>
		       <COND (<ZERO? ,P-LEN> <SET NW 0>)
			     (T <SET NW <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>>)>
		       ;<COND (<AND <EQUAL? .WRD ,W?OF>
				   <EQUAL? <GET ,P-ITBL ,P-VERB>
					   ,ACT?MAKE ,ACT?TAKE>>
			      <PUT ,P-LEXV .PTR ,W?WITH>
			      <SET WRD ,W?WITH>)>
		       <COND (<AND <EQUAL? .WRD ,W?PERIOD>
				   <EQUAL? .LW ,W?MR ,W?MS ,W?SGT>>
			      <SET LW 0>)
			     (<EQUAL? .WRD ,W?AND ,W?COMMA>
			      <SET ANDFLG T>)
			     (<EQUAL? .WRD ,W?ALL ,W?BOTH ,W?EVERYTHING>
			    ; <OR <EQUAL? .WRD ,W?ALL ,W?BOTH ,W?ONE>
				  <EQUAL? .WRD ,W?EVERYTHING>>
			      <COND (<EQUAL? .NW ,W?OF>
				     <SETG P-LEN <- ,P-LEN 1>>
				     <SET PTR <+ .PTR ,P-LEXELEN>>)>)
			     (<OR <EQUAL? .WRD ,W?THEN ,W?PERIOD>
				  <AND <WT? .WRD ,PS?PREPOSITION>
				       <GET ,P-ITBL ,P-VERB>
				       <NOT .FIRST??>>>
			      <SETG P-LEN <+ ,P-LEN 1>>
			      <PUT ,P-ITBL
				   <+ .NUM 1>
				   <REST ,P-LEXV <* .PTR 2>>>
			      <RETURN <- .PTR ,P-LEXELEN>>)
			     ;"3/16/83: This clause used to be later."
			     (<AND .ANDFLG
				   <OR ;"3/25/83: next statement added."
				       <EQUAL? <GET ,P-ITBL ,P-VERBN> 0>
				       ;"10/26/84: next stmt changed"
				       <VERB-DIR-ONLY? .WRD>>>
			      <SET PTR <- .PTR 4>>
			      <PUT ,P-LEXV <+ .PTR 2> ,W?THEN>
			      <SETG P-LEN <+ ,P-LEN 2>>)
			     (<WT? .WRD ,PS?OBJECT>
			      <COND (<AND <G? ,P-LEN 0>
					  <EQUAL? .NW ,W?OF>
					  <NOT <EQUAL? .WRD ,W?ALL ; ,W?ONE
						            ,W?EVERYTHING>>>
				     T)
				    (<AND <WT? .WRD
					       ,PS?ADJECTIVE
					       ,P1?ADJECTIVE>
					  <NOT <EQUAL? .NW 0>>
					  <WT? .NW ,PS?OBJECT>>)
				    (<AND <NOT .ANDFLG>
					  <NOT <EQUAL? .NW ,W?BUT ,W?EXCEPT>>
					  <NOT <EQUAL? .NW ,W?AND ,W?COMMA>>>
				     <PUT ,P-ITBL
					  <+ .NUM 1>
					  <REST ,P-LEXV <* <+ .PTR 2> 2>>>
				     <RETURN .PTR>)
				    (T <SET ANDFLG <>>)>)
			     ;"Next clause replaced by following one to enable
			       OLD WOMAN, HELLO"
			     ;(<AND <OR ,P-MERGED
				       ,P-OFLAG
				       <NOT <EQUAL? <GET ,P-ITBL ,P-VERB> 0>>>
				   <OR <WT? .WRD ,PS?ADJECTIVE>
				       <WT? .WRD ,PS?BUZZ-WORD>>>)
			     (<OR <WT? .WRD ,PS?ADJECTIVE>
				  <WT? .WRD ,PS?BUZZ-WORD>>)
			     (<AND .ANDFLG
				   <EQUAL? <GET ,P-ITBL ,P-VERB> 0>>
			      <SET PTR <- .PTR 4>>
			      <PUT ,P-LEXV <+ .PTR 2> ,W?THEN>
			      <SETG P-LEN <+ ,P-LEN 2>>)
			     (<WT? .WRD ,PS?PREPOSITION> T)
			     (T
			      <CANT-USE .PTR>
			      <RFALSE>)>)
		      (T <UNKNOWN-WORD .PTR> <RFALSE>)>
		<SET LW .WRD>
		<SET FIRST?? <>>
		<SET PTR <+ .PTR ,P-LEXELEN>>>>

<ROUTINE THIS-IS-IT (OBJ)
         <COND (<OR <EQUAL? .OBJ <> ,PROTAGONIST ,NOT-HERE-OBJECT>
		    <EQUAL? .OBJ ,INTDIR>>
		<RTRUE>)
	       (<AND <EQUAL? ,PRSA ,V?WALK ,V?WALK-TO>
		     <EQUAL? .OBJ ,PRSO>>
		<RTRUE>)
	       (<OR <EQUAL? .OBJ ,CHAINS ,GLASSES ,BOOTS>
		    <EQUAL? .OBJ ,CROWD ,MONUMENTS ,HUMANOIDS>
		    <EQUAL? .OBJ ,VAPORS ,INSTRUMENTS ,SHARKS>>
		<SETG P-IT-OBJECT .OBJ>
		<SETG P-THEM-OBJECT .OBJ>)
	       (<EQUAL? .OBJ ,MISS-VOSS ,OLD-WOMAN ,EVIL-ONE>
	        <SETG P-HER-OBJECT .OBJ>)
               (<EQUAL? .OBJ ,KITTY ,CHAOS ,PRINCESS>
		<SETG P-IT-OBJECT .OBJ>
		<SETG P-HER-OBJECT .OBJ>)
	       (<EQUAL? .OBJ ,CRISP ,GRAVEDIGGER ,MACGUFFIN>
	        <SETG P-HIM-OBJECT .OBJ>)
	       (<OR <EQUAL? .OBJ ,TROLL ,KING ,VULTURE>
		    <EQUAL? .OBJ ,GOLDFISH ,PIRANHA ,HORSE>>
		<SETG P-IT-OBJECT .OBJ>
		<SETG P-HIM-OBJECT .OBJ>)
	       (T
		<SETG P-IT-OBJECT .OBJ>)>
	 <RTRUE>>  

<ROUTINE FAKE-ORPHAN ("AUX" TMP)
	 <ORPHAN ,P-SYNTAX <>>
	 <BE-SPECIFIC>
	 <SET TMP <GET ,P-OTBL ,P-VERBN>>
	 <COND (<EQUAL? .TMP 0>
		<TELL "tell">)
	       (<ZERO? <GETB ,P-VTBL 2>>
		<PRINTB <GET .TMP 0>>)
	       (T
		<WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>
		<PUTB ,P-VTBL 2 0>)>
	 <SETG P-OFLAG T>
	 <SETG P-WON <>>
	 <TELL "?)" CR>>

<ROUTINE SEE-VERB? ()
	 <COND (<OR <EQUAL? ,PRSA ,V?LOOK ,V?EXAMINE ,V?LOOK-INSIDE>
		    <EQUAL? ,PRSA ,V?SEARCH ,V?FIND ,V?LOOK-ON>
		    <EQUAL? ,PRSA ,V?LOOK-UNDER ,V?LOOK-BEHIND ,V?READ>
		    <EQUAL? ,PRSA ,V?LOOK-THRU ,V?LOOK-DOWN ,V?COUNT>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE PERFORM (A "OPTIONAL" (O <>) (I <>) "AUX" (V <>) OA OO OI) 
	<SET OA ,PRSA>
	<SET OO ,PRSO>
	<SET OI ,PRSI>
	<SETG PRSA .A>
	<COND (<AND <NOT ,LIT>
		    <SEE-VERB?>>
	       <TOO-DARK>
	       <RFATAL>)
	      (<AND ,IMMOBILIZED?
		    <NOT <SEE-VERB?>>
		    <NOT <GAME-VERB?>>
		    <NOT <EQUAL? ,PRSA ,V?AGAIN>>>
	       <TELL "Your body seems unwilling to respond." CR>
	       <RFATAL>)
	      (<NOT <EQUAL? .A ,V?WALK>>
	       <COND (<AND <EQUAL? ,IT .I .O>
			   <NOT <ACCESSIBLE? ,P-IT-OBJECT>>>
		      <COND (<NOT .I>
			     <FAKE-ORPHAN>)
			    (T
			     <CANT-SEE-ANY ,P-IT-OBJECT>)>
		      <RFATAL>)>
	       <COND (<EQUAL? ,THEM .I .O>
		      <COND (<VISIBLE? ,P-THEM-OBJECT>
			   ; <COND (,DEBUG
				    <TELL "[them=" D ,P-THEM-OBJECT "]" CR>)>
			     <COND (<EQUAL? ,THEM .O>
				    <SET O ,P-THEM-OBJECT>)>
			     <COND (<EQUAL? ,THEM .I>
				    <SET I ,P-THEM-OBJECT>)>)
			    (T
			     <COND (<NOT .I>
				    <FAKE-ORPHAN>)
				   (T
				    <CANT-SEE-ANY ,P-THEM-OBJECT>)>
			     <RFATAL>)>)>
	       <COND (<EQUAL? ,HER .I .O>
		      <COND (<VISIBLE? ,P-HER-OBJECT>
			   ; <COND (,DEBUG
				    <TELL "[her=" D ,P-HER-OBJECT "]" CR>)>
			     <COND (<EQUAL? ,HER .O>
				    <SET O ,P-HER-OBJECT>)>
			     <COND (<EQUAL? ,HER .I>
				    <SET I ,P-HER-OBJECT>)>)
			    (T
			     <COND (<NOT .I>
				    <FAKE-ORPHAN>)
				   (T 
				    <CANT-SEE-ANY ,P-HER-OBJECT>)>
			     <RFATAL>)>)>
	       <COND (<EQUAL? ,HIM .I .O>
		      <COND (<VISIBLE? ,P-HIM-OBJECT>
			   ; <COND (,DEBUG
				    <TELL "[him=" D ,P-HIM-OBJECT "]" CR>)>
			     <COND (<EQUAL? ,HIM .O>
				    <SET O ,P-HIM-OBJECT>)>
			     <COND (<EQUAL? ,HIM .I>
				    <SET I ,P-HIM-OBJECT>)>)
			    (T
			     <COND (<NOT .I>
				    <FAKE-ORPHAN>)
				   (T 
				    <CANT-SEE-ANY ,P-HIM-OBJECT>)>
			     <RFATAL>)>)>
	       <COND (<EQUAL? .O ,IT>
		      <SET O ,P-IT-OBJECT>
		    ; <COND (,DEBUG
			     <TELL "[it=" D .O "]" CR>)>)
		     ;"(<EQUAL? .O ,THEM><SET O ,P-THEM-OBJECT>)
		     (<EQUAL? .O ,HER> <SET O ,P-HER-OBJECT>)
		     (<EQUAL? .O ,HIM> <SET O ,P-HIM-OBJECT>)">
	       <COND (<EQUAL? .I ,IT>
		      <SET I ,P-IT-OBJECT>
		    ; <COND (,DEBUG
			     <TELL "[it=" D .O "]" CR>)>)
		     ;"(<EQUAL? .I ,THEM><SET I ,P-THEM-OBJECT>)
		     (<EQUAL? .I ,HER> <SET I ,P-HER-OBJECT>)
		     (<EQUAL? .I ,HIM> <SET I ,P-HIM-OBJECT>)">)>
	<SETG PRSI .I>
	<SETG PRSO .O>
	<SET V <>>
	<COND (<AND <NOT <EQUAL? .A ,V?WALK>>
		    <EQUAL? ,NOT-HERE-OBJECT ,PRSO ,PRSI>>
	       <SET V <APPLY ,NOT-HERE-OBJECT-F>>
	       <COND (.V
		      <SETG P-WON <>>)>)>
	<THIS-IS-IT ,PRSI>
	<THIS-IS-IT ,PRSO>
	<SET O ,PRSO>
	<SET I ,PRSI>
	<COND (<ZERO? .V>
	       <SET V <APPLY <GETP ,WINNER ,P?ACTION> ,M-WINNER>>)>
	<COND (<ZERO? .V>
	       <SET V <APPLY <GETP <LOC ,WINNER> ,P?ACTION> ,M-BEG>>)>
	<COND (<ZERO? .V>
	       <SET V <APPLY <GET ,PREACTIONS .A>>>)>
	<COND (<AND <ZERO? .V>
		    <NOT <EQUAL? ,WINNER ,PROTAGONIST>>>
	       <APPLY <GET ,ACTIONS .A>>
	       <SET V T>)>
	<COND (<AND <ZERO? .V>
		    .I
		    <NOT <EQUAL? .A ,V?WALK>>
		    <LOC .I>>
	       <SET V <GETP <LOC .I> ,P?CONTFCN>>
	       <COND (.V
		      <SET V <APPLY .V ,M-CONT>>)>)>
	<COND (<AND <ZERO? .V>
		    .I>
	       <SET V <APPLY <GETP .I ,P?ACTION>>>)>
	<COND (<AND <ZERO? .V>
		    .O
		    <NOT <EQUAL? .A ,V?WALK>>
		    <LOC .O>>
	       <SET V <GETP <LOC .O> ,P?CONTFCN>>
	       <COND (.V
		      <SET V <APPLY .V ,M-CONT>>)>)>
	<COND (<AND <ZERO? .V>
		    .O
		    <NOT <EQUAL? .A ,V?WALK>>>
	       <SET V <APPLY <GETP .O ,P?ACTION>>>
	       <COND (.V
		      <THIS-IS-IT .O>)>)>
	<COND (<ZERO? .V>
	       <SET V <APPLY <GET ,ACTIONS .A>>>)>
        	
      ; <COND (<NOT <EQUAL? .V ,M-FATAL>>
	       <COND (<NOT <GAME-VERB?>>
		      <SET V 
			   <APPLY <GETP <LOC ,WINNER> ,P?ACTION> ,M-END>>)>)>
	<SETG PRSA .OA>
	<SETG PRSO .OO>
	<SETG PRSI .OI>
	.V>

<ROUTINE BUZZER-WORD? (WORD)
         <COND (<QUESTION-WORD? .WORD>
	        <RTRUE>)
               (<NAUGHTY-WORD? .WORD>
	        <RTRUE>)
               (<MAGIC-WORD? .WORD>
	        <RTRUE>)
               (<OR <EQUAL? .WORD ,W?NW ,W?NORTHW ,W?NE>
	            <EQUAL? .WORD ,W?SW ,W?SOUTHW ,W?NORTHE>
	            <EQUAL? .WORD ,W?SE ,W?SOUTHE>>
	        ;<TELL "(You don't need to use \"">
	        ;<PRINTB .WORD>
	        ;<TELL "\" directions in this story.)" CR>
		<V-BAD-DIRECTION>
		<RTRUE>)
	       
	       (<EQUAL? .WORD ,W?MOUSE ,W?RAT ,W?RODENT>
		<COND (<AND <EQUAL? ,HERE ,INSIDE-CHURCH>
			    <NOT <FSET? ,CHURCH ,TOUCHBIT>>>
		       <TELL 
"It disappeared before you could get a good look." CR>)
		      (T
		       <CANT-SEE-ANY>)>
		<RTRUE>)
	       (<SESAME? .WORD>
		<RTRUE>)
	       (<AND <EQUAL? .WORD ,W?FUZZY ,W?BLURRY ,W?BLURRED>
		     <NOT ,FUZZY?>>
		<TELL ,YOU-SEE "nothing ">
		<PRINTB .WORD>
		<TELL " here!" CR>
		<RTRUE>)
	       (<EQUAL? .WORD ,W?CORKY>
		<COND (<IN? ,CRISP ,HERE>
		       <TELL D ,CRISP 
" reddens. \"Don't use that name in front of me!\"">)
		      (T
		       <TELL "(" D ,CRISP 
			     " hates it when you use that name!)">)>
		<CRLF>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<BUZZ	AM ANY ARE COULD DID DO HAS HAVE HE\'S HOW
	IS IT\'S I\'LL I\'M I\'VE LET\'S SHALL SHE\'S SHOULD
	THAT\'S THEY\'RE WAS WERE WE\'RE
	WHAT WHAT\'S WHEN WHEN\'S WHERE ;WHERE\'S WHICH WHO WHO\'S WHY
	WILL WON\'T WOULD YOU\'RE MOUSE RAT RODENT KALUZE FRATTO SORKIN
	FUZZY BLURRY BLURRED CORKY>

<GLOBAL POWER 0>

<ROUTINE SESAME? (WORD "AUX" MWORD)
	 <COND (<EQUAL? .WORD ,W?KALUZE ,W?FRATTO ,W?SORKIN>
		<COND (<ZERO? ,POWER>
		       <SET MWORD ,W?KALUZE>)
		      (<EQUAL? ,POWER 1>
		       <SET MWORD ,W?FRATTO>)
		      (T
		       <SET MWORD ,W?SORKIN>)>
		<COND (<OR <NOT ,SKEWED?>
			   <NOT <EQUAL? ,HERE ,HILLTOP>>
			   <NOT <EQUAL? .WORD .MWORD>>>
		       <TELL "(The word \"">
		       <PRINTB .WORD>
		       <TELL "\" isn't useful here.)" CR>)
                      (<FSET? ,PELICAN ,RMUNGBIT>
		       <SAY-THE ,DRAWBRIDGE>
		       <TELL " decides that you're only guessing the word \"">
		       <PRINTB .WORD>
		       <TELL ",\" and refuses to cooperate." CR>)
		      (<FSET? ,DRAWBRIDGE ,RMUNGBIT>
		       <NOTHING-EXCITING>)
	              (,ECLIPSE?
		       <DARK-IS-POWERFUL>)
	              (T
		       <FSET ,DRAWBRIDGE ,RMUNGBIT>
		       <FSET ,DRAWBRIDGE ,OPENBIT>
		       <TELL 
"With a great creak of wood and rattle of chains, the " D ,DRAWBRIDGE " slowly lowers across the moat." CR CR>
		       <UPDATE-SCORE 3>
		       <GOOD-PLACE-TO-SAVE>)>
		<RTRUE>)
	       (T
	        <RFALSE>)>>

<ROUTINE QUESTION-WORD? (WORD)
	<COND (<EQUAL? .WORD ,W?WHERE>
	       <TO-DO-THING-USE "locate" "FIND">
	       <RTRUE>)
	      
	      (<OR <EQUAL? .WORD ,W?WHAT ,W?WHAT\'S ,W?WHO>
		   <EQUAL? .WORD ,W?WHO\'S ,W?WHY ,W?HOW>
		   <EQUAL? .WORD ,W?WHEN ,W?WHEN\'S ,W?AM>
		   <EQUAL? .WORD ,W?WOULD ,W?COULD ,W?SHOULD>>
	       <TO-DO-THING-USE "ask about" "ASK CHARACTER ABOUT">
	       <RTRUE>)
	      
	      (<OR <EQUAL? .WORD ,W?THAT\'S	,W?IT\'S        ,W?I\'M>
		   <EQUAL? .WORD ,W?IS		,W?DID		,W?ARE>
		   <EQUAL? .WORD ,W?DO		,W?HAVE		,W?ANY>
		   <EQUAL? .WORD ,W?WILL	,W?WAS		,W?WERE>
		   <EQUAL? .WORD ,W?I\'LL	,W?WHICH        ,W?WE\'RE>
		   <EQUAL? .WORD ,W?I\'VE	,W?WON\'T	,W?HAS>
		   <EQUAL? .WORD ,W?YOU\'RE	,W?HE\'S	,W?SHE\'S>
		   <EQUAL? .WORD ,W?THEY\'RE	,W?SHALL>>
	       <TELL "(Please use commands, not statements or questions.)" CR>
	       <RTRUE>)
	      (T
	       <RFALSE>)>>

<BUZZ FUCK FUCKED CURSE GODDAMNED CUSS DAMN SHIT ASSHOLE CUNT
      SHITHEAD PISS SUCK BASTARD SCREW FUCKING DAMNED PEE COCKSUCKER BITCH>

<ROUTINE NAUGHTY-WORD? (WORD)
         <COND (<OR <EQUAL? .WORD ,W?CURSE ,W?GODDAMNED ,W?CUSS>
	            <EQUAL? .WORD ,W?DAMN ,W?SHIT ,W?FUCK>
	            <EQUAL? .WORD ,W?SHITHEAD ,W?PISS ,W?SUCK>
	            <EQUAL? .WORD ,W?BASTARD ,W?SCREW ,W?FUCKING>
	            <EQUAL? .WORD ,W?DAMNED ,W?PEE ,W?COCKSUCKER>
		    <EQUAL? .WORD ,W?FUCKED ,W?CUNT ,W?ASSHOLE>
		    <EQUAL? .WORD ,W?BITCH>>
	        <TELL "(" <PICK-ONE ,OFFENDED> ".)" CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<GLOBAL OFFENDED
	<LTABLE 0  
        "What charming language"
        "Computers aren't impressed by naughty words"
        "Grow up">>

<BUZZ PLUGH XYZZY YOHO ODYSSEUS ULYSSES ECHO SAILOR ZORK OZMOO>

<ROUTINE MAGIC-WORD? (WORD)
	 <COND (<OR <EQUAL? .WORD ,W?PLUGH ,W?XYZZY ,W?YOHO>
		    <EQUAL? .WORD ,W?ECHO ,W?ODYSSEUS ,W?ULYSSES>
		    <EQUAL? .WORD ,W?SAILOR ,W?ZORK ,W?OZMOO>>
		<TELL "A hollow voice says, \"Fool!\"" CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE VERB-DIR-ONLY? (WRD)
	<AND <NOT <WT? .WRD ,PS?OBJECT>>
	     <NOT <WT? .WRD ,PS?ADJECTIVE>>
	     <OR <WT? .WRD ,PS?DIRECTION>
		 <WT? .WRD ,PS?VERB>>>>

<ROUTINE NUMBER? (PTR "AUX" CNT BPTR CHR (SUM 0) (TIM <>) (DOLLAR <>))
	 <SET CNT <GETB <REST ,P-LEXV <* .PTR 2>> 2>>
	 <SET BPTR <GETB <REST ,P-LEXV <* .PTR 2>> 3>>
	 ;<SETG P-DOLLAR-FLAG <>>
	 <REPEAT ()
		 <COND (<L? <SET CNT <- .CNT 1>> 0> <RETURN>)
		       (T
			<SET CHR <GETB ,P-INBUF .BPTR>>
			<COND (<EQUAL? .CHR %<ASCII !\:>>
			       <SET TIM .SUM>
			       <SET SUM 0>)
			      (<G? .SUM 9999> <RFALSE>)
			      (<EQUAL? .CHR ,CURRENCY-SYMBOL>
			       <SET DOLLAR T>)
			      (<OR <G? .CHR %<ASCII !\9>>
				   <L? .CHR %<ASCII !\0>>>
			       <RFALSE>)
			      (T
			       <SET SUM <+ <* .SUM 10>
					   <- .CHR %<ASCII !\0>>>>)>
			<SET BPTR <+ .BPTR 1>>)>>
	 <PUT ,P-LEXV .PTR ,W?INTNUM>
	 <COND (<G? .SUM 9999> <RFALSE>)
	       (.TIM
		<COND ;"(<L? .TIM 8> <SET TIM <+ .TIM 12>>)"
		      (<G? .TIM 23> <RFALSE>)
		      ;"(<G? .TIM 19> T)
		      (<G? .TIM 12> <RFALSE>)
		      (<G? .TIM  7> T)
		      (T <SET TIM <+ 12 .TIM>>)">
		<SET SUM <+ .SUM <* .TIM 60>>>)>
	 <SETG P-DOLLAR-FLAG .DOLLAR>
	 <COND (<AND .DOLLAR <G? .SUM 0>>
		<SETG P-AMOUNT .SUM>
		,W?MONEY
		;<FSET ,INTNUM ,VOWELBIT>
		;<PUTP ,INTNUM ,P?SDESC "amount of money">)
	       (T
		<SETG P-NUMBER .SUM>
		<SETG P-DOLLAR-FLAG <>>
		,W?INTNUM
		;<FCLEAR ,INTNUM ,VOWELBIT>
		;<PUTP ,INTNUM ,P?SDESC "number">)>>

<GLOBAL P-NUMBER -1>
<GLOBAL P-AMOUNT 0>
<GLOBAL P-DOLLAR-FLAG <>>
<CONSTANT CURRENCY-SYMBOL %<ASCII !\$>>

<GLOBAL P-DIRECTION 0>

"New ORPHAN-MERGE for TRAP Retrofix 6/21/84"

<ROUTINE ORPHAN-MERGE ("AUX" (CNT -1) TEMP VERB BEG END (ADJ <>) WRD) 
   <SETG P-OFLAG <>>
   <COND (<WT? <SET WRD <GET <GET ,P-ITBL ,P-VERBN> 0>>
	       ,PS?ADJECTIVE ,P1?ADJECTIVE>
	  <SET ADJ T>)
	 (<AND <WT? .WRD ,PS?OBJECT ,P1?OBJECT>
	       <EQUAL? ,P-NCN 0>>
	  <PUT ,P-ITBL ,P-VERB 0>
	  <PUT ,P-ITBL ,P-VERBN 0>
	  <PUT ,P-ITBL ,P-NC1 <REST ,P-LEXV 2>>
	  <PUT ,P-ITBL ,P-NC1L <REST ,P-LEXV 6>>
	  <SETG P-NCN 1>)>
   <COND (<AND <NOT <ZERO? <SET VERB <GET ,P-ITBL ,P-VERB>>>>
	       <NOT .ADJ>
	       <NOT <EQUAL? .VERB <GET ,P-OTBL ,P-VERB>>>>
	  <RFALSE>)
	 (<EQUAL? ,P-NCN 2>
	  <RFALSE>)
	 (<EQUAL? <GET ,P-OTBL ,P-NC1> 1>
	  <COND (<OR <EQUAL? <SET TEMP <GET ,P-ITBL ,P-PREP1>>
			  <GET ,P-OTBL ,P-PREP1>>
		     <ZERO? .TEMP>>
		 <COND (.ADJ
			<PUT ,P-OTBL ,P-NC1 <REST ,P-LEXV 2>>
			<COND (<ZERO? <GET ,P-ITBL ,P-NC1L>>
			       <PUT ,P-ITBL ,P-NC1L <REST ,P-LEXV 6>>)>
			<COND (<ZERO? ,P-NCN>
			       <SETG P-NCN 1>)>)
		       (T
			<PUT ,P-OTBL ,P-NC1 <GET ,P-ITBL ,P-NC1>>
			;<PUT ,P-OTBL ,P-NC1L <GET ,P-ITBL ,P-NC1L>>)>
		 <PUT ,P-OTBL ,P-NC1L <GET ,P-ITBL ,P-NC1L>>)
		(T
		 <RFALSE>)>)
	 (<EQUAL? <GET ,P-OTBL ,P-NC2> 1>
	  <COND (<OR <EQUAL? <SET TEMP <GET ,P-ITBL ,P-PREP1>>
			  <GET ,P-OTBL ,P-PREP2>>
		     <ZERO? .TEMP>>
		 <COND (.ADJ
			<PUT ,P-ITBL ,P-NC1 <REST ,P-LEXV 2>>
			<COND (<ZERO? <GET ,P-ITBL ,P-NC1L>>
			       <PUT ,P-ITBL ,P-NC1L <REST ,P-LEXV 6>>)>)>
		 <PUT ,P-OTBL ,P-NC2 <GET ,P-ITBL ,P-NC1>>
		 <PUT ,P-OTBL ,P-NC2L <GET ,P-ITBL ,P-NC1L>>
		 <SETG P-NCN 2>)
		(T
		 <RFALSE>)>)
	 (,P-ACLAUSE
	  <COND (<AND <NOT <EQUAL? ,P-NCN 1>> <NOT .ADJ>>
		 <SETG P-ACLAUSE <>>
		 <RFALSE>)
		(T
		 <SET BEG <GET ,P-ITBL ,P-NC1>>
		 <COND (.ADJ <SET BEG <REST ,P-LEXV 2>> <SET ADJ <>>)>
		 <SET END <GET ,P-ITBL ,P-NC1L>>
		 <REPEAT ()
			 <SET WRD <GET .BEG 0>>
			 <COND (<EQUAL? .BEG .END>
				<COND (.ADJ
				       <ACLAUSE-WIN .ADJ>
				       <RETURN>)
				      (T
				       <SETG P-ACLAUSE <>> <RFALSE>)>)
			       (<AND <NOT .ADJ>
				     <OR <BTST <GETB .WRD ,P-PSOFF>
					       ,PS?ADJECTIVE> ;"same as WT?"
					 <EQUAL? .WRD ,W?ALL ; ,W?ONE
						 ,W?EVERYTHING>>>
				<SET ADJ .WRD>)
			     ; (<EQUAL? .WRD ,W?ONE>
				<ACLAUSE-WIN .ADJ>
				<RETURN>)
			       (<BTST <GETB .WRD ,P-PSOFF> ,PS?OBJECT>
				<COND (<EQUAL? .WRD ,P-ANAM>
				       <ACLAUSE-WIN .ADJ>)
				      (T
				       <NCLAUSE-WIN>)>
				<RETURN>)>
			 <SET BEG <REST .BEG ,P-WORDLEN>>
			 <COND (<EQUAL? .END 0>
				<SET END .BEG>
				<SETG P-NCN 1>
				<PUT ,P-ITBL ,P-NC1 <BACK .BEG 4>>
				<PUT ,P-ITBL ,P-NC1L .BEG>)>>)>)>
   <PUT ,P-VTBL 0 <GET ,P-OVTBL 0>>
   <PUTB ,P-VTBL 2 <GETB ,P-OVTBL 2>>
   <PUTB ,P-VTBL 3 <GETB ,P-OVTBL 3>>
   <PUT ,P-OTBL ,P-VERBN ,P-VTBL>
   <PUTB ,P-VTBL 2 0>
   ;<AND <NOT <EQUAL? <GET ,P-OTBL ,P-NC2> 0>> <SETG P-NCN 2>>
   <REPEAT ()
	   <COND (<G? <SET CNT <+ .CNT 1>> ,P-ITBLLEN>
		  <SETG P-MERGED T>
		  <RTRUE>)
		 (T
		  <PUT ,P-ITBL .CNT <GET ,P-OTBL .CNT>>)>>
   T>

"New ACLAUSE-WIN for TRAP retrofix 6/21/84"

<ROUTINE ACLAUSE-WIN (ADJ) 
	<PUT ,P-ITBL ,P-VERB <GET ,P-OTBL ,P-VERB>>
	<PUT ,P-CCTBL ,CC-SBPTR ,P-ACLAUSE>
	<PUT ,P-CCTBL ,CC-SEPTR <+ ,P-ACLAUSE 1>>
	<PUT ,P-CCTBL ,CC-DBPTR ,P-ACLAUSE>
	<PUT ,P-CCTBL ,CC-DEPTR <+ ,P-ACLAUSE 1>>
	<CLAUSE-COPY ,P-OTBL ,P-OTBL .ADJ>
	<AND <NOT <EQUAL? <GET ,P-OTBL ,P-NC2> 0>> <SETG P-NCN 2>>
	<SETG P-ACLAUSE <>>
	<RTRUE>>

<ROUTINE NCLAUSE-WIN ()
        <PUT ,P-CCTBL ,CC-SBPTR ,P-NC1>
	<PUT ,P-CCTBL ,CC-SEPTR ,P-NC1L>
	<PUT ,P-CCTBL ,CC-DBPTR ,P-ACLAUSE>
	<PUT ,P-CCTBL ,CC-DEPTR <+ ,P-ACLAUSE 1>>
	<CLAUSE-COPY ,P-ITBL ,P-OTBL>
	<AND <NOT <EQUAL? <GET ,P-OTBL ,P-NC2> 0>> <SETG P-NCN 2>>
	<SETG P-ACLAUSE <>>
	<RTRUE>>

"Print undefined word in input. PTR points to the unknown word in P-LEXV"   

<ROUTINE WORD-PRINT (CNT BUF)
	 ;<COND (<G? .CNT 6> <SET CNT 6>)>
	 <REPEAT ()
		 <COND (<DLESS? CNT 0> <RETURN>)
		       (ELSE
			<PRINTC <GETB ,P-INBUF .BUF>>
			<SET BUF <+ .BUF 1>>)>>>

<GLOBAL UNKNOWN-MSGS
        <LTABLE 0 
  <PTABLE "This story doesn't know the word \""
	 ".\"">
  <PTABLE "Sorry, but the word \""
	 "\" is not in the vocabulary that you can use.">
  <PTABLE "You don't need to use the word \""
	 "\" to finish this story.">
  <PTABLE "Sorry, but this story doesn't recognize the word \""
	 ".\"">>>

<ROUTINE UNKNOWN-WORD (PTR "AUX" BUF MSG)
	<SET MSG <PICK-ONE ,UNKNOWN-MSGS>>
	<TELL "(" <GET .MSG 0>>
	<WORD-PRINT <GETB <REST ,P-LEXV <SET BUF <* .PTR 2>>> 2>
		    <GETB <REST ,P-LEXV .BUF> 3>>
	<SETG QUOTE-FLAG <>>
	<SETG P-OFLAG <>>
	<TELL <GET .MSG 1> ")" CR>>

" Perform syntax matching operations, using P-ITBL as the source of
   the verb and adjectives for this input.  Returns false if no
   syntax matches, and does it's own orphaning.  If return is true,
   the syntax is saved in P-SYNTAX."   
 
<GLOBAL P-SLOCBITS 0>    
 
<CONSTANT P-SYNLEN 8>    
 
<CONSTANT P-SBITS 0>
 
<CONSTANT P-SPREP1 1>    
 
<CONSTANT P-SPREP2 2>    
 
<CONSTANT P-SFWIM1 3>    
 
<CONSTANT P-SFWIM2 4>    
 
<CONSTANT P-SLOC1 5>
 
<CONSTANT P-SLOC2 6>
 
<CONSTANT P-SACTION 7>   
 
<CONSTANT P-SONUMS 3>    

<ROUTINE SYNTAX-CHECK ("AUX" SYN LEN NUM OBJ (DRIVE1 <>) (DRIVE2 <>)
			     PREP VERB) 
	<SET VERB <GET ,P-ITBL ,P-VERB>>
	<COND (<ZERO? .VERB>
	       <NOT-IN-SENTENCE "any verbs">
	       <RFALSE>)>
	<SET SYN <GET ,VERBS <- 255 .VERB>>>
	<SET LEN <GETB .SYN 0>>
	<SET SYN <REST .SYN>>
	<REPEAT ()
		<SET NUM <BAND <GETB .SYN ,P-SBITS> ,P-SONUMS>>
		<COND (<G? ,P-NCN .NUM> T) ;"Added 4/27/83"
		      (<AND <NOT <L? .NUM 1>>
			    <ZERO? ,P-NCN>
			    <OR <ZERO? <SET PREP <GET ,P-ITBL ,P-PREP1>>>
				<EQUAL? .PREP <GETB .SYN ,P-SPREP1>>>>
		       <SET DRIVE1 .SYN>)
		      (<EQUAL? <GETB .SYN ,P-SPREP1> <GET ,P-ITBL ,P-PREP1>>
		       <COND (<AND <EQUAL? .NUM 2> <EQUAL? ,P-NCN 1>>
			      <SET DRIVE2 .SYN>)
			     (<EQUAL? <GETB .SYN ,P-SPREP2>
				   <GET ,P-ITBL ,P-PREP2>>
			      <SYNTAX-FOUND .SYN>
			      <RTRUE>)>)>
		<COND (<DLESS? LEN 1>
		       <COND (<OR .DRIVE1 .DRIVE2> <RETURN>)
			     (T
			      <DONT-UNDERSTAND>
			      <RFALSE>)>)
		      (T <SET SYN <REST .SYN ,P-SYNLEN>>)>>
	<COND (<AND .DRIVE1
		    <SET OBJ
			 <GWIM <GETB .DRIVE1 ,P-SFWIM1>
			       <GETB .DRIVE1 ,P-SLOC1>
			       <GETB .DRIVE1 ,P-SPREP1>>>>
	       <PUT ,P-PRSO ,P-MATCHLEN 1>
	       <PUT ,P-PRSO 1 .OBJ>
	       <SYNTAX-FOUND .DRIVE1>)
	      (<AND .DRIVE2
		    <SET OBJ
			 <GWIM <GETB .DRIVE2 ,P-SFWIM2>
			       <GETB .DRIVE2 ,P-SLOC2>
			       <GETB .DRIVE2 ,P-SPREP2>>>>
	       <PUT ,P-PRSI ,P-MATCHLEN 1>
	       <PUT ,P-PRSI 1 .OBJ>
	       <SYNTAX-FOUND .DRIVE2>)
	      (<EQUAL? .VERB ,ACT?FIND ; ,ACT?WHAT>
	       <TELL "That's your problem!" CR>
	       <RFALSE>)
	      (T
	       <COND (<EQUAL? ,WINNER ,PROTAGONIST>
		      <ORPHAN .DRIVE1 .DRIVE2>
		      <TELL "(Wh"
			    <COND (<EQUAL? .VERB ,ACT?WALK> "ere")
				  (T "at")>
			    " do you want to ">)
		     (T
		      <TELL
"(Your command wasn't complete. Next time, type wh"
                      <COND (<EQUAL? .VERB ,ACT?WALK> "ere") (T "at")>
" you want ">
		      <ARTICLE ,WINNER T>
		      <TELL D ,WINNER " to ">)>
	       <VERB-PRINT>
	       <COND (.DRIVE2
		      <CLAUSE-PRINT ,P-NC1 ,P-NC1L>)>
	       <PREP-PRINT <COND (.DRIVE1 <GETB .DRIVE1 ,P-SPREP1>)
				 (T <GETB .DRIVE2 ,P-SPREP2>)>>
	       <COND (<EQUAL? ,WINNER ,PROTAGONIST>
		      <SETG P-OFLAG T>
		      <TELL "?)" CR>)
		     (T
		      <SETG P-OFLAG <>>
		      <TELL ".)" CR>)>
	       <RFALSE>)>>

<ROUTINE VERB-PRINT ("AUX" TMP)
	<SET TMP <GET ,P-ITBL ,P-VERBN>>	;"? ,P-OTBL?"
	<COND (<EQUAL? .TMP 0> <TELL "tell">)
	      (<ZERO? <GETB ,P-VTBL 2>>
	       <PRINTB <GET .TMP 0>>)
	      (T
	       <WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>
	       <PUTB ,P-VTBL 2 0>)>>

<ROUTINE ORPHAN (D1 D2 "AUX" (CNT -1)) 
	<COND (<NOT ,P-MERGED>
	       <PUT ,P-OCLAUSE ,P-MATCHLEN 0>)>
	<PUT ,P-OVTBL 0 <GET ,P-VTBL 0>>
	<PUTB ,P-OVTBL 2 <GETB ,P-VTBL 2>>
	<PUTB ,P-OVTBL 3 <GETB ,P-VTBL 3>>
	<REPEAT ()
		<COND (<IGRTR? CNT ,P-ITBLLEN> <RETURN>)
		      (T <PUT ,P-OTBL .CNT <GET ,P-ITBL .CNT>>)>>
	<COND (<EQUAL? ,P-NCN 2>
	       <PUT ,P-CCTBL ,CC-SBPTR ,P-NC2>
	       <PUT ,P-CCTBL ,CC-SEPTR ,P-NC2L>
	       <PUT ,P-CCTBL ,CC-DBPTR ,P-NC2>
	       <PUT ,P-CCTBL ,CC-DEPTR ,P-NC2L>
	       <CLAUSE-COPY ,P-ITBL ,P-OTBL>)>
	<COND (<NOT <L? ,P-NCN 1>>
	       <PUT ,P-CCTBL ,CC-SBPTR ,P-NC1>
	       <PUT ,P-CCTBL ,CC-SEPTR ,P-NC1L>
	       <PUT ,P-CCTBL ,CC-DBPTR ,P-NC1>
	       <PUT ,P-CCTBL ,CC-DEPTR ,P-NC1L>
	       <CLAUSE-COPY ,P-ITBL ,P-OTBL>)>
	<COND (.D1
	       <PUT ,P-OTBL ,P-PREP1 <GETB .D1 ,P-SPREP1>>
	       <PUT ,P-OTBL ,P-NC1 1>)
	      (.D2
	       <PUT ,P-OTBL ,P-PREP2 <GETB .D2 ,P-SPREP2>>
	       <PUT ,P-OTBL ,P-NC2 1>)>> 

<ROUTINE CLAUSE-PRINT (BPTR EPTR "OPTIONAL" (THE? T)) 
	<BUFFER-PRINT <GET ,P-ITBL .BPTR> <GET ,P-ITBL .EPTR> .THE?>>    

<ROUTINE BUFFER-PRINT (BEG END CP "AUX" (NOSP <>) WRD (FIRST?? T) (PN <>))
	 <REPEAT ()
		<COND (<EQUAL? .BEG .END> <RETURN>)
		      (T
		       <COND (.NOSP <SET NOSP <>>)
			     (T <TELL " ">)>
		       <SET WRD <GET .BEG 0>>
		       <COND (<OR <AND <EQUAL? .WRD ,W?HIM>
				       <NOT <VISIBLE? ,P-HIM-OBJECT>>>
				  <AND <EQUAL? .WRD ,W?HER>
				       <NOT <VISIBLE? ,P-HER-OBJECT>>>
				  <AND <EQUAL? .WRD ,W?THEM>
				       <NOT <VISIBLE? ,P-THEM-OBJECT>>>>
			      <SET PN T>)>
		       <COND (<EQUAL? .WRD ,W?PERIOD>
			      <SET NOSP T>)
			     (<EQUAL? .WRD ,W?ME>
			      <PRINTD ,PROTAGONIST>
			      <SET PN T>)
			     (<NAME? .WRD>
			      <CAPITALIZE .BEG>
			      <SET PN T>)
			     (T
			      <COND (<AND .FIRST?? <NOT .PN> .CP>
				     <TELL "the ">)>
			      <COND (<OR ,P-OFLAG ,P-MERGED> <PRINTB .WRD>)
				    (<AND <EQUAL? .WRD ,W?IT>
					  <VISIBLE? ,P-IT-OBJECT>>
				     <PRINTD ,P-IT-OBJECT>)
				    (<AND <EQUAL? .WRD ,W?HER>
					  <NOT .PN>	;"VISIBLE check above"
					  ;<VISIBLE? ,P-HER-OBJECT>>
				     <PRINTD ,P-HER-OBJECT>)
				    (<AND <EQUAL? .WRD ,W?THEM>
					  <NOT .PN>
					  ;<VISIBLE? ,P-THEM-OBJECT>>
				     <PRINTD ,P-THEM-OBJECT>)
				    (<AND <EQUAL? .WRD ,W?HIM>
					  <NOT .PN>
					  ;<VISIBLE? ,P-HIM-OBJECT>>
				     <PRINTD ,P-HIM-OBJECT>)
				    (T
				     <WORD-PRINT <GETB .BEG 2>
						 <GETB .BEG 3>>)>
			      <SET FIRST?? <>>)>)>
		<SET BEG <REST .BEG ,P-WORDLEN>>>>

<ROUTINE NAME? (WRD)
	<OR <EQUAL? .WRD ,W?CRISP ,W?VOSS ,W?MACGUFFIN>
	    <EQUAL? .WRD ,W?FESTERON ,W?SHOPPE ,W?MAGICK>
	    <EQUAL? .WRD ,W?KING ,W?PRINCESS ,W?TASMANIA>
	    <EQUAL? .WRD ,W?ANATINUS ,W?EVIL ,W?ONE>
	    <EQUAL? .WRD ,W?WISHBRINGER ,W?CHAOS ,W?MR>
	    <EQUAL? .WRD ,W?MISS ,W?MS ,W?ALEXIS>>>

<ROUTINE CAPITALIZE (PTR)
	 <PRINTC <- <GETB ,P-INBUF <GETB .PTR 3>> 32>>
	 <WORD-PRINT <- <GETB .PTR 2> 1> <+ <GETB .PTR 3> 1>>>

<ROUTINE PREP-PRINT (PREP "OPTIONAL" (SP? T) "AUX" WRD) 
	<COND (<NOT <ZERO? .PREP>>
	       <COND (.SP? <TELL " ">)>
	       <SET WRD <PREP-FIND .PREP>>
	       <COND ;(<EQUAL? .WRD ,W?AGAINST> <TELL "against">)
		     (<EQUAL? .WRD ,W?THROUGH> <TELL "through">)
		     (T <PRINTB .WRD>)>
	       <COND (<AND <EQUAL? ,W?SIT <GET <GET ,P-ITBL ,P-VERBN> 0>>
			   <EQUAL? ,W?DOWN .WRD>>
		      <TELL " on">)>
	       <COND (<AND <EQUAL? ,W?GET <GET <GET ,P-ITBL ,P-VERBN> 0>>
			   <EQUAL? ,W?OUT .WRD>>	;"Will it ever work? --SWG"
		      <TELL " of">)>
	       <RTRUE>)>>    

<GLOBAL P-CCTBL <TABLE 0 0 0 0>>  

"pointers used by CLAUSE-COPY (source/destination beginning/end pointers)"

<CONSTANT CC-SBPTR 0>
<CONSTANT CC-SEPTR 1>
<CONSTANT CC-DBPTR 2>
<CONSTANT CC-DEPTR 3>

<ROUTINE CLAUSE-COPY (SRC DEST "OPTIONAL" (INSRT <>) "AUX" BEG END)
	<SET BEG <GET .SRC <GET ,P-CCTBL ,CC-SBPTR>>>
	<SET END <GET .SRC <GET ,P-CCTBL ,CC-SEPTR>>>
	<PUT .DEST
	     <GET ,P-CCTBL ,CC-DBPTR>
	     <REST ,P-OCLAUSE
		   <+ <* <GET ,P-OCLAUSE ,P-MATCHLEN> ,P-LEXELEN> 2>>>
	<REPEAT ()
		<COND (<EQUAL? .BEG .END>
		       <PUT .DEST
			    <GET ,P-CCTBL ,CC-DEPTR>
			    <REST ,P-OCLAUSE
				  <+ <* <GET ,P-OCLAUSE ,P-MATCHLEN> ,P-LEXELEN>
				     2>>>
		       <RETURN>)
		      (T
		       <COND (<AND .INSRT <EQUAL? ,P-ANAM <GET .BEG 0>>>
			      <CLAUSE-ADD .INSRT>)>
		       <CLAUSE-ADD <GET .BEG 0>>)>
		<SET BEG <REST .BEG ,P-WORDLEN>>>>


<ROUTINE CLAUSE-ADD (WRD "AUX" PTR) 
	<SET PTR <+ <GET ,P-OCLAUSE ,P-MATCHLEN> 2>>
	<PUT ,P-OCLAUSE <- .PTR 1> .WRD>
	<PUT ,P-OCLAUSE .PTR 0>
	<PUT ,P-OCLAUSE ,P-MATCHLEN .PTR>>   
 
<ROUTINE PREP-FIND (PREP "AUX" (CNT 0) SIZE) 
       	<SET SIZE <* <GET ,PREPOSITIONS 0> 2>>
	<REPEAT ()
		<COND (<IGRTR? CNT .SIZE> <RFALSE>)
		      (<EQUAL? <GET ,PREPOSITIONS .CNT> .PREP>
		       <RETURN <GET ,PREPOSITIONS <- .CNT 1>>>)>>>  
 
<ROUTINE SYNTAX-FOUND (SYN) 
	<SETG P-SYNTAX .SYN>
	<SETG PRSA <GETB .SYN ,P-SACTION>>>   
 
<GLOBAL P-GWIMBIT 0>
 
<ROUTINE GWIM (GBIT LBIT PREP "AUX" OBJ WPREP)
	<COND (<EQUAL? .GBIT ,RLANDBIT>
	       <RETURN ,ROOMS>)>
	<SETG P-GWIMBIT .GBIT>
	<SETG P-SLOCBITS .LBIT>
	<PUT ,P-MERGE ,P-MATCHLEN 0>
	<COND (<GET-OBJECT ,P-MERGE <>>
	       <SETG P-GWIMBIT 0>
	       <COND (<EQUAL? <GET ,P-MERGE ,P-MATCHLEN> 1>
		      <SET OBJ <GET ,P-MERGE 1>>
		      <TELL "(">
		      <COND (<PREP-PRINT .PREP <>>
			     <TELL " ">
			     <ARTICLE .OBJ T>)>
		      <TELL D .OBJ ")" CR>
		      .OBJ)>)
	      (T
	       <SETG P-GWIMBIT 0>
	       <RFALSE>)>>   

<ROUTINE SNARF-OBJECTS ("AUX" PTR) 
	<COND (<NOT <EQUAL? <SET PTR <GET ,P-ITBL ,P-NC1>> 0>>
	       <SETG P-SLOCBITS <GETB ,P-SYNTAX ,P-SLOC1>>
	       <OR <SNARFEM .PTR <GET ,P-ITBL ,P-NC1L> ,P-PRSO> <RFALSE>>
	       <OR <ZERO? <GET ,P-BUTS ,P-MATCHLEN>>
		   <SETG P-PRSO <BUT-MERGE ,P-PRSO>>>)>
	<COND (<NOT <EQUAL? <SET PTR <GET ,P-ITBL ,P-NC2>> 0>>
	       <SETG P-SLOCBITS <GETB ,P-SYNTAX ,P-SLOC2>>
	       <OR <SNARFEM .PTR <GET ,P-ITBL ,P-NC2L> ,P-PRSI> <RFALSE>>
	       <COND (<NOT <ZERO? <GET ,P-BUTS ,P-MATCHLEN>>>
		      <COND (<EQUAL? <GET ,P-PRSI ,P-MATCHLEN> 1>
			     <SETG P-PRSO <BUT-MERGE ,P-PRSO>>)
			    (T <SETG P-PRSI <BUT-MERGE ,P-PRSI>>)>)>)>
	<RTRUE>>  

<ROUTINE BUT-MERGE (TBL "AUX" LEN BUTLEN (CNT 1) (MATCHES 0) OBJ NTBL) 
	<SET LEN <GET .TBL ,P-MATCHLEN>>
	<PUT ,P-MERGE ,P-MATCHLEN 0>
	<REPEAT ()
		<COND (<DLESS? LEN 0> <RETURN>)
		      (<ZMEMQ <SET OBJ <GET .TBL .CNT>> ,P-BUTS>)
		      (T
		       <PUT ,P-MERGE <+ .MATCHES 1> .OBJ>
		       <SET MATCHES <+ .MATCHES 1>>)>
		<SET CNT <+ .CNT 1>>>
	<PUT ,P-MERGE ,P-MATCHLEN .MATCHES>
	<SET NTBL ,P-MERGE>
	<SETG P-MERGE .TBL>
	.NTBL>    
 
<GLOBAL P-NAM <>>   
 
<GLOBAL P-XNAM <>>

<GLOBAL P-ADJ <>>   
 
<GLOBAL P-XADJ <>>

<GLOBAL P-ADJN <>>  
 
<GLOBAL P-XADJN <>>

<GLOBAL P-PRSO <ITABLE NONE 25>>   
 
<GLOBAL P-PRSI <ITABLE NONE 25>>   
 
<GLOBAL P-BUTS <ITABLE NONE 25>>   
 
<GLOBAL P-MERGE <ITABLE NONE 25>>  
 
<GLOBAL P-OCLAUSE <ITABLE NONE 25>>
 
<GLOBAL P-MATCHLEN 0>    
 
<GLOBAL P-GETFLAGS 0>    
 
<CONSTANT P-ALL 1>  
 
<CONSTANT P-ONE 2>  
 
<CONSTANT P-INHIBIT 4>   

<GLOBAL P-AND <>>

<ROUTINE SNARFEM (PTR EPTR TBL "AUX" (BUT <>) LEN WV WRD NW (WAS-ALL? <>)) 
   ;"Next SETG 6/21/84 for WHICH retrofix"
   <SETG P-AND <>>
   <COND (<EQUAL? ,P-GETFLAGS ,P-ALL>
	  <SET WAS-ALL? T>)>
   <SETG P-GETFLAGS 0>
   <PUT ,P-BUTS ,P-MATCHLEN 0>
   <PUT .TBL ,P-MATCHLEN 0>
   <SET WRD <GET .PTR 0>>
   <REPEAT ()
	   <COND (<EQUAL? .PTR .EPTR>
		  <SET WV <GET-OBJECT <OR .BUT .TBL>>>
		  <COND (.WAS-ALL?
			 <SETG P-GETFLAGS ,P-ALL>)>
		  <RETURN .WV>)
		 (T
		  <SET NW <GET .PTR ,P-LEXELEN>>
		  <COND (<EQUAL? .WRD ,W?ALL ,W?BOTH ,W?EVERYTHING>
			 <SETG P-GETFLAGS ,P-ALL>
			 <COND (<EQUAL? .NW ,W?OF>
				<SET PTR <REST .PTR ,P-WORDLEN>>)>)
			(<EQUAL? .WRD ,W?BUT ,W?EXCEPT>
			 <OR <GET-OBJECT <OR .BUT .TBL>> <RFALSE>>
			 <SET BUT ,P-BUTS>
			 <PUT .BUT ,P-MATCHLEN 0>)
			(<BUZZER-WORD? .WRD>
			 <RFALSE>)
			(<EQUAL? .WRD ,W?A ; ,W?ONE>
			 <COND (<NOT ,P-ADJ>
				<SETG P-GETFLAGS ,P-ONE>
				<COND (<EQUAL? .NW ,W?OF>
				       <SET PTR <REST .PTR ,P-WORDLEN>>)>)
			       (T
				<SETG P-NAM ,P-ONEOBJ>
				<OR <GET-OBJECT <OR .BUT .TBL>> <RFALSE>>
				<AND <ZERO? .NW> <RTRUE>>)>)
			(<AND <EQUAL? .WRD ,W?AND ,W?COMMA>
			      <NOT <EQUAL? .NW ,W?AND ,W?COMMA>>>
			 ;"Next SETG 6/21/84 for WHICH retrofix"
			 <SETG P-AND T>
			 <OR <GET-OBJECT <OR .BUT .TBL>> <RFALSE>>
			 T)
			(<WT? .WRD ,PS?BUZZ-WORD>)
			(<EQUAL? .WRD ,W?AND ,W?COMMA>)
			(<EQUAL? .WRD ,W?OF>
			 <COND (<ZERO? ,P-GETFLAGS>
				<SETG P-GETFLAGS ,P-INHIBIT>)>)
			(<AND <SET WV <WT? .WRD ,PS?ADJECTIVE ,P1?ADJECTIVE>>
			      <NOT ,P-ADJ>>
			 <SETG P-ADJ .WV>
			 <SETG P-ADJN .WRD>)
			(<WT? .WRD ,PS?OBJECT ,P1?OBJECT>
			 <SETG P-NAM .WRD>
			 <SETG P-ONEOBJ .WRD>)>)>
	   <COND (<NOT <EQUAL? .PTR .EPTR>>
		  <SET PTR <REST .PTR ,P-WORDLEN>>
		  <SET WRD .NW>)>>>   
 
<CONSTANT SH 128>   
<CONSTANT SC 64>    
<CONSTANT SIR 32>   
<CONSTANT SOG 16>
<CONSTANT STAKE 8>  
<CONSTANT SMANY 4>  
<CONSTANT SHAVE 2>  

<ROUTINE GET-OBJECT (TBL
		    "OPTIONAL" (VRB T)
		    "AUX" BTS LEN XBITS TLEN (GCHECK <>) (OLEN 0) OBJ ADJ X)
 <SET XBITS ,P-SLOCBITS>
 <SET TLEN <GET .TBL ,P-MATCHLEN>>
 <COND (<BTST ,P-GETFLAGS ,P-INHIBIT> <RTRUE>)>
 <SET ADJ ,P-ADJN>
 <COND (<AND <NOT ,P-NAM> ,P-ADJ>
	<COND (<WT? ,P-ADJN ,PS?OBJECT ,P1?OBJECT>
	       <SETG P-NAM ,P-ADJN>
	       <SETG P-ADJ <>>)
	      (<SET BTS <WT? ,P-ADJN ,PS?DIRECTION ,P1?DIRECTION>>
	       <SETG P-ADJ <>>
	       <PUT .TBL ,P-MATCHLEN 1>
	       <PUT .TBL 1 ,INTDIR>
	       <SETG P-DIRECTION .BTS>
	       <RTRUE>)>)>
 <COND (<AND <NOT ,P-NAM>
	     <NOT ,P-ADJ>
	     <NOT <EQUAL? ,P-GETFLAGS ,P-ALL>>
	     <ZERO? ,P-GWIMBIT>>
	<COND (.VRB 
	       <NOT-IN-SENTENCE "enough nouns">)>
	<RFALSE>)>
 <COND (<OR <NOT <EQUAL? ,P-GETFLAGS ,P-ALL>> <ZERO? ,P-SLOCBITS>>
	<SETG P-SLOCBITS -1>)>
 <SETG P-TABLE .TBL>
 <PROG ()
  ;<COND (,DEBUG <TELL "[GETOBJ: GCHECK=" N .GCHECK "]" CR>)>
  <COND (.GCHECK
	 ;<COND (,DEBUG <TELL "[GETOBJ: calling GLOBAL-CHECK]" CR>)>
	 <GLOBAL-CHECK .TBL>)
	(T
	 <COND (,LIT
		<FCLEAR ,PROTAGONIST ,TRANSBIT>
		<DO-SL ,HERE ,SOG ,SIR>
		<FSET ,PROTAGONIST ,TRANSBIT>)>
	 <DO-SL ,PROTAGONIST ,SH ,SC>)>
  <SET LEN <- <GET .TBL ,P-MATCHLEN> .TLEN>>
  ;<COND (,DEBUG <TELL "[GETOBJ: LEN=" N .LEN "]" CR>)>
  <COND (<BTST ,P-GETFLAGS ,P-ALL>)
	(<AND <BTST ,P-GETFLAGS ,P-ONE>
	      <NOT <ZERO? .LEN>>>
	 <COND (<NOT <EQUAL? .LEN 1>>
		<PUT .TBL 1 <GET .TBL <RANDOM .LEN>>>
		<TELL "(How about ">
		<ARTICLE <GET .TBL 1> T>
		<TELL D <GET .TBL 1> "?)" CR>)>
	 <PUT .TBL ,P-MATCHLEN 1>)
	(<OR <G? .LEN 1>
	     <AND <ZERO? .LEN> <NOT <EQUAL? ,P-SLOCBITS -1>>>>
	 <COND (<EQUAL? ,P-SLOCBITS -1>
		<SETG P-SLOCBITS .XBITS>
		<SET OLEN .LEN>
		<PUT .TBL ,P-MATCHLEN <- <GET .TBL ,P-MATCHLEN> .LEN>>
		<AGAIN>)
	       (T
		<COND (<ZERO? .LEN> <SET LEN .OLEN>)>
		<COND ;(<AND ,P-NAM
			    ;<REMOTE-VERB?>
			    <SET OBJ <GET .TBL <+ .TLEN 1>>>
			    <SET OBJ <APPLY <GETP .OBJ ,P?GENERIC> .TBL>>>
		       <COND (<EQUAL? .OBJ ,NOT-HERE-OBJECT>
			      <RFALSE>)>
		       <PUT .TBL 1 .OBJ>
		       <PUT .TBL ,P-MATCHLEN 1>
		       <SETG P-NAM <>>
		       <SETG P-ADJ <>>
		       ;<SETG P-ADJN <>>
		       <RTRUE>)
		      (<NOT <EQUAL? ,WINNER ,PROTAGONIST>>
		       <TELL "(Please try saying that another way.)" CR>
		       <RFALSE>)
		      (<AND .VRB ,P-NAM>
		       <WHICH-PRINT .TLEN .LEN .TBL>
		       <SETG P-ACLAUSE
			     <COND (<EQUAL? .TBL ,P-PRSO> ,P-NC1)
				   (T ,P-NC2)>>
		       <SETG P-AADJ ,P-ADJ>
		       <SETG P-ANAM ,P-NAM>
		       <ORPHAN <> <>>
		       <SETG P-OFLAG T>)
		      (.VRB
		       <NOT-IN-SENTENCE "enough nouns">)>
		<SETG P-NAM <>>
		<SETG P-ADJ <>>
		<RFALSE>)>)
	(<AND <ZERO? .LEN> .GCHECK>
	 <COND (.VRB
		<SETG P-SLOCBITS .XBITS> ; "RETROFIX #33"
		<COND (<OR ,LIT <SPEAKING-VERB?>>
		       <OBJ-FOUND ,NOT-HERE-OBJECT .TBL>
		       <SETG P-XNAM ,P-NAM>
		       <SETG P-XADJ ,P-ADJ>
		       <SETG P-XADJN ,P-ADJN>
		       <SETG P-NAM <>>
		       <SETG P-ADJ <>>
		       <SETG P-ADJN <>>
		       <RTRUE>)
		      (T
		       <TOO-DARK>)>)>
	 <SETG P-NAM <>>
	 <SETG P-ADJ <>>
	 <RFALSE>)
	(<ZERO? .LEN>
	 <SET GCHECK T>
	 ;<COND (,DEBUG <TELL "[GETOBJ: GCHECK set to " N .GCHECK "]" CR>)>
	 <AGAIN>)>
  <SET X <GET .TBL <+ .TLEN 1>>>
  <COND (<AND ,P-ADJ <NOT ,P-NAM> .X>
	 <TELL ,I-ASSUME " ">
	 <ARTICLE .X T>
	 <TELL D .X ".)" CR>)>
  <SETG P-SLOCBITS .XBITS>
  <SETG P-NAM <>>
  <SETG P-ADJ <>>
  <RTRUE>>>

<ROUTINE SPEAKING-VERB? ("OPTIONAL" (V <>))
	 <COND (<NOT .V> 
		<SET V ,PRSA>)>
	 <COND (<OR <EQUAL? .V ,V?ASK-ABOUT ,V?ASK-FOR ,V?HELLO>
		    <EQUAL? .V ,V?TELL ,V?QUESTION ,V?REPLY>
		    ;<EQUAL? .V ,V?WHAT-ABOUT ,V?GOODBYE>>
	       <RTRUE>)
	       (T
		<RFALSE>)>>

<GLOBAL P-MOBY-FOUND <>>

; <GLOBAL P-MOBY-FLAG <>> ; "Needed only for ZIL"

; "This MOBY-FIND works in ZIP only!"

<ROUTINE MOBY-FIND (TBL "AUX" (OBJ 1) LEN FOO)
         <SETG P-NAM ,P-XNAM>
         <SETG P-ADJ ,P-XADJ>
         <PUT .TBL ,P-MATCHLEN 0>
         <REPEAT ()
		 <COND (<AND <SET FOO <META-LOC .OBJ>>
			     <SET FOO <THIS-IT? .OBJ>>>
			<SET FOO <OBJ-FOUND .OBJ .TBL>>)>
		 <COND (<IGRTR? OBJ ,DUMMY-OBJECT>
			<RETURN>)>>
	 <SET LEN <GET .TBL ,P-MATCHLEN>>
	 <COND (<EQUAL? .LEN 1>
		<SETG P-MOBY-FOUND <GET .TBL 1>>)>
	 .LEN>

; "This MOBY-FIND works in both ZIL and ZIP."

; <ROUTINE MOBY-FIND (TBL "AUX" (OBJ 1) LEN FOO)
           <SETG P-NAM ,P-XNAM>
           <SETG P-ADJ ,P-XADJ>
           <PUT .TBL ,P-MATCHLEN 0>
           <COND (<NOT <ZERO? <GETB 0 18>>>	;"ZIP case"
	          <REPEAT ()
		          <COND (<AND <SET FOO <META-LOC .OBJ>>
			              <SET FOO <THIS-IT? .OBJ>>>
			         <SET FOO <OBJ-FOUND .OBJ .TBL>>)>
		          <COND (<IGRTR? OBJ ,DUMMY-OBJECT>
			         <RETURN>)>>
	          <SET LEN <GET .TBL ,P-MATCHLEN>>
	          <COND (<EQUAL? .LEN 1>
		         <SETG P-MOBY-FOUND <GET .TBL 1>>)>
	          .LEN)
	         (T		;"ZIL case"
	          <SETG P-MOBY-FLAG T>
	          <SETG P-TABLE .TBL>
	          <SETG P-SLOCBITS -1>
	          <SET FOO <FIRST? ,ROOMS>>
	          <REPEAT ()
		          <COND (<NOT .FOO>
				 <RETURN>)
		                (T
			         <SEARCH-LIST .FOO .TBL ,P-SRCALL>
			         <SET FOO <NEXT? .FOO>>)>>
		  <COND (<EQUAL? <SET LEN <GET .TBL ,P-MATCHLEN>> 0>
		         <DO-SL ,LOCAL-GLOBALS 1 1>)>
	          <COND (<EQUAL? <SET LEN <GET .TBL ,P-MATCHLEN>> 0>
		         <DO-SL ,ROOMS 1 1>)>
	          <COND (<EQUAL? <SET LEN <GET .TBL ,P-MATCHLEN>> 1>
		         <SETG P-MOBY-FOUND <GET .TBL 1>>)>
	          <SETG P-MOBY-FLAG <>>
	          .LEN)>>

<ROUTINE WHICH-PRINT (TLEN LEN TBL "AUX" OBJ RLEN)
	 <SET RLEN .LEN>
	 <TELL "Which">
         <COND (<OR ,P-OFLAG ,P-MERGED ,P-AND> <TELL " "> <PRINTB ,P-NAM>)
	       (<EQUAL? .TBL ,P-PRSO>
		<CLAUSE-PRINT ,P-NC1 ,P-NC1L <>>)
	       (T <CLAUSE-PRINT ,P-NC2 ,P-NC2L <>>)>
	 <TELL " do you mean,">
	 <REPEAT ()
		 <SET TLEN <+ .TLEN 1>>
		 <SET OBJ <GET .TBL .TLEN>>
		 <TELL " ">
		 <ARTICLE .OBJ T>
		 <TELL D .OBJ>
		 <COND (<EQUAL? .LEN 2>
		        <COND (<NOT <EQUAL? .RLEN 2>> <TELL ",">)>
		        <TELL " or">)
		       (<G? .LEN 2> <TELL ",">)>
		 <COND (<L? <SET LEN <- .LEN 1>> 1>
		        <TELL "?" CR>
		        <RETURN>)>>>

<ROUTINE GLOBAL-CHECK (TBL "AUX" LEN RMG RMGL (CNT 0) OBJ OBITS FOO) 
	<SET LEN <GET .TBL ,P-MATCHLEN>>
	<SET OBITS ,P-SLOCBITS>
	<COND (<SET RMG <GETPT ,HERE ,P?GLOBAL>>
	       <SET RMGL <- <PTSIZE .RMG> 1>>
	       ;<COND (,DEBUG <TELL "[GLBCHK: (LG) RMGL=" N .RMGL "]" CR>)>
	       <REPEAT ()
		       <SET OBJ <GETB .RMG .CNT>>
		       <COND (<FIRST? .OBJ>
			      <SEARCH-LIST .OBJ .TBL ,P-SRCALL>)>
		       <COND (<THIS-IT? .OBJ>
			      <OBJ-FOUND .OBJ .TBL>)>
		       <COND (<IGRTR? CNT .RMGL> <RETURN>)>>)>
	<COND (<SET RMG <GETPT ,HERE ,P?PSEUDO>>
	       <SET RMGL <- </ <PTSIZE .RMG> 4> 1>>
	       <SET CNT 0>
	       ;<COND (,DEBUG <TELL "[GLBCHK: (PS) RMGL=" N .RMGL "]" CR>)>
	       <REPEAT ()
		       <COND (<EQUAL? ,P-NAM <GET .RMG <* .CNT 2>>>
			      <SETG LAST-PSEUDO-LOC ,HERE>
			      <PUTP ,PSEUDO-OBJECT
				    ,P?ACTION
				    <GET .RMG <+ <* .CNT 2> 1>>>
			      <SET FOO
				   <BACK <GETPT ,PSEUDO-OBJECT ,P?ACTION> 5>>
			      <PUT .FOO 0 <GET ,P-NAM 0>>
			      <PUT .FOO 1 <GET ,P-NAM 1>>
			      <OBJ-FOUND ,PSEUDO-OBJECT .TBL>
			      <RETURN>)
		             (<IGRTR? CNT .RMGL> <RETURN>)>>)>
	<COND (<EQUAL? <GET .TBL ,P-MATCHLEN> .LEN>
	       <SETG P-SLOCBITS -1>
	       <SETG P-TABLE .TBL>
	       <DO-SL ,GLOBAL-OBJECTS 1 1>
	       <SETG P-SLOCBITS .OBITS>
	       <COND (<ZERO? <GET .TBL ,P-MATCHLEN>>
		      <COND (<VERB? EXAMINE DUMB-EXAMINE LOOK-INSIDE FIND
				    FOLLOW LEAVE SEARCH SMELL THROUGH WALK-TO
				    WAIT-FOR LOOK-ON>
			     <DO-SL ,ROOMS 1 1>)>)>)>>

<ROUTINE DO-SL (OBJ BIT1 BIT2 "AUX" BITS) 
	<COND (<BTST ,P-SLOCBITS <+ .BIT1 .BIT2>>
	       <SEARCH-LIST .OBJ ,P-TABLE ,P-SRCALL>)
	      (T
	       <COND (<BTST ,P-SLOCBITS .BIT1>
		      <SEARCH-LIST .OBJ ,P-TABLE ,P-SRCTOP>)
		     (<BTST ,P-SLOCBITS .BIT2>
		      <SEARCH-LIST .OBJ ,P-TABLE ,P-SRCBOT>)
		     (T <RTRUE>)>)>>  

<CONSTANT P-SRCBOT 2>    

<CONSTANT P-SRCTOP 0>    

<CONSTANT P-SRCALL 1>    

<ROUTINE SEARCH-LIST (OBJ TBL LVL)
   <SET OBJ <FIRST? .OBJ>>
   <COND (.OBJ
	  <REPEAT ()
	        <COND (<AND <NOT <EQUAL? .LVL ,P-SRCBOT>>
			    <GETPT .OBJ ,P?SYNONYM>
			    <THIS-IT? .OBJ>>
		       <OBJ-FOUND .OBJ .TBL>)>
		<COND (<AND <OR <NOT <EQUAL? .LVL ,P-SRCTOP>>
			      ; <FSET? .OBJ ,SEARCHBIT>
				<FSET? .OBJ ,SURFACEBIT>>
			    <FIRST? .OBJ>
			    <SEE-INSIDE? .OBJ>
			  ; <OR <SEE-INSIDE? .OBJ>
			        <FSET? .OBJ ,SURFACEBIT> ; "ADDED 3/26/85"
			        <FSET? .OBJ ,OPENBIT>
			        <FSET? .OBJ ,TRANSBIT>
			        ,P-MOBY-FLAG ; "Needed only for ZIL"
			        <AND <FSET? .OBJ ,ACTORBIT>
				     <NOT <EQUAL? .OBJ ,PROTAGONIST>>>>
			  ; <NOT <EQUAL? .OBJ ,PROTAGONIST ,LOCAL-GLOBALS>>>
		       <SEARCH-LIST .OBJ .TBL
				    <COND (<FSET? .OBJ ,SURFACEBIT>
					   ,P-SRCALL)
					; (<FSET? .OBJ ,SEARCHBIT>
					   ,P-SRCALL)
					  (T
					   ,P-SRCTOP)>>)>
		<COND (<SET OBJ <NEXT? .OBJ>>) (T <RETURN>)>>)>>

<ROUTINE THIS-IT? (OBJ "AUX" SYNS) 
 <COND (<FSET? .OBJ ,INVISIBLE>
	<RFALSE>)
       (<AND ,P-NAM
	     <OR <NOT <SET SYNS <GETPT .OBJ ,P?SYNONYM>>>
		 <NOT <ZMEMQ ,P-NAM .SYNS <- </ <PTSIZE .SYNS> 2> 1>>>>>
	<RFALSE>)
       (<AND ,P-ADJ
	     <OR <NOT <SET SYNS <GETPT .OBJ ,P?ADJECTIVE>>>
		 <NOT <ZMEMQB ,P-ADJ .SYNS <- <PTSIZE .SYNS> 1>>>>>
	<RFALSE>)
       (<AND <NOT <ZERO? ,P-GWIMBIT>> <NOT <FSET? .OBJ ,P-GWIMBIT>>>
	<RFALSE>)>
 <RTRUE>>

<ROUTINE OBJ-FOUND (OBJ TBL "AUX" PTR) 
        <SET PTR <GET .TBL ,P-MATCHLEN>>
	<PUT .TBL <+ .PTR 1> .OBJ>
	<PUT .TBL ,P-MATCHLEN <+ .PTR 1>>> 
 
<ROUTINE TAKE-CHECK () 
	<AND <ITAKE-CHECK ,P-PRSO <GETB ,P-SYNTAX ,P-SLOC1>>
	     <ITAKE-CHECK ,P-PRSI <GETB ,P-SYNTAX ,P-SLOC2>>>> 

<ROUTINE ITAKE-CHECK (TBL BITS "AUX" PTR OBJ TAKEN) 
<COND (<AND <SET PTR <GET .TBL ,P-MATCHLEN>>
	     <OR <BTST .BITS ,SHAVE>
		 <BTST .BITS ,STAKE>>>
	<REPEAT ()
	 <COND (<L? <SET PTR <- .PTR 1>> 0> <RETURN>)>
	 <SET OBJ <GET .TBL <+ .PTR 1>>>
	 <COND (<EQUAL? .OBJ ,IT>
		<COND (<NOT <ACCESSIBLE? ,P-IT-OBJECT>>
		       <REFERRING ;MORE-SPECIFIC>
		       <RFALSE>)
		      (T
		       <SET OBJ ,P-IT-OBJECT>)>)
	       (<EQUAL? .OBJ ,HER>
		<COND (<NOT <ACCESSIBLE? ,P-HER-OBJECT>>
		       <REFERRING ;MORE-SPECIFIC>
		       <RFALSE>)
		      (T
		       <SET OBJ ,P-HER-OBJECT>)>)
	       (<EQUAL? .OBJ ,HIM>
		<COND (<NOT <ACCESSIBLE? ,P-HIM-OBJECT>>
		       <REFERRING ;MORE-SPECIFIC>
		       <RFALSE>)
		      (T
		       <SET OBJ ,P-HIM-OBJECT>)>)
	       (<EQUAL? .OBJ ,THEM>
		<COND (<NOT <ACCESSIBLE? ,P-THEM-OBJECT>>
		       <REFERRING ;MORE-SPECIFIC>
		       <RFALSE>)
		      (T
		       <SET OBJ ,P-THEM-OBJECT>)>)>
	 <COND (<AND <NOT <HELD? .OBJ>>
		     <NOT <EQUAL? .OBJ ,HANDS>>>
		<SETG PRSO .OBJ>
		<COND (<FSET? .OBJ ,TRYTAKEBIT>
		       <SET TAKEN T>)
		      (<NOT <EQUAL? ,WINNER ,PROTAGONIST>>
		       <SET TAKEN <>>)
		      (<AND <BTST .BITS ,STAKE>
			    <EQUAL? <ITAKE <>> T>>
		       <SET TAKEN <>>)
		      (T
		       <SET TAKEN T>)>
		<COND (<AND .TAKEN <BTST .BITS ,SHAVE>>
		       ;<TELL "(">
		       ;<HE-SHE-IT ,WINNER T "do" ;"is"> 
		       <TELL "(You don't seem to be holding">
		       <COND (<L? 1 <GET .TBL ,P-MATCHLEN>>
			      <TELL " all those things">)
			     (<EQUAL? .OBJ ,NOT-HERE-OBJECT>
			      <TELL " that">)
			     (T
			      <THIS-IS-IT .OBJ>
			      <TELL " ">
			      <ARTICLE .OBJ T>
			      <TELL D .OBJ>)>
		       <TELL "!)" CR>
		       <RFALSE>)
		      (<AND <NOT .TAKEN> <EQUAL? ,WINNER ,PROTAGONIST>>
		       <TELL "(taking ">
		       <ARTICLE ,PRSO T>
		       <TELL D ,PRSO>
		       <COND (,ITAKE-LOC
			      <TELL " from ">
			      <ARTICLE ,ITAKE-LOC T>
			      <TELL D ,ITAKE-LOC>)>
		       <TELL " first)" CR>)>)>>)
       (T)>>  

<ROUTINE MANY-CHECK ("AUX" (LOSS <>) TMP) 
        <COND (<AND <G? <GET ,P-PRSO ,P-MATCHLEN> 1>
		    <NOT <BTST <GETB ,P-SYNTAX ,P-SLOC1> ,SMANY>>>
	       <SET LOSS 1>)
	      (<AND <G? <GET ,P-PRSI ,P-MATCHLEN> 1>
		    <NOT <BTST <GETB ,P-SYNTAX ,P-SLOC2> ,SMANY>>>
	       <SET LOSS 2>)>
	<COND (.LOSS
	     ; <TELL "(" ,CANT " use more than one ">
	     ; <COND (<EQUAL? .LOSS 2>
		      <TELL "in">)>
	     ; <TELL "direct object with \"">
	       <TELL "(" ,CANT " use more than one object at a time with \"">
	       <SET TMP <GET ,P-ITBL ,P-VERBN>>
	       <COND (<ZERO? .TMP>
		      <TELL "tell">)
		     (<OR ,P-OFLAG ,P-MERGED>
		      <PRINTB <GET .TMP 0>>)
		     (T
		      <WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>)>
	       <TELL ".\")" CR>
	       <RFALSE>)
	      (T
	       <RTRUE>)>>

<ROUTINE ZMEMQ (ITM TBL "OPTIONAL" (SIZE -1) "AUX" (CNT 1)) 
	<COND (<NOT .TBL> <RFALSE>)>
	<COND (<NOT <L? .SIZE 0>> <SET CNT 0>)
	      (ELSE <SET SIZE <GET .TBL 0>>)>
	<REPEAT ()
		<COND (<EQUAL? .ITM <GET .TBL .CNT>>
		       <COND (<ZERO? .CNT> <RTRUE>)
			     (T <RETURN .CNT>)>)
		      (<IGRTR? CNT .SIZE> <RFALSE>)>>>

; <ROUTINE ZMEMZ (ITM TBL "AUX" (CNT 0)) 
	<COND (<NOT .TBL> <RFALSE>)>
	<REPEAT ()
		<COND (<ZERO? <GET .TBL .CNT>>
		       <RFALSE>)
		      (<EQUAL? .ITM <GET .TBL .CNT>>
		       <COND (<ZERO? .CNT> <RTRUE>)
			     (T <RETURN .CNT>)>)
		      (T <INC CNT>)>>>

<ROUTINE ZMEMQB (ITM TBL SIZE "AUX" (CNT 0)) 
	<REPEAT ()
		<COND (<EQUAL? .ITM <GETB .TBL .CNT>>
		       <COND (<ZERO? .CNT> <RTRUE>)
			     (T <RETURN .CNT>)>)
		      (<IGRTR? CNT .SIZE> <RFALSE>)>>>

<GLOBAL ALWAYS-LIT? <>>
 
<ROUTINE LIT? (RM "OPTIONAL" (RMBIT T) "AUX" OHERE (LIT <>))
	<COND (<AND ,ALWAYS-LIT?
		    <EQUAL? ,WINNER ,PROTAGONIST>>
	       <RTRUE>)
	      (,ECLIPSE?
	       <RFALSE>)>
	<SETG P-GWIMBIT ,ONBIT>
	<SET OHERE ,HERE>
	<SETG HERE .RM>
	<COND (<AND .RMBIT
		    <FSET? .RM ,ONBIT>>
	       <SET LIT T>)
	      (T
	       <PUT ,P-MERGE ,P-MATCHLEN 0>
	       <SETG P-TABLE ,P-MERGE>
	       <SETG P-SLOCBITS -1>
	       <COND (<EQUAL? .OHERE .RM>
		      <DO-SL ,WINNER 1 1>
		      <COND (<AND <NOT <EQUAL? ,WINNER ,PROTAGONIST>>
				  <IN? ,PROTAGONIST .RM>>
			     <DO-SL ,PROTAGONIST 1 1>)>)>
	       <DO-SL .RM 1 1>
	       <COND (<G? <GET ,P-TABLE ,P-MATCHLEN> 0>
		      <SET LIT T>)>)>
	<SETG HERE .OHERE>
	<SETG P-GWIMBIT 0>
	.LIT>

; <ROUTINE PICK-ONE (FROB)
	 <GET .FROB <RANDOM <GET .FROB 0>>>>

<ROUTINE PICK-ONE (FROB "OPTIONAL" (THIS <>) "AUX" L CNT RND MSG RFROB)
	 <SET L <GET .FROB 0>>
	 <SET CNT <GET .FROB 1>>
	 <SET L <- .L 1>>
	 <SET FROB <REST .FROB 2>>
	 <SET RFROB <REST .FROB <* .CNT 2>>>
	 <COND (<AND .THIS 
		     <ZERO? .CNT>>
		<SET RND .THIS>)
	       (T 
		<SET RND <RANDOM <- .L .CNT>>>)>
	 <SET MSG <GET .RFROB .RND>>
	 <PUT .RFROB .RND <GET .RFROB 1>>
	 <PUT .RFROB 1 .MSG>
	 <SET CNT <+ .CNT 1>>
	 <COND (<EQUAL? .CNT .L> 
		<SET CNT 0>)>
	 <PUT .FROB 0 .CNT>
	 .MSG>

<ROUTINE DONT-HAVE? (OBJ "AUX" WHERE)
	 <SET WHERE <LOC .OBJ>>
	 <COND (<EQUAL? .WHERE ,PROTAGONIST>
		<RFALSE>)
	     ; (<AND <EQUAL? .OBJ ,MILK>
		     <IN? ,MILK ,BOTTLE>
		     <IN? ,BOTTLE ,PROTAGONIST>>
		<RFALSE>)
	       (<IN? .WHERE ,PROTAGONIST>
		<TELL "You'll have to take ">
		<ARTICLE .OBJ T>
		<TELL D .OBJ " ">
		<COND (<FSET? .WHERE ,CONTBIT>
		       <TELL "out">)
		      (T
		       <TELL "off">)>
		<TELL " of ">
		<ARTICLE .WHERE T>
		<TELL D .WHERE " first." CR>
		<RTRUE>)
	       (T
		<NOT-HOLDING .OBJ>
		<RTRUE>)>>

<ROUTINE NOT-HOLDING ("OPTIONAL" (OBJ <>))
	 <TELL "You're not holding ">
	 <COND (.OBJ
		<ARTICLE .OBJ T>
		<PRINTD .OBJ>)
	       (T
		<TELL "that">)>
	 <TELL "." CR>>

<ROUTINE ASKING? (ACTOR)
	 <COND (<AND <VERB? ASK-ABOUT ASK-FOR QUESTION ; WHAT-ABOUT>
		     <EQUAL? ,PRSO .ACTOR>>
	        <RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE TALKING-TO? (ACTOR)
	 <COND (<ASKING? .ACTOR>
		<RTRUE>)
	       (<AND <VERB? TELL HELLO WAVE-AT REPLY ALARM ; GOODBYE>
		     <EQUAL? ,PRSO .ACTOR>>
	        <RTRUE>) 
	       (T
		<RFALSE>)>>

<ROUTINE TOUCHING? (THING)
	 <COND (<OR <EQUAL? ,PRSA ,V?TAKE ,V?RUB ,V?SHAKE>
		    <EQUAL? ,PRSA ,V?SWING ,V?PLAY ,V?SPIN>
		    <EQUAL? ,PRSA ,V?CLEAN ,V?PUT ,V?PUT-ON>
		    <EQUAL? ,PRSA ,V?MOVE ,V?PULL ,V?PUSH>
		    <EQUAL? ,PRSA ,V?PUT-UNDER ,V?PUT-BEHIND ,V?SMELL>
		    <EQUAL? ,PRSA ,V?KISS>
		    <HURT? .THING>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE HURT? (THING)
	 <COND (<AND <OR <EQUAL? ,PRSA ,V?MUNG ,V?KICK ,V?KILL>
			 <EQUAL? ,PRSA ,V?KNOCK ,V?SQUEEZE ,V?CUT>
			 <EQUAL? ,PRSA ,V?BITE ,V?RAPE ,V?SHAKE>>
		     <EQUAL? ,PRSO .THING>>
		<RTRUE>)
	       (<AND <VERB? THROW>
		     <EQUAL? ,PRSI .THING>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE ENTER-FROM? (ENTRY "OPTIONAL" (DEST <>) (PLACE <>))
	 <COND (<VERB? WALK-TO THROUGH ENTER>
		<COND (<EQUAL? ,HERE .ENTRY>
		       <DO-WALK ,P?IN>)
		      (<AND .DEST .PLACE
		            <EQUAL? ,HERE .DEST>>
		       <ALREADY-IN .PLACE>)
		      (T
		       <HOW?>)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE USE-DOOR? (OUTSIDE)
	 <COND (<VERB? WALK-TO ENTER THROUGH USE>
		<COND (<EQUAL? ,HERE .OUTSIDE>
		       <DO-WALK ,P?IN>)
		      (T
		       <DO-WALK ,P?OUT>)>
		<RTRUE>)
	       (<VERB? EXIT>
		<COND (<EQUAL? ,HERE .OUTSIDE>
		       <V-WALK-AROUND>)
		      (T
		       <DO-WALK ,P?OUT>)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE ANYONE-HERE? ("AUX" OBJ)
	 <COND (<AND <EQUAL? ,HERE ,CLIFF-BOTTOM>
		     <IN? ,VULTURE ,GNARLED-TREE>>
		<RETURN ,VULTURE>)
	       (T
		<SET OBJ <FIRST? ,HERE>>
	        <REPEAT ()
	                <COND (<NOT .OBJ>
			       <RETURN>)
			      (<AND <FSET? .OBJ ,ACTORBIT>
				    <NOT <EQUAL? .OBJ ,PROTAGONIST ,VULTURE
						      ,ALEXIS>>>
		               <RETURN>)
		              (T
			       <SET OBJ <NEXT? .OBJ>>)>>
	        <RETURN .OBJ>)>>

<ROUTINE FIXED-FONT-ON () 
	 <PUT 0 8 <BOR <GET 0 8> 2>>>

<ROUTINE FIXED-FONT-OFF ()
	 <PUT 0 8 <BAND <GET 0 8> -3>>>

<ROUTINE GETTING-INTO? ()
	 <COND (<OR <EQUAL? ,PRSA ,V?WALK-TO ,V?THROUGH ,V?ENTER>
		    <EQUAL? ,PRSA ,V?SIT ,V?STAND-ON ,V?LIE-DOWN>
		    <EQUAL? ,PRSA ,V?CLIMB-UP ,V?CLIMB-ON ,V?LEAP>
		    <EQUAL? ,PRSA ,V?SWIM ,V?WEAR ,V?WALK-AROUND>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE SAY-THE (THING)
	 <TELL "The " D .THING>>

<ROUTINE BUT-THE (THING)
	 <TELL "But ">
	 <ARTICLE .THING T>
	 <TELL D .THING " ">>

<ROUTINE MOVING? (THING)
	 <COND (<AND <OR <EQUAL? ,PRSA ,V?MOVE ,V?PULL ,V?PUSH>
		         <EQUAL? ,PRSA ,V?TAKE ,V?TURN ,V?PUSH-TO>
		         <EQUAL? ,PRSA ,V?RAISE ,V?SPIN ,V?SHAKE>>
		     <EQUAL? ,PRSO .THING>>
		<RTRUE>)
	       (T
		<RFALSE>)>> 

<OBJECT NOT-HERE-OBJECT
	(DESC "that")
	(FLAGS NARTICLEBIT)
	(ACTION NOT-HERE-OBJECT-F)>

<ROUTINE NOT-HERE-OBJECT-F ("AUX" TBL (PRSO? T) OBJ ; (X <>))
	 <COND (<AND <EQUAL? ,PRSO ,NOT-HERE-OBJECT>
		     <EQUAL? ,PRSI ,NOT-HERE-OBJECT>>
		<TELL "Those things aren't here!" CR>
		<RTRUE>)
	       (<EQUAL? ,PRSO ,NOT-HERE-OBJECT>
		<SET TBL ,P-PRSO>)
	       (T
		<SET TBL ,P-PRSI>
		<SET PRSO? <>>)>
	       
	<COND (.PRSO?
		<COND (<OR <EQUAL? ,PRSA ,V?FIND ,V?FOLLOW ,V?BUY>
			   <EQUAL? ,PRSA ,V?WAIT-FOR ; ,V?WALK-TO ; ,V?PLAY>
			   <AND <EQUAL? ,PRSA ,V?TAKE>
				<NOT <EQUAL? ,WINNER ,PROTAGONIST>>>>
		       <COND (<SET OBJ <FIND-NOT-HERE .TBL .PRSO?>>
			      <COND (<NOT <EQUAL? .OBJ ,NOT-HERE-OBJECT>>
				     <RFATAL>)>)
			     (T
			      <RFALSE>)>)>)
	       (T
		<COND (<EQUAL? ,PRSA ,V?TELL ,V?ASK-ABOUT ,V?ASK-FOR>
		       <RFALSE>)>)>
	 
	 <TELL ,CANT " see">
	 <COND (<EQUAL? ,P-XNAM ,W?GRAVEDIGGER ,W?DIGGER ,W?ONE>
		<TELL " the">)
	       (<NOT <NAME? ,P-XNAM>>
		<TELL " any">)>
	 <NOT-HERE-PRINT .PRSO?>
	 <TELL " here!">
	 <COND (<EQUAL? ,HERE ,FUZZY>
		<TELL " Everything is too " <PICK-ONE ,BLURS> ".">)>
       	 <CRLF>
	 <PCLEAR>
	 <RFATAL>>

<ROUTINE FIND-NOT-HERE (TBL PRSO? "AUX" M-F OBJ)
	<SET M-F <MOBY-FIND .TBL>>
	;<COND (,DEBUG
	       <TELL "[Found " N .M-F " obj]" CR>)>
	<COND (<EQUAL? 1 .M-F>
	       ;<COND (,DEBUG <TELL "[Namely: " D ,P-MOBY-FOUND "]" CR>)>
	       <COND (.PRSO?
		      <SETG PRSO ,P-MOBY-FOUND>)
		     (T
		      <SETG PRSI ,P-MOBY-FOUND>)>
	       <RFALSE>)
	      ;(<EQUAL? ,PRSA ,V?TELL ,V?ASK-FOR ,V?ASK-ABOUT>
	       <RFALSE>)
	      (<NOT .PRSO?>
	       <TELL "You wouldn't find any">
	       <NOT-HERE-PRINT .PRSO?>
	       <TELL " there." CR>
	       <RTRUE>)
	      (T
	       ,NOT-HERE-OBJECT)>>

; <ROUTINE GLOBAL-NOT-HERE-PRINT (OBJ "AUX" TARGET)
	 <PCLEAR>
	 <COND (<EQUAL? .OBJ ,PRSO>
		<SET TARGET ,PRSO>)
	       (T
		<SET TARGET ,PRSI>)>
	 <YOU-CANT-SEE>
	 <COND (<NOT <FSET? .TARGET ,ACTORBIT>>
		<TELL "any ">)>
	 <TELL D .TARGET " here!" CR>>

<ROUTINE NOT-HERE-PRINT ("OPTIONAL" (PRSO? <>))
	 <COND (,P-OFLAG
	        <COND (,P-XADJ
		       <TELL " ">
		       <PRINTB ,P-XADJN>)>
	        <COND (,P-XNAM
		       <TELL " ">
		       <PRINTB ,P-XNAM>)>)
               (.PRSO?
	        <BUFFER-PRINT <GET ,P-ITBL ,P-NC1> <GET ,P-ITBL ,P-NC1L> <>>)
               (T
	        <BUFFER-PRINT <GET ,P-ITBL ,P-NC2> <GET ,P-ITBL ,P-NC2L> <>>)>>

<OBJECT C-OBJECT>
	
<ROUTINE PRINT-CONTENTS (THING "AUX" OBJ NXT (1ST? T) (IT? <>) (TWO? <>))
	 <SET OBJ <FIRST? .THING>>
	 <REPEAT ()
		<COND (.OBJ
		       <SET NXT <NEXT? .OBJ>>
		       <COND (<OR <FSET? .OBJ ,INVISIBLE>
				  ; <FSET? .OBJ ,NDESCBIT>
				  <EQUAL? .OBJ ,WINNER>>
			      <MOVE .OBJ ,C-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>
	 <SET OBJ <FIRST? .THING>>
	 <COND (<NOT .OBJ>
		<TELL "nothing " <PICK-ONE ,YAWNS>>)
	       (T
		<REPEAT ()
		        <COND (.OBJ
		               <SET NXT <NEXT? .OBJ>>
		               <COND (.1ST?
			              <SET 1ST? <>>)
			             (T
			              <COND (.NXT
				             <TELL ", ">)
				            (T
				             <TELL " and ">)>)>
		               <ARTICLE .OBJ>
		               <COND (,FUZZY?
				      <TELL <PICK-ONE ,BLURS> " ">)>
			       <TELL D .OBJ>
		               <COND (<FSET? .OBJ ,WORNBIT>
			              <TELL " (being worn)">)>
			       <COND (<FSET? .OBJ ,ONBIT>
				      <TELL " (providing light)">)>
		               <COND (<AND <EQUAL? .OBJ ,BROOM>
					   <IN? ,BROOM ,PROTAGONIST>
					   ,BROOM-SIT?>
				      <TELL " (on which you're sitting)">)>
			       <COND (<AND <NOT .IT?>
				           <NOT .TWO?>>
			              <SET IT? .OBJ>)
			             (T
			              <SET TWO? T>
			              <SET IT? <>>)>
		               <SET OBJ .NXT>)
			      (T
		               <COND (<AND .IT?
				           <NOT .TWO?>>
			              <THIS-IS-IT .IT?>)>
		               <RETURN>)>>)>
	 <MOVE-ALL ,C-OBJECT .THING>>

<ROUTINE MOVE-ALL (FROM TO "AUX" OBJ NXT)
	 <SET OBJ <FIRST? .FROM>>
	 <REPEAT ()
		 <COND (.OBJ
		        <SET NXT <NEXT? .OBJ>>
		        <FCLEAR .OBJ ,WORNBIT>
			<MOVE .OBJ .TO>
		        <SET OBJ .NXT>)
		       (T
		        <RTRUE>)>>>

<ROUTINE DESCRIBE-OBJECTS ("AUX" OBJ NXT STR (1ST? T) (TWO? <>) (IT? <>))
	 <COND (<NOT ,LIT>
	        <TOO-DARK>
	        <RTRUE>)>
       
      ; "Hide invisible objects"

	<SET OBJ <FIRST? ,HERE>>
	<COND (<NOT .OBJ>
	       <RTRUE>)>
	
	<REPEAT ()
		<COND (.OBJ
		       <SET NXT <NEXT? .OBJ>>
		       <COND (<OR <FSET? .OBJ ,INVISIBLE>
				  <FSET? .OBJ ,NDESCBIT>
				  <EQUAL? .OBJ ,WINNER>>
			      <MOVE .OBJ ,DUMMY-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>
	
      ; "Apply all FDESCs and eliminate those objects"
	
	<SET OBJ <FIRST? ,HERE>>
	<REPEAT ()
		<COND (.OBJ
		       <SET NXT <NEXT? .OBJ>>
		       <SET STR <GETP .OBJ ,P?FDESC>>
		       <COND (<AND .STR
				   <NOT <FSET? .OBJ ,TOUCHBIT>>>
			      <TELL CR .STR CR>
			      <MOVE .OBJ ,DUMMY-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>

      ; "Apply all DESCFCNs and hide those objects"
	
       <SET OBJ <FIRST? ,HERE>>
       <REPEAT ()
		<COND (.OBJ
		       <SET NXT <NEXT? .OBJ>>
		       <SET STR <GETP .OBJ ,P?DESCFCN>>
		       <COND (.STR
		              <CRLF>
			      <SET STR <APPLY .STR ,M-OBJDESC>>
			      <CRLF>
			      <MOVE .OBJ ,DUMMY-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>
     
       ; "Print whatever's left in a nice sentence"
	
	<SET OBJ <FIRST? ,HERE>>
	<COND (.OBJ
	       <REPEAT ()
		       <COND (.OBJ
		              <SET NXT <NEXT? .OBJ>>
		              <COND (.1ST?
			             <SET 1ST? <>>
			             <CRLF>
			             <COND (.NXT
				            <TELL ,YOU-SEE>)
				           (T
				            <TELL "There's ">)>)
			            (T
			             <COND (.NXT
				            <TELL ", ">)
				           (T
				            <TELL " and ">)>)>
			      <ARTICLE .OBJ>
		              <TELL D .OBJ>
		              <COND (<FSET? .OBJ ,ONBIT>
				     <TELL " (providing light)">)>
			      <COND (<AND <SEE-INSIDE? .OBJ>
				          <SEE-ANYTHING-IN? .OBJ>
					  <NOT <EQUAL? .OBJ ,COAT>>>
			             <TELL " with ">
			             <PRINT-CONTENTS .OBJ>
			             <COND (<FSET? .OBJ ,CONTBIT>
				            <TELL " in">)
				           (T
				            <TELL " on">)>
			             <TELL " it">)>
		              <COND (<AND <NOT .IT?>
				          <NOT .TWO?>>
			             <SET IT? .OBJ>)
			            (T
			             <SET TWO? T>
			             <SET IT? <>>)>
		              <SET OBJ .NXT>)
		             (T
		              <COND (<AND .IT?
				          <NOT .TWO?>>
			             <THIS-IS-IT .IT?>)>
		              <TELL " here." CR>
		              <RETURN>)>>)>
	<MOVE-ALL ,DUMMY-OBJECT ,HERE>>

<ROUTINE SEE-ANYTHING-IN? (THING "AUX" OBJ NXT (ANY? <>))
	 <SET OBJ <FIRST? .THING>>
	 <REPEAT ()
		 <COND (.OBJ
			<COND (<AND <NOT <FSET? .OBJ ,INVISIBLE>>
				    <NOT <FSET? .OBJ ,NDESCBIT>>
				    <NOT <EQUAL? .OBJ ,WINNER>>>
			       <SET ANY? T>
			       <RETURN>)>
			<SET OBJ <NEXT? .OBJ>>)
		       (T
			<RETURN>)>>
	 <RETURN .ANY?>>

<ROUTINE GLOBAL-IN? (OBJ1 OBJ2 "AUX" T)
	 <COND (<SET T <GETPT .OBJ2 ,P?GLOBAL>>
		<ZMEMQB .OBJ1 .T <- <PTSIZE .T> 1>>)>>

<ROUTINE ARTICLE (OBJ "OPTIONAL" (THE <>))
	 <COND (<FSET? .OBJ ,NARTICLEBIT>
		<RFALSE>)
	       (.THE
		<TELL "the ">)
	       (<FSET? .OBJ ,VOWELBIT>
		<TELL "an ">)
	       (T
		<TELL "a ">)>>

<GLOBAL YOU-SEE "You can see ">
<GLOBAL YOU-HEAR "You can hear ">

<ROUTINE HELD? (OBJ)
	 <COND (<NOT .OBJ>
		<RFALSE>)
	       (<IN? .OBJ ,PROTAGONIST>
		<RTRUE>)
	       (<IN? .OBJ ,WINNER>
		<RTRUE>)
	       (<NOT <FSET? .OBJ ,TAKEBIT>>
		<RFALSE>)
	       (<IN? .OBJ ,ROOMS>
		<RFALSE>)
	       (<IN? .OBJ ,GLOBAL-OBJECTS>
		<RFALSE>)
	       (T
		<HELD? <LOC .OBJ>>)>>

<ROUTINE WHAT-A-CONCEPT ()
	 <TELL "What a concept!" CR>>

<ROUTINE YOU-DONT-NEED (THING "OPTIONAL" (STRING? <>))
	 <TELL "(You don't need to refer to ">
	 <COND (.STRING?
		<TELL "the " .THING>)
	       (T
		<ARTICLE .THING T>
	        <TELL D .THING>)>
	 <TELL " that way to finish this story.)" CR>>	 

<ROUTINE ITS-CLOSED (OBJ)
	 <THIS-IS-IT .OBJ>
	 <SAY-THE .OBJ>
	 <IS-CLOSED>
	 <CRLF>>

<ROUTINE IS-CLOSED ()
	 <TELL " is closed.">>

<ROUTINE IF-YOU-TRIED ()
	 <TELL " if you tried that!" CR>>

<ROUTINE AND-DROPS-OUT (THING)
	 <TELL " and ">
	 <FCLEAR .THING ,WORNBIT>
	 <COND (<EQUAL? ,HERE ,FOG>
		<TELL "disappears in the fog." CR>
		<MOVE .THING ,CLIFF-BOTTOM>)
	       (<EQUAL? ,HERE ,STEEP-TRAIL>
		<TELL "tumbles over the edge of the cliff." CR>
		<MOVE .THING ,CLIFF-BOTTOM>)
	       (<EQUAL? ,HERE ,FUZZY>
		<TELL "disappears in the fuzziness." CR>
		<MOVE .THING ,FUZZY-FROM>)
	       (T
		<TELL "lands at your feet." CR>
	        <COND (<EQUAL? ,HERE ,OUTSIDE-COTTAGE>
		       <CRLF>
		       <PERFORM ,V?GIVE .THING ,POOCH>
		       <SETG CLOCK-WAIT T>
		       <RTRUE>)
		      (T
		       <MOVE .THING ,HERE>)>)>>

<ROUTINE OPEN-CLOSED (THING "OPTIONAL" (N? <>))
	 <COND (<FSET? .THING ,OPENBIT>
		<COND (.N?
		       <TELL "n">)>
		<TELL " open ">)
	       (T
		<TELL " closed ">)>>

<ROUTINE WHICH-TOWN ("OPTIONAL" (STR <>))
	 <TELL " ">
	 <COND (<OR <NOT ,SKEWED?>
		    ,SUCCESS?>
		<TELL "Festeron">)
	       (T
		<TELL "Witchville">)>
	 <COND (.STR
		<TELL " " .STR>)>>

"*** COMMON INTERRUPTS ***"

<ROUTINE I-BEFORE-FIVE ()
	 <COND (<EQUAL? ,SCORE 16>
		<COND (<ZERO? ,MOVES>
		       <BETTER-HURRY>)
		      (<EQUAL? ,MOVES 30>
		       <BETTER-HURRY T>)>)
	       (<AND <EQUAL? ,SCORE 17>
		     <NOT <EQUAL? ,HERE ,INSIDE-SHOPPE>>>
	      	<FIRED T>)>>

<ROUTINE I-BREAK-IN ()
	 <COND (<AND <EQUAL? ,HERE ,JAIL-CELL>
		     <PROB 10>>
		<CRLF>
		<HEAR-WAILS>)>>

<ROUTINE I-CREAK ()
	 <COND (<EQUAL? ,HERE ,EDGE-OF-LAKE>
		<COND (<FSET? ,NORTH-GATE ,RMUNGBIT>
		       <FCLEAR ,NORTH-GATE ,RMUNGBIT>)
		      (T
		       <DISABLE <INT I-CREAK>>
		       <FCLEAR ,NORTH-GATE ,LOCKEDBIT>
		       <FSET ,NORTH-GATE ,OPENBIT>
		       <THIS-IS-IT ,NORTH-GATE>
		       <TELL CR 
"A rusty \"click!\" draws your eyes to the " D ,NORTH-GATE
". You watch as it slowly creaks open, all by itself!" CR>)>)>>

<ROUTINE I-VULTURE ()
	 <COND (<OR ,ECLIPSE? ,FUZZY?
		    <FSET? ,HERE ,INDOORSBIT>
		    <EQUAL? ,HERE ,WEST-OF-HOUSE>>
		<RTRUE>)
	       (<OR <FSET? ,VULTURE ,RMUNGBIT>
		    <PROB 5>>
		<FCLEAR ,VULTURE ,RMUNGBIT>
		<MOVE ,VULTURE ,HERE>
		<CRLF>
		<SEE-VULTURE>)>>

<ROUTINE I-BEFORE-MOONSET ("AUX" H)
	 <COND (<G? ,SCORE 17>
		<RTRUE>)
	       (<G? ,SCORE 5>
		<CRLF>
		<COND (<AND <NOT <FSET? ,HERE ,INDOORSBIT>>
			    <NOT ,FUZZY?>
			    <NOT ,ECLIPSE?>>
		       <TELL "You watch with horror as the " D ,MOON
			     " slowly sets in the western sky." CR CR>)>
		<TELL "Out of nowhere, the sad voice of the " 
		      D ,OLD-WOMAN " from the " D ,MAGICK-SHOPPE
" rises around you. \"Your quest is over" ,ADVENTURER 
". The moon is set, and " D ,CHAOS " is no more. ">
		<THANKS-ANYWAY> 
		<BAD-ENDING>)
	       (<ZERO? ,MOVES>
		<SET H <- 6 ,SCORE>>
		<SAY-HURRY>
		<TELL "You've only got ">
		<COND (<1? .H>
		       <TELL "one more hour">)
		      (T
		       <TELL N .H " hours">)>
		<TELL " before the " D ,MOON " sets!)" CR>)>>

<GLOBAL P-PROMPT 2>

<ROUTINE I-PROMPT-1 ()
	 <SETG P-PROMPT 1>
	 <RFALSE>>

<ROUTINE I-PROMPT-2 ()
         <COND (,P-PROMPT
	        <SETG P-PROMPT <>>
	        <TELL CR
"(You won't see the \"What next?\" prompt any more.)">
	      ; <COND (<VERB? WAIT-FOR ;WAIT ;WAIT-UNTIL> 
	               <CRLF>)>
	        <DISABLE <INT I-PROMPT-2>>
	        <RFALSE>)>>

<GLOBAL NO-LUCK? <>>

<ROUTINE I-LUCK ("OPTIONAL" (SHUTOFF? <>))
	 <COND (,NO-LUCK?
		<RTRUE>)>
	 <COND (<AND <IN? ,SHOE ,PROTAGONIST>
		     <IN? ,WISHBRINGER ,PROTAGONIST>
		     <FSET? ,WISHBRINGER ,ONBIT>
		     <NOT .SHUTOFF?>>
		<COND (<NOT ,LUCKY?>
		       <FSET ,SHOE ,ONBIT>
		       <THIS-IS-IT ,SHOE>
		       <SETG LUCKY? T>
		       <CRLF>
		       <SAY-THE ,SHOE>
		       <TELL " is twinkling again." CR>)>)
	       (T
		<COND (,LUCKY?
		       <COND (<VISIBLE? ,SHOE>
		              <THIS-IS-IT ,SHOE>
			      <CRLF>
			      <SAY-THE ,SHOE>
			      <TELL " isn't twinkling any more." CR>)>
		       <FCLEAR ,SHOE ,ONBIT>
		       <SETG LUCKY? <>>)>)>
	 <COND (.SHUTOFF?
		<SETG NO-LUCK? T>)>>

<ROUTINE I-GLOW ()
	 <COND (,ECLIPSE?
		<RFALSE>)
	       (<IN? ,WISHBRINGER ,PROTAGONIST>
		<COND (<FSET? ,WISHBRINGER ,TOOLBIT> ; "1st touch?"
		       <FCLEAR ,WISHBRINGER ,TOOLBIT>
		       <TELL CR
"As your fingers close around the " D ,WISHBRINGER " it begins to glow">
		       <SAY-GLOW>)
		      (<FSET? ,WISHBRINGER ,RMUNGBIT>
		       <CRLF>
		       <SAY-THE ,WISHBRINGER>
		       <TELL " begins to glow again." CR>)
		      (T
		       <RFALSE>)>
		<FSET ,WISHBRINGER ,ONBIT>
	        <FCLEAR ,WISHBRINGER ,RMUNGBIT>
		<COND (<NOT ,LIT>
		       <SETG LIT T>
		       <CRLF>
		       <V-LOOK>)>
		<COND (<AND <FSET? ,LUCK ,TOUCHBIT>
			    <IN? ,SHOE ,PROTAGONIST>>
		       <I-LUCK>)>)
	       (<NOT <FSET? ,WISHBRINGER ,RMUNGBIT>>
		<FSET ,WISHBRINGER ,RMUNGBIT> ; "Not being held"
		<FCLEAR ,WISHBRINGER ,ONBIT>
		<COND (<VISIBLE? ,WISHBRINGER>
		       <CRLF>
		       <SAY-THE ,WISHBRINGER>
		       <TELL " stops glowing." CR>)>
		<SAY-IF-NOT-LIT>)
	       (T
		<RFALSE>)>>

<GLOBAL SHELL-SCRIPT 5>

<ROUTINE I-SHELL-TALK ()
	 <SETG SHELL-SCRIPT <- ,SHELL-SCRIPT 1>>
	 <COND (<OR <ZERO? ,SHELL-SCRIPT>
		    <NOT <IN? ,CONCH-SHELL ,PROTAGONIST>>
		    <NOT <IN? ,WISHBRINGER ,PROTAGONIST>>>
		<DISABLE <INT I-SHELL-TALK>>
		<COND (<AND <VISIBLE? ,CONCH-SHELL>
			    <L? ,SHELL-SCRIPT 4>>
		       <THIS-IS-IT ,CONCH-SHELL>
		       <TELL CR  
"The buzzing sound in the " D ,CONCH-SHELL " stops." CR>)>)
	       (<EQUAL? ,SHELL-SCRIPT 4>
		<THIS-IS-IT ,CONCH-SHELL>
		<TELL CR ,YOU-HEAR "a faint buzzing sound, like an overheard telephone, coming from the " D ,CONCH-SHELL "." CR>)
	       (<EQUAL? ,SHELL-SCRIPT 2>
		<THIS-IS-IT ,CONCH-SHELL>
		<TELL CR "(">
		<SAY-THE ,CONCH-SHELL>
		<TELL 
" is still buzzing. Maybe you should listen to it.)" CR>)>>

; "*** ATARI: MAKE THIS TABLE PURE FOR NON-ATARI ZIPS"

<GLOBAL BOOT-PATH
	 <PTABLE FESTERON-POINT		; "0"
		ROCKY-PATH		; "1"
	        SOUTH-OF-BRIDGE		; "2"
	        RIVER-OUTLET		; "3"
	        LOOKOUT-HILL		; "4"
	        RIVER-OUTLET		; "5"
	        EDGE-OF-LAKE		; "6"
	        ROTARY-WEST		; "7"
	        ROTARY-SOUTH		; "8"
	        ROTARY-EAST		; "9"
	        PLEASURE-WHARF		; "10"
	        WHARF			; "11"
	        PLEASURE-WHARF		; "12"
	        ROTARY-EAST		; "13"
	        PARK			; "14"
	        ROTARY-WEST		; "15"
	        ROTARY-NORTH		; "16"
	        SOUTH-OF-BRIDGE		; "17"
	        ROCKY-PATH		; "18"
	        FESTERON-POINT>>
	 
<CONSTANT BOOT-MAX 18> ; "LENGTH OF BOOT-PATH"
<CONSTANT DIR-MAX 6> ; "MAXIMUM DIRECTION INDEX"

; "The following is a table of tables, one for each boot room.
   Entries are in N-S-E-W-U-D-OUT order. All entries zero-aligned.
   A room name in a slot indicates that you can see boots in that direction
   when the boots are in the room corresponding to that table.
   For example, if the boots are at South Of Bridge (Boot Room #2) and you
   are at Rotary North, you can hear boots to the north. So the NORTH (#0)
   entry for Boot Room #2 contains Rotary North (your location). Got it?"

; "*** ATARI: IMPURE TABLE (SEE PURE BELOW)"

; <GLOBAL DIRECTION-TABLES
	<TABLE
; "0"	 <TABLE <> <> ROCKY-PATH <> <> <> <>>
; "1"	 <TABLE WEST-OF-HOUSE <> SOUTH-OF-BRIDGE FESTERON-POINT <> <> <>>
; "2"	 <TABLE ROTARY-NORTH ON-BRIDGE RIVER-OUTLET ROCKY-PATH <> <> <>>
; "3"	 <TABLE EDGE-OF-LAKE <> <> SOUTH-OF-BRIDGE <> LOOKOUT-HILL <>>
; "4"	 <TABLE <> <> <> <> RIVER-OUTLET <> UNDER-HILL>
; "5"	 <TABLE EDGE-OF-LAKE <> <> SOUTH-OF-BRIDGE <> LOOKOUT-HILL <>>
; "6"	 <TABLE TWILIGHT-GLEN RIVER-OUTLET <> ROTARY-WEST <> <> <>>
; "7"	 <TABLE <> <> EDGE-OF-LAKE PARK <> <> INSIDE-POLICE-STATION>
; "8"	 <TABLE OUTSIDE-COTTAGE PARK <> <> <> <> CIRCULATION-DESK>
; "9"	 <TABLE <> <> PARK PLEASURE-WHARF <> <> LOBBY>
; "10"	 <TABLE VIDEO-ARCADE <> ROTARY-EAST WHARF <> <> <>>
; "11"	 <TABLE <> <> PLEASURE-WHARF <> <> <> <>>
; "12"   <TABLE VIDEO-ARCADE <> ROTARY-EAST WHARF <> <> <>>
; "13"	 <TABLE <> <> PARK PLEASURE-WHARF <> <> LOBBY>
; "14"	 <TABLE ROTARY-SOUTH ROTARY-NORTH ROTARY-WEST ROTARY-EAST <> <> <>>
; "15"   <TABLE <> <> EDGE-OF-LAKE PARK <> <> INSIDE-POLICE-STATION>
; "16"	 <TABLE PARK SOUTH-OF-BRIDGE <> <> <> <> INSIDE-CHURCH>
; "17"	 <TABLE ROTARY-NORTH ON-BRIDGE RIVER-OUTLET ROCKY-PATH <> <> <>>      
; "18"	 <TABLE WEST-OF-HOUSE <> SOUTH-OF-BRIDGE FESTERON-POINT <> <> <>>>>

; "*** ATARI: PURE VERSION FOR NON-ATARI ZIPS"

<GLOBAL DIRECTION-TABLES
	<PTABLE
; "0"	 <PTABLE <> <> ROCKY-PATH <> <> <> <>>
; "1"	 <PTABLE WEST-OF-HOUSE <> SOUTH-OF-BRIDGE FESTERON-POINT <> <> <>>
; "2"	 <PTABLE ROTARY-NORTH ON-BRIDGE RIVER-OUTLET ROCKY-PATH <> <> <>>
; "3"	 <PTABLE EDGE-OF-LAKE <> <> SOUTH-OF-BRIDGE <> LOOKOUT-HILL <>>
; "4"	 <PTABLE <> <> <> <> RIVER-OUTLET <> UNDER-HILL>
; "5"	 <PTABLE EDGE-OF-LAKE <> <> SOUTH-OF-BRIDGE <> LOOKOUT-HILL <>>
; "6"	 <PTABLE TWILIGHT-GLEN RIVER-OUTLET <> ROTARY-WEST <> <> <>>
; "7"	 <PTABLE <> <> EDGE-OF-LAKE PARK <> <> INSIDE-POLICE-STATION>
; "8"	 <PTABLE OUTSIDE-COTTAGE PARK <> <> <> <> CIRCULATION-DESK>
; "9"	 <PTABLE <> <> PARK PLEASURE-WHARF <> <> LOBBY>
; "10"	 <PTABLE VIDEO-ARCADE <> ROTARY-EAST WHARF <> <> <>>
; "11"	 <PTABLE <> <> PLEASURE-WHARF <> <> <> <>>
; "12"   <PTABLE VIDEO-ARCADE <> ROTARY-EAST WHARF <> <> <>>
; "13"	 <PTABLE <> <> PARK PLEASURE-WHARF <> <> LOBBY>
; "14"	 <PTABLE ROTARY-SOUTH ROTARY-NORTH ROTARY-WEST ROTARY-EAST <> <> <>>
; "15"   <PTABLE <> <> EDGE-OF-LAKE PARK <> <> INSIDE-POLICE-STATION>
; "16"	 <PTABLE PARK SOUTH-OF-BRIDGE <> <> <> <> INSIDE-CHURCH>
; "17"	 <PTABLE ROTARY-NORTH ON-BRIDGE RIVER-OUTLET ROCKY-PATH <> <> <>>      
; "18"	 <PTABLE WEST-OF-HOUSE <> SOUTH-OF-BRIDGE FESTERON-POINT <> <> <>>>>

<ROUTINE TO-N ()
	 <RETURN <GET ,DIR-NAMES 0>>>

<ROUTINE TO-S ()
	 <RETURN <GET ,DIR-NAMES 1>>>

<ROUTINE TO-E ()
	 <RETURN <GET ,DIR-NAMES 2>>>

<GLOBAL DIR-NAMES
	<PTABLE
	 "to the north"				; "0"
	 "to the south"				; "1"
	 "to the east"				; "2"
	 "to the west"				; "3"
	 "on the summit of Lookout Hill"	; "4"
	 "at the bottom of the hill"		; "5"
	 "outside">>				; "6"

<GLOBAL BOOT-LOC 0>
<GLOBAL LAST-PLACE CLIFF-EDGE>

<ROUTINE I-BOOT-PATROL ("AUX" DIR-INDEX DIR-TABLE PLACE WHERE-BOOTS)
	 <COND (,ECLIPSE?
		<RTRUE>)>  ; "Abort if dark"
	 
       ; "Move the boots only if the player has NOT moved"

	 <COND (<EQUAL? ,LAST-PLACE ,HERE>
		
              ; "Calc next boot location and move the boots"
		
		<SET WHERE-BOOTS <LOC ,BOOTS>>
	        <COND (<AND ,FUZZY?
			    <EQUAL? ,FUZZY-FROM .WHERE-BOOTS>>
		       <TELL CR "The fuzzy">
		       <TRAMP>
		       <TELL "fades away." CR>)>
		<SETG BOOT-LOC <+ ,BOOT-LOC 1>>
	        <COND (<G? ,BOOT-LOC ,BOOT-MAX>
		       <SETG BOOT-LOC 0>)>
	        <SET WHERE-BOOTS <GET ,BOOT-PATH ,BOOT-LOC>>
		<MOVE ,BOOTS .WHERE-BOOTS>)
	       
	      ; "Update LAST-HERE if player moved"

	       (T
		<SET WHERE-BOOTS <LOC ,BOOTS>>
		<SETG LAST-PLACE ,HERE>)>
	 
       ; "Check for boot collision"

	 <COND (<AND ,FUZZY?
		     <EQUAL? ,FUZZY-FROM .WHERE-BOOTS>>
		<TELL CR ,YOU-HEAR "the">
		<TRAMP>
		<TELL 
"all around you. But the sound is fuzzy and oddly distant." CR>
		<RTRUE>)>
	      
	 <COND (<EQUAL? ,HERE .WHERE-BOOTS>
		<DEPOSIT-BRANCH>
	      		
	      ; "Generic boot approach"

		<TELL CR "The night is filled with rhythmic thunder, and a platoon of gigantic leather army " D ,BOOTS " marches into view. It's the Boot Patrol">
		<COND (<NOT <ZERO? ,JAIL-VISITS>>
		       <TELL " again">)>
	        <TELL "!|
|
You're immediately surrounded, tied, gagged and dragged before an especially tall Boot. ">
	        
	      ; "Filter response according to JAIL-VISITS"

		<COND (<ZERO? ,JAIL-VISITS>
		       <TELL
"\"What have we here?\" he hisses. \"Out after curfew? Tsk, tsk, tsk. I wonder what " D ,MACGUFFIN " will say about this.\"">)
		      
		      (<EQUAL? ,JAIL-VISITS 1>
		       <TELL
"\"What!\" he cries. \"I thought you were locked up with " D ,MACGUFFIN ". Tsk, tsk.\"">)
		      
		      (T        ; "Last visit"
		       <TELL
"\"Escaped again!\" He looks around at the silent platoon. \"We don't want to bother " D ,MACGUFFIN>
		       <SHARK-SNACK>)>
		
		<THROWN-OVER-SHOULDER>    ; "Generic carry-away"
		
	      ; "Handle 1st and 2nd JAIL-VISITS"
		
		<COND (<EQUAL? ,JAIL-VISITS 0 1>
		       <TELL 
"the " D ,GLOBBY " of the " D ,INSIDE-POLICE-STATION "." CR CR D ,MACGUFFIN 
" glares at you as the " D ,BOOTS " dump you on the floor. ">
		              
		            ; "1st visit"

		       <COND (<ZERO? ,JAIL-VISITS>
			      <TELL
"\"What's this?\" he demands impatiently.|
|
\"A nightcrawler,\" hisses the Tall Boot, giving you a vicious little kick. \"Outside after curfew. Shall I feed it to the " D ,SHARKS "?\"" CR CR 
D ,MACGUFFIN " shakes his head. \"Later. The Tower wants all prisoners held for questioning.\" He turns back to his work. \"Cell Three.\"">)
			            
		           ; "2nd visit"
				
		             (T
			      <TELL
"His eyes narrow when he sees you. ">
		              <JAIL-AGAIN>)>
		       		       
		     ; "1st and 2nd visit"

		       <TO-JAIL>)

	            ; "Handle last visit"

		      (T
		       <INTO-BAY>)>
		<RTRUE>)>
	 
       ; "If no collision, scan for nearby boots"

	 <SET DIR-INDEX 0>
	 <SET DIR-TABLE <GET ,DIRECTION-TABLES ,BOOT-LOC>>
	 <REPEAT ()
		 <COND (<G? .DIR-INDEX ,DIR-MAX>
		        <RETURN>)>
		 <SET PLACE <GET .DIR-TABLE .DIR-INDEX>>
		 
	       ; "The following clause fixes the rotary problem"

		 <COND (<EQUAL? .PLACE ,PARK>
			<COND (<AND <EQUAL? .DIR-INDEX 0 1>
				    <EQUAL? ,HERE ,ROTARY-WEST
					          ,ROTARY-EAST>>
			       <SET PLACE ,HERE>)
			      (<AND <EQUAL? .DIR-INDEX 2 3>
				    <EQUAL? ,HERE ,ROTARY-NORTH
					          ,ROTARY-SOUTH>>
			       <SET PLACE ,HERE>)>)> 
		 
		 <COND (<EQUAL? ,HERE .PLACE>
		        <THIS-IS-IT ,BOOTS>
		        <TELL CR ,YOU-HEAR "the">
		        <TRAMP>
		        <TELL <GET ,DIR-NAMES .DIR-INDEX> ".">
		        <COND (<EQUAL? ,HERE <GET ,BOOT-PATH <+ ,BOOT-LOC 1>>>
		               <COMING-THIS-WAY>)>
		        <CRLF>
		        <RETURN>)>
		 <SET DIR-INDEX <+ .DIR-INDEX 1>>>>

<GLOBAL JAIL-SCRIPT 24> ; "# turns for first jail visit"

<ROUTINE I-JAIL ()
	 <COND (<OR ,FUZZY? ,ECLIPSE?>
		<RTRUE>)
	       (<EQUAL? ,HERE ,JAIL-CELL>
		<SETG JAIL-SCRIPT <- ,JAIL-SCRIPT 1>>
		<COND (<EQUAL? ,JAIL-SCRIPT 8>
		       <TELL CR ,YOU-HEAR>
		       <EVIL-VOICES>
		       <TELL "." CR>)
		      
		      (<EQUAL? ,JAIL-SCRIPT 6 3>
		       <TELL CR "The ">
		       <EVIL-VOICES>
		       <TELL " laugh among themselves." CR>)
		      
		      (<EQUAL? ,JAIL-SCRIPT 5>
		       <TELL CR "One of the ">
		       <EVIL-VOICES>
		       <TELL " just mentioned your name!" CR>)
		      		      
		      (<EQUAL? ,JAIL-SCRIPT 2>
		       <TELL CR ,YOU-HEAR "the">
		       <TRAMP>
		       <TELL "in the " D ,CORRIDOR " outside.">
		       <COMING-THIS-WAY>
		       <CRLF>)
		      
		      (<EQUAL? ,JAIL-SCRIPT 1>
		       <TELL CR 
"Uh-oh. Somebody's unlocking your " D ,CELL-DOOR "!" CR>)
		      
	       	      (<ZERO? ,JAIL-SCRIPT>
		       <TELL CR "The door flies open, and a dozen giant army boots stride into your cell.">
		       <THROWN-OVER-SHOULDER>
		       <TORTURE-ENDING>)
		      
		      (<OR <EQUAL? ,JAIL-SCRIPT 7 4>
			   <PROB 10>>
		       <CRLF>
		       <HEAR-WAILS>)>)>>

<ROUTINE I-SMOKE ()
	 <COND (<EQUAL? ,HERE ,VIDEO-ARCADE>
		<DISABLE <INT I-SMOKE>>
		<TELL CR "A vague electrical smell quickly fades." CR>)>>