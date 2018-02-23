-- create our global container object

local shippingCo = {
    rocketStacks = 10,
    objectiveItems = {
        ["ores"] = { "coal", "stone", "iron", "copper" }
    }    
}

-- generate an order
local function generate_order(number_of_items)    

    -- hardcoded for now, we will try and randomly generate these later.
    local item1 = { 
        itemCategory = "ores",
        name = "coal",
        quantityOfStacks = 4,
        maxStack = 50,
        quantityLaunched = 5
    }

    local item2 = { 
        itemCategory = "ores",
        name = "stone",
        quantityOfStacks = 5,
        maxStack = 50,
        quantityLaunched = 8
    }

    local order = {item1, item2}         

    return order
end

local function gui_init(player)

    if player.gui.top["shippingCoOrderButton"] then
        player.gui.top["shippingCoOrderButton"].destroy()
    end

    player.gui.top.add{        
        type = "button",
        name = "shippingCoOrderButton",
        caption = {"Order"}
    }

end

local function gui_open_frame(player)
    local frame = player.gui.left["shipping-co-order-frame"]

    if frame then
        frame.destroy()            
    end
    
    frame = player.gui.left.add {
        type = "frame",
        caption = "Shipping Order Details",
        name = "shipping-co-order-frame",
        direction = "vertical"
    }

    if global.shippingCoOrder then
        for key, item in pairs(global.shippingCoOrder) do
            local quantity = item.maxStack * item.quantityOfStacks
            frame.add {
                type = "label",
                caption = string.format("%s launched : %s / %s", item.name, item.quantityLaunched, quantity)
            }
        end        
    end
end

script.on_event( defines.events.on_tick, function(event)        
    if not global.shippingCoOrder then global.shippingCoOrder = generate_order(1) end

    for i, player in pairs(game.connected_players) do
        if player.gui.top.shippingCoOrderButton == nill then 
            player.gui.top.add{ type = "button", name="shippingCoOrderButton", caption = "Shipping Order" }
        end        
    end    
end)

script.on_event(defines.events.on_rocket_launched, function(event)
    -- just to make sure we don't accidently finish the game!
    remote.call("silo_script","set_show_launched_without_satellite", false)
    remote.call("silo_script","set_finish_on_launch", false)

    local testString = "Hello Rocket Launch!"        
    
    for _, player in pairs(game.players) do      
      player.print(testString)
      player.print(shippingCo.get_number())
    end
  end)

script.on_event( defines.events.on_gui_click, function(event) 

    local element = event.element
    local player = game.players[event.player_index]

    if element.name == "shippingCoOrderButton" then

        local frame = player.gui.left["shipping-co-order-frame"]

        if frame then
            frame.destroy()
        else
            gui_open_frame(player)
        end
        
    end

end )