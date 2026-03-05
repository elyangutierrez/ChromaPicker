//
//  File.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/4/26.
//

import Foundation
import UIKit

extension UIDeviceOrientation {
    @MainActor
    func getDeviceOrientation() -> UIDeviceOrientation {
        var orientation = UIDevice.current.orientation
        // Get the interface orientation incase the UIDevice Orientation doesn't exist.
        let interfaceOrientation: UIInterfaceOrientation?
        if #available(iOS 15, *) {
            interfaceOrientation = UIApplication.shared.connectedScenes
                // Keep only the first `UIWindowScene`
                .first(where: { $0 is UIWindowScene })
                // Get its associated windows
                .flatMap({ $0 as? UIWindowScene })?.effectiveGeometry.interfaceOrientation
        } else {
            interfaceOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        }
        guard interfaceOrientation != nil else {
            return orientation
        }

        // Initially the orientation is unknown so we need to check based on the application window orientation.
        if !orientation.isValidInterfaceOrientation {
            switch interfaceOrientation {
            case .portrait:
                orientation = .portrait
                break
            case .landscapeRight:
                orientation = .landscapeLeft
                break
            case .landscapeLeft:
                orientation = .landscapeRight
                break
            case .portraitUpsideDown:
                orientation = .portraitUpsideDown
                break
            default:
                orientation = .unknown
                break
            }
        }

        return orientation
    }
}
