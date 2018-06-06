//
//  LogisticsViewController.m
//  TBWLDemo
//
//  Created by 张鹏 on 2018/5/28.
//  Copyright © 2018年 c4ibD3. All rights reserved.
//

#import "LogisticsViewController.h"
#import "MaskView.h"
#import "RouteAnnotation.h"
@interface LogisticsViewController ()
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *topToolView;
@property (weak, nonatomic) IBOutlet LogisticeTableView *tableView;


@property (nonatomic,strong) BMKRouteSearch *routeSearch;


//滑动的时候的maskView
@property (nonatomic, strong) MaskView *maskView;

@end

@implementation LogisticsViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0);
    //遮罩视图
    self.maskView = [[MaskView alloc]initWithFrame:self.view.bounds];
    self.maskView.backgroundColor = [UIColor colorWithRed:115/255.0 green:115/255.0 blue:115/255.0 alpha:1];
    self.maskView.alpha = 0;
    [self.view insertSubview:self.maskView aboveSubview:self.mapView];
    
    
    //划线
//    NSMutableArray *nodeArray = [NSMutableArray array];
    self.routeSearch = [[BMKRouteSearch alloc]init];
    self.routeSearch.delegate = self;
    BMKPlanNode *startNode = [[BMKPlanNode alloc]init];
    startNode.pt = CLLocationCoordinate2DMake(39.7804439496,116.4617176879);
    BMKPlanNode *endNode = [[BMKPlanNode alloc]init];
    endNode.pt = CLLocationCoordinate2DMake(22.5485544122,114.0661345267);
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = startNode;
    drivingRouteSearchOption.to = endNode;
    drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;
    BOOL flag = [self.routeSearch drivingSearch:drivingRouteSearchOption];
    if (flag ) {
        NSLog(@"car检索发送成功");
    }else{
        NSLog(@"car检索发送失败");
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.maskView.alpha = (1 - (scrollView.contentOffset.y*-1/300));
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)popAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - BMKRouteSearchDelegate
- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"onGetDrivingRouteResult error:%d", (int)error);
    if (error == BMK_SEARCH_NO_ERROR) {
        //成功获取结果
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
//            //添加annotation节点
//            RouteAnnotation* item = [[RouteAnnotation alloc]init];
//            item.coordinate = transitStep.entrace.location;
//            item.title = transitStep.entraceInstruction;
//            item.degree = transitStep.direction * 30;
//            item.type = 4;
//            [_mapView addAnnotation:item];
            
            NSLog(@"%@   %@    %@", transitStep.entraceInstruction, transitStep.exitInstruction, transitStep.instruction);
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    } else {
        //检索失败
    }
}
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [UIColor redColor];
        polylineView.lineWidth = 2.0;
        return polylineView;
    }
    return nil;
}
#pragma mark - 私有
//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x;
    ltY = pt.y;
    rbX = pt.x;
    rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX, ltY);
    rect.size = BMKMapSizeMake((rbX - ltX),(rbY - ltY));
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 2;
}

@end
