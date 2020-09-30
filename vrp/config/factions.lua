factions = {
  ["Police"] = {
    _coords = {
      {445.55010986328,-984.70275878906,30.689599990845},
      {-445.90008544922,6013.9404296875,31.716373443604}
    },
    _offices = {
      {448.12948608398,-973.21948242188,30.689599990845},
      {-441.23086547852,6004.388671875,31.716438293457}
    },
    _type = "Departament",
    _chat = " <span style='color:rgb(0, 157, 236)'>Police</span> ",
    _blip_id = 60,
    _blip_color = 3,
    _leader = "Leader Police",
    _ranks = {
      "Agent",
      "Rutier Agent",
      "Frontier Agent",
      "Swat Agent",
    },
    _salary = {
      ["Leader Police"] = 7000 + math.random(500,1000),
      ["Swat Agent"] = 5000 + math.random(500,1000),
      ["Frontier Agent"] = 4200 + math.random(500,1000),
      ["Rutier Agent"] = 4000 + math.random(500,1000),
      ["Agent"] = 3000 + math.random(500,1000),
    }
  },
  ["EMS"] = {
    _coords = {
      {342.86727905273,-1398.0349121094,32.509269714355},
      {-242.41955566406,6325.9760742188,32.426189422607},
      {1839.5577392578,3672.3471679688,34.276710510254}
    },
    _type = "Departament",
    _chat = " <span style='color:rgb(255, 200, 200)'>EMS</span> ",
    _blip_id = 61,
    _blip_color = 3,
    _leader = "Director",
    _ranks = {
      "Paramedic",
      "Specialist",
      "Surgeon",
    },
    _salary = {
      ["Director"] = 10000  + math.random(100,650),
      ["Surgeon"] = 7200  + math.random(100,650),
      ["Specialist"] = 7000  + math.random(100,650),
      ["Paramedic"] = 6500  + math.random(100,650),
    }
  }
}

return factions