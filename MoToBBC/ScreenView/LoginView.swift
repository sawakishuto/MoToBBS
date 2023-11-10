import SwiftUI
import FirebaseAuth
import CoreData
// swiftlint:disable line_length
struct LoginView: View {
    @ObservedObject private var viewModel = LoginViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: LoginInfo.entity(),
        sortDescriptors: [NSSortDescriptor(key: "pass", ascending: false)],
        animation: .default
    ) var fetchedInfo: FetchedResults<LoginInfo>
    @State private var checkerror: Bool = false
    @State var showsheet = false
    @State var showconfine = false
    @State public var usersname: String = ""
    @State public var bikename: String = ""
    @State public var usercomment: String = ""
    @State var logingo = true
    @State var eventid: String = ""
    @State var userid: String = ""
    @State public var mail: String = ""
    @State public var password: String = ""
    @State public var errorMessage: String = ""
    @State var profile = false
    @State var check = false
    @State  var checkms = false
    @State private var allview: Bool = false
    @State private var errorhandle: Bool = false
    @State var checkname = "checkmark.circle"
    @State private var mailname: String = " MoToBBS@gmail.com"
    @State private var passname: String = " 123456"
    @State private var male: Bool = false
    @State private var female: Bool = false
    @State private var andSoOn: Bool = false
    @State private var mailnames: String = "MoToBBS@email.com"
    @State private var passnames: String = "123456"
    @State private var authState:String = ""
    @State private var progresState:String = "新規登録"


    var body: some View {
            if allview == false {
                if logingo == true {
                    StartLoginView(logingo: $logingo, allview: $allview)
                }
                else if(logingo == false) {
                    NewLoginView(logingo: $logingo, allview: $allview)
                }
            }
            else if allview == true {
                HomeView()
            }
        }
    }

struct Loginview_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
                }
            }

