{
  "$GMRoom":"v1",
  "%Name":"rBoardTemplate",
  "creationCodeFile":"${project_dir}/rooms/rBoardSMW/RoomCreationCode.gml",
  "inheritCode":false,
  "inheritCreationOrder":false,
  "inheritLayers":false,
  "instanceCreationOrder":[
    {"name":"inst_1D5460D2_1","path":"rooms/rBoardTemplate/rBoardTemplate.yy",},
  ],
  "isDnd":false,
  "layers":[
    {"$GMRAssetLayer":"","%Name":"Assets","assets":[],"depth":0,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"name":"Assets","properties":[],"resourceType":"GMRAssetLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
    {"$GMRInstanceLayer":"","%Name":"Managers","depth":100,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[
        {"$GMRInstance":"v1","%Name":"inst_1D5460D2_1","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"name":"inst_1D5460D2_1","objectId":{"name":"objBoard","path":"objects/objBoard/objBoard.yy",},"properties":[
            {"$GMOverriddenProperty":"v1","%Name":"","name":"","objectId":{"name":"objBoard","path":"objects/objBoard/objBoard.yy",},"propertyId":null,"resourceType":"GMOverriddenProperty","resourceVersion":"2.0","value":"pthBoardSMW_Begin",},
            {"$GMOverriddenProperty":"v1","%Name":"","name":"","objectId":{"name":"objBoard","path":"objects/objBoard/objBoard.yy",},"propertyId":null,"resourceType":"GMOverriddenProperty","resourceVersion":"2.0","value":"pthBoardSMW_A",},
          ],"resourceType":"GMRInstance","resourceVersion":"2.0","rotation":0.0,"scaleX":1.0,"scaleY":1.0,"x":0.0,"y":-32.0,},
      ],"layers":[],"name":"Managers","properties":[],"resourceType":"GMRInstanceLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
    {"$GMRInstanceLayer":"","%Name":"Actors","depth":200,"effectEnabled":true,"effectType":null,"gridX":16,"gridY":16,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[],"layers":[],"name":"Actors","properties":[],"resourceType":"GMRInstanceLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
    {"$GMRLayer":"","%Name":"Board","depth":300,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[
        {"$GMRLayer":"","%Name":"Sprites","depth":400,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[
            {"$GMRAssetLayer":"","%Name":"Misc","assets":[],"depth":500,"effectEnabled":true,"effectType":null,"gridX":16,"gridY":16,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"name":"Misc","properties":[],"resourceType":"GMRAssetLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
          ],"name":"Sprites","properties":[],"resourceType":"GMRLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
        {"$GMRLayer":"","%Name":"Instances","depth":600,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[
            {"$GMRInstanceLayer":"","%Name":"Path","depth":700,"effectEnabled":true,"effectType":null,"gridX":16,"gridY":16,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[],"layers":[],"name":"Path","properties":[],"resourceType":"GMRInstanceLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
            {"$GMRInstanceLayer":"","%Name":"Spaces","depth":800,"effectEnabled":true,"effectType":null,"gridX":16,"gridY":16,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[],"layers":[],"name":"Spaces","properties":[],"resourceType":"GMRInstanceLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
          ],"name":"Instances","properties":[],"resourceType":"GMRLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
        {"$GMRLayer":"","%Name":"Tiles","depth":900,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[
            {"$GMRTileLayer":"","%Name":"Direction","depth":1000,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"name":"Direction","properties":[],"resourceType":"GMRTileLayer","resourceVersion":"2.0","tiles":{"SerialiseHeight":95,"SerialiseWidth":100,"TileCompressedData":[
                  -94,0,-6,-2147483648,-94,0,-6,-2147483648,-94,0,-6,-2147483648,-94,0,-6,-2147483648,-4885,0,-15,-2147483648,
                  -3200,0,1,-2147483648,-99,0,-12,-2147483648,-88,0,-12,-2147483648,-88,0,-12,-2147483648,-88,0,-30,-2147483648,
                  -70,0,-30,-2147483648,-70,0,-48,-2147483648,-47,0,-305,-2147483648,
                ],"TileDataFormat":1,},"tilesetId":{"name":"tlsRoad","path":"tilesets/tlsRoad/tlsRoad.yy",},"userdefinedDepth":false,"visible":true,"x":0,"y":0,},
            {"$GMRTileLayer":"","%Name":"Road","depth":1100,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"name":"Road","properties":[],"resourceType":"GMRTileLayer","resourceVersion":"2.0","tiles":{"SerialiseHeight":95,"SerialiseWidth":100,"TileCompressedData":[
                  -89,0,-11,-2147483648,-89,0,-11,-2147483648,-89,0,-11,-2147483648,-95,0,-5,-2147483648,-95,0,-5,-2147483648,
                  -95,0,-5,-2147483648,-95,0,-5,-2147483648,-95,0,-5,-2147483648,-95,0,-5,-2147483648,-95,0,-5,-2147483648,
                  -95,0,-5,-2147483648,-95,0,-5,-2147483648,-95,0,-5,-2147483648,-95,0,-5,-2147483648,-95,0,-5,-2147483648,
                  -95,0,-5,-2147483648,-6998,0,-2,-2147483648,-92,0,-17,-2147483648,-83,0,-17,-2147483648,-82,0,-32,-2147483648,
                  -62,0,-38,-2147483648,-62,0,-55,-2147483648,-34,0,-326,-2147483648,
                ],"TileDataFormat":1,},"tilesetId":{"name":"tlsRoad","path":"tilesets/tlsRoad/tlsRoad.yy",},"userdefinedDepth":false,"visible":true,"x":0,"y":0,},
            {"$GMRTileLayer":"","%Name":"Decoration","depth":1200,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"name":"Decoration","properties":[],"resourceType":"GMRTileLayer","resourceVersion":"2.0","tiles":{"SerialiseHeight":95,"SerialiseWidth":100,"TileCompressedData":[
                  -8697,0,-3,-2147483648,-97,0,-3,-2147483648,-96,0,-4,-2147483648,-96,0,-4,-2147483648,-87,0,-13,-2147483648,
                  -79,0,-39,-2147483648,-61,0,-39,-2147483648,-49,0,-133,-2147483648,
                ],"TileDataFormat":1,},"tilesetId":null,"userdefinedDepth":false,"visible":true,"x":0,"y":0,},
            {"$GMRTileLayer":"","%Name":"Structure","depth":1300,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"name":"Structure","properties":[],"resourceType":"GMRTileLayer","resourceVersion":"2.0","tiles":{"SerialiseHeight":95,"SerialiseWidth":100,"TileCompressedData":[-97,0,-3,-2147483648,-9300,0,-6,-2147483648,-94,0,],"TileDataFormat":1,},"tilesetId":null,"userdefinedDepth":false,"visible":true,"x":0,"y":0,},
          ],"name":"Tiles","properties":[],"resourceType":"GMRLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
      ],"name":"Board","properties":[],"resourceType":"GMRLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
    {"$GMRBackgroundLayer":"","%Name":"Background","animationFPS":9.0,"animationSpeedType":0,"colour":4278190080,"depth":1400,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"hspeed":0.0,"htiled":true,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"name":"Background","properties":[],"resourceType":"GMRBackgroundLayer","resourceVersion":"2.0","spriteId":null,"stretch":false,"userdefinedAnimFPS":false,"userdefinedDepth":false,"visible":true,"vspeed":0.0,"vtiled":true,"x":0,"y":0,},
  ],
  "name":"rBoardTemplate",
  "parent":{
    "name":"Party",
    "path":"folders/Rooms/Party.yy",
  },
  "parentRoom":null,
  "physicsSettings":{
    "inheritPhysicsSettings":false,
    "PhysicsWorld":false,
    "PhysicsWorldGravityX":0.0,
    "PhysicsWorldGravityY":10.0,
    "PhysicsWorldPixToMetres":0.1,
  },
  "resourceType":"GMRoom",
  "resourceVersion":"2.0",
  "roomSettings":{
    "Height":1520,
    "inheritRoomSettings":false,
    "persistent":false,
    "Width":1600,
  },
  "sequenceId":null,
  "views":[
    {"hborder":32,"hport":608,"hspeed":-1,"hview":608,"inherit":false,"objectId":null,"vborder":32,"visible":true,"vspeed":-1,"wport":800,"wview":800,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
  ],
  "viewSettings":{
    "clearDisplayBuffer":true,
    "clearViewBackground":false,
    "enableViews":true,
    "inheritViewSettings":false,
  },
  "volume":1.0,
}