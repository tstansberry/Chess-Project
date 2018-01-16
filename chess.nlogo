turtles-own [team movedyet? piecename selected? timesMoved]
patches-own [original-color]
globals [numberSelected turn ahead? green? rightWhiteRook leftWhiteRook rightBlackRook leftBlackRook timerwhite timerblack leftWhiteEnPassent rightWhiteEnPassent leftBlackEnPassent rightBlackEnPassent]
breed [pawns pawn]
breed [rooks rook]
breed [knights knight]
breed [bishops bishop]
breed [kings king]
breed [queens queen]

;SETTING UP THE WORLD
to setup
  ;RESIZING WORLD
  ca
  set-patch-size 70
  resize-world 0 7 0 7

  ;BOARD
  ask patches [
    ifelse ((pxcor + pycor) mod 2 = 0)[set pcolor white][set pcolor gray]
    set original-color pcolor]
  set turn 0

  ;PAWNS
  set-default-shape pawns "chess pawn"
  cro 8 [set color 49 set xcor who set ycor 1 set heading 0 set breed pawns]
  cro 8 [set color black set xcor (who - 8) set ycor 6 set heading 180 set breed pawns]
  ;ROOKS
  set-default-shape rooks "chess rook"
  cro 1 [set color 49 set heading 0 set breed rooks]
  cro 1 [set color 49 set xcor 7 set heading 0 set breed rooks]
  cro 1 [set color black set heading 180 set ycor 7 set breed rooks]
  cro 1 [set color black set heading 180 set ycor 7 set xcor 7 set breed rooks]
  ;KNIGHTS
  set-default-shape knights "chess knight"
  cro 1 [set color 49 set heading 0 set xcor 1 set breed knights]
  cro 1 [set color 49 set heading 0 set xcor 6 set breed knights]
  cro 1 [set color black set heading 180 set xcor 1 set ycor 7 set breed knights]
  cro 1 [set color black set heading 180 set xcor 6 set ycor 7 set breed knights]
  ;BISHOPS
  set-default-shape bishops "chess bishop"
  cro 1 [set color 49 set heading 0 set xcor 2 set breed bishops]
  cro 1 [set color 49 set heading 0 set xcor 5 set breed bishops]
  cro 1 [set color black set heading 180 set xcor 2 set ycor 7 set breed bishops]
  cro 1 [set color black set heading 180 set xcor 5 set ycor 7 set breed bishops]
  ;KINGS
  set-default-shape kings "chess king"
  cro 1 [set color 49 set heading 0 set xcor 3 set breed kings]
  cro 1 [set color black set heading 180 set xcor 3 set ycor 7 set breed kings]
  ;QUEENS
  set-default-shape queens "chess queen"
  cro 1 [set color 49 set heading 0 set xcor 4 set breed queens]
  cro 1 [set color black set heading 180 set xcor 4 set ycor 7 set breed queens]

  ask turtles [
    if color = black [
      set team "black"]
    if color = 49 [
      set team "white"]]
  ;timer
  set timerwhite playtime * 60
  set timerblack playtime * 60
end

;SELECTING THE PIECES
to selectPiece
  if mouse-down? and mouse-inside? and numberSelected = 0[
    ask turtles with [pxcor = round mouse-xcor and pycor = round mouse-ycor and team = setMove][
      set color green
      set selected? true set numberSelected numberSelected + 1
      calculateMoves]]
end

to deselectPiece
  let run? false
  if mouse-down? and mouse-inside? and numberSelected = 1[
    ask patch mouse-xcor mouse-ycor [
      if count turtles-here with [selected? = true] > 0[
        ask turtles-here [
          if team = "white" [
            set color 49
            set selected? false
            set run? true]
          if team = "black" [
            set color black
            set selected? false
            set run? true]
          set selected? false set numberSelected numberSelected - 1]]]
    if run? = true [
      ask patches [set pcolor original-color]]
    set ahead? false]
end

to go
  every .031 [
    if numberSelected = 0 [
      selectPiece
      wait 0.14]
    if numberSelected = 1[
      deselectPiece
      executeMove
      wait .12]]
end

;CALCULATING MOVES
to calculateMoves
  if breed = pawns [
    calculateWhitePawnMove
    calculateBlackPawnMove
    enPassentWhite
    enPassentBlack]
  if breed = knights [
    calculateWhiteKnightMove
    calculateBlackKnightMove]
  if breed = bishops [
    calculateWhiteBishopMove
    calculateBlackBishopMove]
  if breed = rooks [
    calculateWhiteRookMove
    calculateBlackRookMove]
  if breed = kings [
    calculateWhiteKingMove
    calculateBlackKingMove
    whiteCastle
    blackCastle]
  if breed = queens [
    calculateWhiteQueenMove
    calculateBlackQueenMove]
end

to calculateWhitePawnMove
  if team = "white"[
    if movedyet? != true [
      if([xcor] of self - 1) <= 7 and ([ycor] of self + 1) <= 7 and ([xcor] of self - 1) >= 0 and ([ycor] of self + 1) >= 0 [
        ask patch ([xcor] of self - 1) ([ycor] of self + 1) [
          if count turtles-here with [team = "black"] > 0 [
            set pcolor green]]]
      if([xcor] of self + 1) <= 7 and ([ycor] of self + 1) <= 7 and ([xcor] of self + 1) >= 0 and ([ycor] of self + 1) >= 0 [
        ask patch ([xcor] of self + 1) ([ycor] of self + 1) [
          if count turtles-here with [team = "black"] > 0 [
            set pcolor green]]]
      ask patch [xcor] of self ([ycor] of self + 1)[
        ifelse count turtles-here = 0 [
          set pcolor green][set ahead? true]]
      ask patch [xcor] of self ([ycor] of self + 2)[
        if count turtles-here = 0 and ahead? != true[
          set pcolor green]]]
    if movedyet? = true [
      if([xcor] of self + 1) <= 7 and ([ycor] of self + 1) <= 7 and ([xcor] of self + 1) >= 0 and ([ycor] of self + 1) >= 0 [
        ask patch ([xcor] of self + 1) ([ycor] of self + 1) [
          if count turtles-here with [team = "black"] > 0 [
            set pcolor green]]]
      if([xcor] of self - 1) <= 7 and ([ycor] of self + 1) <= 7 and ([xcor] of self - 1) >= 0 and ([ycor] of self + 1) >= 0 [
        ask patch ([xcor] of self - 1) ([ycor] of self + 1) [
          if count turtles-here with [team = "black"] > 0 [
            set pcolor green]]]
      ask patch [xcor] of self ([ycor] of self + 1)[
        if count turtles-here = 0 [
          set pcolor green]]]]
end

to calculateBlackPawnMove
  if team = "black" [
    if movedyet? != true [
      if([xcor] of self + 1) <= 7 and ([ycor] of self - 1) <= 7 and ([xcor] of self + 1) >= 0 and ([ycor] of self - 1) >= 0 [
        ask patch ([xcor] of self + 1) ([ycor] of self - 1) [
          if count turtles-here with [team = "white"] > 0 [
            set pcolor green]]]
      if([xcor] of self - 1) <= 7 and ([ycor] of self - 1) <= 7 and ([xcor] of self - 1) >= 0 and ([ycor] of self - 1) >= 0 [
        ask patch ([xcor] of self - 1) ([ycor] of self - 1) [
          if count turtles-here with [team = "white"] > 0 [
            set pcolor green]]]
      ask patch [xcor] of self ([ycor] of self - 1)[
        ifelse count turtles-here = 0 [
          set pcolor green][set ahead? true]]
      ask patch [xcor] of self ([ycor] of self - 2)[
        if count turtles-here = 0 and ahead? != true[
          set pcolor green]]]
    if movedyet? = true [
      if([xcor] of self + 1) <= 7 and ([ycor] of self - 1) <= 7 and ([xcor] of self + 1) >= 0 and ([ycor] of self - 1) >= 0 [
        ask patch ([xcor] of self + 1) ([ycor] of self - 1) [
          if count turtles-here with [team = "white"] > 0 [
            set pcolor green]]]
      if([xcor] of self - 1) <= 7 and ([ycor] of self - 1) <= 7 and ([xcor] of self - 1) >= 0 and ([ycor] of self - 1) >= 0 [
        ask patch ([xcor] of self - 1) ([ycor] of self - 1) [
          if count turtles-here with [team = "white"] > 0 [
            set pcolor green]]]
      ask patch [xcor] of self ([ycor] of self - 1)[
        if count turtles-here = 0 [
          set pcolor green]]]]
end

to calculateWhiteKnightMove
  if team = "white" [
    if([xcor] of self + 2) <= 7 and ([ycor] of self + 1) <= 7 and ([xcor] of self + 2) >= 0 and ([ycor] of self + 1) >= 0 [
      ask patch ([xcor] of self + 2) ([ycor] of self + 1) [
        if count turtles-here with [team = "white"] = 0 [
          set pcolor green]]]
    if([xcor] of self + 2) <= 7 and ([ycor] of self - 1) <= 7 and ([xcor] of self + 2) >= 0 and ([ycor] of self - 1) >= 0 [
      ask patch ([xcor] of self + 2) ([ycor] of self - 1) [
        if count turtles-here with [team = "white"] = 0 [
          set pcolor green]]]
    if([xcor] of self + 1) <= 7 and ([ycor] of self + 2) <= 7 and ([xcor] of self + 1) >= 0 and ([ycor] of self + 2) >= 0 [
      ask patch ([xcor] of self + 1) ([ycor] of self + 2) [
        if count turtles-here with [team = "white"] = 0 [
          set pcolor green]]]
    if([xcor] of self - 1) <= 7 and ([ycor] of self + 2) <= 7 and ([xcor] of self - 1) >= 0 and ([ycor] of self + 2) >= 0 [
      ask patch ([xcor] of self - 1) ([ycor] of self + 2) [
        if count turtles-here with [team = "white"] = 0 [
          set pcolor green]]]
    if([xcor] of self - 2) <= 7 and ([ycor] of self + 1) <= 7 and ([xcor] of self - 2) >= 0 and ([ycor] of self + 1) >= 0 [
      ask patch ([xcor] of self - 2) ([ycor] of self + 1) [
        if count turtles-here with [team = "white"] = 0 [
          set pcolor green]]]
    if([xcor] of self + 1) <= 7 and ([ycor] of self - 2) <= 7 and ([xcor] of self + 1) >= 0 and ([ycor] of self - 2) >= 0 [
      ask patch ([xcor] of self + 1) ([ycor] of self - 2) [
        if count turtles-here with[team = "white"] = 0 [
          set pcolor green]]]
    if([xcor] of self - 1) <= 7 and ([ycor] of self - 2) <= 7 and ([xcor] of self - 1) >= 0 and ([ycor] of self - 2) >= 0 [
      ask patch ([xcor] of self - 1) ([ycor] of self - 2) [
        if count turtles-here with[team = "white"] = 0 [
          set pcolor green]]]
    if([xcor] of self - 2) <= 7 and ([ycor] of self - 1) <= 7 and ([xcor] of self - 2) >= 0 and ([ycor] of self - 1) >= 0 [
      ask patch ([xcor] of self - 2) ([ycor] of self - 1) [
        if count turtles-here with[team = "white"] = 0 [
          set pcolor green]]]]
end

to calculateBlackKnightMove
  if team = "black" [
    if([xcor] of self + 2) <= 7 and ([ycor] of self + 1) <= 7 and ([xcor] of self + 2) >= 0 and ([ycor] of self + 1) >= 0 [
      ask patch ([xcor] of self + 2) ([ycor] of self + 1) [
        if count turtles-here with [team = "black"] = 0 [
          set pcolor green]]]
    if([xcor] of self + 2) <= 7 and ([ycor] of self - 1) <= 7 and ([xcor] of self + 2) >= 0 and ([ycor] of self - 1) >= 0 [
      ask patch ([xcor] of self + 2) ([ycor] of self - 1) [
        if count turtles-here with [team = "black"] = 0 [
          set pcolor green]]]
    if([xcor] of self + 1) <= 7 and ([ycor] of self + 2) <= 7 and ([xcor] of self + 1) >= 0 and ([ycor] of self + 2) >= 0 [
      ask patch ([xcor] of self + 1) ([ycor] of self + 2) [
        if count turtles-here with [team = "black"] = 0 [
          set pcolor green]]]
    if([xcor] of self - 1) <= 7 and ([ycor] of self + 2) <= 7 and ([xcor] of self - 1) >= 0 and ([ycor] of self + 2) >= 0 [
      ask patch ([xcor] of self - 1) ([ycor] of self + 2) [
        if count turtles-here with [team = "black"] = 0 [
          set pcolor green]]]
    if([xcor] of self - 2) <= 7 and ([ycor] of self + 1) <= 7 and ([xcor] of self - 2) >= 0 and ([ycor] of self + 1) >= 0 [
      ask patch ([xcor] of self - 2) ([ycor] of self + 1) [
        if count turtles-here with [team = "black"] = 0 [
          set pcolor green]]]
    if([xcor] of self + 1) <= 7 and ([ycor] of self - 2) <= 7 and ([xcor] of self + 1) >= 0 and ([ycor] of self - 2) >= 0 [
      ask patch ([xcor] of self + 1) ([ycor] of self - 2) [
        if count turtles-here with [team = "black"] = 0 [
          set pcolor green]]]
    if([xcor] of self - 1) <= 7 and ([ycor] of self - 2) <= 7 and ([xcor] of self - 1) >= 0 and ([ycor] of self - 2) >= 0 [
      ask patch ([xcor] of self - 1) ([ycor] of self - 2) [
        if count turtles-here with [team = "black"] = 0 [
          set pcolor green]]]
    if([xcor] of self - 2) <= 7 and ([ycor] of self - 1) <= 7 and ([xcor] of self - 2) >= 0 and ([ycor] of self - 1) >= 0 [
      ask patch ([xcor] of self - 2) ([ycor] of self - 1) [
        if count turtles-here with [team = "black"] = 0 [
          set pcolor green]]]]
end

to calculateWhiteBishopMove
  if team = "white" [
    let xvar 1 let yvar 1
    repeat 7 [
      if([xcor] of self + xvar) <= 7 and ([ycor] of self + yvar) <= 7 and ([xcor] of self + xvar) >= 0 and ([ycor] of self + yvar) >= 0 [
        ask patch ([xcor] of self + xvar) ([ycor] of self + yvar) [
          continueWhitePath?]]
      set xvar xvar + 1 set yvar yvar + 1]
    set ahead? false

    set xvar 1 set yvar 1
    repeat 7 [
      if([xcor] of self - xvar) <= 7 and ([ycor] of self - yvar) <= 7 and ([xcor] of self - xvar) >= 0 and ([ycor] of self - yvar) >= 0 [
        ask patch ([xcor] of self - xvar) ([ycor] of self - yvar) [
          continueWhitePath?]]
      set xvar xvar + 1 set yvar yvar + 1]
    set ahead? false

    set xvar 1 set yvar 1
    repeat 7 [
      if([xcor] of self + xvar) <= 7 and ([ycor] of self - yvar) <= 7 and ([xcor] of self + xvar) >= 0 and ([ycor] of self - yvar) >= 0 [
        ask patch ([xcor] of self + xvar) ([ycor] of self - yvar) [
          continueWhitePath?]]
      set xvar xvar + 1 set yvar yvar + 1]
    set ahead? false

    set xvar 1 set yvar 1
    repeat 7 [
      if([xcor] of self - xvar) <= 7 and ([ycor] of self + yvar) <= 7 and ([xcor] of self - xvar) >= 0 and ([ycor] of self + yvar) >= 0 [
        ask patch ([xcor] of self - xvar) ([ycor] of self + yvar) [
          continueWhitePath?]]
      set xvar xvar + 1 set yvar yvar + 1]
    set ahead? false]
end

to calculateBlackBishopMove
  if team = "black" [
    let xvar 1 let yvar 1
    repeat 7 [
      if([xcor] of self + xvar) <= 7 and ([ycor] of self + yvar) <= 7 and ([xcor] of self + xvar) >= 0 and ([ycor] of self + yvar) >= 0 [
        ask patch ([xcor] of self + xvar) ([ycor] of self + yvar) [
          continueBlackPath?]]
      set xvar xvar + 1 set yvar yvar + 1]
    set ahead? false

    set xvar 1 set yvar 1
    repeat 7 [
      if([xcor] of self - xvar) <= 7 and ([ycor] of self - yvar) <= 7 and ([xcor] of self - xvar) >= 0 and ([ycor] of self - yvar) >= 0 [
        ask patch ([xcor] of self - xvar) ([ycor] of self - yvar) [
          continueBlackPath?]]
      set xvar xvar + 1 set yvar yvar + 1]
    set ahead? false

    set xvar 1 set yvar 1
    repeat 7 [
      if([xcor] of self + xvar) <= 7 and ([ycor] of self - yvar) <= 7 and ([xcor] of self + xvar) >= 0 and ([ycor] of self - yvar) >= 0 [
        ask patch ([xcor] of self + xvar) ([ycor] of self - yvar) [
          continueBlackPath?]]
      set xvar xvar + 1 set yvar yvar + 1]
    set ahead? false

    set xvar 1 set yvar 1
    repeat 7 [
      if([xcor] of self - xvar) <= 7 and ([ycor] of self + yvar) <= 7 and ([xcor] of self - xvar) >= 0 and ([ycor] of self + yvar) >= 0 [
        ask patch ([xcor] of self - xvar) ([ycor] of self + yvar) [
          continueBlackPath?]]
      set xvar xvar + 1 set yvar yvar + 1]
    set ahead? false]
end

to calculateWhiteKingMove
  if team = "white" [
    if([xcor] of self + 1) <= 7 and ([ycor] of self + 1) <= 7 and ([xcor] of self + 1) >= 0 and ([ycor] of self + 1) >= 0 [
      ask patch ([xcor] of self + 1) ([ycor] of self + 1) [
        if count turtles-here with [team = "white"] = 0 [
          set pcolor green]]]
    if([xcor] of self - 1) <= 7 and ([ycor] of self - 1) <= 7 and ([xcor] of self - 1) >= 0 and ([ycor] of self - 1) >= 0 [
      ask patch ([xcor] of self - 1) ([ycor] of self - 1) [
        if count turtles-here with [team = "white"] = 0 [
          set pcolor green]]]
    if([xcor] of self + 1) <= 7 and ([ycor] of self - 1) <= 7 and ([xcor] of self + 1) >= 0 and ([ycor] of self - 1) >= 0 [
      ask patch ([xcor] of self + 1) ([ycor] of self - 1) [
        if count turtles-here with [team = "white"] = 0 [
          set pcolor green]]]
    if([xcor] of self - 1) <= 7 and ([ycor] of self + 1) <= 7 and ([xcor] of self - 1) >= 0 and ([ycor] of self + 1) >= 0 [
      ask patch ([xcor] of self - 1) ([ycor] of self + 1) [
        if count turtles-here with [team = "white"] = 0 [
          set pcolor green]]]
    if [xcor] of self <= 7 and ([ycor] of self + 1) <= 7 and [xcor] of self >= 0 and ([ycor] of self + 1) >= 0 [
      ask patch [xcor] of self ([ycor] of self + 1) [
        if count turtles-here with [team = "white"]  = 0[
          set pcolor green]]]
    if [xcor] of self <= 7 and ([ycor] of self - 1) <= 7 and [xcor] of self >= 0 and ([ycor] of self - 1) >= 0 [
      ask patch [xcor] of self ([ycor] of self - 1) [
        if count turtles-here with [team = "white"]  = 0[
          set pcolor green]]]
    if([xcor] of self + 1) <= 7 and [ycor] of self <= 7 and ([xcor] of self + 1) >= 0 and [ycor] of self >= 0 [
      ask patch ([xcor] of self + 1) [ycor] of self [
        if count turtles-here with [team = "white"]  = 0[
          set pcolor green]]]
    if([xcor] of self - 1) <= 7 and [ycor] of self <= 7 and ([xcor] of self - 1) >= 0 and [ycor] of self >= 0 [
      ask patch ([xcor] of self - 1) [ycor] of self [
        if count turtles-here with [team = "white"]  = 0[
          set pcolor green]]]]
end

to calculateBlackKingMove
  if team = "black" [
    if([xcor] of self + 1) <= 7 and ([ycor] of self + 1) <= 7 and ([xcor] of self + 1) >= 0 and ([ycor] of self + 1) >= 0 [
      ask patch ([xcor] of self + 1) ([ycor] of self + 1) [
        if count turtles-here with [team = "black"]  = 0[
          set pcolor green]]]
    if([xcor] of self - 1) <= 7 and ([ycor] of self - 1) <= 7 and ([xcor] of self - 1) >= 0 and ([ycor] of self - 1) >= 0 [
      ask patch ([xcor] of self - 1) ([ycor] of self - 1) [
        if count turtles-here with [team = "black"]  = 0[
          set pcolor green]]]
    if([xcor] of self + 1) <= 7 and ([ycor] of self - 1) <= 7 and ([xcor] of self + 1) >= 0 and ([ycor] of self - 1) >= 0 [
      ask patch ([xcor] of self + 1) ([ycor] of self - 1) [
        if count turtles-here with [team = "black"]  = 0[
          set pcolor green]]]
    if([xcor] of self - 1) <= 7 and ([ycor] of self + 1) <= 7 and ([xcor] of self - 1) >= 0 and ([ycor] of self + 1) >= 0 [
      ask patch ([xcor] of self - 1) ([ycor] of self + 1) [
        if count turtles-here with [team = "black"]  = 0[
          set pcolor green]]]
    if [xcor] of self <= 7 and ([ycor] of self + 1) <= 7 and [xcor] of self >= 0 and ([ycor] of self + 1) >= 0 [
      ask patch [xcor] of self ([ycor] of self + 1) [
        if count turtles-here with [team = "black"]  = 0[
          set pcolor green]]]
    if [xcor] of self <= 7 and ([ycor] of self - 1) <= 7 and [xcor] of self >= 0 and ([ycor] of self - 1) >= 0 [
      ask patch [xcor] of self ([ycor] of self - 1) [
        if count turtles-here with [team = "black"]  = 0[
          set pcolor green]]]
    if([xcor] of self + 1) <= 7 and [ycor] of self <= 7 and ([xcor] of self + 1) >= 0 and [ycor] of self >= 0 [
      ask patch ([xcor] of self + 1) [ycor] of self [
        if count turtles-here with [team = "black"]  = 0[
          set pcolor green]]]
    if([xcor] of self - 1) <= 7 and [ycor] of self <= 7 and ([xcor] of self - 1) >= 0 and [ycor] of self >= 0 [
      ask patch ([xcor] of self - 1) [ycor] of self [
        if count turtles-here with [team = "black"]  = 0[
          set pcolor green]]]]
end

to calculateWhiteQueenMove
  if team = "white" [
    calculateWhiteRookMove
    calculateWhiteBishopMove]
end

to calculateBlackQueenMove
  if team = "black" [
    calculateBlackRookMove
    calculateBlackBishopMove]
end

to calculateWhiteRookMove
  if team = "white" [
    let xvar 1
    repeat 7 [
      if([xcor] of self + xvar) <= 7 and ([xcor] of self + xvar) > 0 [
        ask patch ([xcor] of self + xvar) ([ycor] of self) [
          continueWhitePath?]]
      set xvar xvar + 1]
    set ahead? false
    
    set xvar 1
    repeat 7 [
      if([xcor] of self - xvar) <= 7 and ([xcor] of self - xvar) > 0 [
        ask patch ([xcor] of self - xvar) ([ycor] of self) [
          continueWhitePath?]]
      set xvar xvar + 1]
    set ahead? false

    let yvar 1
    repeat 7 [
      if ([ycor] of self + yvar) <= 7 and ([ycor] of self + yvar) >= 0 [
        ask patch ([xcor] of self) ([ycor] of self + yvar) [
          continueWhitePath?]]
      set yvar yvar + 1]
    set ahead? false

    set yvar 1
    repeat 7 [
      if ([ycor] of self - yvar) <= 7 and ([ycor] of self - yvar) >= 0 [
        ask patch ([xcor] of self) ([ycor] of self - yvar) [
          continueWhitePath?]]
      set yvar yvar + 1]
    set ahead? false]
end

to calculateBlackRookMove
  if team = "black" [
    let xvar 1
    repeat 7 [
      if([xcor] of self + xvar) <= 7 and ([xcor] of self + xvar) > 0 [
        ask patch ([xcor] of self + xvar) ([ycor] of self) [
          continueBlackPath?]]
      set xvar xvar + 1]
    set ahead? false
    
    set xvar 1
    repeat 7 [
      if([xcor] of self - xvar) <= 7 and ([xcor] of self - xvar) > 0 [
        ask patch ([xcor] of self - xvar) ([ycor] of self) [
          continueBlackPath?]]
      set xvar xvar + 1]
    set ahead? false

    let yvar 1
    repeat 7 [
      if ([ycor] of self + yvar) <= 7 and ([ycor] of self + yvar) >= 0 [
        ask patch ([xcor] of self) ([ycor] of self + yvar) [
          continueBlackPath?]]
      set yvar yvar + 1]
    set ahead? false

    set yvar 1
    repeat 7 [
      if ([ycor] of self - yvar) <= 7 and ([ycor] of self - yvar) >= 0 [
        ask patch ([xcor] of self) ([ycor] of self - yvar) [
          continueBlackPath?]]
      set yvar yvar + 1]
    set ahead? false]
end

to continueWhitePath?
  if ahead? != true [
    if count turtles-here with [team = "white"] > 0[
      set ahead? true]
    if count turtles-here with [team = "black"] > 0[
      set ahead? true set pcolor green]
    if count turtles-here = 0 [
      set pcolor green]]
end

to continueBlackPath?
  if ahead? != true [
    if count turtles-here with [team = "black"] > 0[
      set ahead? true]
    if count turtles-here with [team = "white"] > 0[
      set ahead? true set pcolor green]
    if count turtles-here = 0 [
      set pcolor green]]
end

;EXECUTING MOVES
to executeMove
  let x 0
  let y 0
  set green? false
  if numberSelected = 1 and mouse-down? and mouse-inside? [
    ask patch mouse-xcor mouse-ycor [
      if pcolor = green [
        set green? true
        set x pxcor
        set y pycor
        ask turtles-here [
          die]]]
    if green? = true [
      ask turtles with [selected? = true] [
        setxy x y
        set movedyet? true
        set timesMoved timesMoved + 1]
      executeCastle
      executeEnPassent
      deselectAllPieces
      increaseTurn
    ifelse setMove = "white"
    [set timerblack timerblack + increment]
    [set timerwhite timerwhite + increment]]]
  pawnPromotion
  resetEnPassent
end

to deselectAllPieces
  ask turtles [
    set selected? false
    if team = "white" [
      set color 49]
    if team = "black" [
      set color black]]
  set numberSelected 0
  ask patches [
    set pcolor original-color]

end

;TURNS
to increaseTurn
  set turn turn + 1
end

to-report turns
  report turn
end

to-report setMove
  ifelse turns mod 2 = 0 [
    report "white"] [report "black"]
end

;SPECIAL MOVES
to whiteCastle
  let king? false
  let leftRook? false
  let RightRook? false
  let check1 false
  let check2 false
  let check3 false
  let check4 false
  let check5 false

  ask kings with [team = "white"] [
    if movedyet? != true [
      set king? true]]
  ask rook 16 [
    if movedyet? != true [
      set leftRook? true]]
  ask rook 17 [
    if movedyet? != true [
      set rightRook? true]]

  if king? and leftRook? [
    ask patch 1 0 [
      if count turtles-here = 0 [
        set check1 true]]
    ask patch 2 0 [
      if count turtles-here = 0 [
        set check2 true]]
    if check1 and check2 [
      ask patch 1 0 [
        set pcolor green
        set leftWhiteRook true]]]

  if king? and rightRook? [
    ask patch 4 0 [
      if count turtles-here = 0 [
        set check3 true]]
    ask patch 5 0 [
      if count turtles-here = 0 [
        set check4 true]]
    ask patch 6 0 [
      if count turtles-here = 0 [
        set check5 true]]
    if check3 and check4 and check5 [
      ask patch 6 0 [
        set pcolor green
        set rightWhiteRook true]]]
end

to blackCastle
  let king? false
  let leftRook? false
  let RightRook? false
  let check1 false
  let check2 false
  let check3 false
  let check4 false
  let check5 false

  ask kings with [team = "black"] [
    if movedyet? != true [
      set king? true]]
  ask rook 18 [
    if movedyet? != true [
      set leftRook? true]]
  ask rook 19 [
    if movedyet? != true [
      set rightRook? true]]

  if king? and leftRook? [
    ask patch 1 7 [
      if count turtles-here = 0 [
        set check1 true]]
    ask patch 2 7 [
      if count turtles-here = 0 [
        set check2 true]]
    if check1 and check2 [
      ask patch 1 7 [
        set pcolor green
        set leftBlackRook true]]]

  if king? and rightRook? [
    ask patch 4 7 [
      if count turtles-here = 0 [
        set check3 true]]
    ask patch 5 7 [
      if count turtles-here = 0 [
        set check4 true]]
    ask patch 6 7 [
      if count turtles-here = 0 [
        set check5 true]]
    if check3 and check4 and check5 [
      ask patch 6 7 [
        set pcolor green
        set rightBlackRook true]]]
end

to executeCastle
  if rightWhiteRook = true and round mouse-xcor = 6 and round mouse-ycor = 0 and mouse-down?[
    ask rook 17 [
      setxy 5 0]
    set rightWhiteRook false
    set leftWhiteRook false
    set rightBlackRook false
    set leftBlackRook false]
  if leftWhiteRook = true and round mouse-xcor = 1 and round mouse-ycor = 0 and mouse-down?[
    ask rook 16 [
      setxy 2 0]
    set rightWhiteRook false
    set leftWhiteRook false
    set rightBlackRook false
    set leftBlackRook false]
  if rightBlackRook = true and round mouse-xcor = 6 and round mouse-ycor = 7 and mouse-down?[
    ask rook 19 [
      setxy 5 7]
    set rightWhiteRook false
    set leftWhiteRook false
    set rightBlackRook false
    set leftBlackRook false]
  if leftBlackRook = true and round mouse-xcor = 1 and round mouse-ycor = 7 and mouse-down?[
    ask rook 18 [
      setxy 2 7]
    set rightWhiteRook false
    set leftWhiteRook false
    set rightBlackRook false
    set leftBlackRook false]
end

to-report whiteseconds
  report timerwhite - whiteminutes * 60
end

to-report blackseconds
  report timerblack - blackminutes * 60
end

to-report whiteminutes
  report floor (timerwhite / 60)
end

to-report blackminutes
  report floor (timerblack / 60)
end

to chesstimer
  every 1 [ifelse setMove = "white"
    [set timerwhite timerwhite - 1]
    [set timerblack timerblack - 1]]
  if timerwhite <= 0 [stop]
  if timerblack <= 0 [stop]
end

to pawnpromotion
  ask pawns with [ycor = 7 and team = "white"] [
    if Promotion-Type = "promote-to-queen" [
      set breed queens]
    if Promotion-Type = "promote-to-bishop" [
      set breed bishops]
    if Promotion-Type = "promote-to-knight" [
      set breed knights]
    if Promotion-Type = "promote-to-rook" [
      set breed rooks]]
  ask pawns with [ycor = 0 and team = "black"] [
    if Promotion-Type = "promote-to-queen" [
      set breed queens]
    if Promotion-Type = "promote-to-bishop" [
      set breed bishops]
    if Promotion-Type = "promote-to-knight" [
      set breed knights]
    if Promotion-Type = "promote-to-rook" [
      set breed rooks]]
end

to enPassentBlack
  ask pawns with [team = "black" and ycor = 3 and selected? = true] [
    ask patch ([xcor] of self - 1) ([ycor] of self) [
      if count pawns-here with [team = "white" and timesMoved = 1] = 1[
        ask patch([pxcor] of self) ([pycor] of self - 1) [
          set leftBlackEnPassent true
          set pcolor green]]]
    ask patch ([xcor] of self + 1) ([ycor] of self) [
      if count pawns-here with [team = "white" and timesMoved = 1] = 1[
        ask patch([pxcor] of self) ([pycor] of self - 1) [
          set rightBlackEnPassent true
          set pcolor green]]]]
end

to enPassentWhite
  ask pawns with [team = "white" and ycor = 4 and selected? = true] [
    ask patch ([xcor] of self - 1) ([ycor] of self) [
      if count pawns-here with [team = "black" and timesMoved = 1] = 1[
        ask patch([pxcor] of self) ([pycor] of self + 1) [
          set leftWhiteEnPassent true
          set pcolor green]]]
    ask patch ([xcor] of self + 1) ([ycor] of self) [
      if count pawns-here with [team = "black" and timesMoved = 1] = 1[
        ask patch([pxcor] of self) ([pycor] of self + 1) [
          set rightWhiteEnPassent true
          set pcolor green]]]]
end

to executeEnPassent
  if leftWhiteEnPassent = true [
    if round mouse-xcor = ([xcor] of one-of pawns with [selected? = true]) and round mouse-ycor = ([ycor] of one-of pawns with [selected? = true]) and mouse-down? [
      ask pawns with [team = "black" and xcor = ([xcor] of one-of pawns with [selected? = true]) and ycor = ([ycor] of one-of pawns with [selected? = true]) - 1] [
        die
        set leftWhiteEnPassent false
        set rightWhiteEnPassent false
        set leftBlackEnPassent false
        set rightBlackEnPassent false]]]
  if rightWhiteEnPassent = true [
    if round mouse-xcor = ([xcor] of one-of pawns with [selected? = true]) and round mouse-ycor = ([ycor] of one-of pawns with [selected? = true]) and mouse-down? [
      ask pawns with [team = "black" and xcor = ([xcor] of one-of pawns with [selected? = true]) and ycor = ([ycor] of one-of pawns with [selected? = true]) - 1] [
        die
        set leftWhiteEnPassent false
        set rightWhiteEnPassent false
        set leftBlackEnPassent false
        set rightBlackEnPassent false]]]
  if leftBlackEnPassent = true [ 
    if round mouse-xcor = ([xcor] of one-of pawns with [selected? = true]) and round mouse-ycor = ([ycor] of one-of pawns with [selected? = true]) and mouse-down? [
      ask pawns with [team = "white" and xcor = ([xcor] of one-of pawns with [selected? = true]) and ycor = ([ycor] of one-of pawns with [selected? = true]) + 1] [
        die
        set leftWhiteEnPassent false
        set rightWhiteEnPassent false
        set leftBlackEnPassent false
        set rightBlackEnPassent false]]]
  if rightBlackEnPassent = true [
    if round mouse-xcor = ([xcor] of one-of pawns with [selected? = true]) and round mouse-ycor = ([ycor] of one-of pawns with [selected? = true]) and mouse-down? [
      ask pawns with [team = "white" and xcor = ([xcor] of one-of pawns with [selected? = true]) and ycor = ([ycor] of one-of pawns with [selected? = true]) + 1] [
        die
        set leftWhiteEnPassent false
        set rightWhiteEnPassent false
        set leftBlackEnPassent false
        set rightBlackEnPassent false]]]
end

to resetEnPassent
  set leftWhiteEnPassent false
  set rightWhiteEnPassent false
  set leftBlackEnPassent false
  set rightBlackEnPassent false
end


@#$#@#$#@
GRAPHICS-WINDOW
210
10
778
579
-1
-1
70.0
1
10
1
1
1
0
1
1
1
0
7
0
7
0
0
1
ticks
30.0

BUTTON
13
66
120
99
Setup the Board
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
13
102
120
135
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
882
71
964
116
Turn
setMove
17
1
11

MONITOR
827
197
929
242
Minutes
whiteminutes
17
1
11

TEXTBOX
892
165
1042
183
WHITE TIMER
11
0.0
1

MONITOR
930
197
1032
242
Seconds
whiteseconds
17
1
11

TEXTBOX
893
259
1043
277
BLACK TIMER
11
0.0
1

MONITOR
828
284
931
329
Minutes
blackminutes
17
1
11

MONITOR
933
284
1036
329
Seconds
blackseconds
17
1
11

BUTTON
13
138
120
171
Timer
chesstimer
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
12
174
163
219
Promotion-Type
Promotion-Type
"promote-to-queen" "promote-to-bishop" "promote-to-knight" "promote-to-rook"
0

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

chess bishop
false
0
Circle -7500403 true true 135 35 30
Circle -16777216 false false 135 35 30
Rectangle -7500403 true true 90 255 210 300
Line -16777216 false 75 255 225 255
Rectangle -16777216 false false 90 255 210 300
Polygon -7500403 true true 105 255 120 165 180 165 195 255
Polygon -16777216 false false 105 255 120 165 180 165 195 255
Rectangle -7500403 true true 105 165 195 150
Rectangle -16777216 false false 105 150 195 165
Line -16777216 false 137 59 162 59
Polygon -7500403 true true 135 60 120 75 120 105 120 120 105 120 105 90 90 105 90 120 90 135 105 150 195 150 210 135 210 120 210 105 195 90 165 60
Polygon -16777216 false false 135 60 120 75 120 120 105 120 105 90 90 105 90 135 105 150 195 150 210 135 210 105 165 60

chess king
false
0
Polygon -7500403 true true 105 255 120 90 180 90 195 255
Polygon -16777216 false false 105 255 120 90 180 90 195 255
Polygon -7500403 true true 120 85 105 40 195 40 180 85
Polygon -16777216 false false 119 85 104 40 194 40 179 85
Rectangle -7500403 true true 105 105 195 75
Rectangle -16777216 false false 105 75 195 105
Rectangle -7500403 true true 90 255 210 300
Line -16777216 false 75 255 225 255
Rectangle -16777216 false false 90 255 210 300
Rectangle -7500403 true true 165 23 134 13
Rectangle -7500403 true true 144 0 154 44
Polygon -16777216 false false 153 0 144 0 144 13 133 13 133 22 144 22 144 41 154 41 154 22 165 22 165 12 153 12

chess knight
false
0
Line -16777216 false 75 255 225 255
Polygon -7500403 true true 90 255 60 255 60 225 75 180 75 165 60 135 45 90 60 75 60 45 90 30 120 30 135 45 240 60 255 75 255 90 255 105 240 120 225 105 180 120 210 150 225 195 225 210 210 255
Polygon -16777216 false false 210 255 60 255 60 225 75 180 75 165 60 135 45 90 60 75 60 45 90 30 120 30 135 45 240 60 255 75 255 90 255 105 240 120 225 105 180 120 210 150 225 195 225 210
Line -16777216 false 255 90 240 90
Circle -16777216 true false 134 63 24
Line -16777216 false 103 34 108 45
Line -16777216 false 80 41 88 49
Line -16777216 false 61 53 70 58
Line -16777216 false 64 75 79 75
Line -16777216 false 53 100 67 98
Line -16777216 false 63 126 69 123
Line -16777216 false 71 148 77 145
Rectangle -7500403 true true 90 255 210 300
Rectangle -16777216 false false 90 255 210 300

chess pawn
false
0
Circle -7500403 true true 105 65 90
Circle -16777216 false false 105 65 90
Rectangle -7500403 true true 90 255 210 300
Line -16777216 false 75 255 225 255
Rectangle -16777216 false false 90 255 210 300
Polygon -7500403 true true 105 255 120 165 180 165 195 255
Polygon -16777216 false false 105 255 120 165 180 165 195 255
Rectangle -7500403 true true 105 165 195 150
Rectangle -16777216 false false 105 150 195 165

chess queen
false
0
Circle -7500403 true true 140 11 20
Circle -16777216 false false 139 11 20
Circle -7500403 true true 120 22 60
Circle -16777216 false false 119 20 60
Rectangle -7500403 true true 90 255 210 300
Line -16777216 false 75 255 225 255
Rectangle -16777216 false false 90 255 210 300
Polygon -7500403 true true 105 255 120 90 180 90 195 255
Polygon -16777216 false false 105 255 120 90 180 90 195 255
Rectangle -7500403 true true 105 105 195 75
Rectangle -16777216 false false 105 75 195 105
Polygon -7500403 true true 120 75 105 45 195 45 180 75
Polygon -16777216 false false 120 75 105 45 195 45 180 75
Circle -7500403 true true 180 35 20
Circle -16777216 false false 180 35 20
Circle -7500403 true true 140 35 20
Circle -16777216 false false 140 35 20
Circle -7500403 true true 100 35 20
Circle -16777216 false false 99 35 20
Line -16777216 false 105 90 195 90

chess rook
false
0
Rectangle -7500403 true true 90 255 210 300
Line -16777216 false 75 255 225 255
Rectangle -16777216 false false 90 255 210 300
Polygon -7500403 true true 90 255 105 105 195 105 210 255
Polygon -16777216 false false 90 255 105 105 195 105 210 255
Rectangle -7500403 true true 75 90 120 60
Rectangle -7500403 true true 75 84 225 105
Rectangle -7500403 true true 135 90 165 60
Rectangle -7500403 true true 180 90 225 60
Polygon -16777216 false false 90 105 75 105 75 60 120 60 120 84 135 84 135 60 165 60 165 84 179 84 180 60 225 60 225 105

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
