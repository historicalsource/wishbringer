"FOG for WISHBRINGER: Copyright (C)1985 Infocom, Inc."

"*** STEEP TRAIL & FOG ***"

<OBJECT FOG
	(IN ROOMS)
	(DESC "Fog")
	(LDESC "You're lost in a thick cloud of fog.")
	(GLOBAL TRAIL CLIFF)
	(FLAGS ONBIT RLANDBIT)
	(NORTH PER N-TRAIL)
	(EAST PER E-TRAIL)
	(SOUTH PER S-TRAIL)
	(WEST PER W-TRAIL)
	(UP PER U-TRAIL)
	(DOWN PER D-TRAIL)
      ; (IN "You're \"in\" this fog far enough already.")
      ; (OUT "You won't get \"out\" of this fog that easily.")
	(PSEUDO "FOG" FOG-PSEUDO "CLOUD" FOG-PSEUDO)>

<GLOBAL TLOC <>>

<ROUTINE I-FOG-RISING ()
	 <COND (<OR ,ECLIPSE?
		    <NOT <EQUAL? ,HERE ,CLIFF-EDGE>>>
		<DISABLE <INT I-FOG-RISING>>
		<RTRUE>)>
	 <SETG WOMAN-SCRIPT <+ ,WOMAN-SCRIPT 1>>
	 <COND (<ZERO? ,WOMAN-SCRIPT>
		<RTRUE>)>
	 <CRLF>
	 <COND (<EQUAL? ,WOMAN-SCRIPT 1>
		<TELL "The fog in the valley is rising towards you!">)

	       (<EQUAL? ,WOMAN-SCRIPT 2>
		<TELL "Fog is spilling over the edge of the cliff.">)
	       
	       (<EQUAL? ,WOMAN-SCRIPT 3>
		<TELL "Fingers of fog are swirling around your feet.">)

	       (T 
		<DISABLE <INT I-FOG-RISING>>
		<MOVE ,PROTAGONIST ,FOG>
		<SETG HERE ,FOG>
		<SETG TLOC 7>
		<START-BUZZ 1>
		<TELL 
"The rising mist envelops the cliff in a thick layer of..." CR CR>
		<V-LOOK>
		<RTRUE>)>
	 <CRLF>>

<ROUTINE ENTER-FOG? ()
	 <COND (,ENDING?
		<SETG WOMAN-SCRIPT 5>
		<TELL "A sudden noise from the " D ,MAGICK-SHOPPE
		      " changes your mind." CR>
		<RFALSE>)>
	 <SETG TLOC 6>
	 <START-BUZZ 1>
	 <COND (,SKEWED?
		<TELL
"As you descend the " D ,TRAIL " you are immediately engulfed in..." CR CR>
		<RETURN ,FOG>)
	       (T
		<RETURN ,STEEP-TRAIL>)>>

<ROUTINE FOG-PSEUDO ()
	 <COND (<VERB? EXAMINE LOOK-THRU LOOK-INSIDE>
		<TELL "It's so thick you can barely see your own feet!" CR>
		<RTRUE>)
	       (<VERB? TAKE WALK-TO ENTER THROUGH>
		<TELL "There's more than enough right here." CR>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED "fog" T>
		<RFATAL>)>>

<OBJECT STEEP-TRAIL
	(IN ROOMS)
	(DESC "Steep Trail")
	(FLAGS ONBIT RLANDBIT RMUNGBIT)
	(GLOBAL TRAIL CLIFF)
	(NORTH PER N-TRAIL)
	(EAST PER E-TRAIL)
	(SOUTH PER S-TRAIL)
	(WEST PER W-TRAIL)
	(UP PER U-TRAIL)
	(DOWN PER D-TRAIL)
	(ACTION STEEP-TRAIL-F)>

; "RMUNGBIT = No map warning given"

<ROUTINE STEEP-TRAIL-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "A steep, rocky " D ,TRAIL " winds "
		      <GET ,TRAILS ,TLOC> "." CR>)>>
		
<GLOBAL TRAILS
	<PLTABLE 
	 "west and downward"
	 "north and east"
	 "south and upward"
	 "east and downward"
	 "south and west"
	 "north and upward">>

<ROUTINE N-TRAIL ()
	 <COND (<EQUAL? ,TLOC 1 3 7>
		<BUMP-CLIFF>
		<RFALSE>)
	       (<EQUAL? ,TLOC 4 5>
		<PROB-TUMBLE>
		<RFALSE>)
	       (<EQUAL? ,TLOC 2>
		<NEW-TRAIL 3>)
	       (T ; "6"
		<NEW-TRAIL 5>)>
	 <RETURN <NEXT-CELL>>>

<ROUTINE E-TRAIL ()
	 <COND (<EQUAL? ,TLOC 5 6 7>
		<PROB-TUMBLE>
		<RFALSE>)
	       (<EQUAL? ,TLOC 1 3>
		<BUMP-CLIFF>
		<RFALSE>)
	       (<EQUAL? ,TLOC 2>
		<NEW-TRAIL 1>)
	       (T ; "4"
		<NEW-TRAIL 5>)>
	 <RETURN <NEXT-CELL>>>

<ROUTINE S-TRAIL ()
	 <COND (<EQUAL? ,TLOC 1 2 7>
		<PROB-TUMBLE>
		<RFALSE>)
	       (<EQUAL? ,TLOC 4 6>
		<BUMP-CLIFF>
		<RFALSE>)
	       (<EQUAL? ,TLOC 3>
		<NEW-TRAIL 2>)
	       (T ; "5"
		<NEW-TRAIL 6>)>
	 <RETURN <NEXT-CELL>>>

<ROUTINE W-TRAIL ()
	 <COND (<EQUAL? ,TLOC 2 3 4>
		<PROB-TUMBLE>
		<RFALSE>)
	       (<EQUAL? ,TLOC 6>
		<BUMP-CLIFF>
		<RFALSE>)
	       (<EQUAL? ,TLOC 1>
		<NEW-TRAIL 2>)
	       (<EQUAL? ,TLOC 5>
		<NEW-TRAIL 4>)
	       (T ; "7"
		<TELL "Crash! ">
		<BELL-TINKLES>
		<RFALSE>)>
	 <RETURN <NEXT-CELL>>>

<ROUTINE U-TRAIL ()
	 <COND (<OR <EQUAL? ,TLOC 1 2 4>
		    <EQUAL? ,TLOC 5 7>>
		<CANT-SEE-ANY "any upward trails" T>
		<RFALSE>)
	       (<EQUAL? ,TLOC 3>
		<NEW-TRAIL 4>)
	       (T ; "6"
		<COND (,SKEWED?
		       <SETG TLOC 7>)
		      (T
		       <SETG TLOC <>>
		       <COND (<FSET? ,CLIFF-EDGE ,RMUNGBIT>
			      <FCLEAR ,CLIFF-EDGE ,RMUNGBIT>
			      <UPDATE-SCORE 1>
			      <CRLF>)>
		       <RETURN ,CLIFF-EDGE>)>)>
	 <RETURN <NEXT-CELL>>>

<ROUTINE D-TRAIL ()
	 <COND (<OR <EQUAL? ,TLOC 2 3 5>
		    <EQUAL? ,TLOC 6>>
		<CANT-SEE-ANY "any downward trails" T>
		<RFALSE>)
	       (<EQUAL? ,TLOC 1>
		<COND (,SKEWED?
		       <WALK-OUT-OF-FOG>)>
		<SETG TLOC <>>
		<RETURN ,CLIFF-BOTTOM>)
	       (<EQUAL? ,TLOC 4>
		<NEW-TRAIL 3>)
	       (T ; "7"
		<NEW-TRAIL 6>)>
	 <RETURN <NEXT-CELL>>>

<ROUTINE NEXT-CELL ()
	 <COND (,SKEWED?
		<FCLEAR ,FOG ,TOUCHBIT>
		<RETURN ,FOG>)
	       (T
		<RETURN ,STEEP-TRAIL>)>>

<ROUTINE WALK-OUT-OF-FOG ()
	 <START-BUZZ 2>
	 <SUDDEN-GUST>
	 <TELL "dissolves the fog and clears your vision." CR CR>>

<ROUTINE SUDDEN-GUST ()
	 <TELL "A sudden gust of wind ">>

<ROUTINE NEW-TRAIL (NEW-LOC)
	 <FCLEAR ,FOG ,TOUCHBIT>
	 <FCLEAR ,STEEP-TRAIL ,TOUCHBIT>
	 <SETG TLOC .NEW-LOC>>

<ROUTINE BUMP-CLIFF ()
	 <TELL <PICK-ONE ,BUMPS> "." CR>
	 <RFALSE>>

<GLOBAL BUMPS
	<LTABLE 0
	 "A cliff wall blocks your path"
	 "You just walked into a solid wall of stone"
	 "Your path is blocked by a cliff wall">>

<GLOBAL T-PROB 0>

<ROUTINE PROB-TUMBLE ()
	 <SETG T-PROB <+ ,T-PROB 10>>
	 <COND (<OR <EQUAL? ,T-PROB 100>
		    <PROB ,T-PROB>>
		<TELL 
"Oh, no! You lost your footing and tumbled off the cliff!">
		<BAD-ENDING>)
	       (T
		<TUMBLE>)>>

<ROUTINE TUMBLE ()
	 <TELL "You'd " <PICK-ONE ,FALLS>>
	 <COND (<EQUAL? ,HERE ,HILLTOP ,LOOKOUT-HILL>
		<TELL " down the hill">)
	       (T
		<TELL " off the " D ,CLIFF>)>
	 <WENT-THAT-WAY>
	 <RFALSE>>

<GLOBAL FALLS
	<LTABLE 0 "tumble" "fall" "plummet">>
	 




