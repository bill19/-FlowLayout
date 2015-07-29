//
//  ViewController.m
//  自定义的FlowLayout
//
//  Created by vera on 15/7/28.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import "CustomLayout.h"
#import "Cell.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *array;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
     自定义瀑布流需要重写父类的4个方法：
     1.- (void)prepareLayout;
     2.- (CGSize)collectionViewContentSize;
     3.- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect; // return an array layout attributes instances for all the views in the given rect
     4.- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
     */
    
    
    
    array = [NSMutableArray array];
    
    for (int i = 0; i < 50; i++)
    {
        Model *m = [[Model alloc] init];
        m.w = arc4random()%100 + 100;
        m.h = arc4random()%100 + 200;
        
        //添加到数组中
        [array addObject:m];
    }
    
    /**
     自定义瀑布流
     */
    CustomLayout *layout = [[CustomLayout alloc] init];
    //layout.datasourceArray = array;
    layout.sectionInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    //layout.columnSpace = 20;
    layout.columnCount = 2;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = [UIColor whiteColor];
    
    //注册
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [collectionView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];

}

//代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return array.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

//返回item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Model *m = array[indexPath.item];
    
    return CGSizeMake(m.w, m.h);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
