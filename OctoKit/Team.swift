//
//  Team.swift
//  OctoKit
//
//  Created by Jeroen Wesbeek on 04/12/2024.
//

import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: model

open class Team: Codable {
    open internal(set)  var id: Int
    open var nodeID: String
    open var name: String
    open var slug: String
    open var description: String?
    open var privacy: Privacy?
    open var notificationSetting: NotificationSetting?
    open var url: String?
    open var htmlURL: String?
    open var membersURL: String?
    open var repositoriesURL: String?

    public init(id: Int = -1,
                nodeID: String,
                name: String,
                slug: String,
                description: String,
                privacy: Privacy? = nil,
                notificationSetting: NotificationSetting? = nil,
                url: String? = nil,
                htmlURL: String? = nil,
                membersURL: String? = nil,
                repositoriesURL: String? = nil) {
        self.id = id
        self.nodeID = nodeID
        self.name = name
        self.slug = slug
        self.description = description
        self.privacy = privacy
        self.notificationSetting = notificationSetting
        self.url = url
        self.htmlURL = htmlURL
        self.membersURL = membersURL
        self.repositoriesURL = repositoriesURL
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, description, privacy, url
        case nodeID = "node_id"
        case htmlURL = "html_url"
        case membersURL = "members_url"
        case repositoriesURL = "repositories_url"
    }
}

public extension Team {
    /// The level of privacy of a team.
    enum Privacy: String, Codable {
        /// Only visible to organization owners and members of this team.
        case secret
        /// Visible to all members of this organization.
        case closed
    }
}

public extension Team {
    enum Permission: String, Codable {
        case pull, push, triage, maintain, admin
    }
}

public extension Team {
    enum NotificationSetting: String, Codable {
        case enabled = "notifications_enabled"
        case disabled = "notifications_disabled"
    }
}
