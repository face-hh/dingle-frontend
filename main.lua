local query = get("query")
local cards = get("card", true);

local links = get("link", true)
local descriptions = get("desc", true)
local domains = get("domain", true)

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
        local link = links[k];
        local desc = descriptions[k];
        local domain = domains[k];
        
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