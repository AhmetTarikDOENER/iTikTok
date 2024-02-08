//
//  iTikTokTests.swift
//  iTikTokTests
//
//  Created by Ahmet Tarik DÖNER on 8.02.2024.
//

import XCTest
@testable import iTikTok

final class iTikTokTests: XCTestCase {

    func test_post_child_path() {
        let id = UUID().uuidString
        let user = User(
            username: "tarik",
            profilePictureURL: nil,
            identifier: "12345"
        )
        let post = PostModel(identifier: id, user: user)
        XCTAssertEqual(post.videoChildPath, "videos/tarik/")
    }

}
