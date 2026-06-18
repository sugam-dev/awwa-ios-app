import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        context.coordinator.webView = webView
        
        // Configure native pull-to-refresh mechanism
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.handleRefresh), for: .valueChanged)
        webView.scrollView.refreshControl = refreshControl
        
        // Initialize the initial web request
        let request = URLRequest(url: url)
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // View updates handled via Coordinator delegate callbacks; no direct UI updates required here.
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        // Maintain a weak reference to prevent retain cycles and memory leaks
        weak var webView: WKWebView?
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        @objc func handleRefresh(_ sender: UIRefreshControl) {
            webView?.reload()
        }
        
        // Intercept navigation to route external links to the system browser
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url, navigationAction.navigationType == .linkActivated {
                if let host = url.host, !host.contains("awwa.org.in") {
                    UIApplication.shared.open(url)
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
        
        // Manage loading state for UI feedback
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            webView.scrollView.refreshControl?.endRefreshing()
        }
        
        // Ensure UI recovers gracefully and refresh control dismisses on failure
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            webView.scrollView.refreshControl?.endRefreshing()
            // Future enhancement: Log error or display user-facing alert here
        }
    }
}

struct TabContentView: View {
    let url: String
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            WebView(url: URL(string: url)!, isLoading: $isLoading)
            
            // Overlay to indicate network activity during initial load or refresh
            if isLoading {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading...")
                        .font(.caption)
                        .padding(.top, 8)
                }
                .padding(25)
                .background(.regularMaterial)
                .cornerRadius(12)
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            TabContentView(url: "https://awwa.org.in")
                .tabItem {
                    Image("tab_home")
                }
            
            TabContentView(url: "https://awwa.org.in/Donation")
                .tabItem {
                    Image("tab_donation")
                }
            
            TabContentView(url: "https://awwa.org.in/Entrepreneur")
                .tabItem {
                    Image("tab_entrepreneur")
                }
                
            TabContentView(url: "https://awwa.org.in/Entrepreneur/Login")
                .tabItem {
                    Image("tab_profile")
                }
        }
    }
}

#Preview {
    ContentView()
}
