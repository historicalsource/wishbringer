"NORTH for WISHBRINGER: (C)1985 Infocom, Inc. All rights reserved."

"*** WEST OF HOUSE ***"

<OBJECT WEST-OF-HOUSE
	(IN ROOMS)
	(DESC "West of House")
	(LDESC
"You are standing in an open field west of a white house, with a boarded front door.")
	(FLAGS ONBIT RLANDBIT)
	(GLOBAL TREE TRAIL)
	(NORTH PER BACK-TO-ROCKY-PATH)
	(SOUTH PER UNWILLING-TO-MOVE)
	(EAST PER BOARDS-ARE-SECURE)
      	(WEST PER UNWILLING-TO-MOVE)
	(IN PER BOARDS-ARE-SECURE)>

<ROUTINE BACK-TO-ROCKY-PATH ()
	 <COND (<ENABLED? ,I-WAKE-SMALL-BOX>
		<TELL "The spectacle of the " D ,SMALL-BOX
		      " has you frozen in your tracks." CR>
		<RFALSE>)
	       (T
		<TELL "As the house disappears into the distance, you get the distinct feeling that, someday, you will pass this way again.">
	        <CARRIAGE-RETURNS>
	        <RETURN ,ROCKY-PATH>)>>

<ROUTINE BOARDS-ARE-SECURE ()
	 <SAY-THE ,HOUSE-DOOR>
	 <TELL " is securely closed." CR>
	 <RFALSE>>

<OBJECT WHITE-HOUSE
	(IN WEST-OF-HOUSE)
	(DESC "house")
	(SYNONYM HOUSE)
	(ADJECTIVE WHITE)
	(FLAGS NDESCBIT)
	(ACTION WHITE-HOUSE-F)>

<ROUTINE WHITE-HOUSE-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"This place has seen better days. Its stately colonial architecture reflects the taste and wealth of its builders. But eons of trespassing by thoughtless adventurers have left the once noble edifice in ruins." CR>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE OPEN MUNG THROUGH ENTER>
		<BOARDS-ARE-SECURE>
	        <RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT HOUSE-DOOR
	(IN WEST-OF-HOUSE)
	(DESC "front door")
	(SYNONYM DOOR ENTRANCE ENTRY BOARDS)
	(ADJECTIVE FRONT BOARDED)
	(FLAGS NDESCBIT DOORBIT)
	(ACTION HOUSE-DOOR-F)>

<ROUTINE HOUSE-DOOR-F ()
	 <COND (<OR <HURT? ,HOUSE-DOOR>
		    <VERB? OPEN>>
		<BOARDS-ARE-SECURE>
		<RTRUE>)
	       (<USE-DOOR? ,WEST-OF-HOUSE>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT LEAFLET
	(IN SMALL-BOX)
	(DESC "leaflet")
	(SYNONYM LEAFLET MAIL ADVERT AD)
	(ADJECTIVE JUNK-MAIL CANCEL JUNK STAMPED STAMP)
	(FLAGS TAKEBIT READBIT)
	(ACTION LEAFLET-F)
	(VALUE 0)
	(SIZE 1)>

<ROUTINE LEAFLET-F ()
	 <COND (<VERB? READ LOOK-ON EXAMINE>
		<COND (<IN? ,LEAFLET ,PROTAGONIST>
		       <TELL "It seems to be a junk-mail ad for a primitive computer game. The cancelled stamp on the " D ,LEAFLET>
		       <TOO-FADED>)
		      (T
		       <YOUD-HAVE-TO "be holding" ,LEAFLET>)>
		<RTRUE>)
	       (<HURT? ,LEAFLET>
		<RUIN ,LEAFLET>
		<RTRUE>)
	       (T
		<RFALSE>)>>
	       
"*** ROCKY PATH ***"

<OBJECT ROCKY-PATH
	(IN ROOMS)
	(DESC "Rocky Path")
	(FLAGS ONBIT RLANDBIT WETBIT)
	(GLOBAL RIVER TREE TRAIL)
	(NORTH PER PROBABLY-DROWN)
	(EAST TO FESTERON-POINT)
	(SOUTH PER ENTER-HOUSE?)
	(WEST TO SOUTH-OF-BRIDGE)
	(ACTION ROCKY-PATH-F)
	(PSEUDO "FOREST" FOREST-PSEUDO "WOODS" FOREST-PSEUDO)>

<ROUTINE FOREST-PSEUDO ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE>
		<TELL "It's ">
		<COND (<NOT ,HOUSE-VISITED?>
		       <TELL "almost ">)>
		<TELL "impenetrable." CR>
		<RTRUE>)
	       (<VERB? ENTER THROUGH WALK-TO>
		<DO-WALK ,P?SOUTH>
		<RTRUE>)
	       (T
		<YOU-DONT-NEED "forest" T>
		<RFATAL>)>>
		
<GLOBAL HOUSE-VISITED? <>>

<ROUTINE ROCKY-PATH-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL "You're on a rocky path that runs east and west along the banks of the">
		<WHICH-TOWN "River">
		<TELL ". A ">
		<COND (<AND ,SKEWED?
		       	    <NOT ,HOUSE-VISITED?>>
		       <TELL
"shimmering " D ,TRAIL " leads south into a dense forest">)
		      (T
		       <TELL
"dense, impenetrable forest borders the south edge of the path">)>
		<TELL "." CR>)>>

<ROUTINE ENTER-HOUSE? ()
	 <COND (<AND ,SKEWED?
		     <NOT ,HOUSE-VISITED?>>
		<TELL
"As you walk along the shimmering " D ,TRAIL " you feel a vague sense of disorientation, then a shock of recognition...">
		<CARRIAGE-RETURNS>
		<RETURN ,WEST-OF-HOUSE>)
	       (T
	        <TELL ,CANT " enter an impenetrable forest." CR>
		<RFALSE>)>>

"*** SOUTH OF BRIDGE ***"

<OBJECT RIVER
	(IN LOCAL-GLOBALS)
	(DESC "river")
	(SYNONYM RIVER WATER)
	(ADJECTIVE FESTERON WITCHVILLE)
	(FLAGS NDESCBIT TRYTAKEBIT CONTBIT OPENBIT)
	(ACTION RIVER-F)>

<ROUTINE RIVER-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "The current looks swift and ">
		<COND (,SKEWED?
		       <TELL "murky">)
		      (T
		       <TELL "clean">)>
		<TELL "." CR>
		<RTRUE>)
	       (<VERB? CROSS>
		<COND (<EQUAL? ,HERE ,SOUTH-OF-BRIDGE>
		       <DO-WALK ,P?NORTH>)
		      (<EQUAL? ,HERE ,NORTH-OF-BRIDGE>
		       <DO-WALK ,P?SOUTH>)
		      (T
		       <V-WALK-AROUND>)>
		<RTRUE>)
	       (<HANDLE-WATER?>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT SOUTH-OF-BRIDGE
	(IN ROOMS)
	(DESC "South of Bridge")
	(FLAGS ONBIT RLANDBIT WETBIT)
	(GLOBAL RIVER BRIDGE)
	(NORTH PER GO-ON-BRIDGE)
	(EAST TO ROCKY-PATH)
	(SOUTH TO ROTARY-NORTH)
	(WEST TO RIVER-OUTLET)
	(ACTION SOUTH-OF-BRIDGE-F)>
		       
<ROUTINE SOUTH-OF-BRIDGE-F (CONTEXT)
	 <COND (<EQUAL? .CONTEXT ,M-LOOK>
		<TELL
"This is the south side of a " D ,BRIDGE " that spans the">
		<WHICH-TOWN "River">
		<TELL ". Paths lead off " <TO-E> " and west, and a road leads south to the " D ,FESTERON "." CR>)>>

<ROUTINE GO-ON-BRIDGE ()
	 <SETG WHERE-FROM ,SOUTH-OF-BRIDGE>
	 <RETURN ,ON-BRIDGE>>