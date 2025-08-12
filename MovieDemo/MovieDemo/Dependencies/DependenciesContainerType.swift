//
//  DependenciesContainerType.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//
protocol DependenciesContainerType {
    var networking: NetworkingType { get }
}
class DependenciesContainer: DependenciesContainerType {
    var networking: NetworkingType = Networking()
}
