//
//  RepositoryRow.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 06.10.21.
//

import SwiftUI
import OctoKit

struct RepositoryRow: View {
    var repository: Repository

    var body: some View {
        VStack(alignment: .leading) {
            Text(repository.fullName ?? repository.name ?? String(repository.id))
                .font(.headline)
            if let description = repository.repositoryDescription {
                Text(description)
                    .font(.subheadline)
            }
        }
    }
}

//struct RepositoryRow_Previews: PreviewProvider {
//    static var previews: some View {
//        RepositoryRow(repository: Repository())
//    }
//}
