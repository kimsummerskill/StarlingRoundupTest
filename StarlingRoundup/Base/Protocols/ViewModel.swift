//
//  ViewModel.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//

protocol ViewModel {
    associatedtype coordinatorType

    // For my test example I am forcing the developer with ! to always have a coordinator when they adopt the ViewModel protocol.
    // in a real world scenario you could go either way, you dont always need a coordinator to be tied to a view model...
    var coordinator: coordinatorType! { get set }
}
