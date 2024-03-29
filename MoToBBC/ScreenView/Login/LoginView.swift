import SwiftUI
import FirebaseAuth
import CoreData
// swiftlint:disable line_length
struct LoginView: View {
    @State var logingo = true
    @State private var allview: Bool = false



    var body: some View {
        if !allview {
            if logingo {
                StartLoginView(logingo: $logingo, allview: $allview)
            }
            else {
                NewLoginView(logingo: $logingo, allview: $allview)
            }
        }
        else if allview {
            HomeView()
        }
    }
}

struct Loginview_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

