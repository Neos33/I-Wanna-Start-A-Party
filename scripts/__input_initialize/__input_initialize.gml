__input_initialize();

function __input_initialize()
{
    if (variable_global_exists("__input_initialization_phase")) return false;
    global.__input_initialization_phase = "Pending";
    
    //Set up the extended debug functionality
    global.__input_debug_log = "input___" + string_replace_all(string_replace_all(date_datetime_string(date_current_datetime()), ":", "-"), " ", "___") + ".txt";
    if (INPUT_EXTERNAL_DEBUG_LOG && __INPUT_DEBUG)
    {
        show_debug_message("Input: Set external debug log to \"" + string(global.__input_debug_log) + "\"");
        exception_unhandled_handler(__input_exception_handler);
    }
    
    __input_trace("Welcome to Input by @jujuadams and @offalynne! This is version ", __INPUT_VERSION, ", ", __INPUT_DATE);
    
    //Attempt to set up a time source for slick automatic input handling
    try
    {
        //GMS2022.500.58 runtime
        global.__input_time_source = time_source_create(time_source_game, 1, time_source_units_frames, function()
        {
            __input_system_tick();
        }, [], -1);
        
        time_source_start(global.__input_time_source);
    }
    catch(_error)
    {
        try
        {
            //Early GMS2022.500.xx runtimes
            global.__input_time_source = time_source_create(time_source_game, 1, time_source_units_frames, function()
            {
                __input_system_tick();
            }, -1);
            
            time_source_start(global.__input_time_source);
        }
        catch(_error)
        {
            //If the above fails then fall back on needing to call input_tick()
            global.__input_time_source = undefined;
            __input_trace("Warning! Running on a GM runtime earlier than 2022.5");
        }
    }
    
    //Global frame counter and realtime tracker. This is used for input buffering
    global.__input_frame = 0;
    global.__input_current_time = current_time;
    global.__input_previous_current_time = current_time;
    
    //Whether momentary input has been cleared
    global.__input_cleared = false;
    
    //Windows focus tracking
    global.__input_window_focus = true;
    
    //Accessibility state
    global.__input_toggle_momentary_dict  = {};
    global.__input_toggle_momentary_state = false;
    global.__input_cooldown_dict          = {};
    global.__input_cooldown_state         = false;
    
    //Windows tap-to-click tracking
    global.__input_tap_presses  = 0;
    global.__input_tap_releases = 0;
    global.__input_tap_click    = false;
    
    //Touch pointer tracking
    global.__input_pointer_index         = 0;
    global.__input_pointer_pressed       = false;
    global.__input_pointer_released      = false;
    global.__input_pointer_pressed_index = undefined;
    global.__input_pointer_durations     = array_create(INPUT_MAX_TOUCHPOINTS, 0);
    global.__input_pointer_coord_space   = INPUT_COORD_SPACE.ROOM;
    global.__input_pointer_x             = array_create(INPUT_COORD_SPACE.__SIZE, 0);
    global.__input_pointer_y             = array_create(INPUT_COORD_SPACE.__SIZE, 0);
    global.__input_pointer_dx            = array_create(INPUT_COORD_SPACE.__SIZE, 0);
    global.__input_pointer_dy            = array_create(INPUT_COORD_SPACE.__SIZE, 0);
    global.__input_pointer_moved         = false;
    
    global.__input_mouse_capture             = false;
    global.__input_mouse_capture_sensitivity = false;
    global.__input_mouse_capture_frame       = false;
    
    //Whether to strictly verify bindings match auto profiles
    //This is set to <true> on boot, causing Input to throw an error, otherwise this is <false>
    //If an invalid binding is set during normal gameplay then a warning message is emitted to the console
    global.__input_strict_binding_check = false;
    
    //Whether these particular input sources are valid
    //This is determined by what default keybindings are set up
    global.__input_any_keyboard_binding_defined = false;
    global.__input_any_mouse_binding_defined    = false;
    global.__input_any_gamepad_binding_defined  = false;
    
    //Disallow keyboard bindings on specified platforms unless explicitly enabled
    global.__input_keyboard_allowed = (__INPUT_KEYBOARD_SUPPORT && ((os_type != os_android) || INPUT_ANDROID_KEYBOARD_ALLOWED) && ((os_type != os_switch) || INPUT_SWITCH_KEYBOARD_ALLOWED));

    //Disallow mouse bindings on specified platforms (unless explicitly enabled)
    global.__input_mouse_allowed = !(__INPUT_ON_PS || __INPUT_ON_XBOX || (__INPUT_TOUCH_SUPPORT && !INPUT_TOUCH_POINTER_ALLOWED));

    //Whether mouse is blocked due to Window focus state
    global.__input_mouse_blocked = false;
    
    global.__input_cursor_verbs_valid = false;
    
    //Whether to swap A/B gamepad buttons for default bindings
    global.__input_swap_ab = false;
    
    //Arrays/dictionaries to track verbs, chords, and combos
    global.__input_all_verb_dict  = {};
    global.__input_all_verb_array = [];
    
    global.__input_basic_verb_dict  = {};
    global.__input_basic_verb_array = [];
    
    global.__input_chord_verb_dict  = {};
    global.__input_chord_verb_array = [];
    
    global.__input_combo_verb_dict  = {};
    global.__input_combo_verb_array = [];
    
    //Struct to store keyboard key names
     global.__input_key_name_dict = {};
    
    //Struct to store all the keyboard keys we want to ignore
    global.__input_ignore_key_dict = {};
    
    //Struct to store ignored gamepad types
    global.__input_ignore_gamepad_types = {};
    
    //Two structs that are returned by input_players_get_status() and input_gamepads_get_status()
    //These are "static" structs that are reset and populated by input_tick()
    global.__input_players_status = {
        any_changed: false,
        new_connections: [],
        new_disconnections: [],
        players: array_create(INPUT_MAX_PLAYERS, INPUT_STATUS.DISCONNECTED),
    }
    
    global.__input_gamepads_status = {
        any_changed: false,
        new_connections: [],
        new_disconnections: [],
        gamepads: array_create(INPUT_MAX_GAMEPADS, INPUT_STATUS.DISCONNECTED),
    }
    
    //The default player. This player struct holds default binding data
    global.__input_default_player = new __input_class_player();
    
    //Array of players. Each player is a struct (instanceof __input_class_player) that contains lotsa juicy information
    global.__input_players = array_create(INPUT_MAX_PLAYERS, undefined);
    
    var _p = 0;
    repeat(INPUT_MAX_PLAYERS)
    {
        with(new __input_class_player())
        {
            global.__input_players[@ _p] = self;
            __index = _p;
        }
        
        ++_p;
    }
    
    enum INPUT_SOURCE_MODE
    {
        FIXED,        //Player sources won't change unless manually editted
        JOIN,         //Starts source assignment, typically used for multiplayer
        HOTSWAP,      //Player 0's source is determined by most recent input
        MIXED,        //Player 0 can use a mixture of keyboard, mouse, and any gamepad
        MULTIDEVICE, //Player 0 can use a mixture of keyboard, mouse, and any gamepad, but gamepad bindings are specific to each device
    }
    
    global.__input_source_mode = undefined;
    
    //Multiplayer source assignment state
    //This is set by input_multiplayer_set()
    global.__input_multiplayer_min       = 1;
    global.__input_multiplayer_max       = INPUT_MAX_PLAYERS;
    global.__input_multiplayer_drop_down = true;
    
    //Array of currently connected gamepads. If an element is <undefined> then the gamepad is disconnected
    //Each gamepad in this array is an instance of __input_class_gamepad
    //Gamepad structs contain remapping information and current button state
    global.__input_gamepads = array_create(INPUT_MAX_GAMEPADS, undefined);
    
    //Our database of SDL2 definitions, used for the aforementioned remapping information
    global.__input_sdl2_database = {
        by_guid           : {},
        by_vendor_product : {},
    };
    
    global.__input_sdl2_look_up_table = {
        a:             gp_face1,
        b:             gp_face2,
        x:             gp_face3,
        y:             gp_face4,
        dpup:          gp_padu,
        dpdown:        gp_padd,
        dpleft:        gp_padl,
        dpright:       gp_padr,
        leftx:         gp_axislh,
        lefty:         gp_axislv,
        rightx:        gp_axisrh,
        righty:        gp_axisrv,
        leftshoulder:  gp_shoulderl,
        rightshoulder: gp_shoulderr,
        lefttrigger:   gp_shoulderlb,
        righttrigger:  gp_shoulderrb,
        leftstick:     gp_stickl,
        rightstick:    gp_stickr,
        start:         gp_start,
        back:          gp_select,
    }
    
    if (INPUT_SDL2_ALLOW_EXTENDED)
    {
        global.__input_sdl2_look_up_table.guide    = gp_guide;
        global.__input_sdl2_look_up_table.misc1    = gp_misc1;
        global.__input_sdl2_look_up_table.touchpad = gp_touchpad;
        global.__input_sdl2_look_up_table.paddle1  = gp_paddle1;
        global.__input_sdl2_look_up_table.paddle2  = gp_paddle2;
        global.__input_sdl2_look_up_table.paddle3  = gp_paddle3;
        global.__input_sdl2_look_up_table.paddle4  = gp_paddle4;
    }
    
    #region Gamepad mapping database
    
    if (!__INPUT_SDL2_SUPPORT || !INPUT_SDL2_REMAPPING)
    {
        __input_trace("Skipping loading SDL database");
    }
    else
    {
        if (file_exists(INPUT_SDL2_DATABASE_PATH))
        {
            __input_load_sdl2_from_file(INPUT_SDL2_DATABASE_PATH);
        }
        else
        {
            __input_trace("Warning! \"", INPUT_SDL2_DATABASE_PATH, "\" not found in Included Files");
        }
        
        //Try to load an external SDL2 database if possible
        if (INPUT_SDL2_ALLOW_EXTERNAL)
        {
            var _external_string = environment_get_variable("SDL_GAMECONTROLLERCONFIG");

            if (_external_string != "")
            {
                __input_trace("External SDL2 string found");
            
                try
                {
                    __input_load_sdl2_from_string(_external_string);
                }
                catch(_error)
                {
                    __input_trace_loud("Error!\n\n%SDL_GAMECONTROLLERCONFIG% could not be parsed.\nYou may see unexpected behaviour when using gamepads.\n\nTo remove this error, clear %SDL_GAMECONTROLLERCONFIG%\n\nInput ", __INPUT_VERSION, "   @jujuadams and @offalynne ", __INPUT_DATE);
                }
            }
        }
    }
    
    #endregion
  
    var _default_xbox_type = "xbox one"; //Default type assigned to XInput and Xbox-like gamepads
    
    #region Gamepad type identification
    
    //Lookup table for simple gamepad types based on raw types
    global.__input_simple_type_lookup = {
    
        //Xbox
        CommunityLikeXBox: _default_xbox_type,

        XBoxOneController: "xbox one",
        SteamControllerV2: "xbox one",
        CommunityXBoxOne:  "xbox one",
        AppleController:   "xbox one", // Apple uses Xbox One iconography excepting 'View' button, shoulders, triggers
        CommunityStadia:   "xbox one", //Stadia uses Xbox One iconography excepting 'View' button, shoulders, triggers
        CommunityLuna:     "xbox one", //  Luna uses Xbox One iconography excepting 'View' button
        
        XBox360Controller:  "xbox 360",
        CommunityXBox360:   "xbox 360",
        CommunityDreamcast: "xbox 360", //        Xbox 360 uses Dreamcast iconography
        SteamController:    "xbox 360", //Steam Controller uses X-Box 360 iconography
        MobileTouch:        "xbox 360", //      Steam Link uses X-Box 360 iconography
        
        //PlayStation
        PS5Controller: "ps5",
        PS4Controller: "ps4",
        CommunityPS4:  "ps4",
        PS3Controller: "psx",
        CommunityPSX:  "psx",
        
        //Switch
        SwitchHandheld:            "switch", //Attached JoyCon pair or Switch Lite
        SwitchJoyConPair:          "switch",
        SwitchProController:       "switch",
        XInputSwitchController:    "switch",
        SwitchInputOnlyController: "switch",
        CommunityLikeSwitch:       "switch",
        Community8BitDo:           "switch", //8BitDo are Switch gamepads (exceptions typed appropriately)
        WiiClassic:                "switch",

        SwitchJoyConLeft:  "switch joycon left",
        SwitchJoyConRight: "switch joycon right",
        
        //Legacy
        CommunityGameCube:     "gamecube",
        CommunityN64:          "n64",
        CommunitySaturn:       "saturn",
        CommunitySNES:         "snes",
        CommunitySuperFamicom: "snes",
        
        Unknown: "unknown",
        unknown: "unknown",
        
        UnknownNonSteamController: "unknown",
        CommunityUnknown:          "unknown",
        CommunitySteam:            "unknown"
        
    }
    
    //Parse controller type database
    global.__input_raw_type_dictionary = { none : _default_xbox_type };

    //Load the controller type database
    if (__INPUT_ON_CONSOLE || __INPUT_ON_OPERAGX || (os_type == os_ios) || (os_type == os_tvos))
    {
        __input_trace("Skipping loading controller type database");
    }
    else if (file_exists(INPUT_CONTROLLER_TYPE_PATH))
    {
        __input_load_type_csv(INPUT_CONTROLLER_TYPE_PATH);
    }
    else
    {
        __input_trace("Warning! \"", INPUT_CONTROLLER_TYPE_PATH, "\" not found in Included Files");
    }
    
    #endregion
    
    
    
    #region Gamepad device blocklist
    
    global.__input_blacklist_dictionary = {};
    if (!__INPUT_SDL2_SUPPORT)
    {
        __input_trace("Skipping loading controller blacklist database");
    }
    else
    {
        //Parse the controller type database
        if (file_exists(INPUT_BLACKLIST_PATH))
        {
            __input_load_blacklist_csv(INPUT_BLACKLIST_PATH);
        }
        else
        {
            __input_trace("Warning! \"", INPUT_BLACKLIST_PATH, "\" not found in Included Files");
        }
    }
    
    #endregion



    #region Key names

    __input_key_name_set(vk_backtick,   "`");
    __input_key_name_set(vk_hyphen,     "-");
    __input_key_name_set(vk_equals,     "=");
    __input_key_name_set(vk_semicolon,  ";");
    __input_key_name_set(vk_apostrophe, "'");
    __input_key_name_set(vk_comma,      ",");
    __input_key_name_set(vk_period,     ".");
    __input_key_name_set(vk_rbracket,   "]");
    __input_key_name_set(vk_lbracket,   "[");
    __input_key_name_set(vk_fslash,     "/");
    __input_key_name_set(vk_bslash,     "\\");

    __input_key_name_set(vk_scrollock, "scroll lock");
    __input_key_name_set(vk_capslock,  "caps lock");
    __input_key_name_set(vk_numlock,   "num lock");
    __input_key_name_set(vk_lmeta,     "left meta");
    __input_key_name_set(vk_rmeta,     "right meta");
    __input_key_name_set(vk_clear,     "clear");
    __input_key_name_set(vk_menu,      "menu");

    __input_key_name_set(vk_printscreen, "print screen");
    __input_key_name_set(vk_pause,       "pause break");
    
    __input_key_name_set(vk_escape,    "escape");
    __input_key_name_set(vk_backspace, "backspace");
    __input_key_name_set(vk_space,     "space");
    __input_key_name_set(vk_enter,     "enter");
    
    __input_key_name_set(vk_up,    "arrow up");
    __input_key_name_set(vk_down,  "arrow down");
    __input_key_name_set(vk_left,  "arrow left");
    __input_key_name_set(vk_right, "arrow right");
    
    __input_key_name_set(vk_tab,      "tab");
    __input_key_name_set(vk_ralt,     "right alt");
    __input_key_name_set(vk_lalt,     "left alt");
    __input_key_name_set(vk_alt,      "alt");
    __input_key_name_set(vk_rshift,   "right shift");
    __input_key_name_set(vk_lshift,   "left shift");
    __input_key_name_set(vk_shift,    "shift");
    __input_key_name_set(vk_rcontrol, "right ctrl");
    __input_key_name_set(vk_lcontrol, "left ctrl");
    __input_key_name_set(vk_control,  "ctrl");

    __input_key_name_set(vk_f1,  "f1");
    __input_key_name_set(vk_f2,  "f2");
    __input_key_name_set(vk_f3,  "f3");
    __input_key_name_set(vk_f4,  "f4");
    __input_key_name_set(vk_f5,  "f5");
    __input_key_name_set(vk_f6,  "f6");
    __input_key_name_set(vk_f7,  "f7");
    __input_key_name_set(vk_f8,  "f8");
    __input_key_name_set(vk_f9,  "f9");
    __input_key_name_set(vk_f10, "f10");
    __input_key_name_set(vk_f11, "f11");
    __input_key_name_set(vk_f12, "f12");

    __input_key_name_set(vk_divide,   "numpad /");
    __input_key_name_set(vk_multiply, "numpad *");
    __input_key_name_set(vk_subtract, "numpad -");
    __input_key_name_set(vk_add,      "numpad +");
    __input_key_name_set(vk_decimal,  "numpad .");

    __input_key_name_set(vk_numpad0, "numpad 0");
    __input_key_name_set(vk_numpad1, "numpad 1");
    __input_key_name_set(vk_numpad2, "numpad 2");
    __input_key_name_set(vk_numpad3, "numpad 3");
    __input_key_name_set(vk_numpad4, "numpad 4");
    __input_key_name_set(vk_numpad5, "numpad 5");
    __input_key_name_set(vk_numpad6, "numpad 6");
    __input_key_name_set(vk_numpad7, "numpad 7");
    __input_key_name_set(vk_numpad8, "numpad 8");
    __input_key_name_set(vk_numpad9, "numpad 9");

    __input_key_name_set(vk_delete,   "delete");
    __input_key_name_set(vk_insert,   "insert");
    __input_key_name_set(vk_home,     "home");
    __input_key_name_set(vk_pageup,   "page up");
    __input_key_name_set(vk_pagedown, "page down");
    __input_key_name_set(vk_end,      "end");
   
    //Name newline character after Enter
    __input_key_name_set(10, global.__input_key_name_dict[$ vk_enter]);
    
    //Reset F11 and F12 keycodes on certain platforms
    if ((os_type == os_switch) || (os_type == os_linux) || (os_type == os_macosx))
    {
        __input_key_name_set(128, "f11");
        __input_key_name_set(129, "f12");
    }
   
    //F13 to F32 on Windows and Web
    if ((os_type == os_windows) || (__INPUT_ON_WEB))
    {
        for(var _i = vk_f1 + 12; _i < vk_f1 + 32; _i++) __input_key_name_set(_i, "f" + string(_i));
    }
    
    //Numeric keys 2-7 on Switch
    if (os_type == os_switch)
    {
        for(var _i = 2; _i <= 7; _i++) __input_key_name_set(_i, __input_key_get_name(ord(_i)));
    }
    
    #endregion



    #region Ignored keys
    
    //Keyboard ignore level 1+
    if (INPUT_IGNORE_RESERVED_KEYS_LEVEL > 0)
    {
        input_ignore_key_add(vk_alt);
        input_ignore_key_add(vk_ralt);
        input_ignore_key_add(vk_lalt);
        input_ignore_key_add(vk_lmeta);
        input_ignore_key_add(vk_rmeta);
        
        input_ignore_key_add(0xFF); //Vendor key
        
        if (__INPUT_ON_MOBILE && __INPUT_ON_APPLE)
        {
            input_ignore_key_add(124); //Screenshot
        }
        
        if (__INPUT_ON_WEB)
        {
            if (__INPUT_ON_APPLE)
            {
                input_ignore_key_add(vk_f10); //Fullscreen
                input_ignore_key_add(vk_capslock);
            }
            else
            {
                input_ignore_key_add(vk_f11); //Fullscreen
            }
        }
    }
    
    //Keyboard ignore level 2+
    if (INPUT_IGNORE_RESERVED_KEYS_LEVEL > 1)
    {
        input_ignore_key_add(vk_numlock);   //Num Lock
        input_ignore_key_add(vk_scrollock); //Scroll Lock
        
        if (__INPUT_ON_WEB || (os_type == os_windows))
        {
            input_ignore_key_add(0x15); //IME Kana/Hanguel
            input_ignore_key_add(0x16); //IME On
            input_ignore_key_add(0x17); //IME Junja
            input_ignore_key_add(0x18); //IME Final
            input_ignore_key_add(0x19); //IME Kanji/Hanja
            input_ignore_key_add(0x1A); //IME Off
            input_ignore_key_add(0x1C); //IME Convert
            input_ignore_key_add(0x1D); //IME Nonconvert
            input_ignore_key_add(0x1E); //IME Accept
            input_ignore_key_add(0x1F); //IME Mode Change
            input_ignore_key_add(0xE5); //IME Process
            
            input_ignore_key_add(0xA6); //Browser Back
            input_ignore_key_add(0xA7); //Browser Forward
            input_ignore_key_add(0xA8); //Browser Refresh
            input_ignore_key_add(0xA9); //Browser Stop
            input_ignore_key_add(0xAA); //Browser Search
            input_ignore_key_add(0xAB); //Browser Favorites
            input_ignore_key_add(0xAC); //Browser Start/Home
            
            input_ignore_key_add(0xAD); //Volume Mute
            input_ignore_key_add(0xAE); //Volume Down
            input_ignore_key_add(0xAF); //Volume Up
            input_ignore_key_add(0xB0); //Next Track
            input_ignore_key_add(0xB1); //Previous Track
            input_ignore_key_add(0xB2); //Stop Media
            input_ignore_key_add(0xB3); //Play/Pause Media
            
            input_ignore_key_add(0xB4); //Launch Mail
            input_ignore_key_add(0xB5); //Launch Media
            input_ignore_key_add(0xB6); //Laumch App 1
            input_ignore_key_add(0xB7); //Launch App 2
            
            input_ignore_key_add(0xFB); //Zoom
        }
    }
    
    #endregion
    
    
    
    #region Steam Input
    
    if (((os_type == os_linux) || (os_type == os_macosx)) && !__INPUT_ON_WEB)
    {
        //Define the virtual controller's identity
        var _os = ((os_type == os_macosx)? "macos"    : "linux");
        var _id = ((os_type == os_macosx)? "5e048e02" : "de28ff11");
    
        //Access the blacklist
        var _blacklist_os = (is_struct(global.__input_blacklist_dictionary)? global.__input_blacklist_dictionary[$ _os] : undefined);
        var _blacklist_id = (is_struct(_blacklist_os)? _blacklist_os[$ "vid+pid"] : undefined);
    
        if (is_struct(_blacklist_os) && (_blacklist_id == undefined))
        {
            //Add 'Vendor ID + Product ID' category
            _blacklist_os[$ "vid+pid"] = {};
            _blacklist_id = (is_struct(_blacklist_os)? _blacklist_os[$ "vid+pid"] : undefined);
        }
    
        //Blacklist the Steam virtual controller
        if (is_struct(_blacklist_id)) _blacklist_id[$ _id] = true;   
    }
    
    if ((os_type == os_linux) && !__INPUT_ON_WEB)
    {
        var _steam_environ = environment_get_variable("SteamEnv");
        var _steam_configs = environment_get_variable("EnableConfiguratorSupport");
    
        if ((_steam_environ != "") && (_steam_environ == "1")
        &&  (_steam_configs != "") && (_steam_configs == string_digits(_steam_configs)))
        {
            //If run through Steam remove Steam virtual controller from the blocklist
            if (is_struct(_blacklist_id)) variable_struct_remove(_blacklist_id, _id);
        
            var _bitmask = real(_steam_configs);
        
            //Resolve Steam Input configuration
            var _steam_ps      = (_bitmask & 1);
            var _steam_xbox    = (_bitmask & 2);
            var _steam_generic = (_bitmask & 4);
            var _steam_switch  = (_bitmask & 8);
            
            var _ignore_list = [];
        
            if (environment_get_variable("SDL_GAMECONTROLLER_IGNORE_DEVICES") == "")
            {
                //If ignore hint isn't set, GM accesses controllers meant to be blocked
                //We address this by adding the Steam config types to our own blocklist
                if (_steam_switch)  array_push(_ignore_list, "switch");
                if (_steam_ps)      array_push(_ignore_list, "ps4", "ps5");
                if (_steam_xbox)    array_push(_ignore_list, "xbox 360", "xbox one");        
                if (_steam_generic) array_push(_ignore_list, "snes", "saturn", "n64", "gamecube", "psx", "xbox", "switch joycon left", "switch joycon right", "unknown");
             
                var _i = 0;
                repeat(array_length(_ignore_list))
                {
                    global.__input_ignore_gamepad_types[$ _ignore_list[_i]] = true;
                }
            }
            
            //Check for a reducible type configuration
            var _steam_switch_labels = environment_get_variable("SDL_GAMECONTROLLER_USE_BUTTON_LABELS");
            if (!_steam_generic && !_steam_ps
            && (!_steam_switch || ((_steam_switch_labels != "") && (_steam_switch_labels == "1"))))
            {
                //The remaining configurations are in the Xbox Controller style including:
                //Steam Controller, Steam Link, Steam Deck, Xbox or Switch with AB/XY swap
                global.__input_simple_type_lookup[$ "CommunitySteam"] = _default_xbox_type;
            }
        }
    }

    #endregion
    
    
    
    #region Keyboard locale
    
    var _locale = os_get_language() + "-" + os_get_region();
    switch(_locale)
    {
        case "en-US": case "en-":
        case "en-GB": case "-":
            INPUT_KEYBOARD_LOCALE = "QWERTY";
        break;

        case "ar-DZ": case "ar-MA": case "ar-TN":
        case "fr-BE": case "fr-FR": case "fr-MC":
        case "co-FR": case "oc-FR": case "ff-SN": 
        case "wo-SN": case "gsw-FR": 
        case "nl-BE": case "tzm-DZ":
            INPUT_KEYBOARD_LOCALE = "AZERTY";
        break;  

        case "cs-CZ": case "de-AT": case "de-CH": 
        case "de-DE": case "de-LI": case "de-LU": 
        case "fr-CH": case "fr-LU": case "sq-AL":
        case "hr-BA": case "hr-HR": case "hu-HU":
        case "lb-LU": case "rm-CH": case "sk-SK": 
        case "sl-SI": case "dsb-DE":
        case "sr-BA": case "hsb-DE":
            INPUT_KEYBOARD_LOCALE = "QWERTZ";
        break;

        default:
            INPUT_KEYBOARD_LOCALE = "QWERTY";
        break;
    }
    
    #endregion 
    
    
    
    #region Keyboard type
    
    if (__INPUT_ON_CONSOLE || (__INPUT_ON_WEB && !__INPUT_ON_DESKTOP))
    {
        INPUT_KEYBOARD_TYPE = "async";
    }
    else if (__INPUT_ON_MOBILE)
    {
        var _ret = "virtual";
        if (os_type == os_android)
        {
            var _map = os_get_info();
            if (ds_exists(_map, ds_type_map))
            {
                if (_map[? "PHYSICAL_KEYBOARD"])
                {
                    _ret = "keyboard";
                }

                ds_map_destroy(_map);
            }
        }

        INPUT_KEYBOARD_TYPE = _ret;
    }
    else
    {
        INPUT_KEYBOARD_TYPE = "keyboard";
    }
    
    #endregion
    
    
    
    //By default GameMaker registers double click (or tap) as right mouse button
    //We want to be able to identify the actual mouse buttons correctly, and have our own double-input handling
    device_mouse_dbclick_enable(false);
    
    global.__input_profile_array         = undefined;
    global.__input_profile_dict          = undefined;
    global.__input_default_profile_dict  = undefined;
    global.__input_verb_to_group_dict    = {};
    global.__input_group_to_verbs_dict   = {};
    global.__input_verb_group_array      = [];
    global.__input_null_binding          = input_binding_empty();
    global.__input_icons                 = {};
    
    
    
    //Build out the sources
    INPUT_KEYBOARD = new __input_class_source(__INPUT_SOURCE.KEYBOARD);
    INPUT_MOUSE = INPUT_ASSIGN_KEYBOARD_AND_MOUSE_TOGETHER? INPUT_KEYBOARD : (new __input_class_source(__INPUT_SOURCE.MOUSE));
    
    INPUT_GAMEPAD = array_create(INPUT_MAX_GAMEPADS, undefined);
    var _g = 0;
    repeat(INPUT_MAX_GAMEPADS)
    {
        INPUT_GAMEPAD[@ _g] = new __input_class_source(__INPUT_SOURCE.GAMEPAD, _g);
        ++_g;
    }
    
    
    
    global.__input_initialization_phase = "__input_finalize_default_profiles";
    __input_config_profiles_and_default_bindings();
    
    global.__input_initialization_phase = "__input_finalize_verb_groups";
    __input_config_verbs();
    
    
    
    //Resolve the starting source mode
    input_source_mode_set(INPUT_STARTING_SOURCE_MODE);
    
    if (INPUT_STARTING_SOURCE_MODE == INPUT_SOURCE_MODE.MIXED)
    {
        if (!variable_struct_exists(global.__input_profile_dict, INPUT_AUTO_PROFILE_FOR_MIXED)) __input_error("Default profile for mixed \"", INPUT_AUTO_PROFILE_FOR_MIXED, "\" has not been defined in INPUT_DEFAULT_PROFILES");
        input_profile_set(INPUT_AUTO_PROFILE_FOR_MIXED);
    }
    else if (INPUT_STARTING_SOURCE_MODE == INPUT_SOURCE_MODE.MULTIDEVICE)
    {
        if (!variable_struct_exists(global.__input_profile_dict, INPUT_AUTO_PROFILE_FOR_MULTIDEVICE)) __input_error("Default profile for multidevice \"", INPUT_AUTO_PROFILE_FOR_MULTIDEVICE, "\" has not been defined in INPUT_DEFAULT_PROFILES");
        input_profile_set(INPUT_AUTO_PROFILE_FOR_MULTIDEVICE);
    }
    
    
    
    //Make sure we're not misconfigured
    __input_validate_macros();
    
    global.__input_initialization_phase = "Complete";
    
    return true;
}
