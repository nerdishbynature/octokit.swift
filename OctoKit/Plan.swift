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
  
  public init(
      name: String? = nil,
      space: Int? = nil,
      numberOfCollaborators: Int? = nil,
      numberOfPrivateRepos: Int? = nil
  ) {
      self.name = name
      self.space = space
      self.numberOfCollaborators = numberOfCollaborators
      self.numberOfPrivateRepos = numberOfPrivateRepos
  }

    enum CodingKeys: String, CodingKey {
        case name
        case space
        case numberOfCollaborators = "collaborators"
        case numberOfPrivateRepos = "private_repos"
    }
}
