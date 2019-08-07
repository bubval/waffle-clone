//
//  Scopes.swift
//  Waffle-Clone
//
//  Created by Lubo on 5.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

/// Scopes let you specify exactly what type of access you need. Scopes limit access for OAuth tokens. They do not grant any additional permission beyond that which the user already has.
///
/// - user: Update all user data
/// - userEmail: Access user email addresses (Read-only)
/// - userFollow: Follow and unfollow users
/// - publicRepo: Access public repositories
/// - repo: Full control of private repositories
/// - repoDeployment: Access deployment status
/// - repoStatus: Access commit status
/// - deleteRepo: Delete repositories
/// - notifications: Access notifications
/// - gist: Create gists
/// - readRepoHook: Read repository hooks
/// - writeRepoHook: Write repository hooks
/// - adminRepoHook: Full control of repository hooks
/// - adminOrgHook: Full control of organization hooks
/// - readOrg: Read org and team membership
/// - writeOrg: Read and write org and team membership
/// - adminOrg: Full control of orgs and teams
/// - readPublicKey: Read user public keys
/// - writePublicKey: Write user public keys
/// - adminPublicKey: Full control of user public keys
/// - readGPGKey: Full access to commit signature verification
/// - writeGPGKey: Write access to commit signature verification
/// - adminGPGKey: Read access to commit signature verification
enum Scopes : String, CaseIterable {
    case user = "user"
    case userEmail = "user:email"
    case userFollow = "user:follow"
    case publicRepo = "public_repo"
    case repo = "repo"
    case repoDeployment = "repo_deployment"
    case repoStatus = "repo:status"
    case deleteRepo = "delete_repo"
    case notifications = "notifications"
    case gist = "gist"
    case readRepoHook = "read:repo_hook"
    case writeRepoHook = "write:repo_hook"
    case adminRepoHook = "admin:repo_hook"
    case adminOrgHook = "admin:org_hook"
    case readOrg = "read:org"
    case writeOrg = "write:org"
    case adminOrg = "admin:org"
    case readPublicKey = "read:public_key"
    case writePublicKey = "write:public_key"
    case adminPublicKey = "admin:public_key"
    case readGPGKey = "read:gpg_key"
    case writeGPGKey = "write:gpg_key"
    case adminGPGKey = "admin:gpg_key"
}
