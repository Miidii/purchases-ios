//
//  PresentIfNeededTests.swift
//  
//
//  Created by Nacho Soto on 7/31/23.
//

import Nimble
import RevenueCat
@testable import RevenueCatUI
import SwiftUI
import XCTest

#if !os(macOS)

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@MainActor
class PresentIfNeededTests: TestCase {

    func testPresentWithPurchaseHandler() throws {
        var customerInfo: CustomerInfo?

        Text("")
            .presentPaywallIfNeeded(offering: Self.offering,
                                    introEligibility: .producing(eligibility: .eligible),
                                    purchaseHandler: Self.purchaseHandler) { _ in
                return true
            } purchaseCompleted: {
                customerInfo = $0
            } customerInfoFetcher: {
                return TestData.customerInfo
            }
            .addToHierarchy()

        Task {
            _ = try await Self.purchaseHandler.purchase(package: Self.package)
        }

        expect(customerInfo).toEventually(be(TestData.customerInfo))
    }

    private static let purchaseHandler: PurchaseHandler = .mock()
    private static let offering = TestData.offeringWithNoIntroOffer
    private static let package = TestData.annualPackage

}

#endif