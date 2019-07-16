# rofi-wifi-menu
A wifi menu for i3/openbox/etc. written in bash. Uses rofi and nmcli.

## Table of Contents
* [Screenshots](#screenshots)
* [Requirements](#requirements)
  * [Optional](#optional)
* [Installation](#installation)
* [Configuration](#configuration)
  * [position](#position)
  * [y-offset](#y-offset)
  * [x-offset](#x-offset)
  * [fields](#fields)
* [ToDo](#todo)

### Screenshots

#### Desktop
![Desktop](https://raw.githubusercontent.com/zbaylin/rofi-wifi-menu/master/screenshots/rofi-wifi-menu-desktop.png)

#### Default
![Default](https://raw.githubusercontent.com/zbaylin/rofi-wifi-menu/master/screenshots/rofi-wifi-menu-default.png)

#### Manual Entry
![Manual Entry](https://raw.githubusercontent.com/zbaylin/rofi-wifi-menu/master/screenshots/rofi-wifi-menu-manual.png)

#### Toggle On
![Toggle On](https://raw.githubusercontent.com/zbaylin/rofi-wifi-menu/master/screenshots/rofi-wifi-menu-toggleon.png)

### Requirements

* nmcli
* iw
* rofi ( _I may end up expanding compatibility to dmenu_ )
* bash ( _but you probably already knew that_ )

#### _Optional_

* lemonbar (or some other bar, i.e. tint2)
* openbox/i3/etc.

### Installation
* make sure you have all the dependencies installed

* run the following commands in your terminal. Replace uppercase variables with personal choice
```
cd DESIRED_DIRECTORY
git clone https://github.com/zbaylin/rofi-wifi-menu.git
cd rofi-wifi-menu
bash "./rofi-wifi-menu.sh"
```

### Configuration
rofi-wifi-menu has an example configuration file in the repository. It will run without it, but will warn you if it does not exist.

To configure rofi-wifi-menu, first cd into the directory it is installed into. Then edit the file `config.example`.
It should contain the following variables:
* position
* y-offset
* x-offset
* fields

#### position
position can be configured where the number represents the position on this screen in this way

| *Screen*   | Left | Right | Center |
|------------|------|-------|--------|
| **Top**    | 1    | 2     | 3      |
| **Center** | 8    | 0     | 4      |
| **Bottom** | 7    | 6     | 5      |

#### y-offset

y-offset is measured in pixels. A positive value moves the window downward, while a negative value moves it upward.

#### x-offset

x-offset is measured in pixels. A positive value move the window rightward, while a negative value moves it leftward.

#### fields

fields choose what is displayed by the menu. The available fields are as follows:

`NAME,SSID,SSID-HEX,BSSID,MODE,CHAN,FREQ,RATE,SIGNAL,BARS,SECURITY,WPA-FLAGS,RSN-FLAGS,DEVICE,ACTIVE,IN-USE,DBUS-PATH`

### ToDo

✔️ Add ability to manually specify SSID

✔️ Add ability to configure the script externally

✔️ Use rofi highlighting

❌ Add more forms of security (PEAP, etc.)

❌ Remove duplicate APs
