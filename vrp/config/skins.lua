-------------- POLICE
local cop1_male = { model = "S_M_Y_Chef_01" }
local cop2_male = { model = "s_m_m_prisguard_01" } 
local cop3_male = { model = "S_M_M_Marine_01" }
local cop4_male = { model = "s_m_m_ciasec_01" }
local cop5_male = { model = "s_m_m_fibsec_01" }
local frontier_male = { model = "S_M_Y_Valet_01" } 
local sias_male = { model = "s_m_y_swat_01" }
-------------- EMS
local medic_male = { model = "s_m_m_paramedic_01" }
local lider_male = { model = "S_M_M_HighSec_01" }

local skins = {
  ["Police"] = {
    _coords = {
      {1842.5231933594,3691.34765625,34.258209228516},
      {454.6669921875,-992.06555175781,30.689599990845},
    },
    ["Agent"] = cop1_male,
    ["Rutier Agent"] = cop5_male,
    ["Frontier Agent"] = frontier_male,
    ["SWAT Agent"] = sias_male,
  },
  ["EMS"] = {
    _coords = {
      {-269.76135253906,6319.7807617188,32.426078796387},
      {1825.8221435547,3675.0361328125,34.274864196777},
      {242.85119628906,-1376.6302490234,39.534374237061}
    },
    ["Paramedic"] = medic_male,
    ["Specialist"] = medic_male,
    ["Surgeon"] = medic_male,
    ["Director"] = lider_male,
  }
}

return skins
