turtles-own [team movedyet? piecename selected?]
patches-own [original-color]
globals [numberSelected turn ahead? green? rightWhiteRook leftWhiteRook timerwhite timerblack]
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
    selectPiece
    wait .014
    deselectPiece
    wait .014
    executeMove
    wait .014]
end

;CALCULATING MOVES
to calculateMoves
  if breed = pawns [
    calculateWhitePawnMove
    calculateBlackPawnMove]
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
    whiteCastle]
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
    if([xcor] of self + 1) <= 7 and ([xcor] of self + 1) > 0 [
    ask patch ([xcor] of self + 1) ([ycor] of self) [
      continueWhitePath?]]
    if([xcor] of self + 2) <= 7 and ([xcor] of self + 2) >= 0 [
    ask patch ([xcor] of self + 2) ([ycor] of self) [
      continueWhitePath?]]
    if([xcor] of self + 3) <= 7 and ([xcor] of self + 3) >= 0 [
    ask patch ([xcor] of self + 3) ([ycor] of self) [
      continueWhitePath?]]
    if([xcor] of self + 4) <= 7 and ([xcor] of self + 4) >= 0 [
    ask patch ([xcor] of self + 4) ([ycor] of self ) [
      continueWhitePath?]]
    if([xcor] of self + 5) <= 7 and ([xcor] of self + 5) >= 0 [
    ask patch ([xcor] of self + 5) ([ycor] of self) [
      continueWhitePath?]]
    if([xcor] of self + 6) <= 7 and ([xcor] of self + 6) >= 0 [
    ask patch ([xcor] of self + 6) ([ycor] of self) [
      continueWhitePath?]]
    if([xcor] of self + 7) <= 7 and ([xcor] of self + 7) >= 0 [
    ask patch ([xcor] of self + 7) ([ycor] of self) [
      continueWhitePath?]]
    set ahead? false

    if([xcor] of self - 1) <= 7 and ([xcor] of self - 1) >= 0 [
      ask patch ([xcor] of self - 1) ([ycor] of self) [
        continueWhitePath?]]
    if([xcor] of self - 2) <= 7 and ([xcor] of self - 2) >= 0 [
      ask patch ([xcor] of self - 2) ([ycor] of self) [
        continueWhitePath?]]
    if([xcor] of self - 3) <= 7 and ([xcor] of self - 3) >= 0 [
      ask patch ([xcor] of self - 3) ([ycor] of self) [
        continueWhitePath?]]
    if([xcor] of self - 4) <= 7 and ([xcor] of self - 4) >= 0 [
      ask patch ([xcor] of self - 4) ([ycor] of self) [
        continueWhitePath?]]
    if([xcor] of self - 5) <= 7 and ([xcor] of self - 5) >= 0 [
      ask patch ([xcor] of self - 5) ([ycor] of self) [
        continueWhitePath?]]
    if([xcor] of self - 6) <= 7 and ([xcor] of self - 6) >= 0 [
      ask patch ([xcor] of self - 6) ([ycor] of self) [
        continueWhitePath?]]
    if([xcor] of self - 7) <= 7 and ([xcor] of self - 7) >= 0 [
      ask patch ([xcor] of self - 7) ([ycor] of self) [
        continueWhitePath?]]
    set ahead? false

    if ([ycor] of self + 1) <= 7 and ([ycor] of self + 1) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self + 1) [
        continueWhitePath?]]
    if ([ycor] of self + 2) <= 7 and ([ycor] of self + 2) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self + 2) [
        continueWhitePath?]]
    if ([ycor] of self + 3) <= 7 and ([ycor] of self + 3) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self + 3) [
        continueWhitePath?]]
    if ([ycor] of self + 4) <= 7 and ([ycor] of self + 4) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self + 4) [
        continueWhitePath?]]
    if ([ycor] of self + 5) <= 7 and ([ycor] of self + 5) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self + 5) [
        continueWhitePath?]]
    if ([ycor] of self + 6) <= 7 and ([ycor] of self + 6) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self + 6) [
        continueWhitePath?]]
    if ([ycor] of self + 7) <= 7 and ([ycor] of self + 7) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self + 7) [
        continueWhitePath?]]
      set ahead? false

    if ([ycor] of self - 1) <= 7 and ([ycor] of self - 1) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self - 1) [
        continueWhitePath?]]
    if ([ycor] of self - 2) <= 7 and ([ycor] of self - 2) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self - 2) [
        continueWhitePath?]]
    if ([ycor] of self - 3) <= 7 and ([ycor] of self - 3) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self - 3) [
        continueWhitePath?]]
    if ([ycor] of self - 4) <= 7 and ([ycor] of self - 4) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self - 4) [
        continueWhitePath?]]
    if ([ycor] of self - 5) <= 7  and ([ycor] of self - 5) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self - 5) [
        continueWhitePath?]]
    if ([ycor] of self - 6) <= 7 and ([ycor] of self - 6) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self - 6) [
        continueWhitePath?]]
    if ([ycor] of self - 7) <= 7 and ([ycor] of self - 7) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self - 7) [
        continueWhitePath?]]
  set ahead? false]
end

to calculateBlackRookMove
  if team = "black" [
    if([xcor] of self + 1) <= 7 and ([xcor] of self + 1) > 0 [
    ask patch ([xcor] of self + 1) ([ycor] of self) [
      continueBlackPath?]]
    if([xcor] of self + 2) <= 7 and ([xcor] of self + 2) >= 0 [
    ask patch ([xcor] of self + 2) ([ycor] of self) [
      continueBlackPath?]]
    if([xcor] of self + 3) <= 7 and ([xcor] of self + 3) >= 0 [
    ask patch ([xcor] of self + 3) ([ycor] of self) [
      continueBlackPath?]]
    if([xcor] of self + 4) <= 7 and ([xcor] of self + 4) >= 0 [
    ask patch ([xcor] of self + 4) ([ycor] of self ) [
      continueBlackPath?]]
    if([xcor] of self + 5) <= 7 and ([xcor] of self + 5) >= 0 [
    ask patch ([xcor] of self + 5) ([ycor] of self) [
      continueBlackPath?]]
    if([xcor] of self + 6) <= 7 and ([xcor] of self + 6) >= 0 [
    ask patch ([xcor] of self + 6) ([ycor] of self) [
      continueBlackPath?]]
    if([xcor] of self + 7) <= 7 and ([xcor] of self + 7) >= 0 [
    ask patch ([xcor] of self + 7) ([ycor] of self) [
      continueBlackPath?]]
    set ahead? false

    if([xcor] of self - 1) <= 7 and ([xcor] of self - 1) >= 0 [
      ask patch ([xcor] of self - 1) ([ycor] of self) [
        continueBlackPath?]]
    if([xcor] of self - 2) <= 7 and ([xcor] of self - 2) >= 0 [
      ask patch ([xcor] of self - 2) ([ycor] of self) [
        continueBlackPath?]]
    if([xcor] of self - 3) <= 7 and ([xcor] of self - 3) >= 0 [
      ask patch ([xcor] of self - 3) ([ycor] of self) [
        continueBlackPath?]]
    if([xcor] of self - 4) <= 7 and ([xcor] of self - 4) >= 0 [
      ask patch ([xcor] of self - 4) ([ycor] of self) [
        continueBlackPath?]]
    if([xcor] of self - 5) <= 7 and ([xcor] of self - 5) >= 0 [
      ask patch ([xcor] of self - 5) ([ycor] of self) [
        continueBlackPath?]]
    if([xcor] of self - 6) <= 7 and ([xcor] of self - 6) >= 0 [
      ask patch ([xcor] of self - 6) ([ycor] of self) [
        continueBlackPath?]]
    if([xcor] of self - 7) <= 7 and ([xcor] of self - 7) >= 0 [
      ask patch ([xcor] of self - 7) ([ycor] of self) [
        continueBlackPath?]]
    set ahead? false

    if ([ycor] of self + 1) <= 7 and ([ycor] of self + 1) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self + 1) [
        continueBlackPath?]]
    if ([ycor] of self + 2) <= 7 and ([ycor] of self + 2) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self + 2) [
       continueBlackPath?]]
    if ([ycor] of self + 3) <= 7 and ([ycor] of self + 3) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self + 3) [
        continueBlackPath?]]
    if ([ycor] of self + 4) <= 7 and ([ycor] of self + 4) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self + 4) [
        continueBlackPath?]]
    if ([ycor] of self + 5) <= 7 and ([ycor] of self + 5) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self + 5) [
        continueBlackPath?]]
    if ([ycor] of self + 6) <= 7 and ([ycor] of self + 6) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self + 6) [
        continueBlackPath?]]
    if ([ycor] of self + 7) <= 7 and ([ycor] of self + 7) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self + 7) [
        continueBlackPath?]]
      set ahead? false

    if ([ycor] of self - 1) <= 7 and ([ycor] of self - 1) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self - 1) [
        continueBlackPath?]]
    if ([ycor] of self - 2) <= 7 and ([ycor] of self - 2) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self - 2) [
        continueBlackPath?]]
    if ([ycor] of self - 3) <= 7 and ([ycor] of self - 3) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self - 3) [
        continueBlackPath?]]
    if ([ycor] of self - 4) <= 7 and ([ycor] of self - 4) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self - 4) [
        continueBlackPath?]]
    if ([ycor] of self - 5) <= 7  and ([ycor] of self - 5) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self - 5) [
        continueBlackPath?]]
    if ([ycor] of self - 6) <= 7 and ([ycor] of self - 6) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self - 6) [
        continueBlackPath?]]
    if ([ycor] of self - 7) <= 7 and ([ycor] of self - 7) >= 0 [
      ask patch ([xcor] of self) ([ycor] of self - 7) [
        continueBlackPath?]]
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
        set movedyet? true]
      deselectAllPieces
      executeCastle
      increaseTurn]]
  pawnPromotion
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

to executeCastle
  if rightWhiteRook = true and round mouse-xcor = 6 and round mouse-ycor = 0 and mouse-down?[
    ask rook 17 [
      setxy 5 0]
    set rightWhiteRook false
    set leftWhiteRook false]
  if leftWhiteRook = true and round mouse-xcor = 1 and round mouse-ycor = 0 and mouse-down?[
    ask rook 16 [
      setxy 2 0]
    set rightWhiteRook false
    set leftWhiteRook false]
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




  
  



