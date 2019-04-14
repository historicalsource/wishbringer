"MISC for WISHBRINGER: (C)1985 Infocom, Inc. All Rights Reserved."

<SETG C-ENABLED? 0>

<SETG C-ENABLED 1>

<SETG C-DISABLED 0>

<DEFMAC TELL ("ARGS" A)
	<FORM PROG ()
	      !<MAPF ,LIST
		     <FUNCTION ("AUX" E P O)
			  <COND (<EMPTY? .A> <MAPSTOP>)
				(<SET E <NTH .A 1>>
				 <SET A <REST .A>>)>
			  <COND (<TYPE? .E ATOM>
				 <COND (<OR <=? <SET P <SPNAME .E>>
						"CRLF">
					    <=? .P "CR">>
					<MAPRET '<CRLF>>)
				       (<EMPTY? .A>
					<ERROR INDICATOR-AT-END? .E>)
				       (ELSE
					<SET O <NTH .A 1>>
					<SET A <REST .A>>
					<COND (<OR <=? <SET P <SPNAME .E>>
						       "DESC">
						   <=? .P "D">
						   <=? .P "OBJ">
						   <=? .P "O">>
					       <MAPRET <FORM PRINTD .O>>)
					      (<OR <=? .P "NUM">
						   <=? .P "N">>
					       <MAPRET <FORM PRINTN .O>>)
					      (<OR <=? .P "CHAR">
						   <=? .P "CHR">
						   <=? .P "C">>
					       <MAPRET <FORM PRINTC .O>>)
					      (ELSE
					       <MAPRET
						 <FORM PRINT
						       <FORM GETP .O .E>>>)>)>)
				(<TYPE? .E STRING ZSTRING>
				 <MAPRET <FORM PRINTI .E>>)
				(<TYPE? .E FORM LVAL GVAL>
				 <MAPRET <FORM PRINT .E>>)
				(ELSE <ERROR UNKNOWN-TYPE .E>)>>>>>

<DEFMAC VERB? ("ARGS" ATMS)
	<MULTIFROB PRSA .ATMS>>

<DEFMAC PRSO? ("ARGS" ATMS)
	<MULTIFROB PRSO .ATMS>>

<DEFMAC PRSI? ("ARGS" ATMS)
	<MULTIFROB PRSI .ATMS>>

<DEFMAC ROOM? ("ARGS" ATMS)
	<MULTIFROB HERE .ATMS>>

<DEFINE MULTIFROB (X ATMS "AUX" (OO (OR)) (O .OO) (L ()) ATM) 
	<REPEAT ()
		<COND (<EMPTY? .ATMS>
		       <RETURN!- <COND (<LENGTH? .OO 1> <ERROR .X>)
				       (<LENGTH? .OO 2> <NTH .OO 2>)
				       (ELSE <CHTYPE .OO FORM>)>>)>
		<REPEAT ()
			<COND (<EMPTY? .ATMS> <RETURN!->)>
			<SET ATM <NTH .ATMS 1>>
			<SET L
			     (<COND (<TYPE? .ATM ATOM>
				     <CHTYPE <COND (<==? .X PRSA>
						    <PARSE
						     <STRING "V?"
							     <SPNAME .ATM>>>)
						   (ELSE .ATM)> GVAL>)
				    (ELSE .ATM)>
			      !.L)>
			<SET ATMS <REST .ATMS>>
			<COND (<==? <LENGTH .L> 3> <RETURN!->)>>
		<SET O <REST <PUTREST .O
				      (<FORM EQUAL? <CHTYPE .X GVAL> !.L>)>>>
		<SET L ()>>>

<DEFMAC BSET ('OBJ "ARGS" BITS)
	<MULTIBITS FSET .OBJ .BITS>>

<DEFMAC BCLEAR ('OBJ "ARGS" BITS)
	<MULTIBITS FCLEAR .OBJ .BITS>>

<DEFMAC BSET? ('OBJ "ARGS" BITS)
	<MULTIBITS FSET? .OBJ .BITS>>

<DEFINE MULTIBITS (X OBJ ATMS "AUX" (O ()) ATM) 
	<REPEAT ()
		<COND (<EMPTY? .ATMS>
		       <RETURN!- <COND (<LENGTH? .O 1> <NTH .O 1>)
				       (<==? .X FSET?> <FORM OR !.O>)
				       (ELSE <FORM PROG () !.O>)>>)>
		<SET ATM <NTH .ATMS 1>>
		<SET ATMS <REST .ATMS>>
		<SET O
		     (<FORM .X
			    .OBJ
			    <COND (<TYPE? .ATM FORM> .ATM)
				  (ELSE <FORM GVAL .ATM>)>>
		      !.O)>>>

<DEFMAC RFATAL ()
	'<PROG () <PUSH 2> <RSTACK>>>

<DEFMAC PROB ('BASE?)
	<FORM NOT <FORM L? .BASE? '<RANDOM 100>>>>

; <DEFMAC PROB ('BASE? "OPTIONAL" 'LOSER?)
	<COND (<ASSIGNED? LOSER?> <FORM ZPROB .BASE?>)
	      (ELSE <FORM G? .BASE? '<RANDOM 100>>)>>

<DEFMAC ENABLE ('INT) <FORM PUT .INT ,C-ENABLED? 1>>

<DEFMAC DISABLE ('INT) <FORM PUT .INT ,C-ENABLED? 0>>

<DEFMAC OPENABLE? ('OBJ)
	<FORM OR <FORM FSET? .OBJ ',DOORBIT>
	         <FORM FSET? .OBJ ',CONTBIT>>> 

<DEFMAC ABS ('NUM)
	<FORM COND (<FORM L? .NUM 0> <FORM - 0 .NUM>)
	           (T .NUM)>>

"*** ZCODE STARTS HERE ***"

"NOTE: This object MUST be the FIRST one defined (for MOBY-FIND)!"

<OBJECT DUMMY-OBJECT>

<ROUTINE GO () 
         <SETG HERE ,HILLTOP>
	 <SETG WINNER ,PROTAGONIST>
	 <SETG SCORE 15>
	 <SETG MOVES 0>
	 <ENABLE <QUEUE I-PROMPT-1 1>>
	 <ENABLE <QUEUE I-PROMPT-2 10>>
	 <ENABLE <QUEUE I-CRISP-CALLING -1>>
	 <ENABLE <QUEUE I-VOSS-CALLING -1>>
	 <ENABLE <QUEUE I-BARKING -1>>
	 <ENABLE <QUEUE I-BEFORE-FIVE -1>>
	 <RESET-THEM>
	 <CRLF>
	 <INTRO>
	 <TELL " Thermofax.|
|
Only your Magick sword can save you now. You swing it high, speak the Word and stand unhurt as the blade absorbs the searing dragon-breath.|
|
The reptile bellows with rage and flaps its wings to fan the fire in its belly. You are advancing, sword poised to strike, when a familiar voice shatters the daydream and stays your mighty hand..." CR>
	 <V-VERSION>
	 <CRLF>
	 <V-LOOK>
	 <SOMEBODY-CALLING>
	 <DO-MAIN-LOOP>
	 <AGAIN>>

<ROUTINE DO-MAIN-LOOP ("AUX" X)
	 <REPEAT ()
		 <SET X <MAIN-LOOP>>>>

<ROUTINE MAIN-LOOP ("AUX" ICNT OCNT NUM CNT OBJ TBL V PTBL OBJ1 TMP X)
   <REPEAT ()
     <SET CNT 0>
     <SET OBJ <>>
     <SET PTBL T>
     <SETG P-WON <PARSER>>
     <COND (,P-WON
	    <SET ICNT <GET ,P-PRSI ,P-MATCHLEN>>
	    <SET OCNT <GET ,P-PRSO ,P-MATCHLEN>>
	    <COND (<AND ,P-IT-OBJECT
			<ACCESSIBLE? ,P-IT-OBJECT>>
		   <SET TMP <>>
		   <REPEAT ()
			   <COND (<G? <SET CNT <+ .CNT 1>> .ICNT>
				  <RETURN>)
				 (T
				  <COND (<EQUAL? <GET ,P-PRSI .CNT> ,IT>
					 <PUT ,P-PRSI .CNT ,P-IT-OBJECT>
					 <SET TMP T>
					 <RETURN>)>)>>
		   <COND (<NOT .TMP>
			  <SET CNT 0>
			  <REPEAT ()
			   <COND (<G? <SET CNT <+ .CNT 1>> .OCNT>
				  <RETURN>)
				 (T
				  <COND (<EQUAL? <GET ,P-PRSO .CNT> ,IT>
					 <PUT ,P-PRSO .CNT ,P-IT-OBJECT>
					 <RETURN>)>)>>)>
		   <SET CNT 0>)>
	    <SET NUM
		 <COND (<ZERO? .OCNT>
			.OCNT)
		       (<G? .OCNT 1>
			<SET TBL ,P-PRSO>
			<COND (<ZERO? .ICNT>
			       <SET OBJ <>>)
			      (T
			       <SET OBJ <GET ,P-PRSI 1>>)>
			.OCNT)
		       (<G? .ICNT 1>
			<SET PTBL <>>
			<SET TBL ,P-PRSI>
			<SET OBJ <GET ,P-PRSO 1>>
			.ICNT)
		       (T
			1)>>
	    <COND (<AND <NOT .OBJ>
			<1? .ICNT>>
		   <SET OBJ <GET ,P-PRSI 1>>)>
	    <COND (<EQUAL? ,PRSA ,V?WALK>
		   <SET V <PERFORM ,PRSA ,PRSO>>)
		  (<ZERO? .NUM>
		   <COND (<ZERO? <BAND <GETB ,P-SYNTAX ,P-SBITS> ,P-SONUMS>>
			  <SET V <PERFORM ,PRSA>>
			  <SETG PRSO <>>)
			 (<NOT ,LIT>
			  <PCLEAR>
			  <TOO-DARK>)
			 (T
			  <PCLEAR>
			  <TELL "(There isn't anything to ">
			  <SET TMP <GET ,P-ITBL ,P-VERBN>>
			  <COND (<VERB? TELL>
				 <TELL "talk to">)
				(<OR ,P-MERGED ,P-OFLAG>
				 <PRINTB <GET .TMP 0>>)
				(T
				 <SET V <WORD-PRINT <GETB .TMP 2>
						    <GETB .TMP 3>>>)>
			  <TELL "!)" CR>
			  <SET V <>>)>)
		; (<AND .PTBL <G? .NUM 1> <VERB? COMPARE>>
		   <SET V <PERFORM ,PRSA ,OBJECT-PAIR>>)
		  (T
		   <SET X 0>
		   ;"<SETG P-MULT <>>
		   <COND (<G? .NUM 1> <SETG P-MULT T>)>"
		   <SET TMP 0>
		   <REPEAT ()
		    <COND (<G? <SET CNT <+ .CNT 1>> .NUM>
			   <COND (<G? .X 0>
				  <TELL "(The ">
				  <COND (<NOT <EQUAL? .X .NUM>>
					 <TELL "other ">)>
				  <TELL "object">
				  <COND (<NOT <EQUAL? .X 1>>
					 <TELL "s">)>
				  <TELL " that you mentioned ">
				  <COND (<NOT <EQUAL? .X 1>>
					 <TELL "are">)
					(T <TELL "is">)>
				  <TELL "n't here!)" CR>)
				 (<NOT .TMP>
				  <REFERRING>)>
			   <RETURN>)
			  (T
			   <COND (.PTBL
				  <SET OBJ1 <GET ,P-PRSO .CNT>>)
				 (T
				  <SET OBJ1 <GET ,P-PRSI .CNT>>)>
	<COND (<OR <G? .NUM 1>
		   <EQUAL? <GET <GET ,P-ITBL ,P-NC1> 0> ,W?ALL ,W?EVERYTHING>>
	       <COND (<EQUAL? .OBJ1 ,NOT-HERE-OBJECT>
		      <SET X <+ .X 1>>
		      <AGAIN>)
		   
		     (<AND <EQUAL? ,P-GETFLAGS ,P-ALL>
			   <DONT-ALL? .OBJ1 .OBJ>>
		      <AGAIN>)

		   ; (<AND <EQUAL? ,P-GETFLAGS ,P-ALL>
			   <VERB-ALL-TEST .OBJ1 .OBJ>>
		      <AGAIN>)
		   
		   ; (<AND <EQUAL? ,P-GETFLAGS ,P-ALL>
			   <VERB? TAKE>
		           <OR <AND <NOT <EQUAL? <LOC .OBJ1> ,WINNER ,HERE>>
				    <NOT <FSET? <LOC .OBJ1> ,SURFACEBIT>>>
			       <NOT <OR <FSET? .OBJ1 ,TAKEBIT>
				        <FSET? .OBJ1 ,TRYTAKEBIT>>>>>
		      <AGAIN>)
		   ; (<AND <EQUAL? ,P-GETFLAGS ,P-ALL>
			   <VERB? DROP PUT GIVE PUT-ON PUT-UNDER
				  PUT-BEHIND THROW>
			   <NOT <IN? .OBJ1 ,WINNER>>
			   <NOT <IN? ,P-IT-OBJECT ,WINNER>>>
		      <AGAIN>)
		     
		     (<NOT <ACCESSIBLE? .OBJ1>>
		      <AGAIN>)
		     (<EQUAL? .OBJ1 ,PROTAGONIST ; ,POCKET>
		      <AGAIN>)
		     (T
		      <COND (<EQUAL? .OBJ1 ,IT>
			     <COND (<NOT <FSET? ,P-IT-OBJECT ,NARTICLEBIT>>
				    <TELL "The ">)>
			     <PRINTD ,P-IT-OBJECT>)
			    (T
			     <COND (<NOT <FSET? .OBJ1 ,NARTICLEBIT>>
				    <TELL "The ">)>
			     <PRINTD .OBJ1>)>
		      <TELL ": ">)>)>
			   <SET TMP T>
			   <SETG PRSO <COND (.PTBL
					     .OBJ1)
					    (T
					     .OBJ)>>
			   <SETG PRSI <COND (.PTBL
					     .OBJ)
					    (T
					     .OBJ1)>>
		   <SET V <PERFORM ,PRSA ,PRSO ,PRSI>>
		   <COND (<EQUAL? .V ,M-FATAL>
			  <RETURN>)>)>>)>
	  ; <COND (<NOT <EQUAL? .V ,M-FATAL>>
		   <COND (<GAME-VERB?>
			  T)
			 (T
			  <SET V <APPLY <GETP <LOC ,WINNER> ,P?ACTION>
					,M-END>>)>)>
	    <COND (<GAME-VERB?>
		   T)
		  (<VERB? AGAIN>
		   T)
		  (,P-OFLAG
		   T)
		  (T
		   <SETG L-PRSA ,PRSA>
		   <SETG L-PRSO ,PRSO>
		   <SETG L-PRSI ,PRSI>)>
	    <COND (<EQUAL? .V ,M-FATAL>
		   <SETG P-CONT <>>)>)
	   (T
	    <SETG P-CONT <>>)>
     <COND (,P-WON
	    <COND (<GAME-VERB?>
		   T)
		  (<AND <VERB? AGAIN>
			<GAME-VERB? ,L-PRSA>>
		   T)
		  (T
		   <SET V <CLOCKER>>)>)>
     <SETG PRSA <>>
     <SETG PRSO <>>
     <SETG PRSI <>>>>

<ROUTINE DONT-ALL? (O I "AUX" L)
	 <SET L <LOC .O>>
	 <COND (<EQUAL? .O .I>
		<RTRUE>)
	       (<VERB? TAKE>
		<COND (<EQUAL? .L ,PROTAGONIST ; ,WINNER>
		       <RTRUE>)
		      (<AND <NOT <FSET? .O ,TAKEBIT>>
			    <NOT <FSET? .O ,TRYTAKEBIT>>>
		       <RTRUE>)
		      (<EQUAL? .O ,CAN-BOTTOM>
		       <RTRUE>)
		      (.I
		       <COND (<NOT <EQUAL? .L .I>>
			      <RTRUE>)
			     (<SEE-INSIDE? .I>
			      <RFALSE>)
			     (T
			      <RTRUE>)>)
		      (<EQUAL? .O ,MILK ,VULTURE>
		       <RTRUE>)
		      (<EQUAL? .L ,HERE>
		       <RFALSE>)
		      (<FSET? .L ,SURFACEBIT>
		       <RFALSE>)
		      (<FSET? .L ,ACTORBIT>
		       <RFALSE>)
		    ; (<SEE-INSIDE? .L>
		       <RFALSE>)
		      (T
		       <RTRUE>)>)
	       (<OR <EQUAL? ,PRSA ,V?DROP ,V?PUT ,V?PUT-ON>
		    <EQUAL? ,PRSA ; ,V?GIVE ; ,V?FEED ,V?THROW>>
		<COND (<EQUAL? .O ,MILK ,CAN-BOTTOM>
		       <RTRUE>)
		      (<EQUAL? .L ,PROTAGONIST ,WINNER>
		       <RFALSE>)
		      (T
		       <RTRUE>)>)
	       (T
		<RFALSE>)>>

<ROUTINE ENABLED? (RTN "AUX" C E)
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 <SET C <REST ,C-TABLE ,C-INTS>>
	 <REPEAT ()
		 <COND (<EQUAL? .C .E> <RFALSE>)
		       (<EQUAL? <GET .C ,C-RTN> .RTN>
			<COND (<ZERO? <GET .C ,C-ENABLED?>> <RFALSE>)
			      (T <RTRUE>)>)>
		 <SET C <REST .C ,C-INTLEN>>>>

<ROUTINE GAME-VERB? ("OPTIONAL" (V <>))
	<COND (<NOT .V>
	       <SET V ,PRSA>)>
	<COND (<OR <EQUAL? .V ,V?BRIEF ,V?SCORE ,V?VERBOSE>
	           <EQUAL? .V ,V?QUIT ,V?RESTART ,V?RESTORE>
	           <EQUAL? .V ,V?SAVE ,V?SCRIPT ,V?SUPER-BRIEF>
	           <EQUAL? .V ,V?TELL ,V?UNSCRIPT ,V?VERSION>
		   <EQUAL? .V ,V?TIME ; ,V?INVENTORY>>
	       <RTRUE>)
	      (T
	       <RFALSE>)>>

<ROUTINE SPOKEN-TO (WHO)
         <PCLEAR>
	 <TELL "(spoken to ">
	 <ARTICLE .WHO T>
	 <TELL D .WHO ")" CR>>

<ROUTINE ACCESSIBLE? (OBJ)
         <COND (<FSET? .OBJ ,INVISIBLE>
		<RFALSE>)
	       (<EQUAL? <META-LOC .OBJ> ,WINNER ,HERE ,GLOBAL-OBJECTS>
	        <RTRUE>)
	       (<VISIBLE? .OBJ>
	        <RTRUE>)
	       (T 
		<RFALSE>)>>

<ROUTINE VISIBLE? (OBJ "AUX" L)
         <SET L <LOC .OBJ>>
	 <COND (<NOT .L> 
		<RFALSE>)
               (<FSET? .OBJ ,INVISIBLE>
	        <RFALSE>)
               (<EQUAL? .L ,GLOBAL-OBJECTS>
	        <RFALSE>)
               (<EQUAL? .L ,PROTAGONIST ,HERE ,WINNER>
	        <RTRUE>)
               (<AND <EQUAL? .L ,LOCAL-GLOBALS>
		     <GLOBAL-IN? .OBJ ,HERE>>
		<RTRUE>)
               (<AND <SEE-INSIDE? .L>
		     <VISIBLE? .L>>
	        <RTRUE>)
               (T
	        <RFALSE>)>>

<ROUTINE SEE-INSIDE? (CONTAINER)
	 <COND (<FSET? .CONTAINER ,SURFACEBIT>
		<RTRUE>)
	       (<FSET? .CONTAINER ,CONTBIT>
		<COND (<OR <FSET? .CONTAINER ,OPENBIT>
		           <FSET? .CONTAINER ,TRANSBIT>>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<AND <FSET? .CONTAINER ,ACTORBIT>
		     <NOT <EQUAL? .CONTAINER ,PROTAGONIST>>>
		<RTRUE>)
	       (T
	    	<RFALSE>)>>

<ROUTINE META-LOC (OBJ)
	 <REPEAT ()
		 <COND (<NOT .OBJ>
			<RFALSE>)
		       (<IN? .OBJ ,GLOBAL-OBJECTS>
			<RETURN ,GLOBAL-OBJECTS>)
		       (<IN? .OBJ ,ROOMS>
			<RETURN .OBJ>)
		       (<FSET? .OBJ ,INVISIBLE>
			<RFALSE>)
		       (T
			<SET OBJ <LOC .OBJ>>)>>>

<CONSTANT C-TABLELEN 330>
<GLOBAL C-TABLE <ITABLE NONE 330>>

<GLOBAL C-DEMONS 330>
<GLOBAL C-INTS 330>

<CONSTANT C-INTLEN 6>
<CONSTANT C-ENABLED? 0>
<CONSTANT C-TICK 1>
<CONSTANT C-RTN 2>

<ROUTINE QUEUE (RTN TICK "AUX" CINT)
	 <PUT <SET CINT <INT .RTN>> ,C-TICK .TICK>
	 .CINT>

<ROUTINE INT (RTN "OPTIONAL" (DEMON <>) E C INT)
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 <SET C <REST ,C-TABLE ,C-INTS>>
	 <REPEAT ()
		 <COND (<EQUAL? .C .E>
			<SETG C-INTS <- ,C-INTS ,C-INTLEN>>
			<AND .DEMON <SETG C-DEMONS <- ,C-DEMONS ,C-INTLEN>>>
			<SET INT <REST ,C-TABLE ,C-INTS>>
			<PUT .INT ,C-RTN .RTN>
			<RETURN .INT>)
		       (<EQUAL? <GET .C ,C-RTN> .RTN> <RETURN .C>)>
		 <SET C <REST .C ,C-INTLEN>>>>

<GLOBAL CLOCK-WAIT <>>

<ROUTINE CLOCKER ("AUX" C E I TICK (FLG <>))
	 <COND (,CLOCK-WAIT
		<SETG CLOCK-WAIT <>>
		<RFALSE>)>
	 <SET C <REST ,C-TABLE <COND (,P-WON ,C-INTS) (T ,C-DEMONS)>>>
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 
       ; "The following clause forces I-ECLIPSE to be
	  executed before any other pending interrupts"

	 <COND (,ECLIPSE?
		<SET I <INT I-ECLIPSE>>
		<COND (<AND <NOT <ZERO? <GET .I ,C-ENABLED?>>>
			    <L? <GET .I ,C-TICK> 2>>
		       <APPLY <GET .I ,C-RTN>>)>)>
	 
	 <REPEAT ()
		 <COND (<EQUAL? .C .E>
			<COND (<OR <NOT <EQUAL? ,HERE ,INSIDE-SHOPPE>>
				   <FSET? ,CLOCK ,RMUNGBIT>>
			       <SETG GMOVES <+ ,GMOVES 1>>
			       <SETG MOVES <+ ,MOVES 1>>
	                       <COND (<G? ,MOVES 59>
		                      <SETG MOVES 0>
		                      <SETG SCORE <+ ,SCORE 1>>
		                      <COND (<G? ,SCORE 23>
		                             <SETG SCORE 0>)>)>)>
			<RETURN .FLG>)
		       (<NOT <ZERO? <GET .C ,C-ENABLED?>>>
			<SET TICK <GET .C ,C-TICK>>
			<COND (<ZERO? .TICK>)
			      (T
			       <PUT .C ,C-TICK <- .TICK 1>>
			       <COND (<AND <NOT <G? .TICK 1>>
					   <APPLY <GET .C ,C-RTN>>>
				      <SET FLG T>)>)>)>
		 <SET C <REST .C ,C-INTLEN>>>>


<ROUTINE CARRIAGE-RETURNS ("AUX" (CNT 22))
	 <RESET-THEM>
	 <REPEAT ()
		 <CRLF>
	         <SET CNT <- .CNT 1>>
		 <COND (<ZERO? .CNT>
			<RTRUE>)>>>

<ROUTINE RESET-THEM ()
	 <PCLEAR>
         <SETG P-IT-OBJECT ,NOT-HERE-OBJECT>
	 <SETG P-HIM-OBJECT ,NOT-HERE-OBJECT>
         <SETG P-HER-OBJECT ,NOT-HERE-OBJECT>
         <SETG P-THEM-OBJECT ,NOT-HERE-OBJECT>>

<ROUTINE PCLEAR ()
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>>