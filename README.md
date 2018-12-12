# TBWLDemo
淘宝物流
# 大厂样例
## 1 淘宝物流界面
![](https://user-gold-cdn.xitu.io/2018/6/6/163d3b1f46dc1290?w=381&h=749&f=gif&s=3128949)
## 2 滴滴
![](https://user-gold-cdn.xitu.io/2018/6/6/163d3b5ed5dbe50e?w=381&h=749&f=gif&s=3020508)
## 3 自己写的
![](https://user-gold-cdn.xitu.io/2018/6/6/163d3b7083364748?w=679&h=747&f=gif&s=1706265)

# 起源
淘宝对于我来说，已经好久没有去过这个物流的界面了，因为我根本就不关心。在我印象里面，这个界面还是那种根据接口返回的物流信息做界面展示。  
那天，有一个朋友突然问我：“你知道淘宝的那个物流界面是怎么做的吗？”  看了之后我觉得挺神奇的。 我以为上面的地图是做tableView的headerView。我朋友告诉我不是。可能是因为觉得回答的不是很好，我就敷衍的说:"你们有这个需求了啊？"是他同事做的项目有这个需求。之后这个事情就不了了之了.......    
大概是三天后吧，他和我说，那个界面快做出来了，那个同事在google上找到了这么一个demo，然后我就结果来看了一下。基本上差不多。然后我就开始写了这么一个小样例。  
目的并不是炫耀什么，我估计很多人也都会，所以希望，不喜勿喷.......

# The key of problem
我在看过那个demo之后，关键的就是判断点击的是那个视图。`- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;`
# 相关知识链接
1. [iOS 知识小集第 15 期 · 掘金首发](https://juejin.im/post/5b134cb85188251374789109n)  
2. [对UIView的hitTest: withEvent: 方法的理解](https://blog.csdn.net/mushaofeng1990/article/details/62434349)  
3. [点击事件处理, 以及hitTest:withEvent:实现](https://www.jianshu.com/p/ef83a798121c) 
# 行动起来
我的那个demo的结构也是很简单的。  
首先，我们做了一个一整个屏幕大小的MapView；
然后，添加一个tableView,也是整个屏幕的大小，然后对`contentInset`做了这设置；  
这样界面的布局就完事儿了。  
接下来就是实现那个方法的问题了，我自定义了一个tableView，然后在那里面实现了这个方法  

```
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [super hitTest:point withEvent:event];
    if (point.y<0) {
        return nil;
    }
    return hitView;
}
```
这样 地图和tableView的滑动问题就都解决了

# 依旧有个不解之谜，求大神指点
淘宝那个地图路线那个，始终都会在上面显示出来，而我的这个demo现实的一直都是在整个mapview的中心，而且滑动的时候，也可以跟随华东的偏移量做相应的调整，有大神知道的欢迎来知道小弟。
