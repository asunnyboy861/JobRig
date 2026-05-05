import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = {
        if let envTab = ProcessInfo.processInfo.environment["JOBRIG_INITIAL_TAB"],
           let tab = Int(envTab), (0...3).contains(tab) {
            return tab
        }
        return 0
    }()

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                JobsListView()
            }
            .tabItem {
                Label("Jobs", systemImage: "clipboard.fill")
            }
            .tag(0)

            NavigationStack {
                ClientsListView()
            }
            .tabItem {
                Label("Clients", systemImage: "person.2.fill")
            }
            .tag(1)

            NavigationStack {
                QuickQuoteView()
            }
            .tabItem {
                Label("New", systemImage: "plus.circle.fill")
            }
            .tag(2)

            NavigationStack {
                MoreView()
            }
            .tabItem {
                Label("More", systemImage: "ellipsis.circle.fill")
            }
            .tag(3)
        }
    }
}
