# Logitech Gaming Mouse Fix
This is a repo created to help fix an issue prevalent in Logitech Gaming Mice. I had some free time, so I thought I'd solve it. I also thought it would be good to learn a new language (lua) and solve this issue to the best that my ability and free time allows. Programming is my passion (if you can't already tell by the fact that I'm doing this).

Note: Setting the delay too high can cause missed mouse inputs. A delay under 50ms is recommended for this program. 10-20ms is recommended in general.

## I. Why This Fix?
Most people that I've seen opt for a hardware fix, but replacing the switches has a few issues:
* It is a temporary fix
* It requires opening the mouse and soldering (something that most people aren't comfortable with on such a high-priced device)
* It voids the warranty

The advantages of this fix:
* It does not require opening the mouse
* It does not void the warranty
* It is a feature within G HUB
* If the issue still occurs or starts occuring again due to age, the delay length can be increased to compensate
* Delays under 50 ms should be almost un-noticeable

<i>But.. Doesn't a software fix affect the response times?</i> Technically yes, but realistically no. I tested this by altering the report rate in G HUB for 1000 Hz (a 1ms delay) to 500 Hz (a 2ms delay) and saw that this fixed my issue. Standard debouncing (delay) is usually somewhere between 10-20 ms for a button, and does not occur until AFTER the button has been pressed. <b>This means that the button press happens instantaneously, but then waits for a short delay time to be pressed again.</b>

In a test scenario, I attempted to double-click as fast as I could to get some metrics on a reasonable debounce time that would go unnoticed. For the G502, I could not click faster than a delay of 75ms, meaning that a total delay of about 70ms should go unnoticed for most people. A reasonable time for the fastest possible double-click might be to assume 20 clicks/second, meaning a 50ms delay. Logitech's current code is limited by the report rate, which assumes 1000 clicks/second at 1000 Hz, which is pretty rediculous. My code on the other hand assumes a 20ms (50 clicks/second in the worst-case) delay, using 10ms for the down press and 10ms for the release (wich can be overlapping), between successive clicks and is configurable.

## II. Background
I have a Logitech G502 that started double-clicking after 3-4 years. I looked up the current model of G502 (and several other gaming mice from different brands) and saw that they all had a similar issue. In under a year, most gaming mice would start having an issue with double-clicking. I have described this here: https://www.reddit.com/r/LogitechG/comments/j5uecz/software_fix_for_double_clicking_logitech_mice/

### A. Macro Fix
For double-clicking and click/drag issues on the G502 (and by extension, most Logitech gaming mice), a macro can be used to fix this issue. Macros for the main mouse buttons (LMB, RMB, and MMB) can be seen in /G502_Mouse_Fix_Project/Personal_Setup_Macros/ in images 03, 04, and 05 respectively.

### B. Other Buttons
So, great.. The macro fix works for those three buttons. What if the other buttons are double-clicking? No worries! I have taken the time to develop a LUA script to solve this issue for the remaining buttons. Upside? it can fix the issue with a little bit of work. Downside? It's not quite as straight-forward. My goal is to make this fix as accessible as possible and to do most of the heavy-lifting as far as the environment and tools.

## III. Resources
G HUB Manual: https://www.logitech.com/assets/65550/ghub.pdf

Logitech API: https://douile.github.io/logitech-toggle-keys/APIDocs.pdf

Why This Issue Occurs:  https://www.youtube.com/watch?v=v5BhECVlKJA (This Man is a LEGEND)

Loading a LUA Script in G HUB: https://www.reddit.com/r/LogitechG/comments/aud8p6/lua_scripts_are_in_g_hub_but_how_do_they_work/

# The Fix
## I. Before Starting
If you have a mouse that is not the G502, don't worry. It can be done, it just will take a little more work in figuring out which button is which. I will get to that later.

I recommend looking here as a good starting point: /G502_Mouse_Fix_Project/Personal_Setup_Macros/

Be wary of thise line, as it causes performance issues:
>--EnablePrimaryMouseButtonEvents(true);         -- Enable this if you need to edit left mouse button

I take no responsibility for any issues that come from following this guide.

Be very careful that if you use PressMouseButton that you always make sure to use ReleaseMouseButton on the same button to restore it.

It can also be handy to have another mouse around or know keyboard shortcuts such as ALT+ESC and ALT+TAB.

And with that, let's begin!

## II. The Files
* /G502_Mouse_Fix_Project/Console_MB_Output.lua - Outputs the mouse button numbers (should work on most Logitech Gaming Mice)
* /G502_Mouse_Fix_Project/Console_MB_Named_Output_G502.lua - Outputs mouse button names and numbers for G502 ONLY
* /G502_Mouse_Fix_Project/G502_MB_Assignment_Template.lua - An example script to kind of demonstrate the code
* /G502_Mouse_Fix_Project/G502_MB_Personal.lua - This is my personal mouse setup
* /G502_Mouse_Fix_Project/G502_Complete_Control.lua - I don't recommend using this one but.. go for it I guess. It opts to control every button from the script. Again, remember what I said about performance issues:
>--EnablePrimaryMouseButtonEvents(true);         -- Enable this if you need to edit left mouse button

## III. Set Up Macros
Set up macros for the buttons that allow this. These buttons are:
* Left Mouse Button (LMB)
* Right Mouse Button (RMB)
* Middle Mouse Button (MMB)

A link showing these macros is here: https://www.reddit.com/r/G502MasterRace/comments/j47bxb/logitech_gaming_g502_mouse_double_clickdrag_issue/

An example of my personal macros for this project can be seen in the folder /G502_Mouse_Fix_Project/Personal_Setup_Macros/ and I recommend looking here before continuing.

## IV. Figuring Out Your Mouse Buttons (Skip this if you have a G502)
Using /G502_Mouse_Fix_Project/Console_MB_Output.lua , figure out the number of each mouse button and the number of buttons that there are on your mouse. 

Next, choose your lua script and make sure there is an entry for <i>each button</i> in each of the following variables:
* mouse_buttons (optional, but nice for debugging / Disabled by default)
* press_delay_ms
* release_delay_ms
* last_press_timestamp
* last_release_timestamp
* button_press_tbl
* button_press_args
* button_release_tbl
* button_release_args
* button_state_pressed

and make sure to update:
* num_mouse_buttons
## V. Configuring Mouse Button Delay (Fix Parameters)
This is something that you may have to do if you want a shorter delay time or if this delay is not long enough to fix your issue. The delay is stored in two arrays, press_delay_ms and release_delay_ms. The delay stored in these is indexed (ordered) by button and is measured in milliseconds. A value between 5-20ms is recommended, but 2ms is enough to fix my issue right now. As a mouse ages, it will need to have a longer delay, but you can change this value in the script. Again, a value under 50ms should be relatively unnoticeable to most people.

## VI. Configuring Mouse Button Actions
Remember this as you configure your buttons: Any button that you assign in this program must be unassigned in G HUB, otherwise there could be conflicting actions that the mouse may try to execute.

We are going to start by using the script:
>/G502_Mouse_Fix_Project/G502_MB_Personal.lua
This Script assumes:
* That the primary three buttons (LMB, MMB, and RMB) have already been assigned using G HUB using macros to handle the debouncing delay.
Scancodes for any keyboard keys cna be seen in the API Documentation listed under Section <b>III. Resources</b>.

If a macro is set and assigned in G Hub, do not set it here. Instead, set all values for that button number equal to nil (as seen by buttons 1, 2, and 3 for my personal example for the G502)
### A. For Those Who Code
* Load the function that you want to run into "button_press_tbl" (Use nil if empty or handled by G HUB)
* Load 0-1 function arguments into "button_press_args" (Use nil if no arguments)
* Repeat for "button_release_tbl" and "button_release_args"
### B. For Those Who Don't Code
Each button can be attached to a macro in G HUB, a keyboard key, or a mouse click. I have tried to comment my code thoroughly to make it as easy as possible to use for even those who don't code. That being said, <i>be careful</i> and pay close attention. Let's go over the different types of things we might want to implement.
#### i. Empty/Unused Buttons OR If a Button is Assigned in G HUB
If a button is not used or is used, but is assigned in G HUB, do the following:
* Find the button number that you want in button_press_tbl and set it equal to nil
* Find the button number that you want in button_press_args and set it equal to nil
* Find the button number that you want in button_release_tbl and set it equal to nil
* Find the button number that you want in button_release_args and set it equal to nil
#### ii. Click (with hold/drag - What most people want)
* Find the button number that you want in button_press_tbl and set it equal to PressMouseButton
* Find the button number that you want in button_press_args and set it equal to the mouse button you want (LMB - 1, MMB - 2, RMB - 3)
* Find the button number that you want in button_release_tbl and set it equal to ReleaseMouseButton
* Find the button number that you want in button_release_args and set it equal to the mouse button you want (LMB - 1, MMB - 2, RMB - 3)
#### iii. Click (quick press and release)
* Find the button number that you want in button_press_tbl and set it equal to PressAndReleaseMouseButton
* Find the button number that you want in button_press_args and set it equal to the mouse button you want (LMB - 1, MMB - 2, RMB - 3)
* Find the button number that you want in button_release_tbl and set it equal to nil
* Find the button number that you want in button_release_args and set it equal to nil
#### iv. Keyboard Keys (with hold/drag - What most people want)
* Find the button number that you want in button_press_tbl and set it equal to PressKey
* Find the button number that you want in button_press_args and set it equal to the key name with quotes (") around it or the scancode. Ex. "a" for the a key on your keyboard.
* Find the button number that you want in button_release_tbl and set it equal to ReleaseKey
* Find the button number that you want in button_release_args and set it equal to the same key name with quotes (") around it or the same scancode. Ex. "a" for the a key on your keyboard.
#### v. Keyboard Keys (quick press and release)
* Find the button number that you want in button_press_tbl and set it equal to PressAndReleaseKey
* Find the button number that you want in button_press_args and set it equal to the key name with quotes (") around it or the scancode. Ex. "a" for the a key on your keyboard.
* Find the button number that you want in button_release_tbl and set it equal to nil
* Find the button number that you want in button_release_args and set it equal to nil
#### vi. Macros (Increase/DPI/Volume/Etc)
Again, if a macro is set and assigned in G Hub, do not set it here. Instead, set all values for that button number equal to nil (as seen by buttons 1, 2, and 3 for my personal example for the G502)

Macros may take some thinking to implement, rather than being as simple as a key press. I recommend that if a macro doesn't work, try reaching out to the community to see what you might need to do. In general, here is the procedure that I used:

* Create a No-Repeat Macro in GHUB
* Find the button number that you want in button_press_tbl and set it equal to PlayMacro
* Find the button number that you want in button_press_args and set it equal to the macro that you want with quotes (") around it. Ex. "DPI_Down"
* Find the button number that you want in button_release_tbl and set it equal to nil
* Find the button number that you want in button_release_args and set it equal to nil

Example images of this can be seen in the folder /G502_Mouse_Fix_Project/Personal_Setup_Macros/

#### vii. G-SHIFT
* This is probably able to be done through a macro. If not, I may spend some time and implement it later.

# Epilogue
Honestly, this is the largest LUA script I've seen for the G502.
