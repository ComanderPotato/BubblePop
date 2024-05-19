#  What to do
## Registering
You're welcome to create an account, emails require the @ and . characters, and passwords are required to be of length 6. 
Obviously, not much validation was added since this wasn't apart of the functionality and something that I decided to add.

## Logging in
If you'd prefer not to register with a dummy email, you can use mine that I had to test out the application.
    Email: tomgolding2012@outlook.com
    Password: Password1
    
## Information on the appliation
### Login and Register
Both the login and register have a similar layout, the user can navigate to the register view if they don't have an account
and would like to create one. Validation has been implemented on both, albeit very minimal as this was an extension of 
functionality done on my part and not in the requirements of the application. For example, if a user tries to login 
but doesn't have the correct format of email, or they left both text fields empty, it will display an error message.

### Main Menu
The main menu is a tabbed view which allows the user to go to three different views. The Main Menu (Game view), which gives 
a user the ability to select the settings of their game. The difficulty was an extension by me, depending on the difficulty 
will determine the random sizes of the bubbles and their velocity. The second view is the Profile View, which will display 
the users information. Finally, the Leaderboard view will show the top 100 scores across the player base.

### Game View
The game view is the main source for user enjoyment. With a game header displaying all necessary information to the user such as, 
the game score, game time, and the users highscore. There is also a pause button which will stop bubble removable and generation, 
and stop the game timer from decreasing. Moving on to the main game view where the bubbles are displayed, each second a random
amount of bubbles will be removed and generated. Depending on the difficulty, bubbles will be of different size and potentially
move in the game space.

## Things I'd like to change for the future
My layouts aren't as dynamic as I'd like. I'd like to learn how to do auto layouts to have the layout more dynamic for different
devices, as you can see with larger screens, I resorted to keeping the iphone dimensions for most views. Similarly, I couldnt 
figure out how to center the login and register forms on the screen so they're so far up, which wouldn't be good for user experience.
Furthermore, for the most part changing from landscape to portrait works as expected and still has a good look to the views. But
an issue I couldn't resolve was rotating the phone whilst in the game, as the bubbles rely on the geometry of its container to set
the coordinates, it would lead to bubbles being generated outside the view.
