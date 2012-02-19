return {
    version = "1.1",
    luaversion = "5.1",
    orientation = "orthogonal",
    width = 5,
    height = 5,
    tilewidth = 16,
    tileheight = 16,
    properties = {
        ["mapCustomProp1"] = "value1",
        ["mapCustomProp2"] = "value2"
    },
    tilesets = {
        {
            name = "tileset-platformer",
            firstgid = 1,
            tilewidth = 16,
            tileheight = 16,
            spacing = 0,
            margin = 0,
            image = "platformtiles.png",
            imagewidth = 320,
            imageheight = 200,
            tiles = {
                {
                    id = 16,
                    properties = {
                        ["tileCustomProp1"] = "value1"
                    }
                },
                {
                    id = 50,
                    properties = {
                        ["tileCustomProp2"] = "value2"
                    }
                }
            }
        },
        {
            name = "platformtiles-02",
            firstgid = 241,
            tilewidth = 16,
            tileheight = 16,
            spacing = 0,
            margin = 0,
            image = "platformtiles-02.png",
            imagewidth = 320,
            imageheight = 200,
            tiles = {}
        }
    },
    layers = {
        {
            type = "tilelayer",
            name = "Back",
            x = 0,
            y = 0,
            width = 5,
            height = 5,
            visible = true,
            opacity = 0.73,
            properties = {},
            encoding = "lua",
            data = {
                0, 0, 69, 105, 105,
                0, 69, 105, 112, 112,
                69, 112, 105, 70, 0,
                92, 20, 91, 92, 0,
                92, 20, 21, 0, 0
            }
        },
        {
            type = "tilelayer",
            name = "Mountains",
            x = 0,
            y = 0,
            width = 5,
            height = 5,
            visible = true,
            opacity = 1,
            properties = {},
            encoding = "lua",
            data = {
                3, 4, 0, 0, 0,
                23, 24, 0, 0, 106,
                0, 0, 0, 0, 83,
                0, 108, 109, 110, 103,
                27, 27, 32, 33, 34
            }
        },
        {
            type = "tilelayer",
            name = "Objects",
            x = 0,
            y = 0,
            width = 5,
            height = 5,
            visible = true,
            opacity = 1,
            properties = {},
            encoding = "lua",
            data = {
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
                0, 86, 0, 0, 86,
                0, 0, 0, 0, 0
            }
        },
        {
            type = "tilelayer",
            name = "Ground",
            x = 0,
            y = 0,
            width = 5,
            height = 5,
            visible = true,
            opacity = 1,
            properties = {
                ["layerProp1"] = "value1",
                ["layerProp2"] = "value2"
            },
            encoding = "lua",
            data = {
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
                0, 26, 3, 3, 3
            }
        },
        {
            type = "tilelayer",
            name = "Mountains",
            x = 0,
            y = 0,
            width = 5,
            height = 5,
            visible = true,
            opacity = 1,
            properties = {},
            encoding = "lua",
            data = {
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0
            }
        },
        {
            type = "objectgroup",
            name = "ObjectGroup01",
            visible = false,
            opacity = 1,
            properties = {
                ["objGroupProps1"] = "value1",
                ["objGroupProps2"] = "value2"
            },
            objects = {
                {
                    name = "dumy02",
                    type = "customDummy02",
                    x = 16,
                    y = 96,
                    width = 16,
                    height = 16,
                    properties = {
                        ["dummy02Prop"] = "value2"
                    }
                },
                {
                    name = "dummy01",
                    type = "customType1",
                    x = 96,
                    y = 96,
                    width = 16,
                    height = 16,
                    properties = {
                        ["dummy01Prop"] = "value01"
                    }
                },
                {
                    name = "",
                    type = "",
                    x = 96,
                    y = 16,
                    width = 0,
                    height = 0,
                    gid = 55,
                    properties = {}
                },
                {
                    name = "",
                    type = "",
                    x = 128,
                    y = 16,
                    width = 0,
                    height = 0,
                    gid = 55,
                    properties = {}
                },
                {
                    name = "",
                    type = "",
                    x = 96,
                    y = 16,
                    width = 0,
                    height = 0,
                    gid = 57,
                    properties = {}
                },
                {
                    name = "",
                    type = "",
                    x = 160,
                    y = 16,
                    width = 0,
                    height = 0,
                    gid = 57,
                    properties = {}
                },
                {
                    name = "",
                    type = "",
                    x = 160,
                    y = 64,
                    width = 0,
                    height = 0,
                    gid = 56,
                    properties = {}
                },
                {
                    name = "",
                    type = "",
                    x = 160,
                    y = 96,
                    width = 0,
                    height = 0,
                    gid = 55,
                    properties = {}
                },
                {
                    name = "special one",
                    type = "special",
                    x = 0,
                    y = 16,
                    width = 0,
                    height = 0,
                    gid = 55,
                    properties = {
                        ["customProp"] = "at 0;0"
                    }
                }
            }
        },
        {
            type = "tilelayer",
            name = "FromTileset02",
            x = 0,
            y = 0,
            width = 5,
            height = 5,
            visible = true,
            opacity = 1,
            properties = {},
            encoding = "lua",
            data = {
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0
            }
        },
        {
            type = "objectgroup",
            name = "ObjectGroup02",
            visible = false,
            opacity = 1,
            properties = {},
            objects = {
                {
                    name = "ObjGroup02Item01",
                    type = "aType",
                    x = 0,
                    y = 0,
                    width = 16,
                    height = 16,
                    properties = {}
                },
                {
                    name = "ObjGroup02Item02",
                    type = "aType02",
                    x = 128,
                    y = 128,
                    width = 16,
                    height = 16,
                    properties = {}
                }
            }
        }
    }
}
