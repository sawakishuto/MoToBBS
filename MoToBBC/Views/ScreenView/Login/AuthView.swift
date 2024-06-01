import SwiftUI
import FirebaseAuth
import CoreData
// swiftlint:disable line_length
struct AuthView: View {
    @FetchRequest(
        entity: LoginInfo.entity(),
        sortDescriptors: [NSSortDescriptor(key: "haveAccount", ascending: false)],
        animation: .default
    ) var loginInfo: FetchedResults<LoginInfo>
    @State var logingo = true
    @State private var allview: Bool = false

    var body: some View {
        if !allview {
            if logingo {
                SignInView(logingo: $logingo, allview: $allview)
            }
            else {
                SignUpView(logingo: $logingo, allview: $allview)
            }
        }
        else if allview {
            HomeView()
        }
        
    }
}

struct Loginview_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}

