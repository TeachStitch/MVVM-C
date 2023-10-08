//
//  Typealiases.swift
//

import Foundation

typealias VoidClosure = () -> Void
typealias GenericClosure<T> = (T) -> Void
typealias ResultClosure<Success, Failure> = (Result<Success, Failure>) -> Void where Failure: Error
