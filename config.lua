Cfg = {}

Cfg.ped = true                  
Cfg.pos = {x = -1985.80, y = -232.253, z = 28.611, h = 241.65} 

KCDD = {
    ['Heavy'] = {
        inform = {
            label = "Heavy 3xGövde,1xNamlu,1x Sarjör,1xKabza,2xYay ",    -- Menüde gözükecek olan isim
            value = "pistol",           -- Bir değer girin özel harf olmasın.
            CraftedItem = "WEAPON_HEAVYPISTOL",                -- Craftlayınca vericek item
            count = 1,                                          -- Craftlayınca kaç tane verilsin
            Craft = { -- Maksimum 5 eşya arttırabilirsiniz !
                [1] = {
                    reqitem = "gunbody",                              -- Craftlamak için gerekli item
                    count = 3,
                },
                [2] = {
                    reqitem = "gunbarrel",
                    count = 1,
                },
                [3] = {
                    reqitem = "gunmagazine",
                    count = 1,
                },
                [4] = {                                      -- Maksimum 5 !
                    reqitem = "gunkabza",
                    count = 1,
                },
                [5] = {                                      
                reqitem = "yay",
                count = 2,
                }
            }
        }
    },
    ['Glock'] = {
        inform = {
            label = "Glock 2xGövde,1xNamlu,1xSarjör,1xKabza,3xYay",    -- Menüde gözükecek olan isim
            value = "pistol",           -- Bir değer girin özel harf olmasın.
            CraftedItem = "WEAPON_COMBATPISTOL",                -- Craftlayınca vericek item
            count = 1,                                          -- Craftlayınca kaç tane verilsin
            Craft = { -- Maksimum 5 eşya arttırabilirsiniz !
                [1] = {
                    reqitem = "gunbody",                              -- Craftlamak için gerekli item
                    count = 2,
                },
                [2] = {
                    reqitem = "gunbarrel",
                    count = 1,
                },
                [3] = {
                    reqitem = "gunmagazine",
                    count = 1,
                },
                [4] = {                                      -- Maksimum 5 !
                    reqitem = "gunkabza",
                    count = 1,
                },
                [5] = {                                      
                reqitem = "yay",
                count = 3,
                }
            }
        }
    },
    ['Pistol Mermi'] = {
        inform = {
            label = "Pistol Mermi 1xKovan,1xAliminyum",    -- Menüde gözükecek olan isim
            value = "Mermi",           -- Bir değer girin özel harf olmasın.
            CraftedItem = "disc_ammo_pistol",                -- Craftlayınca vericek item
            count = 5,                                          -- Craftlayınca kaç tane verilsin
            Craft = { -- Maksimum 5 eşya arttırabilirsiniz !
                [1] = {
                    reqitem = "kovan",                              -- Craftlamak için gerekli item
                    count = 1,
                },
                [2] = {
                    reqitem = "aluminium",
                    count = 1,
                }
            }
        }
    },
    ['SMG Mermi'] = {
        inform = {
            label = "SMG Mermi 2xKovan,2xAliminyum",    -- Menüde gözükecek olan isim
            value = "Mermi",           -- Bir değer girin özel harf olmasın.
            CraftedItem = "disc_ammo_smg",                -- Craftlayınca vericek item
            count = 5,                                          -- Craftlayınca kaç tane verilsin
            Craft = { -- Maksimum 5 eşya arttırabilirsiniz !
                [1] = {
                    reqitem = "kovan",                              -- Craftlamak için gerekli item
                    count = 2,
                },
                [2] = {
                    reqitem = "aluminium",
                    count = 1,
                }
            }
        }
    },
    ['Rifle Mermi'] = {
        inform = {
            label = "Rifle Mermi 3xKovan,3xAliminyum",    -- Menüde gözükecek olan isim
            value = "Mermi",           -- Bir değer girin özel harf olmasın.
            CraftedItem = "disc_ammo_rifle",                -- Craftlayınca vericek item
            count = 5,                                          -- Craftlayınca kaç tane verilsin
            Craft = { -- Maksimum 5 eşya arttırabilirsiniz !
                [1] = {
                    reqitem = "kovan",                              -- Craftlamak için gerekli item
                    count = 3,
                },
                [2] = {
                    reqitem = "aluminium",
                    count = 3,
                }
            }
        }
    },
    ['Zırh'] = {
        inform = {
            label = "Zırh craftla",
            value = "armor",
            CraftedItem = "fullarmor",
            count = 5,
            Craft = {
                [1] = {
                    reqitem = "kevlar",
                    count = 2,
                }
            }
        }
    }
}

Cfg.WaitingTime = 180000  
Cfg.Locations = {
    craft = {
        process = {
            body = vector3(-1973.25, -220.380, 27.864),
            body2 = vector3(-1973.07, -222.721, 27.864),
            body3 = vector3(-1975.61, -220.966, 27.864),
            barrel = vector3(-1965.73, -224.398, 27.864),
            kabza = vector3(-1968.98, -223.101, 27.864),
            kabza2 = vector3(-1970.21, -224.940, 27.864),
            yay = vector3(-1977.07, -226.869, 27.864),
            yay2 = vector3(-1975.04, -224.209, 27.864),
            kovan = vector3(-1974.69, -231.431, 27.864),
            sarjor = vector3(-1969.83, -228.148, 27.549),
            kevlar = vector3(-1976.19, -223.477, 27.864),
            kevlar2 = vector3(-1977.52, -225.061, 27.864),
            kevlar3 = vector3(-1978.31, -226.401, 27.864)
        }
    }
}