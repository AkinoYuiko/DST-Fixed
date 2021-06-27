local _G = GLOBAL
local Vector3 = _G.Vector3
local containers = require("containers")
local params = containers.params

params.showbundle_alterguardianhat = 
{
    widget =
    {
        slotpos =
        {
            Vector3(-75,  38),
            Vector3( 0,   38),
            Vector3( 75,  38),
            Vector3(-75, -34),
            Vector3( 0,  -34),
            Vector3( 75, -36),
        },
        slotbg = {
            [6] = { image = "alterguardianhat.tex", atlas = _G.GetInventoryItemAtlas("alterguardianhat.tex") }
        },
        animbank = "ui_showbundle_3x2",
        animbuild = "ui_showbundle_3x2",
        bg_scale = Vector3(0.85, 0.9),
        pos = Vector3(0, 85, 0),
    }
}
