// MARK: model

/// The plan of a GitHub user.
///
/// GitHub Apps with the `Plan` user permission can retrieve information about a user's GitHub plan.
/// The GitHub App must be authenticated as a user.
open class Plan: Codable {
    open var name: String?
    open var space: Int?
    open var numberOfCollaborators: Int?
    open var numberOfPrivateRepos: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case space
        case numberOfCollaborators = "collaborators"
        case numberOfPrivateRepos = "private_repos"
    }
}
