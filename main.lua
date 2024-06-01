local query = get("query")
local cards = get("card", true);

local links = get("link", true)
local descriptions = get("desc", true)
local domains = get("domain", true)

local visible = false;

query.on_submit(function(content)
    cards_thing()

    local res = fetch({
		url = "https://search.buss.lol/search?q=" .. content,
		method = "GET",
		headers = { ["Content-Type"] = "application/json" },
	})
    print(res)
    for k, v in pairs(res) do
        local link = links[k];
        local desc = descriptions[k];
        local domain = domains[k];
        
        local URL = string.format("%g",string.format("%.2f", v["score"])) .. "% | buss://" .. v["url"];

        domain.set_content(URL)
        link.set_content(v["title"])
        link.set_href("buss://" .. v["url"])
        desc.set_content(v["description"])
    end
end)

get("luck").on_click(function()
    cards_thing()

    local res = fetch({
		url = "https://search.buss.lol/random",
		method = "GET",
		headers = { ["Content-Type"] = "application/json" },
	})

    local link = links[1];
    local desc = descriptions[1];
    local domain = domains[1];
    
    local URL = "buss://" .. res["url"];
    
    domain.set_content(URL)
    link.set_content(res["title"])
    link.set_href(URL)

    if res["description"] then
        desc.set_content(res["description"])
    else
        desc.set_content("No description :|")
    end
end)

function cards_thing()
    if not visible then
        print("turning shit visible....")

        for k,v in pairs(cards) do
            v.set_opacity(1.0)
        end

        visible = true
    end
end
