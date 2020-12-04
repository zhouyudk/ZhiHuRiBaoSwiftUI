//
//  NewsDetailView.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/23.
//

import SwiftUI
import WebKit

struct NewsDetailView: View {
    @ObservedObject private var viewModel = NewsDetailViewModel()
    @State private var remoteImage: UIImage? = nil
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @ObservedObject private var webHelper = WebViewHelper()
    var news: NewsModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomLeading) {
                    Image(uiImage: remoteImage ?? UIImage(named: "haitun")!)
                        .resizable()
                        .frame(width: UIScreen.screenWidth, height: 400)
                        .onAppear(perform: {
                            fetchRemoteImage(url: news.images.first!)
                        })
                    Text("点击这里返回").frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    HStack {
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
//                        RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 20, endRadius: 200)
//                                    AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
                    }
                    .frame(height: 200)

                    VStack(alignment: .leading) {
                        Text(news.title)
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 0))
                }
                .onTapGesture(count: 1, perform: {
                    self.presentationMode.wrappedValue.dismiss()
                })

                DetailTextView(text: viewModel.newsDetail.body, webViewHelper: webHelper)
                    .frame(width: UIScreen.screenWidth-30, height: webHelper.webHeight, alignment: .center)
                    .padding(.horizontal, 15)
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .onAppear(perform: {
            viewModel.fetchNewsDetail(id: news.id)
        })

    }

    func fetchRemoteImage(url: String){
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            if let d = data, let image = UIImage(data: d){
                self.remoteImage = image
            }
            else{
                print(error ?? "")
            }
        }.resume()
    }
}

struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailView(news: NewsModel())
    }
}

struct DetailTextView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    var text: String = ""
    var webViewHelper: WebViewHelper
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.navigationDelegate = webViewHelper
        uiView.scrollView.isScrollEnabled = false
        // 格式化Html
        let htmlString = String(format: """
                                <html> \n
                                <head> \n
                                <style type=\"text/css\"> \n
                                body {font-size:32px;}\n
                                </style> \n
                                </head> \n
                                <body>
                                <script type='text/javascript'>
                                window.onload = function(){\n
                                    let height = document.body.offsetHeight
                                    window.webkit.messageHandlers.imagLoaded.postMessage(height)
                                }
                                </script>%@
                                </body>
                                </html>
                                """, text)
        //在window.onload方法中调整图片宽高等
//        var $img = document.getElementsByTagName('img');\n
//        for(var p in  $img){\n
//        $img[p].style.width = '100%%';\n
//        $img[p].style.height ='auto'\n
//        let height = document.body.offsetHeight;\n
//        window.webkit.messageHandlers.imagLoaded.postMessage(height);\n
//        }\n
        uiView.loadHTMLString(htmlString, baseURL: nil)
    }
}

class WebViewHelper: UIView, WKNavigationDelegate, ObservableObject {
    @Published var webHeight: CGFloat = 500
//   web加载完成后获取高度
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //https://blog.csdn.net/MinggeQingchun/article/details/95087345 高度计算
        webView.evaluateJavaScript("document.body.scrollWidth") { [weak self ](result, error) in
            guard let self = self else { return }
            guard let width = result as? CGFloat else { return }
            let ratio =  webView.frame.width / width
            webView.evaluateJavaScript("document.body.scrollHeight") { [weak self ](result, error) in
                guard let self = self else { return }
                if let height = result as? CGFloat {
                    self.webHeight = height*ratio + 15
                    print("self.webHeight:", self.webHeight)
                }
            }
        }

    }
}


/*
var dd: String = "<div class=\"main-wrap content-wrap\">\n<div class=\"headline\">\n\n<div class=\"img-place-holder\"></div>\n\n\n\n</div>\n\n<div class=\"content-inner\">\n\n\n\n\n<div class=\"question\">\n<h2 class=\"question-title\">为什么到了冬天，有的女生手和脚老是冰冰的，而身体却是温暖的？</h2>\n\n<div class=\"answer\">\n\n<div class=\"meta\">\n<img class=\"avatar\" src=\"https://pic1.zhimg.com/v2-61abb2c397fe1e5d720422cee18fed6e_l.jpg?source=8673f162\">\n<span class=\"author\">初夏之菡，</span><span class=\"bio\">《戒糖-改变一生的科学饮食法》作者，悉尼大学营养学Mphil.</span>\n<a href=\"https://www.zhihu.com/question/311223084/answer/1543601083\" class=\"originUrl\" hidden>查看知乎原文</a>\n</div>\n\n<div class=\"content\">\n<p><strong>最大原因就是肌肉比例低 + 白色脂肪比例高。</strong></p>\r\n<p>女生跟男性最大的内分泌区别就是性激素，而性激素又进一步决定了男性更容易积累肌肉而不易积累皮下脂肪。女性则刚好相反，所以同等 BMI 的男性和女性，一定是女性体脂含量更高，也就意味着肌肉的比例更低。</p>\r\n<figure><img class=\"content-image\" src=\"https://pic1.zhimg.com/v2-70cc90cc8ca0f634a655e6ac03a25566_720w.jpg?source=8673f162\" alt=\"\"></figure><p>参考上图同等 BMI 男性和女性的模型变化，男性在体重增加的时候，通常肌肉增加的速度会比女性高很多。所以男性胖起来主要是胖肚子，四肢也会粗壮但并不是单纯积累脂肪。</p>\r\n<p>女性胖的过程是脂肪积累速度大大高于肌肉积累速度，所以女性的增胖会有非常明显「松弛」感，也有非常明显的「橘皮组织」，男性则少很多。</p>\r\n<p><strong>但是胖子不是更怕热吗？</strong></p>\r\n<p>那么有的人会问：不是说脂肪可以保暖，为啥女性皮下脂肪多还是冷？大家可以观察一下怕热的胖子，一般是那种肌肉和脂肪都发达的人——体重基数很大。</p>\r\n<p>而绝非那类肌肉少而脂肪超标的「隐性胖子」，尤其是那类四肢纤细（肚腩却不一定小）的女性，可以说是最怕冷的类型，没跑的。</p>\r\n<p><strong>因为肌肉是主要生热的部位 -- 线粒体是个「锅炉」</strong></p>\r\n<p>脂肪保暖不假，但是它的作用更像是棉被——如果你屋子没有给力的地暖，而只有一个小油汀（暖气片），那么再厚的棉被也无法让你暖起来，因为此时你取暖的上限在于你的小油汀的功率，而不是怕散热太快。（原谅南方人无法想象北方暖气，只能用地暖来打比方）</p>\r\n<p>所以肌肉少而脂肪多的「胖人」并不能解决手脚冰凉的问题，因为产热太少了。</p>\r\n<p>肌肉生热的原理很简单，是因为肌肉组织的细胞比脂肪组织的细胞产热能力强太多，其中的秘密就是线粒体的数量。如下图所示，细胞产热的最主要来源就是线粒体中那步氧化反应——简单来说就是供能物质在线粒体里缓慢地燃烧。</p>\r\n<p>燃烧是放热的，而且是放热是最多的。所以可以得到非常简单的结论：</p>\r\n<p>线粒体越多=放热越多。</p>\r\n<figure><img class=\"content-image\" src=\"https://pic1.zhimg.com/v2-6fbf05810514906af2832bfbf294fd82_720w.jpg?source=8673f162\" alt=\"\"></figure><p>而肌肉细胞是含有线粒体最多的细胞种类，比如心肌细胞（心脏砰砰跳动需要能量是极多的），以及经常需要收缩供应能量的骨骼肌。</p>\r\n<p>所以为什么我们感觉运动员不太怕冷，比如在大冷天踢球的运动员即使休息的时候也比一般人耐寒。他们发达的肌肉正如他们身体内天然的「供暖系统」。</p>\r\n<figure><img class=\"content-image\" src=\"https://pic1.zhimg.com/v2-871f908cc8fec7050537c20a636bc38a_720w.jpg?source=8673f162\" alt=\"\"><figcaption>肌束间那个亮蓝色长条状的物质就是线粒体，数量非常非常多，而且是可以「锻炼出来」的。也就是用的越多，线粒体会更多。</figcaption></figure><p><strong>棕色脂肪也能生热——这是女生「保暖」更简单的思路</strong></p>\r\n<p>与上面肌肉细胞束惨烈的对比是「白色脂肪细胞」，也就是我们游泳圈和皮下大多数的脂肪。它们的作用不是发动机而是粮仓。</p>\r\n<p>而没有人会在粮仓里装上发动机，身体也不会。所以可想而知，如果你身体 30% 是这类脂肪组成的话，就相当于冬天你买了 1000 度电存在电卡里，但是不开空调，仅仅盖棉被——能不冷吗？</p>\r\n<figure><img class=\"content-image\" src=\"https://pic4.zhimg.com/v2-e243bff4ce6823669b64e20598bdde67_720w.jpg?source=8673f162\" alt=\"\"><figcaption>这是白色脂肪细胞，线粒体很少，因为脂肪细胞不是平时供能的主体（棕色脂肪细胞除外）。</figcaption></figure><p>因此对于这种情况并不是没救了，而是需要把这部分粮仓转变成「发动型粮仓」——棕色脂肪。这个在婴儿体内特别多，所以婴儿身上总是暖呼呼的，哪怕他们根本跟「肌肉发达」不沾边。</p>\r\n<p>所以婴儿和幼童身上暖呼呼，中医认为是「阳气足」，细胞生物学很简单能用「棕色脂肪」比例高来清晰解释。</p>\r\n<figure><img class=\"content-image\" src=\"https://pic1.zhimg.com/v2-e81a662683942f2a462c69f12aeae0a4_720w.jpg?source=8673f162\" alt=\"\"><figcaption>红色的就是线粒体，左边是白色粮仓（白色脂肪细胞）；而右边是棕色发动机型粮仓（棕色脂肪细胞），可以看到其中的线粒体数量巨大的差异</figcaption></figure><p><strong>我该怎么做才能提高「保暖力」？</strong></p>\r\n<p><strong>对，这里提到的是「保暖力」而不是「肌肉量」，否则就变成了增肌攻略。</strong></p>\r\n<p>主要原因是增肌对女性来说非常困难，但是方法又相对固定（力量训练 + 充足优质蛋白质 + 不过于低的能量），所以没什么太多玄机。</p>\r\n<p><strong>而「保暖力」不一样，它不仅仅跟肌肉量有关，还跟我们上文提及的「棕色脂肪」相关。</strong>所以女生冬天手脚冰凉的解决办法除了增加身体肌肉量之外，还可以从提高「棕色脂肪」含量下手。</p>\r\n<ul><li><strong>耐寒锻炼可以增加棕色脂肪</strong><sup>[1]</sup>：高纬度地区的人自带更多棕色脂肪；这也能解释为什么有的人认为常常洗冷水澡可以锻炼耐寒能力——这是可行的。但是至于要不要用这种方法，真的见仁见智，此处不做过多评论。</li>\r\n</ul><ul><li><strong>锻炼</strong>——但并不仅仅限于肌肉训练<sup>[2]</sup>。这里很多人会觉得锻炼当然能保暖，因为锻炼本身不就产生热量（肌肉耗能），而且锻炼能增加肌肉呀！这里我要说的通路不是这一条，而是说锻炼本身就能增加「白色脂肪细胞」向「棕色脂肪细胞」转化的过程。</li>\r\n</ul><p>这个过程与一种叫 irisin（鸢尾素）的蛋白质相关。</p>\r\n<figure><img class=\"content-image\" src=\"https://pic2.zhimg.com/v2-ed5a9a5af6f7912805eedd97f41aa7b0_720w.jpg?source=8673f162\" alt=\"\"><figcaption>这个过程是独立于「运动生热」以及「增肌生热」的，所以不要认为只有增加肌肉和出汗的运动才有效，只要是运动耗能都能启动这个趋势。</figcaption></figure><ul><li><strong>改变饮食模式——通过激活 SIRT1 通路进行。（绝不是单纯多吃肉）</strong></li>\r\n</ul><p><strong>简单来说就是进行低碳水，中高脂肪，中等蛋白质的饮食模式（低碳水或者生酮模式</strong>）<sup>[3]</sup>。蛋白质本身近 30% 的「生热效应」就不多说了，这个是食物生热带来的热，与身体本身产热能力关系不大，且不适用于这类本身肌肉少人的长期用来保暖（总不可能到了冬天就拼命吃肉？）。</p>\r\n<p>而这个改变饮食模式的原理完全不一样，它是通过模拟热量限制从而激活 SIRT1 这个著名的通路，来增加「糖异生」的倾向。而「糖异生」本身就意味着需要通过消耗脂肪来变成葡萄糖，所以更多的棕色脂肪会参与进来——这不就顺带保暖了？</p>\r\n<figure><img class=\"content-image\" src=\"https://pic1.zhimg.com/v2-f260d6a16bdfd5d3e06f4667604ba374_720w.jpg?source=8673f162\" alt=\"\"><figcaption>图片来源 https://diabetes.diabetesjournals.org/content/64/7/2369 ，一篇专门讲棕色脂肪形成机制的文章，非常有意思</figcaption></figure><p>当然，这里并不是让怕冷的人去无端进行低碳水乃至生酮饮食。而仅仅是提供了一个思路，可以帮助那些肌肉量很少，而体脂高的人群借用饮食 + 运动的方法双管齐下来改善这个难题。</p>\r\n<hr><p>初夏之菡——中国 / 澳洲注册营养师，悉尼大学营养学硕士。做有态度的营养科学。</p>\n</div>\n</div>\n\n\n<div class=\"view-more\"><a href=\"https://www.zhihu.com/question/311223084\">查看知乎讨论<span class=\"js-question-holder\"></span></a></div>\n\n</div>\n\n\n</div>\n</div><script type=“text/javascript”>window.daily=true</script>"
*/
