local HttpService = game:GetService("HttpService")

type APIClassMember = {
	MemberType: string,
	Name: string,
	ValueType: {
		Category: string,
		Name: string,
	}?,
}

type APIClass = {
	Members: { APIClassMember },
	Name: string,
	Superclass: string?,
}

type APIDump = {
	Classes: { APIClass },
}

type MappedAPIDump = {
	Classes: { [string]: APIClass },
}

local apiDump: APIDump = HttpService:JSONDecode(
	HttpService:GetAsync(
		"https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/refs/heads/roblox/Mini-API-Dump.json"
	)
)

local mappedApiDump: MappedAPIDump = {
	Classes = {},
}

for _, class in apiDump.Classes do
	mappedApiDump.Classes[class.Name] = class
end

return mappedApiDump
