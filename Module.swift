

import Foundation
var sharedUser = User(username: "", password: "")
struct User{

    var username: String
    var password: String
    var modules: [Module]?
    var whitelists: [Whitelist]?
}
struct Module{
    var unique_id: String
    var whitelists: [String]?
    var isActive: Bool
    var attempts: [attemptData]?
}

struct Whitelist{
    var name: String
    var plates: [String]?
}






