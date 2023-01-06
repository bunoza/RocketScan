// Urheberrechtshinweis: Diese Software ist urheberrechtlich geschützt. Das Urheberrecht liegt bei
// Research Industrial Systems Engineering (RISE) Forschungs-, Entwicklungs- und Großprojektberatung GmbH,
// soweit nicht im Folgenden näher gekennzeichnet.

import SwiftUI

struct InfoView: View {
    @State private var animate: Bool = false
    private let animation: Animation = Animation.easeInOut(duration: 3.0)

    var body: some View {
        List {
            Section {} footer: {
                HStack {
                    Spacer()
                    ZStack {
                        Image("rocket")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200, alignment: .center)
                            .onTapGesture {
                                withAnimation(animation) {
                                    animate.toggle()
                                }
                            }
                            .offset(y: animate ? -1000 : 0)
                    Image("rocket")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200, alignment: .center)
                            .offset(y: animate ? 0 : 1000)
                    }
                    Spacer()
                }
            }
            Section {} footer: {
                Text("RocketScanner is an iOS mobile app developed as project assignment for OKPP at FERIT 2022/2023.\n\n \"Tim Raketa\" consists of 8 members:\n \t\u{2022} Domagoj Bunoza \n \t\u{2022} Ivan Lukac\n \t\u{2022} Ivan Šebetić\n \t\u{2022} Filip Pitlović\n \t\u{2022} Matko Mihalj\n \t\u{2022} Filip Kupanovac\n \t\u{2022} Domagoj Dragić\n \t\u{2022} Luka Lovretić"
                )
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
