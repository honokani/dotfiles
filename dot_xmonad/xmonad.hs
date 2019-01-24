import XMonad
-- layout
import XMonad.Hooks.ManageDocks    (avoidStruts)-- avoid xmobar area
import XMonad.Layout.DragPane      (DragType(Horizontal, Vertical), dragPane) -- see only two window
import XMonad.Layout.NoBorders     (noBorders) -- In Full mode, border is no use
import XMonad.Layout.ResizableTile (ResizableTall(..)) -- Resizable Horizontal border
import XMonad.Layout.Spacing       (spacing) -- this makes smart space around windows
import XMonad.Layout.Simplest      (Simplest(..))
import XMonad.Layout.ToggleLayouts (toggleLayouts) -- Full window at any time
-- manage window position
import XMonad.Hooks.ManageDocks    (manageDocks) -- avoid xmobar area
import XMonad.ManageHook           ((-->)) -- avoid xmobar area
import XMonad.Hooks.Place          (placeHook, fixed)
-- key config
import XMonad.Util.EZConfig -- removeKeys, additionalKeys
-- loghook
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run             (spawnPipe, hPutStrLn)
import XMonad.Hooks.FadeInactive   (fadeInactiveLogHook)


-- window tranceparent ratio
tranceparentRatio = 0xdddddddd
-- my colors
myGray      = "#676767"
myGrayAlt   = "#313131"
myWhite     = "#d3d7cf"
--myBlue      = "#857da9"
myBlue      = "#6699ff"
--myGreen     = "#88b986"
myGreen     = "#adffbf"
myNormalbg  = "#1a1e1b"



-- * main *
main = do
    -- mb <- spawnPipe "xmobar"
    xmonad defaultConfig { terminal = "urxvt"
                         , modMask = mod1Mask
                         , borderWidth = 2
                         , normalBorderColor = myGray
                         , focusedBorderColor = myGreen
                         , startupHook = myStartups
                         , logHook = myLogHook
                         , layoutHook = toggleLayouts (noBorders Full) $ avoidStruts $ myLayouts
                         , manageHook = placeHook myPlacement
                                        <+> myManageHookShift
                                        <+> myManageHookFloat
                                        <+> manageDocks
                         , workspaces = mySpaceNames
                         }



-- * startup hooks *
myStartups = do
    spawn "feh --bg-fill $HOME/.xmonad/wps/wp.jpg"
    --spawn "$HOME/.xmonad/wps.sh"
    spawn "ibus-daemon --xim --replace &"
    spawn "xcompmgr &"

-- * log hooks *
myLogHook = do
    -- dynamicLogWithPP xmobarPP { ppOutput = hPutStrLn mb }
    fadeInactiveLogHook tranceparentRatio


-- * work spaces *
data MyWorkspaces = MyMain
                  | MyBrowser
                  | MyMedia
                  | MyWork
                  | MyTray
                  deriving (Show, Enum, Bounded)
myWorkspacesAll :: [MyWorkspaces]
myWorkspacesAll = [minBound..maxBound]

makeSpaceName :: MyWorkspaces -> String
makeSpaceName = wrap2spaces.showWithout'My'
    where
        showWithout'My' = drop 2.show
        wrap2spaces x = "  " ++ x ++ "  "
mySpaceNames :: [String]
mySpaceNames = map makeSpaceName myWorkspacesAll



-- * application management *
data AppClassesToUse = Firefox
                     | Mplayer
                     | Gimp
                     deriving (Show)
appWindowMap :: [(AppClassesToUse, MyWorkspaces)]
appWindowMap = [ (Firefox, MyBrowser)
               , (Mplayer, MyMedia)
               ]
appWindowFloatings :: [AppClassesToUse]
appWindowFloatings = [ Mplayer
                     , Gimp
                     ]
-- if you want to know className, type "$ xprop|grep CLASS" on shell
myManageHookShift = composeAll $ map makeShift appWindowMap
    where
        makeShift (x,y) = className =? (show x) --> doShift (makeSpaceName y)
myManageHookFloat = composeAll $ map makeFloat appWindowFloatings
    where
        makeFloat x = className =? (show x) --> doFloat
myPlacement = fixed (0.5, 0.5)



-- * layout *
myLayouts =   ( surround_18px $ ResizableTall 1 (3/100) (2/3) [] )
          ||| ( surround_02px $ dragPane Horizontal (1/10) (1/2) )
          ||| ( surround_00px $ dragPane Vertical   (1/10) (1/2) )
          ||| ( surround_00px $ Simplest                         )
    where
        surround_00px = id
        surround_02px = spacing 2
        surround_18px = spacing 18

