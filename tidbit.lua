-- tidbit by mark ijzerman
--
--
--   . . .    .  . .  . .. .   . . ..  .
--   .  .   ..  . . ..  . ....  .. ..  .
--     .   . ..   . .. .. . .    . ...  .

MusicUtil = require "musicutil"

-- engine.name = "PolyPerc" -- engine for trying stuff without JF

amtNotes = 5

notes = { {0,0,0,0,0},
          {0,0,0,0,0},
          {0,0,0,0,0},
          {0,0,0,0,0},
        }
        
noteAmps = { {0,0,0,0,0},
          {0,0,0,0,0},
          {0,0,0,0,0},
          {0,0,0,0,0},
        }
        
tune = 0.00 -- tune to pitch with this (offset)
-- spread = 0.00 -- yet to implement

-- PLUCKYLOGGER STUFF
  function wsyn_add_params()
  params:add_group("w/syn",12)
  params:add {
    type = "option",
    id = "wsyn_ar_mode",
    name = "AR mode",
    options = {"off", "on"},
    default = 2,
    action = function(val) 
      crow.send("ii.wsyn.ar_mode(".. (val-1) ..")")
    end
  }
  params:add {
    type = "control",
    id = "wsyn_vel",
    name = "Velocity",
    controlspec = controlspec.new(0, 5, "lin", 0, 2, "v"),
    action = function(val) 
      pset_wsyn_vel = val
    end
  }
  params:add {
    type = "control",
    id = "wsyn_curve",
    name = "Curve",
    controlspec = controlspec.new(-5, 5, "lin", 0, 0, "v"),
    action = function(val) 
      crow.send("ii.wsyn.curve(" .. val .. ")") 
      pset_wsyn_curve = val
    end
  }
  params:add {
    type = "control",
    id = "wsyn_ramp",
    name = "Ramp",
    controlspec = controlspec.new(-5, 5, "lin", 0, 0, "v"),
    action = function(val) 
      crow.send("ii.wsyn.ramp(" .. val .. ")") 
      pset_wsyn_ramp = val
    end
  }
  params:add {
    type = "control",
    id = "wsyn_fm_index",
    name = "FM index",
    controlspec = controlspec.new(0, 5, "lin", 0, 0, "v"),
    action = function(val) 
      crow.send("ii.wsyn.fm_index(" .. val .. ")") 
      pset_wsyn_fm_index = val
    end
  }
  params:add {
    type = "control",
    id = "wsyn_fm_env",
    name = "FM env",
    controlspec = controlspec.new(-5, 5, "lin", 0, 0, "v"),
    action = function(val) 
      crow.send("ii.wsyn.fm_env(" .. val .. ")") 
      pset_wsyn_fm_env = val
    end
  }
  params:add {
    type = "control",
    id = "wsyn_fm_ratio_num",
    name = "FM ratio numerator",
    controlspec = controlspec.new(1, 20, "lin", 1, 2),
    action = function(val) 
      crow.send("ii.wsyn.fm_ratio(" .. val .. "," .. params:get("wsyn_fm_ratio_den") .. ")") 
      pset_wsyn_fm_ratio_num = val
    end
  }
  params:add {
    type = "control",
    id = "wsyn_fm_ratio_den",
    name = "FM ratio denominator",
    controlspec = controlspec.new(1, 20, "lin", 1, 1),
    action = function(val) 
      crow.send("ii.wsyn.fm_ratio(" .. params:get("wsyn_fm_ratio_num") .. "," .. val .. ")") 
      pset_wsyn_fm_ratio_den = val
    end
  }
  params:add {
    type = "control",
    id = "wsyn_lpg_time",
    name = "LPG time",
    controlspec = controlspec.new(-5, 5, "lin", 0, 0, "v"),
    action = function(val) 
      crow.send("ii.wsyn.lpg_time(" .. val .. ")") 
      pset_wsyn_lpg_time = val
    end
  }
  params:add {
    type = "control",
    id = "wsyn_lpg_symmetry",
    name = "LPG symmetry",
    controlspec = controlspec.new(-5, 5, "lin", 0, 0, "v"),
    action = function(val) 
      crow.send("ii.wsyn.lpg_symmetry(" .. val .. ")") 
      pset_wsyn_lpg_symmetry = val
    end
  }
  params:add{
    type = "trigger",
    id = "wsyn_pluckylog",
    name = "Pluckylogger >>>",
    action = function()
      params:set("wsyn_curve", math.random(-40, 40)/10)
      params:set("wsyn_ramp", math.random(-5, 5)/10)
      params:set("wsyn_fm_index", math.random(-50, 50)/10)
      params:set("wsyn_fm_env", math.random(-50, 40)/10)
      params:set("wsyn_fm_ratio_num", math.random(1, 4))
      params:set("wsyn_fm_ratio_den", math.random(1, 4))
      params:set("wsyn_lpg_time", math.random(-28, -5)/10)
      params:set("wsyn_lpg_symmetry", math.random(-50, -30)/10)
    end
  }
  params:add{
    type = "trigger",
    id = "wsyn_randomize",
    name = "Randomize all >>>",
    action = function()
      params:set("wsyn_curve", math.random(-50, 50)/10)
      params:set("wsyn_ramp", math.random(-50, 50)/10)
      params:set("wsyn_fm_index", math.random(0, 50)/10)
      params:set("wsyn_fm_env", math.random(-50, 50)/10)
      params:set("wsyn_fm_ratio_num", math.random(1, 20))
      params:set("wsyn_fm_ratio_den", math.random(1, 20))
      params:set("wsyn_lpg_time", math.random(-50, 50)/10)
      params:set("wsyn_lpg_symmetry", math.random(-50, 50)/10)
    end
  }
  params:add{
    type = "trigger",
    id = "wsyn_init",
    name = "Init",
    action = function()
      params:set("wsyn_curve", pset_wsyn_curve)
      params:set("wsyn_ramp", pset_wsyn_ramp)
      params:set("wsyn_fm_index", pset_wsyn_fm_index)
      params:set("wsyn_fm_env", pset_wsyn_fm_env)
      params:set("wsyn_fm_ratio_num", pset_wsyn_fm_ratio_num)
      params:set("wsyn_fm_ratio_den", pset_wsyn_fm_ratio_den)
      params:set("wsyn_lpg_time", pset_wsyn_lpg_time)
      params:set("wsyn_lpg_symmetry", pset_wsyn_lpg_symmetry)
      params:set("wsyn_vel", pset_wsyn_vel)
    end
  }
  params:hide("wsyn_init")
  
end
  
  
  -- END PLUCKYLOGGER

function init()
  crow.ii.jf.mode(1)
  crow.ii.wsyn.ar_mode(1)
  screen.level(15)
  screen.aa(0)
  screen.line_width(1)
  
  -- set the menu
  params:add_separator("TIDBIT")

  params:add{type="control",id='noteSet',"Noteset",controlspec=controlspec.new(1,#notes,'lin',1,1,'note set',0.08)} -- minval, maxval, warp, step, default, units, quantum, wrap
  params:set_action("noteSet", function(x)  noteSet = x end)
  noteSet= 1
  
  local voice_options = {"jf", "w/synth", "jf & wsynth", "midi"}
  params:add_option("voices","voices",voice_options, 1)
  params:add_number("midi_dev", "midi device", 1, 4, 1)
  params:hide("midi_dev")
  params:add_number("midi_ch", "midi channel", 1, 16, 1)
  params:hide("midi_ch")
  _menu.rebuild_params()
  params:set_action("voices", function(x)
		       selected_voice = x
		       if voice_options[x] == "midi" then
			  params:show("midi_dev")
			  params:show("midi_ch")
			  _menu.rebuild_params()
		       else
			  params:hide("midi_dev")
			  params:hide("midi_ch")
			  _menu.rebuild_params()
		       end
  end)
  selected_voice = 1

  params:add_number('voice_chance', 'voice_chance', 0, 100, 50)
  params:set_action("voice_chance", function(x)  voice_chance = x end)
  voice_chance = 50
  
  wsyn_add_params()
  
  params:add{type="control",id='division',"Division",controlspec=controlspec.new(1,90,'lin',1,32,'div',0.01)}
  params:set_action("division", function(x)  division = x end)
  division = 32
  
  
  params:add_control('tune', "tune", controlspec.BIPOLAR)
  params:set_action("tune", function(x)  tune = x end)
  
  params:add{type='binary',name="randomize notes",id='randomize',behavior='trigger',
    action=function(v)
      -- action for randomize!
     -- for each set of notes, set all notes and amps to random values **
      for i = 1,#notes do
        for j = 1,#notes[i] do
          params:set('note-'..i..'-'..j, math.random(0,50))
          params:set('note-'..i..'-'..j..'-amp', math.random())
        end
      end
    end
    }
  
  -- for each set of notes, make menu thing ** should SET it as well! **
  for i = 1,#notes do
    params:add_separator("NOTE SET " ..i)
    for j = 1,#notes[i] do
      -- params:add{type="control",id='note-'..i..'-'..j,'note-'..i..'-'..j,controlspec=controlspec.new(0,90,'lin',1,1.0,'pitch',0.01)} -- minval, maxval, warp, step, default, units, quantum, wrap
      
      params:add_number(
        'note-'..i..'-'..j, -- id
        'note-'..i..'-'..j, -- name
        0, -- min
        127, -- max
        60, -- default
        function(param) return MusicUtil.note_num_to_name(param:get(), true) end, -- formatter
        true -- wrap
        )
    
      params:set_action('note-'..i..'-'..j, function(x) notes[i][j] = x end)
      params:set('note-'..i..'-'..j, notes[i][j])

      params:add{type="control",id='note-'..i..'-'..j..'-amp','note-'..i..'-'..j..'-amp',controlspec=controlspec.new(0,1,'lin',0.001,1.0,'amp',0.01)} 
      params:set_action('note-'..i..'-'..j..'-amp', function(x) noteAmps[i][j] = x end)
      params:set('note-'..i..'-'..j..'-amp', noteAmps[i][j])
    end
  end
  
  
  
  
  -- read last preset
  params:read()
  
  
end


function redraw()
  screen.clear()

  screen.move(100,10)
  screen.text("TIDBIT")
  screen.move(5,10)
  screen.text("noteset: " ..noteSet)
  screen.move(5,20)
  screen.text("division: 1/" ..division)

  if noteForDrawing == nil and ampForDrawing == nil then
    for i=1,24 do
      local x = 1 + (i*5)
      local y = 36
      local r = 1
      screen.move(x+r,y)
      screen.circle(x, y, r)
      screen.stroke()
    end
  end
  
  
  if noteForDrawing ~= nil and ampForDrawing ~= nil  then
    --print(noteForDrawing.. " - " ..ampForDrawing)
    for i=1,24 do
      
      if i == (noteForDrawing % 24) then
        r = ampForDrawing*math.random(5,10)
      else
        r = 1
      end
      
      local x = 1 + (i*5)
      local y = 35 + math.random(1,5)
      --local r = 1
      screen.move(x+r,y)
      screen.circle(x, y, r)
      screen.stroke()
    end
  end

  screen.move(5,60)
  screen.text("K2 = start/stop")
  screen.update()
end

function key(n,z)
  if n==2 and z==1 and isPlaying ~= 1 then
    clock.transport.start()
    isPlaying = 1
  elseif n==2 and z==1 and isPlaying ~=0 then
    clock.transport.stop()
    isPlaying = 0
  end
end

function enc(n,d)
  if n == 2 then
    params:delta("noteSet",d)
    redraw()
  end
  
  if n == 3 then
    params:delta("division",d)
    redraw()
  end
end

  
function strum()
  while true do
    -- select which of the sets to play
    clock.sync(1/division)
    note = math.random(#notes[1])
    
    if selected_voice == 1 then
      crow.ii.jf.play_note((notes[noteSet][note]/12-1)+tune,math.random(10)*noteAmps[noteSet][note])
      
    elseif selected_voice == 2 then
      crow.ii.wsyn.play_note((notes[noteSet][note]/12-1)+tune,math.random(10)*noteAmps[noteSet][note])

    
    elseif selected_voice == 3 then
      local randomNumber = math.random(100)
      if randomNumber < voice_chance then
      crow.ii.jf.play_note((notes[noteSet][note]/12-1)+tune,math.random(10)*noteAmps[noteSet][note])
      else
        crow.ii.wsyn.play_note((notes[noteSet][note]/12-1)+tune,math.random(10)*noteAmps[noteSet][note])
      end
      
    elseif selected_voice == 4 then
      local midi_dev = midi.connect(params:get("midi_dev"))
      midi_note = math.floor(notes[noteSet][note]+tune*12)
      midi_amp = util.round(util.linlin(0, 10, 0, 127, math.random(10)*noteAmps[noteSet][note]))
      midi_dev:note_on(midi_note, midi_amp, params:get("midi_ch"))

    -- send current note and redraw
    noteForDrawing = notes[noteSet][note]
    ampForDrawing = noteAmps[noteSet][note]
    redraw()
    end
    
    
    
    -- for testing w/ polyperc
    -- engine.amp(math.random(1)*noteAmps[noteSet][note])
    -- engine.hz(midi_to_hz(48+(notes[noteSet][note]/12-1)+tune))
    
    -- for the screen
    -- do something cool with a slider with flickering bits on it
    
    
    redraw()
  end
end
    
function clock.transport.start()
  print("we begin")
  id = clock.run(strum)
end

function clock.transport.stop()
  print("we stop")
  noteForDrawing = nil
  ampForDrawing = nil
  redraw()
  clock.cancel(id)
end

function midi_to_hz(note) -- this is only here for the polyperc engine test
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end
