Config = {}

Config.Developer = true
Config.Locations = {
    --low class
    {x = -231.7128, y =311.6248, z = 92.16626, radius = 200.0, color = 2, diff = 3, weapon = 'WEAPON_SNSPISTOL'},
    {x = -752.0413, y = 368.2673, z = 87.86913, radius = 200.0, color = 2, diff = 3, weapon = 'WEAPON_SNSPISTOL'},
    {x = -367.7654, y = -1525.632, z = 27.7573, radius = 200.0, color = 2, diff = 3, weapon = 'WEAPON_SNSPISTOL'},
    {x = 1185.369, y = -1358.03, z = 34.95679, radius = 200.0, color = 2, diff = 3, weapon = 'WEAPON_SNSPISTOL'},
    {x = 3575.709, y = 3769.046, z = 29.92107, radius = 200.0, color = 2, diff = 3, weapon = 'WEAPON_SNSPISTOL'},
    {x = -570.5073, y =  5344.351, z = 70.24323, radius = 200.0, color = 2, diff = 3, weapon = 'WEAPON_SNSPISTOL'},
    {x = 1184.375, y =  -1557.705, z = 39.40099,radius = 200.0, color = 2, diff = 3, weapon = 'WEAPON_SNSPISTOL'},
    {x = 80.32881, y =  -410.0465, z = 37.85736, radius = 200.0, color = 2, diff = 3, weapon = 'WEAPON_SNSPISTOL'},
    --mid class
    {x = 100.1995, y = -2193.46, z = 6.036561, radius = 200.0, color = 47, diff = 4, weapon = 'WEAPON_PISTOL'},
    {x = -137.3586, y = -23.20039, z = 59.94114, radius = 200.0, color = 47, diff = 4, weapon = 'WEAPON_PISTOL'},
    --high class
    {x = 1369.597, y = -734.9691, z = 67.2329, radius = 200.0, color = 1, diff = 5, weapon = 'WEAPON_HEAVYPISTOL'},
    {x = 2726.86, y = 1357.797, z = 24.52393, radius = 200.0, color = 1, diff = 5, weapon = 'WEAPON_HEAVYPISTOL'},


}

Config.PedAppearance = 'g_m_y_mexgoon_01'

Config.StartNPCAppearance = 'a_m_m_trampbeac_01'
Config.NPCStart = vector3(-799.1818, -893.6425, 19.857) 
Config.NPCHeading = 30 
Config.NPCAnimation = true
Config.StartAmount = 50000
Config.PropItem = "prop_mil_crate_01"
Config.Zone = true --If zone is true then you will get a red zone around the location. If false you get a blip on the map (exact location)


Config.OpenItem = 'lockpick'

Config.InteractionButton = 38 --E

Config.Items = {
    {
        name = "pistol_barrel",
        limit = 3,
        minReward = 0,
        maxReward = 2
    },
    {
        name = "pistol_magazine",
        limit = 5,
        minReward = 1,
        maxReward = 3
    },
    {
        name = "pistol_grip",
        limit = 3,
        minReward = 0,
        maxReward = 2
    },
    {
        name = "smg_magazine",
        limit = 5,
        minReward = 0,
        maxReward = 2
    },
    {
        name = "smg_barrel",
        limit = 3,
        minReward = 0,
        maxReward = 2
    }
}
