import SwiftUI

struct VersionChangesUpdateModal: View {
    let dismissCallback: () -> Void
    
    var body: some View {
        VStack{
            HStack { Spacer() }
            Text("Updates in this Version!")
                .font(.largeTitle)
                .foregroundColor(.accentColor)
                .padding(.bottom)
            Text("We have added the ability to change the tone of the notifications reminding you to go to bed. One of them is slightly more assertive if you need that kind of push. The other one is a nod to a good buddy of mine that has helped me QA the app.")
                .foregroundColor(.accentColor)
                .padding(.bottom)
            Spacer()
            Button("Good to know", action: dismissCallback)
                .buttonStyle(.bordered)
                .padding(.bottom)
        }
        .padding(.horizontal)
        .appBackground()
    }
    
}


struct UIChangeMoveToBasketButton_Previews: PreviewProvider {
    static var previews: some View {
        VersionChangesUpdateModal {}
    }
}
