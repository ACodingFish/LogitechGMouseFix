# Logitech Gaming Mouse Fix
This is a repo created to help fix an issue prevalent in Logitech Gaming Mice.

## I. Why This Fix?
Most people that I've seen opt for a hardware fix, but replacing the switches has a few issues:
* It is a temporary fix
* It requires opening the mouse and soldering (something that most people aren't comfortable with on such a high-priced device)
* It voids the warranty

The advantages of this fix:
* It does not require opening the mouse
* It does not void the warranty
* It is a feature within G HUB
* If the issue still occurs or starts occuring again during age, the delay length can be increased to compensate
* Delays under 50 ms should be almost un-noticeable

<i>But.. Doesn't a software fix affect the response times?</i> Technically yes, but realistically no. I tested this by altering the report rate in G HUB for 1000 Hz (a 1ms delay) to 500 Hz (a 2ms delay) and saw that this fixed my issue. Standard debouncing (delay) is usually somewhere between 10-20 ms for a button, and does not occur until AFTER the button has been pressed. <b>This means that the button press happens instantaneously, but then waits for a short delay time to be pressed again.</b>

In a test scenario, I attempted to double-click as fast as I could to get some metrics on a reasonable debounce time that would go unnoticed. For the G502, I could not click faster than a delay of 75ms, meaning that a delay of about 70ms should go unnoticed for most people. A reasonable time for the fastest possible double-click might be to assume 20 clicks/second, meaning a 50ms delay. Logitech's current code is limited by the report rate, which assumes 1000 clicks/second at 1000 Hz, which is pretty rediculous. My code on the other hand assumes a 10ms (100 clicks/second) delay between successive clicks and is configurable.

## II. Background
I have a Logitech G502 that started double-clicking after 3-4 years. I looked up the current model of G502 (and several other gaming mice from different brands) and saw that they all had a similar issue. In under a year, most gaming mice would start having an issue with double-clicking. I have described this here: https://www.reddit.com/r/LogitechG/comments/j5uecz/software_fix_for_double_clicking_logitech_mice/

### A. Macro Fix
For double-clicking and click/drag issues on the G502 (and by extension, most Logitech gaming mice), a macro can be used to fix this issue. Macros for the main mouse buttons (LMB, RMB, and MMB) can be seen in /G502_Mouse_Fix_Project/Personal_Setup_Macros/ in images 03, 04, and 05 respectively.

### B. Other Buttons
So, great.. The macro fix works for those three buttons. What if the other buttons are double-clicking or can't be dragged? No worries! I have taken the time to develop a LUA script to solve this issue for the remaining buttons. Upside? it can fix the issue with a little bit of work. Downside? It's not quite as straight-forward. My goal is to make this fix as accessible as possible and to do most of the heavy-lifting as far as the environment and tools.

## III. Resources
G HUB Manual: https://www.logitech.com/assets/65550/ghub.pdf

Logitech API: https://douile.github.io/logitech-toggle-keys/APIDocs.pdf

# The Fix
## I. Before Starting
If you have a mouse that is not the G502, don't worry. It can be done, it just will take a little more work in figuring out which button is which. I will get to that later.

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

and make sure to update:
* num_mouse_buttons
## V. Configuring Mouse Button Delay (The Fix!)

## VI. Configuring Mouse Button Actions
We are going to start by using the script:
>/G502_Mouse_Fix_Project/G502_MB_Personal.lua
### A. For Those Who Code
* Load the function that you want to run into "button_press_tbl" (Use nil if empty or handled by G HUB)
* Load 0-1 function arguments into "button_press_args" (Use nil if no arguments)
* Repeat for "button_release_tbl" and "button_release_args"
### B. For Those Who Don't Code
Each button can be attached to a macro in G HUB, a keyboard key, or a mouse click. I have tried to comment my code thoroughly to make it as easy as possible to use for even those who don't code. Let's go over the different types of things we might want to implement.
#### i. Click (quick press and release)
#### ii. Click (with hold/drag)
#### iii. Empty/unused buttons.
#### iv. Keyboard Keys (quick press and release)
#### v. Keyboard Keys (with hold/drag)
#### vi. Macros (Increase/DPI/Volume/Etc)
