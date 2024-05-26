local query = get("query")
local cards = get("card", true);

local links = {
    ["1"] = get("result1link"),
    ["2"] = get("result2link"),
    ["3"] = get("result3link"),
    ["4"] = get("result4link"),
    ["5"] = get("result5link"),
    ["6"] = get("result6link"),
    ["7"] = get("result7link"),
    ["8"] = get("result8link"),
    ["9"] = get("result9link"),
    ["10"] = get("result10link")
}

local descriptions = {
    ["1"] = get("result1desc"),
    ["2"] = get("result2desc"),
    ["3"] = get("result3desc"),
    ["4"] = get("result4desc"),
    ["5"] = get("result5desc"),
    ["6"] = get("result6desc"),
    ["7"] = get("result7desc"),
    ["8"] = get("result8desc"),
    ["9"] = get("result9desc"),
    ["10"] = get("result10desc")
}

local domains = {
    ["1"] = get("result1domain"),
    ["2"] = get("result2domain"),
    ["3"] = get("result3domain"),
    ["4"] = get("result4domain"),
    ["5"] = get("result5domain"),
    ["6"] = get("result6domain"),
    ["7"] = get("result7domain"),
    ["8"] = get("result8domain"),
    ["9"] = get("result9domain"),
    ["10"] = get("result10domain")
}

local visible = false;

query.on_submit(function(content)
    if not visible then
        print("turning shit visible....")

        for k,v in pairs(cards) do
            v.set_opacity(1.0)
        end

        visible = true
    end

    local res = fetch({
		url = "http://search.buss.lol/search",
		method = "POST",
		headers = { ["Content-Type"] = "application/json" },
		body = '{ "query": "' .. content .. '" }',
	})

    for k, v in pairs(res) do
        local i = tostring(k);

        local link = links[i];
        local desc = descriptions[i];
        local domain = domains[i];
        
        local URL = percentage(v["rating"], -999, 2) .. "% | buss://" .. v["domain"];

        domain.set_content(URL)
        link.set_content(v["title"])
        link.set_href("buss://" .. v["domain"])
        desc.set_content(v["description"])
    end
end)

function percentage(value, min, max)
    if value < min then
        value = min
    elseif value > max then
        value = max
    end
    
    local percentage = ((value - min) / (max - min)) * 100
    
    if percentage < 0 then
        percentage = 0
    elseif percentage > 100 then
        percentage = 100
    end

    return string.format("%.2f", percentage)
end