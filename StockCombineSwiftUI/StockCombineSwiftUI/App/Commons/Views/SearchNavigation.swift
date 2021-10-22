//
//  SearchNavigation.swift
//  StockCombineSwiftUI
//
//  Created by Marlon David Ruiz Arroyave on 18/10/21.
//

import SwiftUI

struct SearchNavigation<Content: View>: UIViewControllerRepresentable {

    @Binding var text: String
    var search: () -> Void
    var cancel: () -> Void
    var content: () -> Content

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: context.coordinator.rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        context.coordinator.searchController.searchBar.delegate = context.coordinator
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        context.coordinator.update(content: content())
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(content: content(), searchText: $text, searchAction: search, cancelAction: cancel)
    }

}

extension SearchNavigation {

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String
        let rootViewController: UIHostingController<Content>
        let searchController = UISearchController(searchResultsController: nil)
        var search: () -> Void
        var cancel: () -> Void

        init(content: Content,
             searchText: Binding<String>,
             searchAction: @escaping () -> Void,
             cancelAction: @escaping () -> Void) {
            rootViewController = UIHostingController(rootView: content)
            searchController.searchBar.autocapitalizationType = .none
            searchController.searchBar.tintColor = .label
            searchController.obscuresBackgroundDuringPresentation = false
            rootViewController.navigationItem.searchController = searchController

            _text = searchText
            search = searchAction
            cancel = cancelAction
        }

        func update(content: Content) {
            rootViewController.rootView = content
            rootViewController.view.setNeedsDisplay()
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            search()
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            cancel()
        }

    }

}
