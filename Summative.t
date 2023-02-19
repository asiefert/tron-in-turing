/*
 Name: Arin Siefert
 Course : ICS-2OI
 Assignment: Summative
 Title: Tron in Turing
 Start date: April 27, 2013
 Completion Date: June 2,2013
 */
import GUI
%Screen Related(Background,etc)

setscreen ("title:Tron in Turing;graphics:max;max,buttonbar")
colourback (black) %Background color set to black
colour (brightblue)
cls
%----------------------------------------------------
%Declaring and initializing variables and constants

%GUI elements and pictures
var logo : int %Logo picture ID
var logoPic := Pic.FileNew ("resources/pics/logo.jpg")
var playButton : int
var resetButton : int
var font := Font.New ("Times New Roman:14")
var font2 := Font.New ("Arial:36")

%Timer related
var timer : int := 0
var timer_Start : int := 0

%Player control variables

var chars : array char of boolean
%Location of players
var p1_X := maxx div 2
var p1_Y := maxy div 2 - 10
var p2_X := maxx div 2
var p2_Y := maxy div 2 + 10

%Direction of players
var p1_dir : string := "down"
var p2_dir : string := "up"

%Variables of who lost and won
var loser : string := "Empty"
var winner : string := "Empty"
var score_winner : int := 0

%Other
const speedDelay : int := 10 %The speed of the players
var goToNext : boolean := false

%Score related
type userRecord :
    record
	name : string
	Time : int
    end record
var user : userRecord
user.Time := 0
user.name := winner

%--------------------------------------------------------------
%Procedure that resets the scores

procedure reset_scores
    var hsFile : int
    var space : string := " "
    open : hsFile, "highscores.txt", put
    %Put highscores file back to original state
    for i : 1 .. 5
	put : hsFile, "Empty"
	put : hsFile, "0"
	put : hsFile, space
    end for
    close : hsFile
    locatexy (maxx div 2, maxy div 2 - 200)
    put "Done"
    delay (900)
    drawfillbox (maxx div 2, maxy div 2 - 190, maxx div 2 + 30, maxy div 2 - 210, black)
end reset_scores
%--------------------------------------------------------------
% Procedure that exits the main menu

procedure exitMenu
    goToNext := true
    GUI.Dispose (logo)
    GUI.Dispose (playButton)
    cls
end exitMenu
%-------------------------------------------------------------
%Procedure that exits to LAN selection menu

procedure exitMenu_LAN
end exitMenu_LAN
%--------------------------------------------------------------
% Start Menu Procedure

procedure startMenu
    playButton := GUI.CreateButtonFull (maxx div 2 - 50, maxy div 2 - 50, 5, "Play Multiplayer", exitMenu, 5, 'p', false)
    resetButton := GUI.CreateButtonFull (maxx div 2 - 50, maxy div 2 - 100, 5, "Reset highscores", reset_scores, 5, 'r', false)

    logo := GUI.CreatePicture (maxx div 2 - 180, maxy div 2, logoPic, false)
    Font.Draw ("In Turing!", maxx div 2 + 140, maxy div 2 - 30, font, yellow)
    loop
	exit when GUI.ProcessEvent or goToNext = true
    end loop
end startMenu
%---------------------------------------------------------------
%Procedure to draw the timer, game border, and players

procedure draw_Necessary
    color (brightpurple)
    locatexy (maxx div 2, maxy - 40)
    put timer
    drawdot (p1_X, p1_Y, brightblue)  %P-1's "Light Cycle"
    drawdot (p2_X, p2_Y, red) %P-2's "Light Cycle"
    %Draw the border of the game playing space
    for decreasing i : 60 .. 50
	for decreasing j : 10 .. 1
	    drawbox (maxx - j, maxy - i, 1 + j, 1 + j, brightgreen)
	end for
    end for
end draw_Necessary
%-----------------------------------------------------------
%Procedure to continue the line when key isn't pressed for P-1

procedure p1_continueLine
    if p1_dir = "up" then
	if whatdotcolor (p1_X, p1_Y + 1) = black then
	    p1_Y += 1
	else
	    loser := "P-1"
	    winner := "P-2"
	end if
    elsif p1_dir = "down" then
	if whatdotcolor (p1_X, p1_Y - 1) = black then
	    p1_Y -= 1
	else
	    loser := "P-1"
	    winner := "P-2"
	end if
    elsif p1_dir = "right" then
	if whatdotcolor (p1_X + 1, p1_Y) = black then
	    p1_X += 1
	else
	    loser := "P-1"
	    winner := "P-2"
	end if
    elsif p1_dir = "left" then
	if whatdotcolor (p1_X - 1, p1_Y) = black then
	    p1_X -= 1
	else
	    loser := "P-1"
	    winner := "P-2"
	end if
    end if
end p1_continueLine
%--------------------------------------------------------------------
%Procedure to continue the line when key isn't pressed for P-2

procedure p2_continueLine
    if p2_dir = "up" then
	if whatdotcolor (p2_X, p2_Y + 1) = black then
	    p2_Y += 1
	else
	    %Declare who has won and lost
	    loser := "P-2"
	    winner := "P-1"
	end if
    elsif p2_dir = "down" then
	if whatdotcolor (p2_X, p2_Y - 1) = black then
	    p2_Y -= 1
	else
	    %Declare who has won and lost
	    loser := "P-2"
	    winner := "P-1"
	end if
    elsif p2_dir = "right" then
	if whatdotcolor (p2_X + 1, p2_Y) = black then
	    p2_X += 1
	else
	    %Declare who has won and lost
	    loser := "P-2"
	    winner := "P-1"
	end if
    elsif p2_dir = "left" then
	if whatdotcolor (p2_X - 1, p2_Y) = black then
	    p2_X -= 1
	else
	    %Declare who has won and lost
	    loser := "P-2"
	    winner := "P-1"
	end if
    end if
end p2_continueLine

%--------------------------------------------------------------------------------
%Procedure to store highscores on disk

procedure store_highscores
    var hsFile : int % The file stream for the highscores file
    const numTimes : int := 5 % Number of highscores(times) to store
    var hTime, hUser, users, times : array 1 .. 5 of string
    var space : string
    open : hsFile, "highscores.txt", get
    %Starting from score 1 to final score
    for i : 1 .. numTimes
	exit when eof (hsFile)
	%Get all required data
	get : hsFile, hUser (i) %user in highscores file
	get : hsFile, hTime (i) %time in highscores file
	get : hsFile, space : * %space between scores

	users (i) := hUser (i) %Set user that is being read to user in highscores file
	times (i) := hTime (i) %Set time that is being read to time in highscores file
    end for

    close : hsFile % Close the file

    %Starting from the bottom time
    for decreasing i : numTimes .. 1
	if user.Time > strint (times (i)) then % if the current time is higher than the one being checked
	    for decreasing j : numTimes .. i % starting from the bottom time
		if j not= numTimes then
		    hUser (j + 1) := users (j) % move the name down
		    hTime (j + 1) := times (j) % move the time down
		end if
	    end for
	    %Put the user's name and time in
	    hUser (i) := user.name
	    hTime (i) := intstr (user.Time)
	end if
    end for

    open : hsFile, "highscores.txt", put

    %Write the scores
    for i : 1 .. numTimes
	put : hsFile, hUser (i)
	put : hsFile, hTime (i)
	put : hsFile, space
    end for

    close : hsFile % close the txt file
end store_highscores
%-------------------------------------
startMenu % Call to the start menu procedure

%---------------------------------------------------------------------------------
%Main Program

%Play music for game
Music.PlayFileLoop ("resources/music/music.mp3")

%Countdown to game start
for decreasing i : 3 .. 1
    locatexy (maxx div 2, maxy div 2)
    put i
    delay (1000)
    exit when i = 1
end for
locatexy (maxx div 2, maxy div 2)
put "GO"
delay (500)
cls

setscreen ("offscreenonly")
%Update screen
View.Update
timer_Start := Time.Elapsed
loop

    %Set time to be time elapsed since the start of the timer in seconds
    timer := (Time.Elapsed - timer_Start) div 1000

    % Call the procedure to draw the players, timer, and border
    draw_Necessary

    %Update screen
    View.Update

    %Get keys that are down
    Input.KeyDown (chars)

    %Empty keyboard buffer
    Input.Flush
    %---------------------------------------------------------------------

    %  P-1 Controls

    if chars (KEY_UP_ARROW) then
	if p1_dir not= "down" then
	    p1_dir := "up"
	    if whatdotcolor (p1_X, p1_Y + 1) = black then
		p1_Y += 1
	    else

		%Declare who has won and lost when key is down(Different from continue line procedure))
		loser := "P-1"
		winner := "P-2"
		exit
	    end if
	else
	    p1_continueLine
	    exit when loser = "P-1" or loser = "P-2"
	end if

    elsif chars (KEY_DOWN_ARROW) then
	if p1_dir not= "up" then
	    p1_dir := "down"
	    if whatdotcolor (p1_X, p1_Y - 1) = black then
		p1_Y -= 1
	    else

		%Declare who has won and lost when key is down(Different from continue line procedure))
		loser := "P-1"
		winner := "P-2"
		exit
	    end if
	else
	    p1_continueLine
	    exit when loser = "P-1" or loser = "P-2"
	end if
    elsif chars (KEY_LEFT_ARROW) then
	if p1_dir not= "right" then
	    p1_dir := "left"
	    if whatdotcolor (p1_X - 1, p1_Y) = black then
		p1_X -= 1
	    else

		%Declare who has won and lost when key is down(Different from continue line procedure))
		loser := "P-1"
		exit
	    end if
	else
	    p1_continueLine
	    exit when loser = "P-1" or loser = "P-2"
	end if
    elsif chars (KEY_RIGHT_ARROW) then
	if p1_dir not= "left" then
	    p1_dir := "right"
	    if whatdotcolor (p1_X + 1, p1_Y) = black then
		p1_X += 1
	    else

		%Declare who has won and lost when key is down(Different from continue line procedure))
		loser := "P-1"
		winner := "P-2"
		exit
	    end if
	else
	    p1_continueLine
	    exit when loser = "P-1" or loser = "P-2"
	end if
    else
	p1_continueLine
	exit when loser = "P-1" or loser = "P-2"
    end if
    %------------------------------------------------------------------------

    % P-2 Controls

    if chars ('w') then
	if p2_dir not= "down" then
	    p2_dir := "up"
	    if whatdotcolor (p2_X, p2_Y + 1) = black then
		p2_Y += 1
	    else

		%Declare who has won and lost when key is down(Different from continue line procedure))
		loser := "P-2"
		winner := "P-1"
		exit
	    end if
	else
	    p2_continueLine
	    exit when loser = "P-1" or loser = "P-2"
	end if

    elsif chars ('s') then
	if p2_dir not= "up" then
	    p2_dir := "down"
	    if whatdotcolor (p2_X, p2_Y - 1) = black then
		p2_Y -= 1
	    else

		%Declare who has won and lost when key is down(Different from continue line procedure))
		loser := "P-2"
		winner := "P-1"
		exit
	    end if
	else
	    p2_continueLine
	    exit when loser = "P-1" or loser = "P-2"
	end if
    elsif chars ('a') then
	if p2_dir not= "right" then
	    p2_dir := "left"
	    if whatdotcolor (p2_X - 1, p2_Y) = black then
		p2_X -= 1
	    else

		%Declare who has won and lost when key is down(Different from continue line procedure))
		loser := "P-2"
		winner := "P-1"
		exit
	    end if
	else
	    p2_continueLine
	    exit when loser = "P-1" or loser = "P-2"
	end if
    elsif chars ('d') then
	if p2_dir not= "left" then
	    p2_dir := "right"
	    if whatdotcolor (p2_X + 1, p2_Y) = black then
		p2_X += 1
	    else

		%Declare who has won and lost when key is down(Different from continue line procedure))
		loser := "P-2"
		winner := "P-1"
		exit
	    end if
	else
	    p2_continueLine
	    exit when loser = "P-1" or loser = "P-2"
	end if
    else
	p2_continueLine
	exit when loser = "P-1" or loser = "P-2"
    end if
    delay (speedDelay) % Delay of both players
end loop
%---------------------------------------------------------------

% Called when someone loses

Music.PlayFileStop %Stop Music
user.Time := timer %Set up user time for highscores
cls
locatexy (maxx div 2, maxy div 2)
color (brightblue)
Font.Draw ("Final Results", maxx div 2 - 50, maxy div 2 + 100, font2, red)
Font.Draw (winner + " won!", maxx div 2, maxy div 2, font, blue)
%if timer is equal to 1
if timer = 1 then
    Font.Draw ("Time: " + intstr (timer) + " second", maxx div 2, maxy div 2 - 20, font, blue) %Write "Time: 1 second"
else %Otherwise
    Font.Draw ("Time: " + intstr (timer) + " seconds", maxx div 2, maxy div 2 - 20, font, blue) %Write "Time: ___ seconds"
end if
%If P-1 is the loser
if loser = "P-1" then
    locatexy (maxx div 2 - 100, maxy div 2 - 15)
    winner := "P-2"
    score_winner := timer
    user.name := winner %Set user.name to winner(P-2 in this case)
    store_highscores

    %if P-2 is the loser
elsif loser = "P-2" then
    locatexy (maxx div 2 - 100, maxy div 2 - 15)
    winner := "P-1"
    score_winner := timer
    user.name := winner %Set user.name to winner(P-1 in this case)
    store_highscores
end if
Pic.Free (logoPic) %Free logo picture from memory
